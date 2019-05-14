--monitor suspect_pages

select d.name as dbname,
mf.name as logical_file_name,
mf.physical_name as physical_file_name,
sp.page_id,
case sp.event_type
	when 1 then '823 or 824 error'
	when 2 then 'Bad Checksum'
	when 3 then 'Torn Page'
	when 4 then 'Restored'
	when 5 then 'Repaired'
	when 7 then 'Deallocated'
end as eventType,
sp.error_count,
sp.last_update_date
from msdb.dbo.suspect_pages as sp
join sys.databases as d on sp.database_id = d.database_id
join sys.master_files as mf on sp.[file_id] = mf.[file_id]
and d.database_id = mf.database_id

