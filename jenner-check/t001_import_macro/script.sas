/************************************************************************************
***** Program: 	Import Macro	*****
***** Author:	joshkylepearce	*****
************************************************************************************/

/************************************************************************************
Purpose:
Import an external file based on user-inputted parameters.

Input Parameters:
1. folder		- The file explorer location of the file.
2. file_name		- The name of the file.
3. file_extension	- The file extension (e.g. xlsx, csv, txt etc.).
4. replace		- Binary indicator to overwrite pre-existing file (if exists).

Macro Usage:
1.	Run the import macro code.
2.	Call the import macro and enter the input parameters.
	e.g. %import(
	folder		= fileexplorer/folder,
	file_name	= filexplorer_file,
	file_extension 	= csv,
	replace		= 1
	);

Notes:
1. 	Input parameters are compatible with/without quotations.
	This is addressed within the macro.
2.	Input parameter 'replace' is an optional paramater.
	The macro will default to replacing a pre-existing file unless set to 0.
************************************************************************************/

%macro import(folder,file_name,file_extension,replace);

/*
Input parameters are only compatible with macro if not in quotes.
Account for single & double quotations.
*/
/*Remove double quotes*/
%let folder = %sysfunc(compress(&folder., '"'));
%let file_name = %sysfunc(compress(&file_name., '"'));
%let file_extension = %sysfunc(compress(&file_extension., '"'));
%let replace = %sysfunc(compress(&replace., '"'));
/*Remove single quotes*/
%let folder = %sysfunc(compress(&folder., "'"));
%let file_name = %sysfunc(compress(&file_name., "'"));
%let file_extension = %sysfunc(compress(&file_extension., "'"));
%let replace = %sysfunc(compress(&replace., "'"));

/*
Address possibility of duplciate backslashes being entered by the user
*/
/*Calculate the length of the 'folder' input parameter*/
%let len = %length(&folder.);
/*Identify the last character of the 'folder' input parameter*/
%let last_char = %substr(&folder., &len., 1);
/*Remove backslash if entered by the user at the end of the 'folder' parameter*/
%if &last_char. = \ %then %do;
	%let folder = %sysfunc(substr(&folder., 1, %sysfunc(length(&folder.))-1));
%end;

/*
Create two rules for importing dependent on the 'replace' input parameter
*/
/*If the input paramater 'replace' is set to zero*/
/*Do not overwrite a pre-existing file (if exists)*/
%if &replace. = 0 %then %do;
	proc import
		datafile="&folder./&file_name..&file_extension."
		out=&file_name.
		dbms=&file_extension.
		;
	run;
%end;
/*If the input paramater 'replace' is not set to zero*/
/*Overwrite a pre-existing file (if exists)*/
%else %do;
	proc import
		datafile="&folder./&file_name..&file_extension."
		out=&file_name.
		dbms=&file_extension.
		replace;
	run;
%end;

%mend;

/************************************************************************************
Example: Import Macro Usage (adapted for this bundle)

The author's own example calls the macro with a real UNC path
(\\sasebi\SAS User Data\Josh Pearce\DATA) and quoted / trailing-backslash
input, which is exactly what the macro's own header notes say it handles.
This bundle keeps that shape but points 'folder' at the WORK library
sandbox populated by autoexec.sas instead of a real network share, and
still exercises the quote-stripping and trailing-backslash-trim logic
above by quoting 'folder' with a trailing backslash and single-quoting
'file_name'.
************************************************************************************/

%import(
folder		= "%sysfunc(pathname(work))\",
file_name	= 'tourism_sample',
file_extension 	= "csv",
replace		= 1
);

proc print data=tourism_sample;
run;
