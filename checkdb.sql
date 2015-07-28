
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[spCheckDBIntegrity]
@database_name SYSNAME=NULL,
@physical_only bit=1 --run physical_only by default
AS

	declare @clause varchar(30)
	if @physical_only = 1 
		set @clause = ' ,physical_only'
	else
		set @clause = ''
		
	
	IF @database_name IS NULL -- Run against all databases
	BEGIN
		DECLARE database_cursor CURSOR FOR
		SELECT name 
		FROM sys.databases db
		WHERE name NOT IN ('master','model','msdb','tempdb') 
		AND db.state_desc = 'ONLINE'
		AND source_database_id IS NULL -- REAL DBS ONLY (Not Snapshots)
		AND is_read_only = 0

		OPEN database_cursor
		FETCH next FROM database_cursor INTO @database_name
		WHILE @@FETCH_STATUS=0
		BEGIN

INSERT INTO dbcc_history ([Error], [Level], [State], MessageText, RepairLevel, [Status], 
[DbId], Id, IndId, PartitionId, AllocUnitId, [File], Page, Slot, RefFile, RefPage, 
RefSlot,Allocation)
EXEC ('dbcc checkdb(''' + @database_name + ''') with tableresults'+@clause)

FETCH next FROM database_cursor INTO @database_name
END

CLOSE database_cursor
DEALLOCATE database_cursor
END 

ELSE -- run against a specified database (ie: usp_CheckDBIntegrity 'DB Name Here'

INSERT INTO dbcc_history ([Error], [Level], [State], MessageText, RepairLevel, [Status], 
[DbId], Id, IndId, PartitionId, AllocUnitId, [File], Page, Slot, RefFile, RefPage, RefSlot,Allocation)
EXEC ('dbcc checkdb(''' + @database_name + ''') with tableresults'+@clause)
GO