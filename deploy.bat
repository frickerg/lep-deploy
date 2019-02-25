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

FOR /L %%n in (1,1,16) DO (
    call :spinner
    sleep 0.1
)

cd ../
IF EXIST lep-backend (
    del /f /s /q lep-backend 1>nul
    rmdir /s /q lep-backend
)

printf "1) CLONING FROM REPOSITORY\n\n"

sleep 1
git clone git@gitlab.ti.bfh.ch:fricg2/lep-backend.git
cd lep-backend

sleep 1
printf "\n2) BUILDING PACKAGES\n\n"

sleep 1
call npm install
GOTO:End

:spinner
set /a "spinner=(spinner + 1) %% 4"
set "spinChars=\|/-"
<nul set /p ".=Loading... !spinChars:~%spinner%,1!!CR!"
exit /b

:End
PAUSE