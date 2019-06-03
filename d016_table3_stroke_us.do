** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d016_table3_cvd_us, replace

**  GENERAL DO-FILE COMMENTS
**  program:      	d016_table3_cvd_us.do
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
** 1999-2001. All ages
** -------------------------------------------------------------------------------------
use "data\result\us_1999_2001\us_state_001", clear
keep if state==0
keep state sex race i2 i6
gen p_cvd_1999 = (i6/i2)*100
format p_cvd_1999 %9.1f
drop i2 i6
gen row = 1
tempfile cvd_all_1999
save `cvd_all_1999', replace

** -------------------------------------------------------------------------------------
** 1999-2001. 0-74 yrs
** -------------------------------------------------------------------------------------
use "data\result\us_1999_2001_74\us_state_001", clear
keep if state==0
keep state sex race i2 i6
gen p_cvd_1999 = (i6/i2)*100
format p_cvd_1999 %9.1f
drop i2 i6
gen row = 2
tempfile cvd_74_1999
save `cvd_74_1999', replace

** -------------------------------------------------------------------------------------
** 1999-2001. 0-64 yrs
** -------------------------------------------------------------------------------------
use "data\result\us_1999_2001_64\us_state_001", clear
keep if state==0
keep state sex race i2 i6
gen p_cvd_1999 = (i6/i2)*100
format p_cvd_1999 %9.1f
drop i2 i6
gen row = 3
tempfile cvd_64_1999
save `cvd_64_1999', replace


** -------------------------------------------------------------------------------------
** 2009-2011. All ages
** -------------------------------------------------------------------------------------
use "data\result\us_2009_2011\us_state_001", clear
keep if state==0
keep state sex race i2 i6
gen p_cvd_2009 = (i6/i2)*100
format p_cvd_2009 %9.1f
drop i2 i6
gen row = 1
tempfile cvd_all_2009
save `cvd_all_2009', replace

** -------------------------------------------------------------------------------------
** 2009-2011. 0-74 yrs
** -------------------------------------------------------------------------------------
use "data\result\us_2009_2011_74\us_state_001", clear
keep if state==0
keep state sex race i2 i6
gen p_cvd_2009 = (i6/i2)*100
format p_cvd_2009 %9.1f
drop i2 i6
gen row = 2
tempfile cvd_74_2009
save `cvd_74_2009', replace

** -------------------------------------------------------------------------------------
** 2009-2011. 0-64 yrs
** -------------------------------------------------------------------------------------
use "data\result\us_2009_2011_64\us_state_001", clear
keep if state==0
keep state sex race i2 i6
gen p_cvd_2009 = (i6/i2)*100
format p_cvd_2009 %9.1f
drop i2 i6
gen row = 3
tempfile cvd_64_2009
save `cvd_64_2009', replace

** -------------------------------------------------------------------------------------
** 1999-2001. APPEND and calculate change
** -------------------------------------------------------------------------------------
use `cvd_all_1999', clear
append using `cvd_74_1999'
append using `cvd_64_1999'
sort race sex row
order race sex row
list race sex row p_cvd_1999, noobs clean
tempfile data_1999
save `data_1999', replace

** -------------------------------------------------------------------------------------
** 2009-2011. APPEND and calculate change
** -------------------------------------------------------------------------------------
use `cvd_all_2009', clear
append using `cvd_74_2009'
append using `cvd_64_2009'
sort race sex row
order race sex row
list race sex row p_cvd_2009, noobs clean
tempfile data_2009
save `data_2009', replace

** -------------------------------------------------------------------------------------
** MERGE and calculate abolute and relative change
** -------------------------------------------------------------------------------------
use `data_1999', clear
merge 1:1 race sex row using `data_2009'
drop _merge

gen ac = p_cvd_2009 - p_cvd_1999 
format ac %9.1f

** Relative change
gen rc = ((p_cvd_2009-p_cvd_1999)/p_cvd_1999)*100
format rc %9.1f

