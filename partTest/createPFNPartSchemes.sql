/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [partNum]
      ,[minLim]
      ,[maxLim]
  FROM [sueDB].[dbo].[PartLimitsAB]


  create partition function pfnAB(int) as range left for values (100, 200, 300)

  create partition scheme partSchemeA as partition pfnAB to ([fg01a], [fg02a], [fg03a], [fg04a])

  create partition scheme partSchemeB as partition pfnAB to ([fg01b], [fg02b], [fg03b], [fg04b])



  create table Part2FG (
  partitionNum int not null,
  partScheme varchar(1),
  fgName sysname
)
