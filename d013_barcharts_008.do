** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d013_barcharts_008, replace

**  GENERAL DO-FILE COMMENTS
**  program:      d013_barcharts_008.do
**  project:      
**  author:       HAMBLETON \ 20-AUG-2015
**  task:         Mortality rates in the Caribbean 
 

 ** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200

** Primary dataset created using --> d100_join_mr_datasets.do
use "data\result\us_carib\mr_us_carib_001", clear

** Create STRING variable from label of LOC. This is to allow meaningful country/state names to be used on graphic Y-AXIS
decode cid, gen(cid_string)





** ************************************************************************************
** GRAPHICS - UNADJUSTED 
** SELECT sub-group for graphing. We produce 3 graphs
** ************************************************************************************
**
** 001
** Keep Caribbean countries and US Averages
** Keep Caribbean data
**	-->	(N=8, English-speaking, 0-74, age adjusted, dataset 24)
**	-->	(N=5, non-English-speaking, 0-74, age adjusted, dataset 30)
** Keep US data (Averages and State-level)
**	--> (1999-2001, 0-74, age-adjusted, dataset 200) 
**	--> (2009-2011, 0-74, age-adjusted, dataset 500) 
** All ages
** keep if dataset==24 | dataset==30 | dataset==100 | dataset==400
** 0-74
keep if dataset==26 | dataset==32 | dataset==200 | dataset==500
** 0-64
**keep if dataset==28 | dataset==34 | dataset==300 | dataset==600



replace dataset = 100 if dataset==400
replace dataset = 200 if dataset==500
replace dataset = 300 if dataset==600



** 002
** Choose decade (1==1999-2001, 2=2009-2011)
keep if decade==2

** 003
** Choose age range
** 1=all ages, 2=0-74, 3=0-64
keep if arange==2

** 004
** Choose mortality group
** ALL-CAUSE 				(COD=2). 
** CANCER					(COD=3)
** CVD/DIABETES				(COD=4)
** HEART					(COD=5)
** STROKE					(COD=6)
** DIABETES					(COD=7)
keep if cod==4

** 005
** SEX
** 1=female, 2=male, 3=both
keep if sex==1 | sex==2

** 006
** Only for US datasets. Race. 1=AA, 2=White, 3=All
keep if race==1 | race==2 | race>=.

** SELECT RATE RANGE FOR X-AXIS

** (0-74). N=13. CVD/DIABETES
local tick1 = "0(100)300"
local tick2 = "0(50)300"
local tick3 = "0(10)320"
local title1 = "CVD / diabetes mortality rate"


** ************************************************************************************

** Fill in race variable for caribbean countries
replace race = 1 if dataset==24 | dataset==26 | dataset==28 | dataset==30 | dataset==32 | dataset==34

** Reshape to SEX wide
keep dataset cid cid_string sex race i
reshape wide i, i(dataset cid cid_string race) j(sex)


** Year specific values
gen inc1 = i1
gen us1  = i1 if cid==0 & race==1 
gen ca1  = i1 if cid==1000 
gen inc2 = i2
gen us2  = i2 if cid==0 & race==1 
gen ca2  = i2 if cid==1000 


** US average 
egen usmean1 = min(us1)
egen usmean2 = min(us2)
drop us1 us2
replace usmean1 = round(usmean1,1)
replace usmean2 = round(usmean2,1)
local usmean1 = usmean1 
local usmean2 = usmean2 

** Caribbean average 
egen carmean1 = min(ca1)
egen carmean2 = min(ca2)
drop ca1 ca2
replace carmean1 = round(carmean1,1)
replace carmean2 = round(carmean2,1)
local carmean1 = carmean1
local carmean2 = carmean2


** ONLY plot those for whom complete information exists
keep if inc1<. & inc2<.


** Keep Caribbean regional average ONLY
** drop if cid==1000
** Keep Caribbean COUNTRY LEVEL DATA ONLY --> we don't want these as bars in the charts
drop if cid>1000
** Drop US regional average (ALL RACES)--> we don't want this as a bar in the charts
** drop if cid==0 & race==3

** 1999-2001 --> Attach Appropriate country names to re-ordered country values (Y-AXIS labelling)
sort inc1
gen cid1_string = cid_string
replace cid1_string = "US African-American" if cid==0 & race==1
replace cid1_string = "US White-American" if cid==0 & race==2
gen cid1 = _n
order cid cid1_string cid1
labmask cid1, values(cid1_string) 
order cid cid1_string cid1

** 2009-2011 --> Attach Appropriate country names to re-ordered country values (Y-AXIS labelling)
sort inc2
gen cid2_string = cid_string
replace cid2_string = "US African-American" if cid==0 & race==1
replace cid2_string = "US White-American" if cid==0 & race==2
gen cid2 = _n
order cid cid2_string cid2
labmask cid2, values(cid2_string) 
order cid cid2_string cid2

replace usmean1 = . if cid1>=4
replace usmean2 = . if cid2>=4
replace carmean1 = . if cid1>=4
replace carmean2 = . if cid2>=4

** Country Change
gen cc = cid1-cid2
order cid1 cid2 cc


** CARICOM indicator
gen car = 0
replace car = 1 if cid==2040 | cid==2400 | cid==2030 | cid==2420 | cid==2010 | cid==2440 | cid==2045
replace car = 1 if dataset==24 | dataset==26 | dataset==28

** non-CARICOM
gen non_car = 0
replace non_car = 1 if cid==2300 | cid==2240 | cid==2210 | cid==2380 | cid==2455 | cid==2150
replace non_car = 1 if dataset==30 | dataset==32 | dataset==34


** Order for 1999-2001
sort inc1 cid
gen loc3 = _n
order cid cid_string loc3
labmask loc3, values(cid_string) 
order cid cid_string loc3 

** Order for 2009-2011
sort inc2 cid
gen loc4 = _n
order cid cid_string loc4
labmask loc4, values(cid_string) 
order cid cid_string loc4 




	

** GRAPHIC		TWO COLOURS, WHITE AMERICA, BLACK AMERICA
**				CARIBBEAN AVERAGES in PURPLE (nES) and RED (ES)
#delimit ;
	graph twoway 
		/// US-States 
		(bar inc2 loc4 if race==1 ,  							horiz lc(blue*0.75) fc(blue*0.75))
		(bar inc2 loc4 if race==2,  							horiz lc(orange*0.75) fc(orange*0.75))
		(bar inc2 loc4 if race==1 & cid>=1000 & car==1,  		horiz lc(red*0.75) fc(red*0.75))
		(bar inc2 loc4 if race==1 & cid>=1000 & non_car==1,  	horiz lc(purple*0.75) fc(purple*0.75))


		/// US-States  (WOMEN)
		///(bar inc1 loc3 if race==1 ,  					lc(blue*0.4) fc(blue*0.4))
		///(bar inc1 loc3 if race==2,  							lc(orange*0.4) fc(orange*0.4))
		///(bar inc1 loc3 if race==1 & cid>=1000 & car==1,  		lc(red*0.75) fc(red*0.5))
		///(bar inc1 loc3 if race==1 & cid>=1000 & non_car==1,  	lc(purple*0.75) fc(purple*0.5))

		,
		plotregion(c(gs16) ic(gs16) ilw(thick) lw(thick)) 
		graphregion(color(gs16) ic(gs16) ilw(thick) lw(thick)) 
		ysize(10) xsize(6)

		ylab(, 
		labs(2.5) nogrid glc(gs14) angle(0) labgap(1))
		yscale(lw(vthin) off) ytitle("`title1'", margin(t=4) size(2.5)) 
		
		xlab(`tick1', valuelab
		labs(6) nogrid glc(gs14) angle(0) format(%9.0f))
		xtitle("", margin(r=3) size(large))
		xscale(lw(vthin) fill) 	
		xtick(`tick2')
		xmtick(`tick3')
		
		legend(off)
		;
	#delimit cr	
	
/






