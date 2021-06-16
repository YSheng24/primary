libname hw '/folders/myfolders/409';
proc contents data = hw.resitdata;
run;

data work.dat1;
set hw.resitdata;
where (tca>0 and year=5);
run;

/* 1.1 */
proc freq data=work.dat1;
tables TCA /binomial(wald wilson exact level=2) alpha=0.05;
run;


/* 1.2 */
proc reg data = work.dat1;
model tca= / cli alpha = 0.01;
run;

/* 1.3Mann- Whitney U检验 */
proc npar1way data=work.dat1 correct=NO;
class trt;
var TCA;
run;

/* 1.4 Hampel*/
proc means data=work.dat1;
var tca;
output out=Hampel_med median=medianD;
run;
PROC BOXPLOT DATA=work.dat1;
PLOT tca*mean/BOXSTYLE=SCHEMATIC;
RUN;

/* 1.5 */
proc freq data =  work.dat1;
tables EXPOSURE*TRT / chisq;
run;

/* 2.1 */
data work.dat2;
set hw.resitdata;
where (year=1 or year=3);
run;
proc transpose data=work.dat2 out=work.dat2_wide(drop=_NAME_) prefix=TCA; 
	by ID exposure trt;
	id year;
	var TCA;
run;

data work.dat2_wide;
set work.dat2_wide;
if cmiss (of TCA1 TCA3) then delete;
run;
proc print data =  work.dat2_wide;
run;
proc contents data =  work.dat2_wide;
run;
data work.dat22;
set work.dat2_wide;
if TCA1 = 0 then tca11 = 'n';
else tca11 = 'p';
if TCA3 = 0 then tca31 = 'n';
else tca31 = 'p';
run;

proc sort data = work.dat22;
by exposure;
run;

PROC FREQ DATA=work.dat22;
by exposure;
TABLES TCA11*TCA31/AGREE;
RUN;

/* 2.2 */

/* 2.3 */
proc corr data=work.dat22 kendall;
var tca1 tca3;
run;

/* 2.4 */
proc rank data=work.dat22;
out=ranked_a;
var tca1 tca3;
ranks rank_tca1 rank_tca3;
run;
proc corr data=work.dat22  kendall spearman;
var tca1 tca3;
run;


/* 3*/
data work.dat1;
set hw.resitdata;
where (tca>0 and year=5);
logtca = log(tca);
keep CENTER TRT EXPOSURE logtca;
run;

/* 3.1 */
PROC MIXED DATA=work.dat1 METHOD=TYPE3;
CLASS TRT EXPOSURE CENTER;
MODEL logtca = TRT EXPOSURE /SOLUTION OUTP=RES;
RANDOM CENTER;
RUN;
PROC MIXED DATA=work.dat1 METHOD=TYPE3;
CLASS TRT EXPOSURE CENTER;
MODEL logtca = TRT EXPOSURE /SOLUTION OUTP=RES;
RANDOM CENTER(TRT);
RUN;
/* 3.2 */
PROC MIXED DATA=work.dat1 METHOD=TYPE3 CL;
CLASS TRT EXPOSURE;
MODEL logtca = TRT EXPOSURE/SOLUTION CL;
RUN;

/* 3.3 */
PROC MIXED DATA=work.dat1 METHOD=TYPE3 CL;
CLASS TRT EXPOSURE CENTER;
MODEL logtca = TRT EXPOSURE/SOLUTION CL;
random CENTER;
RUN;

/* 3.4 */

/* 3.5 */
PROC MIXED DATA=work.dat1 METHOD=TYPE3 CL;
CLASS TRT EXPOSURE CENTER;
MODEL logtca = TRT EXPOSURE/SOLUTION CL;
random CENTER;
LSMEANS EXPOSURE/DIFF;
RUN;








