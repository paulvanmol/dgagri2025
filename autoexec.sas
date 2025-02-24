/*autoexec */
%let path=/workshop/dgagri2025; 
%let path=/home/student/dgagri2025; 
options dlcreatedir fmtsearch=(work r2_fmt.formats); 

libname sumrica "&path/ricasum_n"; 
libname nuts "&path/eumaps";
libname R2_FMT "&path/formats"; 
libname fadn "&path/egtask"; 