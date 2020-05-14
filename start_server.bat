:::
::: +---------------------------------+
::: |   LEP -FOREVER- SERVER DAEMON   |
::: +---------------------------------+
::: | This is where the fun begins... |
::: +---------------------------------+
:::

@echo off
:: prints the LEP banner
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do (
	@echo(%%A
)

:: check if forever has been installed.
:: if not, install it globally
call npm list -g forever || npm install -g forever

:: save deploy path for later
set PROJECT_PATH=C:\LEP\lep-demonstrator
cd %PROJECT_PATH%

:: stop all forever daemons
call forever stopall

:: kill all node tasks for good measure
taskkill /f /im node.exe

:: start the lepdemo daemon
call forever start --uid "lepdemo" -c "npm run start:server" -a ./

:: byebye
exit
