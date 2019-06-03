** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d004_car_002, replace

**  GENERAL DO-FILE COMMENTS
**  program:      d004_car_002.do
**  project:      HD mortality analysis 2
**  author:       HAMBLETON \ 15-AUG-2015
**  task:         Preparing Caribbean mortality files
 
** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200



** Merging WHO death data with UN population data
use "data\input\who_md\pop_aging\carib_deaths_001", clear

** Revamping age to match the US Standard population for age-standardisation
** 11 groups
** 0-1, 1-4, 5-14, 15-24, 25-34, 35-44, 45-54, 55-64, 65-74, 75,84, 85+
gen age11 = .
replace age11 = 1 if ag==0
replace age11 = 2 if ag==1|ag==2|ag==3|ag==4
replace age11 = 3 if ag==5 | ag==6
replace age11 = 4 if ag==7 | ag==8
replace age11 = 5 if ag==9 | ag==10
replace age11 = 6 if ag==11 | ag==12
replace age11 = 7 if ag==13 | ag==14
replace age11 = 8 if ag==15 | ag==16
replace age11 = 9 if ag==17 | ag==18
replace age11 = 10 if ag==19 | ag==20
replace age11 = 11 if ag==21|ag==22|ag==23 

** Labelling age
label define age11	1 "0-1"		///
					2 "1-4"		///
					3 "5-14"		///
					4 "15-24"		///
					5 "25-34"		///
					6 "35-44"		///
					7 "45-54"		///
					8 "55-64"		///
					9 "65-74"		///
					10 "75-84"		///
					11 "85+", modify
label values age11 age11			
label var age11 "11 Age groups"


** TEMP COLLAPSE
**collapse (sum) deaths, by(cid sex year cod)
**sort cid year sex cod

** Major collapse 
** Decade is now the proxy for year
collapse (sum) deaths, by(cid sex year age11 cod md)


*****************************************************************
** Merge Annual Death and Population data
** carib_pop_004 --> comes from DO FILE: d012_car_pop_004.do
merge m:1 cid year sex age11 using "data\input\who_md\pop_aging\carib_pop_004"
*****************************************************************

** Years without death data in WHO Mortality database
** Analysis note: 	Merge=1 occus when death has an unknown age OR
**				    When line items of unused causes occurs (the top 6-10 CoDs --> assault, nephrotic, alzheimers etc)
**				   See below
drop if _merge==2

** Merge variable highlights those deaths for which age was unknown
rename _merge ageunk
recode ageunk 3=0
label define ageunk 0 "age known" 1 "age unknown",modify
label values ageunk ageunk
label var ageunk "Deaths for which age was unknown"
order cid cidun year age11 ageunk 

** THIS DATASET IS
** AGE-ADJUSTED
** QUALITY UNADJUSTED 
** Save the final combined deaths + population dataset
save "data\input\who_md\pop_aging\car_deaths_002_a", replace




*****************************************************************
** SUPPLEMENTARY TABLE TABULATING
**		qp1		UNDERCOUNT vs UN ESTIMATED DEATHS
**		qp2		JUNK CODES (R00-R99)
**		qp3		UNKNOWN AGE/SEX
*****************************************************************
use "data\input\who_md\pop_aging\car_deaths_002_a", clear

drop pop poptot
gen age_sex_miss = 0
replace age_sex_miss = 1 if age11==. | sex==9

** Missing age or sex by country and year
** deaths0 WITH ICD code
** deaths1 WITHOUT ICD code
preserve
	keep if cod==2 
	keep if sex==3|sex==9
	collapse (sum) deaths, by(cid year age_sex_miss)
	reshape wide deaths, i(cid year) j(age_sex_miss)
	rename deaths1 who_asmiss
	gen qp3 = (who_asmiss/deaths0)*100
	sort year cid
	tempfile who_unknown
	save `who_unknown', replace
restore

drop if age11==. | sex==9

** DEATH COUNTS BY COUNTRY AND YEAR OF MEASUREMENT
** This dataset is cut and pasted into APPEDIX TABLE looking at country-level undercount
preserve
	keep if sex==3 & cod==2
	collapse (sum) deaths, by(cid year)
	rename deaths who_death
	sort year cid
	tempfile who_deaths
	save `who_deaths', replace
restore

** Miss-classification by country and year
preserve
	keep if sex==3 
	collapse (sum) deaths, by(cid year cod)
	reshape wide deaths, i(cid year) j(cod)
	replace deaths8 = 0 if deaths8==.
	drop deaths3 deaths4 deaths5 deaths6 deaths7 deaths9 
	gen qp2 = (deaths8/deaths2)*100
	drop deaths2
	rename deaths8 who_mclass
	sort year cid
	tempfile who_misclassification
	save `who_misclassification', replace
restore

** Create amalgamated dataset for Supplementary Table --> completeness and misclassification of deaths
** Importing UN data on population and deaths
use "C:\statistics\analysis\a054\versions\version05\data\result\sensitivity\pop_death_001", clear
merge 1:1 cid year using `who_deaths'
drop if _merge==2
drop _merge
merge 1:1 cid year using `who_misclassification'
drop if _merge==2
drop _merge
merge 1:1 cid year using `who_unknown'
drop if _merge==2
drop _merge

** Undercount percentage
gen who_undercount = un_death - who_death
replace who_undercount = 0 if who_undercount<=0
gen qp1 = ((un_death - who_death)/un_death)*100
** Replace negative values with ZERO count
** replace qp1 = 0 if qp1<=0
format qp1 %9.1f
** Average undercount in (1999-2001) and in (2009-2011)
gen ind = 1 if year==1999|year==2000|year==2001
replace ind = 2 if year==2009|year==2010|year==2011
bysort cid ind: egen qp1_av1 = mean(qp1)
bysort cid: egen qp1_av2 = mean(qp1)

** Moving average of undercount (by country)
tssmooth ma qp1_av3 = qp1 , window(1 1 1)
bysort cid: egen max_av3 = max(qp1_av3)
format qp1_av3 %9.1f
order qp1_av1 qp1_av2 qp1_av3 max_av3, after(qp1)
sort cid year

** Undercount adjustment value
** We adjust for undercounts of 5% or more
** Arbitrary value intended to recognise the variable nature of annual counts from SIDS
gen qp1_5 = qp1
replace qp1_5 = 0 if qp1<5

** Misclassification percentage
format qp2 %9.1f

** Missing age/sex percentage
format qp3 %9.2f

order cid year un_pop un_death who_death who_undercount qp1 qp1_av1 qp1_av2 qp1_av3 who_mclass qp2 who_asmiss qp3 
list cid year qp1 qp1_5 qp1_av3 max_av3 if year>=1999 & year<2012, clean noobs 
list cid year un_pop un_death who_death who_undercount qp1 qp1_av3 who_mclass qp2 who_asmiss qp3 if year>=1999 & year<2012, clean noobs 

** Save this undercount dataset
tempfile adjustment
save `adjustment', replace



*****************************************************************
** ADJUSTING WHO DEATHS FOR UNDERCOUNT, MISCLASSIFICATION, and UNKNOWN AGE/SEX
**		qp1		UNDERCOUNT vs UN ESTIMATED DEATHS
**		qp2		JUNK CODES (R00-R99)
**		qp3		UNKNOWN AGE/SEX
*****************************************************************
use `adjustment'
merge 1:m cid year using "data\input\who_md\pop_aging\car_deaths_002_a"
** _merge==2 from countries not included in analysis
drop if _merge==2
drop un_pop un_death who_death who_mclass who_asmiss cidun deaths0 ageunk _merge
order cid year sex age11 cod pop poptot deaths qp1 qp2 qp3
sort cid sex year age11 cod

rename deaths udeaths
** ALL-CAUSE
**		INJURIES do not get mis-classification multiplication
**		ALL_CAUSE already includes deaths due to R codes
gen deaths_t13 = (udeaths)* (  (qp1_5/100) + (qp3/100)  )

** Remaining CODs have all three adjustments
gen deaths_t123 = (udeaths)* (  (qp1_5/100) + (qp2/100) + (qp3/100)  )
gen deaths13  = udeaths + deaths_t13
gen deaths123 = udeaths + deaths_t123
gen deaths = .

** Assign undercount and mising age/sex to ALL-CAUSE MORTALITY 
replace deaths = deaths13 if  cod==2
** Assign undercount, mis-classification, and missing age/sex to EACH specific cause of death
replace deaths = deaths123 if cod==3 | cod==4 | cod==5 | cod==6 | cod==7
table cid year if sex==3 & cod==2, c(sum udeaths sum deaths13 sum deaths123 sum deaths)
table cid year if sex==3 & cod==3, c(sum udeaths sum deaths13 sum deaths123 sum deaths)
table cid year if sex==3 & cod==4, c(sum udeaths sum deaths13 sum deaths123 sum deaths)
table cid year if sex==3 & cod==5, c(sum udeaths sum deaths13 sum deaths123 sum deaths)
table cid year if sex==3 & cod==6, c(sum udeaths sum deaths13 sum deaths123 sum deaths)
table cid year if sex==3 & cod==7, c(sum udeaths sum deaths13 sum deaths123 sum deaths)

****************************************************************
** THIS DATASET INCLUDES ADJUSTED DEATH NUMBERS
** AND CAN BE USED FOR QUALITY-ADJUSTED RATES
** Save the final combined deaths + population dataset
save "data\input\who_md\pop_aging\car_deaths_002_aq", replace
****************************************************************



****************************************************************
** UNADJUSTED DEATHS
** Caribbean deaths and populations in 3 categories
****************************************************************
use "data\input\who_md\pop_aging\car_deaths_002_a", clear

forval var = 2(1)7 {
preserve
		keep if cod==`var'
		** Drop Jamaica (2290) & Haiti (2270)
		keep if cid==2040|cid==2010|cid==2025|cid==2030|cid==2040|cid==2045|cid==2150|cid==2170	|cid==2210|		///
		cid==2230|cid==2240|cid==2260|cid==2300|cid==2380|cid==2400|cid==2420|cid==2430|cid==2440|cid==2455
		
		** Merge Caribbean data and Standard population
		** NOTE that the US Standard population is NOT sex stratified
		sort age11
		merge m:1 age11 using "data\input\us2000"
	
		** Drop deaths with unknown age
		drop if _merge==1
		drop _merge
		** Years with no deaths become 0 counts
		replace deaths = 0 if deaths==.

		** ANALYSIS NOTE
		** Deaths with unspecified SEX cannot be used in sex-specific analysis
		** More importantly, these deaths have now been re-allocated across other death categories
		drop if sex==9
		
		** Use selected years (1999-2001) and (2009-2011)
		** replace decade = . if year==2008 | year==2012
		** keep if decade<.
		** sort cid year sex age11 cod
		** collapse (sum) deaths pop poptot, by(decade year cid age11 count prop sex cod) 

		** Save the file ready for analysis
		order cid  age11 deaths pop count prop  
		sort cid  age11
		save "data\input\who_md\pop_aging\carib_cod`var'_a", replace
restore
}
	


****************************************************************
** QUALITY ADJUSTED
****************************************************************

** QUALITY-ADJUSTED DEATHS
** Caribbean deaths and populations in 11 categories
use "data\input\who_md\pop_aging\car_deaths_002_aq", clear

** DISEASE RESTRICTION
forval var = 2(1)7 {
preserve
		keep if cod==`var'
		** Drop Jamaica (2290) & Haiti (2270)
		keep if cid==2040|cid==2010|cid==2025|cid==2030|cid==2040|cid==2045|cid==2150|cid==2170	|cid==2210|		///
		cid==2230|cid==2240|cid==2260|cid==2300|cid==2380|cid==2400|cid==2420|cid==2430|cid==2440|cid==2455
		
		** Merge Caribbean data and Standard population
		** NOTE that the SUS STandard population is NOT sex stratified
		sort age11
		merge m:1 age11 using "data\input\us2000"
		
		** Drop deaths with unknown age
		drop if _merge==1
		drop _merge
		** Years with no deaths become 0 counts
		replace deaths = 0 if deaths==.

		** ANALYSIS NOTE
		** Deaths with unspecified SEX cannot be used in sex-specific analysis
		** More importantly, these deaths have now been re-allocated across other death categories
		drop if sex==9
		
		** Use selected years (1999-2001) and (2009-2011)
		** replace decade = . if year==2008 | year==2012
		** keep if decade<.
		** sort cid year sex age11 cod
		** collapse (sum) deaths pop poptot, by(decade cid age11 count prop sex cod) 

		** Save the file ready for analysis
		order cid  age11 deaths pop count prop  
		sort cid  age11
		save "data\input\who_md\pop_aging\carib_cod`var'_aq", replace
restore
}

	