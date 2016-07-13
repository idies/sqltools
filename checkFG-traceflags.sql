


select * from sys.filegroups


dbcc checkfilegroup ([FG01]) with physical_only, no_infomsgs  --32:35 with no TF's
-------------------------------------------------------------------------------------------------
dbcc traceon(2562)
dbcc checkfilegroup ([FG02]) with physical_only, no_infomsgs  --28:18 (ended about 1:20pm)
dbcc traceoff(2562)

dbcc traceon(2549, -1)
dbcc checkfilegroup ([FG03]) with physical_only, no_infomsgs --43:07 (ended about 2:08 pm)
dbcc traceoff(2549, -1)


dbcc traceon(2562)
dbcc traceon(2549, -1)
dbcc checkfilegroup ([FG04]) with physical_only, no_infomsgs --30:39 (ended 2:52 pm)
dbcc traceoff(2562)
dbcc traceoff(2549, -1)


dbcc checkfilegroup([FG05]) with physical_only, no_infomsgs --32:04 (ended 3:28pm)

--just for the heck of it, try without physical_only
dbcc checkfilegroup([FG06]) with no_infomsgs




