-- The following two queries return information about 
-- which objects belongs to which filegroup
--insert suedb.dbo.indexInfo (TableName, IndexName, IndexID, IndexType, sourceFG)
SELECT distinct 

OBJECT_NAME(i.[object_id]) AS [ObjectName]
    ,i.[name] AS [IndexName]
    ,i.[index_id] AS [IndexID]
    ,i.[type_desc] AS [IndexType]
    --,i.[data_space_id] AS [DatabaseSpaceID]
    ,f.[name] AS [FileGroup]
  --  ,d.[physical_name] AS [DatabaseFileName]
	--,i.type
	--into suedb.dbo.IndexPrimary

FROM [sys].[indexes] i
INNER JOIN [sys].[filegroups] f
    ON f.[data_space_id] = i.[data_space_id]
INNER JOIN [sys].[database_files] d
    ON f.[data_space_id] = d.[data_space_id]
INNER JOIN [sys].[data_spaces] s
    ON f.[data_space_id] = s.[data_space_id]
WHERE OBJECTPROPERTY(i.[object_id], 'IsUserTable') = 1
--and i.type = 5
--and i.index_id > 0
and f.name = 'PRIMARY'
ORDER BY 
--OBJECT_NAME(i.[object_id]),
f.[name]
 --   ,i.[data_space_id]
GO


update t2
--set FileGroup='DATAFG'
set compression='PAGE'

--select t1.objectName, t2.*
from suedb.dbo.IndexPrimary t1
join IndexMapFG t2
on t1.ObjectName = t2.TableName
where t2.code='K'
--and t2.indexGroup not like 'FINISH'
and t2.TableName != 'SpecObjAll'
--order by t1.ObjectName




select t1.objectName, t2.*
from suedb.dbo.IndexPrimary t1
join IndexMapFG t2
on t1.ObjectName = t2.TableName
where t2.code='K'
--and t2.indexGroup not like 'FINISH'
and t2.TableName != 'SpecObjAll'
order by t1.ObjectName



select * from suedb.dbo.indexPrimary

update IndexMapFG
set FileGroup='SPEC'
where TableName='SpecPhotoAll'
and code = 'K'

