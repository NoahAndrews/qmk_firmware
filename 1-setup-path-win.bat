@SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
@ECHO OFF
SET CMDLINERUNSTR=%SystemRoot%\system32\cmd.exe

CD UTIL
ELEVATE -w -c add-paths.bat > nul 2>&1
IF ERRORLEVEL 1 (
	ECHO You denied admin access. Rerun the script, and be sure to press the yes button this time.
) ELSE (
	TYPE add-paths.log
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
REG delete HKCU\Environment /F /V TEMPVAR > nul 2>&1
setx TEMPVAR 1 > nul 2>&1
REG delete HKCU\Environment /F /V TEMPVAR > nul 2>&1
IF NOT !cmdcmdline! == !CMDLINERUNSTR! (CALL :KillExplorer)
GOTO ExitBatch

:: -----------------------------------------------------------------------------

:ExitBatch
ENDLOCAL
PAUSE
EXIT /b

:: -----------------------------------------------------------------------------

:KillExplorer

ECHO Your desktop is being restarted, please wait. . .   
ping -n 5 127.0.0.1 > NUL 2>&1   
ECHO Killing process Explorer.exe. . . 
ECHO.  
taskkill /f /im explorer.exe   
ECHO.   
ECHO Your desktop is now loading. . . 
ECHO.   
ping -n 5 127.0.0.1 > NUL 2>&1   
START explorer.exe
START explorer.exe %CD%\..
EXIT /b