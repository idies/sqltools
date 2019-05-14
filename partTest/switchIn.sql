


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

alter table TestA
switch partition 1 to test_a01

alter table TestA
switch partition 2 to test_a02

alter table TestA
switch partition 3 to test_a03

alter table TestA
switch partition 4 to test_a04

