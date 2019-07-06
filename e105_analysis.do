** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e105_analysis.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    30q70 Graphics (2000 to 2016)

    ** General algorithm set-up
    version 15
    clear all
    macro drop _all
    set more 1
    set linesize 80

    ** Set working directories: this is for DATASET and LOGFILE import and export
    ** DATASETS to encrypted SharePoint folder
    local datapath "X:/The University of the West Indies/DataGroup - repo_data/data_p122"
    ** LOGFILES to unencrypted OneDrive folder (.gitignore set to IGNORE log files on PUSH to GitHub)
    local logpath X:/OneDrive - The University of the West Indies/repo_datagroup/repo_p122

    ** Close any open log file and open a new log file
    capture log close
    log using "`logpath'\e105_analysis", replace
** HEADER -----------------------------------------------------

/*


** For SAP --> See e000_000.do

** -----------------------------------------------------
** FIGURE 1. EQUIPLOT OF COUNTRY AND REGIONAL 30q70 
** -----------------------------------------------------
** Build the dataset for equiplot
** Country-level data 
use "`datapath'/version01/2-working/file100_q3070_lac.dta", clear 
drop if sex==3 
keep if year==2000|year==2004|year==2008|year==2012|year==2016
drop if rid==4
recode rid 2 3 = 6 
sort rid sex year q3070
bysort rid sex year: egen min3070 = min(q3070)
bysort rid sex year: egen max3070 = max(q3070)
egen tag = tag(rid year sex)
keep if tag==1
drop tag 

tempfile country 
save `country', replace

** Sub-regional averages 
use "`datapath'/version01/2-working/file100_q3070_region_various.dta", clear 
drop if sex==3 
keep if rid==1 | rid==6 
keep if year==2000|year==2004|year==2008|year==2012|year==2016
sort rid sex year q3070

merge 1:1 rid sex year using `country'
drop iso3 unid _merge 
label define sex_ 1 "women" 2 "men"
label values sex sex_

sort rid sex year 
order rid sex year 
gen yax = _n 
replace yax = yax + 2 if yax>=6 
replace yax = yax-12 if _n>=11 
replace yax = yax + 2 if yax>=6 & rid==6
order yax


** Caribbean
#delimit ;
	gr twoway
		/// Line between min and max
		(rspike min3070 max3070 yax if rid==1 , hor lc(gs12) lw(0.35))
		/// Minimum points
		(sc yax min3070 if rid==1, 			    msize(3.5) m(o) mlc(gs0) mfc("198 219 239") mlw(0.1))
		/// Maximum points
		(sc yax max3070  if rid==1,             msize(3.5) m(o) mlc(gs0) mfc("8 81 156") mlw(0.1))
		/// Regional average
		(sc yax q3070  if rid==1, 				msize(3.5) m(o) mlc(gs0) mfc(gs13) mlw(0.1))
		,
			graphregion(color(gs16)) ysize(8) xsize(6)

			xlab(0(10)50 , labs(3) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill range(`range') lc(gs0))
			xtitle("30q70", size(3) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(0(5)50, tlc(gs0))

			ylab(1 "2000"  2  "2004" 3  "2008" 4  "2012" 5 "2016"
                8 "2000" 9 "2004" 10 "2008" 11 "2012" 12 "2016"
			,
			valuelabel labc(gs0) labs(3) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) reverse range(0(1)13))
			ytitle("", size(3) margin(l=2 r=5 t=2 b=2))

			text(7 0 "Men", place(e) color(gs0) size(3.5))
			text(0 0 "Women", place(e) color(gs0) size(3.5))

			legend( size(3) position(12) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(1)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(2 3 4)
			lab(2 "Min 30q70")
			lab(3 "Max 30q70")
			lab(4 "Regional 30q70")
            )
            name(caribbean)
            ;
#delimit cr

** Central and South America
#delimit ;
	gr twoway
		/// Line between min and max
		(rspike min3070 max3070 yax if rid==6 , hor lc(gs12) lw(0.35))
		/// Minimum points
		(sc yax min3070 if rid==6, 			    msize(3.5) m(o) mlc(gs0) mfc("161 217 155") mlw(0.1))
		/// Maximum points
		(sc yax max3070  if rid==6,             msize(3.5) m(o) mlc(gs0) mfc("35 139 69") mlw(0.1))
		/// Regional average
		(sc yax q3070  if rid==6, 				msize(3.5) m(o) mlc(gs0) mfc(gs13) mlw(0.1))
		,
			graphregion(color(gs16)) ysize(8) xsize(6)

			xlab(0(10)50 , labs(3) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill range(`range') lc(gs0))
			xtitle("30q70", size(3) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(0(5)50, tlc(gs0))

			ylab(1 "2000"  2  "2004" 3  "2008" 4  "2012" 5 "2016"
                8 "2000" 9 "2004" 10 "2008" 11 "2012" 12 "2016"
			,
			valuelabel labc(gs0) labs(3) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) reverse range(0(1)13))
			ytitle("", size(3) margin(l=2 r=5 t=2 b=2))

			text(7 0 "Men", place(e) color(gs0) size(3.5))
			text(0 0 "Women", place(e) color(gs0) size(3.5))

			legend( size(3) position(12) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(1)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(2 3 4)
			lab(2 "Min 30q70")
			lab(3 "Max 30q70")
			lab(4 "Regional 30q70")
            )
            name(ca_and_sa)
            ;
#delimit cr




** -----------------------------------------------------
** FIGURE 2
** -----------------------------------------------------
** Line chart of Regional 30Q70 by YEAR
use "`datapath'/version01/2-working/file100_q3070_region_various.dta", clear 
drop if sex==3
keep if rid==1 | rid==6 


** Central and South America
#delimit ;
	gr twoway
		/// Female: Caribbean
		(line q3070 year if rid==1 & sex==1 , lc(gs10) lw(0.35) lp("l"))
        (sc   q3070 year if rid==1 & sex==1,  msize(2) m(o) mlc(gs0) mfc("8 81 156") mlw(0.1))
		/// Male: Caribbean
		(line q3070 year if rid==1 & sex==2 , lc(gs10) lw(0.35) lp("l"))
        (sc   q3070 year if rid==1 & sex==2,  msize(2) m(t) mlc(gs0) mfc("8 81 156") mlw(0.1))

		/// Female: CA and LA
		(line q3070 year if rid==6 & sex==1 , lc(gs10) lw(0.35) lp("l"))
        (sc   q3070 year if rid==6 & sex==1,  msize(2) m(o) mlc(gs0) mfc("161 217 155") mlw(0.1))
		/// Male: CA and LA
		(line q3070 year if rid==6 & sex==2 , lc(gs10) lw(0.35) lp("l"))
        (sc   q3070 year if rid==6 & sex==2,  msize(2) m(t) mlc(gs0) mfc("161 217 155") mlw(0.1))

		,
			graphregion(color(gs16)) ysize(8) xsize(6)

			xlab(2000(4)2016, labs(3) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill range(`range') lc(gs0))
			xtitle("Year", size(3) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(2000(1)2016, tlc(gs0))

			ylab(10(2)26
			,
			valuelabel labc(gs0) labs(3) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale( lw(vthin) range(10(1)26))
			ytitle("Premature Mortality (30q70)", size(3) margin(l=2 r=5 t=2 b=2))
            ymtick(10(1)26)

			legend(size(3) position(12) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(2)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(2 4 6 8)
			lab(2 "Carib: women")
			lab(4 "Carib: men")
			lab(6 "Amer: women")
			lab(8 "Amer: men")
            )
            name(line_01)
            ;
#delimit cr



** -----------------------------------------------------
** FIGURE 3
** -----------------------------------------------------
** Scatterplot of Regional 30Q70 in 2000 and in 2016
use "`datapath'/version01/2-working/file100_q3070_lac.dta", clear 
drop w_*
drop if sex==3 
recode rid 2 3 = 6 
keep if rid==1 | rid==6 
keep if year==2000 | year==2016
rename q3070 pmort
reshape wide pmort , i(rid iso3 unid sex) j(year)
rename pmort2000 pmort2000_
rename pmort2016 pmort2016_
reshape wide pmort2000_ pmort2016_ , i(rid iso3 unid) j(sex)

** Central and South America
** WOMEN
#delimit ;
	gr twoway
		/// Reference line
        (function y=x, range(8 32) col(gs13) lp("-") mlw(0.1))
        /// Female: Caribbean
        (sc   pmort2016_1 pmort2000_1 if rid==1,  msize(1.5) m(o) mlc(gs0) mfc("8 81 156") mlw(0.1))
		/// Male: Caribbean
        ///(sc   pmort2016_2 pmort2000_2 if rid==1,  msize(1.5) m(t) mlc(gs0) mfc("8 81 156") mlw(0.1))

		/// Female: CA and LA
        (sc   pmort2016_1 pmort2000_1 if rid==6,  msize(1.5) m(o) mlc(gs0) mfc("161 217 155") mlw(0.1))
		/// Male: CA and LA
        ///(sc   pmort2016_2 pmort2000_2 if rid==6,  msize(1.5) m(t) mlc(gs0) mfc("161 217 155") mlw(0.1))
		,
			graphregion(color(gs16)) ysize(6) xsize(6)

			xlab(8(4)32, labs(2.5) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill range(`range') lc(gs0))
			xtitle("Premature Mortality (30q70) in 2000", size(2.5) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(8(2)32, tlc(gs0))

			ylab(8(4)32
			,
			valuelabel labc(gs0) labs(2.5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale( lw(vthin) range(10(1)26))
			ytitle("Premature Mortality (30q70) in 2016", size(2.5) margin(l=2 r=5 t=2 b=2))
            ymtick(8(2)32)

			legend(size(2.5) position(12) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(2)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(2 3)
			lab(2 "Carib: women")
			lab(3 "Amer: women")
            )
            name(scatter_women)
            ;
#delimit cr

** Central and South America
** MEN
#delimit ;
	gr twoway
		/// Reference line
        (function y=x, range(8 32) col(gs13) lp("-") mlw(0.1))
        /// Female: Caribbean
        ///(sc   pmort2016_1 pmort2000_1 if rid==1,  msize(1.5) m(o) mlc(gs0) mfc("8 81 156") mlw(0.1))
		/// Male: Caribbean
        (sc   pmort2016_2 pmort2000_2 if rid==1,  msize(1.5) m(t) mlc(gs0) mfc("8 81 156") mlw(0.1))

		/// Female: CA and LA
        ///(sc   pmort2016_1 pmort2000_1 if rid==6,  msize(1.5) m(o) mlc(gs0) mfc("161 217 155") mlw(0.1))
		/// Male: CA and LA
        (sc   pmort2016_2 pmort2000_2 if rid==6,  msize(1.5) m(t) mlc(gs0) mfc("161 217 155") mlw(0.1))
		,
			graphregion(color(gs16)) ysize(6) xsize(6)

			xlab(8(4)32, labs(2.5) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill range(`range') lc(gs0))
			xtitle("Premature Mortality (30q70) in 2000", size(2.5) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(8(2)32, tlc(gs0))

			ylab(8(4)32
			,
			valuelabel labc(gs0) labs(2.5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale( lw(vthin) range(10(1)26))
			ytitle("Premature Mortality (30q70) in 2016", size(2.5) margin(l=2 r=5 t=2 b=2))
            ymtick(8(2)32)

			legend(size(2.5) position(12) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(2)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(2 3 )
			lab(2 "Carib: men")
			lab(3 "Amer: men")
            )
            name(scatter_men)
            ;
#delimit cr


*/

** -----------------------------------------------------
** FIGURE 4
** -----------------------------------------------------
** 
** We finally want an X-Y plot of 
** Y = 30q70 in 2016 / X = number of 'best-buy' interventions implemented by 2017
** 4 quadrants
** BOTTOM RIGHT = IDEAL: 								Low 30q70  / High # interventions implemented
** BOTTOM LEFT  = OK NOW, BUT UNCERTAIN FUTURE: 		Low 30q70  / Low  # interventions implemented
** TOP RIGHT    = NOT GOOD YET, BUT HOPEFUL FUTURE: 	High 30q70 / High # interventions implemented
** TOP LEFT     = NOT GOOD YET, AND UNCERTAIN FUTURE: 	High 30q70 / Low  # interventions implemented

** We first load the 30q70 for 2016
** Scatterplot of Regional 30Q70 in 2000 and in 2016
use "`datapath'/version01/2-working/file100_q3070_lac.dta", clear 
drop w_*
recode rid 2 3 = 6 
label define rid_ 1 "Caribbean" 6 "South and Central America", modify 
label values rid rid_ 
keep if rid==1 | rid==6 
keep if year==2000 | year==2016
label define sex_ 1 "women" 2 "men" 3 "both",modify
label values sex sex_
rename q3070 pmort
reshape wide pmort , i(rid iso3 unid sex) j(year)
rename pmort2000 pmort2000_
rename pmort2016 pmort2016_
reshape wide pmort2000_ pmort2016_ , i(rid iso3 unid) j(sex)
tempfile pmort
save `pmort', replace 

** Join with WHO progress monitoring 
use "`datapath'/version01/2-working/file07_who_progress_monitor", clear 
rename cid iso3 
merge 1:1 iso3 using `pmort' 
drop if _merge==1
drop _merge 
sort rid iso3
order iso3 unid rid pmort* totpop tmort pdeath 

** Total score from --> WHO progress monitor
rename t8 t17
rename t9 t18
rename t10 t19
rename t5a t5
rename t5b t6 
rename t5c t7 
rename t5d t8
rename t5e t9 
rename t6a t10 
rename t6b t11
rename t6c t12
rename t7a t13
rename t7b t14
rename t7c t15
rename t7d t16
egen tot_score = rowtotal(t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19)
drop totpop pmort tmort  

** We want median premature mortality and median progress score
** These values form the quadrant stratifiers 
sum tot_score , detail 
local prog_med = r(p50)
sum pmort2016_3 , detail
local mort_med = r(p50)
dis " WHO progress median = " `prog_med'
dis " Premature mortality = " `mort_med'

** iso3 to lowercase
replace iso3 = lower(iso3)

/*
** Caribbean
#delimit ;
	gr twoway 
		/// BOTTOM LEFT. Orange --> Low mortality but poor progress
		/// BRB / BHS
		(sc pmort2016_3 tot_score if iso3=="brb" & rid==1 & pmort2016_3<`mort_med' & tot_score<`prog_med'   ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("253 174 97") msize(3) m(O) mlc(gs0) mfc("253 174 97 %50") mlw(0.1)
					mlabp(6))
		(sc pmort2016_3 tot_score if iso3=="bhs" & rid==1 & pmort2016_3<`mort_med' & tot_score<`prog_med'   ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("253 174 97") msize(3) m(O) mlc(gs0) mfc("253 174 97 %50") mlw(0.1)
					mlabp(9))
		/// TOP LEFT. Red --> Poor outlook
		/// ATG / BLZ / CUB / GRD / GUY / HTI / LCA / VCT / TTO
		(sc pmort2016_3 tot_score if iso3=="atg" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("215 25 28") msize(3) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(9))
		(sc pmort2016_3 tot_score if iso3=="blz" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("215 25 28") msize(3) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(2))
		(sc pmort2016_3 tot_score if iso3=="cub" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("215 25 28") msize(3) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="grd" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("215 25 28") msize(3) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(8) mlabg(1pt))
		(sc pmort2016_3 tot_score if iso3=="guy" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("215 25 28") msize(3) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="hti" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("215 25 28") msize(3) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="lca" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("215 25 28") msize(3) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="vct" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("215 25 28") msize(3) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="tto" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("215 25 28") msize(3) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(12))
		/// BOTTOM RIGHT. Green --> Very good progress 
		/// JAM
		(sc pmort2016_3 tot_score if iso3=="jam" & rid==1 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("26 150 65") msize(3) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(3))
		/// TOP RIGHT. Orange --> Hopeful 
		/// DOM / SUR
		(sc pmort2016_3 tot_score if iso3=="dom" & rid==1 & pmort2016_3>=`mort_med' & tot_score>=`prog_med' ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("253 174 97") msize(3) m(O) mlc(gs0) mfc("253 174 97 %50") mlw(0.1)
					mlabp(4))
		(sc pmort2016_3 tot_score if iso3=="sur" & rid==1 & pmort2016_3>=`mort_med' & tot_score>=`prog_med' ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("253 174 97") msize(3) m(O) mlc(gs0) mfc("253 174 97 %50") mlw(0.1)
					mlabp(12))
		,
			graphregion(color(gs16)) ysize(10) xsize(10)
			plotregion(margin(zero))

			xlab(0(5)35, 
			tstyle(major_notick) labs(3) labc(gs10) nogrid format(%9.0f))
			xtitle("WHO progress monitor score", size(3)  color(gs10) margin(l=2 r=2 t=5 b=2)) 
			xscale(lw(vthin) noline range(5(5)35)) 
			
			ylab(10(5)35,
			labs(3) labc(gs10) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(lw(vthin) noline range(5(5)35)) 
			ytitle("Premature Mortality (30q70)", size(3) color(gs10) margin(l=2 r=5 t=2 b=2)) 

			yline(`mort_med', lc(gs7) lw(0.25))
			xline(`prog_med', lc(gs7) lw(0.25))
			
			note("atg=Antigua and Barbuda, bhs=Bahamas, blz=Belize, brb=Barbados, cub=Cuba," 
			"dom=Dominican Republic, grd=Grenada, guy=Guyana, hti=Haiti, jam=Jamaica, " 
			"lca=Saint Lucia, sur=Suriname, tto=Trinidad and Tobago," 
			"vct=Saint Vincent and the Grenadines", color(gs10) size(2))

			/// Quandrant descriptors
			text( 7.5  35  "{it:Low 30q70}" "{it:High progress}", 		j(right) place(w) size(2) col(gs10) box lc(gs8) fc(gs14) margin(l=1 r=1 t=1 b=1) ) 
			text( 32.5  35  "{it:High 30q70}" "{it:High progress}", 	j(right) place(w) size(2) col(gs10) box lc(gs8) fc(gs14) margin(l=1 r=1 t=1 b=1) ) 

			text( 32.5  0  "{it:High 30q70}" "{it:Low progress}", 	j(left) place(e) size(2) col(gs10) box lc(gs8) fc(gs14) margin(l=1 r=1 t=1 b=1) ) 
			text( 7.5  0  "{it:Low 30q70}" "{it:Low progress}", 		j(left) place(e) size(2) col(gs10) box lc(gs8) fc(gs14) margin(l=1 r=1 t=1 b=1) ) 

			legend(off)
			name(monitor_caribbean)
			;
	#delimit cr

*/
** Minor jitter to show both country points (Honduras and El Salvador) 
replace pmort2016_3 = pmort2016_3+0.2 if iso3=="hnd"
replace pmort2016_3 = pmort2016_3-0.4 if iso3=="slv"
/*
** South and Central America 
#delimit ;
	gr twoway 
		/// BOTTOM LEFT. Orange --> Low mortality but poor progress
		/// NIC
		(sc pmort2016_3 tot_score if iso3=="nic" & rid==6  & pmort2016_3<`mort_med' & tot_score<`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("253 174 97") msize(3) m(O) mlc(gs0) mfc("253 174 97 %50") mlw(0.1)
					mlabp(12))
		/// TOP LEFT. Red --> Poor outlook
		/// ATG / BLZ / CUB / GRD / GUY / HTI / LCA / VCT / TTO

		(sc pmort2016_3 tot_score if iso3=="bol" & rid==6 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("215 25 28") msize(3) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(9))
		(sc pmort2016_3 tot_score if iso3=="pry" & rid==6 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("215 25 28") msize(3) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(1))
		(sc pmort2016_3 tot_score if iso3=="ven" & rid==6 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("215 25 28") msize(3) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(12))

		/// BOTTOM RIGHT. Green --> Very good progress 
		/// ARG / CRI
		(sc pmort2016_3 tot_score if iso3=="arg" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("26 150 65") msize(3) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="chl" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("26 150 65") msize(3) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(4) mlabg(1pt))
		(sc pmort2016_3 tot_score if iso3=="col" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("26 150 65") msize(3) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(3) mlabg(2pt))
		(sc pmort2016_3 tot_score if iso3=="cri" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("26 150 65") msize(3) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="ecu" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("26 150 65") msize(3) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(5) mlabg(1pt))
		(sc pmort2016_3 tot_score if iso3=="gtm" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("26 150 65") msize(3) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(10))
		(sc pmort2016_3 tot_score if iso3=="hnd" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("26 150 65") msize(3) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(9))	
		(sc pmort2016_3 tot_score if iso3=="mex" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("26 150 65") msize(3) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(3))	
		(sc pmort2016_3 tot_score if iso3=="pan" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med' ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("26 150 65") msize(3) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="per" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("26 150 65") msize(3) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(6) mlabg(1pt))			
		(sc pmort2016_3 tot_score if iso3=="slv" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("26 150 65") msize(3) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(8))					
		/// TOP RIGHT. Orange --> Hopeful 
		/// BRA
		(sc pmort2016_3 tot_score if iso3=="bra" & rid==6 & pmort2016_3>=`mort_med' & tot_score>=`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("253 174 97") msize(3) m(O) mlc(gs0) mfc("253 174 97 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="ury" & rid==6 & pmort2016_3>=`mort_med' & tot_score>=`prog_med'  ,  
					mlabel(iso3) mlabs(2.5) mlabp(12) mlabc("253 174 97") msize(3) m(O) mlc(gs0) mfc("253 174 97 %50") mlw(0.1)
					mlabp(1))
		,
			graphregion(color(gs16)) ysize(10) xsize(10)
			plotregion(margin(zero))

			xlab(0(5)35, 
			tstyle(major_notick) labs(3) labc(gs10) nogrid format(%9.0f))
			xtitle("WHO progress monitor score", size(3)  color(gs10) margin(l=2 r=2 t=5 b=2)) 
			xscale(lw(vthin) noline range(5(5)35)) 
			
			ylab(10(5)35,
			labs(3) labc(gs10) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(lw(vthin) noline range(5(5)35)) 
			ytitle("Premature Mortality (30q70)", size(3) color(gs10) margin(l=2 r=5 t=2 b=2)) 

			yline(`mort_med', lc(gs7) lw(0.25))
			xline(`prog_med', lc(gs7) lw(0.25))
			
			note("arg=Argentina, bol=Bolivia, bra=Brazil, chl=Chile, col=Colombia," 
			"cri=Costa Rica, ecu=Ecuador,  gtm=Guatemala, hnd=Honduras, mex=Mexico," 
			"nic=Nicaragua, pan=Panama, pry=Paraguay, per=Peru, slv=ElSalvador," 
			"ury=Uruguay, ven=Venezuela", color(gs10) size(2))

			/// Quandrant descriptors
			text( 7.5  35  "{it:Low 30q70}" "{it:High progress}", 		j(right) place(w) size(2) col(gs10) box lc(gs8) fc(gs14) margin(l=1 r=1 t=1 b=1) ) 
			text( 32.5  35  "{it:High 30q70}" "{it:High progress}", 	j(right) place(w) size(2) col(gs10) box lc(gs8) fc(gs14) margin(l=1 r=1 t=1 b=1) ) 

			text( 32.5  0  "{it:High 30q70}" "{it:Low progress}", 	j(left) place(e) size(2) col(gs10) box lc(gs8) fc(gs14) margin(l=1 r=1 t=1 b=1) ) 
			text( 7.5  0  "{it:Low 30q70}" "{it:Low progress}", 		j(left) place(e) size(2) col(gs10) box lc(gs8) fc(gs14) margin(l=1 r=1 t=1 b=1) ) 

			legend(off)
			name(monitor_southamerica)
			;
	#delimit cr

*/

** JOINT CARIBBEAN / SOUTH AMERICA GRAPHIC WITH ELLIPSES

#delimit ;
	ellip pmort2016_3 tot_score if rid==1 | rid==6,
		
			by(rid) 
			overlay
			lc("8 81 156 %75" "35 139 69 %75") lp("-" "-")

		    plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
		    graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(10) xsize(10)

			xlab(0(5)35, 
			tstyle(major_notick) labs(3) labc(gs10) nogrid format(%9.0f))
			xtitle("WHO progress monitor score", size(3) color(gs10) margin(l=2 r=2 t=5 b=2)) 
			xscale(lw(vthin) noline range(5(5)35)) 
			
			ylab(10(5)35,
			labs(3) labc(gs10) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(lw(vthin) noline range(5(5)35)) 
			ytitle("Premature Mortality (30q70)", size(3) color(gs10) margin(l=2 r=5 t=2 b=2)) 

			yline(`mort_med', lc(gs7) lw(0.25))
			xline(`prog_med', lc(gs7) lw(0.25))

			title("")
			subtitle("")
			note("")

			legend(size(2.5) nobox color(gs10) ring(0) position(1) bm(t=0 b=5 l=0 r=0) colf cols(1) order(3 4)
			region(fc(gs16) lc(gs16) lw(thin) margin(l=1 r=1 t=1 b=1)) 
			lab(3 "Caribbean") 
			lab(4 "South and Central America") 
			)

	plot(

		(sc pmort2016_3 tot_score if rid==1    ,  
					msize(2) m(O) mlc(gs0) mfc("8 81 156 %50") mlw(0.1))
		(sc pmort2016_3 tot_score if rid==6    ,  
					msize(2) m(O) mlc(gs0) mfc("35 139 69 %50") mlw(0.1))

	)
	;
#delimit cr 

