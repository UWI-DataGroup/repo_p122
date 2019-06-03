** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d013_barcharts, replace

**  GENERAL DO-FILE COMMENTS
**  program:      d013_barcharts.do
**  project:      
**  author:       HAMBLETON \ 16-SEP-2015
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
keep if dataset==3 | dataset>=100


** 002
** Choose decade (1==1999-2001, 2=2009-2011)
keep if decade == 1

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
keep if sex==2

** 006
** Only for US datasets. Race. 1=AA, 2=White, 3=All
keep if race==1 | race==2 | race==3 | race>=.

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

** ************************************************************************************

** Year specific values
gen inc = i
gen us  = i if cid==0 & race==3
gen ca  = i if cid==1000

** US average 
egen usmean = min(us)
drop us
replace usmean = round(usmean,1)
local usmean = usmean 
** Caribbean average 
egen carmean = min(ca)
drop ca
replace carmean = round(carmean,1)
local carmean = carmean

** Drop Caribbean regional average --> we don't want this as a bar in the charts
drop if cid==1000
** Drop US regional average (ALL RACES)--> we don't want this as a bar in the charts
drop if cid==0 & race==3
** Attach Appropriate country names to re-ordered country values (Y-AXIS labelling)
sort inc
replace cid_string = "US African-American" if cid==0 & race==1
replace cid_string = "US White-American" if cid==0 & race==2
gen cid2 = _n
order cid cid_string cid2
labmask cid2, values(cid_string) 
order cid cid_string cid2 

** This generates "r(levels)" for use as labelling on Y-AXIS
qui levelsof cid2 

** THE GRAPHIC
#delimit ;
	graph twoway 
		/// USA African-American
		(bar inc cid2 if race==1 , horizontal lc(gs10) lw(0.001) fc(gs10))
		/// USA White-American
		(bar inc cid2 if race==2 , horizontal lc(gs10) lw(0.001) fc(gs10))
		/// Caribbean
		(bar inc cid2 if cid>100 , horizontal lc(green*0.75) lw(0.001) fc(green*0.5) )
		(line cid2 usmean          , lp("--") lc(gs0*0.8) lw(0.25))
		(line cid2 carmean         , lp("--") lc(green*0.8) lw(0.25))
	  ,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		ysize(7)
		yscale(reverse)

		xlab(`tick1', 
		labs(2.5) nogrid glc(gs14) angle(0) labgap(1))
		xscale(lw(vthin)) xtitle("`title1'", margin(t=3) size(2.5)) 
		xmtick(`tick2')
		
		ylab(`r(levels)', valuelab
		labs(2.5) nogrid glc(gs14) angle(0) format(%9.0f))
		ytitle("", margin(r=3) size(large))
		yscale(lw(vthin) fill) 	
		
		text(0 `carmean' "`carmean'", place(e) size(2.5))
		text(0 `usmean' "`usmean'", place(w) size(2.5))

		/// NOTE TO ADD TO MALE 2009 ALL-CAUSE GRAPH
		///text(66 2000 "*", place(e) size(3.5))
		///note("* Guyanese mortality rate was 2460 deaths per 100,000", size(2))

		/// NOTE TO ADD TO MALE 2009 CVD-DIABETES GRAPH
		///text(66 900 "*", place(e) size(3.5))
		///note("* Guyanese mortality rate was 1225 deaths per 100,000", size(2))

		/// NOTE TO ADD TO MALE 2009 HEART GRAPH
		///text(66 500 "*", place(e) size(3.5))
		///note("* Guyanese mortality rate was 612 deaths per 100,000", size(2))

		/// NOTE TO ADD TO MALE 2009 STROKE GRAPH
		// text(66 275 "*", place(e) size(3.5))
		/// note("* Guyanese mortality rate was 417 deaths per 100,000", size(2))
		
		legend(off)
		;
	#delimit cr





/*

** ************************************************************************************
** GRAPHICS.  CHANGE FROM 2000 to 2009
** ************************************************************************************
**
** 001
** Choose Caribbean data from 35 alternative sensitivity datasets. Also keep US datasets (dataset 100 and higher)
** N=13 Caribbean countries with undercount < 25% (age adjusted only)
** keep if dataset==1 | dataset>=100
** (0-74 YRS). N=13 Caribbean countries with undercount < 25% (age adjusted only)
 keep if dataset==3 | dataset>=100

** 002
** Choose decade (1==1999-2001, 2=2009-2011)
keep if decade==1 | decade == 2

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
keep if sex==1

** 006
** Only for US datasets. Race. 1=AA, 2=White, 3=All
keep if race==1 | race==2 | race==3 | race>=.

** SELECT RATE RANGE FOR X-AXIS



** CVD/DIABETES
local tick1 = "-45(10)25"
local tick2 = "-45(5)25"
local title1 = "CVD / diabetes mortality rate"

** ALL-CAUSE
local tick1 = "-30(10)20"
local tick2 = "-30(5)20"
local title1 = "% change in all-cause mortality rate"

** ************************************************************************************

** Drop Caribbean regional average --> we don't want this as a bar in the charts
drop if cid==1000
** Drop US regional average (ALL RACES)--> we don't want this as a bar in the charts
drop if cid==0 & race==3

** Calculate absolute change (ac) and relative change (rc)
drop dataset deaths pop crude ill iul ise ins 
reshape wide i, i( adjust arange cid sex cod race) j(decade)
** Absolute change
gen ac = i2 - i1
format ac %9.1f
** Relative change
gen rc = ((i2 - i1) / i1)*100
format rc %9.1f
reshape long i, i(adjust arange cid sex cod race ac rc) j(decade)
keep if decade==1

** Attach Appropriate country names to re-ordered country values (Y-AXIS labelling)
sort rc
replace cid_string = "US African-American" if cid==0 & race==1
replace cid_string = "US White-American" if cid==0 & race==2
gen cid2 = _n
order cid cid_string cid2
labmask cid2, values(cid_string) 
order cid cid_string cid2 

** This generates "r(levels)" for use as labelling on Y-AXIS
qui levelsof cid2 
gen x = 0

** Tweak to numbers for scatterplot
gen rc_pos = rc-7 if rc<0
replace rc_pos = rc if rc>0
gen rc_plot2 = round(rc)
gen rc_plot = string(rc_plot)

** THE GRAPHIC
#delimit ;
	graph twoway 
		/// USA African-American
		(bar rc cid2 if race==1 , horizontal lc(gs0*0.5) lw(0.001) fc(gs10) )
		/// USA White-American
		(bar rc cid2 if race==2 , horizontal lc(gs0*0.5) lw(0.001) fc(gs10) )
		/// Caribbean
		(bar rc cid2 if cid>100 , horizontal lc(gs0*0.5) lw(0.001) fc(green*0.5) )

		(sc cid2 rc_pos, msymbol(none) mlab(rc_plot) mlabsize(2.5) mlabcol(gs6) )
		
		/// X-Line at ZERO
		(line cid2 x, lp("l") lw(medium) lc(gs6))
	  ,
		plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
		ysize(5)
		yscale(reverse)

		xlab(`tick1', 
		labs(2.5) nogrid glc(gs14) angle(0) format(%9.0f) labgap(1))
		xscale(off lw(vthin) range(-50(5)15)) xtitle("`title1'", margin(t=3) size(2.5)) 
		xmtick(`tick2')
		
		ylab(`r(levels)', valuelab
		labs(2.5) notick nogrid glc(gs14) angle(0) format(%9.0f))
		ytitle("", margin(r=3) size(large))
		yscale(lw(none) noline fill) 	
		
		///xline(0, lc(gs0) lw(medthick))

		legend(off)
		;
	#delimit cr






