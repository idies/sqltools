DROP TABLE IF EXISTS [dbo].[TestA];CREATE TABLE [dbo].[TestA](
	id int not null,
 CONSTRAINT [pk_a_id] PRIMARY KEY CLUSTERED 
(
id
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [partSchemeA](id)
) ON [partSchemeA](id)


DROP TABLE IF EXISTS [dbo].[TestB];CREATE TABLE [dbo].[TestB](
	id int not null,
 CONSTRAINT [pk_b_id] PRIMARY KEY CLUSTERED 
(
id
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [partSchemeB](id)
) ON [partSchemeB](id)


DROP TABLE IF EXISTS [dbo].[test_a01]; CREATE TABLE [dbo].[test_a01](
				[id] [int] NOT NULL

		CONSTRAINT [pk_test_a01] PRIMARY KEY CLUSTERED 
		(
			id
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
		ON [fg01a])

ALTER TABLE [dbo].[test_a01] ADD CONSTRAINT [ck_test_a01] CHECK (([id]<=100 and [id] is not null))


;WITH Nums AS
		(
			SELECT n = ROW_NUMBER() OVER (ORDER BY [object_id]) 
			FROM sys.all_objects 

		)
		insert test_a01
		select n from Nums where n between 1 and 100 
		order by n

DROP TABLE IF EXISTS [dbo].[test_a02]; CREATE TABLE [dbo].[test_a02](
				[id] [int] NOT NULL

		CONSTRAINT [pk_test_a02] PRIMARY KEY CLUSTERED 
		(
			id
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
		ON [fg02a])

ALTER TABLE [dbo].[test_a02] ADD CONSTRAINT [ck_test_a02] CHECK (([id]>=101 AND [id]<=200 and [id] is not null))


;WITH Nums AS
		(
			SELECT n = ROW_NUMBER() OVER (ORDER BY [object_id]) 
			FROM sys.all_objects 

		)
		insert test_a02
		select n from Nums where n between 101 and 200 
		order by n

DROP TABLE IF EXISTS [dbo].[test_a03]; CREATE TABLE [dbo].[test_a03](
				[id] [int] NOT NULL

		CONSTRAINT [pk_test_a03] PRIMARY KEY CLUSTERED 
		(
			id
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
		ON [fg03a])

ALTER TABLE [dbo].[test_a03] ADD CONSTRAINT [ck_test_a03] CHECK (([id]>=201 AND [id]<=300 and [id] is not null))


;WITH Nums AS
		(
			SELECT n = ROW_NUMBER() OVER (ORDER BY [object_id]) 
			FROM sys.all_objects 

		)
		insert test_a03
		select n from Nums where n between 201 and 300 
		order by n

DROP TABLE IF EXISTS [dbo].[test_a04]; CREATE TABLE [dbo].[test_a04](
				[id] [int] NOT NULL

		CONSTRAINT [pk_test_a04] PRIMARY KEY CLUSTERED 
		(
			id
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
		ON [fg04a])

ALTER TABLE [dbo].[test_a04] ADD CONSTRAINT [ck_test_a04] CHECK (([id]>=301 and [id] is not null))


;WITH Nums AS
		(
			SELECT n = ROW_NUMBER() OVER (ORDER BY [object_id]) 
			FROM sys.all_objects 

		)
		insert test_a04
		select n from Nums where n between 301 and 400 
		order by n

DROP TABLE IF EXISTS [dbo].[test_b01]; CREATE TABLE [dbo].[test_b01](
				[id] [int] NOT NULL

		CONSTRAINT [pk_test_b01] PRIMARY KEY CLUSTERED 
		(
			id
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
		ON [fg01b])

ALTER TABLE [dbo].[test_b01] ADD CONSTRAINT [ck_test_b01] CHECK (([id]<=100 and [id] is not null))


;WITH Nums AS
		(
			SELECT n = ROW_NUMBER() OVER (ORDER BY [object_id]) 
			FROM sys.all_objects 

		)
		insert test_b01
		select n from Nums where n between 1 and 100 
		order by n

DROP TABLE IF EXISTS [dbo].[test_b02]; CREATE TABLE [dbo].[test_b02](
				[id] [int] NOT NULL

		CONSTRAINT [pk_test_b02] PRIMARY KEY CLUSTERED 
		(
			id
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
		ON [fg02b])

ALTER TABLE [dbo].[test_b02] ADD CONSTRAINT [ck_test_b02] CHECK (([id]>=101 AND [id]<=200 and [id] is not null))


;WITH Nums AS
		(
			SELECT n = ROW_NUMBER() OVER (ORDER BY [object_id]) 
			FROM sys.all_objects 

		)
		insert test_b02
		select n from Nums where n between 101 and 200 
		order by n

DROP TABLE IF EXISTS [dbo].[test_b03]; CREATE TABLE [dbo].[test_b03](
				[id] [int] NOT NULL

		CONSTRAINT [pk_test_b03] PRIMARY KEY CLUSTERED 
		(
			id
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
		ON [fg03b])

ALTER TABLE [dbo].[test_b03] ADD CONSTRAINT [ck_test_b03] CHECK (([id]>=201 AND [id]<=300 and [id] is not null))


;WITH Nums AS
		(
			SELECT n = ROW_NUMBER() OVER (ORDER BY [object_id]) 
			FROM sys.all_objects 

		)
		insert test_b03
		select n from Nums where n between 201 and 300 
		order by n

DROP TABLE IF EXISTS [dbo].[test_b04]; CREATE TABLE [dbo].[test_b04](
				[id] [int] NOT NULL

		CONSTRAINT [pk_test_b04] PRIMARY KEY CLUSTERED 
		(
			id
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
		ON [fg04b])

ALTER TABLE [dbo].[test_b04] ADD CONSTRAINT [ck_test_b04] CHECK (([id]>=301 and [id] is not null))


;WITH Nums AS
		(
			SELECT n = ROW_NUMBER() OVER (ORDER BY [object_id]) 
			FROM sys.all_objects 

		)
		insert test_b04
		select n from Nums where n between 301 and 400 
		order by n

