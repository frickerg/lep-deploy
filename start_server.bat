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

:: check if forever has been installed. If not, install it globally.
:: latest version (>= 2.0.0) can be used if tested accordingly!
call npm list -g forever@2.0.0 || npm install -g forever@2.0.0

:: save deploy path for later
set PROJECT_PATH=C:\LEP\lep-demonstrator
cd %PROJECT_PATH%

:: stop all forever daemons
call forever stopall

:: kill all node tasks for good measure
taskkill /f /im node.exe

:: start the lepdemo daemon
call forever start --uid "lepdemo" -c "npm run start:secure_server" -a ./

:: byebye
exit
