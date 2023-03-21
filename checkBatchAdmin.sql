--=========================================
-- 
-- This script verifies that the db's in Batch.Servers
-- actually exist where we think they do.
-- it also verifies that linked servers exist between 
-- the batchadmin host and the target catalog hosts.
--
-- S.Werner 3/2023
--
--  TODO:	turn into stored procedure?
--			figure out why NT AUTHORITY/ANONYMOUS LOGIN issue happens for certain hosts
--			test login credentials also?
--
--==============================================



use batchadmin


declare @sql nvarchar(4000)
declare @name sysname, @host sysname, @cat sysname
declare @n int

declare cur cursor fast_forward for 
select name, host, cat
from batch.servers
where host NOT IN ('sciserver01', 'dsp051')
and cat not in ('ETAPA')

open cur
fetch next from cur
into @name, @host, @cat

declare @outtab table (
	name sysname,
	host sysname, 
	cat sysname,
	errno int, 
	errstate int,
	err nvarchar(4000)
	)

while @@FETCH_STATUS = 0
begin

	set @sql = concat('select @n=count(*) from ',@host, '.master.sys.databases where name = ''',@cat,'''')
	print @sql
	begin try
		exec sp_executesql @sql, N'@n int OUTPUT', @n = @n OUTPUT
	end try
	begin catch
		insert into @outtab values (
			@name,
			@host, 
			@cat, 
			error_number(),
			error_state(),
			error_message()
			)
	end catch
	--select @name, @host, @cat, @n
	if (@n < 1)
		insert into @outtab values (
			@name,
			@host, 
			@cat, 
			9999999,
			@n,
			'make sure this db actually exists on the server'
			)

	fetch next from cur into @name, @host, @cat

end

select * from @outtab
order by errno desc

close cur
deallocate cur


