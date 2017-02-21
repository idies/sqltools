declare @sql nvarchar(max)
declare @tablename sysname
declare @indexname sysname


declare cur cursor for
SELECT
            so.name AS TableName
            , si.name AS IndexName
           , si.type_desc AS IndexType
			, si.type
			, sf.name
FROM
            sys.indexes si
            JOIN sys.objects so ON si.[object_id] = so.[object_id]
			join sys.filegroups sf on sf.[data_space_id] = si.data_space_id
WHERE
            so.type = 'U'    --Only get indexes for User Created Tables
            AND si.name IS NOT NULL
			and si.type = 1
			and sf.name = 'PRIMARY'
ORDER BY
            so.name, si.type
			
open cur
fetch next from cur into @tablename, @indexname
while (@@FETCH_STATUS = 0)
begin
	set @sql = 
	'create clustered columnstore index ['+@indexname+']
on ['+@tablename+']
with drop_existing on [OTHER_CCI] 

'
	
	print @sql

	fetch next from cur into @tablename, @indexname

	--exec sp_executesql @sql
end

close cur
deallocate cur 
