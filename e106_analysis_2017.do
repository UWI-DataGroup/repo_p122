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
    local outputpath "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122"

    ** Close any open log file and open a new log file
    capture log close
    log using "`logpath'\e106_analysis_2017", replace
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
use "`datapath'/version01/2-working/file07_who_progress_monitor_2017", clear
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



** HeatMap of WHO Progress metrics

use "`datapath'/version01/2-working/file07_who_progress_monitor_2017", clear
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

** Save the score file 
save "`datapath'/version01/2-working/progress2017", replace
/*
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
			graphregion(color(gs16)) ysize(17) xsize(11.5)

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
			axis(2) valuelabel labc(gs0) labs(1.75) tstyle(major_notick) nogrid glc(gs16) angle(45) format(%9.0f) labgap(4))
			xscale(axis(2) noline lw(vthin) range(1(1)23))
			xtitle("", axis(2) size(2.5) color(gs0) margin(l=2 r=2 t=5 b=2))
			xscale(off axis(1) noline lw(vthin))
			xtitle("", axis(1) size(2.5) color(gs0) margin(l=2 r=2 t=5 b=2))

			ylab(1 "Costa Rica" 	2 "Brazil" 
				 3 "Chile" 			4 "Colombia" 
				 5 "Argentina" 		6 "Ecuador" 
				 7 "{bf:Jamaica}"	8 "Panama"
				 9 "{bf:Suriname}"	10 "{bf:Dominican Republic}"
				 11 "Mexico"
				 12 "Peru"			13 "Uruguay"
				 14 "Guatemala"		15 "Honduras"
				 16 "El Salvador"	17 "{bf:Trinidad & Tobago}"
				 18 "{bf:Barbados}"	19 "{bf:Cuba}"
				 20 "Paraguay"		21 "{bf:Guyana}"
				 22 "Venezuela"		23 "{bf:Bahamas}"
				 24 "{bf:Belize}"	25 "{bf:St.Lucia}"
				 26 "{bf:Antigua}"	27 "Bolivia"
				 28 "{bf:Grenada}"	29 "{bf:St.Vincent}"
				 30 "Nicaragua"		31 "{bf:Haiti}"
			,
			valuelabel labgap(2) labc(gs0) labs(1.8) tstyle(major_notick) nogrid glc(gs16) angle(0) format(%9.0f))
			yscale( reverse noline lw(vthin) range(1(1)33))
			ytitle("", size(2.5) margin(l=2 r=2 t=2 b=2))

			/// PROGRESS INDICATOR 
			text(-0.3 10.5 "{bf: WHO Progress Indicator}",  size(2.5) color(gs0) just(center))
			
			/// WHO prgress score title
			text(33 21 "WHO" "Progress" "Score",  size(2) color(gs10) just(center))

			/// Costa Rica
			text(1 21 "33",  size(2) color(gs10) just(center))
			/// Brazil
			text(2 21 "30",  size(2) color(gs10) just(center))
			/// Chile
			text(3 21 "25",  size(2) color(gs10) just(center))
			/// Colombia
			text(4 21 "24",  size(2) color(gs10) just(center))
			/// Argentina
			text(5 21 "23",  size(2) color(gs10) just(center))
			/// Ecuador
			text(6 21 "21",  size(2) color(gs10) just(center))
			/// Jamaica
			text(7 21 "20",  size(2) color(gs10) just(center))
			/// Panama
			text(8 21 "20",  size(2) color(gs10) just(center))
			/// Suriname
			text(9 21 "20",  size(2) color(gs10) just(center))
			/// Dom Rep
			text(10 21 "18",  size(2) color(gs10) just(center))
			/// Mexico 
			text(11 21 "18",  size(2) color(gs10) just(center))
			/// Peru
			text(12 21 "18",  size(2) color(gs10) just(center))
			/// Uruguay 
			text(13 21 "18",  size(2) color(gs10) just(center))
			/// Guatemala
			text(14 21 "17",  size(2) color(gs10) just(center))
			/// Honduras
			text(15 21 "17",  size(2) color(gs10) just(center))
			/// El Salvador
			text(16 21 "17",  size(2) color(gs10) just(center))
			/// Trinidad
			text(17 21 "16",  size(2) color(gs10) just(center))
			/// Barbados
			text(18 21 "14",  size(2) color(gs10) just(center))
			/// Cuba
			text(19 21 "14",  size(2) color(gs10) just(center))
			/// Paraguay
			text(20 21 "14",  size(2) color(gs10) just(center))
			/// Guyana
			text(21 21 "13",  size(2) color(gs10) just(center))
			/// Venezuela
			text(22 21 "12",  size(2) color(gs10) just(center))
			/// Bahamas
			text(23 21 "11",  size(2) color(gs10) just(center))
			/// Belize
			text(24 21 "11",  size(2) color(gs10) just(center))
			/// St.Lucia
			text(25 21 "11", size(2) color(gs10) just(center))
			/// Antigua
			text(26 21 "10", size(2) color(gs10) just(center))
			/// Bolivia
			text(27 21 "10", size(2) color(gs10) just(center))
			/// Grenada
			text(28 21 "10",  size(2) color(gs10) just(center))
			/// Saint Vincent
			text(29 21 "10",  size(2) color(gs10) just(center))
			/// Nicaragua
			text(30 21 "8",  size(2) color(gs10) just(center))
			/// Haiti
			text(31 21 "2",  size(2) color(gs10) just(center))

			legend(size(2.25) position(7) ring(1) bm(t=1 b=1 l=1 r=0) colf cols(2) rowgap(0.5) colgap(0.5)
			region(fcolor(gs16) lw(vthin) margin(l=0 r=0 t=0 b=0))
			order(1 2 3 4)
			lab(1 "not implemented")
			lab(2 "partially implemented")
			lab(3 "fully implemented")
			lab(4 "not reported")
            )
			name(heat_map)
            ;
#delimit cr
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122\05_Outputs\HAMBLETON_Figure3.svg", as(svg) name("heat_map") replace
graph export "X:\The University of the West Indies\DataGroup - DG_Projects\PROJECT_p122\05_Outputs\HAMBLETON_Figure3.png", replace width(4000)




** PDF for FIGURE 3
    putpdf begin, pagesize(letter) font("Calibri Light", 12) margin(top,1cm) margin(bottom,1cm) margin(left,1cm) margin(right,1cm)
	* Fig title
    putpdf paragraph ,  font("Calibri Light", 12)
    putpdf text ("FIGURE 3. ") , bold
    putpdf text ("Heatmap depicting World Health Organization progress indicators for prevention and control of non-communicable disease ")
	* The figure
    putpdf table f2 = (1,1), width(80%) border(all,nil) halign(center)
    putpdf table f2(1,1)=image("`outputpath'/05_Outputs/HAMBLETON_Figure3.png")
    ** putpdf save 
    putpdf save "`outputpath'/05_Outputs/Health and Place/HAMBLETON_HealthPlace_200623_Figure3", replace
