


CREATE TABLE Test1
(
	Filler CHAR(8000)
)
on FG01
 
-- Insert 4 records
INSERT INTO Test1 VALUES (REPLICATE('A', 8000))
INSERT INTO Test1 VALUES (REPLICATE('B', 8000))
INSERT INTO Test1 VALUES (REPLICATE('C', 8000))
INSERT INTO Test1 VALUES (REPLICATE('D', 8000))
GO
 
-- Retrieve the selected records
SELECT * FROM Test1
GO

CREATE TABLE Test2
(
	Filler CHAR(8000)
)
on FG02
 
-- Insert 4 records
INSERT INTO Test2 VALUES (REPLICATE('A', 8000))
INSERT INTO Test2 VALUES (REPLICATE('B', 8000))
INSERT INTO Test2 VALUES (REPLICATE('C', 8000))
INSERT INTO Test2 VALUES (REPLICATE('D', 8000))
GO
 
-- Retrieve the selected records
SELECT * FROM Test2
GO

CREATE TABLE Test3
(
	Filler CHAR(8000)
)
on FG03
 
-- Insert 4 records
INSERT INTO Test3 VALUES (REPLICATE('A', 8000))
INSERT INTO Test3 VALUES (REPLICATE('B', 8000))
INSERT INTO Test3 VALUES (REPLICATE('C', 8000))
INSERT INTO Test3 VALUES (REPLICATE('D', 8000))
GO
 
-- Retrieve the selected records
SELECT * FROM Test3
GO


CREATE TABLE Test4
(
	Filler CHAR(8000)
)
on FG04
 
-- Insert 4 records
INSERT INTO Test4 VALUES (REPLICATE('A', 8000))
INSERT INTO Test4 VALUES (REPLICATE('B', 8000))
INSERT INTO Test4 VALUES (REPLICATE('C', 8000))
INSERT INTO Test4 VALUES (REPLICATE('D', 8000))
GO
 
-- Retrieve the selected records
SELECT * FROM Test4
GO



--==============
--backup db
backup database SueFGTest to disk = 'c:\data\data1\sql_db\SueFGTest.bak'


dbcc ind(sueFGTest, Test1, -1)

--

alter database sueFGTest set single_user with rollback immediate

--corrupt page 8
dbcc writepage('sueFGtest', 3, 8, 4000, 1, 0x45, 1);
go

select * from Test1

--error!
/*
Msg 824, Level 24, State 2, Line 90
SQL Server detected a logical consistency-based I/O error: incorrect checksum (expected: 0x81bb6e92; actual: 0x81bb6a92). It occurred during a read of page (3:8) in database ID 29 at offset 0x00000000010000 in file 'C:\data\data2\sql_db\sueFG01.ndf'.  Additional messages in the SQL Server error log or system event log may provide more detail. This is a severe error condition that threatens database integrity and must be corrected immediately. Complete a full database consistency check (DBCC CHECKDB). This error can be caused by many factors; for more information, see SQL Server Books Online.

*/


alter database sueFGtest set multi_user

--now run checkfilegroup?
EXECUTE master.dbo.DatabaseIntegrityCheck
@Databases = 'sueFGTest',
@CheckCommands = 'CHECKFILEGROUP',
@FileGroups = 'ALL_FILEGROUPS',
@PhysicalOnly = 'Y',
@EXECUTE = 'Y',
@LogToTable = 'Y'



