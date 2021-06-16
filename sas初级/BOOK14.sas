libname hw '/folders/myfolders/sas初级';
options validvarname= any;
proc format;
value brandf 1 = '联想' 2 = '惠普' 3 = '宏基';
value memoryf 1 = '512MB' 2 = '1024MB' 3 = '4GHZ';
value cpuf 1 = '1GHZ' 2 = '2GHZ' 3 = '4GHZ';
value pricef 1 = '4200RMB' 2 = '4800RMB' 3 = '5600RMB';
run;

%mktex(3 3 3 3,n=18,seed=2011);
%mktlab(vars=brand memory cpu price,out=design,
statements=format brand brandf6. memory memoryf6. cpu cpuf6. price pricef9.);
%mkteval;
proc print data = hw.design;
run;
data score;
input rank @@;
cards;
3 5 5 1 4 2 3 1 3 5 2 4 3 2 2 1 4 4
;
data hw.computer;
merge score hw.design;
run;
proc print data = hw.computer;
run;

