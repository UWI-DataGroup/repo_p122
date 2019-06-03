** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d015_table3_new_nes, replace

**  GENERAL DO-FILE COMMENTS
**  program:      	d015_table3_new_nes.do
**  project:      	
**  author:       	HAMBLETON \ 22-NOV-2015
**  task:         	English-speaking caribbean contribution to Table 3

** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200

** Premature mortality (below 75 years) is our primary outcome measure. 
** We present these data by mortality group, for women, men, and women + men combined
** And for 2 time period (1999-2001) and (2009-2011)

** -------------------------------------------------------------------------------------
** Tabulate Premature Mortality 
** 1999-2001
** PREMATURE YRS (0-74)
** -------------------------------------------------------------------------------------
tempfile fall fnotall

tempfile nes8_a nes8_74a nes8_aq nes8_74aq nes5_a nes5_74a nes5_aq nes5_74aq

** Load and merge TWO datasets (all ages, 0-74)

** -------------------------------------------------------------------------------------
** Non-English-speaking Caribbean (N=8 countries). Age adjusted. Datasets 18 and 20 
** -------------------------------------------------------------------------------------
** Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_18_9995_a", clear
save `nes8_a', replace
** (0-74 yrs) Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_20_9995_74_a", clear
cap rename rateadj rateadj74
save `nes8_74a', replace

** -------------------------------------------------------------------------------------
** Non-English-speaking Caribbean (N=8 countries). Age and quality adjusted. Datasets 19 and 21 
** -------------------------------------------------------------------------------------
** Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_19_9995_aq", clear
save `nes8_aq', replace
** (0-74 yrs) Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_21_9995_74_aq", clear
cap rename rateadj rateadj74
save `nes8_74aq', replace

** -------------------------------------------------------------------------------------
** Non-English-speaking Caribbean (N=5 countries). Age adjusted. Datasets 30 and 32 
** -------------------------------------------------------------------------------------
** Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_30_9993_a", clear
save `nes5_a', replace
** (0-74 yrs) Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_32_9993_74_a", clear
cap rename rateadj rateadj74
save `nes5_74a', replace

** -------------------------------------------------------------------------------------
** Non-English-speaking Caribbean (N=5 countries). Age and quality adjusted. Datasets 31 and 33 
** -------------------------------------------------------------------------------------
** Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_31_9993_aq", clear
save `nes5_aq', replace
** (0-74 yrs) Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_33_9993_74_aq", clear
cap rename rateadj rateadj74
save `nes5_74aq', replace


** -------------------------------------------------------------------------------------
** non ENGLISH-SPEAKING AGE ADJUSTED
** Merge all-age and 0-74 mortality
** -------------------------------------------------------------------------------------
tempfile t1 t2 t3 t4

use `nes5_a', clear
merge 1:1 cid decade cod sex using `nes5_74a'
gen dataset = 1
label define dataset 1 "nES5-a" 2 "nES5-aq" 3 "nES8-a" 4 "nES8-aq"
label values dataset dataset
drop _merge
save `t1'

use `nes5_aq', clear
merge 1:1 cid decade cod sex using `nes5_74aq'
gen dataset = 2
drop _merge
save `t2'

use `nes8_a', clear
merge 1:1 cid decade cod sex using `nes8_74a'
gen dataset = 3
drop _merge
save `t3'

use `nes8_aq', clear
merge 1:1 cid decade cod sex using `nes8_74aq'
gen dataset = 4
drop _merge
save `t4'

use `t1', clear
append using `t2'
append using `t3'
append using `t4'


** Keep All-cause (2) and CVD-Diabetes (4) mortality 
keep if cod==2 | cod==4




** INDICATOR 1 and 2 - premature mortality within mortality group
** Indicator 1 --> all-cause premature mortality
** Indicator 2 --> cvd/diabetes premature mortality

tempfile ind_file1

** Percentage premature (percentage of ALL-AGE deaths due to deaths 0-74 years)
gen pprem = (rateadj74/rateadj)*100
format pprem %9.1f

** Reshape to wide (by decade) 1999-2001 = 1, 2009-2011=2
keep rateadj rateadj74 pprem cid cod sex decade dataset
reshape wide rateadj rateadj74 pprem, i(dataset cid cod sex) j(decade)

** THE OBSERVED , PRIMARY MEASURE --> N=8 AGE-ADJUSTED
keep if cid==1000 & cod==4
gen t1 = rateadj741 if dataset==1
gen t2 = rateadj742 if dataset==1
bysort sex: egen obs741 = min(t1) 
bysort sex: egen obs742 = min(t2) 

gen diff_mr1 = rateadj741 - obs741
gen diff_mr2 = rateadj742 - obs742
gen perc_mr1 = ((rateadj741 - obs741)/rateadj741)*100
gen perc_mr2 = ((rateadj742 - obs742)/rateadj741)*100

format diff_mr1 %9.1f
format diff_mr2 %9.1f
format perc_mr1 %9.1f
format perc_mr2 %9.1f

** THE LISTING FOR TABULATION (TABLE 3)
sort sex dataset
list sex dataset rateadj741 diff_mr1 perc_mr1 rateadj742 diff_mr2 perc_mr2, clean noobs

