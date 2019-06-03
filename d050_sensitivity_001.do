** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d050_sensitivity_001, replace

**  GENERAL DO-FILE COMMENTS
**  program:      d050_sensitivity_001.do
**  project:      
**  author:       HAMBLETON \ 12-SEP-2015
**  task:         
 
** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200


/* The following line should contain the complete path and name of your raw data file */
local dat_name "C:\statistics\analysis\a000\18_un_esa\versions\version03\data\7-interpolated_annual\F1_dem\WPP2012_INT_F1_Annual_Demographic_Indicators.dat"
/* The following line should contain the path to your output '.dta' file */
local dta_name "C:\statistics\analysis\a000\18_un_esa\versions\version03\data\7-interpolated_annual\F1_dem\WPP2012_INT_F1_Annual_Demographic_Indicators.dta"
/* The following line should contain the path to the data dictionary file */
local dct_name "C:\statistics\analysis\a000\18_un_esa\versions\version03\data\7-interpolated_annual\F1_dem\WPP2012_INT_F1_Annual_Demographic_Indicators.dct"
infile using "`dct_name'", using("`dat_name'") clear 
save `dta_name', replace

** Medium fertility variant
keep if VarID==2

** Deaths
gen death = Deaths*1000

** Restrict countries
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

** Country ID using the WHO Mortality Database codes
** UN country coding system not same as UN. Code the 1:1 relationship
gen cid = .
rename LocID cidun

replace cid = 2010 if cidun==28		/* Antigua & Barbuda*/
replace cid = 2025 if cidun==533	/* Aruba*/
replace cid = 2030 if cidun==44		/* Bahamas */
replace cid = 2040 if cidun==52		/* Barbados */
replace cid = 2045 if cidun==84		/* Belize */
replace cid = 2150 if cidun==192 	/* Cuba */
replace cid = 2170 if cidun==214 	/* Dominican Republic */
replace cid = 2210 if cidun==254 	/* French Guiana */
replace cid = 2230 if cidun==308 	/* Grenada */
replace cid = 2240 if cidun==312 	/* Guadeloupe */
replace cid = 2260 if cidun==328 	/* Guyana */
replace cid = 2270 if cidun==332 	/* Haiti */
replace cid = 2290 if cidun==388 	/* Jamaica */
replace cid = 2300 if cidun==474 	/* Martinique */
replace cid = 2380 if cidun==630 	/* Puerto Rico */
replace cid = 2400 if cidun==662 	/* Saint Lucia */
replace cid = 2420 if cidun==670 	/* Saint Vincent and Grenadines */
replace cid = 2430 if cidun==740 	/* Suriname */
replace cid = 2440 if cidun==780 	/* Trinidad and Tobago */
replace cid = 2455 if cidun==850 	/* USVI */

label var cid "WHO country codes"
#delimit ;
label define cid	 	
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
order cid
rename Time year
keep cid cidun year death
keep if year>=1999 & year<=2012
tempfile death
save `death',replace 


** LOAD and JOIN annual population data
/* The following line should contain the complete path and name of your raw data file */
local dat_name "C:\statistics\analysis\a000\18_un_esa\versions\version03\data\7-interpolated_annual\F2A_pop\WPP2012_INT_F2A_Annual_Population_Indicators.dat"
/* The following line should contain the path to your output '.dta' file */
local dta_name "C:\statistics\analysis\a000\18_un_esa\versions\version03\data\7-interpolated_annual\F2A_pop\WPP2012_INT_F2A_Annual_Population_Indicators.dta"
/* The following line should contain the path to the data dictionary file */
local dct_name "C:\statistics\analysis\a000\18_un_esa\versions\version03\data\7-interpolated_annual\F2A_pop\WPP2012_INT_F2A_Annual_Population_Indicators.dct"
infile using "`dct_name'", using("`dat_name'") clear 
save `dta_name', replace

** Medium fertility variant
keep if VarID==2
keep LocID Time PopTotal
rename Time year

** Restrict countries
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
rename LocID cidun
keep if year>=1999 & year<=2012
merge 1:1 cidun year using `death'
drop _merge
order cid year PopTotal death
 
** Listing
sort cid year
list cid year PopTotal death if year!=2012, noobs clean
list cid year PopTotal death if cid==2010 & (year==2012), noobs clean

** Save dataset
rename PopTotal un_pop
rename death un_death
label data "Caribbean Annual Pop and Death data: 1999 to 2011" 
save "C:\statistics\analysis\a054\versions\version05\data\result\sensitivity\pop_death_001", replace

