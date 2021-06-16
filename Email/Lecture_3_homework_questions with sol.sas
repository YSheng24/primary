libname email '/folders/myfolders/Email';

/* Import the dataset into SAS */
proc import datafile='/folders/myfolders/Email/Email_data.csv'
dbms=csv
out = email.email_data
replace;
getnames=yes;
run;
/* 1.	Use proc contents to get familiar with the structure of the data */
proc contents data=email.email_data;
run;
/* 2.	Check the distribution of the data by email type (Segment) */

proc freq data=email.email_data;
table segment;
run;

/* 3.	Find the statistical properties of visit, conversion, and spend. */

proc means data= email.email_data;
var visit conversion spend;
run;
* 4.	Find the statistical properties of visit, conversion, and spend by email type (Segment). 
Which e-mail campaign performed the best, the Mens version, or the Womens version? */

proc means data= email.email_data;
class segment;
var visit conversion spend;
run;






