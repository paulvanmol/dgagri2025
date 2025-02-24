%macro create_labels(
    dataset=,           /* Dataset to modify (include library) */
    metadata=,          /* Metadata table containing labels */
    name_col=,         /* Column containing variable names */
    label_col=,        /* Column containing variable labels */
    unit_col=          /* Optional: Column containing units */
);
    /* Parameter validation */
    %if %sysevalf(%superq(dataset)=,boolean) %then %do;
        %put ERROR: Parameter dataset is required.;
        %return;
    %end;
    %if %sysevalf(%superq(metadata)=,boolean) %then %do;
        %put ERROR: Parameter metadata is required.;
        %return;
    %end;
    %if %sysevalf(%superq(name_col)=,boolean) %then %do;
        %put ERROR: Parameter name_col is required.;
        %return;
    %end;
    %if %sysevalf(%superq(label_col)=,boolean) %then %do;
        %put ERROR: Parameter label_col is required.;
        %return;
    %end;

    /* Extract library and dataset names */
    %let lib_name = %scan(&dataset, 1, .);
    %let ds_name = %scan(&dataset, 2, .);
    
    /* If no library specified, assume WORK */
    %if &ds_name = %then %do;
        %let ds_name = &lib_name;
        %let lib_name = WORK;
    %end;

    /* Create a temporary file to store the PROC DATASETS statements */
    filename labels temp;

    /* Write the PROC DATASETS statements to the temporary file */
    data _null_;
        set &metadata. end=last;
        file labels;
        length label_text $1000;
        
        /* Write the initial PROC DATASETS statement only once */
        if _n_ = 1 then do;
            put "proc datasets library=&lib_name nolist;";
            put "    modify &ds_name;";
            put '    label';
        end;
        
        /* Construct label text based on presence of unit_col */
        %if %sysevalf(%superq(unit_col)=,boolean) %then %do;
            label_text = cats('(', "&name_col"n, ') ', "&label_col"n);
        %end;
        %else %do;
            if "&unit_col"n = '' then
                label_text = cats('(', "&name_col"n, ') ', "&label_col"n);
            else
                label_text = cats('(', "&name_col"n, ') ', "&label_col"n, ' (', "&unit_col"n, ')');
        %end;
        
        /* Write each label statement */
        put '        ' "&name_col"n '=' '"' label_text +(-1) '"';
        
        /* If not the last record, add a continuation */
        if not last then put '        ';
        else put '    ;';
        
        /* Close the PROC DATASETS at the end */
        if last then put 'quit;';
    run;

    /* Execute the generated code */
    %include labels;

    /* Clean up */
    filename labels clear;
%mend create_labels;

/* Example usage:
data metadata;
    length var_name $32 description $256 unit $32;
    input var_name $ description $ unit $;
    datalines;
age     Patient Age    years
gender  Patient Gender     
bmi     Body Mass Index    kg/m2
weight  Body Weight    kg
;
run;

* Example with units;
%create_labels(
    dataset=sasuser.patients,
    metadata=metadata,
    name_col=var_name,
    label_col=description,
    unit_col=unit
);

* Example without units;
%create_labels(
    dataset=work.patients,
    metadata=metadata,
    name_col=var_name,
    label_col=description
);
*/
libname fadnvars xlsx "&path/fadn/fadn_variable_descriptions.xlsx"; 

/*Add specific labels and formats*/
data sumrica.yearcountryregiontf14_labels;
set sumrica.yearcountryregiontf14; 
label COUNTRY="Country"
      REGION="Region"
	  TF14="(TF14)14 Types of Farms"; 
	; 
      ;
run; 
%create_labels(
dataset=sumrica.yearcountryregiontf14_labels, 
metadata=fadnvars.sheet1,
name_col=variable,
label_col=label,
unit_col=unit);
