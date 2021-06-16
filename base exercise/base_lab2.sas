
/* Example 1 */
LIBNAME icdb '/folders/myfolders/base exercise';
 
PROC CONTENTS data = icdb.hem2 position;
RUN;
 
PROC PRINT data = icdb.hem2 (OBS = 15);
RUN;

PROC MEANS data = icdb.hem2 ;
RUN;

PROC MEANS data = icdb.hem2;
   var wbc rbc hemog hcrit mcv mch mchc;
RUN;

PROC MEANS data = icdb.hem2 MAXDEC = 2;
   var wbc rbc hemog hcrit mcv mch mchc;
RUN;

PROC MEANS data=icdb.hem2  maxdec=2 sum range median;
    var rbc;
RUN;

PROC MEANS data=icdb.hem2  maxdec=2;
      var rbc wbc hcrit;
    class hosp;
RUN;
  
  
/* Example 2 */  
DATA parks;
     input ParkName $ 1-21 Type $ Region $ Museums Camping;
     DATALINES;
Dinosaur              NM West 2  6
Ellis Island          NM East 1  0
Everglades            NP East 5  2
Grand Canyon          NP West 5  3
Great Smoky Mountains NP East 3 10
Hawaii Volcanoes      NP West 2  2
Lava Beds             NM West 1  1
Statue of Liberty     NM East 1  0
Theodore Roosevelt    NP West 2  2
Yellowstone           NP West 9 11
Yosemite              NP West 2 13
	 ;
RUN;
 
PROC MEANS data = parks maxdec = 0 sum;
   var museums camping;
   class type region;
RUN;



/* Example 3 */  
PROC SORT data = parks out = srtdparks;
   by type region;
RUN;
PROC MEANS data = srtdparks  maxdec = 0 sum min max;
   var museums camping;
   by type region;
RUN;


/* Example 4 */  

PROC MEANS data=icdb.hem2 NOPRINT;
      var rbc wbc hcrit;
    class hosp;
    output out = icdb.hospsummary
           mean = MeanRBC MeanWBC MeanHCRIT
         median = MedianRBC MedianWBC MedianHCRIT;
RUN;
  
  PROC PRINT;
    title 'Hospital Statistics';
  RUN;



/* Example 5 */  
PROC SORT data = icdb.hem2 out = srtdhem2;
   by hosp;
RUN;
 
PROC MEANS data=srtdhem2 NOPRINT;
    var rbc wbc hcrit;
	by hosp;
	output out = hospsummary 
	       mean = MeanRBC MeanWBC MeanHCRIT
		   median = MedianRBC MedianWBC MedianHCRIT;
RUN;
 
PROC PRINT;
  title 'Hospital Statistics';
RUN;

/* Example 6 */ 
PROC UNIVARIATE data = icdb.hem2;
   title 'Univariate Analysis of RBC';
   var rbc;
RUN;

PROC UNIVARIATE data = icdb.hem2 NORMAL PLOT;
   title 'Univariate Analysis of RBC with NORMAL and PLOT Options';
   var rbc;
RUN;


/* Example 7 */ 
 PROC FREQ data=icdb.back;
    title 'Frequency Count of SEX: No Cumulative Stats';
    tables sex/nocum;
 RUN;


 PROC FREQ data=icdb.back page;
    title 'Frequency Count of SEX and RACE';
    tables sex race;
 RUN;

PROC FREQ data=icdb.back;
   title 'Crosstabulation of Education Level and Sex';
   tables ed_level*sex;
RUN;