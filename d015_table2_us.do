** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d015_table2_us, replace

**  GENERAL DO-FILE COMMENTS
**  program:      	d015_table2_us.do
**  project:      	
**  author:       	HAMBLETON \ 12-SEP-2015
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
tempfile mall_1999 m74_1999 pmort1999
** Load all-age mortality. Keep certain variables. Reshape to long
use "data\result\us_1999_2001\us_state_001", clear
keep if state==0
keep state race sex year i2 i4 i5 i6 i7 
order state race sex year i2 i4 i5 i6 i7 
reshape long i, i(state race sex year) j(mort_group)
save `mall_1999', replace

** Load all-age mortality. Keep certain variables. Reshape to long
use "data\result\us_1999_2001_74\us_state_001", clear
keep if state==0
keep state race sex year i2 i4 i5 i6 i7 
order state race sex year i2 i4 i5 i6 i7 
reshape long i, i(state race sex year) j(mort_group)
rename i i74 
save `m74_1999', replace

** Merge all-age and 0-74 mortality
use `mall_1999', clear
merge 1:1 race sex mort_group using `m74_1999'
drop _merge

** Percentage premature 
gen pprem_1999 = (i74/i)*100
format pprem_1999 %9.1f

** Save merged file
rename i i_1999
rename i74 i74_1999
keep race sex mort_group i_1999 i74_1999 pprem_1999
save `pmort1999', replace


** -------------------------------------------------------------------------------------
** Tabulate Premature Mortality for 0-74 years 
** 2009-2011
** -------------------------------------------------------------------------------------
tempfile mall_2009 m74_2009 pmort2009
** Load all-age mortality. Keep certain variables. Reshape to long
use "data\result\us_2009_2011\us_state_001", clear
keep if state==0
keep state race sex year i2 i4 i5 i6 i7 
order state race sex year i2 i4 i5 i6 i7 
reshape long i, i(state race sex year) j(mort_group)
save `mall_2009', replace

** Load all-age mortality. Keep certain variables. Reshape to long
use "data\result\us_2009_2011_74\us_state_001", clear
keep if state==0
keep state race sex year i2 i4 i5 i6 i7 
order state race sex year i2 i4 i5 i6 i7 
reshape long i, i(state race sex year) j(mort_group)
rename i i74 
save `m74_2009', replace

** Merge all-age and 0-74 mortality
use `mall_2009', clear
merge 1:1 race sex mort_group using `m74_2009'
drop _merge

** Percentage premature 
gen pprem_2009 = (i74/i)*100
format pprem_2009 %9.1f

** Save merged file
rename i i_2009
rename i74 i74_2009
keep race sex mort_group i_2009 i74_2009 pprem_2009
save `pmort2009', replace


** -------------------------------------------------------------------------------------
** Merge and calculate change in % premature mortality
** -------------------------------------------------------------------------------------
use `pmort1999', clear
merge 1:1 race sex mort_group using `pmort2009'
drop _merge

rename i_1999 rateadj1
rename i_2009 rateadj2
rename i74_1999 rateadj741
rename i74_2009 rateadj742
rename pprem_1999 pprem1
rename pprem_2009 pprem2
	
	
** Keep All-cause (2) and CVD-Diabetes (4) mortality 
rename mort_group cod
keep if cod==2 | cod==4
keep if race==1 | race==2


** INDICATOR 1 and 2 - premature mortality within mortality group
** Indicator 1 --> all-cause premature mortality
** Indicator 2 --> cvd/diabetes premature mortality
preserve
	tempfile ind_file1

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
	keep rateadj1 rateadj2 rateadj741 rateadj742 race sex cod
	rename rateadj1 rateadj100_1
	rename rateadj2 rateadj100_2
	rename rateadj741 rateadj74_1
	rename rateadj742 rateadj74_2

	reshape long rateadj74_ rateadj100_, i(race cod sex) j(decade)
	rename rateadj74_ rateadj74
	rename rateadj100_ rateadj100
	reshape long rateadj, i(race cod sex decade) j(agerange)
	reshape wide rateadj , i(race sex agerange decade) j(cod)
	reshape wide rateadj2 rateadj4 , i(race sex agerange) j(decade)

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
sort race sex indicator
list race sex indicator pprem1 pprem2 ac rc, clean noobs




