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


** JOINT CARIBBEAN / SOUTH AMERICA GRAPHIC WITH ELLIPSES
** 			lc("8 81 156 %75" "35 139 69 %75") lp("-" "-")


#delimit ;
	ellip pmort2016_3 tot_score if rid==1 | rid==6,
		
			by(rid) 
			overlay
			lc(gs16 "35 139 69 %75") lp("-" "-")

		    plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
		    graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(10) xsize(10)

			xlab(0(5)35, 
			tstyle(major_notick) labs(3) labc(gs16) nogrid format(%9.0f))
			xtitle(" ", size(3) color(gs10) margin(l=2 r=2 t=5 b=2)) 
			xscale(lw(vthin) noline range(5(5)35)) 
			
			ylab(10(5)35,
			labs(3) labc(gs16) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(lw(vthin) noline range(5(5)35)) 
			ytitle(" ", size(3) color(gs10) margin(l=2 r=5 t=2 b=2)) 

			yline(`mort_med', lc(gs7) lw(0.25))
			xline(`prog_med', lc(gs7) lw(0.25))

			title("")
			subtitle("")
			note("")

			legend(off size(2.5) nobox color(gs10) ring(0) position(1) bm(t=0 b=5 l=0 r=0) colf cols(1) order(3 4)
			region(fc(gs16) lc(gs16) lw(thin) margin(l=1 r=1 t=1 b=1)) 
			lab(3 "Caribbean") 
			lab(4 "South and Central America") 
			)

	plot(

		(sc pmort2016_3 tot_score if rid==6    ,  
					msize(3) m(O) mlc(gs0) mfc("35 139 69 %50") mlw(0.1))

	)
            name(graph1)
				;
#delimit cr 


#delimit ;
	ellip pmort2016_3 tot_score if rid==1 | rid==6,
		
			by(rid) 
			overlay
			lc("8 81 156 %75"  "35 139 69 %25") lp("-" "-")

		    plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin))
		    graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin))
			ysize(10) xsize(10)

			xlab(0(5)35, 
			tstyle(major_notick) labs(3) labc(gs16) nogrid format(%9.0f))
			xtitle(" ", size(3) color(gs10) margin(l=2 r=2 t=5 b=2)) 
			xscale(lw(vthin) noline range(5(5)35)) 
			
			ylab(10(5)35,
			labs(3) labc(gs16) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale(lw(vthin) noline range(5(5)35)) 
			ytitle(" ", size(3) color(gs10) margin(l=2 r=5 t=2 b=2)) 

			yline(`mort_med', lc(gs7) lw(0.25))
			xline(`prog_med', lc(gs7) lw(0.25))

			title("")
			subtitle("")
			note("")

			legend(off size(2.5) nobox color(gs10) ring(0) position(1) bm(t=0 b=5 l=0 r=0) colf cols(1) order(3 4)
			region(fc(gs16) lc(gs16) lw(thin) margin(l=1 r=1 t=1 b=1)) 
			lab(3 "Caribbean") 
			lab(4 "South and Central America") 
			)

	plot(
		(sc pmort2016_3 tot_score if rid==1    ,  
					msize(3) m(O) mlc(gs0) mfc("8 81 156 %50") mlw(0.1))
		(sc pmort2016_3 tot_score if rid==6    ,  
					msize(3) m(O) mlc(gs12) mfc("35 139 69 %10") mlw(0.1))

	)
            name(graph2)
				;
#delimit cr 



*/


** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\archive\statistics\analysis\a042\versions\version03\"
log using logfiles\p2014_05_le_disparity, replace

** Relative Risk
use data\hd_rr_sreg, clear
** Relative Difference
append using data\hd_rd_sreg
** Index of Disparity
append using data\hd_id_sreg
** Generalised Entropy Class
** Mean Logarithmic Deviation (MLD), Theil Index (T), Symmetric Theil Index (STI)
append using data\hd_ge_sreg
** Between Group Variation
append using data\hd_bgv_sreg

** Rescale MLD, T, STI (x10,000)
** foreach var in _le  {
** 	replace `var' = `var'*10000 if measure==4 | measure==5| measure==7
** 	}
		
** TABLE 3 Country-level e0 disparity (Caribbean only)
** Index + percentage change in consecutive 5-year time bands
** RR=1, RD=2, ID=3, MLD==4, T=5, BGV=6, STI=7
forval i = 1(1)7 {
	foreach var in _le  {
		qui replace `var' = round(`var', 0.01)
		}
	dis "INDEX = " `i'
	list year _le  if measure==`i' & type==3, noobs clean	
	}
	

** GRAPHICAL INTERPRETATION OF INDICES
** Interpreting the INDICES graphically
** replace _le = _le*10 if measure==1

** Show difference in UN-STANDARDIZED indices compared to 2005-10 (ie. NOW)
gen _nle1 = _le if year==1965
bysort measure type: egen _nle = min(_nle1)
gen _le2 = _le - _nle
drop _nle*


** BGV
sort measure type year
#delimit ;
	gr twoway 
          /// Northern America
		  ///(connect _le year if measure==6 & type==18, lp("-") lw(medthick) msize(medlarge) mc("49 163 84") lc("49 163 84"))
          /// Central America
		  ///(connect _le year if measure==6 & type==16, lp("-") lw(medthick) msize(medlarge) mc("35 139 69 %25") lc("35 139 69 %25"))
          /// Southern America
		  (connect _le year if measure==6 & type==17, lp("-") lw(medthick) msize(medlarge) mc("35 139 69 %75") lc("35 139 69 %75"))
          /// Caribbean
		  (connect _le year if measure==6 & type==15, lp("l") lw(medthick) msize(medlarge) mc("8 81 156 %75") lc("8 81 156 %75"))
		  ,
        plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
		graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) ysize(12) xsize(16)

			xlab(1965 "1970" 1985 "1990" 2005 "2010", labs(large) nogrid glc(gs14) angle(0))
			xscale(lw(vthin) ) xtitle("", margin(t=5) size(large)) 
			xmtick(1965(5)2010)

			ylab(0(10)50,labs(large) nogrid glc(gs14) angle(0) format(%9.0f))
			ytitle("", margin(r=3) size(large))
			yscale(lw(vthin) fill) 
			ymtick(0(5)50)
			
			legend(off size(large) position(2) bm(t=1 b=0 l=0 r=0) colf cols(1)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(4 1 2 3)
			lab(1 "Northern America") 
			lab(2 "Central America")
			lab(3 "Southern America")
			lab(4 "Caribbean")
			)
			name(graph3)
			;
#delimit cr


		 
		 


























/*

** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\archive\statistics\analysis\a042\versions\version03\"
log using logfiles\p2014_02_le_americas, replace

**  GENERAL DO-FILE COMMENTS
**  program:      p2014_02_le_americas.do
**  project:      LE summary dataset: analysis
**  author:       HAMBLETON \ 17-JUN-2013
**  task:         The analysis of country- and sex- level LE disparities 
 
** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200

** Load the prepared dataset
use "C:\archive\statistics\analysis\a000\18_un_esa\versions\version02\data\wpp_2012\03_mortality\prepared\wpp_le0_001", clear
append using "C:\archive\statistics\analysis\a000\18_un_esa\versions\version02\data\wpp_2012\03_mortality\prepared\wpp_le0_002"
sort ccode sex yearg




**----------------------------------------------------------------------------------
** FIGURE 1A. 
** LE at birth among women & men for major world religions.
**----------------------------------------------------------------------------------
** WORLD REGIONS
** LAC REGION
** Northern America = 	905
** Caribbean = 			915
** C.America = 			916
** S.America = 			931
** OTHER REGIONS
** World = 				900
** Africa = 			903
** Europe =				908
** Asia =				935
** Oceania =			909
keep if region==1
** Centering on the entire World
gen le2 = le if ccode==900
bysort sex yearg: egen le3 = min(le2)
gen le_cc = le - le3
drop le2 le3

** AMERICAS 
** Colour gradation using http://colorbrewer2.org/
** 4-GRADATIONS
** 0 109 44
** 49 163 84
** 116 196 118
** 186 228 179





**----------------------------------------------------------------------------------
** GRAPHIC ONE (F) --> WORLD HORIZONTAL, CARIBBEAN ENHANCED
**----------------------------------------------------------------------------------
keep if sex==3
#delimit ;
	gr twoway 
		  /// Northern America		  
          ///(connect le_cc yearg if ccode==905 & yearg>=4 & yearg<=12, lp("l") lw(medthick) m(none) lc(gs14))
		  /// Central America		  
          (connect le_cc yearg if ccode==916 & yearg>=4 & yearg<=12, lp("l") lw(medthick) m(none) lc("35 139 69 %75"))
		  /// South America		  
          (connect le_cc yearg if ccode==931 & yearg>=4 & yearg<=12, lp("l") lw(medthick) m(none) lc("35 139 69 %50"))
		  /// Caribbean		  
          (connect le_cc yearg if ccode==915 & yearg>=4 & yearg<=12, lp("l") lw(1.5) m(smcircle) mc("8 81 156 %75") lc("8 81 156 %25"))
          /// World
		  (connect le_cc yearg if ccode==900 & yearg>=4 & yearg<=12, lp("-#-#") lw(thick) m(none) lc(gs2) )
		  ,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
			ysize(16) xsize(12)


			xlab(4 "1970" 8 "1990" 12 "2010", labs(vlarge) nogrid glc(gs14) angle(0))
			xscale(lw(vthin) range(3(1)13)) xtitle("", margin(t=3) size(vlarge)) 
			xmtick(4(2)12)

			ylab(0(5)10,labs(vlarge) nogrid glc(gs14) angle(0) format(%9.0f))
			ytitle(" ", margin(r=3) size(vlarge))
			yscale(lw(vthin) fill) 
			ymtick(-2(1)10)
			
			text(5 4 "Caribbean", size(large) col("8 81 156 %75") place(e))
			
			legend(off size(small) position(3) bm(t=1 b=0 l=0 r=0) colf cols(3)
			region(fcolor(gs16) lw(vthin) margin(l=2 r=2 t=2 b=2)) order(9 8 5 6 7 1 2 3 4 )
			lab(9 "World") 
			lab(1 "Africa")
			lab(2 "Europe")
			lab(3 "Oceania")
			lab(4 "Asia")
			lab(5 "Northern America")
			lab(6 "Central America")
			lab(7 "South America")
			lab(8 "Caribbean")
			)
            name(graph3)
			;
#delimit cr 

