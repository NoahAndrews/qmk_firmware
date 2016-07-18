@SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
@ECHO OFF
SET CMDLINERUNSTR=%SystemRoot%\system32\cmd.exe

SET LOGDIR=%CD%\log\1-setup-path-win
MKDIR %LOGDIR% 2> NUL

DEL %LOGDIR%\path-setup.log > NUL 2>&1
DEL %LOGDIR%\add-paths.log > NUL 2>&1
DEL %LOGDIR%\add-paths-detail.log > NUL 2>&1
DEL UPDATE > NUL 2>&1

ELEVATE -wait add-paths.bat >> %LOGDIR%\path-setup.log 2>&1

IF ERRORLEVEL 1 (
	ECHO.
	ECHO Something went wrong when obtaining admin access. Rerun the script, and be sure to press the yes button this time.
	ECHO.
	ECHO If that doesn't work, make a new post at reddit.com/r/olkb and include the contents of the files in log\1-setup-path-win\
) ELSE (
	IF EXIST %LOGDIR%\add-paths.log (
		TYPE %LOGDIR%\add-paths.log
		DEL %LOGDIR%\add-paths.log
	) ELSE (
		ECHO add-paths.bat did not run properly. Make a new post at reddit.com/r/olkb to get help.
	)
)
ECHO.

:: Branch to UpdateEnv if we need to update
IF EXIST UPDATE (
	DEL UPDATE
	GOTO UpdateEnv
)

GOTO ExitBatch

:: -----------------------------------------------------------------------------

:UpdateEnv
ECHO Making updated PATH go live . . .
REG delete HKCU\Environment /F /V TEMPVAR > NUL 2>&1
setx TEMPVAR 1 > NUL
REG delete HKCU\Environment /F /V TEMPVAR > NUL 2>&1
IF NOT !cmdcmdline! == !CMDLINERUNSTR! (CALL :KillExplorer)
GOTO ExitBatch

:: -----------------------------------------------------------------------------

:ExitBatch
ENDLOCAL
PAUSE
EXIT /b

:: -----------------------------------------------------------------------------

:KillExplorer
ECHO.
ECHO.
ECHO Your desktop will be restarted. 
ECHO.
ECHO All file explorer windows except for the one you launched this script from WILL BE CLOSED.
ECHO.
ECHO Press enter when ready, or close this window if you would rather do a full restart of your computer at a later time.
ECHO.
PAUSE
ping -n 5 127.0.0.1 > NUL 2>&1
ECHO Killing process Explorer.exe. . . 
ECHO.  
taskkill /f /im explorer.exe > NUL
ECHO.   
ECHO Your desktop is now loading. . . 
ECHO.   
ping -n 5 127.0.0.1 > NUL 2>&1
START explorer.exe
START explorer.exe %CD%
EXIT /b