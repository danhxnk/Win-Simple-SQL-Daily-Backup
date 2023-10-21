@ECHO OFF
:: Define SQL Instance, leave as %1 for default, change to dedicated, or leave as %1 and call the script the instance name as an argument.
Set Instance=%1
:: Where do you want the backup files to go?
Set BKUPFLDR=C:\SQL\Backup
:: Put your 7-Zip archive password below
Set PASSWORD=pUT tHE pASSWORD hERE!!
:: Set the following variable to the name of the DB where you applied the spExecBackupAllDBs stored procedure
Set InfDB=InfraDB


::Create Folders
IF NOT EXIST %BKUPFLDR% MD %BKUPFLDR%

::Start Error Count at 0
SET COUNT=0

::Main
CD /D %BKUPFLDR%\

IF %ERRORLEVEL% NEQ 0 SET /a COUNT=%COUNT%+1
OSQL -E -S .\%Instance% -d %InfDB% -Q "EXEC spExecBackupAllDBs @path = N'%BKUPFLDR%\'"
IF %ERRORLEVEL% NEQ 0 SET /a COUNT=%COUNT%+1

::Zip up the Backup Files
IF "%Instance%" EQU "" SET Instance=MSSQLSERVER
FOR /f %%a in ('Dir %BKUPFLDR%\*.bak /b /od') DO SET BKUPDAY=%%a
IF %ERRORLEVEL% NEQ 0 SET /a COUNT=%COUNT%+1
SET BKDAY=%BKUPDAY:~0,3%
::Zip Dailies
"C:\Program Files\7-Zip\7z.exe" a -p%PASSWORD% -mhe=on %BKUPFLDR%\%COMPUTERNAME%-%Instance%-SQLBKUP-%BKDAY%.7z -r- %BKUPFLDR%\*%Instance%*.bak
IF %ERRORLEVEL% NEQ 0 SET /a COUNT=%COUNT%+1

::Delete Local Backups if Successful
IF %COUNT% EQU 0 IF EXIST %BKUPFLDR%\*%Instance%*.bak DEL /Q %BKUPFLDR%\*%Instance%*.bak

EXIT %COUNT%