


use master
alter database BestDR15
set single_user with rollback immediate
go

alter database BestDR15
set read_write
go

alter database BestDR15
set multi_user
go




create procedure dbo.spSetSingleUser @dbname sysname
as
	set nocount on;
	declare @sql nvarchar(4000)

	set @sql = concat('alter database ', @dbname , ' set single_user with rollback immediate')
	exec sp_executesql @sql		

	
go

create procedure dbo.spSetReadWrite @dbname sysname
as
	set nocount on;
	declare @sql nvarchar(4000)
	set @sql = concat('alter database ', @dbname, ' set read_write')

	exec sp_executesql @sql		


go


create procedure dbo.spSetMultiUser @dbname sysname
as
	set nocount on;	
	declare @sql nvarchar(4000)

	set @sql = concat('alter database ', @dbname, ' set multi_user')

	exec sp_executesql @sql		


go


create procedure dbo.spSetReadOnly @dbname sysname
as
	set nocount on;
	declare @sql nvarchar(4000)
	
	set @sql = concat('alter database ', @dbname, ' set read_only')
go


