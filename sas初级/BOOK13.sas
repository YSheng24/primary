libname hw '/folders/myfolders/sas初级';
FILENAME REFFILE '/folders/myfolders/sas初级/dat1.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=HW.dat1
	replace;
	GETNAMES=no;
RUN;

data hw.dat31;
set HW.dat1;
rename
A =  No B = race C = sex D = age E = edu F = weight G = height H= tobaco I = sbp J = bmi;
RUN;
proc contents data = hw.dat31;
run;

PROC FREQ DATA = HW.DAT31;
TABLES RACE SEX TOBACO;
RUN;

proc univariate normal;
var age edu weight height bmi sbp;
histogram age edu weight height bmi sbp;
run;

/* data work.data; */
/* infile REFFILE; */
/* input No race sex age edu weight height tobaco sbp bmi; */
/* run; */

proc reg DATA = HW.DAT31;
model sbp = age edu weight height bmi / vif;
run;

proc reg DATA = HW.DAT31;
model sbp = age edu weight height bmi /noint vif;
run;

proc freq data = hw.dat31;
tables sex* race / chisq fisher;
run;

proc sort data = hw.dat31;
by sex;
run;
proc univariate data = hw.dat31 normal;
class sex;
var age;
by sex;
run;

proc ttest data = hw.dat31 cochran;
class sex;
var age;
run;
proc npar1way data = hw.dat31 wilcoxon;
class sex;
var age;
run;
