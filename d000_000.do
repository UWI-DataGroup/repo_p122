
** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d000_000, replace

**  GENERAL DO-FILE COMMENTS
**  program:      d000_000.do
**  project:      MCVD-Diabetes mortlity in Caribbean and US
**  author:       HAMBLETON \ 14-SEP-2015
**  task:         
 
** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200

******************************************************************
** Listing of DO files for PAPER 03
** Comparison of Mortality Rates for Caribbean and NAM (Black and White)
** In contrast to Paper 02, comparisons now at the country-level (Caribbean) and at the State level (NAM)
** US also stratified by race (African-American and White)
******************************************************************

** ------------------------------------------------------------------------
** CHANGES
** 14-SEP-2015
** ------------------------------------------------------------------------
**
** (1) Re-Download all datasets from WONDER database
**		(A)  All ages, with stratifiers (1999-2001, 2009-2011 grouped) (N=60 files) 
**		(B)  74 years and younger, with stratifiers (N=30 files), to allow premature mortality calculation
**			(1999-2001, 2009-2011 grouped) (N=60 files) 
**		(B)  64 years and younger, with stratifiers (N=30 files), to allow premature mortality calculation
**			(1999-2001, 2009-2011 grouped) (N=60 files) 
**		(C)	We also download individual years (1999-2013) for (A-C) above. (N=60 files)
**
** (2) 	TABLE 1A
**		(A)  Recalculate all mortality rates
**		(B)  Present 95% CIs and country/US-State ranges?
**		(C) Present age-adjusted for all groups. Present quality unadjusted and adjusted for Caribbean
**
**		TABLE 1B
**		Repeat of Table 1 for deaths (0-79 years of age)
** 		Can't apply (0-74 years) for US data due to data extraction restrictions (as we want age-adjusted figures)
**
**		TABLE 1C
**		Repeat of Table 1 for deaths (0-69 years of age)
**
** (3)	TABLE 2A
** 		(A) 	PMR (Premature Mortality Rate, 0-79 years). 
**		(B)	Calc % premature. As (MR(0-79)/MR(all ages)*100)
**		(C)	Absolute change (in percentage points) between 1999-2001 and 2009-2011
**		(D)	Relative change (as a %) between 1999-2001 and 2009-2011
**
**		TABLE 2B
**		Repeat for 0-69 years of age
**	
**		REF for ideal Premature Age range: 
**				GLOBAL ACTION PLAN. World Health Organization
**				FOR THE PREVENTION AND CONTROL OF NONCOMMUNICABLE DISEASES
**				2013-2020
**
** (4) 	TABLE 3A
** 		% contribution of CVD-Diab mortality to All-cause mortality
** 		(A) At all-ages
**		(B) Among 0-79 years
**		(C) Among 0-69 years
**		(D)	Absolute change (in percentage points) between 1999-2001 and 2009-2011
**		(E)	Relative change (as a %) between 1999-2001 and 2009-2011
**
**		TABLE 3B
**		Repeat for cancers to show mortality group whose relative contribution is rising
**
** (5)	FIGURE 1. Country level premature mortality rates due to CVD/Diabetes(2000)
**		(A) Bar charts, PMR by country with US-AA and US-White included, for women, men, both
**
** (6)	FIGURE 2. Country level change in premature mortality rates due to CVD/Diabetes (between 2000 and 2009)
**		(A) Bar charts, Absolute PMR change by country with US-AA and US-White included, for women, men, both
**		
** (7)	FIGURE 3. EquiPlot. Country and State-level inequalities in %PMR due to CVD/Diabetes
**		Y-axis --> Women (Car, US), Men (Car, US), Both (Car, US)
**		X-axis --> % range 0 to 100
** 		Think about also presenting MD alongside each horizontal equiplot line...?
**
** (8) 	SENSITIVITY ANALYSES
**		Looking at the sensitivity of results to changes in our methodology. 
**		Endpoint of interest --> Change in %PMR


** SENSITIVITY ANALYSES to do
** Sensitivity analysis outcome of interest
**		- CVD-diabetes premature MR (0-79 years)
**		- % contribution of CVD
** Primary analysis: (1999-2001) and (2009-2011)
** 		- sensitivity 1: calculate rates for individual years
**			- would need to be careful about changing Caribbean country inclusions
**			- could do this for separate countries, 1-at-a-time
**			- this might show countries whose patterns were robust to changing data quality
**		- sensitivity 2: quality-adjusted
**			- repeat everything with quality adjusted numbers
**		- vary countries in Caribbean grouping. 
**			- Take one country out at a time. Similar to PlosOne paper
** ------------------------------------------------------------------------


******************************************************************
** d001_us*
******************************************************************
** a053_us_001
** Preparing and anlysing US data. 
** Health outcome metrics among US (RACE-specific --> Black and White)
******************************************************************
** We read a series of mortality datasets extracted from CDC WONDER
** wonder.cdc.gov
** data stored at: C:\statistics\analysis\a054\versions\version05\data\input\wonder\
** Meta-data for each file is available at the end of each ASCII datafile
** Data extracted from US sources for creating SEVEN metrics (numbered 2 to 7)
	** METRIC 1 (US) : 	LE at birth (country level) --> from Measure of America --> NOT USED
	** METRIC 2 (US) : 	All-cause mortality
	** METRIC 3 (US) : 	Malignant neoplasms
	** METRIC 4 (US) : 	Heart/Diabetes/Cerebrovascular diseases
	** METRIC 5 (US) : 	Heart disease only
	** METRIC 6 (US) : 	Cerebrovascular disease only
	** METRIC 7 (US) : 	Diabetes only
	** METRIC 8 (US): 	Intentional injury

	** 1999-2013 data (stratified by single year at all times - for sensitivity work)
	do "C:\statistics\analysis\a054\versions\version05\dofiles\d001_us_001.do"
	do "C:\statistics\analysis\a054\versions\version05\dofiles\d001_us_001_74.do"
	do "C:\statistics\analysis\a054\versions\version05\dofiles\d001_us_001_64.do"
	
	** 1999-2001 data (single rate for three year period)
	do "C:\statistics\analysis\a054\versions\version05\dofiles\d001_us1999_001.do"
	do "C:\statistics\analysis\a054\versions\version05\dofiles\d001_us1999_001_74.do"
	do "C:\statistics\analysis\a054\versions\version05\dofiles\d001_us1999_001_64.do"

	** 2009-2011 data (single rate for three year period)
	do "C:\statistics\analysis\a054\versions\version05\dofiles\d001_us2009_001.do"
	do "C:\statistics\analysis\a054\versions\version05\dofiles\d001_us2009_001_74.do"
	do "C:\statistics\analysis\a054\versions\version05\dofiles\d001_us2009_001_64.do"



	
** *****************************************************
** d002_car_000*
** *****************************************************
** READ and RESTRICT WHO MORTALITY DATABASE
** *****************************************************
** Read in WHO Mortality databases (ICD9 and ICD10) 
** and immediately restrict to N=20 Caribbean countries
** These countries are:
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
** Save dataset for subsequent loading to --> d003_car_001.do
**		Location --> "data\input\who_md"
do "C:\statistics\analysis\a054\versions\version05\dofiles\d002_car_000_icd9.do"
do "C:\statistics\analysis\a054\versions\version05\dofiles\d002_car_000_icd10_part1.do"
do "C:\statistics\analysis\a054\versions\version05\dofiles\d002_car_000_icd10_part2.do"



** *****************************************************
** d003_car_001.do
** *****************************************************
** INITIAL PREPARATION OF WHO DATABASE
** *****************************************************
** (A) Prepare WHO age and sex categories
** (B) MERGE with PAHO mortality database to check database discrepancies for each country
** (C) DEFINE cause of death groups using ICD9 and ICD10
** (D) Prepare and save dataset to new file for next DO file
**		Location --> "data\result\car_001\"
do "C:\statistics\analysis\a054\versions\version05\dofiles\d003_car_001.do"



** *****************************************************
** d004_car_002.do
** *****************************************************
** CREATE COUNTRY GROUPS
** MERGE WITH CARIBBEAN POPULATION DATA 
** ADJUST FOR COUNTRY/YEAR-STRATIFIED DEATH UNDERCOUNT
** *****************************************************
** (A) Create THREE different country groupings
**		group18 		- Countries with 4/6 or more years of submitted data from period (1999-2001, and 2009-2011)
**		group6		- Countries with 6/6 submitted data years 
**		group5		- Countries with 5/6 submitted data years 
**		group4		- Countries with 4/6 submitted data years 
**
** (B) KEEP only the years we need from Caribbean data. (1999-2001) and (2009-2011)
** (C) New age structure to match the US population data extraction. 11 age groups
** (D) COLLAPSE dataset by country, year, sex, age groups, cause of deaths
**		- creates counts of deaths within these categories
** (E) MERGE with CARIBBEAN populations
**		- Created in
**		- C:\statistics\analysis\a054\versions\version03\dofiles\d012_car_pop_004.do
** (F) CALCULATE undercount, misclassification, unknown age/sex proportions using an alternative mortality source 
**		- UN WPP (2012). Data prepared as tabulation. Becomes SUPPLEMENTARY TABLE.
**		- FOR MISCLASSIFICATION --> Compare R0-R99 (cod05) from WHO as % of all-cause (cod02) 
**		- MISSING AGE/SEX --> Compare structural missing as % of cod02
** (G) APPLY UNDERCOUNT percentages, MISSCLASSIFICATION percentages, and MISSING AGE/SEX percentages
**
** Dataset without quality-adjusted numbers
** 		- save "data\result\car_002\car_deaths_002", replace
** Dataset with quality-adjusted numbers
**		- save "data\result_qa\car_002\car_deaths_002", replace
**
** ENTER and SAVE the US Standard populations
**		- save "data\input\us2000", replace
**		- save "data\input\us2000_74", replace
**		- save "data\input\us2000_64", replace
**
** MERGE and SAVE Caribbean deaths and US population (non-quality adjusted / quality adjusted)
**		- save "data\result\car_002\carib_cod`var'", replace
**		- save "data\result_qa\car_002\carib_cod`var'", replace
do "C:\statistics\analysis\a054\versions\version05\dofiles\d004_car_002.do"



** *****************************************************
** d005_car_003.do
** *****************************************************
** CREATE REGIONAL and COUNTRY MORTALITY RATES
** *****************************************************
** (A) LOAD Cause of death specific datasets created in previous DO file
** (B) Generate directly standardized rates (using -distrate- package)
**		- generate rates stratified by country, cause of death grouping (cod2, cod3, cod4, etc), sex, year
**		- do this in looping structure
** (C) Merge all datasets to create a single RATES dataset
**		- save "data\result\car_003\country_rates_overall", replace
** (D) LOAD rates for Caribbean overall (created in carib_mra.do)
**		- use "data\result\carib_mra\caribbean_rates_overall", replace
** (E) TABULATE rates in 2000 and 2009, along with change between years
**		- Save a resulting dataset to ease tabulation
**		- save "data\result\car_003\country_rates_overall", replace
**		- save "data\result\car_003\caribbean_rates_overall", replace
**		- save "data\result\car_003\carib_country_001", replace
do "C:\statistics\analysis\a054\versions\version05\dofiles\d005_car_003.do"

** Using the next DO file we make TWO major changes
** Age standardization to the World population
** Allowing premture mortality as <70 years


** *****************************************************
** d100_join_mr_datasets.do
** *****************************************************
** Join the many datasets created during multiple runs of 
** d005_car_003.do
do "C:\statistics\analysis\a054\versions\version05\dofiles\d100_join_mr_datasets.do"



** *****************************************************
** d006_carib_mra.do --> NOT USED
** d008_caribqa_mra.do --> NOT USED
** *****************************************************



** *****************************************************
** d009_car_pop_001.do
** *****************************************************
** WE USE UN WPP (2012) DATA AS CARIBBEAN POP DENOMINATOR
** *****************************************************
** (A) LOAD annual population data from UN WPP
** (B) RESTRICT to N=20 Caribbean countries to reduce computation time
** (C) SAVE dataset:
**		- save "data\carib_pop_001", replace
do "C:\statistics\analysis\a054\versions\version05\dofiles\d009_car_pop_001.do"



** *****************************************************
** d010_car_pop_002.do
** *****************************************************
** FURTHER PREPARATION OF POP DENOMINATOR FILE
** *****************************************************
** (A) Attach WHO country codes in place of UN country codes
** (B) Define appropriate age and sex groups to match WHO datasset
** (C) Save dataset:
**		- save "data\carib_pop_002", replace
do "C:\statistics\analysis\a054\versions\version05\dofiles\d010_car_pop_002.do"




** *****************************************************
** d011_car_pop_003.do (prepare early life and late life populations)
** d012_car_pop_004.do (merge 
** *****************************************************
** LOAD EARLY-LIFE AND END-OF-LIFE POPULATIONS FROM UN 
** MERGE WITH MAIN CARIBBEAN POP FILE
** *****************************************************
** d011_car_pop_003.do
** (A) Early-life and and-of-life populations in  carib_pop_002 are broad
** (B) We take early-life and end-of-age populations from a different UN dataset
**		- Save dataset:
**		- save "data\carib_pop_003", replace
**
** ** d012_car_pop_004.do
** (A) Merge with age range extremes from previous DO file
** (B) Keep appropriate countries
** (D) Save dataset:
**		- save "data\carib_pop_004", replace
**		- This pop dataset is then used in --> a054_car_002.do
do "C:\statistics\analysis\a054\versions\version05\dofiles\d011_car_pop_003.do"
do "C:\statistics\analysis\a054\versions\version05\dofiles\d012_car_pop_004.do"




** *****************************************************
** GRAPHICS
** *****************************************************
** d013_barcharts
** d013_equipolot
** D013_map
** *****************************************************
** ORDERED BAR CHARTS
** *****************************************************
** Repeated for unadjusted data and quality-adjusted data
**
** FOR UNADJUSTED DATA
** (A) Load and merge caribbean and US data
**		- use "data\result\car_003\caribbean_data", clear
**		- use "data\result\us_001\us_data", clear

** NOT USED in current analysis
** But for information this produces an ordered bar-chart with Caribbean countries and US States included
do "C:\statistics\analysis\a054\versions\version05\dofiles\d013_barcharts.do"

** PRIMARY Ordered bar-chart of INCLUDED Caribbean countries
** And Race-sapecific US averages
** Weighted Av Caribbean and US values as vertical lines
do "C:\statistics\analysis\a054\versions\version05\dofiles\d013_barcharts_002.do"

** SIMILAR to _002 above
** This set of charts provides overlays for COHSOD presentation (Sep-2015)
** Charts change ordering of countries to show how countries have changeds on a single barchart
** PRIMARY Ordered bar-chart of INCLUDED Caribbean countries
** And Race-sapecific US averages
** Weighted Av Caribbean and US values as vertical lines
do "C:\statistics\analysis\a054\versions\version05\dofiles\d013_barcharts_003.do"

** SIMILAR to _002 above
** This set of charts provides overlays for COHSOD presentation (Sep-2015)
** Charts DO NOT change countries --> Keeps 2000 order. To show the bar-length change of each country
** PRIMARY Ordered bar-chart of INCLUDED Caribbean countries
** And Race-specific US averages
** Weighted Av Caribbean and US values as vertical lines
do "C:\statistics\analysis\a054\versions\version05\dofiles\d013_barcharts_004.do"

** SIMILAR to _002 above (0-74 years)
** This set of charts provides overlays for TMRI-QUINQUENNIAL presentation (Nov-2015)
** Charts DO NOT change countries --> Keeps 2000 order. To show the bar-length change of each country
** PRIMARY Ordered bar-chart of INCLUDED Caribbean countries
** And Race-specific US averages
** Weighted Av Caribbean and US values as vertical lines
do "C:\statistics\analysis\a054\versions\version05\dofiles\d013_barcharts_005.do"


** EquiPlot of (Min --- Av --- Max) CVD mortality by: DECADE, SEX, COUNTRY GROUP
** COUNTRY GROUPS ARE:
** Caribbean, US-White, US-AA, US All
do "C:\statistics\analysis\a054\versions\version05\dofiles\d013_equiplot_001.do"

** EquiPlot of (Min --- Av --- Max) CVD mortality by: DECADE, SEX, COUNTRY GROUP
** COUNTRY GROUPS ARE:
** English-Speaking Caribbean, non-English speaking, US-White, US-AA
do "C:\statistics\analysis\a054\versions\version05\dofiles\d013_equiplot_002.do"

** EquiPlot of (Min --- Av --- Max) CVD mortality by: DECADE, SEX, COUNTRY GROUP
** Restricting to SINGLE SEX/DECADE combination to allow overlays for COHSOD presentation (Sep-2015)
do "C:\statistics\analysis\a054\versions\version05\dofiles\d013_equiplot_003.do"

** EquiPlot of (Min --- Av --- Max) CVD mortality by: DECADE, SEX, COUNTRY GROUP
** Restricting to SINGLE SEX/DECADE combination to allow overlays for TMRI-QUINQUENNIAL presentation (Nov-2015)
do "C:\statistics\analysis\a054\versions\version05\dofiles\d013_equiplot_004.do"

** US MAP of CVD-Diabetes mortality
** Plotted by State, separately for women and men
do C:\statistics\analysis\a054\versions\version05\dofiles\d013_map_us_001.do

** Caribbean country MAPS of CVD-Diabetes mortality
** Women
do C:\statistics\analysis\a054\versions\version05\dofiles\d013_map_car_001.do

** Caribbean country MAPS of CVD-Diabetes mortality
** Men
do C:\statistics\analysis\a054\versions\version05\dofiles\d013_map_car_002.do



** *****************************************************
** TABLE 1
** d014_table1.do
** *****************************************************
** CARIBBEAN and US MORTALITY RATES / MORTALITY RATES RANGES
** *****************************************************
** CARIBBEAN: Regional rate and country range (min, max)
**		- separately for women, men, both
**		- separately for unadjusted and quality-adjusted
** US: Country rate and state range (min, max)
do "C:\statistics\analysis\a054\versions\version05\dofiles\d014_table1.do"
** US contribution to Table 1
do "C:\statistics\analysis\a054\versions\version05\dofiles\d014_table1_us.do"
** CARIBBEAN contribution to Table 1
do "C:\statistics\analysis\a054\versions\version05\dofiles\d014_table1_carib.do"



** *****************************************************
** TABLE 2
** d015_table2.do
** *****************************************************
** Premature Mortality
** The percentage of all age mortality explained by mortality 0-74 
** *****************************************************
** US contribution to Table 2
do "C:\statistics\analysis\a054\versions\version05\dofiles\d015_table2_us.do"
** CARIBBEAN contribution to Table 2
do "C:\statistics\analysis\a054\versions\version05\dofiles\d015_table2_carib.do"


** *****************************************************
** TABLE 3
** d015_table3_new.do
** *****************************************************
** English-Speaking Caribbean contribution to Table 3
do "C:\statistics\analysis\a054\versions\version05\dofiles\d015_table3_new_es.do"
** Non-English-Speaking Caribbean contribution to Table 3
do "C:\statistics\analysis\a054\versions\version05\dofiles\d015_table3_new_nes.do"




** *****************************************************
** NOT USED
** TABLE 3
** d016_table3.do
** *****************************************************
** CVD/DIABETES contribution to overall mortality and Premature Mortality
** *****************************************************
** US contribution to Table 3
do "C:\statistics\analysis\a054\versions\version03\dofiles\d016_table3_cvd_us.do"
** CARIBBEAN contribution to Table 3
do "C:\statistics\analysis\a054\versions\version03\dofiles\d016_table3_cvd_carib.do"
** Other Table 3 information
do "C:\statistics\analysis\a054\versions\version03\dofiles\d016_table3_cancer_us.do"
do "C:\statistics\analysis\a054\versions\version03\dofiles\d016_table3_diabetes_us.do"
do "C:\statistics\analysis\a054\versions\version03\dofiles\d016_table3_heart_us.do"
do "C:\statistics\analysis\a054\versions\version03\dofiles\d016_table3_stroke_us.do"


** *****************************************************
** d025_md.do
** *****************************************************
** NOW CREATES TABLE SUPPLEMENT IN EXCEL SPREADSHEET
** CARIBBEAN and US INDICES OF DISPARITY
** *****************************************************
**
** Create Absolute Mean Difference (and Index of Disparity)
**		- separately for women, men, both
**		- separately for unadjusted and quality-adjusted
**		- separately for each cause of death (cod2, cod3, cod4, etc)
do "C:\statistics\analysis\a054\versions\version05\dofiles\d025_md.do"




** *****************************************************
** SENSITIVITY WORK
** d050 - UN population and morality for analysing WHO MD undercount
** *****************************************************
** We perform a number of sensitivity analyses to investigate 
** the effects of exploring variations due to potential data quality
** in the Caribbean
** *****************************************************
**
** Load and prepare UN Caribbean country-level population and mortality rates (using UN WPP 2012) estimates
** These are used in a data quality adjustment applied in --> d004_car002.do 
do "C:\statistics\analysis\a054\versions\version05\dofiles\d050_sensitivity_001.do"








** *****************************************************
** US WONDER DATABASE DATA EXTRACTIONS PERFORMED
** 10-SEP-2015
** *****************************************************

** *****************************************************
** ALL CAUSE	** 1999-2001
** *****************************************************
** DONE	** Dataset 2. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder2_usa_race_20151010
** DONE	** Dataset 2. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder2_usa_race_20151010_64
** DONE	** Dataset 2. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder2_usa_race_20151010_74

** DONE	** Dataset 2. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder2_usa_20151010
** DONE	** Dataset 2. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder2_usa_20151010_64
** DONE	** Dataset 2. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder2_usa_20151010_74

** DONE	** Dataset 2. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder2_state_race_20151010
** DONE	** Dataset 2. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder2_state_race_20151010_64
** DONE	** Dataset 2. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder2_state_race_20151010_74

** DONE	** Dataset 2. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder2_state_20151010
** DONE	** Dataset 2. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder2_state_20151010_64
** DONE	** Dataset 2. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder2_state_20151010_74

** DONE	** Dataset 2. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder2_state_race_both_20151010
** DONE	** Dataset 2. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder2_state_race_both_20151010_64
** DONE	** Dataset 2. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder2_state_race_both_20151010_74

** *****************************************************
** CANCERS	** 1999-2001
** *****************************************************
** DONE	** Dataset 3. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder3_usa_race_20151010
** DONE	** Dataset 3. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder3_usa_race_20151010_64
** DONE	** Dataset 3. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder3_usa_race_20151010_74

** DONE	** Dataset 3. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder3_usa_20151010
** DONE	** Dataset 3. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder3_usa_20151010_64
** DONE	** Dataset 3. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder3_usa_20151010_74

** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder3_state_race_20151010
** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder3_state_race_20151010_64
** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder3_state_race_20151010_74

** DONE	** Dataset 3. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder3_state_20151010
** DONE	** Dataset 3. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder3_state_20151010_64
** DONE	** Dataset 3. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder3_state_20151010_74

** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 							BY STATE. 	--> wonder3_state_race_both_20151010
** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 							BY STATE. 	--> wonder3_state_race_both_20151010_64
** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 							BY STATE. 	--> wonder3_state_race_both_20151010_74

**
** *****************************************************
** CVD/DIABETES	** 1999-2001
** *****************************************************
** DONE	** Dataset 4. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder4_usa_race_20151010
** DONE	** Dataset 4. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder4_usa_race_20151010_64
** DONE	** Dataset 4. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder4_usa_race_20151010_74

** DONE	** Dataset 4. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder4_usa_20151010
** DONE	** Dataset 4. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder4_usa_20151010_64
** DONE	** Dataset 4. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder4_usa_20151010_74

** DONE	** Dataset 4. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder4_state_race_20151010
** DONE	** Dataset 4. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder4_state_race_20151010_64
** DONE	** Dataset 4. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder4_state_race_20151010_74

** DONE	** Dataset 4. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder4_state_20151010
** DONE	** Dataset 4. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder4_state_20151010_64
** DONE	** Dataset 4. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder4_state_20151010_74

** DONE	** Dataset 4. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder4_state_race_both_20151010
** DONE	** Dataset 4. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder4_state_race_both_20151010_64
** DONE	** Dataset 4. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder4_state_race_both_20151010_74
**
** *****************************************************
** HEART	** 1999-2001
** *****************************************************
** DONE	** Dataset 5. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder5_usa_race_20151010
** DONE	** Dataset 5. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder5_usa_race_20151010_64
** DONE	** Dataset 5. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder5_usa_race_20151010_74

** DONE	** Dataset 5. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder5_usa_20151010
** DONE	** Dataset 5. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder5_usa_20151010_64
** DONE	** Dataset 5. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder5_usa_20151010_74

** DONE	** Dataset 5. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder5_state_race_20151010
** DONE	** Dataset 5. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder5_state_race_20151010_64
** DONE	** Dataset 5. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder5_state_race_20151010_74

** DONE	** Dataset 5. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder5_state_20151010
** DONE	** Dataset 5. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder5_state_20151010_64
** DONE	** Dataset 5. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder5_state_20151010_74

** DONE	** Dataset 5. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder5_state_race_both_20151010
** DONE	** Dataset 5. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder5_state_race_both_20151010_64
** DONE	** Dataset 5. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder5_state_race_both_20151010_74
**
** *****************************************************
** STROKE	** 1999-2001
** *****************************************************
** DONE	** Dataset 6. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder6_usa_race_20151010
** DONE	** Dataset 6. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder6_usa_race_20151010_64
** DONE	** Dataset 6. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder6_usa_race_20151010_74

** DONE	** Dataset 6. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder6_usa_20151010
** DONE	** Dataset 6. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder6_usa_20151010_64
** DONE	** Dataset 6. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder6_usa_20151010_74

** DONE	** Dataset 6. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder6_state_race_20151010
** DONE	** Dataset 6. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder6_state_race_20151010_64
** DONE	** Dataset 6. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder6_state_race_20151010_74

** DONE	** Dataset 6. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder6_state_20151010
** DONE	** Dataset 6. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder6_state_20151010_64
** DONE	** Dataset 6. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder6_state_20151010_74

** DONE	** Dataset 6. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder6_state_race_both_20151010
** DONE	** Dataset 6. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder6_state_race_both_20151010_64
** DONE	** Dataset 6. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder6_state_race_both_20151010_74
**
** *****************************************************
** DIABETES	** 1999-2001
** *****************************************************
** DONE	** Dataset 7. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder7_usa_race_20151010
** DONE	** Dataset 7. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder7_usa_race_20151010_64
** DONE	** Dataset 7. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder7_usa_race_20151010_74

** DONE	** Dataset 7. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder7_usa_20151010
** DONE	** Dataset 7. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder7_usa_20151010_64
** DONE	** Dataset 7. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder7_usa_20151010_74

** DONE	** Dataset 7. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder7_state_race_20151010
** DONE	** Dataset 7. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder7_state_race_20151010_64
** DONE	** Dataset 7. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder7_state_race_20151010_74

** DONE	** Dataset 7. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder7_state_20151010
** DONE	** Dataset 7. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder7_state_20151010_64
** DONE	** Dataset 7. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder7_state_20151010_74

** DONE	** Dataset 7. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder7_state_race_both_20151010
** DONE	** Dataset 7. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder7_state_race_both_20151010_64
** DONE	** Dataset 7. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder7_state_race_both_20151010_74
**
** *****************************************************
** HOMICIDE	** 1999-2001
** *****************************************************
** DONE	** Dataset 8. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder8_usa_race_20151010
** DONE	** Dataset 8. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder8_usa_race_20151010_64
** DONE	** Dataset 8. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder8_usa_race_20151010_74

** DONE	** Dataset 8. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder8_usa_20151010
** DONE	** Dataset 8. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder8_usa_20151010_64
** DONE	** Dataset 8. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder8_usa_20151010_74

** DONE	** Dataset 8. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder8_state_race_20151010
** DONE	** Dataset 8. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder8_state_race_20151010_64
** DONE	** Dataset 8. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder8_state_race_20151010_74

** DONE	** Dataset 8. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder8_state_20151010
** DONE	** Dataset 8. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder8_state_20151010_64
** DONE	** Dataset 8. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder8_state_20151010_74

** DONE	** Dataset 8. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder8_state_race_both_20151010
** DONE	** Dataset 8. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder8_state_race_both_20151010_64
** DONE	** Dataset 8. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder8_state_race_both_20151010_74




** 2009-2011
**
** *****************************************************
** ALL CAUSE	** 2009-2011
** *****************************************************
** DONE	** Dataset 2. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder2_usa_race_20151010
** DONE	** Dataset 2. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder2_usa_race_20151010_64
** DONE	** Dataset 2. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder2_usa_race_20151010_74

** DONE	** Dataset 2. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder2_usa_20151010
** DONE	** Dataset 2. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder2_usa_20151010_64
** DONE	** Dataset 2. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder2_usa_20151010_74

** DONE	** Dataset 2. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder2_state_race_20151010
** DONE	** Dataset 2. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder2_state_race_20151010_64
** DONE	** Dataset 2. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder2_state_race_20151010_74

** DONE	** Dataset 2. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder2_state_20151010
** DONE	** Dataset 2. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder2_state_20151010_64
** DONE	** Dataset 2. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder2_state_20151010_74

** DONE	** Dataset 2. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder2_state_race_both_20151010
** DONE	** Dataset 2. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder2_state_race_both_20151010_64
** DONE	** Dataset 2. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder2_state_race_both_20151010_74
**
** *****************************************************
** CANCERS	** 2009-2011
** *****************************************************
** DONE	** Dataset 3. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder3_usa_race_20151010
** DONE	** Dataset 3. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder3_usa_race_20151010_64
** DONE	** Dataset 3. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder3_usa_race_20151010_74

** DONE	** Dataset 3. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder3_usa_20151010
** DONE	** Dataset 3. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder3_usa_20151010_64
** DONE	** Dataset 3. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder3_usa_20151010_74

** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder3_state_race_20151010
** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder3_state_race_20151010_64
** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder3_state_race_20151010_74

** DONE	** Dataset 3. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder3_state_20151010
** DONE	** Dataset 3. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder3_state_20151010_64
** DONE	** Dataset 3. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder3_state_20151010_74

** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder3_state_race_both_20151010
** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder3_state_race_both_20151010_64
** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder3_state_race_both_20151010_74

**
** *****************************************************
** CVD/DIABETES	** 2009-2011
** *****************************************************
** DONE	** Dataset 4. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder4_usa_race_20151010
** DONE	** Dataset 4. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder4_usa_race_20151010_64
** DONE	** Dataset 4. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder4_usa_race_20151010_74

** DONE	** Dataset 4. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder4_usa_20151010
** DONE	** Dataset 4. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder4_usa_20151010_64
** DONE	** Dataset 4. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder4_usa_20151010_74

** DONE	** Dataset 4. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder4_state_race_20151010
** DONE	** Dataset 4. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder4_state_race_20151010_64
** DONE	** Dataset 4. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder4_state_race_20151010_74

** DONE	** Dataset 4. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder4_state_20151010
** DONE	** Dataset 4. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder4_state_20151010_64
** DONE	** Dataset 4. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder4_state_20151010_74

** DONE	** Dataset 4. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder4_state_race_both_20151010
** DONE	** Dataset 4. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder4_state_race_both_20151010_64
** DONE	** Dataset 4. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder4_state_race_both_20151010_74
**
** *****************************************************
** HEART	** 2009-2011
** *****************************************************
** DONE	** Dataset 5. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder5_usa_race_20151010
** DONE	** Dataset 5. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder5_usa_race_20151010_64
** DONE	** Dataset 5. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder5_usa_race_20151010_74

** DONE	** Dataset 5. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder5_usa_20151010
** DONE	** Dataset 5. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder5_usa_20151010_64
** DONE	** Dataset 5. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder5_usa_20151010_74

** DONE	** Dataset 5. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder5_state_race_20151010
** DONE	** Dataset 5. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder5_state_race_20151010_64
** DONE	** Dataset 5. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder5_state_race_20151010_74

** DONE	** Dataset 5. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder5_state_20151010
** DONE	** Dataset 5. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder5_state_20151010_64
** DONE	** Dataset 5. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder5_state_20151010_74

** DONE	** Dataset 5. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder5_state_race_both_20151010
** DONE	** Dataset 5. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder5_state_race_both_20151010_64
** DONE	** Dataset 5. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder5_state_race_both_20151010_74
**
** *****************************************************
** STROKE	** 2009-2011
** *****************************************************
** DONE	** Dataset 6. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder6_usa_race_20151010
** DONE	** Dataset 6. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder6_usa_race_20151010_64
** DONE	** Dataset 6. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder6_usa_race_20151010_74

** DONE	** Dataset 6. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder6_usa_20151010
** DONE	** Dataset 6. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder6_usa_20151010_64
** DONE	** Dataset 6. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder6_usa_20151010_74

** DONE	** Dataset 6. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder6_state_race_20151010
** DONE	** Dataset 6. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder6_state_race_20151010_64
** DONE	** Dataset 6. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder6_state_race_20151010_74

** DONE	** Dataset 6. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder6_state_20151010
** DONE	** Dataset 6. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder6_state_20151010_64
** DONE	** Dataset 6. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder6_state_20151010_74

** DONE	** Dataset 6. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder6_state_race_both_20151010
** DONE	** Dataset 6. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder6_state_race_both_20151010_64
** DONE	** Dataset 6. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder6_state_race_both_20151010_74
**
** *****************************************************
** DIABETES	** 2009-2011
** *****************************************************
** DONE	** Dataset 7. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder7_usa_race_20151010
** DONE	** Dataset 7. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder7_usa_race_20151010_64
** DONE	** Dataset 7. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder7_usa_race_20151010_74

** DONE	** Dataset 7. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder7_usa_20151010
** DONE	** Dataset 7. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder7_usa_20151010_64
** DONE	** Dataset 7. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder7_usa_20151010_74

** DONE	** Dataset 7. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder7_state_race_20151010
** DONE	** Dataset 7. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder7_state_race_20151010_64
** DONE	** Dataset 7. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder7_state_race_20151010_74

** DONE	** Dataset 7. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder7_state_20151010
** DONE	** Dataset 7. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder7_state_20151010_64
** DONE	** Dataset 7. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder7_state_20151010_74

** DONE	** Dataset 7. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder7_state_race_both_20151010
** DONE	** Dataset 7. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder7_state_race_both_20151010_64
** DONE	** Dataset 7. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder7_state_race_both_20151010_74
**
** *****************************************************
** HOMICIDE	** 2009-2011
** *****************************************************
** DONE	** Dataset 8. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder8_usa_race_20151010
** DONE	** Dataset 8. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder8_usa_race_20151010_64
** DONE	** Dataset 8. All Mortality.	BY 			RACE, 	 GENDER.	TOTAL USA. 	--> wonder8_usa_race_20151010_74

** DONE	** Dataset 8. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder8_usa_20151010
** DONE	** Dataset 8. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder8_usa_20151010_64
** DONE	** Dataset 8. All Mortality.	BY 					 GENDER.	TOTAL USA. 	--> wonder8_usa_20151010_74

** DONE	** Dataset 8. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder8_state_race_20151010
** DONE	** Dataset 8. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder8_state_race_20151010_64
** DONE	** Dataset 8. All Mortality.	BY STATE, 	RACE, 	 GENDER.	BY STATE. 	--> wonder8_state_race_20151010_74

** DONE	** Dataset 8. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder8_state_20151010
** DONE	** Dataset 8. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder8_state_20151010_64
** DONE	** Dataset 8. All Mortality.	BY STATE, 		    	 GENDER.	BY STATE. 	--> wonder8_state_20151010_74

** DONE	** Dataset 8. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder8_state_race_both_20151010
** DONE	** Dataset 8. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder8_state_race_both_20151010_64
** DONE	** Dataset 8. All Mortality.	BY STATE, 	RACE, 				BY STATE. 	--> wonder8_state_race_both_20151010_74



** FINALLY
** *****************************************************
** CANCERS	** 1999-2013 (all years)
** *****************************************************
** DONE	** Dataset 3. All Mortality.	BY 			RACE, 	 YEAR, GENDER.	TOTAL USA. 	--> wonder3_usa_race_20151010
** DONE	** Dataset 3. All Mortality.	BY 			RACE, 	 YEAR, GENDER.	TOTAL USA. 	--> wonder3_usa_race_20151010_64
** DONE	** Dataset 3. All Mortality.	BY 			RACE, 	 YEAR, GENDER.	TOTAL USA. 	--> wonder3_usa_race_20151010_74

** DONE	** Dataset 3. All Mortality.	BY 					 YEAR, GENDER.	TOTAL USA. 	--> wonder3_usa_20151010
** DONE	** Dataset 3. All Mortality.	BY 					 YEAR, GENDER.	TOTAL USA. 	--> wonder3_usa_20151010_64
** DONE	** Dataset 3. All Mortality.	BY 					 YEAR, GENDER.	TOTAL USA. 	--> wonder3_usa_20151010_74

** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 	 YEAR, GENDER.	BY STATE. 	--> wonder3_state_race_20151010
** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 	 YEAR, GENDER.	BY STATE. 	--> wonder3_state_race_20151010_64
** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 	 YEAR, GENDER.	BY STATE. 	--> wonder3_state_race_20151010_74

** DONE	** Dataset 3. All Mortality.	BY STATE, 		    	 YEAR, GENDER.	BY STATE. 	--> wonder3_state_20151010
** DONE	** Dataset 3. All Mortality.	BY STATE, 		    	 YEAR, GENDER.	BY STATE. 	--> wonder3_state_20151010_64
** DONE	** Dataset 3. All Mortality.	BY STATE, 		    	 YEAR, GENDER.	BY STATE. 	--> wonder3_state_20151010_74

** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 	YEAR, 			BY STATE. 	--> wonder3_state_race_both_20151010
** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 	YEAR, 			BY STATE. 	--> wonder3_state_race_both_20151010_64
** DONE	** Dataset 3. All Mortality.	BY STATE, 	RACE, 	YEAR, 			BY STATE. 	--> wonder3_state_race_both_20151010_74









