:::
::: +-------------------------------------------+
::: |                LEP-UPDATE                 |
::: +-------------------------------------------+
::: | Just checking if new builds have arrived! |
::: +-------------------------------------------+
:::

@echo off
:: prints the LEP banner
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do (
	@echo(%%A
)

:: save deploy path for later
set DEPLOY_PATH=C:\LEP\lep-deploy
cd %DEPLOY_PATH%

cd ..
:: clone the repository if it doesn't exist
if not exist lep-demonstrator (
	call git clone git@gitlab.ti.bfh.ch:fricg2/lep-demonstrator.git
	call %DEPLOY_PATH%/deploy.bat prod
	exit
)

:: change to project directory
cd lep-demonstrator

:: set flag for git ask
set GIT_ASK_YESNO=false

:: check repository
echo checking repository...
call git fetch origin
:: reset local changes
call git checkout .

:: checkout develop branch
call git checkout develop
:: check the status before calling the deployment script
call git status -uno | find /i "branch is up to date"
if errorlevel 1 (
	:: stop all forever daemons
	call forever stopall
	:: pull latest changes
	call git pull
	:: run deploy script for new build
	call %DEPLOY_PATH%/deploy.bat dev
	:: restart server
	call %DEPLOY_PATH%/start_server.bat dev
)

:: change back to deploy path
cd %DEPLOY_PATH%
