@SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
@ECHO off

CD %~dp0

SET LOGDIR=%CD%\log\1-setup-path-win

SET NEWPATH1="C:\MinGW\msys\1.0\bin"
SET NEWPATH2="C:\MinGW\bin"
SET NEWPATH3="C:\Program Files (x86)\MHV AVR Tools\bin"
SET NEWPATH4="C:\Windows"
SET NEWPATH5="C:\Windows\system32"

ECHO. > %LOGDIR%\add-paths.log

CALL :AddPath %NEWPATH1%
CALL :AddPath %NEWPATH2%
CALL :AddPath %NEWPATH3%
CALL :AddPath %NEWPATH4%
CALL :AddPath %NEWPATH5%

EXIT /b

:AddPath <pathToAdd>
ECHO %PATH% | FINDSTR /C:"%~1" > nul
IF ERRORLEVEL 1 (
	 REG add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /f /v PATH /t REG_SZ /d "%PATH%;%~1" >> %LOGDIR%\add-paths-detail.log
	IF ERRORLEVEL 0 (
		ECHO Adding   %1 . . . Success! >> %LOGDIR%\add-paths.log
		SET "PATH=%PATH%;%~1"
		COPY NUL UPDATE
	) ELSE (
		ECHO Adding   %1 . . . FAILED. Run this script with administrator privileges. >> %LOGDIR%\add-paths.log
	)	
) ELSE (
	ECHO Skipping %1 - Already in PATH >> %LOGDIR%\add-paths.log
	)
EXIT /b