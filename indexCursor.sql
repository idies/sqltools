/*
drop table IndexInfo

create table IndexInfo(
	pk int identity(1,1),
	TableName sysname null, 
	IndexName sysname null,
	IndexID int null,
	IndexType sysname null,
	IndexSql nvarchar(4000) null,
	sourceFG sysname null,
	destFG sysname null,
	IndexStatus int default 0, 0-pending 1-in progress 2-done 3-dropped
	constraint pk_indexinfo primary key clustered (pk)
	)

*/

--1 drop all NCI's
declare @TableName sysname
declare @IndexName sysname
declare @sql nvarchar(4000)
declare @pk int

declare cur cursor for
select TableName, IndexName, pk from SueDB.dbo.IndexInfo
where IndexID > 1
--and IndexStatus <> 3 --3=dropped

open cur
fetch next from cur
into @TableName, @IndexName, @pk

while (@@FETCH_STATUS=0) begin

set @sql = 'IF (EXISTS(SELECT * FROM sys.indexes WHERE object_id = object_id(''dbo.'+@TableName+''') AND NAME ='''+@indexname+'''))
    DROP INDEX ['+@tablename+'].['+@IndexName+']'
	--set @sql = 'DROP INDEX ['+@tablename+'].['+@IndexName+']'
	print @sql
	
	exec sp_executesql @sql 

	update suedb.dbo.indexinfo
	set indexStatus = 3
	where pk=@pk

	fetch next from cur
	into @tableName, @indexName, @pk
end

close cur
deallocate cur

--2 move CI's

declare cur cursor for
select tableName, indexName, indexSQL, pk
from sueDB.dbo.indexinfo
where indexID = 1
and indexStatus <> 2


open cur
fetch next from cur into 
@tableName, @indexName, @sql, @pk

while(@@FETCH_STATUS = 0)
begin
	
	update sueDB.dbo.IndexInfo
	set IndexStatus = 1 --in progress
	where pk = @pk

	print @sql
	print @pk 
	
	exec sp_executesql @sql

	update sueDB.dbo.IndexInfo
	set IndexStatus = 2 --done
	where pk = @pk
	
	print '----'
	

	fetch next from cur into @tablename, @indexname, @sql, @pk
end

close cur
deallocate cur

--3 create NCIs

declare cur cursor for
select TableName, IndexName, IndexSQL, pk from SueDB.dbo.IndexInfo
where IndexID > 1
and IndexStatus <> 2

open cur
fetch next from cur
into @TableName, @IndexName, @sql, @pk

while (@@FETCH_STATUS=0) begin

	
		update sueDB.dbo.IndexInfo
	set IndexStatus = 1 --in progress
	where pk = @pk

	print @sql
	print @pk 
	
	exec sp_executesql @sql

	update sueDB.dbo.IndexInfo
	set IndexStatus = 2 --done
	where pk = @pk

	print '----'

	fetch next from cur
	into @tableName, @indexName, @sql, @pk
end

close cur
deallocate cur





