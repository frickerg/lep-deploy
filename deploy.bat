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
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do (
	@echo(%%A
)

if [%1]==[] goto:cancel

cd ..
if not exist lep-demonstrator (
	call git clone git@gitlab.ti.bfh.ch:fricg2/lep-demonstrator.git
)

echo 1) RETRIEVING LATEST VERSION FROM REPOSITORY

cd lep-demonstrator
call git reset --hard
call git fetch --all
if %1 == prod (
	set BRANCH="master"
) else if %1 == dev (
	set BRANCH="develop"
) else if %1 == test (
	set BRANCH="testing"
	%1 = dev
) else (
	goto:cancel
)
call git checkout %BRANCH%
call git reset --hard origin/%BRANCH%
call git status

echo 2) INSTALLING PACKAGES

if exist build rmdir /s /q build
if exist node_modules rmdir /s /q node_modules

call npm install || exit /b -1

echo 3) BUILDING SOURCE CODE
call npm run build:%1 || exit /b -1

echo 4) PACKAGING WINDOWS EXECUTABLE
call npm run package:%1 || exit /b -1

echo 5) CREATING INSTALLER
call npm run installer:%1 || exit /b -1
goto:end

:cancel
echo ERROR!
echo The environment was not set correctly
echo Check the parameter for %0 in your CI script!
exit /b -1

:spinner
set /a "spinner=(spinner + 1) %% 4"
set "spinChars=\|/-"
<nul set /p ".=Loading... !spinChars:~%spinner%,1!!CR!"
exit /b

:end
if %ERRORLEVEL% NEQ 0 (
	echo ERROR: Encountered fatal error while deploying.
)
exit /b
