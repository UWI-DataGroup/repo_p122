** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\a054_car_004, replace

**  GENERAL DO-FILE COMMENTS
**  program:      a054_car_004.do
**  project:      LE summary dataset: analysis
**  author:       HAMBLETON \ 25-OCT-2016
**  task:         Mortality rates in the Caribbean at the country-level
 
** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200


** **************************************************************
** PART 01. 
** Select subgroups for Mortality Rate calculations
** **************************************************************

** **************************************************************
** Choose Mortality group
** **************************************************************
** 2	All-cause
** 3	Cancer
** 4	CVD-Diabetes
** 5	Heart disease
** 6	Stroke
** 7	Diabetes
** 8	Intentional Injury
local cod = "cod2 cod3 cod4 cod5 cod6 cod7"
**local cod = "cod2"


** **************************************************************
** Choose Country Selection
** **************************************************************
** 1000 "Caribbean"
** 2010 "Antigua and Barbuda"
** 2025 "Aruba"
** 2030 "Bahamas"
** 2040 "Barbados"
** 2045 "Belize"
** 2150" Cuba"
** 2170 "Dominican Republic"
** 2210 "French Guiana"
** 2230 "Grenada"
** 2240 "Guadeloupe"
** 2260 "Guyana"
** 2270 "Haiti"
** 2290 "Jamaica"
** 2300 "Martinique"
** 2380 "Puerto Rico"
** 2400 "St.Lucia"
** 2420 "St.Vincent & Grenadines"
** 2430 "Suriname"
** 2440 "Trinidad and Tobago"
** 2455 "USVI", modify;					

** 18 countries (not using Haiti, Jamaica)
local country = "2010 2025 2030 2040 2045 2150 2170 2210 2230 2240 2260 2300 2380 2400 2420 2430 2440 2455"
** 13 countries (OUT: Aruba, DomRep, Grenada, Guyana, Suriname)
** local country = "2010 2030 2040 2045 2150 2210 2240 2300 2380 2400 2420 2440 2455"
** 6 countries (Antigua, Bahamas, Barbados, Grenada, St.Lucia, St.Vincent)
**	local country = "2010 2030 2040 2230 2400 2420"
** English-Speaking. 10 countries (Antigua, Bahamas, Barbados, Belize, Grenada, Guyana, St.Lucia, St.Vincent, TnT, USVI)
**	local country = "2010 2030 2040 2045 2230 2260 2400 2420 2440 2455"
** non-English-Speaking. 8 countries (Aruba, Cuba, DomRep, FrGuiana, Guadeloupe, Martinique, Puerto Rico, Suriname)
**	local country = "2025 2150 2170 2210 2240 2300 2380 2430"
** English-Speaking. 8 countries (Antigua, Bahamas, Barbados, Belize, St.Lucia, St.Vincent, TnT, USVI)
**	local country = "2010 2030 2040 2045 2400 2420 2440 2455"
** non-English-Speaking. 5 countries (Cuba, FrGuiana, Guadeloupe, Martinique, Puerto Rico)
**	local country = "2150 2210 2240 2300 2380"

	
** N=18 --> Don't drop any countries (999 code means no countries dropped)
** Code for this drop = 9999
local drop = 9999

** N=13 --> Drop countries with maximum estimated 3-year rolling average undercount of 25%
** Aruba, Dominican Republic, Grenada, Guyana, Suriname
** Code for this drop = 9998
** local drop = 9998


** N=6 --> Keep the countries involved in Paper 2 --> AJPH
** Code for this drop = 9997
** local drop = 9997

** N=10 --> English-speaking Caribbean
** Code for this drop = 9996
** local drop = 9996

** N=8 --> Non English-speaking Caribbean
** Code for this drop = 9995
** local drop = 9995

** N=8 --> English-speaking Caribbean
** Code for this drop = 9994
** local drop = 9994

** N=5 --> non-English-speaking Caribbean
** Code for this drop = 9993
** local drop = 9993


** **************************************************************
** Choose Age Range
** **************************************************************
** All ages (11 groups)
local age1 = 11
local age2 = ""
** local "age1" and "age2" --> left null
** 0-74 (age group 9)
local age1 = 9
local age2 = "_74"
** 0-64 (age group 8)
** local age1 = 8
** local age2 = "_64"


** **************************************************************
** Quality-adjusted rates
** **************************************************************
** Age adjusted only
local quality = "_a"
** Age and Quality adjusted
** local quality = "_aq"



** **************************************************************
** Choose suffix for FINAL saved filename
** **************************************************************
** ----------------------------
** 13 COUNTRIES - under-reporting < 25%
** ----------------------------
** Age-Adjusted. N=13 Countries. 5 DROPPED (Aruba, DomRep, Grenada, Guyana, Suriname)
local name = 001
** Age and Quality Adjusted. N=13 Countries. 5 DROPPED (Aruba, DomRep, Grenada, Guyana, Suriname)
** local name = 002
** (0-74 years) Age-Adjusted. N=13 Countries. 5 DROPPED (Aruba, DomRep, Grenada, Guyana, Suriname)
** local name = 003
** (0-74 years) Age and Quality Adjusted. N=13 Countries. 5 DROPPED (Aruba, DomRep, Grenada, Guyana, Suriname)
** local name = 004
** (0-64 years) Age-Adjusted. N=13 Countries. 5 DROPPED (Aruba, DomRep, Grenada, Guyana, Suriname)
** local name = 005
** (0-64 years) Age and Quality Adjusted. N=13 Countries. 5 DROPPED (Aruba, DomRep, Grenada, Guyana, Suriname)
** local name = 006
** ----------------------------
** 18 COUNTRIES - all levels of under-reporting
** ----------------------------
** Age and Quality Adjusted. N=18 Countries.
** local name = 007
** (0-74 years) Age and Quality Adjusted. N=18 Countries.
** local name = 008
** (0-64 years) Age and Quality Adjusted. N=18 Countries.
** local name = 009
** ----------------------------
** 6 COUNTRIES - countries used in AJPH paper
** ----------------------------
** Age-Adjusted. N=6 Countries. (Same as for AJPH paper)
** local name = 010
** Age and Quality Adjusted. N=6 Countries. (Same as for AJPH paper)
** local name = 011
** ----------------------------
** 10 COUNTRIES - English-speaking. All under-reporting
** ----------------------------
** Age-Adjusted. N=10 Countries. (English-speaking Caribbean)
** local name = 012
** Age and Quality Adjusted. N=10 Countries. (English-speaking Caribbean)
** local name = 013
** (0-74 years) Age-Adjusted. N=10 Countries. (English-speaking Caribbean)
** local name = 014
** (0-74 years) Age and Quality Adjusted. N=10 Countries. (English-speaking Caribbean)
** local name = 015
** (0-64 years) Age-Adjusted. N=10 Countries. (English-speaking Caribbean)
** local name = 016
** (0-64 years) Age and Quality Adjusted. N=10 Countries. (English-speaking Caribbean)
** local name = 017
** ----------------------------
** 8 COUNTRIES - Non-English-speaking. All-under-reporting
** ----------------------------
** Age-Adjusted. N=8 Countries. (Non English-speaking Caribbean)
**local name = 018
** Age and Quality Adjusted. N=8 Countries. (Non English-speaking Caribbean)
**local name = 019
** (0-74 years) Age-Adjusted. N=8 Countries. (Non English-speaking Caribbean)
**local name = 020
** (0-74 years) Age and Quality Adjusted. N=8 Countries. (Non English-speaking Caribbean)
**local name = 021
** (0-64 years) Age-Adjusted. N=8 Countries. (Non English-speaking Caribbean)
**local name = 022
** (0-64 years) Age and Quality Adjusted. N=8 Countries. (Non English-speaking Caribbean)
**local name = 023
** ----------------------------
** 8 COUNTRIES - English-speaking. Under-reporting < 25%
** ----------------------------
** Age-Adjusted. N=8 Countries. (English-speaking Caribbean)
** local name = 024
** Age and Quality Adjusted. N=8 Countries. (English-speaking Caribbean)
** local name = 025
** (0-74 years) Age-Adjusted. N=8 Countries. (English-speaking Caribbean)
** local name = 026
** (0-74 years) Age and Quality Adjusted. N=8 Countries. (English-speaking Caribbean)
** local name = 027
** (0-64 years) Age-Adjusted. N=8 Countries. (English-speaking Caribbean)
** local name = 028
** (0-64 years) Age and Quality Adjusted. N=8 Countries. (English-speaking Caribbean)
** local name = 029
** ----------------------------
** 5 COUNTRIES - Non-English-speaking. Under-reporting < 25%
** ----------------------------
** Age-Adjusted. N=5 Countries. (Non English-speaking Caribbean)
**local name = 030
** Age and Quality Adjusted. N=5 Countries. (Non English-speaking Caribbean)
**local name = 031
** (0-74 years) Age-Adjusted. N=5 Countries. (Non English-speaking Caribbean)
**local name = 032
** (0-74 years) Age and Quality Adjusted. N=5 Countries. (Non English-speaking Caribbean)
**local name = 033
** (0-64 years) Age-Adjusted. N=5 Countries. (Non English-speaking Caribbean)
**local name = 034
** (0-64 years) Age and Quality Adjusted. N=5 Countries. (Non English-speaking Caribbean)
**local name = 035

*/


** **************************************************************




** **************************************************************
** PART 02. US 2000 STANDARD POPULATIONS
** **************************************************************
** ALL-AGES (11 age groups)
** **************************************************************
** The Standard US 2000 population
drop _all
input age11 str5 at count prop
1 	"0-1"	 3794901	0.013818
2 	"1-4"	15191619	0.055316
3 	"5-14"	39976619	0.145565
4	"15-24"	38076743	0.138646
5 	"25-34"	37233437	0.135573
6 	"35-44"	44659185	0.162613
7 	"45-54"	37030152	0.134834
8 	"55-64"	23961506	0.087247
9 	"65-74"	18135514	0.066037
10 	"75-84"	12314793	0.044842
11 	"85+"	4259173		0.015508
format count %12.0f
end
sort age11
save "data\input\us2000", replace

** **************************************************************
** 0-74 (9 age groups)
****************************************************************
** The Standard US 2000 population
drop _all
input age11 str5 at count prop
1 	"0-1"	 3794901	0.013818
2 	"1-4"	15191619	0.055316
3 	"5-14"	39976619	0.145565
4	"15-24"	38076743	0.138646
5 	"25-34"	37233437	0.135573
6 	"35-44"	44659185	0.162613
7 	"45-54"	37030152	0.134834
8 	"55-64"	23961506	0.087247
9 	"65-74"	18135514	0.066037
format count %12.0f
end
sort age11
save "data\input\us2000_74", replace

** **************************************************************
** 0-64 (8 age groups)
** **************************************************************
** The Standard US 2000 population
drop _all
input age11 str5 at count prop
1 	"0-1"	 3794901	0.013818
2 	"1-4"	15191619	0.055316
3 	"5-14"	39976619	0.145565
4	"15-24"	38076743	0.138646
5 	"25-34"	37233437	0.135573
6 	"35-44"	44659185	0.162613
7 	"45-54"	37030152	0.134834
8 	"55-64"	23961506	0.087247
format count %12.0f
end
sort age11
save "data\input\us2000_64", replace




** **************************************************************
** PART 03. CARIBBEAN REGIONAL MORTALITY RATES
** 
** FILENAME CONVENTION
** 7 sections to filename convention
**
** 1	indicator type 	--> eg. mortality rate <mr>
** 2	region		 	--> eg. Caribbean region <car>
** 3	mortality group 	--> eg. diabetes <cod7>
** 4	sex			 	--> eg. female  <1>
** 5	decade		 	--> eg. decade 2 <2>
** 6	country exclusions --> eg. Dominican Republic <2170>, No exclusions <9999>
** 7	adjustment		--> eg. age and quality adjusted <aq>
**
** EG. --> mr_car_cod2_1_1_9999_a.dta
** <mortality rate>_<caribbean>_<all-cause>_<female>_<1999-2001>_<no exclusions>_<age adjusted>

** **************************************************************

** Remove unwanted Countries
foreach var in `cod' {
	display _newline(5) "METRIC NUMBER IS: " "`var'"
	use "data\result\car_002\carib_`var'`quality'", clear
	** Keep only those countries we want before calculating rates
	#delimit ;
		keep if 						
		cid == 2010 |	/* Antigua and Barbuda */
		cid == 2025 | 	/* Aruba */
		cid == 2030 | 	/* Bahamas */
		cid == 2040 | 	/* Barbados */
		cid == 2045  |	/* Belize */
		cid == 2150 |	/* Cuba */
		 cid == 2170  |	/* Dominican Republic */
		cid == 2210  |	/* French Guiana */
		 cid == 2230 | 	/* Grenada */
		cid == 2240 | 	/* Guadeloupe */
		 cid == 2260  |	/* Guyana */
		 cid == 2270  |	/* Haiti */
		 cid == 2290  |	/* Jamaica */
		cid == 2300  |	/* Martinique */
		cid == 2380 |	/* Puerto Rico */
		cid == 2400 | 	/* St.Lucia */
		cid == 2420 | 	/* St.Vincent & Grenadines */
		 cid == 2430	|	/* Suriname */
		cid == 2440 | 	/* Trinidad and Tobago */
		cid == 2455;  	/* USVI */		
	#delimit cr
	** Collapse out unwanted countries
	** Aruba (2025)  /  Dom Rep (2170)  /  Grenada (2230)  /  Guyana (2260)  /  Suriname (2430
	** drop if cid==2025 | cid==2170 | cid==2230 | cid==2260 | cid==2430 | cid==2270 | cid==2290	
	** Jamaica (2290) and Haiti (2270)
	drop if cid==2270 | cid==2290	
	save "data\result\car_002\carib_`var'`quality'", replace
	}
	
	
** Caribbean Average Mortality rates by COD
foreach var in `cod' {
	display _newline(5) "METRIC NUMBER IS: " "`var'"
	use "data\result\car_002\carib_`var'`quality'", clear
	** Restrict age range
	drop if age11 > `age1'
	** Collapse out country indicator. Leaves us with Regional data
	drop if cid==`drop'
	collapse (sum) deaths pop, by(decade year sex age11 count)
	keep if decade<.
	drop if year==2008|year==2012
	collapse (sum) deaths pop, by(decade sex age11 count)
	
	/// Female=1, Male=2, Both=3
	forval sx = 1(1)3 {
			forval yr = 1(1)2 {
			display _newline(5) "SEX IS: " "`sx'" "  ...and...  YEAR IS: " "`yr'" 
			distrate deaths pop using "data\input\us2000`age2'" if sex==`sx' & decade==`yr', 	///
				stand(age11) popstand(prop) mult(100000) format(%8.1f)	///
				saving(data\result\car_004\mr_car_`var'_`sx'_`yr'_`drop'`age2'`quality', replace)
				}
			}
		}

** Labelling the datasets
local k=2
** Female. Decade 1 (1999-2001)
foreach var in `cod' {
	use "data\result\car_004\mr_car_`var'_1_1_`drop'`age2'`quality'.dta", clear		
	gen cod = `k'
	gen decade = 1
	gen sex = 1			
	save "data\result\car_004\mr_car_`var'_1_1_`drop'`age2'`quality'.dta", replace		
	local k=`k'+1
	}
local k=2
** Female. Decade 2 (2009-2011)
foreach var in `cod' {
	use "data\result\car_004\mr_car_`var'_1_2_`drop'`age2'`quality'.dta", clear		
	gen cod = `k'
	gen decade = 2
	gen sex = 1
	save "data\result\car_004\mr_car_`var'_1_2_`drop'`age2'`quality'.dta", replace		
	local k=`k'+1
	}
local k=2
** Male. Decade 1 (1999-2001)
foreach var in `cod' {
	use "data\result\car_004\mr_car_`var'_2_1_`drop'`age2'`quality'.dta", clear		
	gen cod = `k'
	gen decade = 1
	gen sex = 2
	save "data\result\car_004\mr_car_`var'_2_1_`drop'`age2'`quality'.dta", replace		
	local k=`k'+1
	}
local k=2
** Male. Decade 2 (2009-2011)
foreach var in `cod' {
	use "data\result\car_004\mr_car_`var'_2_2_`drop'`age2'`quality'.dta", clear		
	gen cod = `k'
	gen decade = 2
	gen sex = 2
	save "data\result\car_004\mr_car_`var'_2_2_`drop'`age2'`quality'.dta", replace		
	local k=`k'+1
	}
local k=2
** Female+Male. Decade 1 (1999-2001)
foreach var in `cod' {
	use "data\result\car_004\mr_car_`var'_3_1_`drop'`age2'`quality'.dta", clear		
	gen cod = `k'
	gen decade = 1
	gen sex = 3
	save "data\result\car_004\mr_car_`var'_3_1_`drop'`age2'`quality'.dta", replace		
	local k=`k'+1
	}
local k=2
** Female+Male. Decade 2 (2009-2011)
foreach var in `cod' {
	use "data\result\car_004\mr_car_`var'_3_2_`drop'`age2'`quality'.dta", clear		
	gen cod = `k'
	gen decade = 2
	gen sex = 3
	save "data\result\car_004\mr_car_`var'_3_2_`drop'`age2'`quality'.dta", replace		
	local k=`k'+1
	}
	
** Create a single dataset
use "data\result\car_004\mr_car_cod2_1_1_`drop'`age2'`quality'.dta"	, clear	

foreach var in `cod' {
	append using "data\result\car_004\mr_car_`var'_1_1_`drop'`age2'`quality'.dta"		
	}
foreach var in `cod' {
	append using "data\result\car_004\mr_car_`var'_1_2_`drop'`age2'`quality'.dta"		
	}
foreach var in `cod' {
	append using "data\result\car_004\mr_car_`var'_2_1_`drop'`age2'`quality'.dta"		
	}
foreach var in `cod' {
	append using "data\result\car_004\mr_car_`var'_2_2_`drop'`age2'`quality'.dta"		
	}
foreach var in `cod' {
	append using "data\result\car_004\mr_car_`var'_3_1_`drop'`age2'`quality'.dta"		
	}
foreach var in `cod' {
	append using "data\result\car_004\mr_car_`var'_3_2_`drop'`age2'`quality'.dta"		
	}
** Drop first row, which is repeated in row 2
drop if _n==1
label define decade 1 "1999-2001" 2 "2009-2011"
label values decade decade
label define sex 1 "female" 2 "male" 3 "both"
label values sex sex
label define cod 2 "all-cause" 3 "cancer" 4 "cvd-diab" 5 "heart" 6 "stroke" 7 "diabetes"
label values cod cod
save "data\result\car_004\mr_car`age2'`quality'.dta", replace






** **************************************************************
** PART 04. COUNTRY LEVEL MORTALITY RATES
** 7 sections to filename convention
**
** 1	indicator type 	--> eg. mortality rate <mr>
** 2	WHO country code	--> eg. Barbados <2040>
** 3	mortality group 	--> eg. diabetes <cod7>
** 4	sex			 	--> eg. female  <1>
** 5	decade		 	--> eg. decade 2 <2>
** 6	country exclusions --> eg. Dominican Republic <2170>, No exclusions <9999>
** 7	adjustment		--> eg. age and quality adjusted <aq>
**
** EG. --> mr_cid_cod2_1_1_9999_a.dta
** <mortality rate>_<2040>_<all-cause>_<female>_<1999-2001>_<no exclusions>_<age adjusted>
** **************************************************************

** Country-level mortality rates by COD
foreach var in `cod' {
	display _newline(5) "METRIC NUMBER IS: " "`var'"
	use "data\result\car_002\carib_`var'`quality'", clear
	** Restrict age range
	drop if age11 > `age1'
	foreach cid in `country' {
		/// Female=1, Male=2, Both=3
		forval sx = 1(1)3 {
			forval yr = 1(1)2 {
				display _newline(3) "CID is: ""`cid'""  ...and...  SEX IS: " "`sx'" "  ...and...  DECADE IS: " "`yr'" 
				distrate deaths pop using "data\input\us2000`age2'" if cid==`cid' & sex==`sx' & decade==`yr', 	///
					stand(age11) popstand(prop) mult(100000) format(%8.1f)	///
					saving(data\result\car_004\mr_`cid'_`var'_`sx'_`yr'_`drop'`age2'`quality', replace)
					}
				}
			}
		}
	
** Labelling the datasets
** Female. Decade 1 (1999-2001)
foreach cid in `country' {
	local k=2
	foreach var in `cod' {
		use "data\result\car_004\mr_`cid'_`var'_1_1_`drop'`age2'`quality'.dta", clear		
		cap drop cod year sex
		gen cid = `cid'
		gen cod = `k'
		gen decade = 1
		gen sex = 1			
		save "data\result\car_004\mr_`cid'_`var'_1_1_`drop'`age2'`quality'.dta", replace		
		local k=`k'+1
		}
	}
** Female. Decade 2 (2009-2011)
foreach cid in `country' {
	local k=2
	foreach var in `cod' {
	use "data\result\car_004\mr_`cid'_`var'_1_2_`drop'`age2'`quality'.dta", clear		
		cap drop cod year sex
		gen cid = `cid'
		gen cod = `k'
		gen decade = 2
		gen sex = 1
		save "data\result\car_004\mr_`cid'_`var'_1_2_`drop'`age2'`quality'.dta", replace		
		local k=`k'+1
		}
	}
** Male. Decade 1 (1999-2001)
foreach cid in `country' {
	local k=2
	foreach var in `cod' {
		use "data\result\car_004\mr_`cid'_`var'_2_1_`drop'`age2'`quality'.dta", clear		
		cap drop cod year sex
		gen cid = `cid'
		gen cod = `k'
		gen decade = 1
		gen sex = 2
		save "data\result\car_004\mr_`cid'_`var'_2_1_`drop'`age2'`quality'.dta", replace		
		local k=`k'+1
		}
	}
** Male. Decade 2 (2009-2011)
foreach cid in `country' {
	local k=2
	foreach var in `cod' {
		use "data\result\car_004\mr_`cid'_`var'_2_2_`drop'`age2'`quality'.dta", clear		
		cap drop cod year sex
		gen cid = `cid'
		gen cod = `k'
		gen decade = 2
		gen sex = 2
		save "data\result\car_004\mr_`cid'_`var'_2_2_`drop'`age2'`quality'.dta", replace		
		local k=`k'+1
		}
	}
** Female+Male. Decade 1 (1999-2001)
foreach cid in `country' {
	local k=2
	foreach var in `cod' {
		use "data\result\car_004\mr_`cid'_`var'_3_1_`drop'`age2'`quality'.dta", clear		
		cap drop cod year sex
		gen cid = `cid'
		gen cod = `k'
		gen decade = 1
		gen sex = 3
		save "data\result\car_004\mr_`cid'_`var'_3_1_`drop'`age2'`quality'.dta", replace		
		local k=`k'+1
		}
	}
** Female+Male. Decade 2 (2009-2011)
foreach cid in `country' {
	local k=2
	foreach var in `cod' {
		use "data\result\car_004\mr_`cid'_`var'_3_2_`drop'`age2'`quality'.dta", clear		
		cap drop cod year sex
		gen cid = `cid'
		gen cod = `k'
		gen decade = 2
		gen sex = 3
		save "data\result\car_004\mr_`cid'_`var'_3_2_`drop'`age2'`quality'.dta", replace		
		local k=`k'+1
		}
	}

** Create a single dataset (NB cid in this first example = Antigua)
use "data\result\car_004\mr_2010_cod2_1_1_`drop'`age2'`quality'.dta"	, clear	
** Use when restricting to Non English speaking caribbean
** use "data\result\car_004\mr_2025_cod2_1_1_`drop'`age2'`quality'.dta"	, clear	
** Use when restricting to Non English speaking caribbean (<25% undercount)
** use "data\result\car_004\mr_2150_cod2_1_1_`drop'`age2'`quality'.dta"	, clear	
foreach cid in `country' {
	foreach var in `cod' {
		append using "data\result\car_004\mr_`cid'_`var'_1_1_`drop'`age2'`quality'.dta"		
		}
	}
foreach cid in `country' {
	foreach var in `cod' {
		append using "data\result\car_004\mr_`cid'_`var'_1_2_`drop'`age2'`quality'.dta"		
		}
	}
foreach cid in `country' {
	foreach var in `cod' {
		append using "data\result\car_004\mr_`cid'_`var'_2_1_`drop'`age2'`quality'.dta"		
		}
	}
foreach cid in `country' {
	foreach var in `cod' {
		append using "data\result\car_004\mr_`cid'_`var'_2_2_`drop'`age2'`quality'.dta"		
		}
	}
foreach cid in `country' {
	foreach var in `cod' {
		append using "data\result\car_004\mr_`cid'_`var'_3_1_`drop'`age2'`quality'.dta"		
		}
	}
foreach cid in `country' {
	foreach var in `cod' {
		append using "data\result\car_004\mr_`cid'_`var'_3_2_`drop'`age2'`quality'.dta"		
		}
	}
** Drop first row, which is repeated in row 2
drop if _n==1
save "data\result\car_004\mr_`drop'`age2'`quality'", replace



** **************************************************************
** PART 05
** Join (append) Caribbean average MRs to country level MRs
** Naming convention for the various MR files
** **************************************************************
** Caribbean average rates
use "data\result\car_004\mr_car`age2'`quality'.dta", clear
gen cid=1000
append using "data\result\car_004\mr_`drop'`age2'`quality'"
** label country
#delimit ;
label define cid	 	
						1000 "Caribbean"
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
save "data\result\car_004\mr_`name'_`drop'`age2'`quality'", replace


** Labelling & saving a redued size dataset
order cid cod decade sex deaths N crude rateadj lb_gam ub_gam
label var cid  "Country"
label var cod "Cause of death"
label var decade "1=1999-2001, 2=2009-2011"
label var sex "1=f, 2=m, 3=both"
label var deaths "Number of deaths"
rename N pop
label var pop "Country/Region population"
label var crude "Crude mortality rate"
label var rateadj "Age-adjusted mortality rate"
label var lb_gam "age-adjusted MR lower 95% bound"
label var ub_gam "age-adjusted MR upper 95% bound"
drop se_gam lb_dob ub_dob
save "data\result\car_004\mr_`name'_`drop'`age2'`quality'_carpha", replace
saveold "data\result\car_004\mr_`name'_`drop'`age2'`quality'_carpha_v13", replace version(13)


