use tempdb

exec sp_helpfile

go

use master

go

Alter database tempdb modify file (name = tempdev, filename = 'F:\sql_db\tempdb.mdf')

go

Alter database tempdb modify file (name = templog, filename = 'F:\sql_db\templog.ldf')

go


USE [master]; 
GO 
alter database tempdb modify file (name='tempdev', size = 25GB);
GO
/* Adding seven additional files */
USE [master];
GO
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev2', FILENAME = N'F:\sql_db\tempdev2.ndf' , SIZE = 25GB , FILEGROWTH = 0);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev3', FILENAME = N'F:\sql_db\tempdev3.ndf' , SIZE = 25GB , FILEGROWTH = 0);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev4', FILENAME = N'F:\sql_db\tempdev4.ndf' , SIZE = 25GB , FILEGROWTH = 0);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev5', FILENAME = N'F:\sql_db\tempdev5.ndf' , SIZE = 25GB , FILEGROWTH = 0);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev6', FILENAME = N'F:\sql_db\tempdev6.ndf' , SIZE = 25GB , FILEGROWTH = 0);
ALTER DATABASE [tempdb] ADD FILE (NAME = N'tempdev7', FILENAME = N'F:\sql_db\tempdev7.ndf' , SIZE = 25GB , FILEGROWTH = 0);
GO


/* Restart SQL server to make the changes take affect */

