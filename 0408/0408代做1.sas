/* 在此path下建立0408文件夹，用于保存sas7bdat文件 */
libname hw '/folders/myfolders/0408';
/* 查看数据 */
proc print data = hw.fundamentals (obs=10);
run;
proc contents data = hw.fundamentals;
run;

proc print data = hw.market (obs=5);
run;
proc contents data = hw.market;
run;
/* 在合并数据前按照firmid和year排序 */
proc sort data = hw.fundamentals;
by firmid year;
run;
proc sort data = hw.market;
by firmid year;
run;

/* T1 */
data hw.mergedata;
merge hw.fundamentals hw.market;
by firmid year;
run;
proc contents data = hw.mergedata;
run;

proc print data = hw.mergedata (firstobs=156800 obs=156823);
run;

/* T2 */
data hw.newdata;
set hw.mergedata;
cashratio = cash/assets;
daratio = ltdebt/assets;
roa = ebitda/assets;
if dividends>0 then divpayer = 1;
else divpayer = 0;
lnassets = log(assets*1000000);
lnage = log(age);
run;
data work.data1;
set hw.newdata;
where firmid = 4115 and year = 2005;
run;
proc print data = work.data1;
title 'Value for firm with FirmID 4115 in year2005';
var cashratio daratio divpayer LnAssets lnage roa;
run;

/* T3 */
proc means data = hw.newdata N mean std;
var age assets cash ebitda equity;
run;

/* T4 */
proc corr data = hw.newdata nosimple;
var Age MarketCap Return CashRatio DARatio ROA;
run;

/* T5 */
proc ttest data = hw.newdata NOBYVAR ;
class divpayer;
var cashratio;
run;

/* T6 */
proc sort data = hw.newdata;
by year;
run;
/* The equally weighted average cash ratio across all firms by year. */
proc univariate data = hw.newdata outtable=work.data2;
var cashratio;
by year;
run;
data work.data_ewa;
set work.data2;
Eq_w_av = _sum_ / _nobs_;
run;

proc plot data = work.data_ewa;
plot Eq_w_av*year;
run;

/* The average cash ratio by year, value weighted across firms according to 
firms’ market capitalisation each year */
data work.data_jiaquan;
set hw.newdata;
quanzhong1 = cashratio* marketcap;
keep year cashratio marketcap quanzhong1;
run;
proc sort data = work.data_jiaquan;
by year;
run;

proc univariate data = work.data_jiaquan outtable=work.data3jiquan;
var quanzhong1;
by year;
run;

data work.data_vwa;
set work.data3jiquan;
va_w_av =  _sum_ / _nobs_;
run;
proc plot data = work.data_vwa;
plot va_w_av*year;
run;

/* T7 */
data hw.newdata_lag;
set hw.newdata;
lagreturn = lag(return);
run;
data work.newdata_return;
set hw.newdata_lag;
lagreturn = lag(return);
if year = 2002;
where firmid = 5540;
run;
proc print data = work.newdata_return;
TITLE 'The value of LagReturn for the firm with FirmID 5540 in year 2002';
var firmid year return lagreturn;
run;

/* T8 */
proc reg data = hw.newdata_lag;
reg1: model cashratio = lnassets;
reg2: model cashratio = lnassets lnage daratio divpayer lagreturn;
run;
proc reg data = hw.newdata_lag;
reg2: model cashratio = lnassets lnage daratio divpayer lagreturn;
run;

PROC MIXED DATA=hw.newdata_lag METHOD=TYPE3 CL;
CLASS sicindustry;
reg3: MODEL cashratio = lnassets lnage daratio divpayer lagreturn sicindustry /SOLUTION CL;
RUN;

PROC MIXED DATA=hw.newdata_lag METHOD=TYPE3 CL;
CLASS year;
reg4: MODEL cashratio = lnassets lnage daratio divpayer lagreturn year /SOLUTION CL;
RUN;

PROC MIXED DATA=hw.newdata_lag METHOD=TYPE3 CL;
CLASS sicindustry year;
reg5: MODEL cashratio = lnassets lnage daratio divpayer lagreturn sicindustry year/SOLUTION CL;
RUN;
/* proc mixed data = hw.newdata_lag; */
/* reg3: model cashratio = lnassets lnage daratio divpayer lagreturn sicindustry; */
/* estimate sicindustry; */
/* run; */
/* proc mixed data = hw.newdata_lag covtest; */
/* class sicindustry year; */
/* reg4: model cashratio = lnassets lnage daratio divpayer lagreturn sicindustry*year / ddfm=satterth; */
/* run; */

/* T9 */
data work.datn;
set hw.newdata_lag;
run;
proc reg data = hw.newdata_lag;
reg1: model cashratio = lnassets lnage daratio divpayer lagreturn /selection = forward;
reg2: model cashratio = lnassets lnage daratio divpayer lagreturn /selection = backward;
reg3: model cashratio = lnassets lnage daratio divpayer lagreturn /selection = stepwise;
run;

libname hw '/folders/myfolders/0408';
data work.alldata;
set hw.newdata_lag;
cash_log = log(cash);
where firmid = 4;
keep firmid CompanyName year cash cash_log;
run;
/* 时间序列 */
/* 平稳性检验 */
proc arima data = work.alldata;
identify var = cash_log outcov=work.chash01;
run;




/* 随机筛选110000作为训练集 */
%macro samp;
    %let seed=1234;
    %do i = 1 %to 1;  
      proc sql outobs=110000;
         create table sample&i. as
         select *
         from work.alldata
         order by ranuni(&seed);
      quit;
      %let seed = %eval(&seed+2);
    %end;
%mend samp;
%samp
;
data work.sample_train;
set work.sample1;
run;

/* 筛选60000条数据作为测试集 */
%macro samp;
    %let seed=456;
    %do i = 1 %to 1;  
      proc sql outobs=60000;
         create table sample&i. as
         select *
         from work.alldata
         order by ranuni(&seed);
      quit;
      %let seed = %eval(&seed+2);
    %end;
%mend samp;
%samp
;

data work.sample_test;
set work.sample1;
run;
/* 建模 */
proc reg data = work.sample_train;
reg1: model cashratio = lnassets lnage daratio divpayer lagreturn /selection = forward;
reg2: model cashratio = lnassets lnage daratio divpayer lagreturn /selection = backward;
reg3: model cashratio = lnassets lnage daratio divpayer lagreturn /selection = stepwise;
run;
proc reg data = work.sample_train;
model cashratio = lnassets lnage daratio divpayer lagreturn/selection = stepwise;
run;
proc reg data = work.sample_train;
model cashratio = lnassets lnage daratio divpayer lagreturn/selection = stepwise;
run;

data work.sample_test_pre;
set work.sample_test;
cashratio_pre = 0.26232+0.00130*lnassets-0.01743*lnage-0.27992*daratio-0.08728*divpayer+0.00786*lagreturn;
run;





/* 用于筛选不同部分但运行太慢 */
/* proc sql; */
/* select a.*, b.*  */
/* from work.alldata as a  */
/* LEFT JOIN  */
/* work.sample1 as b */
/* ON a.firmid ^=b.firmid and a.year ^= b.year; */
/* quit; */
