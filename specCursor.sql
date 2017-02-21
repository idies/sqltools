
declare @sql nvarchar(max)

declare @tablename sysname
declare @colname sysname

declare cur cursor for
SELECT      
            t.name AS 'TableName', 
			c.name as 'ColumnName'
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
WHERE       c.name LIKE '%SpecObjID%'
and c.system_type_id = 127
and t.name not like '%_bak'
ORDER BY    TableName
          


open cur
fetch next from cur into @tablename, @colname
while @@FETCH_STATUS= 0
begin

	set @sql = 'ALTER TABLE ' + @tablename + ' ALTER COLUMN ['+@colname+'] NUMERIC(20) NOT NULL'
	print @sql

	exec sp_executesql @sql

	fetch next from cur into @tablename, @colname
end
close cur
deallocate cur


--alter table PhotoObjAll alter column specobjid NUMERIC(20) NOT NULL
