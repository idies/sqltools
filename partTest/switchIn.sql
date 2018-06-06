


alter table test_a01
switch to TestA
partition 1

alter table test_a02
switch to TestA
partition 2

alter table test_a03
switch to TestA
partition 3

alter table test_a04
switch to TestA 
partition 4


select count(*) from TestA
where $partition.pfnAB(id) = 2

