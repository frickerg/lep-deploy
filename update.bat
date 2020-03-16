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
set DEPLOY_PATH=%CD%

cd ..
:: clone the repository if it doesn't exist
if not exist lep-demonstrator (
	call git clone git@gitlab.ti.bfh.ch:fricg2/lep-demonstrator.git
)

:: change to project directory
cd lep-demonstrator

:: check repository
echo checking repository...
call git fetch origin
:: reset local changes
call git checkout .

:: loop through array of branches
set branches=develop master
(for %%b in (%branches%) do (
	:: checkout current branch
	call git checkout %%b
	:: check the status before calling the deployment script
	call git status -uno | find /i "branch is up to date"
	if errorlevel 1 (
		:: run deploy script for new build
		if %%b == master (
			call %DEPLOY_PATH%/deploy.bat prod
		) else if %%b == develop (
			call %DEPLOY_PATH%/deploy.bat dev
		)
	)
))

:: change back to deploy path
cd %DEPLOY_PATH%
