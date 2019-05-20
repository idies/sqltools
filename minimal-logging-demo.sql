
set statistics io on


if object_id('dbo.Test', 'U') is not null
begin
	drop table dbo.Test;
end;
go

create table dbo.Test
(
	id int not null identity constraint pk_test_id -- [PK dbo.Test (id)]
	primary key,
	c1 int not null, 
	padding char(45) not null default ''
);
go

-- clear the log
checkpoint;
go

-- insert rows
insert dbo.Test with (TABLOCK)
	(c1)
select top (269) checksum(newid()) --268 will be fully logged.  
from master.dbo.spt_values as sv;
go

-- show log entries
SELECT
    FD.Operation,
    FD.Context,
    FD.[Log Record Length],
    FD.[Log Reserve],
    FD.AllocUnitName,
    FD.[Transaction Name],
    FD.[Lock Information],
    FD.[Description]
FROM sys.fn_dblog(NULL, NULL) AS FD
where fd.AllocUnitName = N'dbo.Test.pk_test_id'
GO

-- count number of fully-logged rows
select
	[Fully Logged Rows] = count_big(*)
from sys.fn_dblog(null, null) as fd
where 
	fd.operation = N'LOP_INSERT_ROWS'
	and fd.Context = N'LCX_CLUSTERED'
	and fd.AllocUnitName = N'dbo.Test.pk_test_id'

-- LOP_INSERT_ROWS and LCX_CLUSTERED means it's fully logged
-- (despite empty cx and tablock!

go

-- maybe try same thing with tf 610
----------------------------------------------------------------------------------
if object_id('dbo.Test610', 'U') is not null
begin
	drop table dbo.Test610;
end;
go

create table dbo.Test610
(
	id int not null identity constraint pk_test610_id -- [PK dbo.Test (id)]
	primary key,
	c1 int not null, 
	padding char(45) not null default ''
);
go

-- clear the log
checkpoint;
go

-- insert rows
dbcc traceon(610)
insert dbo.Test610 with (TABLOCK)
	(c1)
select top (269) checksum(newid())
from master.dbo.spt_values as sv;
go

dbcc traceoff(610)

SELECT
    FD.Operation,
    FD.Context,
    FD.[Log Record Length],
    FD.[Log Reserve],
    FD.AllocUnitName,
    FD.[Transaction Name],
    FD.[Lock Information],
    FD.[Description]
FROM sys.fn_dblog(NULL, NULL) AS FD
where fd.AllocUnitName = N'dbo.Test610.pk_test610_id'

GO

-- count number of fully-logged rows
select
	[Fully Logged Rows] = count_big(*)
from sys.fn_dblog(null, null) as fd
where 
	fd.operation = N'LOP_INSERT_ROWS'
	and fd.Context = N'LCX_CLUSTERED'
	and fd.AllocUnitName = N'dbo.Test610.pk_test610_id'

-- SAME THING! 268 FULLY LOGGED ROWS
-- EVEN THOUGH 1. empty table 2. tablock 3. tf(610)

-- look at clustered index insert node in query plan.  DMLRequestSort = false, which means that 
-- either the estimated row count is less that 250 
-- or the calculated data size is less than 2 8K pages

--=======================
-- not that interesting, i don't really care about minimal logging with data sizes this small
-- however.

-- LOW CARDINALITY ESTIMATES can mess you up

if object_id('dbo.Test', 'U') is not null
begin
	drop table dbo.Test;
end;
go

create table dbo.Test
(
	id int not null identity constraint pk_test_id -- [PK dbo.Test (id)]
	primary key,
	c1 int not null, 
	padding char(45) not null default ''
);
go

-- clear the log
checkpoint;
go

declare @nrows bigint = 10000

-- insert rows
insert dbo.Test with (TABLOCK)
	(c1)
select top (@nrows) checksum(newid()) 
from master.dbo.spt_values as sv
option(recompile)
go

-- show log entries
SELECT
    FD.Operation,
    FD.Context,
    FD.[Log Record Length],
    FD.[Log Reserve],
    FD.AllocUnitName,
    FD.[Transaction Name],
    FD.[Lock Information],
    FD.[Description]
FROM sys.fn_dblog(NULL, NULL) AS FD
where fd.AllocUnitName = N'dbo.Test.pk_test_id'
GO

-- count number of fully-logged rows
select
	[Fully Logged Rows] = count_big(*)
from sys.fn_dblog(null, null) as fd
where 
	fd.operation = N'LOP_INSERT_ROWS'
	and fd.Context = N'LCX_CLUSTERED'
	and fd.AllocUnitName = N'dbo.Test.pk_test_id'



-- it incorrectly estimates 100 rows (why???)
-- this could be a problem because the cardinality info is stored with the plan cache!
-- it will not be re-evauated even if you change the value of @nrows

-- changed @nrows to 1000
-- 2551 FULLY LOGGED ROWS!!!

-- you can change this behavior by doing option(recompile)

-- option(recompile) gives 0 fully logged rows

--========================================
-- ok but  WHAT ABOUT HEAPS
-------------------------------------------

CREATE TABLE dbo.TestHeap
(
    id integer NOT NULL IDENTITY,
    c1 integer NOT NULL,
    padding char(45) NOT NULL
        DEFAULT ''
);
GO
-- Clear the log
CHECKPOINT;
GO
-- Insert rows
INSERT dbo.TestHeap WITH (TABLOCK) 
    (c1)
SELECT TOP (897)
    CHECKSUM(NEWID())
FROM master.dbo.spt_values AS SV;
GO
-- Show log entries
SELECT
    FD.Operation,
    FD.Context,
    FD.[Log Record Length],
    FD.[Log Reserve],
    FD.AllocUnitName,
    FD.[Transaction Name],
    FD.[Lock Information],
    FD.[Description]
FROM sys.fn_dblog(NULL, NULL) AS FD;
GO
-- Count the number of fully-logged rows
SELECT 
    [Fully Logged Rows] = COUNT_BIG(*) 
FROM sys.fn_dblog(NULL, NULL) AS FD
WHERE
    FD.Operation = N'LOP_INSERT_ROWS'
    AND FD.Context = N'LCX_HEAP'
    AND FD.AllocUnitName = N'dbo.TestHeap';


-- wait i thought having (tablock) and an empty table were sufficient for minimal logging?
-- why on earth would insert into a heap table be fully logged??

-- oh, same thing.  it has to do with data size for heaps (threshold is 8 8k pages)
-- don't care that much, we'd always be going over the data size of 

