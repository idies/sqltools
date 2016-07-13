SELECT     
DB_NAME(db.database_id) DatabaseName,     
(CAST(mfrows.RowSize AS FLOAT)*8)/1024000000 DBSizeTB,     
(CAST(mflog.LogSize AS FLOAT)*8)/1024 LogSizeMB, 
(CAST(mfrows.RowSize AS FLOAT)*8)/1024/1024+(CAST(mflog.LogSize AS FLOAT)*8)/1024/1024 DBSizeG,
(CAST(mfstream.StreamSize AS FLOAT)*8)/1024 StreamSizeMB,     
(CAST(mftext.TextIndexSize AS FLOAT)*8)/1024 TextIndexSizeMB 
FROM sys.databases db     
LEFT JOIN (SELECT database_id, 
                  SUM(size) RowSize 
            FROM sys.master_files 
            WHERE type = 0 
            GROUP BY database_id, type) mfrows 
    ON mfrows.database_id = db.database_id     
LEFT JOIN (SELECT database_id, 
                  SUM(size) LogSize 
            FROM sys.master_files 
            WHERE type = 1 
            GROUP BY database_id, type) mflog 
    ON mflog.database_id = db.database_id     
LEFT JOIN (SELECT database_id, 
                  SUM(size) StreamSize 
                  FROM sys.master_files 
                  WHERE type = 2 
                  GROUP BY database_id, type) mfstream 
    ON mfstream.database_id = db.database_id     
LEFT JOIN (SELECT database_id, 
                  SUM(size) TextIndexSize 
                  FROM sys.master_files 
                  WHERE type = 4 
                  GROUP BY database_id, type) mftext 
    ON mftext.database_id = db.database_id 
    
    --where db.database_id > 4 and name like 'BESTDR%'
	where db.database_id > 4 and name like 'twomass%'
	order by 4 desc