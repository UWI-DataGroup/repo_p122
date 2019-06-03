** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d014_table1_us, replace

**  GENERAL DO-FILE COMMENTS
**  program:      	d014_table1_us.do
**  project:      	LE summary dataset: analysis
**  author:       	HAMBLETON \ 11-SEP-2015
**  task:         	US contribution to Table 1
**				Age-standardized mortality rates (MR average, MR range between States)

** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200

** Mortality below 75 years is our primary outcome measure
** We present these data by mortality group, for women, men, and women + men combined
** And for 2 time period (1999-2001) and (2009-2011)

** -------------------------------------------------------------------------------------
** Tabulate US Mortality Rates (average, State-level range) 
** Choose correct dataset for tabulation
** -------------------------------------------------------------------------------------
use "data\result\us_2009_2011\us_state_001", clear
** -------------------------------------------------------------------------------------


** Standardize position of morbidity group indicator in variable name
** This allows easier looping below
rename ill* i*ll
rename iul* i*ul
rename ise* i*se

** Prepare dataset for Table 1 listing 
foreach w in i2 i4 i5 i6 i7 {
	dis _newline(4) "INDICATOR =  is " "`w'"
	** List RATE + CI
	list race year sex `w' `w'll `w'ul if state==0, sep(3)
	* Minimum and maximum state value
	bysort race year sex: egen min`w' = min(`w')
	bysort race year sex: egen max`w' = max(`w')
	gen smin1`w' = state if min`w'==`w'
	gen smax1`w' = state if max`w'==`w'
	bysort race year sex: egen smin`w' = min(smin1`w')
	bysort race year sex: egen smax`w' = min(smax1`w')
	label values smax`w' state
	label values smin`w' state
}

** Keeping the US average rate 
keep if state==0
keep sex race year i2 i4 i5 i6 i7 i2ll i4ll i5ll i6ll i7ll i2ul i4ul i5ul i6ul i7ul ///
				   min* max* smini2 smini4 smini5 smini6 smini7 smaxi2 smaxi4 smaxi5 smaxi6 smaxi7
** Reshape to list in order appropriate for Tabulation
rename i*ll ill* 
rename i*ul iul* 
reshape long i ill iul mini maxi smini smaxi, i(sex race year) j(mort_group)

** AA women, men, both
sort race mort_group sex
order race mort_group sex

** List States with MIN and MAX rates for each indicator by RACE and SEX
list race mort_group sex i ill iul mini maxi , clean noobs


