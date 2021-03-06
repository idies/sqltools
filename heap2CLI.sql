/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [field_name]
      ,[location_id]
      ,[ra]
      ,[dec]
      ,[expected_no_of_visits]
  FROM [BestDR13_CCI].[dbo].[apogeeField]

  USE [BestDR13_CCI]
GO

USE [BestDR13_CCI]
GO

/****** Object:  Index [pk_IndexMap_indexmapid]    Script Date: 2/21/2017 4:37:31 PM ******/
ALTER TABLE [dbo].[IndexMap2] ADD  CONSTRAINT [pk_IndexMap2_indexmapid] PRIMARY KEY CLUSTERED 
(
	[indexmapid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [DATA]
GO


ALTER TABLE [dbo].[nsatlas] ADD  CONSTRAINT [pk_nsatlas_nsaid] PRIMARY KEY CLUSTERED 
(
	[nsaid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [DATA]
GO



--ALTER TABLE [dbo].[Plate2Target] ADD  CONSTRAINT [pk_Plate2Target_plate2targetid] PRIMARY KEY CLUSTERED 
--(
--	[plate2targetid] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [DATA]
--GO

create clustered index cl_plate2target on plate2target(plate2targetid) on [data]

ALTER TABLE [dbo].[Run] ADD  CONSTRAINT [pk_run_run] PRIMARY KEY CLUSTERED 
(
	[run] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [DATA]
GO


ALTER TABLE [dbo].[SiteDBs] ADD  CONSTRAINT [pk_SiteDBs_dbname] PRIMARY KEY CLUSTERED 
(
	[dbname] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [DATA]
GO


