/* 
	CreateVelTables.sql
	S.Werner 6/20/2016

	Script to create partitioned vel table 
	and one switch table per partition.

	Run this script in the DB for which you wish to create velocity tables.

	Note: This script does not execute the statments, just generates them.
	Copy the resulting output from the Results pane into a new SSMS window to execute.
*/

/*
  create partition function pfnAB(int) as range left for values (100, 200, 300)

  create partition scheme partSchemeA as partition pfnAB to ([fg01a], [fg02a], [fg03a], [fg04a])

  create partition scheme partSchemeB as partition pfnAB to ([fg01b], [fg02b], [fg03b], [fg04b])
*/

set nocount on


declare @dbname sysname
declare @sliceNum int
declare @npart int
declare @createPartitionedTable nvarchar(2000)
declare @sql nvarchar(max)

DECLARE @NewLine AS CHAR(2) = CHAR(13) + CHAR(10)

set @dbname = db_name()
--set @sliceNum = cast(right(@dbname, 3) as int)




select @nPart = max(partitionNum)
				from PartLimitsAB
				--where sliceNum = @sliceNum

declare @schemes table  (id int, code nvarchar(1), partscheme sysname)
insert @schemes values (1, 'a', 'PartSchemeA')
insert @schemes values (2, 'b', 'PartSchemeB')


	
--=======================
-- create partitioned table
--======================

set @createPartitionedTable = 'DROP TABLE IF EXISTS [dbo].[TestA];CREATE TABLE [dbo].[TestA](
	id int not null,
 CONSTRAINT [pk_a_id] PRIMARY KEY CLUSTERED 
(
id
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [partSchemeA](id)
) ON [partSchemeA](id)'


print @createPartitionedTable
print @newline
print @newline

set @createPartitionedTable = 'DROP TABLE IF EXISTS [dbo].[TestB];CREATE TABLE [dbo].[TestB](
	id int not null,
 CONSTRAINT [pk_b_id] PRIMARY KEY CLUSTERED 
(
id
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [partSchemeB](id)
) ON [partSchemeB](id)'


print @createPartitionedTable
print @newline
print @newline


declare @count int
set @count = 1

declare @nScheme int
set @nScheme = 1

declare @maxSchemes int
set @maxSchemes = 2


--cte to generate list of numbers to insert

while (@nScheme <= @maxSchemes)
begin
	
	while (@count <= @nPart)
	begin
		declare @schemeCode nvarchar(1)
		select @schemecode = code from @schemes where @nscheme = id

		declare @minLim bigint, @maxLim bigint
		declare @tablename sysname, @fgname sysname

		select @minLim=minLim, @maxLim=maxLim
		from PartLimitsAB
		where PartitionNum = @count

		set @tablename = 'test_' + @schemecode + RIGHT('00'+rtrim(CAST(@count as nvarchar)),2)
		select @fgname = dbo.part2FGName(@count, @schemecode)



		--==============================
		-- create switch tables
		--==============================
		set @sql = 'DROP TABLE IF EXISTS [dbo].['+@tablename +']; CREATE TABLE [dbo].['+@tablename +'](
				[id] [int] NOT NULL

		CONSTRAINT [pk_'+@tablename+'] PRIMARY KEY CLUSTERED 
		(
			id
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
		ON '+@fgname+')'

		print @sql
		print @newline
	
	
		--===============================
		-- add check constraint
		--===============================

		/*
		create partition function zindexPFN(bigint) as range left for values(679477247, 687865855, 696254463, 704643071, 713031679, 721420287, 729808895, 738197503, 746586111, 754974719, 763363327, 771751935, 780140543, 788529151, 796917759)

		ALTER TABLE [dbo].[pr_01]  WITH CHECK ADD  CONSTRAINT [ck_pr1] CHECK  (([zindex]<=(813694975)))
		ALTER TABLE [dbo].[pr_02]  WITH CHECK ADD  CONSTRAINT [ck_pr2] CHECK  (([zindex]>=(813694976) AND [zindex]<=(822083583)))
		ALTER TABLE [dbo].[pr_16]  WITH CHECK ADD  CONSTRAINT [ck_pr16] CHECK  (([zindex]>=(931135488)))
		*/

		--TODO: this is a little hacky but it works with the way zindexes are set up in turbulence.
		--normally you wouldn't put a check constraint that allows both boundaries, (one side would be > and the other side wold be <= or vice versa)
		--but i can't remember which one is which for turbulence, i'll fix this eventually but this works for now.
		-- i think it should be > minLim and <= maxLim but need to double check, will fix
		--

	
		if (@count = 1) --first partition, only max lim
		begin
			set @sql='ALTER TABLE [dbo].['+@tablename+'] ADD CONSTRAINT [ck_'+@tablename+'] CHECK (([id]<='+cast(@maxLim as nvarchar)+' and [id] is not null))'
		end
		else if (@count = @npart)
		begin
			set @sql='ALTER TABLE [dbo].['+@tablename+'] ADD CONSTRAINT [ck_'+@tablename+'] CHECK (([id]>'+cast(@minLim - 1 as nvarchar)+' and [id] is not null))'
		end
		else
			set @sql='ALTER TABLE [dbo].['+@tablename+'] ADD CONSTRAINT [ck_'+@tablename+'] CHECK (([id]>'+cast(@minLim - 1 as nvarchar) + ' AND [id]<='+cast(@maxLim as nvarchar)+' and [id] is not null))'


		print @sql
		print @newline
		print @newline

		--insert into tables using Nums cte

		set @sql=';WITH Nums AS
		(
			SELECT n = ROW_NUMBER() OVER (ORDER BY [object_id]) 
			FROM sys.all_objects 

		)
		insert ' + @tablename + '
		select n from Nums where n between '+cast(@minLim as nvarchar)+' and '+cast(@maxLim as nvarchar)+' 
		order by n'

		print @sql
		print @newline


		

		



		set @count = @count + 1
	
		end
	set @nScheme = @nScheme + 1
	set @count = 1
	end

	

	




