use tempdb

exec sp_helpfile

/*this will give you the names and locations of the currently configured tempdb files.  Out of the box, they're on the C drive in the MSSQL directory.*/

go

use master

go

--change T: to wherever you actually want tempdb to be
Alter database tempdb modify file (name = tempdev, filename = 'T:\sql_db\tempdb.mdf')

go

--change T: to wherever you actually want tempdb to be
Alter database tempdb modify file (name = templog, filename = 'T:\sql_db\templog.ldf')

go

/*IMPORTANT: MAKE ALL THE TEMPDB FILES THE SAME SIZE!!!!!

  ALSO make sure the sql_db directory exists! and change T: to wherever you actually want tempdb to be
*/


USE [master]; 
GO 
alter database tempdb modify file (name='tempdev', size = 25GB, FILEGROWTH = 10%);   --change 25GB to whatever the size of your drive is divided by 8
GO
/* Adding seven additional files */
USE [master];
GO
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev2', FILENAME = N'T:\sql_db\tempdev2.ndf' , SIZE = 25GB , FILEGROWTH = 10%); -- --change 25GB to whatever the size of your drive is divided by 8, do this for all these files
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev3', FILENAME = N'T:\sql_db\tempdev3.ndf' , SIZE = 25GB , FILEGROWTH = 10%);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev4', FILENAME = N'T:\sql_db\tempdev4.ndf' , SIZE = 25GB , FILEGROWTH = 10%);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev5', FILENAME = N'T:\sql_db\tempdev5.ndf' , SIZE = 25GB , FILEGROWTH = 10%);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev6', FILENAME = N'T:\sql_db\tempdev6.ndf' , SIZE = 25GB , FILEGROWTH = 10%);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev7', FILENAME = N'T:\sql_db\tempdev7.ndf' , SIZE = 25GB , FILEGROWTH = 10%);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev8', FILENAME = N'T:\sql_db\tempdev8.ndf' , SIZE = 25GB , FILEGROWTH = 10%);
GO

/* Restart SQL server to make the changes take effect 
and then run the following DBCC command:
*/

DBCC TRACEON(1118, -1)


