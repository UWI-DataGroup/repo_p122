** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d015_table2_carib, replace

**  GENERAL DO-FILE COMMENTS
**  program:      	d015_table2_carib.do
**  project:      	
**  author:       	HAMBLETON \ 15-SEP-2015
**  task:         	US contribution to Table 2
**				% Premature Mortality
**				% of ALL-AGE deaths due to deaths 0-74 years

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

** Load and merge TWO datasets (all ages, 0-74)

** -------------------------------------------------------------------------------------
** English-speaking Caribbean (N=10 countries). Age adjusted. Datasets 12 and 14 
** -------------------------------------------------------------------------------------
** Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_12_9996_a", clear
save `fall', replace
** (0-74 yrs) Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_14_9996_74_a", clear
rename rateadj rateadj74
save `fnotall', replace

** -------------------------------------------------------------------------------------
** English-speaking Caribbean (N=10 countries). Age and quality adjusted. Datasets 13 and 15 
** -------------------------------------------------------------------------------------
** Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_13_9996_aq", clear
save `fall', replace
** (0-74 yrs) Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_15_9996_74_aq", clear
rename rateadj rateadj74
save `fnotall', replace

** -------------------------------------------------------------------------------------
** Non-English-speaking Caribbean (N=8 countries). Age adjusted. Datasets 18 and 20 
** -------------------------------------------------------------------------------------
** Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_18_9995_a", clear
save `fall', replace
** (0-74 yrs) Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_20_9995_74_a", clear
rename rateadj rateadj74
save `fnotall', replace

** -------------------------------------------------------------------------------------
** Non-English-speaking Caribbean (N=8 countries). Age and quality adjusted. Datasets 19 and 21 
** -------------------------------------------------------------------------------------
** Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_19_9995_aq", clear
save `fall', replace
** (0-74 yrs) Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_21_9995_74_aq", clear
rename rateadj rateadj74
save `fnotall', replace


** RESTRICTED TO UNDERCOUNT < 25%

tempfile fall_es fnotall_es fall_nes fnotall_nes fall_esq fnotall_esq fall_nesq fnotall_nesq

** -------------------------------------------------------------------------------------
** English-speaking Caribbean (N=8 countries). Age adjusted. Datasets 24 and 26 
** -------------------------------------------------------------------------------------
** Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_24_9994_a", clear
save `fall_es', replace
** (0-74 yrs) Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_26_9994_74_a", clear
rename rateadj rateadj74
save `fnotall_es', replace

** -------------------------------------------------------------------------------------
** English-speaking Caribbean (N=8 countries). Age and quality adjusted. Datasets 25 and 27 
** -------------------------------------------------------------------------------------
** Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_25_9994_aq", clear
save `fall_esq', replace
** (0-74 yrs) Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_27_9994_74_aq", clear
rename rateadj rateadj74
save `fnotall_esq', replace

** -------------------------------------------------------------------------------------
** Non-English-speaking Caribbean (N=5 countries). Age adjusted. Datasets 30 and 32 
** -------------------------------------------------------------------------------------
** Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_30_9993_a", clear
save `fall_nes', replace
** (0-74 yrs) Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_32_9993_74_a", clear
rename rateadj rateadj74
save `fnotall_nes', replace

** -------------------------------------------------------------------------------------
** Non-English-speaking Caribbean (N=5 countries). Age and quality adjusted. Datasets 31 and 33 
** -------------------------------------------------------------------------------------
** Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_31_9993_aq", clear
save `fall_nesq', replace
** (0-74 yrs) Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_33_9993_74_aq", clear
rename rateadj rateadj74
save `fnotall_nesq', replace



** -------------------------------------------------------------------------------------
** ENGLISH-SPEAKING AGE ADJUSTED
** Merge all-age and 0-74 mortality
** -------------------------------------------------------------------------------------
use `fall_es', clear
merge 1:1 cid decade cod sex using `fnotall_es'
drop _merge

** Keep All-cause (2) and CVD-Diabetes (4) mortality 
keep if cod==2 | cod==4


** INDICATOR 1 and 2 - premature mortality within mortality group
** Indicator 1 --> all-cause premature mortality
** Indicator 2 --> cvd/diabetes premature mortality
preserve
	tempfile ind_file1

	** Percentage premature (percentage of ALL-AGE deaths due to deaths 0-74 years)
	gen pprem = (rateadj74/rateadj)*100
	format pprem %9.1f

	** Reshape to wide (by decade) 1999-2001 = 1, 2009-2011=2
	keep rateadj rateadj74 pprem cid cod sex decade
	reshape wide rateadj rateadj74 pprem, i(cid cod sex) j(decade)

	** Absolute change
	gen ac = pprem2 - pprem1
	format ac %9.1f

	** Relative change
	gen rc = ((pprem2 - pprem1) / pprem1)*100
	format rc %9.1f

	** TABLE 2 has 4 indicators
	gen indicator = .
	replace indicator = 1 if cod==2
	replace indicator = 2 if cod==4
	label define indicator 1 "all-cause premature" 2 "cvd/diab premature" 3 "cvd/diab all ages" 4 "cvd/diab 0-74"
	label values indicator indicator

	save `ind_file1'
restore


** INDICATOR 3 and 4 - all-cause mortality due to CVD=diab mortality
** Indicator 3 --> all-cause mortality due to CVD/diabetes mortality (all-ages)
** Indicator 4 --> all-cause mortality due to CVD/diabetes mortality (0-74)
preserve
	tempfile ind_file2
	
	** Reshape to wide (by decade) 1999-2001 = 1, 2009-2011=2
	keep rateadj rateadj74 cid sex cod decade
	rename rateadj rateadj100

	reshape long rateadj, i(cid cod sex decade) j(agerange)
	reshape wide rateadj , i(cid sex agerange decade) j(cod)
	reshape wide rateadj2 rateadj4 , i(cid sex agerange) j(decade)

	** % of ALL-CAUSE due to CVD-DIAB (1999-2001)
	gen pprem1 = (rateadj41/rateadj21)*100
	format pprem1 %9.1f

	** % of ALL-CAUSE due to CVD-DIAB (2009-2011)
	gen pprem2 = (rateadj42/rateadj22)*100
	format pprem2 %9.1f

	** Absolute change
	gen ac = pprem2 - pprem1
	format ac %9.1f

	** Relative change
	gen rc = ((pprem2 - pprem1) / pprem1)*100
	format rc %9.1f

	** TABLE 2 has 4 indicators
	gen indicator = .
	replace indicator = 3 if agerange==100
	replace indicator = 4 if agerange==74
	save `ind_file2'
restore


** Use indicator dataset
use `ind_file1', clear
append using `ind_file2'

** THE LISTING FOR TABULATION (TABLE 2)
keep if cid==1000
sort sex indicator
list sex indicator pprem1 pprem2 ac rc, clean noobs





** -------------------------------------------------------------------------------------
** NON-ENGLISH-SPEAKING AGE ADJUSTED
** Merge all-age and 0-74 mortality
** -------------------------------------------------------------------------------------
use `fall_nes', clear
merge 1:1 cid decade cod sex using `fnotall_nes'
drop _merge

** Keep All-cause (2) and CVD-Diabetes (4) mortality 
keep if cod==2 | cod==4


** INDICATOR 1 and 2 - premature mortality within mortality group
** Indicator 1 --> all-cause premature mortality
** Indicator 2 --> cvd/diabetes premature mortality
preserve
	tempfile ind_file1

	** Percentage premature (percentage of ALL-AGE deaths due to deaths 0-74 years)
	gen pprem = (rateadj74/rateadj)*100
	format pprem %9.1f

	** Reshape to wide (by decade) 1999-2001 = 1, 2009-2011=2
	keep rateadj rateadj74 pprem cid cod sex decade
	reshape wide rateadj rateadj74 pprem, i(cid cod sex) j(decade)

	** Absolute change
	gen ac = pprem2 - pprem1
	format ac %9.1f

	** Relative change
	gen rc = ((pprem2 - pprem1) / pprem1)*100
	format rc %9.1f

	** TABLE 2 has 4 indicators
	gen indicator = .
	replace indicator = 1 if cod==2
	replace indicator = 2 if cod==4
	label define indicator 1 "all-cause premature" 2 "cvd/diab premature" 3 "cvd/diab all ages" 4 "cvd/diab 0-74"
	label values indicator indicator

	save `ind_file1'
restore


** INDICATOR 3 and 4 - all-cause mortality due to CVD=diab mortality
** Indicator 3 --> all-cause mortality due to CVD/diabetes mortality (all-ages)
** Indicator 4 --> all-cause mortality due to CVD/diabetes mortality (0-74)
preserve
	tempfile ind_file2
	
	** Reshape to wide (by decade) 1999-2001 = 1, 2009-2011=2
	keep rateadj rateadj74 cid sex cod decade
	rename rateadj rateadj100

	reshape long rateadj, i(cid cod sex decade) j(agerange)
	reshape wide rateadj , i(cid sex agerange decade) j(cod)
	reshape wide rateadj2 rateadj4 , i(cid sex agerange) j(decade)

	** % of ALL-CAUSE due to CVD-DIAB (1999-2001)
	gen pprem1 = (rateadj41/rateadj21)*100
	format pprem1 %9.1f

	** % of ALL-CAUSE due to CVD-DIAB (2009-2011)
	gen pprem2 = (rateadj42/rateadj22)*100
	format pprem2 %9.1f

	** Absolute change
	gen ac = pprem2 - pprem1
	format ac %9.1f

	** Relative change
	gen rc = ((pprem2 - pprem1) / pprem1)*100
	format rc %9.1f

	** TABLE 2 has 4 indicators
	gen indicator = .
	replace indicator = 3 if agerange==100
	replace indicator = 4 if agerange==74
	save `ind_file2'
restore


** Use indicator dataset
use `ind_file1', clear
append using `ind_file2'

** THE LISTING FOR TABULATION (TABLE 2)
keep if cid==1000
sort sex indicator
list sex indicator pprem1 pprem2 ac rc, clean noobs
