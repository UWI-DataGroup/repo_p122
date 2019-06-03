** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d003_car_001, replace

**  GENERAL DO-FILE COMMENTS
**  program:      d003_car_001.do
**  project:      Preparing Caribbean mortality data
**  author:       HAMBLETON \ 15-AUG-2015
**  task:         Preparing Caribbean mortality rate dataset
 
** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200

** Using the WHO Mortality Database
** And coding the 10-leading causes of deaths in the US for the year 2010

** Load data from d002_car_000.do --> and re-prepare the Mortality DataBase, keeping ALL causes of death
** And from these causes we create the 10 top CODs


** Load THREE ICD datasets
use "data\input\who_md\pop_aging\carib_icd9", clear
append using "data\input\who_md\pop_aging\carib_icd10_part1"
append using "data\input\who_md\pop_aging\carib_icd10_part2"

** Generate Mortality Database origin
gen md = 1
label define md 1"who" 2 "paho",modify
label values md md
	 
** 1A. Code each of the 10-Causes of Death --> 1 at a time, creating 11 markers (cod01 - cod11).

** ORIGINAL WHO SEX format
** We are going to RECODE this later
label define sex 1 "male" 2 "female" 9 "not specified", modify
label values sex sex

** AGE FORMAT
rename frmat af
label define af 	0 "24 groups: 0,1,2,3,4,5y...,95+" 	///
					1 "22 groups: 0,1,2,3,4,5y...,85+" 	///
					2 "19 groups: 0,1-4,5y...,85+" 	///
					3 "20 groups: 0,1,2,3,4,5y...,75+" 	///
					4 "17 groups: 0,1-4,5y...,75+" 	///
					5 "16 groups: 0,1-4,5y...,70+" 	///
					6 "15 groups: 0,1-4,5y...,65+" 	///
					7 "10 groups: 0,1-4,10y...,75+" ///
					8 "09 groups: 0,1-4,5y...,65+" ///
					9 "no age grouping", modify
label values af af			
label var af "Age stratification of death counts"

** INFANT AGE format
rename im_frmat iaf
label define iaf 	1 "4 groups: 0,1-6d,7-27d,28-365d"	///
					2 "3 groups: 0-6d,7-27d,28-365d" 	///
					8 "1 group: 0-365d"					///
					9 "no age grouping", modify
label values iaf iaf			
label var iaf "Age stratification of infant death counts"

** Labelling the death variables
label var deaths1 "Deaths at all ages"
label var deaths2 "Deaths at age 0 year"
label var deaths3 "Deaths at age 1 year"
label var deaths4 "Deaths at age 2 years"
label var deaths5 "Deaths at age 3 years"
label var deaths6 "Deaths at age 4 years"
label var deaths7 "Deaths at age 5-9 years"
label var deaths8 "Deaths at age 10-14 years"
label var deaths9 "Deaths at age 15-19 years"
label var deaths10 "Deaths at age 20-24 years"
label var deaths11 "Deaths at age 25-29 years"
label var deaths12 "Deaths at age 30-34 years"
label var deaths13 "Deaths at age 35-39 years"
label var deaths14 "Deaths at age 40-44 years"
label var deaths15 "Deaths at age 45-49 years"
label var deaths16 "Deaths at age 50-54 years"
label var deaths17 "Deaths at age 55-59 years"
label var deaths18 "Deaths at age 60-64 years"
label var deaths19 "Deaths at age 65-69 years"
label var deaths20 "Deaths at age 70-74 years"
label var deaths21 "Deaths at age 75-79 years"
label var deaths22 "Deaths at age 80-84 years"
label var deaths23 "Deaths at age 85-89 years"
label var deaths24 "Deaths at age 90-94 years"
label var deaths25 "Deaths at age 95 years and above" 
label var deaths26 "Deaths at age unspecified" 
label var im_deaths1 "Infant deaths at age 0 day"
label var im_deaths2 "Infant deaths at age 1-6 days"
label var im_deaths3 "Infant deaths at age 7-27 days"
label var im_deaths4 "Infant deaths at age 28-364 days"

order md cid year sex cause af iaf deaths* im_deaths*
sort cid year sex cause


** 17-SEP-2015
** Antigua with PAHO estimates is unbelievable outlier
** FOR CARIBBEAN SUMMARIES of ENGLISH-SPEAKING COUNTRIES
** N=12 will drop Antigua as long as we don't replace WHO data with PAHO data

** Major probable WHO undercount in Antigua 2009 (compared to PAHO version of database)
** We replace WHO MD (Antigua 2009) with PAHO MD

preserve
	use "C:\statistics\analysis\a000\24_paho_md\versions\version01\data\paho_md_002\lac_paho_mort_002", replace
	keep if cid==2010 & year==2009
	gen md = 2
	* Add ICD type
	gen list = "104"
	** Don't include sexes combined just yet
	drop if sex==0
	** recode sex to correct (and to then match) WHO database (1=female in WHO database)
	** recode sex 2=1 1=2
	order md
	drop cidun cname cabbr 
	rename paho_* *
	tempfile antigua2009
	save `antigua2009'
restore
drop if cid==2010 & year==2009 
append using `antigua2009'

/*

** In a previous version of WHO, we noted that Antigua in 2009 has a big discrepancy between WHO and PAHO databases
** Consider using Antigua 2008 data for our final year of data
** This possible change would be made in --> d004_car_002.do
		
preserve
	merge 1:1 cid year sex cause using "C:\statistics\analysis\a000\24_paho_md\versions\version01\data\paho_md_002\lac_paho_mort_002"
	order cid year sex cause deaths1 paho_deaths1 _merge
	gen ddiff = paho_deaths1 - deaths1
	** Antigua
	table cid sex year if cid==2010 & (year==2000 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Aruba
	table cid sex year if cid==2025 & (year==2000 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Bahamas
	table cid sex year if cid==2030 & (year==2000 | year==2008| year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Barbados
	table cid sex year if cid==2040 & (year==2000 | year==2008| year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Belize
	table cid sex year if cid==2045 & (year==2000 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Cuba
	table cid sex year if cid==2150 & (year==2000 | year==2001 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Dominican Republic
	table cid sex year if cid==2170 & (year==2000 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** French Guiana
	table cid sex year if cid==2210 & (year==2000 | year==2001 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Grenada
	table cid sex year if cid==2230 & (year==2000 | year==2001 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Guadeloupe
	table cid sex year if cid==2240 & (year==2000 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Guyana
	table cid sex year if cid==2260 & (year==2000 | year==2001 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Haiti
	table cid sex year if cid==2270 & (year==2000 | year==2001 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Martinique
	table cid sex year if cid==2300 & (year==2000 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Puerto Rico
	table cid sex year if cid==2380 & (year==2000 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)	
	** St.Lucia
	table cid sex year if cid==2400 & (year==2000 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** St.Vincent
	table cid sex year if cid==2420 & (year==2000 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Suriname
	table cid sex year if cid==2430 & (year==2000 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Trinidad
	table cid sex year if cid==2440 & (year==2000 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** USVI
	table cid sex year if cid==2455 & (year==2000 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)

	** NOT IN CARIBBEAN COUNTRY SAMPLE
	** ANGUILLA
	table cid sex year if cid==2005 & (year==2000 | year==2001 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** BVI
	table cid sex year if cid==2085 & (year==2000 | year==2001 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Netherland Antilles
	table cid sex year if cid==2330 & (year==2000 | year==2001 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Cayman
	table cid sex year if cid==2110 & (year==2000 | year==2001 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Dominica
	table cid sex year if cid==2160 & (year==2000 | year==2001 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Monserrat
	table cid sex year if cid==2320 & (year==2000 | year==2001 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** St.Kitts
	table cid sex year if cid==2385 & (year==2000 | year==2001 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
	** Turks
	table cid sex year if cid==2445 & (year==2000 | year==2001 | year==2008 | year==2009) & (sex==1 | sex==2) & cause=="AAA", c(sum deaths1 sum paho_deaths1 sum ddiff)
restore

*/

** **************************************************************************************************
** Cause of death 2. ALL CAUSE
** **************************************************************************************************
gen cod02 = 0
** ICD9
replace cod02 = 1 if(regexm(cause, "([B][0][0])")) & list!="104"
** ICD10
replace cod02 = 1 if(regexm(cause, "([A][A][A])")) & list=="104"



** **************************************************************************************************
** Cause of Death 3. MALIGNANT NEOPLASMS (ICD10: C00 - C97)
** **************************************************************************************************
gen cod03 = 0
** ICD9
replace cod03 = 1 if 	cause=="B08" | cause=="B09" | 	///
						cause=="B10" | cause=="B11" | 	///
						cause=="B12" | cause=="B13" |	///
						cause=="B14" & list!="104"
** ICD10
replace cod03 = 1 if(regexm(cause, "(^C[0-8][0-9])|(^C[9][0-7])")) & list=="104"





** ***************************************************************************************************
** Cause of Death 4. DIABETES, DISEASES OF HEART, CEREBROVASCULAR DISEASES
** **************************************************************************************************
gen cod04 = 0
** ICD9
replace cod04 = 1 if 	cause=="B27"  | cause=="B28"  | 	///
						cause=="B300" | cause=="B181" |		///
						cause=="B29" & list!="104"
** ICD10
** GR113-046 (Diabetes Mellitus) E10 - E14
replace cod04 = 1 if(regexm(cause, "(^E[1][0-4])"))
** GR113-059 (Acute myocardial infarction (I21-I22))
replace cod04 = 1 if(regexm(cause, "(^I[2][1-2])"))
** GR113-060 (Other acute ischemic heart diseases (I24))
replace cod04 = 1 if(regexm(cause, "(^I[2][4])"))
** GR113-062 (Atherosclerotic cardiovascular disease, so described (I25.0))
replace cod04 = 1 if(regexm(cause, "(^I[2][5][0])"))
** GR113-063 (All other forms of chronic ischemic heart disease (I20,I25.1-I25.9))
replace cod04 = 1 if(regexm(cause, "(^I[2][0])|(^I[2][5][1-9])"))
** GR113-067 (Heart failure (I50))
replace cod04 = 1 if(regexm(cause, "(^I[5][0])"))
** GR113-068 (All other forms of heart disease (I26-I28,I34-I38,I42-I49,I51))
replace cod04 = 1 if(regexm(cause, "(^I[2][6-8])|(^I[3][4-8])|(^I[4][2-9])|(^I[5][1])"))
** GR113-070 (Cerebrovascular diseases) I60 - I69
replace cod04 = 1 if(regexm(cause, "(^I[6][0-9])"))





** ***************************************************************************************************
** Cause of Death 5. DISEASES OF HEART
** **************************************************************************************************
gen cod05 = 0
** ICD9
replace cod05 = 1 if 	cause=="B27" | cause=="B28" | 	///
						cause=="B300" & list!="104"
** ICD10
** GR113-059 (Acute myocardial infarction (I21-I22))
replace cod05 = 1 if(regexm(cause, "(^I[2][1-2])"))
** GR113-060 (Other acute ischemic heart diseases (I24))
replace cod05 = 1 if(regexm(cause, "(^I[2][4])"))
** GR113-062 (Atherosclerotic cardiovascular disease, so described (I25.0))
replace cod05 = 1 if(regexm(cause, "(^I[2][5][0])"))
** GR113-063 (All other forms of chronic ischemic heart disease (I20,I25.1-I25.9))
replace cod05 = 1 if(regexm(cause, "(^I[2][0])|(^I[2][5][1-9])"))
** GR113-067 (Heart failure (I50))
replace cod05 = 1 if(regexm(cause, "(^I[5][0])"))
** GR113-068 (All other forms of heart disease (I26-I28,I34-I38,I42-I49,I51))
replace cod05 = 1 if(regexm(cause, "(^I[2][6-8])|(^I[3][4-8])|(^I[4][2-9])|(^I[5][1])"))





** ***************************************************************************************************
** Cause of Death 6. CEREBROVASCULAR DISEASES
** **************************************************************************************************
gen cod06 = 0
**ICD9
replace cod06 = 1 if(regexm(cause, "(^B[2][9])")) & list!="104"
** ICD10
** GR113-070 (Cerebrovascular diseases) I60 - I69
replace cod06 = 1 if(regexm(cause, "(^I[6][0-9])")) & list=="104"




** ***************************************************************************************************
** Cause of Death 7. DIABETES
** **************************************************************************************************
gen cod07 = 0
** ICD9
replace cod07 = 1 if(regexm(cause, "(^[B][1][8][1])")) & list!="104"
** ICD10
** GR113-046 (Diabetes Mellitus) E10 - E14
replace cod07 = 1 if(regexm(cause, "(^E[1][0-4])")) & list=="104"




** ***************************************************************************************************
** Cause of Death 8. MIS-CLASSIFICATION (R00 - R00)
** **************************************************************************************************
gen cod08 = 0
** ICD9
replace cod08 = 1 if 	cause=="B46" & list!="104"
** ICD10
replace cod08 = 1 if(regexm(cause, "(^R[0-9][0-9])"))


** Recode SEX (switch coding of women and men to Match UN WPP data)
recode sex 2=1 1=2
** NEW UN SEX format
label define sex 1 "female" 2 "male" 9 "not specified", modify
label values sex sex

** Remove INFANT GROUPS
** Drop total deaths (deaths1) to prevent overcount
** These also included in "year 0-4" age grouping
drop deaths1 iaf im*

** Countries offer DEATHS in EITHER 24 age groups (most)
** or in 22 groups (ICD9 countries: Cuba 1999-2000, Guyana 1999, St.Vincent 1999)
** Collpase occurs in next DO file, so convert these to zero counts in preparation
replace deaths24 = 0 if deaths24==. & (year==1999 | year==2000) 
replace deaths25 = 0 if deaths25==. & (year==1999 | year==2000) 


** 0,1,2,3,4,...then 5y groups...,95+
** Reshape to long format (to match the population dataset)
**
** WE MUST reshape to LONG 
** LONG --> by AGE
reshape long deaths, i(cid year sex cause md) j(ag)

** Create single FACTOR variable for alll 7 CODs
** IMPORTANT
** (heart/stroke/diabetes) are subsets of cod04 (cvd/diabetes)
** So we must generate new dataset for cod05 - cod07 and append to the main dataset
tempfile f_cod05 f_cod06 f_cod07
preserve
	** Temporary HEART dataset
	keep if cod05==1
	gen heart=1
	save `f_cod05'
restore
preserve
	** Temporary STROKE dataset
	keep if cod06==1
	gen stroke=1
	save `f_cod06'
restore
preserve
	** Temporary DIABETES dataset
	keep if cod07==1
	gen diabetes = 1
	save `f_cod07'
restore
append using `f_cod05'
append using `f_cod06'
append using `f_cod07'

gen cod = .
replace cod = 2 if cod==. & cod02==1
replace cod = 3 if cod==. & cod03==1
replace cod = 4 if cod==. & cod04==1
replace cod = 5 if          cod05==1 & heart==1
replace cod = 6 if          cod06==1 & stroke==1
replace cod = 7 if          cod07==1 & diabetes==1
replace cod = 8 if cod==. & cod08==1
replace cod = 9 if cod==.
label define cod 	2 "all-cause" 3 "cancer" 4 "cvd/diabetes" 5 "heart only" 6 "stroke only" 7 "diabetes only" 8 "mis-classification" 9 "residual",modify
					label values cod cod
					
drop cod02-cod08
sort cid year sex ag cause

** Age groups 25 groups (from 0-24 --> recoded from 2-26)
replace ag = ag-2
** Labelling age
label define ag	0 "0-1"		///
				1 "1-2"		///
				2 "2-3"		///
				3 "3-4"		///
				4 "4-5"		///
				5 "5-9"		///
				6 "10-14"		///
				7 "15-19"		///
				8 "20-24"		///
				9 "25-29"		///
				10 "30-34"		///
				11 "35-39"		///
				12 "40-44"		///
				13 "45-49"		///
				14 "50-54"		///
				15 "55-59"		///
				16 "60-64"		///
				17 "65-69"		///
				18 "70-74"		///
				19 "75-79"		///
				20 "80-84"		///
				21 "85-59"		///
				22 "90-94"		///
				23 "95+"		///
				24 "unspecified", modify
label values ag ag			
label var ag "24 Age groups"

** Save the file reading for further data management
** NB. SEX is in LONG format in this dataset (female=1, male=2)
tempfile female_male both
save `female_male'

** Collapse out SEX, then add "BOTH" (ie. women and men combined) into the dataset --> this then matches the US mortality file (1=F, 2=M, 3=B)
collapse (sum) deaths, by(cid year ag cause cod af)
gen sex = 3
save `both'

use `female_male', clear
append using `both'

** NEW UN SEX format
label define sex 1 "female" 2 "male" 3 "both" 9 "not specified", modify
label values sex sex
sort cid year sex cause ag
save "data\input\who_md\pop_aging\carib_deaths_001", replace
