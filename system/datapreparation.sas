/*Read Selected Dimensions into SAS tables and Formats*/
libname seldims xlsx "&path/fadn/selected_dimensions.xlsx"; 
proc contents data=seldims._all_ out=r2_fmt.metadata_cols; 
run; 

proc copy inlib=seldims outlib=R2_FMT; 
run; 
libname seldims clear; 

/*Create Formats in R2_FMT library*/
proc catalog cat=r2_fmt.formats; 
run; 
%macro create_dimfmt(lib=r2_fmt,dataset=, fmtname=altitude,type=N,start=,label=);
data _cntlfmt; 
%if &dataset= %then %do; set &lib..&fmtname; %end; 
%else %do; set &lib..&dataset; %end; 
type="&type"; 
fmtname="&fmtname";
%if &start= %then %do; start=&fmtname; %end; 

%if &start= %then %do; 
where &fmtname not is missing; 
start=&fmtname; 
%end; 
%else %do; where &start not is missing; start=&start; %end; 
%if &label= %then %do; label=&fmtname._description; %end; 
%else %do; label=&label; %end; 
run; 
proc format lib=&lib..formats cntlin=_cntlfmt fmtlib;
select &fmtname;  
run; 
%mend create_dimfmt;
%create_dimfmt(lib=r2_fmt, fmtname=altitude, type=N, label=);  
%create_dimfmt(lib=r2_fmt, fmtname=cluaa , type=N, label=);  
%create_dimfmt(lib=r2_fmt, dataset=ANC3, fmtname=ANC3_N , type=N,start=ANC3, label=ANC3_Description);
%create_dimfmt(lib=r2_fmt, fmtname=COUNTRY , type=C, label=Country_short_name); 
%create_dimfmt(lib=r2_fmt, fmtname=REGION , type=N, label=);
%create_dimfmt(lib=r2_fmt, dataset=ORGANIC3, fmtname=ORGANIC3_N , start=ORGANIC3, type=N, label=ORGANIC3_description); 
%create_dimfmt(lib=r2_fmt, fmtname=ES6_SGM , type=N, start=siz6, label=siz6_description);  
%create_dimfmt(lib=r2_fmt, fmtname=SIZ6_SO , type=N, start=siz6, label=siz6_description); 
%create_dimfmt(lib=r2_fmt, fmtname=SIZC_SGM , type=N, start=sizc, label=sizc_description);
%create_dimfmt(lib=r2_fmt, fmtname=SIZC_SO , type=N, start=sizc, label=sizc_description); 
%create_dimfmt(lib=r2_fmt, dataset=TF_GEN1, fmtname=TF_GEN1_N , type=N,start=TF_GEN1, label=TF_GEN1_Description);  
%create_dimfmt(lib=r2_fmt, fmtname=TF_PART3_SGM , type=N,start=TF_PART3, label=TF_PART3_description); 
%create_dimfmt(lib=r2_fmt, fmtname=TF_PART3_SO , type=N,start=TF_PART3, label=TF_PART3_description); 
%create_dimfmt(lib=r2_fmt, fmtname=TF_PRIN2_SGM , type=N,start=TF_PRIN2, label=TF_PRIN2_description); 
%create_dimfmt(lib=r2_fmt, fmtname=TF_PRIN2_SO , type=N,start=TF_PRIN2, label=TF_PRIN2_description);
%create_dimfmt(lib=r2_fmt, fmtname=TF_SUBP4_SGM , type=N,start=TF_SUBP4, label=TF_SUBP4_description);  
%create_dimfmt(lib=r2_fmt, fmtname=TF_SUBP4_SO , type=N,start=TF_SUBP4, label=TF_SUBP4_description);
%create_dimfmt(lib=r2_fmt, dataset=TF8, fmtname=TF8_N , type=N, start=TF8, label=TF8_description); 
%create_dimfmt(lib=r2_fmt, fmtname=TF14_SGM , type=N, start=TF14, label=TF14_Description); 
%create_dimfmt(lib=r2_fmt, fmtname=TF14_SO , type=N, start=TF14, label=TF14_Description);
%create_dimfmt(lib=r2_fmt, fmtname=TYPOWN , type=N, label=); 





