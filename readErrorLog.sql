


Declare @InstanceName nvarchar(4000),
        @LogType int,
        @ArchiveID int,
        @Filter1Text nvarchar(4000),
        @Filter2Text nvarchar(4000),
        @FirstEntry datetime,
        @LastEntry datetime,
		@order nvarchar(10)

Select  @InstanceName=NULL,          -- Don't know 
        @LogType = 1,                -- File Type (1 = ERRORLOG OR 2 = SQLAgent)
        @ArchiveID=0,                -- File Extension (0 = Current i.e. ERRORLOG or SQLAgent.out, 1 = ERRORLOG.1 or SQLAgent.1 and so on)
        @Filter1Text=NULL,      -- First Text Filter
        @Filter2Text=NULL,           -- Second Text Filter
        @FirstEntry=NULL,            -- Start Date
        @LastEntry=NULL,              -- End Date
		@order='desc'                 -- sort order (asc or desc)

EXEC lumberjack.master.dbo.xp_readerrorlog @ArchiveID, @LogType, @Filter1Text, @Filter2Text, @FirstEntry, @LastEntry, @order, @InstanceName 