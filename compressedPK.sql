

set nocount on

declare @i int

declare c cursor for

select i.indexmapID
from indexMap i
join tempdb.dbo.photocomp c
on i.tablename = c.objectName
and i.code = 'K'
where indexmapid not in (22,45)


open c
fetch next from c into @i

set statistics time on
while @@FETCH_STATUS=0
begin
	exec spIndexCreate_sue 0,0,@i

	fetch next from c into @i
end
set statistics time off

close c
deallocate c

---started 15:48 pm 3/28/2016
 
