SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================

-- = Author:		<Dan Holmes>
-- = Create date:	<13/03/2021>
-- = Description:	<Inf - Backup all databases
-- =				
-- = UPDATE HISTORY        
-- =	13/03/2021	Dan Holmes - Sproc created
-- =

-- =============================================
	ALTER PROCEDURE [dbo].[spExecBackupAllDBs]
		@path	VARCHAR(256)	= NULL

	AS
	BEGIN
		--SET NOCOUNT ON;
		IF @path IS NOT NULL
		BEGIN
			DECLARE @name VARCHAR(50) -- database name  
			DECLARE @fileName VARCHAR(256) -- filename for backup  
			DECLARE @fileDate VARCHAR(20) -- used for file name
 
			-- specify filename format
			SELECT @fileDate = LEFT(DATENAME(WEEKDAY,GETDATE()),3)
 
			DECLARE db_cursor CURSOR READ_ONLY FOR  
			SELECT name 
			FROM master.sys.databases 
			WHERE name NOT IN ('tempdb')  -- exclude these databases
			AND state = 0 -- database is online
			AND is_in_standby = 0 -- database is not read only for log shipping
 
			OPEN db_cursor   
			FETCH NEXT FROM db_cursor INTO @name   
 
			WHILE @@FETCH_STATUS = 0   
			BEGIN   
			   SET @fileName = @path + @fileDate + '-' + @name +'-' + @@SERVICENAME + '.bak'  
			   BACKUP DATABASE @name TO DISK = @fileName  
 
			   FETCH NEXT FROM db_cursor INTO @name   
			END   

 
			CLOSE db_cursor   
			DEALLOCATE db_cursor
		END
END
