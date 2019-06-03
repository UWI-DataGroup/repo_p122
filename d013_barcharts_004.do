** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d013_barcharts_003, replace

**  GENERAL DO-FILE COMMENTS
**  program:      d013_barcharts_003.do
**  project:      
**  author:       HAMBLETON \ 20-SEP-2015
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

** Keep Caribbean countries and US Averages
keep if cid==0 | cid>100




** ************************************************************************************
** GRAPHICS - UNADJUSTED 
** SELECT sub-group for graphing. We produce 3 graphs
** ************************************************************************************
**
** 001
** Choose Caribbean data from 35 alternative sensitivity datasets. Also keep US datasets (dataset 100 and higher)
** ALL AGES. N=13 Caribbean countries with undercount < 25% (age adjusted only)
** keep if dataset==1 | dataset>=100
** (0-74 YRS). N=13 Caribbean countries with undercount < 25% (age adjusted only)
**keep if dataset==3 | dataset>=200
** (0-64 YRS). N=13 Caribbean countries with undercount < 25% (age adjusted only)
keep if dataset==5 | dataset==300 | dataset==600

** 002
** Choose decade (1==1999-2001, 2=2009-2011)
keep if decade == 1 | decade==2

** 003
** Choose age range
** 1=all ages, 2=0-74, 3=0-64
keep if arange==3

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
keep if sex==2

** 006
** Only for US datasets. Race. 1=AA, 2=White, 3=All
keep if race==1 | race==2 | race>=.

** SELECT RATE RANGE FOR X-AXIS

** N=13. All ages. CVD/DIABETES
local tick1 = "100(200)900"
local tick2 = "0(100)900"
local title1 = "CVD / diabetes mortality rate"


** N=13. All ages. ALL-CAUSE
local tick1 = "400(200)1800"
local tick2 = "400(100)1800"
local title1 = "All-cause mortality rate"

** (0-74). N=13. All ages. ALL-CAUSE
local tick1 = "100(100)900"
local tick2 = "100(50)900"
local title1 = "All-cause mortality rate"

** (0-74). N=13. CVD/DIABETES
local tick1 = "100(100)400"
local tick2 = "0(50)400"
local title1 = "CVD / diabetes mortality rate"

** (0-64). N=13. CVD/DIABETES (WOMEN)
local tick1 = "0(50)150"
local tick2 = "0(25)150"
local title1 = ""

** (0-64). N=13. CVD/DIABETES (MEN)
local tick1 = "0(50)200"
local tick2 = "0(25)200"
local title1 = ""


** ************************************************************************************

** Reshape to decade wide
keep cid cid_string decade sex race i
reshape wide i, i(cid cid_string sex race) j(decade)



** Year specific values
gen inc2001 = i1
gen us2001  = i1 if cid==0 & race==1 
gen ca2001  = i1 if cid==1000 
gen inc2011 = i2
gen us2011  = i2 if cid==0 & race==1 
gen ca2011  = i2 if cid==1000 


** US average 
egen usmean2001 = min(us2001)
egen usmean2011 = min(us2011)
drop us2001 us2011
replace usmean2001 = round(usmean2001,1)
replace usmean2011 = round(usmean2011,1)
local usmean2001 = usmean2001 
local usmean2011 = usmean2011 

** Caribbean average 
egen carmean2001 = min(ca2001)
egen carmean2011 = min(ca2011)
drop ca2001 ca2011
replace carmean2001 = round(carmean2001,1)
replace carmean2011 = round(carmean2011,1)
local carmean2001 = carmean2001
local carmean2011 = carmean2011



** Drop Caribbean regional average --> we don't want this as a bar in the charts
drop if cid==1000
** Drop US regional average (ALL RACES)--> we don't want this as a bar in the charts
drop if cid==0 & race==3

** 1999-2001 --> Attach Appropriate country names to re-ordered country values (Y-AXIS labelling)
sort inc2001
gen cid2001_string = cid_string
replace cid2001_string = "US African-American" if cid==0 & race==1
replace cid2001_string = "US White-American" if cid==0 & race==2
gen cid2001 = _n
order cid cid2001_string cid2001
labmask cid2001, values(cid2001_string) 
order cid cid2001_string cid2001

** 2009-2011 --> Attach Appropriate country names to re-ordered country values (Y-AXIS labelling)
sort inc2011
gen cid2011_string = cid_string
replace cid2011_string = "US African-American" if cid==0 & race==1
replace cid2011_string = "US White-American" if cid==0 & race==2
gen cid2011 = _n
order cid cid2011_string cid2011
labmask cid2011, values(cid2011_string) 
order cid cid2011_string cid2011 

replace usmean2001 = . if cid2001>=4
replace usmean2011 = . if cid2011>=4
replace carmean2001 = . if cid2001>=4
replace carmean2011 = . if cid2011>=4

** Country Change
gen cc = cid2001-cid2011
order cid2001 cid2011 cc


** CARICOM indicator
gen car = 0
replace car = 1 if cid==2040 | cid==2400 | cid==2030 | cid==2420 | cid==2010 | cid==2440 | cid==2045

** non-CARICOM
gen non_car = 0
replace non_car = 1 if cid==2300 | cid==2240 | cid==2210 | cid==2380 | cid==2455 | cid==2150


/*

** This generates "r(levels)" for use as labelling on Y-AXIS
levelsof cid2001

** THE GRAPHIC. PART ONE. 1999-2001. USUAL COLOR
#delimit ;
	graph twoway 
		/// USA African-American
		(bar inc2001 cid2001 if race==1, horizontal lc(gs7) lw(0.001) fc(gs7))
		/// USA White-American
		(bar inc2001 cid2001 if race==2 , horizontal lc(gs7) lw(0.001) fc(gs7))
		/// CARICOM
		(bar inc2001 cid2001 if car==1 , horizontal lc("91 146 229") lw(0.001) fc("91 146 229") )
		/// non CARICOM
		(bar inc2001 cid2001 if non_car==1 , horizontal lc("153 130 180") lw(0.001) fc("153 130 180") )
		///(line cid2001 usmean2001           , lp("l") lc(gs10) lw(1))
		///(line cid2001 carmean2001          , lp("l") lc(gs0) lw(1))
		,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		ysize(5)
		yscale(reverse)
		bgcolor(gs16)

		xlab(`tick1', 
		labs(4) nogrid glc(gs14) angle(0) labgap(1))
		xscale(lw(vthin)) xtitle("`title1'", margin(t=3) size(2.5)) 
		xmtick(`tick2')
		
		ylab(`r(levels)', valuelab
		labs(3.5) nogrid glc(gs14) angle(0) format(%9.0f))
		ytitle("", margin(r=3) size(large))
		yscale(lw(vthin) fill) 	
		
		///text(0 `carmean2001' "`carmean2001'", place(w) size(4))
		///text(0 `usmean2001' "`usmean2001'", place(e) size(4))
		
		legend(off)
		;
#delimit cr




** This generates "r(levels)" for use as labelling on Y-AXIS
levelsof cid2011

** THE GRAPHIC. PART TWO. 2009-2011 & 1999-2001. FADED
#delimit ;
	graph twoway 

		/// USA African-American
		(bar inc2001 cid2001 if race==1 , horizontal lc(gs13) lw(0.001) fc(gs13))
		(bar inc2011 cid2001 if race==1 , horizontal lc(gs7) lw(0.001) fc(gs7))

		/// USA White-American
		(bar inc2001 cid2001 if race==2 , horizontal lc(gs13) lw(0.001) fc(gs13))

		/// CARICOM
		(bar inc2001 cid2001 if car==1 , horizontal lc("176 203 242") lw(0.001) fc("176 203 242") )
		(bar inc2011 cid2001 if car==1 , horizontal lc("91 146 229") lw(0.001) fc("91 146 229") )

		/// non CARICOM
		(bar inc2001 cid2001 if non_car==1 , horizontal lc("230 224 236") lw(0.001) fc("230 224 236") )
		(bar inc2011 cid2001 if non_car==1 , horizontal lc("153 130 180") lw(0.001) fc("153 130 180") )

		(bar inc2011 cid2001 if race==2 , horizontal lc(gs7) lw(0.001) fc(gs7))

		///(line cid2011 usmean2011          , lp("l") lc(gs10) lw(1))
		///(line cid2011 carmean2011         , lp("l") lc("176 203 242") lw(1))
		,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		ysize(5)
		bgcolor(gs16)

		xlab(`tick1', 
		labs(4) nogrid glc(gs14) angle(0) labgap(1))
		xscale( lw(vthin)) xtitle("`title1'", margin(t=3) size(2.5)) 
		xmtick(`tick2')
		
		ylab(`r(levels)', valuelab labs(3.5) nogrid glc(gs14) angle(0) format(%9.0f))
		ytitle("",  margin(r=3) size(large))
		yscale(reverse lw(vthin) fill) 	
		
		///text(0 `carmean2011' "`carmean2011'", place(w) size(4))
		///text(0 `usmean2011' "`usmean2011'", place(e) size(4))
		
		legend(off)
		;
	#delimit cr


*/

** This generates "r(levels)" for use as labelling on Y-AXIS
levelsof cid2011
** HIGHLIGHT BARBADOS
#delimit ;
	graph twoway 

		/// USA African-American
		(bar inc2001 cid2001 if race==1 , horizontal lc(gs13) lw(0.001) fc(gs13))
		(bar inc2011 cid2001 if race==1 , horizontal lc(gs7) lw(0.001) fc(gs7))

		/// USA White-American
		(bar inc2001 cid2001 if race==2 , horizontal lc(gs13) lw(0.001) fc(gs13))

		/// CARICOM
		(bar inc2001 cid2001 if car==1 , horizontal lc("176 203 242") lw(0.001) fc("176 203 242") )
		(bar inc2011 cid2001 if car==1 , horizontal lc("91 146 229") lw(0.001) fc("91 146 229") )

		/// non CARICOM
		(bar inc2001 cid2001 if non_car==1 , horizontal lc("230 224 236") lw(0.001) fc("230 224 236") )
		(bar inc2011 cid2001 if non_car==1 , horizontal lc("153 130 180") lw(0.001) fc("153 130 180") )

		/// Trinidad
		(bar inc2001 cid2001 if cid==2040 , horizontal lc(red*0.25) lw(0.001) fc(red*0.25) )
		(bar inc2011 cid2001 if cid==2040 , horizontal lc(red) lw(0.001) fc(red) )
		
		(bar inc2011 cid2001 if race==2 , horizontal lc(gs7) lw(0.001) fc(gs7))

		///(line cid2011 usmean2011          , lp("l") lc(gs10) lw(1))
		///(line cid2011 carmean2011         , lp("l") lc("176 203 242") lw(1))
		,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		ysize(5)
		bgcolor(gs16)

		xlab(`tick1', 
		labs(4) nogrid glc(gs14) angle(0) labgap(1))
		xscale( lw(vthin)) xtitle("`title1'", margin(t=3) size(2.5)) 
		xmtick(`tick2')
		
		ylab(`r(levels)', valuelab labs(3.5) nogrid glc(gs14) angle(0) format(%9.0f))
		ytitle("",  margin(r=3) size(large))
		yscale(reverse lw(vthin) fill) 	
		
		///text(0 `carmean2011' "`carmean2011'", place(w) size(4))
		///text(0 `usmean2011' "`usmean2011'", place(e) size(4))
		
		legend(off)
		;
	#delimit cr
	
	
	/*


** This generates "r(levels)" for use as labelling on Y-AXIS
levelsof cid2011
** HIGHLIGHT TRINIDAD
#delimit ;
	graph twoway 

		/// USA African-American
		(bar inc2001 cid2001 if race==1 , horizontal lc(gs13) lw(0.001) fc(gs13))
		(bar inc2011 cid2001 if race==1 , horizontal lc(gs7) lw(0.001) fc(gs7))

		/// USA White-American
		(bar inc2001 cid2001 if race==2 , horizontal lc(gs13) lw(0.001) fc(gs13))

		/// CARICOM
		(bar inc2001 cid2001 if car==1 , horizontal lc("176 203 242") lw(0.001) fc("176 203 242") )
		(bar inc2011 cid2001 if car==1 , horizontal lc("91 146 229") lw(0.001) fc("91 146 229") )

		/// non CARICOM
		(bar inc2001 cid2001 if non_car==1 , horizontal lc("230 224 236") lw(0.001) fc("230 224 236") )
		(bar inc2011 cid2001 if non_car==1 , horizontal lc("153 130 180") lw(0.001) fc("153 130 180") )

		/// Trinidad
		(bar inc2001 cid2001 if cid==2440 , horizontal lc(red*0.25) lw(0.001) fc(red*0.25) )
		(bar inc2011 cid2001 if cid==2440 , horizontal lc(red) lw(0.001) fc(red) )
		
		(bar inc2011 cid2001 if race==2 , horizontal lc(gs7) lw(0.001) fc(gs7))

		///(line cid2011 usmean2011          , lp("l") lc(gs10) lw(1))
		///(line cid2011 carmean2011         , lp("l") lc("176 203 242") lw(1))
		,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		ysize(5)
		bgcolor(gs16)

		xlab(`tick1', 
		labs(4) nogrid glc(gs14) angle(0) labgap(1))
		xscale( lw(vthin)) xtitle("`title1'", margin(t=3) size(2.5)) 
		xmtick(`tick2')
		
		ylab(`r(levels)', valuelab labs(3.5) nogrid glc(gs14) angle(0) format(%9.0f))
		ytitle("",  margin(r=3) size(large))
		yscale(reverse lw(vthin) fill) 	
		
		///text(0 `carmean2011' "`carmean2011'", place(w) size(4))
		///text(0 `usmean2011' "`usmean2011'", place(e) size(4))
		
		legend(off)
		;
	#delimit cr
	
	
	/*
	
** This generates "r(levels)" for use as labelling on Y-AXIS
levelsof cid2011
** HIGHLIGHT FRENCH GUIANA
#delimit ;
	graph twoway 

		/// USA African-American
		(bar inc2001 cid2001 if race==1 , horizontal lc(gs13) lw(0.001) fc(gs13))
		(bar inc2011 cid2001 if race==1 , horizontal lc(gs7) lw(0.001) fc(gs7))

		/// USA White-American
		(bar inc2001 cid2001 if race==2 , horizontal lc(gs13) lw(0.001) fc(gs13))

		/// CARICOM
		(bar inc2001 cid2001 if car==1 , horizontal lc("176 203 242") lw(0.001) fc("176 203 242") )
		(bar inc2011 cid2001 if car==1 , horizontal lc("91 146 229") lw(0.001) fc("91 146 229") )

		/// non CARICOM
		(bar inc2001 cid2001 if non_car==1 , horizontal lc("230 224 236") lw(0.001) fc("230 224 236") )
		(bar inc2011 cid2001 if non_car==1 , horizontal lc("153 130 180") lw(0.001) fc("153 130 180") )

		/// Trinidad
		(bar inc2001 cid2001 if cid==2210 , horizontal lc(red*0.25) lw(0.001) fc(red*0.25) )
		(bar inc2011 cid2001 if cid==2210 , horizontal lc(red) lw(0.001) fc(red) )
		
		(bar inc2011 cid2001 if race==2 , horizontal lc(gs7) lw(0.001) fc(gs7))

		///(line cid2011 usmean2011          , lp("l") lc(gs10) lw(1))
		///(line cid2011 carmean2011         , lp("l") lc("176 203 242") lw(1))
		,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		ysize(5)
		bgcolor(gs16)

		xlab(`tick1', 
		labs(4) nogrid glc(gs14) angle(0) labgap(1))
		xscale( lw(vthin)) xtitle("`title1'", margin(t=3) size(2.5)) 
		xmtick(`tick2')
		
		ylab(`r(levels)', valuelab labs(3.5) nogrid glc(gs14) angle(0) format(%9.0f))
		ytitle("",  margin(r=3) size(large))
		yscale(reverse lw(vthin) fill) 	
		
		///text(0 `carmean2011' "`carmean2011'", place(w) size(4))
		///text(0 `usmean2011' "`usmean2011'", place(e) size(4))
		
		legend(off)
		;
	#delimit cr









/*
** This generates "r(levels)" for use as labelling on Y-AXIS
levelsof cid2011
** HIGHLIGHT GUADELOUPE
#delimit ;
	graph twoway 

		/// USA African-American
		(bar inc2001 cid2001 if race==1 , horizontal lc(gs13) lw(0.001) fc(gs13))
		(bar inc2011 cid2001 if race==1 , horizontal lc(gs7) lw(0.001) fc(gs7))

		/// USA White-American
		(bar inc2001 cid2001 if race==2 , horizontal lc(gs13) lw(0.001) fc(gs13))

		/// CARICOM
		(bar inc2001 cid2001 if car==1 , horizontal lc("176 203 242") lw(0.001) fc("176 203 242") )
		(bar inc2011 cid2001 if car==1 , horizontal lc("91 146 229") lw(0.001) fc("91 146 229") )

		/// non CARICOM
		(bar inc2001 cid2001 if non_car==1 , horizontal lc("230 224 236") lw(0.001) fc("230 224 236") )
		(bar inc2011 cid2001 if non_car==1 , horizontal lc("153 130 180") lw(0.001) fc("153 130 180") )

		/// Trinidad
		(bar inc2001 cid2001 if cid==2240 , horizontal lc(red*0.25) lw(0.001) fc(red*0.25) )
		(bar inc2011 cid2001 if cid==2240 , horizontal lc(red) lw(0.001) fc(red) )
		
		(bar inc2011 cid2001 if race==2 , horizontal lc(gs7) lw(0.001) fc(gs7))

		///(line cid2011 usmean2011          , lp("l") lc(gs10) lw(1))
		///(line cid2011 carmean2011         , lp("l") lc("176 203 242") lw(1))
		,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		ysize(5)
		bgcolor(gs16)

		xlab(`tick1', 
		labs(4) nogrid glc(gs14) angle(0) labgap(1))
		xscale( lw(vthin)) xtitle("`title1'", margin(t=3) size(2.5)) 
		xmtick(`tick2')
		
		ylab(`r(levels)', valuelab labs(3.5) nogrid glc(gs14) angle(0) format(%9.0f))
		ytitle("",  margin(r=3) size(large))
		yscale(reverse lw(vthin) fill) 	
		
		///text(0 `carmean2011' "`carmean2011'", place(w) size(4))
		///text(0 `usmean2011' "`usmean2011'", place(e) size(4))
		
		legend(off)
		;
	#delimit cr

	
/*
	
** This generates "r(levels)" for use as labelling on Y-AXIS
levelsof cid2011

** HIGHLIGHT TRINIDAD
#delimit ;
	graph twoway 

		/// USA African-American
		(bar inc2001 cid2001 if race==1 , horizontal lc(gs13) lw(0.001) fc(gs13))
		(bar inc2011 cid2001 if race==1 , horizontal lc(gs7) lw(0.001) fc(gs7))

		/// USA White-American
		(bar inc2001 cid2001 if race==2 , horizontal lc(gs13) lw(0.001) fc(gs13))

		/// CARICOM
		(bar inc2001 cid2001 if car==1 , horizontal lc("176 203 242") lw(0.001) fc("176 203 242") )
		(bar inc2011 cid2001 if car==1 , horizontal lc("91 146 229") lw(0.001) fc("91 146 229") )

		/// non CARICOM
		(bar inc2001 cid2001 if non_car==1 , horizontal lc("230 224 236") lw(0.001) fc("230 224 236") )
		(bar inc2011 cid2001 if non_car==1 , horizontal lc("153 130 180") lw(0.001) fc("153 130 180") )

		/// Trinidad
		(bar inc2001 cid2001 if cid==2440 , horizontal lc(red*0.25) lw(0.001) fc(red*0.25) )
		(bar inc2011 cid2001 if cid==2440 , horizontal lc(red) lw(0.001) fc(red) )
		
		(bar inc2011 cid2001 if race==2 , horizontal lc(gs7) lw(0.001) fc(gs7))

		///(line cid2011 usmean2011          , lp("l") lc(gs10) lw(1))
		///(line cid2011 carmean2011         , lp("l") lc("176 203 242") lw(1))
		,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		ysize(5)
		bgcolor(gs16)

		xlab(`tick1', 
		labs(4) nogrid glc(gs14) angle(0) labgap(1))
		xscale( lw(vthin)) xtitle("`title1'", margin(t=3) size(2.5)) 
		xmtick(`tick2')
		
		ylab(`r(levels)', valuelab labs(3.5) nogrid glc(gs14) angle(0) format(%9.0f))
		ytitle("",  margin(r=3) size(large))
		yscale(reverse lw(vthin) fill) 	
		
		///text(0 `carmean2011' "`carmean2011'", place(w) size(4))
		///text(0 `usmean2011' "`usmean2011'", place(e) size(4))
		
		legend(off)
		;
	#delimit cr


	
	
	
	
		
	
		
	
	
	
		
	
	