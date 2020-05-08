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




** For SAP --> See e000_000.do

** -----------------------------------------------------
** FIGURE 1. EQUIPLOT OF COUNTRY AND REGIONAL 30q70 
** -----------------------------------------------------
** Build the dataset for equiplot
** Country-level data 
use "`datapath'/version01/2-working/file100_q3070_lac.dta", clear 
keep if sex==3 
keep if year==2000|year==2008|year==2016
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
keep if sex==3 
keep if rid==1 | rid==6 
keep if year==2000|year==2008|year==2016
sort rid sex year q3070

merge 1:1 rid sex year using `country'
drop iso3 unid _merge 
label define sex_ 1 "women" 2 "men"
label values sex sex_

sort rid sex year 
order rid sex year 
gen yax = _n 
replace yax = yax - 3 if rid==6 

** Caribbean
#delimit ;
	gr twoway
		/// Line between min and max
		(rspike min3070 max3070 yax if rid==1 , hor lc(gs12) lw(0.35))
		/// Minimum points
		(sc yax min3070 if rid==1, 			    msize(8) m(o) mlc(gs0) mfc("198 219 239") mlw(0.1))
		/// Maximum points
		(sc yax max3070  if rid==1,             msize(8) m(o) mlc(gs0) mfc("8 81 156") mlw(0.1))
		/// Regional average
		(sc yax q3070  if rid==1, 				msize(8) m(o) mlc(gs0) mfc(gs13) mlw(0.1))
		,
			graphregion(color(gs16)) xsize(12) ysize(12)

			xlab(none , labs(5) tlc(gs0) labc(gs0) nogrid notick glc(gs16))
			xscale(noline lc(gs16))
			xtitle(" ", size(5) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(10(5)35, notick )

			ylab(1 "2000" 2  "2008" 3 "2016"
			,
			valuelabel labc(gs0) labs(5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(noline reverse range(0(1)4))
			ytitle("", size(3) margin(l=2 r=5 t=2 b=2))

			legend(off size(5) position(12) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(1)
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
		(sc yax min3070 if rid==6, 			    msize(8) m(o) mlc(gs0) mfc("161 217 155") mlw(0.1))
		/// Maximum points
		(sc yax max3070  if rid==6,             msize(8) m(o) mlc(gs0) mfc("35 139 69") mlw(0.1))
		/// Regional average
		(sc yax q3070  if rid==6, 				msize(8) m(o) mlc(gs0) mfc(gs13) mlw(0.1))
		,
			graphregion(color(gs16)) xsize(12) ysize(12)

			xlab(none , labs(5) tlc(gs0) labc(gs0) nogrid notick glc(gs16))
			xscale(noline lc(gs16))
			xtitle(" ", size(3) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(10(5)35, notick )

			ylab(1 "2000" 2  "2008" 3 "2016"
			,
			valuelabel labc(gs0) labs(5) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) reverse range(0(1)4))
			ytitle("", size(3) margin(l=2 r=5 t=2 b=2))

			legend(off size(3) position(12) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(1)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(2 3 4)
			lab(2 "Min 30q70")
			lab(3 "Max 30q70")
			lab(4 "Regional 30q70")
            )
            name(ca_and_sa)
            ;
#delimit cr


