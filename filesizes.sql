IF Object_ID('TempDB..##FileSize') IS NOT NULL BEGIN
    DROP TABLE ##FileSize
END

CREATE TABLE ##FileSize
(      DB VarChar(128)
    , FileLogicalName VarChar(128)
    , FilePhysicalName VarChar(512)
    , FileGroup VarChar(128)
    , Used_MB VarChar(128)
    , Free_MB VarChar(128)
    , Size_MB VarChar(128)
    , GrowthRate VarChar(128)
    , MaxSize VarChar(128)
)

declare @sql nvarchar(max)

 
set @sql=
--sp_MSforeachdb N'use [?]; 

'INSERT INTO ##FileSize
SELECT DB = db_name()
    , FileLogicalName = f.name
    , FilePhysicalName = f.physical_name
    , FileGroup = ISNULL(g.name, f.Type_Desc) 
    , Used_MB = REPLACE(CONVERT(varchar(100), (CAST((FileProperty(f.name, ''SpaceUsed'')) / 128 AS money)), 1), ''.00'', '''')
    , Free_MB = REPLACE(CONVERT(varchar(100), (CAST((f.size - FileProperty(f.name, ''SpaceUsed'')) / 128 AS money)), 1), ''.00'', '''')
    , Size_MB = REPLACE(CONVERT(varchar(100), (CAST((f.size) / 128 AS money)), 1), ''.00'', '''')
    , GrowthRate = Case Is_Percent_Growth
                    WHEN 1 THEN '''' + Cast(Growth as VarChar(100)) + ''%''
                    ELSE REPLACE(CONVERT(varchar(100), (CAST(Growth/128 AS money)), 1), ''.00'', '''') + '' MB''
                    END 
    , MaxSize = Case Max_Size
                    WHEN -1 THEN ''---''
                    WHEN 268435456 THEN ''---''
                    ELSE REPLACE(CONVERT(varchar(100), (CAST(Max_Size/128 AS money)), 1), ''.00'', '''') + '' MB''
                    END
FROM sys.database_files f
    LEFT JOIN sys.filegroups g on f.data_space_id = g.data_space_id
'

exec sp_executesql @sql

SELECT *
    , PctUsed = Cast(100 * replace(Used_MB, ',', '') / (Cast(replace(Size_MB,',', '') as Dec(20,2)) + .01) as Dec(20,2))
    --, PctFree = 100 - Cast(100 * replace(Used_MB, ',', '') / (Cast(replace(Size_MB,',', '') as Dec(20,2)) + .01) as Dec(20,2))
FROM ##FileSize
--WHERE DB = 'msdb'
ORDER BY FilePhysicalName

DROP TABLE ##FileSize