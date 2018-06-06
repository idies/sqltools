


create function dbo.part2FGname(@partitionNum int, @scheme nvarchar(1))
returns sysname
as 
begin

	declare @fgname sysname

	/*
	add filegroup [FG'+ RIGHT('00'+rtrim(CAST(@count as nvarchar)),2)+']'
	*/

	set @fgname = '[fg' + right('00'+rtrim(cast(@partitionNum as nvarchar)),2)+@scheme+']'
	return @fgname
end



select dbo.part2FGName(2, 'b')