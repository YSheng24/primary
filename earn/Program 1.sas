libname aaa '/folders/myfolders/earn';
FILENAME REFFILE '/folders/myfolders/earn/新建 Microsoft Excel 97-2003 工作表.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=aaa.dat
	replace;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=aaa.dat;
RUN;

/* stationary test  */
data aaa.dat0;
set aaa.dat;
y_log = log(y);
run;

proc arima data = aaa.dat0;
identify 
var = y_log ;
run;
proc arima data = aaa.dat0;
identify 
var = x3 ;
run;

