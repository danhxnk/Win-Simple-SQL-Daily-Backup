# Win-Simple-SQL-Daily-Backup
 Does daily foldered backups of all SQLServer DBs on any given server. Backed up to local password protected 7-Zip archives. Keeps a rolling 7 days. Only for dev and test.

Install 7-Zip to the "C:\Program Files" folder. Anywhere else and you'll need to change the BackupSQLServer.cmd file.

Apply the spExecBackupAllDBs.sql to a DB of your choice.

Update the variables at the top of the cmd script. You can specify an instance name as an argument, leave it as default, or add it to the script.

