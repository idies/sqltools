use bestDR14
go
---size of tables
SELECT SCH.name AS SchemaName 
      ,OBJ.name AS ObjName 
      ,OBJ.type_desc AS ObjType 
      ,INDX.name AS IndexName 
      ,INDX.type_desc AS IndexType 
      ,PART.partition_number AS PartitionNumber 
      ,PART.rows AS PartitionRows 
      ,STAT.row_count AS StatRowCount 
      ,STAT.used_page_count * 8 AS UsedSizeKB 
      ,STAT.reserved_page_count * 8 AS RevervedSizeKB
	  ,drx.common 
into suedb.dbo.dr14_uncommon
FROM sys.partitions AS PART 
     INNER JOIN sys.dm_db_partition_stats AS STAT 
         ON PART.partition_id = STAT.partition_id 
            AND PART.partition_number = STAT.partition_number 
     INNER JOIN sys.objects AS OBJ 
         ON STAT.object_id = OBJ.object_id 
     INNER JOIN sys.schemas AS SCH 
         ON OBJ.schema_id = SCH.schema_id 
     INNER JOIN sys.indexes AS INDX 
         ON STAT.object_id = INDX.object_id 
            AND STAT.index_id = INDX.index_id
	join SueDB.dbo.DRxTables drx
	on drx.tablename=OBJ.name 
where OBJ.type_desc='USER_TABLE'
and drx.common = 1
ORDER BY SCH.name 
        ,OBJ.name 
        ,INDX.name 
        ,PART.partition_number 

--sum of common / unique tables
SELECT 
		OBJ.name AS ObjName
		,f.name
      ,sum(STAT.used_page_count * 8) AS UsedSizeKB 
      ,sum(STAT.reserved_page_count * 8) AS RevervedSizeKB
	  ,sum((stat.reserved_page_count * 8) / 1000 /1000) as ReservedSizeGB
	into dr14_uncommon	   
FROM sys.partitions AS PART 
     INNER JOIN sys.dm_db_partition_stats AS STAT 
         ON PART.partition_id = STAT.partition_id 
            AND PART.partition_number = STAT.partition_number 
     INNER JOIN sys.objects AS OBJ 
         ON STAT.object_id = OBJ.object_id 
     INNER JOIN sys.schemas AS SCH 
         ON OBJ.schema_id = SCH.schema_id 
     INNER JOIN sys.indexes AS INDX 
         ON STAT.object_id = INDX.object_id 
            AND STAT.index_id = INDX.index_id
	inner join sys.filegroups f
	on f.data_space_id = indx.data_space_id
	join SueDB.dbo.DRxTables drx
	on drx.tablename=OBJ.name 
where OBJ.type_desc='USER_TABLE'
and drx.common = 0
group by OBJ.name, f.name
