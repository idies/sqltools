
select top 15 c.* ,  (c.size_current_compression - c.size_requested_compression) as diff, (c.sample_current_compression - c.sample_requested_compression) as diff2
from sciserver01.tempdb.dbo.compresults c
where objectName in (	
	select tableName from IndexMap
	where indexgroup='PHOTO'
)
and index_id=1
order by  diff desc


select * from IndexMap
where indexgroup='PHOTO'




select top 15 objectName ,  (c.size_current_compression - c.size_requested_compression) as diff, (c.sample_current_compression - c.sample_requested_compression) as diff2
into tempdb.dbo.photocomp
from sciserver01.tempdb.dbo.compresults c
where objectName in (	
	select tableName from IndexMap
	where indexgroup='PHOTO'
)
and index_id=1
order by  diff desc



