


alter database [sueDB] add filegroup [FG01a]
alter database [sueDB] add filegroup [FG02a]
alter database [sueDB] add filegroup [FG03a]
alter database [sueDB] add filegroup [FG04a]


alter database [sueDB] add filegroup [FG01b]
alter database [sueDB] add filegroup [FG02b]
alter database [sueDB] add filegroup [FG03b]
alter database [sueDB] add filegroup [FG04b]

---------------------------------------------

alter database [sueDB] add file (
	name = 'test_fg01a', 
	filename = 'c:\data\data1\sql_db\test_fg01a.ndf',
	size = 10MB) 
to filegroup [FG01a]

alter database [sueDB] add file (
	name = 'test_fg02a', 
	filename = 'c:\data\data2\sql_db\test_fg01a.ndf',
	size = 10MB) 
to filegroup [FG02a]

alter database [sueDB] add file (
	name = 'test_fg03a', 
	filename = 'c:\data\data3\sql_db\test_fg03a.ndf',
	size = 10MB) 
to filegroup [FG03a]

alter database [sueDB] add file (
	name = 'test_fg04a', 
	filename = 'c:\data\data4\sql_db\test_fg04a.ndf',
	size = 10MB) 
to filegroup [FG04a]


alter database [sueDB] add file (
	name = 'test_fg01b', 
	filename = 'c:\data\data2\sql_db\test_fg01b.ndf',
	size = 10MB) 
to filegroup [fg01b]

alter database [sueDB] add file (
	name = 'test_fg02b', 
	filename = 'c:\data\data3\sql_db\test_fg01b.ndf',
	size = 10MB) 
to filegroup [fg02b]

alter database [sueDB] add file (
	name = 'test_fg03b', 
	filename = 'c:\data\data4\sql_db\test_fg03b.ndf',
	size = 10MB) 
to filegroup [fg03b]

alter database [sueDB] add file (
	name = 'test_fg04b', 
	filename = 'c:\data\data1\sql_db\test_fg04b.ndf',
	size = 10MB) 
to filegroup [fg04b]



