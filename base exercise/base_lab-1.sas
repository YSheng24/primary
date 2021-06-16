
/* Example 1 */
DATA temp1;
  input subj 1-4 gender 6 height 8-9 weight 11-13;
  DATALINES;
1024 1 65 125
1167 1 68 140
1168 2 68 190
1201 2 72 190
1302 1 63 115
  ;
RUN;
 
PROC PRINT data=temp1;
  title 'Output dataset: TEMP1';
RUN;

/* Example 2 */
libname ex '/folders/myfolders/base exercise'; *Specifies the SAS data library (directory);
 
DATA ex.temp2;
  input subj 1-4 gender 6 height 8-9 weight 11-13;
  DATALINES;
1024 1 65 125
1167 1 68 140
1168 2 68 190
1201 2 72 190
1302 1 63 115
  ;
RUN;
 
PROC PRINT data=ex.temp2;
  title 'Output dataset: STAT480.TEMP2';
RUN;

/* Example 3 */

DATA temp3;
  infile '/folders/myfolders/base exercise/temp3.dat';
  input subj 1-4 gender 6 height 8-9 weight 11-13;
RUN;
 
PROC PRINT data=temp3;
  title 'Output dataset: TEMP3';
RUN;

/* Example 4 */

DATA temp;
  input init $ 6 f_name $ 6-16 l_name $ 18-23
        weight 30-32 height 27-28;
  CARDS;
1024 Alice       Smith  1 65 125
1167 Maryann     White  1 68 140
1168 Thomas      Jones  2    190
1201 Benedictine Arnold 2 68 190
1302 Felicia     Ho     1 63 115
  ;
RUN;
 
 
PROC PRINT data=temp;
  title 'Output dataset: TEMP';
RUN;


/* Example 5 */
DATA grades;
	input name $ 1-15 e1 e2 e3 e4 p1 f1;
	* add up each students four exam scores
	  and store it in examtotal;
	examtotal = e1 + e2 + e3 + e4;
	DATALINES;
Alexander Smith  78 82 86 69  97 80
John Simon       88 72 86  . 100 85
Patricia Jones   98 92 92 99  99 93
Jack Benedict    54 63 71 49  82 69
Rene Porter     100 62 88 74  98 92
;
RUN;
 
PROC PRINT data = grades;
	var name e1 e2 e3 e4 examtotal;
RUN;


/* Example 6 */
DATA grades;
	input name $ 1-15 e1 e2 e3 e4 p1 f1;
	e2 = e2 + 8;  * add 8 to each student's
	                second exam score (e2);
	DATALINES;
Alexander Smith  78 82 86 69  97 80
John Simon       88 72 86  . 100 85
Patricia Jones   98 92 92 99  99 93
Jack Benedict    54 63 71 49  82 69
Rene Porter     100 62 88 74  98 92
;
RUN;
 
PROC PRINT data = grades;
	var name e1 e2 e3 e4 p1 f1;
RUN;


/* Example 7 */
DATA grades;
	input name $ 1-15 e1 e2 e3 e4 p1 f1;
	final = 0.6*((e1+e2+e3+e4)/4) + 0.2*p1 + 0.2*f1;
	DATALINES;
Alexander Smith  78 82 86 69  97 80
John Simon       88 72 86  . 100 85
Patricia Jones   98 92 92 99  99 93
Jack Benedict    54 63 71 49  82 69
Rene Porter     100 62 88 74  98 92
;
RUN;
 
PROC PRINT data = grades;
	var name e1 e2 e3 e4 p1 f1 final;
RUN;




/* Example 8 */

DATA grades;
	input name $ 1-15 e1 e2 e3 e4 p1 f1;
	* calculate the average by definition;
	avg1 = (e1+e2+e3+e4)/4;
	* calculate the average using the mean function;
	avg2 = mean(e1,e2,e3,e4);
	DATALINES;
Alexander Smith  78 82 86 69  97 80
John Simon       88 72 86  . 100 85
Patricia Jones   98 92 92 99  99 93
Jack Benedict    54 63 71 49  82 69
Rene Porter     100 62 88 74  98 92
;
RUN;
 
PROC PRINT data = grades;
	var name e1 e2 e3 e4 avg1 avg2;
RUN;





/* Example 9*/
DATA grades;
	input name $ 1-15 e1 e2 e3 e4 p1 f1;
	*calculate the average using the mean function
	 and then round it to the nearest digit;
	avg = round(mean(e1,e2,e3,e4),1);
	DATALINES;
Alexander Smith   78 82 86 69  97 80
John Simon        88 72 86  . 100 85
Patricia Jones    98 92 92 99  99 93
Jack Benedict     54 63 71 49  82 69
Rene Porter      100 62 88 74  98 92
;
RUN;
 
PROC PRINT data = grades;
	var name e1 e2 e3 e4 avg;
RUN;



/* Example 10*/

DATA grades;
	input name $ 1-15 e1 e2 e3 e4 p1 f1;
	* calculate the average using the mean function;
	avg = mean(e1,e2,e3,e4); 
	* if the average is less than 65 indicate failed,
	  otherwise indicate passed;
	if (avg < 65) then status = 'Failed';
	else status = 'Passed';
	DATALINES;
Alexander Smith  78 82 86 69  97 80
John Simon       88 72 86  . 100 85
Patricia Jones   98 92 92 99  99 93
Jack Benedict    54 63 71 49  82 69
Rene Porter     100 62 88 74  98 92
;
RUN;
 
PROC PRINT data = grades;
	var name e1 e2 e3 e4 avg status;
RUN;


/* Example 11*/

DATA grades;
	input name $ 1-15 e1 e2 e3 e4 p1 f1;
	* if the first exam is less than 65 indicate failed;
	if (e1 < 65) then status = 'Failed';
	DATALINES;
Alexander Smith  78 82 86 69  97 80
John Simon       88 72 86  . 100 85
Patricia Jones   98 92 92 99  99 93
Jack Benedict    54 63 71 49  82 69
Rene Porter     100 62 88 74  98 92
;
RUN;
 
PROC PRINT data = grades;
	var name e1 status;
RUN;


/* Example 12*/

DATA grades;
	input name $ 1-15 e1 e2 e3 e4 p1 f1;
	if p1 in (98, 99, 100) then project = 'Excellent';
	DATALINES;
Alexander Smith  78 82 86 69  97 80
John Simon       88 72 86  . 100 85
Patricia Jones   98 92 92 99  99 93
Jack Benedict    54 63 71 49  82 69
Rene Porter     100 62 88 74  98 92
;
RUN;
 
PROC PRINT data = grades;
	var name p1 project;
RUN;


/* Example 13*/

DATA grades;
	input name $ 1-15 e1 e2 e3 e4 p1 f1;
	* if the first exam is less than 65 indicate failed;
	if (e1 < 65) then status = 'Failed';
	* otherwise indicate passed;
	else status = 'Passed';
	DATALINES;
Alexander Smith  78 82 86 69  97 80
John Simon       88 72 86  . 100 85
Patricia Jones   98 92 92 99  99 93
Jack Benedict    54 63 71 49  82 69
Rene Porter     100 62 88 74  98 92
;
RUN;
 
PROC PRINT data = grades;
	var name e1 status;
RUN;



/* Example 14*/
DATA grades;
    length status $ 6;
	input name $ 1-15 e1 e2 e3 e4 p1 f1;
	* if the fourth exam is missing indicate missing;
	* else if the fourth exam is less than 65 indicate failed;
	* otherwise indicate passed;
	     if (e4 = .)  then status = ' ';
	else if (e4 < 65) then status = 'Failed';
	else                   status = 'Passed';
	DATALINES;
Alexander Smith  78 82 86 69  97 80
John Simon       88 72 86  . 100 85
Patricia Jones   98 92 92 99  99 93
Jack Benedict    54 63 71 49  82 69
Rene Porter     100 62 88 74  98 92
;
RUN;
 
PROC PRINT data = grades;
	var name e4 status;
RUN;



/* Example 15*/
DATA grades;
    length overall $ 10;
   	input name $ 1-15 e1 e2 e3 e4 p1 f1;
	avg = round((e1+e2+e3+e4)/4,0.1);
		 if (avg = .)                   then overall = 'Incomplete';
	else if (avg >= 90)                 then overall = 'A';
	else if (avg >= 80) and (avg < 90)  then overall = 'B';
	else if (avg >= 70) and (avg < 80)  then overall = 'C';
	else if (avg >= 65) and (avg < 70)  then overall = 'D';
	else if (avg < 65)                  then overall = 'F';	
	DATALINES;
Alexander Smith  78 82 86 69  97 80
John Simon       88 72 86  . 100 85
Patricia Jones   98 92 92 99  99 93
Jack Benedict    54 63 71 49  82 69
Rene Porter     100 62 88 74  98 92
;
RUN;
 
PROC PRINT data = grades;
	var name avg overall;
RUN;


/* Example 16*/

DATA grades;
    length overall $ 10;
   	input name $ 1-15 e1 e2 e3 e4 p1 f1;
	avg = round((e1+e2+e3+e4)/4,0.1);
		 if (avg EQ .)         then overall = 'Incomplete';
	else if (90 LE avg LE 100) then overall = 'A';
	else if (80 LE avg LT  90) then overall = 'B';
	else if (70 LE avg LT  80) then overall = 'C';
	else if (65 LE avg LT  70) then overall = 'D';
	else if (0  LE avg LT  65) then overall = 'F';
	DATALINES;
Alexander Smith  78 82 86 69  97 80
John Simon       88 72 86  . 100 85
Patricia Jones   98 92 92 99  99 93
Jack Benedict    54 63 71 49  82 69
Rene Porter     100 62 88 74  98 92
;
RUN;
 
PROC PRINT data = grades;
	var name avg overall;
RUN;

/* Example 17*/
DATA grades;
   	input name $ 1-15 e1 e2 e3 e4 p1 f1;
	avg = round((e1+e2+e3+e4)/4,0.1);
		 if    ((e1 < e3) and (e1 < e4)) 
            or ((e2 < e3) and (e2 < e4)) then adjavg = avg + 2;
    else adjavg = avg;
	DATALINES;
Alexander Smith  78 82 86 69  97 80
John Simon       88 72 86  . 100 85
Patricia Jones   98 92 92 99  99 93
Jack Benedict    54 63 71 49  82 69
Rene Porter     100 62 88 74  98 92
;
RUN;
 
PROC PRINT data = grades;
	var name e1 e2 e3 e4 avg adjavg;
RUN;

/* Example 18*/
DATA grades;
    length action $ 7
           action2 $ 7;
    input name $ 1-15 e1 e2 e3 e4 p1 f1 status $;
	     if (status = 'passed') then action = 'none';
    else if (status = 'failed') then action = 'contact';
	else if (status = 'incomp') then action = 'contact';
	     if (upcase(status) = 'PASSED') then action2 = 'none';
	else if (upcase(status) = 'FAILED') then action2 = 'contact';
	else if (upcase(status) = 'INCOMP') then action2 = 'contact';
	DATALINES;
Alexander Smith  78 82 86 69  97 80 passed
John Simon       88 72 86  . 100 85 incomp
Patricia Jones   98 92 92 99  99 93 PAssed
Jack Benedict    54 63 71 49  82 69 FAILED
Rene Porter     100 62 88 74  98 92 PASSED
;
RUN;
 
PROC PRINT data = grades;
	var name status action action2;
RUN;


/* Example 18*/
DATA grades;
   	input name $ 1-15 e1 e2 e3 e4 p1 f1;
	if e4 = . then do;
	    e4 = 0;
		notify = 'YES';
	end;
	DATALINES;
Alexander Smith  78 82 86 69  97 80
John Simon       88 72 86  . 100 85
Patricia Jones   98 92 92 99  99 93
Jack Benedict    54 63 71 49  82 69
Rene Porter     100 62 88 74  98 92
;
RUN;
 
PROC PRINT data = grades;
	var name e1 e2 e3 e4 p1 f1 notify;
RUN;
