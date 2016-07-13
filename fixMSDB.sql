ALTER TABLE [dbo].[sysmaintplan_log] DROP CONSTRAINT [FK_sysmaintplan_log_subplan_id];

ALTER TABLE [dbo].[sysmaintplan_logdetail] DROP CONSTRAINT [FK_sysmaintplan_log_detail_task_id];

truncate table msdb.dbo.sysmaintplan_logdetail;

truncate table msdb.dbo.sysmaintplan_log;

ALTER TABLE [dbo].[sysmaintplan_log] WITH CHECK ADD CONSTRAINT [FK_sysmaintplan_log_subplan_id] FOREIGN KEY([subplan_id])
REFERENCES [dbo].[sysmaintplan_subplans] ([subplan_id]);

ALTER TABLE [dbo].[sysmaintplan_logdetail] WITH CHECK ADD CONSTRAINT [FK_sysmaintplan_log_detail_task_id] FOREIGN KEY([task_detail_id])
REFERENCES [dbo].[sysmaintplan_log] ([task_detail_id]) ON DELETE CASCADE;



--- SHRINK THE MSDB LOG FILE

USE MSDB

GO

DBCC SHRINKFILE(MSDBLog, 512)

GO

 

-- SHRINK THE MSDB Data File

USE MSDB

GO

DBCC SHRINKFILE(MSDBData, 1024)

GO


-- REBUILD ALL INDEXES

USE MSDB

GO

EXEC sp_MSforeachtable @command1="print ‘?’ DBCC DBREINDEX (‘?’, ‘ ‘, 80)"

GO

--UPDATE STATISTICS

EXEC sp_updatestats

EXEC sp_helpdb @dbname='MSDB'