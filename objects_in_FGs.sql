-- The following two queries return information about 
-- which objects belongs to which filegroup
SELECT distinct OBJECT_NAME(i.[object_id]) AS [ObjectName]
    ,i.[index_id] AS [IndexID]
    ,i.[name] AS [IndexName]
    ,i.[type_desc] AS [IndexType]
    ,i.[data_space_id] AS [DatabaseSpaceID]
    ,f.[name] AS [FileGroup]
  --  ,d.[physical_name] AS [DatabaseFileName]
	,i.type
FROM [sys].[indexes] i
INNER JOIN [sys].[filegroups] f
    ON f.[data_space_id] = i.[data_space_id]
INNER JOIN [sys].[database_files] d
    ON f.[data_space_id] = d.[data_space_id]
INNER JOIN [sys].[data_spaces] s
    ON f.[data_space_id] = s.[data_space_id]
WHERE OBJECTPROPERTY(i.[object_id], 'IsUserTable') = 1
--and i.type = 5
and f.name = 'PRIMARY'
ORDER BY OBJECT_NAME(i.[object_id])
    ,f.[name]
    ,i.[data_space_id]
GO


