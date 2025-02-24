libname fadnvars xlsx "&path/fadn/fadn_variable_descriptions.xlsx"; 
%include "&path/system/create_labels.sas"; 

/*Add specific labels and formats*/
data sumrica.yearcountry_labels;
set sumrica.yearcountryregiontf14; 
label COUNTRY="Country"
      REGION="Region"
	  TF14="(TF14)14 Types of Farms"; 
	; 
      ;
run; 
%create_labels(
dataset=sumrica.yearcountry_labels, 
metadata=fadnvars.sheet1,
name_col=variable,
label_col=label,
unit_col=unit);
