use suedb
go
 
 -- at the very end of this script there is a nice query that gives you all sorts of info about what's going on with your partitions


--counts from test tables to see what is where
select count(*) from test_a01
select count(*) from test_a02
select count(*) from test_a03
select count(*) from test_a04

--count from partitioned table
select count(*) from TestA

--handy query to count and group by partitions
select $partition.pfnAB(id) as partition,
count(*) as nrows from TestA
group by $partition.pfnAB(id)
order by partition ;


-- switch tables into partitioned table
alter table test_a01
switch to TestA
partition 1

alter table test_a02
switch to TestA
partition 2

alter table test_a03
switch to TestA
partition 3

alter table test_a04
switch to TestA
partition 4

-- pretend that disk 2 goes bad, so we've lost fg02a and partition 2 of the table
-- switch out all partitions of partitioned table back to switch tables

alter table TestA
switch partition 1
to test_a01

alter table TestA
switch partition 2 
to test_a02

alter table testA
switch partition 3
to test_a03

alter table testA
switch partition 4
to test_a04

select count(*) from testA

---drop partition scheme from partitioned table?

drop partition scheme PartSchemeA
/*
Msg 7717, Level 16, State 1, Line 57
The partition scheme "PartSchemeA" is currently being used to partition one or more tables.
*/
--can't do it, will need to drop and re-create table.

--first, let's create new partition scheme that uses fg02b instead of fg02a, it's on a different disk so it will be intact

create partition scheme PartSchemeWithoutD2 as PARTITION pfnAB to ( [fg01a], [fg02b], [fg03a], [fg04a])

--drop and recreate table using new partition scheme
DROP TABLE IF EXISTS [dbo].[TestA];
CREATE TABLE [dbo].[TestA](
	id int not null,
 CONSTRAINT [pk_a_id] PRIMARY KEY CLUSTERED 
(
id
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PartSchemeWithoutD2(id)
) ON PartSchemeWithoutD2(id)

--switch tables into new table (using test_b02 instead of test_a02)

alter table test_a01
switch to TestA
partition 1

alter table test_b02
switch to TestA
partition 2

alter table test_a03
switch to TestA
partition 3

alter table test_a04
switch to TestA
partition 4


select count(*) from testA
--back to 400, yay!


----partition query!
SELECT
     SCHEMA_NAME(t.schema_id) AS SchemaName
    ,OBJECT_NAME(i.object_id) AS ObjectName
    ,p.partition_number AS PartitionNumber
    ,fg.name AS Filegroup_Name
    ,rows AS 'Rows'
    ,au.total_pages AS 'TotalDataPages'
    ,CASE boundary_value_on_right
        WHEN 1 THEN 'less than'
        ELSE 'less than or equal to'
     END AS 'Comparison'
    ,value AS 'ComparisonValue'
    ,p.data_compression_desc AS 'DataCompression'
    ,p.partition_id
FROM sys.partitions p
    JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
    JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
    JOIN sys.partition_functions f ON f.function_id = ps.function_id
    LEFT JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id
    JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
    JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id
    JOIN (SELECT container_id, sum(total_pages) as total_pages
            FROM sys.allocation_units
            GROUP BY container_id) AS au ON au.container_id = p.partition_id 
    JOIN sys.tables t ON p.object_id = t.object_id
WHERE i.index_id < 2
ORDER BY ObjectName,p.partition_number;
GO
