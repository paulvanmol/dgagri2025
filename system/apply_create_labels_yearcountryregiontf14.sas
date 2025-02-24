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
