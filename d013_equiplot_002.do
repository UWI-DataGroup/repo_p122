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
keep if cod==4

** Keep Caribbean data
**	-->	(N=8, English-speaking, all ages, age adjusted, dataset 24)
**	-->	(N=5, non-English-speaking, all ages, age adjusted, dataset 30)
** Keep US data 
**	--> (1999-2001, all ages, age-adjusted, dataset 200) 
**	--> (2009-2011, all ages, age-adjusted, dataset 500) 
**keep if dataset==24 | dataset==30 | dataset==100 | dataset==400

** Keep Caribbean data
**	-->	(N=8, English-speaking, 0-74, age adjusted, dataset 24)
**	-->	(N=5, non-English-speaking, 0-74, age adjusted, dataset 30)
** Keep US data 
**	--> (1999-2001, 0-74, age-adjusted, dataset 200) 
**	--> (2009-2011, 0-74, age-adjusted, dataset 500) 
keep if dataset==26 | dataset==32 | dataset==200 | dataset==500

** -------------------------------------------------
** X-axis
** -------------------------------------------------

** ALL-CAUSE, all ages
local tick1 = "0(500)2000"
local tick2 = "0(250)2000"
local title1 = "All-cause mortality rate"
local ytext = 2500
local range "0(500)2500"

** CVD-DIABETES, all ages
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
** local tick1 = "0(200)1200"
** local tick2 = "0(100)1200"
** local title1 = "All-cause mortality rate (0-74 years)"
** local ytext = 1500
** local range "0(100)1500"

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
** Re-order non-English Caribbean and US AA
recode ind3 3=2 2=3 7=8 8=7 12=13 13=12 17=18 18=17 22=23 23=22 27=28 28=27
gen ind2 = ind3
replace ind2 = ind2+1 if ind3>=6 & ind3<=10	
replace ind2 = ind2+2 if ind3>=11 & ind3<=15
replace ind2 = ind2+3 if ind3>=16 & ind3<=20
replace ind2 = ind2+4 if ind3>=21 & ind3<=25
replace ind2 = ind2+5 if ind3>=26 & ind3<=30

** Don't plot ALL US on this one
drop if race==3

/*
	#delimit ;
	gr twoway 
		/// Line between mon and max
		(rspike mr_lo mr_hi ind2 , 		hor lc(gs10) lw(0.35))
		/// Minimum points
		(sc ind2 mr_lo, 				msize(5) m(o) mlc(gs0) mfc("255 255 191") mlw(0.1))
		/// Maximum points
		(sc ind2 mr_hi , 				msize(5) m(o) mlc(gs0) mfc("253 174 97") mlw(0.1))
		/// Caribbean average
		(sc ind2 carib ,			 	msize(4) m(o) mlc(gs10) mfc(gs10) mlw(0.1))
		///US averages
		(sc ind2 us if dataset>=100, 	msize(4) m(o) mlc(gs10) mfc(gs10) mlw(0.1))
		,
			graphregion(color(gs16)) ysize(10)

			xlab(`tick1' , labs(4) nogrid glc(gs16))
			xscale(fill range(`range')) 
			xtitle("`title1'", size(3.75) margin(l=2 r=2 t=5 b=2)) 
			xmtick(`tick2')
			
			ylab(	1 "Car ES" 2 "aa US" 3 "Car nES" 4 " w US"  

					7 "Car ES" 8 "aa US" 9 "Car nES" 10 "w US" 
					13 "Car ES" 14 "aa US" 15 "Car nES" 16 "w US"
					19 "Car ES" 20 "aa US" 21 "Car nES" 22 "w US"
					25 "Car ES" 26 "aa US" 27 "Car nES" 28 "w US"
					31 "Car ES" 32 "aa US" 33 "Car nES" 34 "w US"
					,
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
	

*/

** 20-AUG-2016
** BOTH sexes together only - for SULLIVAN 2 proposal
keep if sex==3
recode ind2 13=1 14=2 15=3 16=4 31=7 32=8 33=9 34=10

** CVD-DIABETES, 0-74
local tick1 = "0(100)300"
local tick2 = "0(50)300"
local title1 = "CVD-Diabetes mortality rate (0-74 years)"
local ytext = 400
local range "0(200)400"

/*
	#delimit ;
	gr twoway 
		/// Line between mon and max
		(rspike mr_lo mr_hi ind2 , 		hor lc(gs10) lw(0.35))
		/// Minimum points
		(sc ind2 mr_lo, 				msize(7) m(o) mlc(gs0) mfc("255 255 191") mlw(0.1))
		/// Maximum points
		(sc ind2 mr_hi , 				msize(7) m(o) mlc(gs0) mfc("253 174 97") mlw(0.1))
		/// Caribbean average
		(sc ind2 carib ,			 	msize(6) m(o) mlc(gs10) mfc(gs10) mlw(0.1))
		///US averages
		(sc ind2 us if dataset>=100, 	msize(6) m(o) mlc(gs10) mfc(gs10) mlw(0.1))
		,
			graphregion(color(gs16)) ysize(5) xsize(7.5)

			xlab(`tick1' , labs(5) nogrid glc(gs16))
			xscale(fill range(`range')) 
			xtitle("`title1'", size(4.75) margin(l=2 r=2 t=5 b=2)) 
			xmtick(`tick2')
			
			ylab(	
					1 "Car ES" 2 "aa US" 3 "Car nES" 4 "w US"
					7 "Car ES" 8 "aa US" 9 "Car nES" 10 "w US"
					,
			labs(4) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) reverse range(0(1)11)) 
			ytitle("", size(3) margin(l=2 r=5 t=2 b=2)) 

			text(1 `ytext' "1999-2001", place(w) size(4.75))
			text(7 `ytext' "2009-2011", place(w) size(4.75))
			
			legend(off size(5) position(11) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(5)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) 
			order(2 3 4 5 6) 
			lab(2 "Q1") 
			lab(3 "Q2") lab(4 "Q3") lab(5 "Q4")
			lab(6 "Q5") 
			);
	#delimit cr

	
	
	
#delimit ;
	gr twoway 
		/// Line between mon and max
		(rspike mr_lo mr_hi ind2 , 		hor lc(gs10) lw(0.35))
		/// Minimum points
		(sc ind2 mr_lo, 				msize(7.5) m(o) mlc(gs0) mfc("255 255 191") mlw(0.1))
		/// Maximum points
		(sc ind2 mr_hi , 				msize(7.5) m(o) mlc(gs0) mfc("253 174 97") mlw(0.1))
		/// Caribbean average
		(sc ind2 carib ,			 	msize(6.5) m(o) mlc(gs10) mfc(gs10) mlw(0.1))
		///US averages
		(sc ind2 us if dataset>=100, 	msize(6.5) m(o) mlc(gs10) mfc(gs10) mlw(0.1))
		,
			graphregion(color(gs16)) ysize(4) xsize(7.5)

			xlab(`tick1' , labs(4) tlc(gs10) labc(gs10) nogrid glc(gs16))
			xscale(fill range(`range') lc(gs10)) 
			xtitle("`title1'", size(4) color(gs10) margin(l=2 r=2 t=5 b=2)) 
			xmtick(`tick2', tlc(gs10))
			
			ylab(	
					1 "Caribbean: English-speaking" 2 "US: African-American" 3 "Caribbean: non English-speaking" 4 "US: White-American"
					7 "Caribbean: English-speaking" 8 "US: African-American" 9 "Caribbean: non English-speaking" 10 "US: White-American"
					,
			labc(gs10) labs(4) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) reverse range(0(1)11)) 
			ytitle("", size(4) margin(l=2 r=5 t=2 b=2)) 

			text(1 `ytext' "1999-2001", place(w) color(gs10) size(4))
			text(7 `ytext' "2009-2011", place(w) color(gs10) size(4))
			
			legend(off size(5) position(6) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(1)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) 
			order(2 3 4) 
			lab(2 "Lowest mortaity rate") 
			lab(3 "Highest mortality rate") 
			lab(4 "Average mortality rate") 
			);
#delimit cr	


** Same graphic in Blues2 (colorbrewer2.org)
#delimit ;
	gr twoway 
		/// Line between mon and max
		(rspike mr_lo mr_hi ind2 , 		hor lc(gs10) lw(0.35))
		/// Minimum points
		(sc ind2 mr_lo, 				msize(7.5) m(o) mlc(gs0) mfc("198 219 239") mlw(0.1))
		/// Maximum points
		(sc ind2 mr_hi , 				msize(7.5) m(o) mlc(gs0) mfc("8 81 156") mlw(0.1))
		/// Caribbean average
		(sc ind2 carib ,			 	msize(6.5) m(o) mlc(gs10) mfc(gs10) mlw(0.1))
		///US averages
		(sc ind2 us if dataset>=100, 	msize(6.5) m(o) mlc(gs10) mfc(gs10) mlw(0.1))
		,
			graphregion(color(gs16)) ysize(4) xsize(7.5)

			xlab(`tick1' , labs(4) tlc(gs10) labc(gs10) nogrid glc(gs16))
			xscale(fill range(`range') lc(gs10)) 
			xtitle("`title1'", size(4) color(gs10) margin(l=2 r=2 t=5 b=2)) 
			xmtick(`tick2', tlc(gs10))
			
			ylab(	
					1 "Caribbean: English-speaking" 2 "US: African-American" 3 "Caribbean: non English-speaking" 4 "US: White-American"
					7 "Caribbean: English-speaking" 8 "US: African-American" 9 "Caribbean: non English-speaking" 10 "US: White-American"
					,
			labc(gs10) labs(4) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) reverse range(0(1)11)) 
			ytitle("", size(4) margin(l=2 r=5 t=2 b=2)) 

			text(1 `ytext' "1999-2001", place(w) color(gs10) size(4))
			text(7 `ytext' "2009-2011", place(w) color(gs10) size(4))
			
			legend(off size(5) position(6) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(1)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) 
			order(2 3 4) 
			lab(2 "Lowest mortaity rate") 
			lab(3 "Highest mortality rate") 
			lab(4 "Average mortality rate") 
			);
#delimit cr	

*/

replace ind2 = ind2-1 if ind2>=7

** CREATED FOR FMS POSTER DISPLAY (SEP-2016)
** Same graphic in Blues2 (colorbrewer2.org)
#delimit ;
	gr twoway 
		/// Line between mon and max
		(rspike mr_lo mr_hi ind2 , 		hor lc(gs12) lw(0.35))
		/// Minimum points
		(sc ind2 mr_lo, 				msize(8.5) m(o) mlc(gs0) mfc("198 219 239") mlw(0.1))
		/// Maximum points
		(sc ind2 mr_hi , 				msize(8.5) m(o) mlc(gs0) mfc("8 81 156") mlw(0.1))
		/// Caribbean average
		(sc ind2 carib ,			 	msize(6.5) m(o) mlc(gs12) mfc(gs12) mlw(0.1))
		///US averages
		(sc ind2 us if dataset>=100, 	msize(6.5) m(o) mlc(gs12) mfc(gs12) mlw(0.1))
		,
			graphregion(color(gs16)) ysize(9.5) xsize(14)

			xlab(`tick1' , labs(5) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill range(`range') lc(gs0)) 
			xtitle("`title1'", size(5) color(gs0) margin(l=2 r=2 t=5 b=2)) 
			xmtick(`tick2', tlc(gs0))
			
			ylab(	
					1 "Car ES" 2 "US AA" 3 "Car nES" 4 "US WA"
					6 "Car ES" 7 "US AA" 8 "Car nES" 9 "US WA"
					,
			labc(gs0) labs(5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) reverse range(0(1)10)) 
				ytitle("", size(5) margin(l=2 r=5 t=2 b=2)) 

			text(1 `ytext' "1999-2001", place(w) color(gs0) size(5))
			text(6 `ytext' "2009-2011", place(w) color(gs0) size(5))
			
			legend(off size(5) position(6) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(1)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) 
			order(2 3 4) 
			lab(2 "Lowest mortaity rate") 
			lab(3 "Highest mortality rate") 
			lab(4 "Average mortality rate") 
			);
#delimit cr	

