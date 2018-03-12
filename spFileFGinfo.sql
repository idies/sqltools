drop procedure if exists spFileFGInfo
go

create procedure spFileFGInfo as

set nocount on 
create table #Data( 
      FileID int NOT NULL, 
      [FileGroupId] int NOT NULL, 
      TotalExtents int NOT NULL, 
      UsedExtents int NOT NULL, 
      [FileName] sysname NOT NULL, 
      [FilePath] nvarchar(MAX) NOT NULL,
      [FileGroup] varchar(MAX) NULL) 

create table #Results(
      db sysname NULL ,
      FileType varchar(4) NOT NULL, 
      [FileGroup] sysname not null,
      [FileName] sysname NOT NULL, 
      TotalMB numeric(18,2) NOT NULL, 
      UsedMB numeric(18,2) NOT NULL, 
      PctUsed numeric(18,2) NULL,
      FilePath nvarchar(MAX) NULL,
      FileID int null) 

create table #Log(
      db sysname NOT NULL, 
      LogSize numeric(18,5) NOT NULL, 
      LogUsed numeric(18,5) NOT NULL, 
      Status int NOT NULL, 
      [FilePath] nvarchar(MAX) NULL) 

INSERT #Data (FileID, [FileGroupId], TotalExtents, UsedExtents, [FileName], [FilePath])
EXEC ('DBCC showfilestats WITH NO_INFOMSGS')

update #Data 
set #Data.FileGroup = sysfilegroups.groupname 
from #Data, sysfilegroups 
where #Data.FileGroupId = sysfilegroups.groupid

INSERT INTO #Results (db, [FileGroup], FileType, [FileName], TotalMB, UsedMB, PctUsed, FilePath, FileID)
SELECT DB_NAME() db,
            [FileGroup], 
            'Data' FileType,
            [FileName], 
            TotalExtents * 64./1024. TotalMB, 
            UsedExtents *64./1024 UsedMB, 
            UsedExtents*100. /TotalExtents  UsedPct, 
            [FilePath],
            FileID 
FROM #Data
order BY --1,2
DB_NAME(), [FileGroup]

insert #Log (db,LogSize,LogUsed,Status)
exec('dbcc sqlperf(logspace) WITH NO_INFOMSGS ') 

insert #Results(db, [FileGroup], FileType, [FileName],  TotalMB,UsedMB, PctUsed, FilePath, FileID) 
select DB_NAME() db,
            'Log' [FileGroup],
            'Log' FileType,
            s.[name] [FileName],
            s.Size/128. as LogSize , 
            FILEPROPERTY(s.name,'spaceused')/8.00 /16.00 As LogUsedSpace,
            ((FILEPROPERTY(s.name,'spaceused')/8.00 /16.00)*100)/(s.Size/128.) UsedPct,
            s.FileName FilePath,
            s.FileID FileID
      from #Log l , master.dbo.sysaltfiles f , dbo.sysfiles s 
      where f.dbid = DB_ID() 
      and (s.status & 0x40) <> 0 
      and s.FileID = f.FileID
      and l.db = DB_NAME()
 
SELECT r.db AS "Database",
r.FileType AS "File type",
CASE
	WHEN r.FileGroup = 'Log' Then 'N/A'
	ELSE r.FileGroup
END "File group",
r.FileName AS "Logical file name",
r.TotalMB AS "Total size (MB)",
r.UsedMB AS "Used (MB)",
r.PctUsed AS "Used (%)",
r.FilePath AS "File name",
r.FileID AS "File ID",
CASE WHEN s.maxsize = -1 THEN null
    ELSE CONVERT(decimal(18,2), s.maxsize /128.) 
END "Max. size (MB)",
CONVERT(decimal(18,2), s.growth /128.) "Autogrowth increment (MB)"
FROM #Results r
INNER JOIN dbo.sysfiles s
ON r.FileID = s.FileID
ORDER BY 1,2,3,4,5


/*
drop table SueDB.dbo.DR13CompFiles

SELECT r.db AS "Database",
r.FileType AS "FileType",
CASE
	WHEN r.FileGroup = 'Log' Then 'N/A'
	ELSE r.FileGroup
END "Filegroup",
r.FileName,
r.TotalMB,
r.UsedMB ,
r.PctUsed ,
r.FilePath ,
r.FileID ,
CASE WHEN s.maxsize = -1 THEN null
    ELSE CONVERT(decimal(18,2), s.maxsize /128.) 
END "maxsizeMB",
CONVERT(decimal(18,2), s.growth /128.) "AutogrowthMB"
into SueDB.dbo.DR13CompFiles
FROM #Results r
INNER JOIN dbo.sysfiles s
ON r.FileID = s.FileID
ORDER BY 1,2,3,4,5
*/
 
DROP TABLE #Data
DROP TABLE #Results
DROP TABLE #Log