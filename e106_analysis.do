** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e106_analysis.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    Regression work using 30q70 as outcome

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
    log using "`logpath'\e106_analysis", replace
** HEADER -----------------------------------------------------

** For SAP --> See e000_000.do

** -----------------------------------------------------
** REGRESSION of 30q70.
** Outcome variants
**  	Outcome 1: 30q70 in 2016
** 		Outcome 2: 30q70 between 2000 and 2016
**  
** -----------------------------------------------------

** Example DID
** 		use "`datapath'/version01/1-input/Panel101", clear
** 		gen time = (year>=1994) & !missing(year)
** 		gen treated = (country>4) & !missing(country)
** 		gen did = time*treated
** 		reg y time treated did, r
** 		reg y time##treated, r

tempfile wb_data
/*
use "`datapath'/version01/2-working/file06_worldbank", clear
rename countrycode iso3 
** Test on Barbados and Brazil
**keep if iso3=="BRB" | iso3=="BRA"
save `wb_data', replace 

** Join with outcome data, merging using iso3
use "`datapath'/version01/2-working/file100_q3070_lac.dta", clear 
replace w_pop = int(w_pop)
replace w_dths = int(w_dths)
**keep if iso3=="BRB" | iso3=="BRA"
drop if rid==4
merge m:m iso3 year using `wb_data'

** Time (pre and post 2008)
gen time = (year>=2008) & !missing(year)
** Treatment (this is region)
gen treg = (rid>1) & !missing(rid) 
drop if q3070==.


** WHO Progress Monitor
use "`datapath'/version01/2-working/file07_who_progress_monitor", clear
rename cid iso3 
egen tot_prog = rowtotal(t1 t2 t3 t4 t5a t5b t5c t5d t5e t6a t6b t6c t7a t7b t7c t7d t8 t9 t10)
replace tot_prog = (tot_prog/(19*2))*100

egen tot_target = rowtotal(t1 t2 t3)
replace tot_target = (tot_target/(3*2))*100

egen tot_policy = rowtotal(t4)
replace tot_policy = (tot_policy/(2))*100

egen tot_rf = rowtotal(t5a t5b t5c t5d t5e)
replace tot_rf = (tot_rf/(5*2))*100

egen tot_measure = rowtotal(t6a t6b t6c t7a t7b t7c t7d t8)
replace tot_measure = (tot_measure/(8*2))*100

egen tot_system = rowtotal(t9 t10)
replace tot_system = (tot_system/(2*2))*100

keep iso3 tot_*
tempfile prog_monitor
save `prog_monitor', replace

** Join with 30q70 
use "`datapath'/version01/2-working/file100_q3070_lac.dta", clear 
replace w_pop = int(w_pop)
replace w_dths = int(w_dths)
** Time (pre and post 2008)
gen time = (year>=2008) & !missing(year)
** Treatment (this is region)
gen treg = (rid>1) & !missing(rid) 
drop if q3070==.
merge m:1 iso3 using `prog_monitor' 
drop if rid==.
drop if rid==4
recode rid 2 3 = 6
label define rid_ 1 "caribbean" 6 "ca+sa",modify
label values rid rid_

** Longitudinal Model 
diff q3070 if sex==2 [fweight=w_pop], t(treg) p(time) cov(tot_prog) report
regress q3070 time treg treg#time tot_prog if sex==2

** Cross sectional models
** Mortality in 2016
keep if year==2000 | year==2008 | year==2016
keep iso3 rid unid sex year q3070 tot_* w_dths
reshape wide q3070 w_dths, i(iso3 sex tot_*) j(year)
rename q30702000 pm_2000
rename q30702008 pm_2008
rename q30702016 pm_2016

regress pm_2016 i.rid tot_prog if sex==2
regress pm_2016 i.rid tot_prog if sex==2
regress pm_2016 i.rid##c.tot_prog if sex==2
margins rid, at(tot_prog=(20(10)100))

gen pm_change1 = pm_2000 - pm_2016 
regress pm_change1 rid##c.tot_prog if sex==2
margins rid, at(tot_prog=(20(10)80))

*/

** HeatMap of WHO Progress metrics

use "`datapath'/version01/2-working/file07_who_progress_monitor", clear
rename cid iso3 
tempfile prog_monitor
save `prog_monitor', replace

** Join with 30q70 
use "`datapath'/version01/2-working/file100_q3070_lac.dta", clear 
drop if q3070==.
merge m:1 iso3 using `prog_monitor' 
drop if rid==.
drop if rid==4
recode rid 2 3 = 6
label define rid_ 1 "caribbean" 6 "ca+sa",modify
label values rid rid_
keep if year==2016 & sex==3
drop _merge

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

** Total score
egen tot_score = rowtotal(t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19)
gsort -tot_score iso3
gen iid = _n
order iid tot_score iso3 

drop w_* totpop pmort tmort sex year 
reshape long t, i(iid iso3 rid) j(monitor)

#delimit ;
	gr twoway
        /// Caribbean
        (sc iid monitor if rid==1 & t==0,  xaxis(1 2) msize(4) m(s) mlc(gs10) mfc("215 48 39") mlw(0.1))
        (sc iid monitor if rid==1 & t==1,  xaxis(1 2) msize(4) m(s) mlc(gs10) mfc("254 224 139") mlw(0.1))
        (sc iid monitor if rid==1 & t==2,  xaxis(1 2) msize(4) m(s) mlc(gs10) mfc("26 152 80") mlw(0.1))
        (sc iid monitor if rid==1 & t>=.,  xaxis(1 2) msize(4) m(s) mlc(gs10) mfc(gs10) mlw(0.1))

        /// Latin America - Caribbean
		(sc iid monitor if rid==6 & t==0,  xaxis(1 2) msize(4) m(s) mlc(gs10) mfc("215 48 39") mlw(0.1))
        (sc iid monitor if rid==6 & t==1,  xaxis(1 2) msize(4) m(s) mlc(gs10) mfc("254 224 139") mlw(0.1))
        (sc iid monitor if rid==6 & t==2,  xaxis(1 2) msize(4) m(s) mlc(gs10) mfc("26 152 80") mlw(0.1))
        (sc iid monitor if rid==6 & t>=.,  xaxis(1 2) msize(4) m(s) mlc(gs10) mfc(gs10) mlw(0.1))
		,
			graphregion(color(gs16)) ysize(14) xsize(11.5)

			xlab(1 "NCD targets"
				 2 "Mortality data" 					3 "Risk factor survey" 
				 4 "NCD policy" 						5 "Tobacco. Taxes / prices"
				 6 "Smoke-free policies"				7 "Tobacco. Warnings / plain packaging"
				 8 "Tobacco. Ad bans"					9 "Mass media campaigns"
				 10 "Alcohol. restrict availability"	11 "Alcohol. Ad bans"
				 12 "Alcohol. Taxes"					13 "Salt policies"
				 14 "Trans-fats policies"				15 "Restrict marketing to kids"
				 16 "Restrict breast milk marketing"	17 "Physical activity awareness"
				 18 "NCD management guidelines"			19 "AMI / stroke prevention"
			,
			axis(2) valuelabel labc(gs0) labs(1.75) tstyle(major_notick) nogrid glc(gs16) angle(45) format(%9.0f))
			xscale(axis(2) noline lw(vthin) range(1(1)23))
			xtitle("", axis(2) size(2.5) color(gs0) margin(l=2 r=2 t=5 b=2))
			xscale(off axis(1) noline lw(vthin))
			xtitle("", axis(1) size(2.5) color(gs0) margin(l=2 r=2 t=5 b=2))

			ylab(1 "Costa Rica" 	2 "Brazil" 
				 3 "Chile" 			4 "Colombia" 
				 5 "Argentina" 		6 "Ecuador" 
				 7 "{bf:Jamaica}"	8 "Panama"
				 9 "{bf:Suriname}"	10 "{bf:Dominican Republic}"
				 11 "Peru"			12 "Uruguay"
				 13 "Guatemala"		14 "Honduras"
				 15 "El Salvador"	16 "{bf:Trinidad & Tobago}"
				 17 "{bf:Barbados}"	18 "{bf:Cuba}"
				 19 "Paraguay"		20 "{bf:Guyana}"
				 21 "Venezuela"		22 "{bf:Bahamas}"
				 23 "{bf:Belize}"	24 "{bf:St.Lucia}"
				 25 "{bf:Antigua}"	26 "Bolivia"
				 27 "{bf:Grenada}"	28 "{bf:St.Vincent}"
				 29 "Nicaragua"		30 "{bf:Haiti}"
			,
			valuelabel labgap(2) labc(gs0) labs(1.8) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale( reverse lw(vthin) )
			ytitle("", size(2.5) margin(l=2 r=2 t=2 b=2))

            legend(off)
			name(heat_map)
            ;
#delimit cr




























/*
#delimit ;

gen yax3 = yax;
gen xax3 = xax;

replace yax3 = yax3+2 if yax3>=17 & yax3<=20;
replace yax3 = yax3+1.5 if yax3>=13 & yax3<=16;
replace yax3 = yax3+1 if yax3>=9 & yax3<=12;
replace yax3 = yax3+0.5 if yax3>=5 & yax3<=8;
replace xax3 = xax3+2 if xax3>=16 & xax3<=21;
replace xax3 = xax3+1.5 if xax3>=11 & xax3<=15;
replace xax3 = xax3+1 if xax3>=6 & xax3<=10;
replace xax3 = xax3+0.5 if xax3>=1 & xax3<=5;

	gr twoway 
		/// COUNTRIES (y-axis) and WHO PROGRESS MONITOR (x-axis)
		  (sc yax3 xax3 if dm_y1_n0==0 & wr==1, m(S) msize(*2.3) mfc(green*0.65) mlc(gs0) mlw(vthin))
		  (sc yax3 xax3 if dm_y1_n0==0 & wr==2, m(S) msize(*2.3) mfc(yellow) mlc(gs0) mlw(vthin))
		  (sc yax3 xax3 if dm_y1_n0==0 & wr==3, m(S) msize(*2.3) mfc(orange) mlc(gs0) mlw(vthin))
		  (sc yax3 xax3 if dm_y1_n0==0 & wr==4, m(S) msize(*2.3) mfc(red*0.65) mlc(gs0) mlw(vthin))
		  (sc yax3 xax3 if dm_y1_n0==0 & wr==5, m(S) msize(*2.3) mfc(red*1.25) mlc(gs0) mlw(vthin))
		  ,
			plotregion(c(gs16) ic(gs16) ilw(thin) lw(thin)) 		
			graphregion(color(gs16) ic(gs16) ilw(thin) lw(thin)) 
			ysize(5)

			/// SBP TEXT
			text(1 23 "120", place(e) size(small)) text(2 23 "140", place(e) size(small))
			text(3 23 "160", place(e) size(small)) text(4 23 "180", place(e) size(small))
			text(5.5 23 "120", place(e) size(small)) text(6.5 23 "140", place(e) size(small))
			text(7.5 23 "160", place(e) size(small)) text(8.5 23 "180", place(e) size(small))
			text(10 23 "120", place(e) size(small)) text(11 23 "140", place(e) size(small))
			text(12 23 "160", place(e) size(small)) text(13 23 "180", place(e) size(small))
			text(14.5 23 "120", place(e) size(small)) text(15.5 23 "140", place(e) size(small))
			text(16.5 23 "160", place(e) size(small)) text(17.5 23 "180", place(e) size(small))

			/// AGE TEXT
			text(2.5 -0.2 "40", place(e) size(small)) text(6.5 -0.2 "50", place(e) size(small))
			text(10.5 -0.2 "60", place(e) size(small)) text(14.5 -0.2 "70", place(e) size(small))

			/// CHOLESTEROL TEXT
			text(-0.25 1.2 "4", place(e) size(small)) text(-0.25 2.2 "5", place(e) size(small))
			text(-0.25 3.2 "6", place(e) size(small)) text(-0.25 4.2 "7", place(e) size(small)) text(-0.25 5.2 "8", place(e) size(small))

			text(-0.25 6.8 "4", place(e) size(small)) text(-0.25 7.8 "5", place(e) size(small))
			text(-0.25 8.8 "6", place(e) size(small)) text(-0.25 9.8 "7", place(e) size(small)) text(-0.25 10.8 "8", place(e) size(small))

			text(-0.25 12.2 "4", place(e) size(small)) text(-0.25 13.2 "5", place(e) size(small))
			text(-0.25 14.2 "6", place(e) size(small)) text(-0.25 15.2 "7", place(e) size(small)) text(-0.25 16.2 "8", place(e) size(small))

			text(-0.25 17.8 "4", place(e) size(small)) text(-0.25 18.8 "5", place(e) size(small))
			text(-0.25 19.8 "6", place(e) size(small)) text(-0.25 20.8 "7", place(e) size(small)) text(-0.25 21.8 "8", place(e) size(small))
			
			/// SBP title
			text(9.5 25.5 "SBP (mm Hg)",  place(c) orient(rvertical) size(medsmall))
			/// AGE title
			text(9.5 -1 "Age (years)",  place(c) orient(vertical) size(medsmall))
			/// CHOLESTEROL title
			text(-1.5 11 "Cholesterol (mmol/L)", place(c) orient(horizontal) size(medsmall))
			
			/// SMOKER text
			text(19 3.5 "Non-smoker", place(c) size(small))
			text(19 9 "Smoker", place(c) size(small))
			text(19 15 "Non-smoker", place(c) size(small))
			text(19 20.5 "Smoker", place(c) size(small))
			
			/// SEX text
			text(20.5 7 "Male", place(c) size(medsmall))
			text(20.5 17 "Female", place(c) size(medsmall))
			
			xscale(off lw(vthin) range(-2(0.5)26)) 
			yscale(off lw(vthin) range(-2(0.5)19)) 
			legend(off) 
			;
#delimit cr


