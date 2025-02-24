%let path=/workshop/dgagri2025; 

options validvarname=v7 sastrace=",,t,d" sastraceloc=saslog nostsuffix;
options set=NLS_LANG="AMERICAN_AMERICA.AL32UTF8";
options set=NLS_CHARSET_EXCP=WARNING;
/*create oracle libname*/ 
libname orarica oracle path="server.demo.sas.com:1521/ORCL" 
	user="STUDENT" pw="Metadata0" schema="STUDENT" 
	DBCLIENT_MAX_BYTES=4  /* For UTF-8 encoding */
    DBSERVER_MAX_BYTES=4 /* For UTF-8 encoding */ ;
/*fadn_variable_descriptions copy to oracle*/
libname fadnvars xlsx "&path/fadn/fadn_variable_descriptions.xlsx"; 
proc contents data=fadnvars._all_; 
run; 
/*drop table*/
proc sql; 
drop table orarica.fadn_variable_desc; 
quit; 

/*insert records */
data orarica.fadn_variable_desc; 
length variable $32 label $255 unit $50 description $1000 
Formula_with_codes_2014 $330
Formula_with_codes_2014_dif $510
Formula_with_codes_pre_2014 $500; 
 
set fadnvars.sheet1
(rename=(
Formula_using_farm_return_codes=Formula_with_codes_pre_2014
Formula_with_codes_of_the_2014_f=Formula_with_codes_2014
Formula_with_codes_of_subsequent=Formula_with_codes_2014_dif))
; 
keep variable label unit description 
Formula_with_codes_2014 
Formula_with_codes_2014_dif
Formula_with_codes_pre_2014; 
run; 

libname sel_dims xlsx "/workshop/dgagri2025/fadn/selected_dimensions.xlsx"; 

proc contents data=sel_dims._all_ nods; 
run; 
/*
proc copy inlib=sel_dims outlib=orarica; 
quit; 
*/