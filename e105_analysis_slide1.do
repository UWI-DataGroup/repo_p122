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
keep if sex==3 
keep if rid==1 | rid==6 
keep if year==2000|year==2004|year==2008|year==2012|year==2016
sort rid sex year q3070

merge 1:1 rid sex year using `country'
drop iso3 unid _merge 
label define sex_ 1 "women" 2 "men" 3 "both"
label values sex sex_

sort rid sex year 
order rid sex year 
gen yax = _n 
replace yax = yax + 2 if yax>=6 
replace yax = yax-12 if _n>=11 
replace yax = yax + 2 if yax>=6 & rid==6
order yax


** -----------------------------------------------------
** SLIDE 2
** -----------------------------------------------------
** Line chart of Regional 30Q70 by YEAR
use "`datapath'/version01/2-working/file100_q3070_region_various.dta", clear 
keep if sex==3
keep if rid==1 | rid==6 


** GRAPHIC 1. Premature Mortality 2000-2007 
#delimit ;
	gr twoway
		/// Caribbean
		(line q3070 year if rid==1 & sex==3 & year<=2007 , lc(gs10) lw(0.35) lp("l"))
        (sc   q3070 year if rid==1 & sex==3 & year<=2007,  msize(2) m(o) mlc(gs0) mfc("8 81 156") mlw(0.1))
		(line q3070 year if rid==1 & sex==3 & year>2007 , lc(gs16) lw(0.35) lp("l"))

		/// CA and LA
		(line q3070 year if rid==6 & sex==3 & year<=2007, lc(gs10) lw(0.35) lp("l"))
        (sc   q3070 year if rid==6 & sex==3 & year<=2007,  msize(2) m(o) mlc(gs0) mfc("161 217 155") mlw(0.1))
		(line q3070 year if rid==6 & sex==3 & year>2007, lc(gs16) lw(0.35) lp("l"))

		,
			graphregion(color(gs16)) ysize(12) xsize(16)

			xlab(2000 "2000" 2008 "2008" 2016 " ", labs(5) tlc(gs0) labc(gs8) tstyle(major_notick) nogrid notick glc(gs16))
			xscale(noline lw(vthin) range(2000(1)2016) )
			xtitle(" ", size(3) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(2000(1)2016, notick)

			ylab(17(3)23
			,
			valuelabel labc(gs8) labs(5) tlc(gs0) tstyle(major_notick) nogrid notick glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) range(15(1)23))
			ytitle(" ", size(3) margin(l=2 r=5 t=2 b=2))
            ymtick(15(2)23, notick)

			legend(off size(3) position(12) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(2)
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
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p151/04_TechDocs/premmort1_$S_DATE.png", replace width(4000)

** GRAPHIC 1. Premature Mortality 2000-2007 + 2008-2016
#delimit ;
	gr twoway
		/// Caribbean
		(line q3070 year if rid==1 & sex==3 & year<=2007 , lc(gs10) lw(0.35) lp("l"))
        (sc   q3070 year if rid==1 & sex==3 & year<=2007,  msize(2) m(o) mlc(gs0) mfc("8 81 156") mlw(0.1))
		(line q3070 year if rid==1 & sex==3 & year>2007 , lc(gs16) lw(0.35) lp("l"))

		/// CA and LA
		(line q3070 year if rid==6 & sex==3 , lc(gs10) lw(0.35) lp("l"))
        (sc   q3070 year if rid==6 & sex==3 ,  msize(2) m(o) mlc(gs0) mfc("161 217 155") mlw(0.1))

		,
			graphregion(color(gs16)) ysize(12) xsize(16)

			xlab(2000 "2000" 2008 "2008" 2016 "2016", labs(5) tlc(gs0) labc(gs8) tstyle(major_notick) nogrid notick glc(gs16))
			xscale(noline lw(vthin) range(2000(1)2016) )
			xtitle(" ", size(3) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(2000(1)2016, notick)

			ylab(17(3)23
			,
			valuelabel labc(gs8) labs(5) tlc(gs0) tstyle(major_notick) nogrid notick glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) range(15(1)23))
			ytitle(" ", size(3) margin(l=2 r=5 t=2 b=2))
            ymtick(15(2)23, notick)

			legend(off size(3) position(12) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(2)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(2 4 6 8)
			lab(2 "Carib: women")
			lab(4 "Carib: men")
			lab(6 "Amer: women")
			lab(8 "Amer: men")
            )
            name(line_02)
            ;
#delimit cr
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p151/04_TechDocs/premmort2_$S_DATE.png", replace width(4000)

** GRAPHIC 1. Premature Mortality 2000-2007 + 2008-2016
#delimit ;
	gr twoway
		/// Caribbean
		(line q3070 year if rid==1 & sex==3  , lc(gs10) lw(0.35) lp("l"))
        (sc   q3070 year if rid==1 & sex==3 ,  msize(2) m(o) mlc(gs0) mfc("8 81 156") mlw(0.1))

		/// CA and LA
		(line q3070 year if rid==6 & sex==3 , lc(gs10) lw(0.35) lp("l"))
        (sc   q3070 year if rid==6 & sex==3 ,  msize(2) m(o) mlc(gs0) mfc("161 217 155") mlw(0.1))

		,
			graphregion(color(gs16)) ysize(12) xsize(16)

			xlab(2000 "2000" 2008 "2008" 2016 "2016", labs(5) tlc(gs0) labc(gs8) tstyle(major_notick) nogrid notick glc(gs16))
			xscale(noline lw(vthin) range(2000(1)2016) )
			xtitle(" ", size(3) color(gs0) margin(l=2 r=2 t=5 b=2))
			xmtick(2000(1)2016, notick)

			ylab(17(3)23
			,
			valuelabel labc(gs8) labs(5) tlc(gs0) tstyle(major_notick) nogrid notick glc(gs16) angle(0) format(%9.0f))
			yscale(noline lw(vthin) range(15(1)23))
			ytitle(" ", size(3) margin(l=2 r=5 t=2 b=2))
            ymtick(15(2)23, notick)

			legend(off size(3) position(12) ring(1) bm(t=1 b=4 l=5 r=0) colf cols(2)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2))
			order(2 4 6 8)
			lab(2 "Carib: women")
			lab(4 "Carib: men")
			lab(6 "Amer: women")
			lab(8 "Amer: men")
            )
            name(line_03)
            ;
#delimit cr

graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p151/04_TechDocs/premmort3_$S_DATE.png", replace width(4000)

** Calculations for slide
gen car_2000 = 22.00
gen car_2007 = 19.14
gen car_2016 = 19.42
gen car_compare1 = ((car_2007 - car_2000)/car_2000)*100
gen car_compare2 = ((car_2016 - car_2007)/car_2007)*100
gen lac_2000 = 20.60
gen lac_2007 = 18.07
gen lac_2016 = 15.77
gen lac_compare1 = ((lac_2007 - lac_2000)/lac_2000)*100
gen lac_compare2 = ((lac_2016 - lac_2007)/lac_2007)*100