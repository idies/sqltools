USE [BestDR13_NoIndices]
GO

/****** Object:  StoredProcedure [dbo].[spIndexCreate_sue]    Script Date: 3/28/2016 2:55:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--
ALTER PROCEDURE [dbo].[spIndexCreate_sue](
	@taskID	int,
	@stepID int,
	@indexmapid int			-- link to IndexMap table
)
-------------------------------------------------------------
--/H Creates primary keys, foreign keys, and indices
--/A  -------------------------------------------------------
--/T Works for all user tables, views, procedures and functions 
--/T The default user is test, default access is U
--/T <BR>
--/T <li> taskID  int   	-- number of task causing this 
--/T <li> stepID  int   	-- number of step causing this 
--/T <li> tableName  varchar(1000)    -- name of table to get index or foreign key
--/T <li> fieldList  varchar(1000)    -- comma separated list of fields in key (no blanks)
--/T <li> foreignkey varchar(1000)    -- foreign key (f(a,b,c))
--/T <br> return value: 0: OK , > 0 : count of errors.
--/T <br> Example<br> 
--/T <samp>
--/T exec spCreateIndex @taskID, @stepID, 32 
--/T </samp>
-------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @indexName varchar(1000),
		@cmd nvarchar(2000),
		@msg varchar(2000),
		@status varchar(16),
		@fgroup varchar(100),
		@ret int,
		@error int,
		@type varchar(100), 		-- primary key, unique, index, foreign key 
		@code char(1),			-- the character code, 'K','I','F'
		@tableName varchar(100), 	-- table name 'photoObj'
		@fieldList varchar(1000),	-- fields 'u,g,r,i,z'
		@foreignKey varchar(1000);  	-- if foreign key 'SpecObj(SpecObjID)'
	--
	SET @status = 'OK'

	--------------------------------------------------
	-- fetch the parameters needed for spIndexCreate
	--------------------------------------------------
	SELECT @type=type, @code=code, @tablename=tableName, 
		@fieldlist=fieldList, @foreignkey=foreignKey
	    FROM IndexMap WITH (nolock)
	    WHERE indexmapid=@indexmapid;

	------------------------------------------------
	-- get the name of the filegroup for the index
	------------------------------------------------
	set @fgroup = null;
	select @fgroup = coalesce(indexFileGroup,'PRIMARY')
		from FileGroupMap with (nolock)
		where tableName=@tableName;
	--
	IF  @fgroup is null SET @fgroup='PRIMARY';
	SET @fgroup = '['+@fgroup+']';
	--
	set @indexName = dbo.fIndexName(@code,@tablename,@fieldList,@foreignKey)
	set @fieldList  = REPLACE(@fieldList,' ','');
	--
/*
	------------------------------------------------
	-- check the existence of the table first, and 
	-- issue warning and exit if it doesnt exist
	------------------------------------------------
	IF NOT EXISTS (SELECT name FROM sysobjects
        	WHERE xtype='U' AND name = @tableName)
	    BEGIN
		SET @msg = 'Could not create index ' + @indexName + ': table ' 
			+ @tablename + ' does not exist!'
		SET @status = 'WARNING'
		EXEC spNewPhase @taskid, @stepid, 'IndexCreate', @status, @msg 
		-----------------------------------------------------
		RETURN 1	
	    END
*/
	---------------
	-- Primary key
	---------------
	IF (lower(@type) = N'primary key')
	    BEGIN
		set @cmd = N'ALTER TABLE '+@tablename+' ADD CONSTRAINT '
			+@indexName+' PRIMARY KEY CLUSTERED '
			+'('+@fieldList+') 
			WITH (sort_in_tempdb=ON, data_compression=page)'
		--
		set @msg = 'primary key constraint '+@tableName+'('+@fieldList+') with tempdb, datacomp'
	    END
	------------------
	-- [unique] index
	------------------
	IF ((lower(@type) = 'index') or (lower(@type) = 'unique index'))
	    BEGIN
		set @cmd = N'CREATE '+upper(@type)+' '+@indexName+' ON '    
			+@tableName+'('+@fieldList+') WITH SORT_IN_TEMPDB';
		--
		if @fgroup is not null set @cmd = @cmd +' ON '+@fgroup;
		--
		set @msg = @type+' '+@tableName+'('+@fieldList+')'
	    END
	---------------
	-- foreign key
	---------------
	IF (lower(@type) = 'foreign key')
	    BEGIN
			set @cmd = N'ALTER TABLE '+@tableName+' WITH NOCHECK ADD CONSTRAINT '+@indexName   
				+' FOREIGN KEY ('+@fieldList+') REFERENCES '+@foreignKey;
			--
			set @msg = 'foreign key constraint '+@tableName 
				+'('+@fieldList+') references '+@foreignKey
	    END
	------------------------
	-- Perform the command
	------------------------
        IF EXISTS (
			SELECT [name] FROM dbo.sysobjects
			WHERE [name] = @tableName
		) 
			BEGIN
				IF NOT EXISTS (	select id from dbo.sysobjects
	    							where [name] = @indexname
	  							union
	    						select id from dbo.sysindexes
	    							where [name] = @indexname 
							  )
	    			BEGIN
						SET @ret = 1;		-- set it to an error value
						BEGIN TRANSACTION
							EXEC @ret=sp_executeSql @cmd 
							SET @error = @@error;
						COMMIT TRANSACTION
    				END
				ELSE 
				    BEGIN	-- index already there
						SET @status = 'OK'
						SET @msg = @msg  + ' already exists.'
						SET @ret = -1		-- signifies special case
					END
			END
		ELSE
			BEGIN
				SET @status = 'ERROR'
				SET @msg = 'Error in '+ @msg + ': Table ' + @tableName + ' does not exist!' 
				SET @ret = 1
			END
	--
	IF (@ret =  0)
	    BEGIN
			SET @status = 'OK'
			SET @msg = 'Created '  + @msg  
	    END

	IF (@ret > 0)
	    BEGIN
			IF (@error is not null)
				BEGIN
					SET @status = 'ERROR'
					DECLARE @sysmsg varchar(1000)
					SELECT @sysmsg = description FROM master.dbo.sysmessages WHERE error = @error
					IF (@sysmsg is null) SET @sysmsg = 'no sysmsg'
					SET @msg = 'Error in '+ @msg + ', ' + cast(@error as varchar(10)) + ': '  + @sysmsg 
				END
			ELSE
				BEGIN
					IF (@status != 'ERROR')
						BEGIN		-- not already marked as error
							SET @status = 'WARNING'
							SET @msg = 'Error in '+ @msg + '.' 
						END
				END
	    END
	-----------------------
	-- Generate log record
	-----------------------
	EXEC spNewPhase @taskid, @stepid, 'IndexCreate', @status, @msg 
	-----------------------------------------------------
	RETURN (case when (@ret < 0) then 0 else @ret end) 
END


GO


