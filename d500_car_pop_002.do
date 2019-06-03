** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\a054_car_pop_002, replace

**  GENERAL DO-FILE COMMENTS
**  program:      a054_car_pop_002.do
**  project:      
**  author:       HAMBLETON \ 12-SEP-2015
**  task:         
 
** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200

** Load the Unprepared UN WPP Population dataset
use "data\carib_pop_001", clear

* A little dataset house-keeping / file preparation
rename LocID cidun 
label var cidun "UN country ID"

** Country ID using the WHO Mortality Database codes
** UN country coding system not same as UN. Code the 1:1 relationship
gen cid = .

replace cid = 2010 if cidun==28		/* Antigua & Barbuda*/
replace cid = 2025 if cidun==533	/* Aruba*/
replace cid = 2030 if cidun==44		/* Bahamas */
replace cid = 2040 if cidun==52		/* Barbados */
replace cid = 2045 if cidun==84		/* Belize */
replace cid = 2150 if cidun==192 	/* Cuba */
replace cid = 2170 if cidun==214 	/* Dominican Republic */
replace cid = 2210 if cidun==254 	/* French Guiana */
replace cid = 2230 if cidun==308 	/* Grenada */
replace cid = 2240 if cidun==312 	/* Guadeloupe */
replace cid = 2260 if cidun==328 	/* Guyana */
replace cid = 2270 if cidun==332 	/* Haiti */
replace cid = 2290 if cidun==388 	/* Jamaica */
replace cid = 2300 if cidun==474 	/* Martinique */
replace cid = 2380 if cidun==630 	/* Puerto Rico */
replace cid = 2400 if cidun==662 	/* Saint Lucia */
replace cid = 2420 if cidun==670 	/* Saint Vincent and Grenadines */
replace cid = 2430 if cidun==740 	/* Suriname */
replace cid = 2440 if cidun==780 	/* Trinidad and Tobago */
replace cid = 2455 if cidun==850 	/* USVI */

label var cid "WHO country codes"
#delimit ;
label define cid	 	
						2010 "Antigua and Barbuda"
						2025 "Aruba"
						2030 "Bahamas"
						2040 "Barbados"
						2045 "Belize"
						2150" Cuba"
						2170 "Dominican Republic"
						2210 "French Guiana"
						2230 "Grenada"
						2240 "Guadeloupe"
						2260 "Guyana"
						2270 "Haiti"
						2290 "Jamaica"
						2300 "Martinique"
						2380 "Puerto Rico"
						2400 "St.Lucia"
						2420 "St.Vincent & Grenadines"
						2430 "Suriname"
						2440 "Trinidad and Tobago"
						2455 "USVI", modify;
label values cid cid;						
#delimit cr

** Sex
gen sex = .
replace sex = 1 if Sex=="Female"
replace sex = 2 if Sex=="Male"
replace sex = 3 if Sex=="Both"
drop if sex==3
label var sex "Sex"
label define sex 1 "female" 2 "male" 3 "both",modify
label values sex sex

** Year
gen year = int(MidPeriod)
label var year "Population year: this is year midpoint population"
keep if year>=1990 & year<=2012

** Age variables
rename AgeGrp ag
rename AgeGrpStart ag_start
rename AgeGrpSpan ag_span
label var ag "Age grouping: # groups vary by country + year"
label var ag_start "The starting age of the age group"
label var ag_span "The width of the age group interval"

** Population
rename Value pop
replace pop = pop*1000
label var pop "Population totals"

drop Location VarID Variant Time Sex SexID MidPeriod
order cid cidun sex year ag ag_start ag_span pop

label data "Caribbean population using UN WPP (2012 rev): 1990-2012 (Long format)"
save "data\input\who_md\pop_aging\carib_pop_002", replace
