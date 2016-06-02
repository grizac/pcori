**************************************************;
** Identifying Frailty using Claims				**;
** Based off Kim & Schneeweiss 2014				**;
** Joanna Seirup, Weill Cornell Medical College **;
** May 18th, 2016								**;
**************************************************;

/*
TYPE OF FILE INPUT REQUIRED
	- Multiple rows are allowed per patient
	- ICD9 codes are required for 12 of the 14 frailty indicators
		Multiple codes are allowed per line provided they start with the same prefix and are numbered 1-n (e.g., dx1 - dx10)
	- HCPCS are required for 2 of the 14 frailty indicators
		Multiple codes are allowed per line provided they start with the same prefix and are numbered 1-n (e.g., hcpcs1 - hcpcs10)
	- ICD9 codes and HCPCS must be in separate variables with different prefixes; they can be on the same or separate rows

USER INPUT TO RUN THIS CODE
	- Update library name
	- Give macro input: library name, dataset name, patient ID variable, ICD9 prefix, number of ICD9 variables, HCPCS prefix, number of HCPCS variables

NURSING SERVICES AND DME LIMITIATON
	- The two frailty indicators that use HCPCS are nursing services and durable medical equipment. These should primarily be found in the Medicare home health 
		and durable medical equipment files respectively. We did not have access to these files for our 2012 NY State Medicare test case for this code, so while
		a small number of HCPCS for these two indicators were found, nursing services and DME use were grossly underestimated. This code is equiped to handle the
		HCPCS from the additional home health and DME Medicare files should they become availble. 
*/

/*Set library*/
libname data 'S:\CR3044\jos2065_CR3044\Grinspan Frailty';

/*Load macro*/
%macro frailty(lib,filname,id,dx,dxn,hcpcs,hcpcsn);

%put &id;
%put &dx;
%put &dxn;
%put &hcpcs;
%put &hcpcsn;
data &filname._frailty_codelevel;
set &lib..&filname;

if substr(&dx.1,1,4) in('7812')
%do i=      2 %to &dxn; 
			or substr(&dx.&i,1,4)  in('7812')   %end; 

then FRAIL_GAIT = 1;
else FRAIL_GAIT = 0;

if substr(&dx.1,1,4) in('7832') 
%do i=      2 %to &dxn; 
			or substr(&dx.&i,1,4) in('7832')   %end; 

then FRAIL_UNDERWEIGHT = 1; 
else FRAIL_UNDERWEIGHT = 0;

if substr(&dx.1,1,4) in('7837') 
%do i=      2 %to &dxn; 
			or substr(&dx.&i,1,4) in('7837')  %end; 

then FRAIL_THRIVE = 1;
else FRAIL_THRIVE = 0;

if substr(&dx.1,1,4)  in('7994') 
%do i=      2 %to &dxn; 
			or substr(&dx.&i,1,4)  in('7994')   %end; 

then FRAIL_CACHEXIA = 1;
else FRAIL_CACHEXIA = 0;

if substr(&dx.1,1,4)  in('7993') 
%do i=      2 %to &dxn; 
			or substr(&dx.&i,1,4)   in('7993')   %end; 

then FRAIL_DEBILITY = 1;
else FRAIL_DEBILITY = 0;

if substr(&dx.1,1,4)  in('7197') 
%do i=      2 %to &dxn; 
			or substr(&dx.&i,1,4)   in('7197')  %end; 

then FRAIL_WALK = 1;
else FRAIL_WALK = 0;

if substr(&dx.1,1,5)  in('V1588') 
%do i=      2 %to &dxn; 
			or substr(&dx.&i,1,5)   in('V1588')   %end; 

then FRAIL_FALL = 1;
else FRAIL_FALL = 0;

if substr(&dx.1,1,4) in('7807')
%do i= 		2 %to &dxn;
			or substr(&dx.&i,1,4) 	in('7807')	%end;

then FRAIL_MALAISE = 1;
else FRAIL_MALAISE = 0;

if substr(&dx.1,1,4)  in('7282') 
%do i=      2 %to &dxn; 
			or substr(&dx.&i,1,4)   in('7282')   %end; 

then FRAIL_ATROPHY = 1;
else FRAIL_ATROPHY = 0;

if substr(&dx.1,1,5)  in('72887') 
%do i=      2 %to &dxn; 
			or substr(&dx.&i,1,5)   in('72887')   %end; 

then FRAIL_WEAKNESS = 1;
else FRAIL_WEAKNESS = 0;

if substr(&dx.1,1,4)  in('7070','7072')
%do i=      2 %to &dxn; 
			or substr(&dx.&i,1,4)   in('7070', '7072')   %end; 

then FRAIL_PRESULCER = 1;
else FRAIL_PRESULCER = 0;

if substr(&dx.1,1,3)  in('797') 
%do i=      2 %to &dxn; 
			or substr(&dx.&i,1,3)   in('797')   %end; 

then FRAIL_SENILITY = 1;
else FRAIL_SENILITY = 0;

if substr(&hcpcs.1,1,5)  in('E0100', 'E0105' ,'E0130', 'E0135', 'E0140', 'E0141', 'E0143', 'E0144', 'E0147', 'E0148', 'E0149', 'E0160', 'E0161', 
		'E0162', 'E0163', 'E0164', 'E0165', 'E0166', 'E0167', 'E0168', 'E0169', 'E0170', 'E0171') 
%do i=      2 %to &hcpcsn; 
			or substr(&hcpcs.&i,1,5)   in('E0100', 'E0105' ,'E0130', 'E0135', 'E0140', 'E0141', 'E0143', 'E0144', 'E0147', 'E0148', 'E0149', 'E0160', 'E0161', 
		'E0162', 'E0163', 'E0164', 'E0165', 'E0166', 'E0167', 'E0168', 'E0169', 'E0170', 'E0171')   %end; 

then FRAIL_DME = 1;
else FRAIL_DME = 0;

if substr(&hcpcs.1,1,5) in('T1000', 'T1001', 'T1002', 'T1003', 'T1004', 'T1005', 'T1019', 'T1020', 'T1021', 'T1022', 'T1030', 'T1031')
%do i= 		2 %to &hcpcsn;
			or substr(&hcpcs.&i,1,5) in('T1000', 'T1001', 'T1002', 'T1003', 'T1004', 'T1005', 'T1019', 'T1020', 'T1021', 'T1022', 
		'T1030', 'T1031')	%end;

then FRAIL_NURSE = 1;
else FRAIL_NURSE = 0;

run;

proc datasets lib=work nolist;
modify &filname._frailty_codelevel;
label 
FRAIL_GAIT = "Abnormality of gait"
FRAIL_UNDERWEIGHT = "Abnormal loss of weight and underweight"
FRAIL_THRIVE = "Failure to thrive"
FRAIL_CACHEXIA = "Cachexia"
FRAIL_DEBILITY = "Debility"
FRAIL_WALK = "Difficulty in walking"
FRAIL_FALL = "Fall"
FRAIL_MALAISE = "Malaise and fatgiue"
FRAIL_ATROPHY = "Muscular wasting and disuse atrophy"
FRAIL_WEAKNESS = "Muscle weakness"
FRAIL_PRESULCER = "Pressure ulcer"
FRAIL_SENILITY = "Senility without mention of psychosis"
FRAIL_DME = "Durable medical equipment (cane, walker, bath equipment, and commode)"
FRAIL_NURSE = "Nursing or personal care services";
quit;run;

/*Patient-level file*/
proc means data=&filname._frailty_codelevel max noprint;
by patient_ID;
var FRAIL_GAIT FRAIL_UNDERWEIGHT FRAIL_THRIVE FRAIL_CACHEXIA FRAIL_DEBILITY FRAIL_WALK FRAIL_FALL 
	FRAIL_MALAISE FRAIL_ATROPHY FRAIL_WEAKNESS FRAIL_PRESULCER FRAIL_SENILITY FRAIL_DME FRAIL_NURSE;
output out= &lib..&filname._frailty_ptlevel max= ;
run;

data &lib..&filname._frailty_ptlevel; set &lib..&filname._frailty_ptlevel;
FRAIL_COUNT = FRAIL_GAIT + FRAIL_UNDERWEIGHT + FRAIL_THRIVE + FRAIL_CACHEXIA + FRAIL_DEBILITY + FRAIL_WALK + FRAIL_FALL +
	FRAIL_MALAISE + FRAIL_ATROPHY + FRAIL_WEAKNESS + FRAIL_PRESULCER + FRAIL_SENILITY + FRAIL_DME + FRAIL_NURSE;
if FRAIL_COUNT >=2 then FRAIL_FLAG = 1;
else FRAIL_FLAG = 0;
run;
%mend;



/* pass in libname, filename, patient ID variable name, ICD9 dx column name, number of ICD9 dx columns, HCPCS column name, and number of HCPCS columns*/
%frailty(data,kim_reshape,patient_ID,dx,1,hcpcs,1); run;
