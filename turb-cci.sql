

alter database channeldb01
set single_user with rollback immediate

alter database channeldb01
set read_write

sp_helpfile

exec sp_spaceused 'vel'
exec sp_spaceused 'pr'

/*
name	rows	reserved	data	index_size	unused
pr	1049362432          	2887816016 KB	2798303120 KB	16001416 KB	73511480 KB
vel	1049362432          	8464582704 KB	8394899456 KB	47992432 KB	21690816 KB
*/

/* AFTER
pr	1049362432          	2889967360 KB	2798303120 KB	18135312 KB	73528928 KB
vel	1049362432          	8464582704 KB	8394899456 KB	47992432 KB	21690816 KB
*/

create nonclustered columnstore index nci_ts
on pr(timestep)
on zindexPartScheme(zindex)

alter database channeldb01
set multi_user


sp_blitz

sp_helpfile

SELECT a.io_stall, a.io_stall_read_ms, a.io_stall_write_ms, a.num_of_reads, 
a.num_of_writes, 
--a.sample_ms, a.num_of_bytes_read, a.num_of_bytes_written, a.io_stall_write_ms, 
( ( a.size_on_disk_bytes / 1024 ) / 1024.0 ) AS size_on_disk_mb, 
db_name(a.database_id) AS dbname, 
b.name, a.file_id, 
db_file_type = CASE 
                   WHEN a.file_id = 2 THEN 'Log' 
                   ELSE 'Data' 
                   END, 
UPPER(SUBSTRING(b.physical_name, 1, 2)) AS disk_location 
FROM sys.dm_io_virtual_file_stats (NULL, NULL) a 
JOIN sys.master_files b ON a.file_id = b.file_id 
AND a.database_id = b.database_id 
ORDER BY a.io_stall DESC


select min(timestep), max(timestep)
from pr --6s

select min(zindex), max(zindex)
from pr  --23 s

select min(timestep), max(timestep)
from vel 

select * from pr
where timestep between 132005 and 132100
and zindex = 2048


select top 10 zindex from pr

 

create nonclustered index i_z
on pr(zindex)
with (sort_in_Tempdb = on)
on zindexPartScheme(zindex)

create nonclustered index i_t
on pr(timestep)
with (sort_in_Tempdb = on)
on zindexPartScheme(zindex)

dbcc traceon(1118, -1)

dbcc traceon(1117, -1)


set statistics IO on

select * from pr where zindex in(0,
512,
1024,
1536,
2048,
2560,
3072,
3584,
4096,
4608)


create table #zz(zindex bigint)

insert into #zz (zindex) values (0),
(512),
(1024),
(1536),
(2048),
(2560),
(3072),
(3584),
(4096),
(4608)


select * from pr where zindex in (
	select zindex from #zz
)



sp_help