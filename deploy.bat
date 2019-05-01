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
	sleep 0.1
)

@echo off
setlocal EnableDelayedExpansion
for /f %%a in ('copy /Z "%~dpf0" nul') do set "CR=%%a"

for /l %%n in (1,1,16) do (
	call :spinner
	sleep 0.1
)

if [%1]==[] goto:Cancel

cd ..
if not exist lep-demonstrator (
	call git clone git@gitlab.ti.bfh.ch:fricg2/lep-demonstrator.git
)

printf "\n1) RETRIEVING LATEST VERSION FROM REPOSITORY\n\n"

sleep 1
cd lep-demonstrator
if %1 == dev (
	call git checkout deployment
) else if %1 == prod (
	call git checkout deployment
) else (
	goto:Cancel
)
call git branch

sleep 1
printf "\n2) BUILDING PACKAGES\n\n"

sleep 1
call npm run cleanup:build
call npm install
call npm run package:%1
call npm run deploy:%1
goto:End

:Cancel
echo 'ERROR!'
echo 'the environment was not set correctly'
echo 'check the parameter for %0 in your CI script!'
exit /b -1

:spinner
set /a "spinner=(spinner + 1) %% 4"
set "spinChars=\|/-"
<nul set /p ".=Loading... !spinChars:~%spinner%,1!!CR!"
exit /b

:End
exit /b
