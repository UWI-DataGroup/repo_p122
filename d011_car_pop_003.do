** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\a054_car_pop_003, replace

**  GENERAL DO-FILE COMMENTS
**  program:      a054_car_pop_003.do
**  project:      
**  author:       HAMBLETON \ 12-SEP-2015
**  task:         
 
** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200

/* ENCODING CP1252 */



/* The following line should contain the complete path and name of your raw data file */
local dat_name "C:\statistics\analysis\a000\18_un_esa\versions\version03\data\2-stock_indicators\pop_broad_ages\WPP2012_DB02_Populations_Broad_Age_Groups.dat"
/* The following line should contain the path to your output '.dta' file */
local dta_name "C:\statistics\analysis\a000\18_un_esa\versions\version03\data\2-stock_indicators\pop_broad_ages\WPP2012_DB02_Populations_Broad_Age_Groups.dta"
/* The following line should contain the path to the data dictionary file */
local dct_name "C:\statistics\analysis\a000\18_un_esa\versions\version03\data\2-stock_indicators\pop_broad_ages\WPP2012_DB02_Populations_Broad_Age_Groups.dct"
infile using "`dct_name'", using("`dat_name'") clear 
save `dta_name', replace


** Select COUNTRIES
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

** Medium Fertility
keep if VarID==2

** Time restriction
keep if Time==1995 | Time==2000 | Time==2005 | Time==2010 | Time==2015
rename Time year

** Create PopTot_1_4
gen PopTot_1_4 = PopTot_0_4 - PopTot_0_1
gen Female_1_4 = Female_0_4 - Female_0_1
gen Male_1_4 = Male_0_4 - Male_0_1

** ID
rename LocID cidun

** Only want certain variables
** Ages at start and end of life course
keep cidun year PopTot_0_1 PopTot_1_4 PopTot_60_100 PopTot_65_100 PopTot_70_100 PopTot_75_100 PopTot_80_100 PopTot_85_100 PopTotal ///
				Female_0_1 Female_1_4 Female_60_100 Female_65_100 Female_70_100 Female_75_100 Female_80_100 Female_85_100 PopFemale ///
				Male_0_1 Male_1_4 Male_60_100 Male_65_100 Male_70_100 Male_75_100 Male_80_100 Male_85_100 PopMale
				
** Interpolate between quinquennial years
tsset cidun year 
tsfill
foreach var in  PopTot_0_1 PopTot_1_4 PopTot_60_100 PopTot_65_100 PopTot_70_100 PopTot_75_100 PopTot_80_100 PopTot_85_100 PopTotal ///
				Female_0_1 Female_1_4 Female_60_100 Female_65_100 Female_70_100 Female_75_100 Female_80_100 Female_85_100 PopFemale ///
				Male_0_1 Male_1_4 Male_60_100 Male_65_100 Male_70_100 Male_75_100 Male_80_100 Male_85_100 PopMale {
					bysort cidun: ipolate `var' year, gen(i_`var')
					}

drop PopTot_0_1 PopTot_1_4 PopTot_60_100 PopTot_65_100 PopTot_70_100 PopTot_75_100 PopTot_80_100 PopTot_85_100 PopTotal ///
				Female_0_1 Female_1_4 Female_60_100 Female_65_100 Female_70_100 Female_75_100 Female_80_100 Female_85_100 PopFemale ///
				Male_0_1 Male_1_4 Male_60_100 Male_65_100 Male_70_100 Male_75_100 Male_80_100 Male_85_100 PopMale

** rename population variables ready for reshaping
rename i_PopTot_0_1 p0
rename i_PopTot_1_4 p1
rename i_PopTot_60_100 p60
rename i_PopTot_65_100 p65
rename i_PopTot_70_100 p70
rename i_PopTot_75_100 p75
rename i_PopTot_80_100 p80
rename i_PopTot_85_100 p85
rename i_PopTotal PopTotal

rename i_Female_0_1 f0
rename i_Female_1_4 f1
rename i_Female_60_100 f60
rename i_Female_65_100 f65
rename i_Female_70_100 f70
rename i_Female_75_100 f75
rename i_Female_80_100 f80
rename i_Female_85_100 f85
rename i_PopFemale PopFemale

rename i_Male_0_1 m0
rename i_Male_1_4 m1
rename i_Male_60_100 m60
rename i_Male_65_100 m65
rename i_Male_70_100 m70
rename i_Male_75_100 m75
rename i_Male_80_100 m80
rename i_Male_85_100 m85
rename i_PopMale PopMale

** Keep only required years
keep if year>=1999 & year<=2012
reshape long p f m , i(cidun year) j(ag) 

** Reshape to long (sex)
** Only want men and women for now
drop p PopTotal
rename f p1 
rename m p2
** Female = 1   Male==2
reshape long p , i(cidun year ag) j(sex) 

** population x 1000 to get actual numbers
replace p = p*1000
replace PopFemale = PopFemale*1000
replace PopMale = PopMale*1000

** Rename age group
rename ag ag_start

sort cidun year sex ag_start


** tempfile
tempfile pop
**sort cidun sex
save `pop', replace



** ADD SEX-STRATIFIED SUMMARY POPULATION FOR 2000 and 2009
tempfile female male both

import excel using "C:\statistics\analysis\a000\18_un_esa\versions\version02\data\wpp_2012\01_population\WPP2012_POP_F01_2_TOTAL_POPULATION_MALE.xls", sheet("ESTIMATES") cellrange(A17:BP253) clear first
keep Majorarearegioncountryora Countrycode BC BD BE BF BG BH BI BJ BK BL BM BN BO BL BP
rename Majorarearegioncountryora country
rename Countrycode cidun
rename BC y1999
rename BD y2000
rename BE y2001
rename BF y2002
rename BG y2003
rename BH y2004
rename BI y2005
rename BJ y2006
rename BK y2007
rename BL y2008
rename BM y2009
rename BN y2010
rename BO y2011
rename BP y2012
** Select COUNTRIES
#delimit ;
keep if 							
			cidun==28	|	/*Antigua and Barbuda*/				
			cidun==533	|	/*Aruba*/							
			cidun==44	|	/*Bahamas*/							
			cidun==52	|	/*Barbados*/						
			cidun==84	|	/*Belize*/							
			cidun==192	|	/*Cuba*/							
			cidun==214	|	/*Dominican Republic*/				
			cidun==254	|	/*French Guiana*/					
			cidun==308	|	/*Grenada*/							
			cidun==312	|	/*Guadeloupe*/						
			cidun==328	|	/*Guyana*/							
			cidun==332	|	/*Haiti*/							
			cidun==388	|	/*Jamaica*/							
			cidun==474	|	/*Martinique*/						
			cidun==630	|	/*Puerto Rico*/						
			cidun==662	|	/*Saint Lucia*/						
			cidun==670	|	/*Saint Vincent*/ 					
			cidun==740	|	/*Suriname*/						
			cidun==780	|	/*Trinidad and Tobago*/				
			cidun==850		/*United States Virgin Islands*/
			;	
#delimit cr
gen sex = 2
drop country
sort cidun sex
save `male', replace

import excel using "C:\statistics\analysis\a000\18_un_esa\versions\version02\data\wpp_2012\01_population\WPP2012_POP_F01_3_TOTAL_POPULATION_FEMALE.xls", sheet("ESTIMATES") cellrange(A17:BP253) clear first
keep Majorarearegioncountryora Countrycode BC BD BE BF BG BH BI BJ BK BL BM BN BO BL BP
rename Majorarearegioncountryora country
rename Countrycode cidun
rename BC y1999
rename BD y2000
rename BE y2001
rename BF y2002
rename BG y2003
rename BH y2004
rename BI y2005
rename BJ y2006
rename BK y2007
rename BL y2008
rename BM y2009
rename BN y2010
rename BO y2011
rename BP y2012

** Select COUNTRIES
#delimit ;
keep if 							
			cidun==28	|	/*Antigua and Barbuda*/				
			cidun==533	|	/*Aruba*/							
			cidun==44	|	/*Bahamas*/							
			cidun==52	|	/*Barbados*/						
			cidun==84	|	/*Belize*/							
			cidun==192	|	/*Cuba*/							
			cidun==214	|	/*Dominican Republic*/				
			cidun==254	|	/*French Guiana*/					
			cidun==308	|	/*Grenada*/							
			cidun==312	|	/*Guadeloupe*/						
			cidun==328	|	/*Guyana*/							
			cidun==332	|	/*Haiti*/							
			cidun==388	|	/*Jamaica*/							
			cidun==474	|	/*Martinique*/						
			cidun==630	|	/*Puerto Rico*/						
			cidun==662	|	/*Saint Lucia*/						
			cidun==670	|	/*Saint Vincent*/ 					
			cidun==740	|	/*Suriname*/						
			cidun==780	|	/*Trinidad and Tobago*/				
			cidun==850		/*United States Virgin Islands*/
			;	
#delimit cr
gen sex = 1
drop country
sort cidun sex
save `female', replace

append using `male'
save `both', replace

** FINAL FILE
use `pop', clear
merge m:1 cidun sex using `both'
drop _merge

** Analysis Note: This file is SEX-STRATIFIED
sort cidun year sex ag_start
label data "Early and Late life populations - for appending with main population file"
save "data\carib_pop_003", replace



