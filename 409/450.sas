libname hw '/folders/myfolders/409';

FILENAME REFFILE '/folders/myfolders/409/2222.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.dat
	replace;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.dat;
RUN;

data hw.dat1;
set work.dat;
rename
VAR1 = ID
VAR2 = FIRENAME
VAR3 = DATE
VAR4 = Y2
VAR5 = STD1
VAR6 = X2
VAR7 = X3
VAR8 = X4
VAR9 = Y1
VAR10 = X5
VAR11 = X1
VAR12=x6
VAR13=x7
VAR14=x8
VAR15=x9
VAR16=x10
VAR17=x11
VAR18=x12
VAR19=x14
VAR20=x15
VAR21=x13
;
run;

proc standard
data = hw.dat1
out = hw.dat1
mean = 0
std=1;
var x1-x15;
run ;

PROC ARIMA DATA = hw.dat1;
identify VAR = Y1 stationarity= (adf = (4));
run;
data HW.DAT2;
set HW.DAT1;
Y1_lag1 = lag1(Y1);
Y1_lag14 = lag14(Y1);
Y1_diff1 = dif1(Y1);
dif14 = dif1(Y1) - (lag1(Y1) - lag14(Y1));
run;

PROC ARIMA DATA = HW.DAT2;
IDENTIFY VAR = DIF14 stationarity=(adf=(4));
RUN;

proc reg data = hw.dat2;
model y2 = x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15;
run;


proc reg data=hw.dat2;
model y1 = x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 / spec clb hcc hccmethod=1;
run;

proc logistic data=hw.dat2 descending ;
Model y2=x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 / cl rl lackfit sls = 0.1 sle=0.05;
run;





