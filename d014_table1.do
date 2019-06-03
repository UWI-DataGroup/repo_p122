** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d014_table1, replace

**  GENERAL DO-FILE COMMENTS
**  program:      	d014_table1.do
**  project:      	LE summary dataset: analysis
**  author:       	HAMBLETON \ 02-NOV-2014
**  task:         	TABLE 2 --> MRs + min/max range
 
** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200

/*

** Caribbean rates (AV, MIN, MAX)
** UNADJUSTED
use "data\result\car_003\caribbean_data", clear

** Country with lowest and highest mortality rate (BY YEAR)
forval x = 2000(9)2009 {
	bysort cod sex: egen rmin`x' = min(rateadj`x')
	bysort cod sex: egen rmax`x' = max(rateadj`x')
	recast double rmin`x'
	recast double rmax`x'
	replace rateadj`x' = round(rateadj`x', 0.1)
	replace rmin`x' = round(rmin`x', 0.1)
	replace rmax`x' = round(rmax`x', 0.1)	
	gen t1=cid if rateadj`x'==rmin`x'
	bysort cod sex: egen cmin`x' = min(t1)
	gen t2=cid if rateadj`x'==rmax`x'
	bysort cod sex: egen cmax`x' = max(t2)
	drop t1 t2
	label values cmin`x' cid
	label values cmax`x' cid
	}
** Change in RR / RD between 2000 and 2009
gen mrc = rateadj2009 - rateadj2000
** Percentage change in RR / RD between 2000 and 2009
gen mrcp = (mrc/rateadj2000)*100
** Average regional values 
table cod if sex==1 & cid==1000, c(mean rateadj2000 mean rateadj2009 mean mrc mean mrcp) format(%9.1f) 
table cod if sex==2 & cid==1000, c(mean rateadj2000 mean rateadj2009 mean mrc mean mrcp) format(%9.1f) 
table cod if sex==3 & cid==1000, c(mean rateadj2000 mean rateadj2009 mean mrc mean mrcp) format(%9.1f) 
** Regional min and max values
egen tag = tag(cod sex)
format %9.0f rmin2000
format %9.0f rmin2009
format %9.0f rmax2000
format %9.0f rmax2009
sort sex cod
list sex cod cmin2000 cmax2000 rmin2000 rmax2000 if tag==1, clean noobs
list sex cod cmin2009 cmax2009 rmin2009 rmax2009 if tag==1, clean noobs



** Caribbean rates (AV, MIN, MAX)
** QUALITY-ADJUSTED
use "data\result_qa\car_003\caribbean_data", clear

** Save regional average
preserve
	keep if cid==1000
	save `reg1', replace
restore

** Country with lowest and highest mortality rate (BY YEAR)
forval x = 2000(9)2009 {
	bysort cod sex: egen rmin`x' = min(rateadj`x')
	bysort cod sex: egen rmax`x' = max(rateadj`x')
	recast double rmin`x'
	recast double rmax`x'
	replace rateadj`x' = round(rateadj`x', 0.1)
	replace rmin`x' = round(rmin`x', 0.1)
	replace rmax`x' = round(rmax`x', 0.1)	
	gen t1=cid if rateadj`x'==rmin`x'
	bysort cod sex: egen cmin`x' = min(t1)
	gen t2=cid if rateadj`x'==rmax`x'
	bysort cod sex: egen cmax`x' = max(t2)
	drop t1 t2
	label values cmin`x' cid
	label values cmax`x' cid
	}
** Change in RR / RD between 2000 and 2009
gen mrc = rateadj2009 - rateadj2000
** Percentage change in RR / RD between 2000 and 2009
gen mrcp = (mrc/rateadj2000)*100
** Average regional values 
table cod if sex==1 & cid==1000, c(mean rateadj2000 mean rateadj2009 mean mrc mean mrcp) format(%9.1f) 
table cod if sex==2 & cid==1000, c(mean rateadj2000 mean rateadj2009 mean mrc mean mrcp) format(%9.1f) 
table cod if sex==3 & cid==1000, c(mean rateadj2000 mean rateadj2009 mean mrc mean mrcp) format(%9.1f) 
** Regional min and max values
egen tag = tag(cod sex)
format %9.0f rmin2000
format %9.0f rmin2009
format %9.0f rmax2000
format %9.0f rmax2009
** 2000
sort sex cod
list cod sex cmin2000 cmax2000 rmin2000 rmax2000 if tag==1, noobs clean
** 2009
list cod sex cmin2009 cmax2009 rmin2009 rmax2009 if tag==1,  noobs clean

*/


** US rates  (AV, MIN, MAX)
use "data\result\us_001\us_data", clear
rename measure cod
label define cod 	2 "all-cause" 3 "cancer" 4 "cvd/diabetes" 5 "heart" 6 "stroke" 7 "diabetes",modify
label values cod cod
rename i2000 rateadj2000
rename i2009 rateadj2009
rename state cid

** Country with lowest and highest mortality rate (BY YEAR)
forval x = 2000(9)2009 {
	bysort race cod sex: egen rmin`x' = min(rateadj`x')
	bysort race cod sex: egen rmax`x' = max(rateadj`x')
	recast double rmin`x'
	recast double rmax`x'
	replace rateadj`x' = round(rateadj`x', 0.1)
	replace rmin`x' = round(rmin`x', 0.1)
	replace rmax`x' = round(rmax`x', 0.1)	
	gen t1=cid if rateadj`x'==rmin`x'
	bysort race cod sex: egen cmin`x' = min(t1)
	gen t2=cid if rateadj`x'==rmax`x'
	bysort race cod sex: egen cmax`x' = max(t2)
	drop t1 t2
	label values cmin`x' cid
	label values cmax`x' cid
	}
keep if cod>1 & (cod<=7)
** Change in RR / RD between 2000 and 2009
gen mrc = rateadj2009 - rateadj2000
** Percentage change in RR / RD between 2000 and 2009
gen mrcp = (mrc/rateadj2000)*100
** Average regional values (ALL RACES)
table cod if race==3 & sex==1 & cid==0, c(mean rateadj2000 mean rateadj2009 mean mrc mean mrcp) format(%9.1f)
table cod if race==3 & sex==2 & cid==0, c(mean rateadj2000 mean rateadj2009 mean mrc mean mrcp) format(%9.1f)
table cod if race==3 & sex==3 & cid==0, c(mean rateadj2000 mean rateadj2009 mean mrc mean mrcp) format(%9.1f)
** Regional min and max values
egen tag = tag(race cod sex)
sort race cod sex
format %9.0f rmin2000
format %9.0f rmin2009
format %9.0f rmax2000
format %9.0f rmax2009
sort sex cod
list race cod sex cmin2000 cmax2000 rmin2000 rmax2000 if tag==1 & race==3, clean noobs
list race cod sex cmin2009 cmax2009 rmin2009 rmax2009 if tag==1 & race==3, clean noobs
