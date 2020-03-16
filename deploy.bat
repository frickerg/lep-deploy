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

cd ..
:: clone the repository if it doesn't exist
if not exist lep-demonstrator (
	call git clone git@gitlab.ti.bfh.ch:fricg2/lep-demonstrator.git
)

echo 1) RETRIEVING LATEST VERSION FROM REPOSITORY
cd lep-demonstrator

:: hard reset and fetch on all branches
call git reset --hard
call git fetch --all

:: if the first argument is 'prod', lep-deploy will use the master branch
:: if the first argument is 'dev', lep-deploy will use the develop branch
if %1 == prod (
	set BRANCH="master"
) else if %1 == dev (
	set BRANCH="develop"
) else (
	goto:cancel
)

:: checkout current branch and reset repo to that branch
call git checkout %BRANCH%
call git reset --hard origin/%BRANCH%
call git status

echo 2) INSTALLING PACKAGES

:: remove any remaining builds or modules
if exist build rmdir /s /q build
if exist node_modules rmdir /s /q node_modules

:: install all npm packages
call npm install || goto:cancel

echo 3) BUILDING SOURCE CODE
:: build 'dev' or 'prod'
call npm run build:%1 || goto:cancel

echo 4) PACKAGING WINDOWS EXECUTABLE
:: package 'dev' or 'prod'
call npm run package:%1 || goto:cancel

echo 5) CREATING INSTALLER
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
