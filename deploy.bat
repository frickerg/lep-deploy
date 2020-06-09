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

:: stop all forever daemons
call forever stopall

:: kill all node tasks for good measure
taskkill /f /im node.exe

:: elevate to admin
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || ( echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

:: save installation path for later
set INSTALL_PATH=C:\LEP\lep-demonstrator
cd %INSTALL_PATH%

:: turn off angular analytics
call ng analytics off

:: checks for arguments 'dev' or 'prod'
:: if no arguments are given, the script will cancel
if [%1]==[] goto:cancel

echo 1) INSTALLING PACKAGES

:: remove any remaining modules
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
if %1 == prod (
	:: create installer for 'prod'
	call npm run installer:%1 || goto:cancel
) else (
	echo INFO: no need to create installer for %1
)

:: start the lepdemo daemon
call forever start --uid "lepdemo" -c "npm run start:secure_server" -a ./
goto:end

:cancel
:: if anything goes wrong, the script will cancel here
echo ERROR!
echo the environment was not set correctly
echo check the process for %1 in your CI script!
exit /b -1

:end
if %ERRORLEVEL% NEQ 0 (
	echo ERROR: Encountered fatal error while deploying.
)
exit /b
