SELECT o.[name], o.[object_id ], c.[object_id ], c.[name], t.[name]
FROM sys.all_columns c
INNER JOIN sys.all_objects o
ON c.object_id = o.object_id
INNER JOIN sys.types t
ON c.system_type_id = t.system_type_id 
inner join [sys].[indexes] i
on o.object_id = i.object_id
INNER JOIN [sys].[filegroups] f
    ON f.[data_space_id] = i.[data_space_id]
WHERE c.system_type_id IN (35, 165, 99, 34, 173)
AND o.[name] NOT LIKE 'sys%'
AND o.[name] <> 'dtproperties'
AND o.[type] = 'U'
and f.name = 'PRIMARY'
GO


exec sp_whoisactive