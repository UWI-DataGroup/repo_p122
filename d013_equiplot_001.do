** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d013_equiplot_001, replace

**  GENERAL DO-FILE COMMENTS
**  program:      d013_equiplot_001.do
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


** Keep Mortality Group
keep if cod==2

** Keep Caribbean (N=13, all ages, age adjusted, dataset 1)
** Keep US data 
**	--> (1999-2001, all ages, age-adjusted, dataset 100) 
**	--> (2009-2011, all ages, age-adjusted, dataset 400) 
** keep if dataset==1 | dataset==100 | dataset==400

** Keep Caribbean (N=13, 0-74, age adjusted, dataset 1)
** Keep US data 
**	--> (1999-2001, 0-74, age-adjusted, dataset 200) 
**	--> (2009-2011, 0-74, age-adjusted, dataset 500) 
**keep if dataset==3 | dataset==200 | dataset==500

** Keep Caribbean data
**	-->	(N=10, English-speaking, all ages, age adjusted, dataset 12)
**	-->	(N=8, non-English-speaking, all ages, age adjusted, dataset 18)
** Keep US data 
**	--> (1999-2001, 0-74, age-adjusted, dataset 200) 
**	--> (2009-2011, 0-74, age-adjusted, dataset 500) 
keep if dataset==12 | dataset==18 | dataset==200 | dataset==500

** -------------------------------------------------
** X-axis
** -------------------------------------------------
** CVD, all ages
local tick1 = "0(200)800"
local tick2 = "0(100)800"
local title1 = "CVD-Diabetes mortality rate"
local ytext = 1200
local range "0(200)1200"

** CVD-DIABETES, 0-74
local tick1 = "0(100)400"
local tick2 = "0(50)400"
local title1 = "CVD-Diabetes mortality rate (0-74 years)"
local ytext = 600
local range "0(200)600"

** ALL-CAUSE, 0-74
local tick1 = "0(200)1200"
local tick2 = "0(100)1200"
local title1 = "All-cause mortality rate (0-74 years)"
local ytext = 1500
local range "0(100)1500"

** ALL-CAUSE, all ages
local tick1 = "0(500)2000"
local tick2 = "0(250)2000"
local title1 = "All-cause mortality rate"
local ytext = 2500
local range "0(500)2500"


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

** Y-axis indicator
gen ind3 = _n
gen ind2 = ind3
replace ind2 = ind2+2 if ind3>=5 & ind3<=8	
replace ind2 = ind2+4 if ind3>=9 & ind3<=12
replace ind2 = ind2+6 if ind3>=13 & ind3<=16
replace ind2 = ind2+8 if ind3>=17 & ind3<=20
replace ind2 = ind2+10 if ind3>=21 & ind3<=24

	#delimit ;
	gr twoway 
		/// Coverage by wealth
		(rspike mr_lo mr_hi ind2 , 		hor lc(gs10) lw(0.35))
		(sc ind2 mr_lo, 				msize(5) m(o) mlc(gs0) mfc("255 255 191") mlw(0.1))
		(sc ind2 mr_hi , 				msize(5) m(o) mlc(gs0) mfc("253 174 97") mlw(0.1))
		(sc ind2 carib ,			 	msize(4) m(o) mlc(gs10) mfc(gs10) mlw(0.1))
		(sc ind2 us if dataset>=100, 	msize(4) m(o) mlc(gs10) mfc(gs10) mlw(0.1))
		,
			graphregion(color(gs16)) ysize(10)

			xlab(`tick1' , labs(4) nogrid glc(gs16))
			xscale(fill range(`range')) 
			xtitle("`title1'", size(3.75) margin(l=2 r=2 t=5 b=2)) 
			xmtick(`tick2')
			
			ylab(	1 "Car" 2 "aa US" 3 " w US" 4 "US"
					7 "Car" 8 "aa US" 9 " w US" 10 "US"
					13 "Car" 14 "aa US" 15 " w US" 16 "US"
					19 "Car" 20 "aa US" 21 " w US" 22 "US"
					25 "Car" 26 "aa US" 27 " w US" 28 "US"
					31 "Car" 32 "aa US" 33 " w US" 34 "US",
			labs(3) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) reverse range(0(1)35)) 
			ytitle("", size(3) margin(l=2 r=5 t=2 b=2)) 

			text(1 `ytext' "1999-2001", place(w) size(3.75))
			text(2 `ytext' "female", place(w) size(3.75))	
			text(7 `ytext' "1999-2001", place(w) size(3.75))
			text(8 `ytext' "male", place(w) size(3.75))	
			text(13 `ytext' "1999-2001", place(w) size(3.75))
			text(14 `ytext' "both", place(w) size(3.75))	

			text(19 `ytext' "2009-2011", place(w) size(3.75))
			text(20 `ytext' "female", place(w) size(3.75))	
			text(25 `ytext' "2009-2011", place(w) size(3.75))
			text(26 `ytext' "male", place(w) size(3.75))	
			text(31 `ytext' "2009-2011", place(w) size(3.75))
			text(32 `ytext' "both", place(w) size(3.75))	
			
			legend(off size(4) position(11) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(5)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) 
			order(2 3 4 5 6) 
			lab(2 "Q1") 
			lab(3 "Q2") lab(4 "Q3") lab(5 "Q4")
			lab(6 "Q5") 
			);
	#delimit cr
	
	
	
	
	
	
/*


	#delimit ;
	gr twoway 
		/// Coverage by wealth
		(function y=10.5 , range(0 130) recast(area) color(gs14))
		(function y=8.5 , range(0 130) recast(area) color(gs16))
		(function y=6.5, range(0 130) recast(area) color(gs14))
		(function y=4.5 , range(0 130) recast(area) color(gs16))
		(function y=2.5 , range(0 130) recast(area) color(gs14))

		(rspike q1 q5 ind3 if dhs==5 & strat==1 & ind!=160, hor lc(gs6) lw(0.25))
		(rspike q1 q5 ind3 if dhs==6 & strat==1 & ind!=160, hor lc(gs6) lw(0.25))
		(sc ind3 est if dhs==5 & strat==1 & group==1 & ind!=160, msize(3) m(o) mlc(gs0) mfc("215 25 28") mlw(0.1))
		(sc ind3 est if dhs==6 & strat==1 & group==1 & ind!=160, msize(3) m(o) mlc(gs0) mfc("215 25 28") mlw(0.1))
		(sc ind3 est if dhs==5 & strat==1 & group==2 & ind!=160, msize(3) m(o) mlc(gs0) mfc("253 174 97") mlw(0.1))
		(sc ind3 est if dhs==6 & strat==1 & group==2 & ind!=160, msize(3) m(o) mlc(gs0) mfc("253 174 97") mlw(0.1))
		(sc ind3 est if dhs==5 & strat==1 & group==3 & ind!=160, msize(3) m(o) mlc(gs0) mfc("255 255 191") mlw(0.1))
		(sc ind3 est if dhs==6 & strat==1 & group==3 & ind!=160, msize(3) m(o) mlc(gs0) mfc("255 255 191") mlw(0.1))
		(sc ind3 est if dhs==5 & strat==1 & group==4 & ind!=160, msize(3) m(o) mlc(gs0) mfc("166 217 106") mlw(0.1))
		(sc ind3 est if dhs==6 & strat==1 & group==4 & ind!=160, msize(3) m(o) mlc(gs0) mfc("166 217 106") mlw(0.1))
		(sc ind3 est if dhs==5 & strat==1 & group==5 & ind!=160, msize(3) m(o) mlc(gs0) mfc("26 150 65") mlw(0.1))
		(sc ind3 est if dhs==6 & strat==1 & group==5 & ind!=160, msize(3) m(o) mlc(gs0) mfc("26 150 65") mlw(0.1))
		,
			graphregion(color(gs16)) ysize(5)

			xlab(0(20)100, labs(2.5) nogrid glc(gs16))
			xscale(fill range(0(15)130)) 
			xtitle("Prevalence (%)", size(2.5) margin(l=2 r=2 t=5 b=2)) 
			xmtick(0(10)100)
			
			ylab(1.25 "DHS-V" 1.75 "DHS-VI" 3.25 "DHS-V" 3.75 "DHS-VI" 5.25 "DHS-V" 5.75 "DHS-VI" 7.25 "DHS-V" 7.75 "DHS-VI" 9.25 "DHS-V" 9.75 "DHS-VI" 11.25 "DHS-V" 11.75 "DHS-VI",
				 labs(2.5) nogrid glc(gs16) angle(0) format(%9.1f))
			yscale(lw(vthin) reverse range(0.5(0.5)12.5)) 
			ytitle("", size(2.5) margin(l=2 r=5 t=2 b=2)) 

			text(1.25 128 "Antenatal", place(w) size(2.5))
			text(1.75 128 "care", place(w) size(2.5))
			text(3.25 128 "Tetanus", place(w) size(2.5))
			text(3.75 128 "coverage", place(w) size(2.5))
			text(5.25 128 "Skilled attendant", place(w) size(2.5))
			text(5.75 128 "at birth", place(w) size(2.5))
			text(7.25 128 "Institutional", place(w) size(2.5))
			text(7.75 128 "delivery", place(w) size(2.5))
			text(9.25 128 "Postnatal", place(w) size(2.5))
			text(9.75 128 "care", place(w) size(2.5))			
			text(11.25 128 "Early", place(w) size(2.5))
			text(11.75 128 "breastfeeding", place(w) size(2.5))			
			legend(size(2.5) position(11) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(5)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) 
			order(8 10 12 14 16) 
			lab(8 "Q1: poorest") 
			lab(10 "Q2") lab(12 "Q3") lab(14 "Q4")
			lab(16 "Q5: richest") 
			);
	#delimit cr	