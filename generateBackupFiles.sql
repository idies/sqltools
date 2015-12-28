
-- To allow advanced options to be changed.
EXEC sp_configure 'show advanced options', 1;
GO
-- To update the currently configured value for advanced options.
RECONFIGURE;
GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1;
GO
-- To update the currently configured value for this feature.
RECONFIGURE;
GO

--14 volumes mounted on c:\data
--like c:\data\ssd0, c:\data\ssd1, etc

declare @dbname sysname;
declare @nvol int = 14  --total # volumes
declare @nStart int = 0  --index of first volume
declare @prefix nvarchar(100) = 'c:\data\ssd';  
declare @filesPerVol  int--number of files per volume (put extras at the end?)

declare @nBackupfiles int = 64 --maxium 

select @filesPerVol = @nBackupfiles / @nVol
if (@nBackupfiles % @nvol) <> 0
	set @filesPerVol = @filesPerVol + 1


declare @path nvarchar(100)

declare @clause nvarchar(max) = ''


declare @filename nvarchar(1000)
declare @v int = @nStart --volumes
declare @f int = 1 --overall number of files
declare @count int --files per volume
while (@v <= @nvol) 
begin

	set @path = @prefix + cast(@v as nvarchar) + '\'
	--create directory if it doesn't exist

	
		declare @cmd nvarchar(2000)

		set @cmd = N'mkdir ' + @path + db_name()
		--select @cmd
		exec xp_cmdshell @cmd
	
	set nocount on

	set @count = 0
	while (@count < = @filesPerVol)
	begin
		if @f > @nBackupfiles 
					BREAK;
		--do stuff per volume
		set @filename = @path + db_name() + '\' + db_name() + '.' + right('00'+cast(@f as nvarchar(2)),2) + '.bak'
		--print @filename
		set @clause = @clause + 'disk = ''' + @filename + +''''+',' + char(10)
		set @f = @f+ 1;
		set @count = @count + 1;
	
		
	end
	--move onto next volume
	set @v = @v+1
end

print @clause 

/*
disk = 'C:\data\data1\sql_db\channeldb10\channeldb10.01.bak',
disk = 'C:\data\data1\sql_db\channeldb10\channeldb10.02.bak',
*/

	
