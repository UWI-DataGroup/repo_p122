
** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\a054_car_pop_001, replace

**  GENERAL DO-FILE COMMENTS
**  program:     a054_car_pop_001.do
**  project:       Caribbean vs. US
**  author:        HAMBLETON \ 30-OCT-2014
**  task:           Mortality in US and in the Caribbean 
 
** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200

** Population data
** Although WHO provide a population file, it not complete.
** We use instead the more complete UN WPP (2012 revision) population file.
** Choose population file stratified by AGE (19 age groups).

/* The following line should contain the complete path and name of your raw data file */
local dat_name "C:\statistics\analysis\a000\18_un_esa\versions\version03\data\4-population\pop_annual\WPP2012_DB04_Population_Annual.dat"
/* The following line should contain the path to your output '.dta' file */
local dta_name "C:\statistics\analysis\a000\18_un_esa\versions\version03\data\4-population\pop_annual\WPP2012_DB04_Population_Annual.dta"
/* The following line should contain the path to the data dictionary file */
local dct_name "C:\statistics\analysis\a000\18_un_esa\versions\version03\data\4-population\pop_annual\WPP2012_DB04_Population_Annual.dct"
infile using "`dct_name'", using("`dat_name'") clear 
save `dta_name', replace

** Select ALL REQUIRED COUNTRIES
** UN country codes not the same as WHO country codes :(
#delimit ;
keep if 							
			LocID==28	|	/*Antigua and Barbuda*/				
			LocID==533	|	/*Aruba*/							
			LocID==44	|	/*Bahamas*/							
			LocID==52	|	/*Barbados*/						
			LocID==84	|	/*Belize*/							
			LocID==192	|	/*Cuba*/							
			LocID==214	|	/*Dominican Republic*/				
			LocID==254	|	/*French Guiana*/					
			LocID==308	|	/*Grenada*/							
			LocID==312	|	/*Guadeloupe*/						
			LocID==328	|	/*Guyana*/							
			LocID==332	|	/*Haiti*/							
			LocID==388	|	/*Jamaica*/							
			LocID==474	|	/*Martinique*/						
			LocID==630	|	/*Puerto Rico*/						
			LocID==662	|	/*Saint Lucia*/						
			LocID==670	|	/*Saint Vincent*/ 					
			LocID==740	|	/*Suriname*/						
			LocID==780	|	/*Trinidad and Tobago*/				
			LocID==850		/*United States Virgin Islands*/
			;	
#delimit cr

** FILE _01
** Age-related deaths: raw
** Original format with rows by COUNTRY, by YEAR, by SEX, by CAUSE, by AGE
sort LocID MidPeriod SexID AgeGrp
label data "Caribbean population using UN WPP (2012 rev): 1980-2010 (age-stratified). RAW DATA"
save "data\carib_pop_001", replace
