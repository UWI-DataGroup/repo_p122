** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d013_equiplot_004, replace

**  GENERAL DO-FILE COMMENTS
**  program:      d013_equiplot_004.do
**  project:      
**  author:       HAMBLETON \ 10-OCT-2015
**  task:         Mortality rates in the Caribbean 
 

** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200



** ***************************************************************
** 19-SEP-2015
** GRAPHIC FOR COHSOD PRESENTATION	
** 0-64 YEARS
** CVD-DIABETES
** 1999-2001 then 2009-2011, Women, then Men
** ***************************************************************



** Primary dataset created using --> d100_join_mr_datasets.do
use "data\result\us_carib\mr_us_carib_001", clear


** Keep CVD-DIABETES Mortality Group
keep if cod==4

** Keep Caribbean data
**	-->	(N=10, English-speaking, all ages, age adjusted, dataset 24)
**	-->	(N=8, non-English-speaking, all ages, age adjusted, dataset 30)
** Keep US data 
**	--> (1999-2001, all ages, age-adjusted, dataset 200) 
**	--> (2009-2011, all ages, age-adjusted, dataset 500) 
** keep if dataset==24 | dataset==30 | dataset==100 | dataset==400

** Keep Caribbean data
**	-->	(N=8, English-speaking, 0-74, age adjusted, dataset 24)
**	-->	(N=5, non-English-speaking, 0-74, age adjusted, dataset 30)
** Keep US data 
**	--> (1999-2001, 0-74, age-adjusted, dataset 200) 
**	--> (2009-2011, 0-74, age-adjusted, dataset 500) 
keep if dataset==26 | dataset==32 | dataset==200 | dataset==500

** Keep Caribbean data
**	-->	(N=10, English-speaking, 0-64, age adjusted, dataset 24)
**	-->	(N=8, non-English-speaking, 0-64, age adjusted, dataset 30)
** Keep US data 
**	--> (1999-2001, 0-64, age-adjusted, dataset 200) 
**	--> (2009-2011, 0-64, age-adjusted, dataset 500) 
** keep if dataset==28 | dataset==34 | dataset==300 | dataset==600

** -------------------------------------------------
** X-axis
** -------------------------------------------------

** CVD-DIABETES, 0-64. FEMALE
local tick1 = "0(50)150"
local tick2 = "0(25)150"
local title1 = ""
local ytext = 200
local range "0(200)150"

** CVD-DIABETES, 0-64. MALE
local tick1 = "0(50)200"
local tick2 = "0(25)200"
local title1 = ""
local ytext = 200
local range "0(200)200"

** CVD-DIABETES, 0-74. FEMALE
local tick1 = "0(100)300"
local tick2 = "0(50)300"
local title1 = ""
local ytext = 300
local range "0(200)300"

** CVD-DIABETES, 0-74. MALE
local tick1 = "0(100)400"
local tick2 = "0(50)400"
local title1 = ""
local ytext = 400
local range "0(200)400"

** Minimum and Maximum MR by region, by sex, by dataset type
drop crude pop deaths ill iul ise ins
bysort dataset sex race decade: egen mr_lo = min(i)
bysort dataset sex race decade: egen mr_hi = max(i)

** Caribbean average
gen carib1 = i if cid==1000
bysort dataset sex race decade: egen carib = min(carib1)

** US average
gen us1 = i if cid==0
bysort dataset sex race decade: egen us = min(us1)
drop carib1 us1


** Generate y-axis indicator
sort decade sex dataset race cid
replace race = 1 if race==.
egen tuse = tag(decade sex dataset race)
keep if tuse==1
drop tuse adjust arange cod
sort decade sex dataset race cid
order decade sex dataset race i mr_lo mr_hi carib us 

** DROP US WOMEN + MEN COMBINED
drop if race==3


** MEN, 1999-2001
preserve
	keep if sex==2 & decade==1
	
	** Y-axis indicator
	gen ind3 = _n
	** Re-order non-English Caribbean and US AA
	recode ind3 3=2 2=3
	gen ind2 = ind3
	replace ind2 = 4 if ind3==2	
	replace ind2 = 7 if ind3==3
	replace ind2 = 10 if ind3==4

	#delimit ;
	gr twoway 
		/// Line between mon and max
		(rspike mr_lo mr_hi ind2 , 		hor lc(gs10) lw(0.35))
		/// Minimum points
		(sc ind2 mr_lo, 				msize(12) m(o) mlc(gs0) mfc("255 255 191") mlw(0.1))
		/// Maximum points
		(sc ind2 mr_hi , 				msize(12) m(o) mlc(gs0) mfc("253 174 97") mlw(0.1))
		/// Caribbean average
		(sc ind2 carib ,			 	msize(10) m(o) mlc(gs10) mfc(gs10) mlw(0.1))
		///US averages
		(sc ind2 us if dataset>=100, 	msize(10) m(o) mlc(gs10) mfc(gs10) mlw(0.1))
		,
			graphregion(color(gs16)) ysize(2.5)
			bgcolor(gs16)
			
			xlab(`tick1' , labs(7) nogrid glc(gs16))
			xscale(fill range(`range')) 
			xtitle("`title1'", size(7) margin(l=2 r=2 t=5 b=2)) 
			xmtick(`tick2')
			
			ylab(1 "Caribbean English Speaking" 4 "US African American" 7 "Caribbean non-English Speaking" 10 " US White American"  
					,
			labs(7) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) reverse range(0(1)13)) 
			ytitle("", size(3) margin(l=2 r=5 t=2 b=2)) 

			legend(off size(4) position(11) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(5)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) 
			order(2 3 4 5 6) 
			lab(2 "Q1") 
			lab(3 "Q2") lab(4 "Q3") lab(5 "Q4")
			lab(6 "Q5") 
			);
	#delimit cr
restore

/*
	
** MEN, 1999-2001
** MEN, 2009-2009
preserve
	keep if sex==2
	
	** Y-axis indicator
	gen ind3 = _n
	** Re-order non-English Caribbean and US AA
	recode ind3 3=2 2=3 6=7 7=6
	gen ind2 = ind3
	** 1999-2001
	replace ind2 = 4 if ind3==2	
	replace ind2 = 7 if ind3==3
	replace ind2 = 10 if ind3==4
	** 2009-2011
	replace ind2 = 2.2 if ind3==5	
	replace ind2 = 5.2 if ind3==6	
	replace ind2 = 8.2 if ind3==7
	replace ind2 = 11.2 if ind3==8

	#delimit ;
	gr twoway 
		/// 1999-2001
		(rspike mr_lo mr_hi ind2 if decade==1, 		hor lc("9 6 5 16") lw(0.35))
		(sc ind2 mr_lo if decade==1, 				msize(12) m(o) mlc("9 6 5 16") mfc("9 6 5 16") mlw(0.1))
		(sc ind2 mr_hi if decade==1 , 				msize(12) m(o) mlc("9 6 5 16") mfc("9 6 5 16") mlw(0.1))
		(sc ind2 carib if decade==1 ,			 	msize(10) m(o) mlc("9 6 5 16") mfc("9 6 5 16") mlw(0.1))
		(sc ind2 us  if decade==1 & dataset>=100, 	msize(10) m(o) mlc("9 6 5 16") mfc("9 6 5 16") mlw(0.1))

		/// 1999-2001
		(rspike mr_lo mr_hi ind2 if decade==2, 		hor lc(gs10) lw(0.35))
		(sc ind2 mr_lo if decade==2, 				msize(12) m(o) mlc(gs0) mfc("255 255 191") mlw(0.1))
		(sc ind2 mr_hi if decade==2 , 				msize(12) m(o) mlc(gs0) mfc("253 174 97") mlw(0.1))
		(sc ind2 carib if decade==2 ,			 	msize(10) m(o) mlc(gs10) mfc(gs10) mlw(0.1))
		(sc ind2 us  if decade==2 & dataset>=100, 	msize(10) m(o) mlc(gs10) mfc(gs10) mlw(0.1))

		,
			graphregion(color(gs16)) ysize(2.5)
			bgcolor(gs16)
			
			xlab(`tick1' , labs(7) nogrid glc(gs16))
			xscale(fill range(`range')) 
			xtitle("`title1'", size(7) margin(l=2 r=2 t=5 b=2)) 
			xmtick(`tick2')
			
			ylab(1 "Caribbean English Speaking" 4 "US African American" 7 "Caribbean non-English Speaking" 10 " US White American"  
					,
			labs(7) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) reverse range(0(1)13)) 
			ytitle("", size(3) margin(l=2 r=5 t=2 b=2)) 

			legend(off size(4) position(11) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(5)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) 
			order(2 3 4 5 6) 
			lab(2 "Q1") 
			lab(3 "Q2") lab(4 "Q3") lab(5 "Q4")
			lab(6 "Q5") 
			);
	#delimit cr
restore	


