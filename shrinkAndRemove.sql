
/*
BestDR13_CCI	Data	PRIMARY	BESTDR8_Data1	2755298.44	75.63	0.00	D:\data1\sql_db\BestDR13_Compressed\BESTDR13_Data1.MDF	1	NULL	0.08
BestDR13_CCI	Data	PRIMARY	BESTDR8_Data2	1499238.44	38.44	0.00	C:\data\data2\sql_db\BestDR13_Compressed\BESTDR13_Data2.NDF	3	NULL	0.08
BestDR13_CCI	Data	PRIMARY	BESTDR8_Data3	1649162.31	43.00	0.00	C:\data\data3\sql_db\BestDR13_Compressed\BESTDR13_Data3.NDF	4	NULL	0.08
BestDR13_CCI	Data	PRIMARY	BESTDR8_Data4	1814078.56	47.00	0.00	C:\data\data4\sql_db\BestDR13_Compressed\BESTDR13_Data4.NDF	5	NULL	0.08
BestDR13_CCI	Data	PRIMARY	BESTDR8_Data5	1814078.56	48.38	0.00	C:\data\data5\sql_db\BestDR13_Compressed\BESTDR13_Data5.NDF	6	NULL	0.08
BestDR13_CCI	Data	PRIMARY	BESTDR8_Data6	1814078.56	48.38	0.00	C:\data\data6\sql_db\BestDR13_Compressed\BESTDR13_Data6.NDF	7	NULL	0.08
BestDR13_CCI	Data	PRIMARY	BESTDR8_Data7	1995486.44	52.81	0.00	C:\data\data7\sql_db\BestDR13_Compressed\BESTDR13_Data7.NDF	8	NULL	0.08
BestDR13_CCI	Data	PRIMARY	BESTDR8_Data8	2655992.56	70.94	0.00	C:\data\data8\sql_db\BestDR13_Compressed\BESTDR13_Data8.NDF	9	NULL	0.08
*/

DBCC SHRINKFILE(BestDR8_Data8, EMPTYFILE)
DBCC SHRINKFILE(BestDR8_Data7, EMPTYFILE)
DBCC SHRINKFILE(BestDR8_Data6, EMPTYFILE)
DBCC SHRINKFILE(BestDR8_Data5, EMPTYFILE)
DBCC SHRINKFILE(BestDR8_Data4, EMPTYFILE)
DBCC SHRINKFILE(BestDR8_Data3, EMPTYFILE)
DBCC SHRINKFILE(BestDR8_Data2, EMPTYFILE)

alter database bestdr13_cci
remove file BestDR8_Data8

alter database bestdr13_cci
remove file BestDR8_Data7

alter database bestdr13_cci
remove file BestDR8_Data6

alter database bestdr13_cci
remove file BestDR8_Data5

alter database bestdr13_cci
remove file BestDR8_Data4

alter database bestdr13_cci
remove file BestDR8_Data3

alter database bestdr13_cci
remove file BestDR8_Data2