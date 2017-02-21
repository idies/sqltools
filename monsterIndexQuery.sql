SET NOCOUNT ON;

declare @tab table
(TableName sysname)

insert @tab(TableName)
SELECT
            so.name AS TableName
           -- , si.name AS IndexName
           --, si.type_desc AS IndexType
			--, si.type
			--, sf.name
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

select * from @tab

DECLARE @sql NVARCHAR(MAX);

SET @sql = N'';

;WITH src AS
(
  SELECT 
    obj = QUOTENAME(OBJECT_SCHEMA_NAME(i.[object_id]))
    + '.' + QUOTENAME(OBJECT_NAME(i.[object_id])),
    i.[object_id],
    i.index_id,
    i.name,
    uniq = CASE i.is_unique WHEN 1 THEN ' UNIQUE' ELSE '' END,
    type_desc = i.type_desc COLLATE SQL_Latin1_General_CP1_CI_AS,
    filter = CASE WHEN i.has_filter = 1 THEN ' WHERE ' + i.filter_definition ELSE '' END,
    ff = ', FILL_FACTOR = ' + CONVERT(VARCHAR(3), i.fill_factor),
    dc = CASE p.data_compression_desc WHEN 'NONE' THEN '' 
        ELSE ', DATA_COMPRESSION = ' + p.data_compression_desc END,
    dest = CASE LEFT(OBJECT_NAME(i.[object_id]), 3)
        WHEN 'ABC' THEN 'FG1'
        WHEN 'DEF' THEN 'FG2'
        ELSE 'DEFAULT'
        END
  FROM sys.indexes AS i
  INNER JOIN sys.partitions AS p
  ON i.[object_id] = p.[object_id]
  inner join @tab tt on
  object_name(i.object_id) = tt.TableName 
  AND i.index_id = p.index_id
  WHERE i.index_id > 0
  --AND OBJECT_NAME(i.object_id) IN ('list','of','tables')
 -- and object_name(i.object_id) in (
	--select TableName from @tab)
),
cols AS
(
  SELECT
    name = QUOTENAME(c.name),
    ic.key_ordinal,
    ic.[object_id],
    ic.index_id,
    sort = CASE ic.is_descending_key WHEN 1 THEN ' DESC' ELSE ' ' END,
    ic.is_included_column
  FROM sys.index_columns AS ic
  INNER JOIN sys.columns AS c
  ON ic.[object_id] = c.[object_id]
  AND ic.column_id = c.column_id
  WHERE ic.[object_id] IN (SELECT [object_id] FROM src)
)
SELECT @sql = @sql + CHAR(13) + CHAR(10) 
    + N'CREATE ' + uniq + ' ' + type_desc + ' INDEX ' + QUOTENAME(name)
    + ' ON ' + obj + '(' + STUFF((SELECT ',' + name + sort FROM cols 
        WHERE cols.object_id = src.object_id 
        AND cols.index_id = src.index_id
        AND cols.is_included_column = 0
        ORDER BY cols.key_ordinal 
        FOR XML PATH('')), 1, 1, '') + ')' 
    + COALESCE(' INCLUDE(' + STUFF((SELECT ',' + name FROM cols 
        WHERE cols.[object_id] = src.[object_id] 
        AND cols.index_id = src.index_id
        AND cols.is_included_column = 1
        ORDER BY cols.key_ordinal 
        FOR XML PATH('')), 1, 1, '') + ')', '') 
    + filter + ' WITH (DROP_EXISTING = ON' + ff + dc
    + ') ON ' + dest + ';'
  FROM src
  ORDER BY uniq DESC, type_desc;

SELECT @sql;
-- EXEC sp_executesql @sql;