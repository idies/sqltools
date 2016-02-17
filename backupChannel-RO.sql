--============================
-- Prepare large DB for backup
-- run this script in the DB you wish to back up
-- 
-- Suzanne Werner, 12/2015
--=============================
--

--set to 0 to test, 1 to execute
declare @doExecute bit = 0
declare @sql nvarchar(4000)

--1. update statistics
print '[updating statistics...]'
if (@doExecute = 1)
	exec sp_updatestats


--2. set single user
set @sql = 'alter database ' + db_name() + ' set single_user with rollback immediate'

print '[setting db to single user mode...]'
print @sql
if (@doExecute = 1)
	exec sp_executesql @sql

set @sql = ''

--3. set filegroups to readonly
select @sql = coalesce(@sql, '')+'alter database ' + db_name() + ' modify filegroup ' + name + ' readonly ' + char(10) 
from sys.filegroups
where name != 'PRIMARY'

print '[setting filegroups to readonly...]'
print @sql
if (@doExecute = 1)
	exec sp_executesql @sql


--4.  set multi user
set @sql = 'alter database ' + db_name() + ' set multi_user'

print '[setting db to multi user mode...]'
print @sql
if (@doExecute = 1)
	exec sp_executesql @sql

--5. Set db to full recovery mode

select @sql = 'alter database ' + db_name() + ' set recovery full;'
print '[setting recovery mode to full...]'
print @sql
if (@doExecute = 1)
	exec sp_executesql @sql








