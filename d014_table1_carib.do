** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d014_table1_carib, replace

**  GENERAL DO-FILE COMMENTS
**  program:      	d014_table1_carib.do
**  project:      	CVD-Diabetes mortality
**  author:       	HAMBLETON \ 14-SEP-2015
**  task:         	Caribbean contribution to Table 1
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
** Tabulate Caribbean Mortality Rates (average, State-level range) 
** Choose correct dataset for tabulation
** -------------------------------------------------------------------------------------
** N=13
** Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_1_9998_a", clear
** Age and quality adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_2_9998_aq", clear

** (0-74 yrs) Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_3_9998_74_a", clear
** (0-74 yrs) Age and quality adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_4_9998_74_aq", clear

** (0-64 yrs) Age adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_5_9998_64_a", clear
** (0-64 yrs) Age and quality adjusted. N=5 countries removed (Aruba, DomRep, Grenada, Guyana, Suriname)
use "data\result\car_003\mr_6_9998_64_aq", clear

** N=18
** Age and quality adjusted. 
use "data\result\car_003\mr_7_9999_aq", clear
** (0-74 yrs) Age and quality adjusted. 
use "data\result\car_003\mr_8_9999_74_aq", clear
** (0-64 yrs) Age and quality adjusted. 
use "data\result\car_003\mr_9_9999_64_aq", clear

** N=6
** Age adjusted. N=6 countries 
**use "data\result\car_003\mr_10_9997_a", clear
** Age adjusted. N=6 countries 
**use "data\result\car_003\mr_11_9997_aq", clear

** N=10
** English-speaking. Age adjusted. N=10 countries 
use "data\result\car_003\mr_12_9996_a", clear
** Age and quality adjusted adjusted. N=10 countries 
use "data\result\car_003\mr_13_9996_aq", clear
** (0-74 yrs)  Age adjusted. N=10 countries 
use "data\result\car_003\mr_14_9996_74_a", clear
** (0-74 yrs)  Age and quality adjusted adjusted. N=10 countries 
use "data\result\car_003\mr_15_9996_74_aq", clear
** (0-64 yrs)  Age adjusted. N=10 countries 
use "data\result\car_003\mr_16_9996_64_a", clear
** (0-64 yrs)  Age and quality adjusted adjusted. N=10 countries 
use "data\result\car_003\mr_17_9996_64_aq", clear

** N=8
** non-English-speaking. Age adjusted. N=8 countries 
**use "data\result\car_003\mr_18_9995_a", clear
** Age and quality adjusted adjusted. N=8 countries 
**use "data\result\car_003\mr_19_9995_aq", clear
** (0-74 yrs)  Age adjusted. N=8 countries 
**use "data\result\car_003\mr_20_9995_74_a", clear
** (0-74 yrs)  Age and quality adjusted adjusted. N=8 countries 
**use "data\result\car_003\mr_21_9995_74_aq", clear
** (0-64 yrs)  Age adjusted. N=8 countries 
**use "data\result\car_003\mr_22_9995_64_a", clear
** (0-64 yrs)  Age and quality adjusted adjusted. N=8 countries 
**use "data\result\car_003\mr_23_9995_64_aq", clear

** N=8
** English-speaking. Age adjusted. English-speaking N=8 countries 
use "data\result\car_003\mr_24_9994_a", clear
** Age and quality adjusted adjusted. N=8 countries 
use "data\result\car_003\mr_25_9994_aq", clear
** (0-74 yrs)  Age adjusted. N=8 countries 
use "data\result\car_003\mr_26_9994_74_a", clear
** (0-74 yrs)  Age and quality adjusted adjusted. N=8 countries 
use "data\result\car_003\mr_27_9994_74_aq", clear
** (0-64 yrs)  Age adjusted. N=8 countries 
use "data\result\car_003\mr_28_9994_64_a", clear
** (0-64 yrs)  Age and quality adjusted adjusted. N=8 countries 
use "data\result\car_003\mr_29_9994_64_aq", clear

** N=5
** non-English-speaking. Age adjusted. non-English-speaking N=5 countries 
**use "data\result\car_003\mr_30_9993_a", clear
** Age and quality adjusted adjusted. N=5 countries 
**use "data\result\car_003\mr_31_9993_aq", clear
** (0-74 yrs)  Age adjusted. N=5 countries 
**use "data\result\car_003\mr_32_9993_74_a", clear
** (0-74 yrs)  Age and quality adjusted adjusted. N=5 countries 
**use "data\result\car_003\mr_33_9993_74_aq", clear
** (0-64 yrs)  Age adjusted. N=5 countries 
**use "data\result\car_003\mr_34_9993_64_a", clear
** (0-64 yrs)  Age and quality adjusted adjusted. N=5 countries 
**use "data\result\car_003\mr_35_9993_64_aq", clear

** -------------------------------------------------------------------------------------
order cid decade sex cod rateadj lb_gam ub_gam
drop deaths N crude lb_dob ub_dob se_gam

** Prepare dataset for Table 1 listing 
** List RATE + CI
sort decade cod sex 
list decade cod sex rateadj lb_gam ub_gam if cod!=3 & cid==1000, sep(3)


** Minimum and maximum COUNTRY value
bysort decade cod sex: egen minr = min(rateadj)
bysort decade cod sex: egen maxr = max(rateadj)
gen smin1 = cid if minr==rateadj
gen smax1 = cid if maxr==rateadj
bysort decade cod sex: egen smin = min(smin1)
bysort decade cod sex: egen smax = min(smax1)
label values smax cid
label values smin cid
format minr %9.1f
format maxr %9.1f
** Keeping the Caribbean average rate 
keep if cid==1000

** List Countries with MIN and MAX rates for each indicator by DECADE and SEX
sort cid decade cod sex
list cid decade cod sex rateadj lb_gam ub_gam minr maxr if cod!=3, clean noobs



