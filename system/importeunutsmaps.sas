%let path=c:/workshop/dgagri2025; 
/*read nuts maps:*/ 
proc mapimport infile="&path/eumaps/NUTS_RG_20M_2021_4326.shp/NUTS_RG_20M_2021_4326.shp" 
contents
out=nuts.EUNUTS2021;
id nuts_id;  
run; 

data nuts.EUNUTS01 nuts.eunuts02 nuts.eunuts03; 
set nuts.eunuts2021; 
if levl_code=1 then output nuts.eunuts01; 
if levl_code=2 then output nuts.eunuts02; 
if levl_code=3 then output nuts.eunuts03; 
run; 

proc sql; 
create table nuts.eunuts01_labels as
select distinct CNTR_CODE,
COAST_TYPE,
LEVL_CODE,
MOUNT_TYPE,
NUTS_ID,
NUTS_NAME,NAME_LATN,
URBN_TYPE
from NUTS.EUNUTS01; 
quit; 

proc sql; 
create table nuts.eunuts02_labels as
select distinct CNTR_CODE,
COAST_TYPE,
LEVL_CODE,
MOUNT_TYPE,
NUTS_ID,
NUTS_NAME,NAME_LATN,
URBN_TYPE
from NUTS.EUNUTS02; 
quit; 
proc sql; 
create table nuts.eunuts03_labels as
select distinct CNTR_CODE,
COAST_TYPE,
LEVL_CODE,
MOUNT_TYPE,
NUTS_ID,
NUTS_NAME,NAME_LATN,
URBN_TYPE
from NUTS.EUNUTS03; 
quit; 
proc sgmap mapdata=nuts.eunuts01 maprespdata=nuts.eunuts01_labels; 
choromap nuts_name /mapid=nuts_id;
run;
proc sgmap mapdata=nuts.eunuts02 maprespdata=nuts.eunuts02_labels; 
choromap nuts_name /mapid=nuts_id;
run;
proc sgmap mapdata=nuts.eunuts03 maprespdata=nuts.eunuts03_labels; 
choromap nuts_name /mapid=nuts_id;
run;