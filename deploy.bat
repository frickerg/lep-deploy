:::
::: +--------------------------------------------------------+
::: |   _      ______ _____    _____                         |
::: |  | |    |  ____|  __ \  |  __ \                        |
::: |  | |    | |__  | |__) | | |  | | ___ _ __ ___   ___    |
::: |  | |    |  __| |  ___/  | |  | |/ _ \ '_ ` _ \ / _ \   |
::: |  | |____| |____| |      | |__| |  __/ | | | | | (_) |  |
::: |  |______|______|_|      |_____/ \___|_| |_| |_|\___/   |
::: |                                                        |
::: |                   - DEPLOYMENT-SCRIPT -                |
::: +--------------------------------------------------------+
:::

@echo off
:: prints the LEP banner
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do (
	@echo(%%A
)

:: checks for arguments 'dev' or 'prod'
:: if no arguments are given, the script will cancel
if [%1]==[] goto:cancel

echo 1) INSTALLING PACKAGES

:: remove any remaining builds or modules
if exist build rmdir /s /q build
if exist node_modules rmdir /s /q node_modules

:: install all npm packages
call npm install || goto:cancel

echo 2) BUILDING SOURCE CODE
:: build 'dev' or 'prod'
call npm run build:%1 || goto:cancel

echo 3) PACKAGING WINDOWS EXECUTABLE
:: package 'dev' or 'prod'
call npm run package:%1 || goto:cancel

echo 4) CREATING INSTALLER
:: create installer for 'prod'
if %1 == prod (
	call npm run installer:%1 || goto:cancel
) else (
	echo No need to create installer for %1
)
goto:end

:cancel
:: if anything goes wrong, the script will cancel here
echo ERROR!
echo The environment was not set correctly
echo Check the parameter for %0 in your CI script!
exit /b -1

:end
if %ERRORLEVEL% NEQ 0 (
	echo ERROR: Encountered fatal error while deploying.
)
exit /b
