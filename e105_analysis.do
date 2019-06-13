** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e103_analysis.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    30q70 from Life Table Analysis (2000 to 2016)

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
    log using "`logpath'\e103_analysis", replace
** HEADER -----------------------------------------------------

** For SAP --> See e000_000.do
/*
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


*/

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