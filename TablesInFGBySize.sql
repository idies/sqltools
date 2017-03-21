SELECT
FILEGROUP_NAME(AU.data_space_id) AS FileGroupName,
OBJECT_NAME(Parti.object_id) AS TableName,
ind.name AS ClusteredIndexName,
AU.total_pages/128 AS TotalTableSizeInMB,
AU.used_pages/128 AS UsedSizeInMB,
AU.data_pages/128 AS DataSizeInMB,
(AU.total_pages/128) / 12 as per12FilesMB,
((AU.total_pages/128) / 12) / 1000 as per12FilesGB

FROM sys.allocation_units AS AU
INNER JOIN sys.partitions AS Parti ON AU.container_id = CASE WHEN AU.type in(1,3) THEN Parti.hobt_id ELSE Parti.partition_id END
LEFT JOIN sys.indexes AS ind ON ind.object_id = Parti.object_id AND ind.index_id = Parti.index_id
where FILEGROUP_NAME(AU.data_space_id) = 'PRIMARY'
--where OBJECT_NAME(Parti.object_id) like '%wise%'
ORDER BY TotalTableSizeInMB DESC

