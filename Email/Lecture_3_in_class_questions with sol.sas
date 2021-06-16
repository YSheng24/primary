/* Specify the libname */

libname bh '/folders/myfolders/Boston House';

/* 1. Starting from the Boston House Pricing test data from the end of the last homework. Use proc contents to understand the structure of the data.*/

proc contents data=bh.boston_house_test_v2;
run;

/* 2.  Use proc freq to find the distribution of the quality_ind. */

proc freq data=bh.boston_house_test_v2;
table quality_ind_2/nocum;
run;

/* 3.  Use proc freq to find the distribution 
of data by chas and quality_ind.*/

proc freq data=bh.boston_house_test_v2;
table chas*quality_ind_2;
run;

/* 4. Use proc means to understand the statistical properties of the price (medv). */

proc means data = bh.boston_house;
var medv;
run;

/* 5. Use the same logic of the last homework to create fancy_house, edu_ind, and quality_ind
for the boston_house dataset. Check the how does the price (medv) change by the quality_ind. */

data bh.boston_house;
set bh.boston_house;
if rm > 6 and age < 80 then fancy_house = 'Y';
else fancy_house = 'N';
if ptratio < 20 then edu_ind = 'good';
else edu_ind = 'ok';
run;

data bh.boston_house;
set bh.boston_house;
length quality_ind $20;
if fancy_house = 'Y' and edu_ind = 'good' then quality_ind = 'Super';
else if fancy_house = 'Y' and edu_ind = 'ok' then quality_ind = 'Nice to live';
else if fancy_house = 'N' and edu_ind = 'good' then quality_ind = 'Good education';
else quality_ind = 'No good';
run;

proc means data = bh.boston_house;
class quality_ind;
var medv;
run;

/* 6. Use proc univariate to explore the statistical properties of the price (medv) and generate a histogram for it. */

proc univariate data = bh.boston_house;
var medv;
histogram;
run;


/* 7. Use proc univariate to explore the statistical properties of the price (medv) and generate a histogram for data
with quality_ind = 'Super' only. */

proc univariate data = bh.boston_house;
where quality_ind='Super';
var medv;
histogram;
run;

/* 8. Use proc univariate to explore the statistical properties of the price (medv) by quality_ind. Generate four 
histograms and compare the difference.*/

proc univariate data = bh.boston_house;
class quality_ind;
var medv;
histogram;
run;













