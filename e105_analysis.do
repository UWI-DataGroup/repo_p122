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
    local outputpath "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122"

    ** Close any open log file and open a new log file
    capture log close
    log using "`logpath'\e105_analysis", replace
** HEADER -----------------------------------------------------




** For SAP --> See e000_000.do

** -----------------------------------------------------
** FIGURE 2. EQUIPLOT OF COUNTRY AND REGIONAL 30q70 
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
			subtitle("(A) Caribbean", pos(11) size(3.5))

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
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122\05_Outputs\HAMBLETON_Figure2a.svg", as(svg) name("caribbean") replace
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122\05_Outputs\HAMBLETON_Figure2a.png", replace width(6000)

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
			subtitle("(B) South and Central America", pos(11) size(3.5))

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
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122\05_Outputs\HAMBLETON_Figure2b.svg", as(svg) name("ca_and_sa") replace
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122\05_Outputs\HAMBLETON_Figure2b.png", replace width(4000)



** -----------------------------------------------------
** FIGURE 1
** -----------------------------------------------------
** Line chart of Regional 30Q70 by YEAR
use "`datapath'/version01/2-working/file100_q3070_region_various.dta", clear 
** drop if sex==3
keep if rid==1 | rid==6 


** Central and South America
#delimit ;
	gr twoway
		/// Female: Caribbean
		(line q3070 year if rid==1 & sex==1 , lc(gs10) lw(0.35) lp("l"))
        (sc   q3070 year if rid==1 & sex==1,  msize(2.5) m(o) mlc(gs10) mfc("8 81 156") mlw(0.1))
		/// Male: Caribbean
		(line q3070 year if rid==1 & sex==2 , lc(gs10) lw(0.35) lp("l"))
        (sc   q3070 year if rid==1 & sex==2,  msize(2.5) m(t) mlc(gs10) mfc("8 81 156") mlw(0.1))

		/// Female: CA and LA
		(line q3070 year if rid==6 & sex==1 , lc(gs10) lw(0.35) lp("l"))
        (sc   q3070 year if rid==6 & sex==1,  msize(2.5) m(o) mlc(gs10) mfc("161 217 155") mlw(0.1))
		/// Male: CA and LA
		(line q3070 year if rid==6 & sex==2 , lc(gs10) lw(0.35) lp("l"))
        (sc   q3070 year if rid==6 & sex==2,  msize(2.5) m(t) mlc(gs10) mfc("161 217 155") mlw(0.1))

		,
			graphregion(color(gs16)) ysize(10) xsize(6)

			xlab(2000(4)2016, labs(3) tlc(gs0) labc(gs0) nogrid glc(gs16))
			xscale(fill range(`range') lc(gs0))
			xtitle("Year", size(3) color(gs0) margin(l=2 r=2 t=2 b=2))
			xmtick(2000(1)2016, tlc(gs0))

			ylab(12(2)25
			,
			valuelabel labc(gs0) labs(3) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale( lw(vthin) range(12(1)25))
			ytitle("Premature Mortality (30q70)", size(3) margin(l=2 r=2 t=2 b=2))
            ymtick(12(1)25)

			legend(size(3) position(12) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(1)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(4 8 2 6)
			lab(4 "Men. Caribbean")
			lab(8 "Men. South and Central America")
			lab(2 "Women. Caribbean")
			lab(6 "Women. South and Central America")
            )
            name(line_01)
            ;
#delimit cr
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122\05_Outputs\HAMBLETON_Figure1.svg", as(svg) name("line_01") replace
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122\05_Outputs\HAMBLETON_Figure1.png", replace width(4000)


/*

** -----------------------------------------------------
** FIGURE X - NOT USED
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


** Caribbean
#delimit ;
	gr twoway 
		/// BOTTOM LEFT. Orange --> Low mortality but poor progress
		/// BRB / BHS
		(sc pmort2016_3 tot_score if iso3=="brb" & rid==1 & pmort2016_3<`mort_med' & tot_score<`prog_med'   ,  
					mlabs(3.5) mlabp(12) mlabc("253 174 97") msize(4) m(O) mlc(gs0) mfc("253 174 97 %50") mlw(0.1)
					mlabp(6))
		(sc pmort2016_3 tot_score if iso3=="bhs" & rid==1 & pmort2016_3<`mort_med' & tot_score<`prog_med'   ,  
					mlabs(3.5) mlabp(12) mlabc("253 174 97") msize(4) m(O) mlc(gs0) mfc("253 174 97 %50") mlw(0.1)
					mlabp(9))
		/// TOP LEFT. Red --> Poor outlook
		/// ATG / BLZ / CUB / GRD / GUY / HTI / LCA / VCT / TTO
		(sc pmort2016_3 tot_score if iso3=="atg" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("215 25 28") msize(4) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(9))
		(sc pmort2016_3 tot_score if iso3=="blz" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("215 25 28") msize(4) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(2))
		(sc pmort2016_3 tot_score if iso3=="cub" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("215 25 28") msize(4) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="grd" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("215 25 28") msize(4) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(8) mlabg(1pt))
		(sc pmort2016_3 tot_score if iso3=="guy" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("215 25 28") msize(4) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="hti" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("215 25 28") msize(4) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="lca" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("215 25 28") msize(4) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="vct" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("215 25 28") msize(4) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="tto" & rid==1 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("215 25 28") msize(4) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(12))
		/// BOTTOM RIGHT. Green --> Very good progress 
		/// JAM
		(sc pmort2016_3 tot_score if iso3=="jam" & rid==1 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("26 150 65") msize(4) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(4))
		/// TOP RIGHT. Orange --> Hopeful 
		/// DOM / SUR
		(sc pmort2016_3 tot_score if iso3=="dom" & rid==1 & pmort2016_3>=`mort_med' & tot_score>=`prog_med' ,  
					mlabs(3.5) mlabp(12) mlabc("253 174 97") msize(4) m(O) mlc(gs0) mfc("253 174 97 %50") mlw(0.1)
					mlabp(4))
		(sc pmort2016_3 tot_score if iso3=="sur" & rid==1 & pmort2016_3>=`mort_med' & tot_score>=`prog_med' ,  
					mlabs(3.5) mlabp(12) mlabc("253 174 97") msize(4) m(O) mlc(gs0) mfc("253 174 97 %50") mlw(0.1)
					mlabp(12))
		,
			graphregion(color(gs16)) ysize(10) xsize(6)
			plotregion(margin(zero))

			xlab(0(5)35, 
			tstyle(major_notick) labs(4) labc(gs10) nogrid format(%9.0f))
			xtitle("WHO progress monitor score", size(4)  color(gs10) margin(l=2 r=2 t=5 b=2)) 
			xscale(lw(vthin) noline range(5(5)35)) 
			
			ylab(10(5)35,
			labs(4) labc(gs10) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(lw(vthin) noline range(5(5)35)) 
			ytitle("Premature Mortality (30q70)", size(4) color(gs10) margin(l=2 r=5 t=2 b=2)) 

			yline(`mort_med', lc(gs7) lw(0.25))
			xline(`prog_med', lc(gs7) lw(0.25))
			subtitle("(C) Caribbean", pos(11) size(4))
			
			note("atg=Antigua and Barbuda, bhs=Bahamas, blz=Belize," 
			"brb=Barbados, cub=Cuba, dom=Dominican Republic," 
			"grd=Grenada, guy=Guyana, hti=Haiti, jam=Jamaica,"
			"lca=Saint Lucia, sur=Suriname, tto=Trinidad and Tobago," 
			"vct=Saint Vincent and the Grenadines", color(gs10) size(3))

			/// Country TEXT on graphic
			/// RED (upper left)
			text( 31.6 15.0  "{bf:guy}", 		j(right) place(w) size(3) col("215 25 28 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 27.4 3.8  "{bf:hti}", 		j(right) place(w) size(3) col("215 25 28 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 24.1 10.2  "{bf:vct}", 		j(right) place(w) size(3) col("215 25 28 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 22.6 8.4  "{bf:atg}", 		j(right) place(w) size(3) col("215 25 28 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 22.5 13.8  "{bf:blz}", 		j(right) place(w) size(3) col("215 25 28 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 22.2 16.2  "{bf:tto}", 		j(right) place(w) size(3) col("215 25 28 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 21.0 8.9  "{bf:grd}", 		j(right) place(w) size(3) col("215 25 28 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 19.0 9.9  "{bf:lca}", 		j(right) place(w) size(3) col("215 25 28 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 17.4 14.5  "{bf:cub}", 		j(right) place(w) size(3) col("215 25 28 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 

			/// GREEN (lower right)
			text( 14.6 23.6  "{bf:jam}", 		j(right) place(w) size(3) col("26 150 65 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 

			/// ORANGE (upper right)
			text( 22.7 20.6  "{bf:sur}", 		j(right) place(w) size(3) col("253 174 97 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 19.0 21.8  "{bf:dom}", 		j(right) place(w) size(3) col("253 174 97 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 

			/// ORANGE (lower left)
			text( 15.5 9.5  "{bf:bhs}", 		j(right) place(w) size(3) col("253 174 97 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 15.3 15.2  "{bf:brb}", 		j(right) place(w) size(3) col("253 174 97 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 

			/// Quandrant descriptors
			text( 7.5  35  "{it:Low 30q70}" "{it:High progress}", 		j(right) place(w) size(3) col(gs0) box lc(gs0) lw(0.1) fc("26 150 65 %50") margin(l=1 r=1 t=1 b=1) ) 
			text( 32.5  35  "{it:High 30q70}" "{it:High progress}", 	j(right) place(w) size(3) col(gs0) box lc(gs0) lw(0.1) fc("253 174 97 %50") margin(l=1 r=1 t=1 b=1) ) 

			text( 32.5  0  "{it:High 30q70}" "{it:Low progress}", 	j(left) place(e) size(3) col(gs0) box lc(gs0) lw(0.1) fc("215 25 28 %50") margin(l=1 r=1 t=1 b=1) ) 
			text( 7.5  0  "{it:Low 30q70}" "{it:Low progress}", 		j(left) place(e) size(3) col(gs0) box lc(gs0) lw(0.1) fc("253 174 97 %50") margin(l=1 r=1 t=1 b=1) ) 

			legend(off)
			name(monitor_caribbean)
			;
	#delimit cr
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122\05_Outputs\HAMBLETON_Figure4c.svg", as(svg) name("monitor_caribbean") replace
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122\05_Outputs\HAMBLETON_Figure4c.png", replace width(4000)



** Minor jitter to show both country points (Honduras and El Salvador) 
replace pmort2016_3 = pmort2016_3+0.2 if iso3=="hnd"
replace pmort2016_3 = pmort2016_3-0.4 if iso3=="slv"

** South and Central America 
#delimit ;
	gr twoway 
		/// BOTTOM LEFT. Orange --> Low mortality but poor progress
		/// NIC
		(sc pmort2016_3 tot_score if iso3=="nic" & rid==6  & pmort2016_3<`mort_med' & tot_score<`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("253 174 97") msize(4) m(O) mlc(gs0) mfc("253 174 97 %50") mlw(0.1)
					mlabp(12))
		/// TOP LEFT. Red --> Poor outlook
		/// ATG / BLZ / CUB / GRD / GUY / HTI / LCA / VCT / TTO

		(sc pmort2016_3 tot_score if iso3=="bol" & rid==6 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("215 25 28") msize(4) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(9))
		(sc pmort2016_3 tot_score if iso3=="pry" & rid==6 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("215 25 28") msize(4) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(1))
		(sc pmort2016_3 tot_score if iso3=="ven" & rid==6 & pmort2016_3>=`mort_med' & tot_score<`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("215 25 28") msize(4) m(O) mlc(gs0) mfc("215 25 28 %50") mlw(0.1)
					mlabp(12))

		/// BOTTOM RIGHT. Green --> Very good progress 
		/// ARG / CRI
		(sc pmort2016_3 tot_score if iso3=="arg" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("26 150 65") msize(4) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="chl" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("26 150 65") msize(4) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(4) mlabg(1pt))
		(sc pmort2016_3 tot_score if iso3=="col" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("26 150 65") msize(4) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(3) mlabg(2pt))
		(sc pmort2016_3 tot_score if iso3=="cri" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("26 150 65") msize(4) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="ecu" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("26 150 65") msize(4) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(5) mlabg(1pt))
		(sc pmort2016_3 tot_score if iso3=="gtm" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("26 150 65") msize(4) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(10))
		(sc pmort2016_3 tot_score if iso3=="hnd" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("26 150 65") msize(4) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(9))	
		(sc pmort2016_3 tot_score if iso3=="mex" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("26 150 65") msize(4) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(3))	
		(sc pmort2016_3 tot_score if iso3=="pan" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med' ,  
					mlabs(3.5) mlabp(12) mlabc("26 150 65") msize(4) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="per" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("26 150 65") msize(4) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(6) mlabg(1pt))			
		(sc pmort2016_3 tot_score if iso3=="slv" & rid==6 & pmort2016_3<`mort_med' & tot_score>=`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("26 150 65") msize(4) m(O) mlc(gs0) mfc("26 150 65 %50") mlw(0.1)
					mlabp(8))					
		/// TOP RIGHT. Orange --> Hopeful 
		/// BRA
		(sc pmort2016_3 tot_score if iso3=="bra" & rid==6 & pmort2016_3>=`mort_med' & tot_score>=`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("253 174 97") msize(4) m(O) mlc(gs0) mfc("253 174 97 %50") mlw(0.1)
					mlabp(12))
		(sc pmort2016_3 tot_score if iso3=="ury" & rid==6 & pmort2016_3>=`mort_med' & tot_score>=`prog_med'  ,  
					mlabs(3.5) mlabp(12) mlabc("253 174 97") msize(4) m(O) mlc(gs0) mfc("253 174 97 %50") mlw(0.1)
					mlabp(1))
		,
			graphregion(color(gs16)) ysize(10) xsize(6)
			plotregion(margin(zero))

			xlab(0(5)35, 
			tstyle(major_notick) labs(4) labc(gs10) nogrid format(%9.0f))
			xtitle("WHO progress monitor score", size(4)  color(gs10) margin(l=2 r=2 t=5 b=2)) 
			xscale(lw(vthin) noline range(5(5)35)) 
			
			ylab(10(5)35,
			labs(4) labc(gs10) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(lw(vthin) noline range(5(5)35)) 
			ytitle("Premature Mortality (30q70)", size(4) color(gs10) margin(l=2 r=5 t=2 b=2)) 

			yline(`mort_med', lc(gs7) lw(0.25))
			xline(`prog_med', lc(gs7) lw(0.25))
			subtitle("(B) South and Central America", pos(11) size(4))
			
			note("arg=Argentina, bol=Bolivia, bra=Brazil, chl=Chile," 
			"col=Colombia, cri=Costa Rica, ecu=Ecuador," 
			" gtm=Guatemala, hnd=Honduras, mex=Mexico," 
			" nic=Nicaragua, pan=Panama, pry=Paraguay, per=Peru, " 
			"slv=El Salvador, ury=Uruguay, ven=Venezuela", color(gs10) size(3))

			/// Country TEXT on graphic
			/// RED (upper left)
			text( 19 12.6  "{bf:ven}", 		j(right) place(w) size(3) col("215 25 28 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 17.4 8.5  "{bf:bol}", 		j(right) place(w) size(3) col("215 25 28 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 18.4 16.3  "{bf:pry}", 		j(right) place(w) size(3) col("215 25 28 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			/// ORANGE (lower left)
			text( 14.5 6.4  "{bf:nic}", 		j(right) place(w) size(3) col("253 174 97 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			/// ORANGE (upper right)
			text( 17.8 19.6  "{bf:ury}", 		j(right) place(w) size(3) col("253 174 97 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 17.6 31  "{bf:bra}", 		j(right) place(w) size(3) col("253 174 97 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			/// GREEN (lower right)
			text( 15.2 15.8  "{bf:gtm}", 		j(right) place(w) size(3) col("26 150 65 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 14.3 15.8  "{bf:hnd}", 		j(right) place(w) size(3) col("26 150 65 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 13.5 15.8  "{bf:slv}", 		j(right) place(w) size(3) col("26 150 65 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 12.5 16.5  "{bf:per}", 		j(right) place(w) size(3) col("26 150 65 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 15.3 21.4  "{bf:mex}", 		j(right) place(w) size(3) col("26 150 65 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 

			text( 16.8 23.0  "{bf:arg}", 		j(right) place(w) size(3) col("26 150 65 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 15.5 27.0  "{bf:col}", 		j(right) place(w) size(3) col("26 150 65 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 12.5 34.0  "{bf:cri}", 		j(right) place(w) size(3) col("26 150 65 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 12.3 27.9  "{bf:chl}", 		j(right) place(w) size(3) col("26 150 65 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 14.0 21.3  "{bf:pan}", 		j(right) place(w) size(3) col("26 150 65 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 
			text( 12.21 23.0  "{bf:ecu}", 		j(right) place(w) size(3) col("26 150 65 %50") nobox lc(gs0) margin(l=0 r=0 t=0 b=0) ) 

			/// Quandrant descriptors
			text( 7.5  35  "{it:Low 30q70}" "{it:High progress}", 		j(right) place(w) size(3) col(gs0) box lc(gs0) lw(0.1) fc("26 150 65 %50") margin(l=1 r=1 t=1 b=1) ) 
			text( 32.5  35  "{it:High 30q70}" "{it:High progress}", 	j(right) place(w) size(3) col(gs0) box lc(gs0) lw(0.1) fc("253 174 97 %50") margin(l=1 r=1 t=1 b=1) ) 

			text( 32.5  0  "{it:High 30q70}" "{it:Low progress}", 	j(left) place(e) size(3) col(gs0) box lc(gs0) lw(0.1) fc("215 25 28 %50") margin(l=1 r=1 t=1 b=1) ) 
			text( 7.5  0  "{it:Low 30q70}" "{it:Low progress}", 		j(left) place(e) size(3) col(gs0) box lc(gs0) lw(0.1) fc("253 174 97 %50") margin(l=1 r=1 t=1 b=1) ) 

			legend(off)
			name(monitor_southamerica)
			;
	#delimit cr
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122\05_Outputs\HAMBLETON_Figure4b.svg", as(svg) name("monitor_southamerica") replace
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122\05_Outputs\HAMBLETON_Figure4b.png", replace width(4000)



** JOINT CARIBBEAN / SOUTH AMERICA GRAPHIC WITH ELLIPSES

#delimit ;
	ellip pmort2016_3 tot_score if rid==1 | rid==6,
		
			by(rid) 
			overlay
			lc("8 81 156 %75" "35 139 69 %75") lp("-" "-")

		    plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
		    graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(10) xsize(6)

			xlab(0(5)35, 
			tstyle(major_notick) labs(4) labc(gs10) nogrid format(%9.0f))
			xtitle("WHO progress monitor score", size(4) color(gs10) margin(l=2 r=2 t=5 b=2)) 
			xscale(lw(vthin) noline range(5(5)35)) 
			
			ylab(10(5)35,
			labs(4) labc(gs10) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(lw(vthin) noline range(5(5)35)) 
			ytitle("Premature Mortality (30q70)", size(4) color(gs10) margin(l=2 r=5 t=2 b=2)) 

			yline(`mort_med', lc(gs7) lw(0.25))
			xline(`prog_med', lc(gs7) lw(0.25))

			text( 27.7  2.4  "Haiti", j(right) place(w) size(3.5) col(gs6) nobox lc(gs0) ) 
			text( 31.75  13.8  "Guyana", j(right) place(w) size(3.5) col(gs6) nobox lc(gs0) ) 
			text( 17.9  31.4  "Brazil", j(right) place(w) size(3.5) col(gs6) nobox lc(gs0) ) 
			text( 10.4 35  "Costa Rica", j(right) place(w) size(3.5) col(gs6) nobox lc(gs0) ) 

			title("")
			subtitle("")
			note("")

			legend(size(3.5) nobox color(gs10) position(6) bm(t=0 b=5 l=0 r=0) colf cols(1) order(3 4)
			region(fc(gs16) lc(gs16) lw(thin) margin(l=1 r=1 t=1 b=1)) 
			lab(3 "Caribbean") 
			lab(4 "South/Central America") 
			)

	plot(

		(sc pmort2016_3 tot_score if rid==1    ,  
					msize(4) m(O) mlc(gs0) mfc("8 81 156 %50") mlw(0.1))
		(sc pmort2016_3 tot_score if rid==6    ,  
					msize(4) m(O) mlc(gs0) mfc("35 139 69 %50") mlw(0.1) subtitle("(A) Latin America and the Caribbean", pos(11) size(4)))

	)
	name(monitor_compare)
	;
#delimit cr 
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122\05_Outputs\HAMBLETON_Figure4a.svg", as(svg) name("monitor_compare") replace
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122\05_Outputs\HAMBLETON_Figure4a.png", replace width(4000)




** PDF for FIGURE 1
    putpdf begin, pagesize(letter) font("Calibri Light", 12) margin(top,1cm) margin(bottom,1cm) margin(left,1cm) margin(right,1cm)
	* Fig title
    putpdf paragraph ,  font("Calibri Light", 12)
    putpdf text ("FIGURE 1. ") , bold
    putpdf text ("Change in premature mortality between 2000 and 2016 for women and men by subregion ")
	* The figure
    putpdf table f2 = (1,1), width(60%) border(all,nil) halign(center)
    putpdf table f2(1,1)=image("`outputpath'/05_Outputs/HAMBLETON_Figure1.png")
    ** putpdf save 
    putpdf save "`outputpath'/05_Outputs/Health and Place/HAMBLETON_HealthPlace_200623_Figure1", replace


** PDF for FIGURE 2
    putpdf begin, landscape pagesize(letter) font("Calibri Light", 12) margin(top,1cm) margin(bottom,1cm) margin(left,1cm) margin(right,1cm)
	* Fig title
    putpdf paragraph ,  font("Calibri Light", 12)
    putpdf text ("FIGURE 2. ") , bold
    putpdf text ("Premature mortality between 2000 and 2016 by subregion ")
	* The figure
    putpdf table f2 = (1,2), width(90%) border(all,nil) halign(center)
    putpdf table f2(1,1)=image("`outputpath'/05_Outputs/HAMBLETON_Figure2a.png")
    putpdf table f2(1,2)=image("`outputpath'/05_Outputs/HAMBLETON_Figure2b.png")
    ** putpdf save 
    putpdf save "`outputpath'/05_Outputs/Health and Place/HAMBLETON_HealthPlace_200623_Figure2", replace


** PDF for FIGURE 4
    putpdf begin, landscape pagesize(letter) font("Calibri Light", 12) margin(top,1cm) margin(bottom,1cm) margin(left,1cm) margin(right,1cm)
	* Fig title
    putpdf paragraph ,  font("Calibri Light", 12)
    putpdf text ("FIGURE 4. ") , bold
    putpdf text ("Premature mortality in 2016 and WHO progress indicators in 2017 by subregion and country ")
	* The figure
    putpdf table f2 = (1,3), width(85%) border(all,nil) halign(center)
    putpdf table f2(1,1)=image("`outputpath'/05_Outputs/HAMBLETON_Figure4a.png")
    putpdf table f2(1,2)=image("`outputpath'/05_Outputs/HAMBLETON_Figure4b.png")
    putpdf table f2(1,3)=image("`outputpath'/05_Outputs/HAMBLETON_Figure4c.png")
	** Methodological Note
    putpdf paragraph ,  font("Calibri Light", 9)
    putpdf text ("Methodological Note. ") , bold
    putpdf text ("In graphic B and C, we divided our plot into four quadrants ")
    putpdf text ("based on median 30q70 and median progress score. ")
   	putpdf text ("Countries with a below average 30q70 and an above average progress score (bottom right quadrant) ")
   	putpdf text ("had relatively low premature non-communicable disease (NCD) mortality and national policies ")
   	putpdf text ("that should enable future NCD reductions. Countries with an above average 30q70 ")
   	putpdf text ("and a below average progress score (top left quadrant) had relatively high ")
   	putpdf text ("premature NCD mortality and lacked national policies for future reductions. ")

    ** putpdf save 
    putpdf save "`outputpath'/05_Outputs/Health and Place/HAMBLETON_HealthPlace_200623_Figure4", replace

