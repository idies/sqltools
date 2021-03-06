

--ts0to4 was created in simple recovery mode

--1. ingest
--2. switch to full recovery mode
alter database ts0to4 set recovery full


--sp_helpfile

--3. shrink log file?
USE [ts0to4]
GO
DBCC SHRINKFILE (N'ts0to4_log' , 0)
GO


--4. backup db to disk
backup database ts0to4 
	to disk = 'c:\data\data1\ts0to4Full_sw.bak'
go
--5. backup log
backup log ts0to4 to disk = 'c:\data\data1\ts0to4Full_sw.bak'
go


--6. detach db 
use master;

alter database ts0to4
set single_user with rollback immediate;

EXEC sp_detach_db 'ts0to4', 'true';

--go to c:\data\data6\sql_db, remove or rename 
--rename c:\data\data6\sql_db\ts0to4_FG02.ndf to c:\data\data6\sql_db\ts0to4_FG02-BAAAAD.ndf

--try to attach DB?
USE [master]
GO
CREATE DATABASE [ts0to4] ON 
( FILENAME = N'C:\data\data5\sql_db\ts0to4_PRIMARY.mdf' ),
( FILENAME = N'C:\data\data5\sql_db\ts0to4_log.ldf' ),
( FILENAME = N'C:\data\data5\sql_db\ts0to4_FG01.ndf' ),
( FILENAME = N'C:\data\data6\sql_db\ts0to4_FG02.ndf' ),
( FILENAME = N'C:\data\data7\sql_db\ts0to4_FG03.ndf' ),
( FILENAME = N'C:\data\data8\sql_db\ts0to4_FG04.ndf' ),
( FILENAME = N'C:\data\data5\sql_db\ts0to4_FG05.ndf' ),
( FILENAME = N'C:\data\data6\sql_db\ts0to4_FG06.ndf' ),
( FILENAME = N'C:\data\data7\sql_db\ts0to4_FG07.ndf' ),
( FILENAME = N'C:\data\data8\sql_db\ts0to4_FG08.ndf' ),
( FILENAME = N'C:\data\data5\sql_db\ts0to4_FG09.ndf' ),
( FILENAME = N'C:\data\data6\sql_db\ts0to4_FG10.ndf' ),
( FILENAME = N'C:\data\data7\sql_db\ts0to4_FG11.ndf' ),
( FILENAME = N'C:\data\data8\sql_db\ts0to4_FG12.ndf' ),
( FILENAME = N'C:\data\data5\sql_db\ts0to4_FG13.ndf' ),
( FILENAME = N'C:\data\data6\sql_db\ts0to4_FG14.ndf' ),
( FILENAME = N'C:\data\data7\sql_db\ts0to4_FG15.ndf' ),
( FILENAME = N'C:\data\data8\sql_db\ts0to4_FG16.ndf' )
 FOR ATTACH
GO

/* missing fg02 file gives this error:
Msg 5120, Level 16, State 101, Line 42
Unable to open the physical file "C:\data\data6\sql_db\ts0to4_FG02.ndf". Operating system error 2: "2(The system cannot find the file specified.)".
*/

--try creating garbage fg02.ndf file?  write some crap in notepad save as C:\data\data6\sql_db\ts0to4_FG02.ndf

--try again
--doesn't work
--how do i test this?


use ts0to4
go

select * from sys.database_files


--set one file to offline
alter database ts0to4 
modify file (name=ts0to4_FG02, OFFLINE)

--NOTE THAT YOU CAN'T JUST PUT A FILE BACK ONLINE AFTER SETTING IT OFFLINE!
--YOU HAVE TO RESTORE FROM BACKUP!

select top 10 * from vel_02
/*
Msg 8653, Level 16, State 1, Line 89
The query processor is unable to produce a plan for the table or view 'vel_02' because the table resides in a filegroup that is not online.
*/

--i guess this replicates having a screwed up file?

SELECT file_id,
    CONVERT (CHAR (15), RTRIM (name)) AS name,
    CONVERT (CHAR (15), RTRIM (state_desc)) AS state
FROM ts0to4.sys.database_files WHERE name = 'ts0to4_FG02';

GO
--this shows the file as offline


restore filelistonly from disk = 'c:\data\data1\ts0to4Full_sw.bak'
--looks like everything is there

--let's try to restore this file
use master;

restore database ts0to4 file = 'ts0to4_FG02'
from disk = 'c:\data\data1\ts0to4Full_sw.bak'
with norecovery;
go

SELECT file_id,
    CONVERT (CHAR (15), RTRIM (name)) AS name,
    CONVERT (CHAR (15), RTRIM (state_desc)) AS state
FROM ts0to4.sys.database_files WHERE name = 'ts0to4_FG02';

GO
--now this says 'restoring' (run this command in different connection obvs)
/*
Processed 82416 pages for database 'ts0to4', file 'ts0to4_FG02' on file 1.
RESTORE DATABASE ... FILE=<name> successfully processed 82416 pages in 91.446 seconds (7.041 MB/sec).
*/


--now we need to restore the log backup
restore log ts0to4 from disk = 'c:\data\data1\ts0to4Full_sw.bak'
with recovery;

---THIS DOES NOT WORK!!!!!!!!  
---maybe attaching and detaching or whatever wrote some stuff to the txn log who knows
--========================================================================================================

--========================================================================================================

--second attempt.

use master;
go

drop database ts0to4;
go

--restore from our old simple recovery mode backup
USE [master]
RESTORE DATABASE [ts0to4] FROM  DISK = N'C:\data\data1\ts0to4.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5

GO


--change recovery to full
alter database ts0to4 set recovery full




-- backup db to disk
backup database ts0to4 
	to disk = 'c:\data\data1\ts0to4Full_sw4.bak'
	with checksum --not sure why these options but ok
go
-- backup log
backup log ts0to4 to disk = 'c:\data\data1\ts0to4Full_sw4_log.trn'
	with checksum
go


-- set file offline
--set one file to offline
alter database ts0to4 
modify file (name=ts0to4_FG02, OFFLINE)

SELECT file_id,
    CONVERT (CHAR (15), RTRIM (name)) AS name,
    CONVERT (CHAR (15), RTRIM (state_desc)) AS state
FROM ts0to4.sys.database_files WHERE name = 'ts0to4_FG02';

select * from ts0to4.dbo.vel_02
--Msg 667, Level 16, State 1, Line 182
--The index "pk_vel_2" for table "dbo.vel_02" (RowsetId 72057594043826176) resides on a filegroup ("FG02") that cannot be accessed because it is offline, is being restored, or is defunct.


--restore one file
restore database ts0to4 file = 'ts0to4_FG02'
from disk = 'c:\data\data1\ts0to4Full_sw3.bak'
with norecovery;
go
--Processed 82416 pages for database 'ts0to4', file 'ts0to4_FG02' on file 1.
--RESTORE DATABASE ... FILE=<name> successfully processed 82416 pages in 34.763 seconds (18.521 MB/sec).


SELECT file_id,
    CONVERT (CHAR (15), RTRIM (name)) AS name,
    CONVERT (CHAR (15), RTRIM (state_desc)) AS state
FROM ts0to4.sys.database_files WHERE name = 'ts0to4_FG02';
--file_id	name	state
--4	ts0to4_FG02    	RESTORING      


--restore log

restore LOG ts0to4 from DISK = 'c:\data\data1\ts0to4Full_sw3.bak'
with RECOVERY 
GO
--DOES NOT WORK!!!!!!


--==========================================================================================
/*
Processed 0 pages for database 'ts0to4', file 'ts0to4_FG02' on file 1.
The roll forward start point is now at log sequence number (LSN) 37000000140000001. Additional roll forward past LSN 37000000150400001 is required to complete the restore sequence.
RESTORE LOG successfully processed 0 pages in 0.446 seconds (0.000 MB/sec).
*/

--what if i backup the log again??


backup log ts0to4 to disk = 'c:\data\data1\ts0to4Full_sw3.bak'
	with checksum
go
/*
Processed 7 pages for database 'ts0to4', file 'ts0to4_log' on file 3.
BACKUP LOG successfully processed 7 pages in 0.762 seconds (0.071 MB/sec).
*/

restore LOG ts0to4 from DISK = 'c:\data\data1\ts0to4Full_sw3.bak'
with RECOVERY 
GO
--DOES NOT WORK



--after setting FG02 offline

--===============================

select * from ts0to4.dbo.vel_02

--tail log backup
backup log ts0to4 to disk = 'c:\data\data1\ts0to4Full_sw4_log2.trn' with norecovery

--trying with partial this time?
restore database ts0to4 file = 'ts0to4_FG02'
from disk = 'c:\data\data1\ts0to4Full_sw4.bak'
with partial, norecovery;
go

restore log ts0to4 from disk =  'c:\data\data1\ts0to4Full_sw4_log.trn' with norecovery

restore log ts0to4 from disk = 'c:\data\data1\ts0to4Full_sw4_log2.trn' with recovery


SELECT file_id,
    CONVERT (CHAR (15), RTRIM (name)) AS name,
    CONVERT (CHAR (15), RTRIM (state_desc)) AS state
FROM ts0to4.sys.database_files WHERE name = 'ts0to4_FG02';


--IT WORKED!

select * from ts0to4.dbo.vel_02
