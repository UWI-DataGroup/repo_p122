** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d001_us2009_001_74, replace

**  GENERAL DO-FILE COMMENTS
**  program:      d001_us2009_001_74.do
**  project:      LE summary dataset: analysis
**  author:       HAMBLETON \ 10-SEP-2015
**  task:         Mortality rates (av, min, max) in the US

** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200

* Temporary files for later merging / appending
tempfile i1 i1a i2 i2a i3 i3a i4 i4a i5 i5a i6 i6a i7 i7a i8 i8a i9 i9a i10 i10a i11 i11a i12 i12a i13 i13a i14 i14a

** FOLDER suffix

** EITHER 
** --> "_1999_2001"
** --> "_2001_2011"
** --> "_all_years"
local folder1 = "_2009_2011"

** EITHER
** --> "_1999_2001_64"
** --> "_1999_2001_74"
** --> "_1999_2001"
** --> "_2009_2011_64"
** --> "_2009_2011_74"
** --> "_2009_2011"
** --> "_1999_2013_64"
** --> "_1999_2013_74"
** --> "_1999_2013"
local folder2 = "_2009_2011_74"


** ************************************************************************************************
** MORTALITY
** US AVERAGE
** The following datasets have been extracted from the CDC/NCHS WONDER DATABASE
** See http://wonder.cdc.gov/wonder/help/cmf.html for more information.
**
**
** WONDER D/B:  All causes of death
** Dataset 2. All Mortality.	BY 			RACE, 	YEAR, GENDER.	TOTAL USA. 	--> wonder2_usa_race_20141030.txt
** Dataset 2. All Mortality.	BY 					YEAR, GENDER.	TOTAL USA. 	--> wonder2_usa_20141030.txt
** Dataset 2. All Mortality.	BY STATE, 	RACE, 	YEAR, GENDER.	BY STATE. 	--> wonder2_state_race_20141030.txt
** Dataset 2. All Mortality.	BY STATE, 		    	YEAR, GENDER.	BY STATE. 	--> wonder2_state_20141030.txt
** Dataset 2. All Mortality.	BY STATE, 	RACE, 	YEAR.			BY STATE. 	--> wonder2_state_race_both_20141030.txt
**
**
** WONDER D/B:  Cancers. GR113-020 - GR113-043.   C00-C97
** Dataset 3. All Mortality.	BY 			RACE, 	YEAR, GENDER.	TOTAL USA. 	--> wonder3_usa_race_20141030.txt
** Dataset 3. All Mortality.	BY 					YEAR, GENDER.	TOTAL USA. 	--> wonder3_usa_20141030.txt
** Dataset 3. All Mortality.	BY STATE, 	RACE, 	YEAR, GENDER.	BY STATE. 	--> wonder3_state_race_20141030.txt
** Dataset 3. All Mortality.	BY STATE, 		    	YEAR, GENDER.	BY STATE. 	--> wonder3_state_20141030.txt
** Dataset 3. All Mortality.	BY STATE, 	RACE, 	YEAR.			BY STATE. 	--> wonder3_state_race_both_20141030.txt
**
** WONDER D/B:  DIABETES. GR113-046.   	E10-E14.
** WONDER D/B:  HEART. 	GR113-059.		I21-I22. 				(Acute myocardial infarction)
** WONDER D/B:  HEART. 	GR113-060.		I24. 					(Other acute ischaemic heart disease)
** WONDER D/B:  HEART. 	GR113-062.		I25.0. 					(Atherosclerotic cardiovascular disease)
** WONDER D/B:  HEART. 	GR113-063.		I20, I25.1-I25.9. 			(All other forms of ischaemic heart disease)
** WONDER D/B:  HEART. 	GR113-067.		I50. 					(Heart failure)
** WONDER D/B:  HEART. 	GR113-068.		I26-I28, I34-I38,
**										I42-I49, I51 				(All other forms of heart disease)
** WONDER D/B:  CEREBROVASCULAR DISEASES. GR113-070.   I60-I69.
** Dataset 4. All Mortality.	BY 			RACE, 	YEAR, GENDER.	TOTAL USA. 	--> wonder4_usa_race_20141030.txt
** Dataset 4. All Mortality.	BY 					YEAR, GENDER.	TOTAL USA. 	--> wonder4_usa_20141030.txt
** Dataset 4. All Mortality.	BY STATE, 	RACE, 	YEAR, GENDER.	BY STATE. 	--> wonder4_state_race_20141030.txt
** Dataset 4. All Mortality.	BY STATE, 		    	YEAR, GENDER.	BY STATE. 	--> wonder4_state_20141030.txt
** Dataset 4. All Mortality.	BY STATE, 	RACE, 	YEAR.			BY STATE. 	--> wonder4_state_race_both_20141030.txt
**
**
** WONDER D/B:  HEART ONLY. GR113-059, 060, 062, 063, 067, 068. (see above)
** Dataset 5. All Mortality.	BY 			RACE, 	YEAR, GENDER.	TOTAL USA. 	--> wonder5_usa_race_20141030.txt
** Dataset 5. All Mortality.	BY 					YEAR, GENDER.	TOTAL USA. 	--> wonder5_usa_20141030.txt
** Dataset 5. All Mortality.	BY STATE, 	RACE, 	YEAR, GENDER.	BY STATE. 	--> wonder5_state_race_20141030.txt
** Dataset 5. All Mortality.	BY STATE, 		    	YEAR, GENDER.	BY STATE. 	--> wonder5_state_20141030.txt
** Dataset 5. All Mortality.	BY STATE, 	RACE, 	YEAR.			BY STATE. 	--> wonder5_state_race_both_20141030.txt
**
**
** WONDER D/B:  CEREBROVASCULAR ONLY. GR113-070. (see above)
** Dataset 6. All Mortality.	BY 			RACE, 	YEAR, GENDER.	TOTAL USA. 	--> wonder6_usa_race_20141030.txt
** Dataset 6. All Mortality.	BY 					YEAR, GENDER.	TOTAL USA. 	--> wonder6_usa_20141030.txt
** Dataset 6. All Mortality.	BY STATE, 	RACE, 	YEAR, GENDER.	BY STATE. 	--> wonder6_state_race_20141030.txt
** Dataset 6. All Mortality.	BY STATE, 		    	YEAR, GENDER.	BY STATE. 	--> wonder6_state_20141030.txt
** Dataset 6. All Mortality.	BY STATE, 	RACE, 	YEAR.			BY STATE. 	--> wonder6_state_race_both_20141030.txt
**
**
** WONDER D/B:  DIABETES ONLY. GR113-046. (see above)
** Dataset 7. All Mortality.	BY 			RACE, 	YEAR, GENDER.	TOTAL USA. 	--> wonder7_usa_race_20141030.txt
** Dataset 7. All Mortality.	BY 					YEAR, GENDER.	TOTAL USA. 	--> wonder7_usa_20141030.txt
** Dataset 7. All Mortality.	BY STATE, 	RACE, 	YEAR, GENDER.	BY STATE. 	--> wonder7_state_race_20141030.txt
** Dataset 7. All Mortality.	BY STATE, 		    	YEAR, GENDER.	BY STATE. 	--> wonder7_state_20141030.txt
** Dataset 7. All Mortality.	BY STATE, 	RACE, 	YEAR.			BY STATE. 	--> wonder7_state_race_both_20141030.txt
**
** ************************************************************************************************

** M Endpoint
** 2	All-cause
** 3	Cancers
** 4	Cardiovascular disease (heart dirseases, cerebrovascular diseases, diabetes)
** 5	Heart disease only
** 6 	Cerebrovascular disease only
** 7	Diabetes only	

foreach m of numlist 2 3 4 5 6 7 {
** ************************************************************************************************
** DATASET 01 --> Dataset Prefix I
** USA: RACE-YEAR-GENDER
** BY RACE (x2), YEAR (x1), GENDER (x3) == 6 ROWS 
** TWENTY ROWS FOR USA VALUE (1 row per year, for black and white separately)
** ************************************************************************************************
insheet using "C:\statistics\analysis\a054\versions\version05\data\input\wonder_2015\usa_level`folder1'\wonder`m'_usa_race_20151010_74.txt", tab clear

** Create year placeholder
** This ensures the same file structure as for the year-stratified WONDER data extraction (which we use for sensitivity work)
gen year = 1

** We want stratified totals (black, white, in both 2000 and 2009)
replace gender = "both" if gender=="" & notes=="Total"
replace gendercode = "B" if gendercode==""
** keep if (year==2000|year==2009)

cap drop yearcode
cap drop oftotaldeaths
drop notes cruderate cruderatel* cruderateu*  cruderatest* cruderate 

** Code US race using CDC standard codes
drop race
gen race = .
** DROP PAcific Islanders and American Natives
drop if racecode=="1002-5" | racecode=="A-PI"
** Black / African-American
replace race = 1 if racecode=="2054-5"
** White
replace race = 2 if racecode=="2106-3"
label define race 1 "aa" 2 "white" 3 "all races",modify
label values race race
drop racecode

** Keep African-American / White only for now
keep if race==1 | race==2

** Encode sex(F=1, M=2, B=3)
gen sex = 1 if gender=="Female"
replace sex = 2 if gender=="Male"
replace sex = 3 if gender=="both"
drop gender gendercode
label define sex 1 "female" 2 "male" 3 "both sexes",modify
label values sex sex

** STATE = 0 (entire USA)
gen state=0

** ------------------------------------------------------------
** Shorter variable names
** Allows for variable being either STRING or NUMERIC
** Depending on whether data have been "Suppressed" or deemed "Unreliable"
** ------------------------------------------------------------
	** POPULATION
	rename population pop

	** DEATHS
	rename deaths deaths`m't1
	cap confirm numeric variable deaths`m't1
	if !_rc {
		gen deaths`m't = string(deaths`m't1)
		}
	else {
		gen str12 deaths`m't = deaths`m't1
		}
	drop deaths`m't1

	** AGE ADJUSTED RATE
	rename ageadjustedrate i`m't1
	cap confirm numeric variable i`m't1
	if !_rc {
		gen i`m't = string(i`m't1)
		}
	else {
	gen str12 i`m't = i`m't1
		}
	drop i`m't1

	** RATE LOWER CL
	rename ageadjustedratelower95confidence ill`m't1
	cap confirm numeric variable ill`m't1
	if !_rc {
		gen ill`m't = string(ill`m't1)
		}
	else {
	gen str12 ill`m't = ill`m't1
		}
	drop ill`m't1

	** RATE UPPER CL
	rename ageadjustedrateupper95confidence iul`m't1
	cap confirm numeric variable iul`m't1
	if !_rc {
		gen iul`m't = string(iul`m't1)
		}
	else {
	gen str12 iul`m't = iul`m't1
		}
	drop iul`m't1

	** RATE SE
	rename ageadjustedratestandarderror ise`m't1
	cap confirm numeric variable ise`m't1
	if !_rc {
		gen ise`m't = string(ise`m't1)
		}
	else {
	gen str12 ise`m't = ise`m't1
		}
	drop ise`m't1

** Create marker if rate is unreliable or suppressed (0=OK = 1=suppressed or unreliable)
gen ins`m' = 0
cap replace ins`m' = 1 if strpos(i`m't, "Unreliable")
cap replace ins`m' = 2 if strpos(i`m't, "Suppressed")
label define ins`m' 0 "ok" 1 "unreliable" 2 "suppressed", modify
label values ins`m' ins`m'
sort state race year sex

order state race year sex pop deaths*  i`m't ins`m'

** Remove text "suppressed" and "(unreliable)" from rates and deaths
** And convert variable to REAL from STRING
foreach var in i`m' ill`m' iul`m' ise`m' {
	gen `var' = trim(substr(`var't,1,5))
	}
drop i`m't ill`m't iul`m't ise`m't
foreach var in i`m' ill`m' iul`m' ise`m' {
	replace `var' = "" if `var'=="Suppre" | `var'=="Suppressed"
	gen `var'n = real(`var')
	}

cap replace deaths`m't = "" if deaths`m't=="Suppressed"
rename deaths`m't d1
gen deaths`m' = real(d1)
drop i`m' ill`m' iul`m' ise`m' d1
rename *n *

sort state race year sex
order state race year sex pop deaths*  i`m'*
label data "US level data (by year, race, sex) --> metric `m'"
save "data\result\us`folder2'\i`m'", replace



** ************************************************************************************************
** DATASET 02 --> Dataset Prefix IB
** USA: YEAR-GENDER
** BY YEAR (x1), GENDER (x3) == 3 ROWS
** ************************************************************************************************
insheet using "C:\statistics\analysis\a054\versions\version05\data\input\wonder_2015\usa_level`folder1'\wonder`m'_usa_20151010_74.txt", tab clear

** Create year placeholder
** This ensures the same file structure as for the year-stratified WONDER data extraction (which we use for sensitivity work)
gen year = 1

** We want stratified totals (black, white, in both 2000 and 2009)
replace gender = "both" if gender=="" & notes=="Total"
replace gendercode = "B" if gendercode==""
**keep if (year==2000|year==2009)

cap drop yearcode
cap drop oftotaldeaths
drop notes cruderate cruderatel* cruderateu*  cruderatest*

** Code US race using CDC standard codes (dataset extracted with all races collapseed)
gen race = 3
label define race 1 "aa" 2 "white" 3 "all races",modify
label values race race

** Encode sex(F=1, M=2, B=3)
gen sex = 1 if gender=="Female"
replace sex = 2 if gender=="Male"
replace sex = 3 if gender=="both"
drop gender gendercode
label define sex 1 "female" 2 "male" 3 "both sexes",modify
label values sex sex

** Restrict out extra rows existing because of metadata at end of file
keep if sex==1 | sex==2 | sex==3

** STATE = 0 (entire USA)
gen state=0

** ------------------------------------------------------------
** Shorter variable names
** Allows for variable being either STRING or NUMERIC
** Depending on whether data have been "Suppressed" or deemed "Unreliable"
** ------------------------------------------------------------
	** POPULATION
	rename population pop

	** DEATHS
	rename deaths deaths`m't1
	cap confirm numeric variable deaths`m't1
	if !_rc {
		gen deaths`m't = string(deaths`m't1)
		}
	else {
		gen str12 deaths`m't = deaths`m't1
		}
	drop deaths`m't1

	** AGE ADJUSTED RATE
	rename ageadjustedrate i`m't1
	cap confirm numeric variable i`m't1
	if !_rc {
		gen i`m't = string(i`m't1)
		}
	else {
	gen str12 i`m't = i`m't1
		}
	drop i`m't1

	** RATE LOWER CL
	rename ageadjustedratelower95confidence ill`m't1
	cap confirm numeric variable ill`m't1
	if !_rc {
		gen ill`m't = string(ill`m't1)
		}
	else {
	gen str12 ill`m't = ill`m't1
		}
	drop ill`m't1

	** RATE UPPER CL
	rename ageadjustedrateupper95confidence iul`m't1
	cap confirm numeric variable iul`m't1
	if !_rc {
		gen iul`m't = string(iul`m't1)
		}
	else {
	gen str12 iul`m't = iul`m't1
		}
	drop iul`m't1

	** RATE SE
	rename ageadjustedratestandarderror ise`m't1
	cap confirm numeric variable ise`m't1
	if !_rc {
		gen ise`m't = string(ise`m't1)
		}
	else {
	gen str12 ise`m't = ise`m't1
		}
	drop ise`m't1

** Create marker if rate is unreliable or suppressed (0=OK = 1=suppressed or unreliable)
gen ins`m' = 0
cap replace ins`m' = 1 if strpos(i`m't, "Unreliable")
cap replace ins`m' = 2 if strpos(i`m't, "Suppressed")
label define ins`m' 0 "ok" 1 "unreliable" 2 "suppressed", modify
label values ins`m' ins`m'
sort state race year sex

order state race year sex pop deaths*  i`m't ins`m'

** Remove text "suppressed" and "(unreliable)" from rates and deaths
** And convert variable to REAL from STRING
foreach var in i`m' ill`m' iul`m' ise`m' {
	gen `var' = trim(substr(`var't,1,5))
	}
drop i`m't ill`m't iul`m't ise`m't
foreach var in i`m' ill`m' iul`m' ise`m' {
	replace `var' = "" if `var'=="Suppre" | `var'=="Suppressed"
	gen `var'n = real(`var')
	}

cap replace deaths`m't = "" if deaths`m't=="Suppressed"
rename deaths`m't d1
gen deaths`m' = real(d1)
drop i`m' ill`m' iul`m' ise`m' d1
rename *n *

sort state race year sex
order state race year sex pop deaths*  i`m'*
label data "US level data (by year, sex) --> metric `m'"
save "data\result\us`folder2'\ib`m'", replace



** ************************************************************************************************
** DATASET 03 --> Dataset Prefix IS
** STATE: RACE-YEAR-GENDER
** BY STATE (x51), RACE (x2), YEAR (x1), GENDER (x2) == 204 ROWS 
** STATE_LEVEL DATA (WOMEN AND MEN ONLY)
** ************************************************************************************************
insheet using "C:\statistics\analysis\a054\versions\version05\data\input\wonder_2015\state_level`folder1'\wonder`m'_state_race_20151010_74.txt", tab clear

** Create year placeholder
** This ensures the same file structure as for the year-stratified WONDER data extraction (which we use for sensitivity work)
gen year = 1

** Keep deaths from 2000 and 2009
**keep if year==2000 | year==2009
cap drop yearcode
cap drop oftotaldeaths
drop notes 

** Code US state using CDC standard codes (additionally 0=USA)
labmask statecode, val(state)
drop state cruderate cruderatelower95confidenceinterv cruderateupper95confidenceinterv cruderatestandarderror
rename statecode state

** Code US race using CDC standard codes
drop if racecode=="1002-5" | racecode=="A-PI"
drop race
gen race = .
replace race = 1 if racecode=="2054-5"
replace race = 2 if racecode=="2106-3"
label define race 1 "aa" 2 "white" 3 "all races",modify
label values race race
drop racecode

** Keep African-American / White only for now
** This also drops additional unwanted rows that exist due to metadata at end of raw datafile
keep if race==1 | race==2

** Encode sex(F=1, M=2, B=3)
gen sex = 1 if gender=="Female"
replace sex = 2 if gender=="Male"
drop gender gendercode
label define sex 1 "female" 2 "male" 3 "both sexes",modify
label values sex sex


** ------------------------------------------------------------
** Shorter variable names
** Allows for variable being either STRING or NUMERIC
** Depending on whether data have been "Suppressed" or deemed "Unreliable"
** ------------------------------------------------------------
	** POPULATION
	rename population pop

	** DEATHS
	rename deaths deaths`m't1
	cap confirm numeric variable deaths`m't1
	if !_rc {
		gen deaths`m't = string(deaths`m't1)
		}
	else {
		gen str12 deaths`m't = deaths`m't1
		}
	drop deaths`m't1

	** AGE ADJUSTED RATE
	rename ageadjustedrate i`m't1
	cap confirm numeric variable i`m't1
	if !_rc {
		gen i`m't = string(i`m't1)
		}
	else {
	gen str12 i`m't = i`m't1
		}
	drop i`m't1

	** RATE LOWER CL
	rename ageadjustedratelower95confidence ill`m't1
	cap confirm numeric variable ill`m't1
	if !_rc {
		gen ill`m't = string(ill`m't1)
		}
	else {
	gen str12 ill`m't = ill`m't1
		}
	drop ill`m't1

	** RATE UPPER CL
	rename ageadjustedrateupper95confidence iul`m't1
	cap confirm numeric variable iul`m't1
	if !_rc {
		gen iul`m't = string(iul`m't1)
		}
	else {
	gen str12 iul`m't = iul`m't1
		}
	drop iul`m't1

	** RATE SE
	rename ageadjustedratestandarderror ise`m't1
	cap confirm numeric variable ise`m't1
	if !_rc {
		gen ise`m't = string(ise`m't1)
		}
	else {
	gen str12 ise`m't = ise`m't1
		}
	drop ise`m't1

** Create marker if rate is unreliable or suppressed (0=OK = 1=suppressed or unreliable)
gen ins`m' = 0
cap replace ins`m' = 1 if strpos(i`m't, "Unreliable")
cap replace ins`m' = 2 if strpos(i`m't, "Suppressed")
label define ins`m' 0 "ok" 1 "unreliable" 2 "suppressed", modify
label values ins`m' ins`m'
sort state race year sex

order state race year sex pop deaths*  i`m't ins`m'

** Remove text "suppressed" and "(unreliable)" from rates and deaths
** And convert variable to REAL from STRING
foreach var in i`m' ill`m' iul`m' ise`m' {
	gen `var' = trim(substr(`var't,1,5))
	}
drop i`m't ill`m't iul`m't ise`m't
foreach var in i`m' ill`m' iul`m' ise`m' {
	replace `var' = "" if `var'=="Suppre" | `var'=="Suppressed"
	gen `var'n = real(`var')
	}

cap replace deaths`m't = "" if deaths`m't=="Suppressed"
rename deaths`m't d1
gen deaths`m' = real(d1)
drop i`m' ill`m' iul`m' ise`m' d1
rename *n *

sort state race year sex
order state race year sex pop deaths*  i`m'*
label data "State level data (by state, year, race, sex) --> metric `m'"
save "data\result\us`folder2'\is`m'", replace



** ************************************************************************************************
** DATASET 04 --> Dataset Prefix ISS
** STATE: RACE-YEAR
** BY STATE (x51), RACE (x2), YEAR (x1), GENDER (x1) == 102 ROWS 
** STATE_LEVEL DATA (WOMEN AND MEN COMBINED - BOTH)
** ************************************************************************************************
insheet using "C:\statistics\analysis\a054\versions\version05\data\input\wonder_2015\state_level`folder1'\wonder`m'_state_race_both_20151010_74.txt", tab clear

** Create year placeholder
** This ensures the same file structure as for the year-stratified WONDER data extraction (which we use for sensitivity work)
gen year = 1

** keep if year==2000 | year==2009
cap drop yearcode
drop notes 

** Code US state using CDC standard codes (additionally 0=USA)
labmask statecode, val(state)
drop state cruderate cruderatelower95confidenceinterv cruderateupper95confidenceinterv cruderatestandarderror
cap drop oftotaldeaths
rename statecode state

** Code US race using CDC standard codes
drop if racecode=="1002-5" | racecode=="A-PI"
drop race
gen race = .
replace race = 1 if racecode=="2054-5"
replace race = 2 if racecode=="2106-3"
label define race 1 "aa" 2 "white" 3 "all races",modify
label values race race
drop racecode

** Keep African-American / White only for now
keep if race==1 | race==2
** Encode sex(F=1, M=2, B=3)
gen sex = 3
label define sex 1 "female" 2 "male" 3 "both sexes",modify
label values sex sex

** ------------------------------------------------------------
** Shorter variable names
** Allows for variable being either STRING or NUMERIC
** Depending on whether data have been "Suppressed" or deemed "Unreliable"
** ------------------------------------------------------------
	** POPULATION
	rename population pop

	** DEATHS
	rename deaths deaths`m't1
	cap confirm numeric variable deaths`m't1
	if !_rc {
		gen deaths`m't = string(deaths`m't1)
		}
	else {
		gen str12 deaths`m't = deaths`m't1
		}
	drop deaths`m't1

	** AGE ADJUSTED RATE
	rename ageadjustedrate i`m't1
	cap confirm numeric variable i`m't1
	if !_rc {
		gen i`m't = string(i`m't1)
		}
	else {
	gen str12 i`m't = i`m't1
		}
	drop i`m't1

	** RATE LOWER CL
	rename ageadjustedratelower95confidence ill`m't1
	cap confirm numeric variable ill`m't1
	if !_rc {
		gen ill`m't = string(ill`m't1)
		}
	else {
	gen str12 ill`m't = ill`m't1
		}
	drop ill`m't1

	** RATE UPPER CL
	rename ageadjustedrateupper95confidence iul`m't1
	cap confirm numeric variable iul`m't1
	if !_rc {
		gen iul`m't = string(iul`m't1)
		}
	else {
	gen str12 iul`m't = iul`m't1
		}
	drop iul`m't1

	** RATE SE
	rename ageadjustedratestandarderror ise`m't1
	cap confirm numeric variable ise`m't1
	if !_rc {
		gen ise`m't = string(ise`m't1)
		}
	else {
	gen str12 ise`m't = ise`m't1
		}
	drop ise`m't1

** Create marker if rate is unreliable or suppressed (0=OK = 1=suppressed or unreliable)
gen ins`m' = 0
cap replace ins`m' = 1 if strpos(i`m't, "Unreliable")
cap replace ins`m' = 2 if strpos(i`m't, "Suppressed")
label define ins`m' 0 "ok" 1 "unreliable" 2 "suppressed", modify
label values ins`m' ins`m'
sort state race year sex

order state race year sex pop deaths*  i`m't ins`m'

** Remove text "suppressed" and "(unreliable)" from rates and deaths
** And convert variable to REAL from STRING
foreach var in i`m' ill`m' iul`m' ise`m' {
	gen `var' = trim(substr(`var't,1,5))
	}
drop i`m't ill`m't iul`m't ise`m't
foreach var in i`m' ill`m' iul`m' ise`m' {
	replace `var' = "" if `var'=="Suppre" | `var'=="Suppressed"
	gen `var'n = real(`var')
	}

cap replace deaths`m't = "" if deaths`m't=="Suppressed"
rename deaths`m't d1
gen deaths`m' = real(d1)
drop i`m' ill`m' iul`m' ise`m' d1
rename *n *
sort state race year sex
order state race year sex pop deaths*  i`m'*


sort state race year sex
order state race year sex pop deaths*  i`m'*
label data "State level data (by state, year, race) --> metric `m'"
save "data\result\us`folder2'\iss`m'", replace




** ************************************************************************************************
** DATASET 05 --> Dataset Prefix ISB
** STATE: YEAR-GENDER
** BY STATE (x51), RACE (x1), YEAR (x1), GENDER (x3) == 153 ROWS 
** STATE_LEVEL DATA (ALL RACES. WOMEN & MEN SEPARATED. WOMEN AND MEN COMBINED)
** ************************************************************************************************
insheet using "C:\statistics\analysis\a054\versions\version05\data\input\wonder_2015\state_level`folder1'\wonder`m'_state_20151010_74.txt", tab clear

** Restrict out extra rows existing because of metadata at end of file
keep if statecode<.

** Create year placeholder
** This ensures the same file structure as for the year-stratified WONDER data extraction (which we use for sensitivity work)
gen year = 1

** keep if year==2000 | year==2009
cap drop yearcode
drop notes 

** Code US state using CDC standard codes (additionally 0=USA)
labmask statecode, val(state)
drop state cruderate cruderatelower95confidenceinterv cruderateupper95confidenceinterv cruderatestandarderror
cap drop oftotaldeaths
rename statecode state

** Code US race using CDC standard codes
gen race=3

** Encode sex(F=1, M=2, B=3)
replace gender = "Both" if gender==""
replace gendercode = "B" if gendercode==""
gen sex = 1 if gender=="Female"
replace sex = 2 if gender=="Male"
replace sex = 3 if gender=="Both"
drop gender gendercode
label define sex 1 "female" 2 "male" 3 "both sexes",modify
label values sex sex



** ------------------------------------------------------------
** Shorter variable names
** Allows for variable being either STRING or NUMERIC
** Depending on whether data have been "Suppressed" or deemed "Unreliable"
** ------------------------------------------------------------
	** POPULATION
	rename population pop

	** DEATHS
	rename deaths deaths`m't1
	cap confirm numeric variable deaths`m't1
	if !_rc {
		gen deaths`m't = string(deaths`m't1)
		}
	else {
		gen str12 deaths`m't = deaths`m't1
		}
	drop deaths`m't1

	** AGE ADJUSTED RATE
	rename ageadjustedrate i`m't1
	cap confirm numeric variable i`m't1
	if !_rc {
		gen i`m't = string(i`m't1)
		}
	else {
	gen str12 i`m't = i`m't1
		}
	drop i`m't1

	** RATE LOWER CL
	rename ageadjustedratelower95confidence ill`m't1
	cap confirm numeric variable ill`m't1
	if !_rc {
		gen ill`m't = string(ill`m't1)
		}
	else {
	gen str12 ill`m't = ill`m't1
		}
	drop ill`m't1

	** RATE UPPER CL
	rename ageadjustedrateupper95confidence iul`m't1
	cap confirm numeric variable iul`m't1
	if !_rc {
		gen iul`m't = string(iul`m't1)
		}
	else {
	gen str12 iul`m't = iul`m't1
		}
	drop iul`m't1

	** RATE SE
	rename ageadjustedratestandarderror ise`m't1
	cap confirm numeric variable ise`m't1
	if !_rc {
		gen ise`m't = string(ise`m't1)
		}
	else {
	gen str12 ise`m't = ise`m't1
		}
	drop ise`m't1

** Create marker if rate is unreliable or suppressed (0=OK = 1=suppressed or unreliable)
gen ins`m' = 0
cap replace ins`m' = 1 if strpos(i`m't, "Unreliable")
cap replace ins`m' = 2 if strpos(i`m't, "Suppressed")
label define ins`m' 0 "ok" 1 "unreliable" 2 "suppressed", modify
label values ins`m' ins`m'
sort state race year sex

order state race year sex pop deaths*  i`m't ins`m'

** Remove text "suppressed" and "(unreliable)" from rates and deaths
** And convert variable to REAL from STRING
foreach var in i`m' ill`m' iul`m' ise`m' {
	gen `var' = trim(substr(`var't,1,5))
	}
drop i`m't ill`m't iul`m't ise`m't
foreach var in i`m' ill`m' iul`m' ise`m' {
	replace `var' = "" if `var'=="Suppre" | `var'=="Suppressed"
	gen `var'n = real(`var')
	}

cap replace deaths`m't = "" if deaths`m't=="Suppressed"
rename deaths`m't d1
gen deaths`m' = real(d1)
drop i`m' ill`m' iul`m' ise`m' d1
rename *n *

sort state race year sex
order state race year sex pop deaths*  i`m'*
label data "State level data (by year, sex) --> metric `m'"
save "data\result\us`folder2'\isb`m'", replace


** ************************************************************************************************
** DATASET 06 --> Dataset Prefix IALL
** Join the US and STATE files
** SHOULD END UP WITH 6+3+204+102+153 = 468 rows 
**
** In other words
** 9 rows per state (AA, m, f, both) (White, m, f, both) (ALL races, m, f, both)
** + 9 rows for US totals
** = 9 * 51 + 9 = 468
** ************************************************************************************************
use using "data\result\us`folder2'\isb`m'", clear
append using "data\result\us`folder2'\iss`m'"
append using "data\result\us`folder2'\is`m'"
append using "data\result\us`folder2'\ib`m'"
append using "data\result\us`folder2'\i`m'"

** LABEL 51 states + USA
#delimit ;
label define state 0 "USA"
09      "Connecticut"
23      "Maine"
25      "Massachusetts"
33      "New Hampshire"
34      "New Jersey"
36      "New York"
42      "Pennsylvania"
44      "Rhode Island"
50      "Vermont"
17      "Illinois"
18      "Indiana"
19      "Iowa"
20      "Kansas"
26      "Michigan"
27      "Minnesota"
29      "Missouri"
31      "Nebraska"
38      "North Dakota"
39      "Ohio"
46      "South Dakota"
55      "Wisconsin"
01      "Alabama"
05      "Arkansas"
10      "Delaware"
11      "District of Columbia"
12      "Florida"
13      "Georgia"
21      "Kentucky"
22      "Louisiana"
24      "Maryland"
28      "Mississippi"
37      "North Carolina"
40      "Oklahoma"
45      "South Carolina"
47      "Tennessee"
48      "Texas"
51      "Virginia"
54      "West Virginia"
02      "Alaska"
04      "Arizona"
06      "California"
08      "Colorado"
15       "Hawaii"
16       "Idaho"
30       "Montana"
32       "Nevada"
35       "New Mexico"
41       "Oregon"
49       "Utah"
53       "Washington"
56       "Wyoming"
0		 "USA";
#delimit cr
label values state state
label define race 1 "aa" 2 "white" 3 "all races",modify

label values race race
sort state race year sex	
label data "US and State level data (by race, year, sex) --> metric `m'"
save "data\result\us`folder2'\iall`m'", replace
}



** ************************************************************************************************
** LISTING USA VALUES FOR TABLE 1 - AFRICAN AMERICAN
** LISTING USA VALUES FOR TABLE 1 - WHITE
** ************************************************************************************************
** AFRICAN-AMERICAN
foreach x of numlist 2 3 4 5 6 7 {
use "data\result\us`folder2'\iall`x'", clear
keep if race==1
drop race
sort state year
save "data\result\us`folder2'\table01\table01_aa`x'", replace
}
** WHITE
foreach x of numlist 2 3 4 5 6 7 {
use "data\result\us`folder2'\iall`x'", clear
keep if race==2
drop race
sort state year
save "data\result\us`folder2'\table01\table01_w`x'", replace
}
** ALL-RACES
foreach x of numlist 2 3 4 5 6 7 {
use "data\result\us`folder2'\iall`x'", clear
keep if race==3
drop race
sort state year
save "data\result\us`folder2'\table01\table01_all`x'", replace
}



** ************************************************************************************************
** MERGING MORTALITY METRICS ACROSS INDICATORS
** NOT USING STATES WITH SUPPRESSED values
** We DO use STATES with "unreliable" values
** ************************************************************************************************

** Create indicator that is invariant across States. 0=Data OK. 1=UNRELIABLE, 2=SUPPRESSED
foreach x of numlist 2 3 4 5 6 7 {
	use "data\result\us`folder2'\iall`x'", clear
	bysort state: egen ins`x't = max(ins`x')
	save "data\result\us`folder2'\iall`x'", replace
	}

** Create a single dataset with all mortality rates as separate columns in a WIDE format
use "data\result\us`folder2'\iall2", replace
foreach x of numlist 3 4 5 6 7 {
	merge 1:1 state race year sex using "data\result\us`folder2'\iall`x'"
	rename _merge merge`x'
	}
save "data\result\us`folder2'\morts", replace


** USA value (min state value TO max state value)
rename ill* i*ll
rename iul* i*ul
rename ise* i*se
foreach w in i2 i3 i4 i5 i6 i7 {
	dis _newline(4) "INDICATOR =  is " "`w'"
	** List RATE + CI
	list race year sex `w' `w'll `w'ul if state==0, sep(3)
	* Minimum and maximum state value
	bysort race year sex: egen `w'min = min(`w')
	bysort race year sex: egen `w'max = max(`w')
	gen smin = state if `w'min==`w'
	gen smax = state if `w'max==`w'
	label values smax state
	label values smin state
	** List States with MIN and MAX rates for each indicator by RACE and SEX
	list race year sex smin `w'min smax `w'max if state>0 & (smin<.|smax<.), sep(2)
	drop `w'min `w'max smin smax
	}

** SAVE final STATE-LEVEL file (MEASURE wide)
use "data\result\us`folder2'\morts", clear
save "data\result\us`folder2'\us_state_001", replace

** SAVE final STATE-LEVEL file (full LONG format)
reshape long deaths c i ill iul ise ins, i(state pop year race sex) j(measure)
save "data\result\us`folder2'\us_state_002", replace

** SAVE final STATE-LEVEL file (YEAR wide format) - only affects the sensitivity file (which has multiple years)
reshape wide deaths c i ill iul ise ins pop, i(state race measure sex) j(year)
save "data\result\us`folder2'\us_state_003", replace



/*

**  ************************************************************************************************
** CHANGE BETWEEN TIME PERIODS - CAN ONLY DO THIS ONCE WE'VE MERGED 1999-2001 data with 2009-2011 data
**  ************************************************************************************************

** Change and percentage change between 2000 and 2009 for all metrics
gen change = i2009 - i2000
gen pchange = ((i2009 - i2000)/i2000)*100
table measure if race==1 & state==0, c(mean change mean pchange) format(%9.1f)
table measure if race==2 & state==0, c(mean change mean pchange) format(%9.1f)
table measure if race==3 & state==0, c(mean change mean pchange) format(%9.1f)
save "data\result\us`folder2'\us_data_001", replace




** DROP ELEVEN states with SUPPRESSED mortality information for ALL-CAUSE (#2), CANCERS (#3), CVD+DIABETES (#4).
** We drop the following States:
** 	2	Alaska
**	15	Hawaii
**	16	idaho
**	23	Maiine
**	30	Montana
**	33	New hampshire
**	38	North Dakota
**	46	South Dakota
**	49	Utah
**	50	Vermont
**	56	Wyoming
** drop if state==2 | state==15 | state==16 | state==23 | state==30 | state==33 | state==38 | state==46 | state==49 | state==50 | state==56
