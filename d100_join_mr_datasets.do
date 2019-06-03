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

** 16-SEP-2015
** We have (so far) created 35 separate 'final' datarepresenting a range of country inclusions
** age restrictions
** age and quality adjustments
** We join these datasets ready for graphing and for tabulating the sensitivity work

tempfile mr1 mr2 mr3 mr4 mr5 mr6 mr7 mr8 mr9
tempfile mr10 mr11 mr12 mr13 mr14 mr15 mr16 mr17 mr18 mr19
tempfile mr20 mr21 mr22 mr23 mr24 mr25 mr26 mr27 mr28 mr29
tempfile mr30 mr31 mr32 mr33 mr34 mr35
  
use "data\result\car_003\mr_1_9998_a.dta", clear
gen dataset = 1
gen arange = 1
gen adjust = 1
label var dataset "Dataset number"
label var adjust "age-adjusted or age- and quality-adjusted"
label var arange "Age range: all ages, 0-74, or 0-64"
label define adjust 1 "age" 2 "age-qual"
label values adjust adjust
label define arange 1 "all" 2 "0-74" 3 "0-64"
label values arange arange
label define dataset 	1 "N=13 under<25%"			///
						2 "N=13 under<25%"			///
						3 "N=13 under<25%"			///
						4 "N=13 under<25%"			///
						5 "N=13 under<25%"			///
						6 "N=13 under<25%"			///
						7 "N=18"			///
						8 "N=18"			///
						9 "N=18"			///
						10 "N=6"			///
						11 "N=6"			///
						12 "N=10 English"			///
						13 "N=10 English"			///
						14 "N=10 English"			///
						15 "N=10 English"			///
						16 "N=10 English"			///
						17 "N=10 English"			///
						18 "N=8 non-English"			///
						19 "N=8 non-English"			///
						20 "N=8 non-English"			///
						21 "N=8 non-English"			///
						22 "N=8 non-English"			///
						23 "N=8 non-English"			///
						24 "N=8 English under<25%"			///
						25 "N=8 English under<25%"			///
						26 "N=8 English under<25%"			///
						27 "N=8 English under<25%"			///
						28 "N=8 English under<25%"			///
						29 "N=8 English under<25%"			///
						30 "N=5 non-English under<25%"			///
						31 "N=5 non-English under<25%"			///
						32 "N=5 non-English under<25%"			///
						33 "N=5 non-English under<25%"			///
						34 "N=5 non-English under<25%"			///
						35 "N=5 non-English under<25%"			///
						,modify
labe values dataset dataset					
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr1', replace

use "data\result\car_003\mr_2_9998_aq.dta", clear
gen dataset = 2
gen arange = 1
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr2', replace

use "data\result\car_003\mr_3_9998_74_a.dta", clear
gen dataset = 3
gen arange = 2
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr3', replace

use "data\result\car_003\mr_4_9998_74_aq.dta", clear
gen dataset = 4
gen arange = 2
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr4', replace

use "data\result\car_003\mr_5_9998_64_a.dta", clear
gen dataset = 5
gen arange = 3
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr5', replace

use "data\result\car_003\mr_6_9998_64_aq.dta", clear
gen dataset = 6
gen arange = 3
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr6', replace

use "data\result\car_003\mr_7_9999_aq.dta", clear
gen dataset = 7
gen arange = 1
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr7', replace

use "data\result\car_003\mr_8_9999_74_aq.dta", clear
gen dataset = 8
gen arange = 2
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr8', replace

use "data\result\car_003\mr_9_9999_64_aq.dta", clear
gen dataset = 9
gen arange = 3
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr9', replace

use "data\result\car_003\mr_10_9997_a.dta", clear
gen dataset = 10
gen arange = 1
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr10', replace

use "data\result\car_003\mr_11_9997_aq.dta", clear
gen dataset = 11
gen arange = 1
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr11', replace

use "data\result\car_003\mr_12_9996_a.dta", clear
gen dataset = 12
gen arange = 1
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr12', replace

use "data\result\car_003\mr_13_9996_aq.dta", clear
gen dataset = 13
gen arange = 1
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr13', replace

use "data\result\car_003\mr_14_9996_74_a.dta", clear
gen dataset = 14
gen arange = 2
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr14', replace

use "data\result\car_003\mr_15_9996_74_aq.dta", clear
gen dataset = 15
gen arange = 2
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr15', replace

use "data\result\car_003\mr_16_9996_64_a.dta", clear
gen dataset = 16
gen arange = 3
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr16', replace

use "data\result\car_003\mr_17_9996_64_aq.dta", clear
gen dataset = 17
gen arange = 3
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr17', replace

use "data\result\car_003\mr_18_9995_a.dta", clear
gen dataset = 18
gen arange = 1
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr18', replace

use "data\result\car_003\mr_19_9995_aq.dta", clear
gen dataset = 19
gen arange = 1
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr19', replace

use "data\result\car_003\mr_20_9995_74_a.dta", clear
gen dataset = 20
gen arange = 2
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr20', replace

use "data\result\car_003\mr_21_9995_74_aq.dta", clear
gen dataset = 21
gen arange = 2
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr21', replace

use "data\result\car_003\mr_22_9995_64_a.dta", clear
gen dataset = 22
gen arange = 3
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr22', replace

use "data\result\car_003\mr_23_9995_64_aq.dta", clear
gen dataset = 23
gen arange = 3
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr23', replace

use "data\result\car_003\mr_24_9994_a.dta", clear
gen dataset = 24
gen arange = 1
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr24', replace

use "data\result\car_003\mr_25_9994_aq.dta", clear
gen dataset = 25
gen arange = 1
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr25', replace

use "data\result\car_003\mr_26_9994_74_a.dta", clear
gen dataset = 26
gen arange = 2
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr26', replace

use "data\result\car_003\mr_27_9994_74_aq.dta", clear
gen dataset = 27
gen arange = 2
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr27', replace

use "data\result\car_003\mr_28_9994_64_a.dta", clear
gen dataset = 28
gen arange = 3
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr28', replace

use "data\result\car_003\mr_29_9994_64_aq.dta", clear
gen dataset = 29
gen arange = 3
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr29', replace

use "data\result\car_003\mr_30_9993_a.dta", clear
gen dataset = 30
gen arange = 1
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr30', replace

use "data\result\car_003\mr_31_9993_aq.dta", clear
gen dataset = 31
gen arange = 1
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr31', replace

use "data\result\car_003\mr_32_9993_74_a.dta", clear
gen dataset = 32
gen arange = 2
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr32', replace

use "data\result\car_003\mr_33_9993_74_aq.dta", clear
gen dataset = 33
gen arange = 2
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr33', replace

use "data\result\car_003\mr_34_9993_64_a.dta", clear
gen dataset = 34
gen arange = 3
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr34', replace

use "data\result\car_003\mr_35_9993_64_aq.dta", clear
gen dataset = 35
gen arange = 3
gen adjust = 2
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `mr35', replace



use `mr1', clear
forval x = 2(1)35 {
	append using `mr`x''
	}


** Save the final dataset
rename N pop
rename rateadj i
rename lb_gam ill
rename ub_gam iul
rename se_gam ise 
drop lb_dob ub_dob
label data "Caribbean Mortality: sensitivity dataset"
save "data\result\us_carib\mr_carib_001", replace





** **********************************************************
** Add in the US results (State-level and Country-level)
** **********************************************************
tempfile us1 us2 us3 us4 us5 us6
use "data\result\us_1999_2001\us_state_002", clear
keep state race sex measure deaths pop i ins ill iul ise
gen dataset = 100
gen decade = 1
rename state cid 
rename measure cod
gen arange = 1
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `us1', replace

use "data\result\us_1999_2001_74\us_state_002", clear
keep state race sex measure deaths pop i ins ill iul ise
gen dataset = 200
gen decade = 1
rename state cid 
rename measure cod
gen arange = 2
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `us2', replace

use "data\result\us_1999_2001_64\us_state_002", clear
keep state race sex measure deaths pop i ins ill iul ise
gen dataset = 300
gen decade = 1
rename state cid 
rename measure cod
gen arange = 3
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `us3', replace

use "data\result\us_2009_2011\us_state_002", clear
keep state race sex measure deaths pop i ins ill iul ise
gen dataset = 400
gen decade = 2
rename state cid 
rename measure cod
gen arange = 1
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `us4', replace

use "data\result\us_2009_2011_74\us_state_002", clear
keep state race sex measure deaths pop i ins ill iul ise
gen dataset = 500
gen decade = 2
rename state cid 
rename measure cod
gen arange = 2
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `us5', replace

use "data\result\us_2009_2011_64\us_state_002", clear
keep state race sex measure deaths pop i ins ill iul ise
gen dataset = 600
gen decade = 2
rename state cid 
rename measure cod
gen arange = 3
gen adjust = 1
sort dataset cid decade sex cod 
order dataset adjust arange cid decade sex cod 
save `us6', replace

use `us1', clear
forval x = 2(1)6 {
	append using `us`x''
	}

** Save the final US dataset
label data "US Mortality: sensitivity dataset"
save "data\result\us_carib\mr_us_001", replace

** Join Caribbean and US datasets and save
use "data\result\us_carib\mr_carib_001", clear
append using "data\result\us_carib\mr_us_001"

#delimit ;
label define cid 0 "USA"
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
0		 "USA", modify;
#delimit cr
label values cid cid
label define race 1 "aa" 2 "white" 3 "all races",modify
label values race race

label define dataset 100 "usa" 200 "usa" 300 "usa" 400 "usa" 500 "usa" 600 "usa",modify
label values dataset dataset

label data "US and Caribbean Mortality: sensitivity dataset"
save "data\result\us_carib\mr_us_carib_001", replace
