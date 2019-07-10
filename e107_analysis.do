** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e107_analysis.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUL-2019
    //  algorithm task			    Inequality Metrics

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
    log using "`logpath'\e107_analysis", replace
** HEADER -----------------------------------------------------


** Load the COUNTRY-LEVEL 30q70 data
** By YEAR, by SEX
tempfile pmort
use "`datapath'/version01/2-working/file100_q3070_lac.dta", clear
drop w_* 
** Keep selected years
keep if year==2000 | year==2004 | year==2008 | year==2012 | year==2016
** Keep "WOmen and Men combined for use in Abstract"
**drop if sex==3 
** Shorten the premature mortality name
rename q3070 pm 
** Add iso3 label to unid
labmask unid, value(iso3)
** Recode sub-regions
drop if rid==4 
recode rid 2 3 = 2
label define rid_ 1 "caribbean" 2 "sca", modify
label values rid rid_
** Save temporary file 
save `pmort' , replace

** --------------------------------------------------------------------------
** We want to create country-level DIFFERENCE for FOUR stratifications
** --------------------------------------------------------------------------
** (sex=1) CARIBBEAN Women only
** (sex=2) CARIBBEAN Men only
** (sex=1) SCA Women only
** (sex=2) SCA Men only
** --------------------------------------------------------------------------
** We then combine (append) the FOUR sets of DIFFERENCES into a single file
** --------------------------------------------------------------------------

tempfile d_car1 d_car2 d_car3 d_sca1 d_sca2 d_sca3

** Minimum and Maximum at each tome point
** Caribbean



** SIMPLE INEQUALITY METRIC: DIFFRENCE
** CARIBBEAN
forval z = 1(1)3 {
	** Load the PM at birth dataset
	use `pmort', clear
	keep if rid==1 & sex==`z'
	reshape wide pm, i(iso3 unid sex) j(year)

	** Calculate RD for each 4-year time period
	foreach var in pm2000 pm2004 pm2008 pm2012 pm2016 {
		** BEST 30q70 in given sex-year group
		egen dh_`var' = max(`var')
		gen `var'_t1 = unid if `var'==dh_`var'
		egen dhc_`var' = min(`var'_t1)
		label values dhc_`var' unid
		
		** WORST rate (LE) in given sex-year group
		egen dl_`var' = min(`var')
		gen `var'_t2 = unid if `var'==dl_`var'
		egen dlc_`var' = min(`var'_t2)
		label values dlc_`var' unid
		** QDIF
		gen d_`var' = dh_`var' - dl_`var'
		drop `var'_t1 `var'_t2
		}
	keep if _n==1
	gen type`z'=`z'
	order dh_* dl_*

	forval x = 2004(4)2016 {
		** ABSOLUTE change in DIF between 2000 and each subsequent year
		gen d_c`x' = (-1) * (d_pm2000 - d_pm`x')
		** PERCENTAGE change in DIF between 2000 and each subsequent year 
		gen d_cp`x' = (d_c`x'/d_pm2000)*100
		}

	keep sex d_* dh_* dhc_* dl_* dlc_*
	reshape long d_pm d_c d_cp , i(sex) j(year)	
	rename d* *
	sort sex year
	label define sex_ 1 "Women" 2 "Men" 3 "Both" ,modify
	label values sex sex_
	list sex year _*
	gen rid = 1
	save `d_car`z'', replace
}

** SIMPLE INEQUALITY METRIC
** SOUTH and CENTRAL AMERICA (SCA)
forval z = 1(1)3 {
	** Load the LE at birth dataset
	use `pmort', clear
	keep if rid==2 & sex==`z'
	reshape wide pm, i(iso3 unid sex) j(year)

	** Calculate RD for each 4-year time period
	foreach var in pm2000 pm2004 pm2008 pm2012 pm2016 {
		** BEST 30q70 in given sex-year group
		egen dh_`var' = max(`var')
		gen `var'_t1 = unid if `var'==dh_`var'
		egen dhc_`var' = min(`var'_t1)
		label values dhc_`var' unid
		
		** WORST rate (LE) in given sex-year group
		egen dl_`var' = min(`var')
		gen `var'_t2 = unid if `var'==dl_`var'
		egen dlc_`var' = min(`var'_t2)
		label values dlc_`var' unid
		** rd
		gen d_`var' = dh_`var' - dl_`var'
		drop `var'_t1 `var'_t2
		}
	keep if _n==1
	gen type`z'=`z'
	order dh_* dl_*

	forval x = 2004(4)2016 {
		** ABSOLUTE change in DIF between 2000 and each subsequent year
		gen d_c`x' = (-1) * (d_pm2000 - d_pm`x')
		** PERCENTAGE change in DIF between 2000 and each subsequent year 
		gen d_cp`x' = (d_c`x'/d_pm2000)*100
		}

	keep sex d_* dh_* dhc_* dl_* dlc_*
	reshape long d_pm d_c d_cp , i(sex) j(year)	
	rename d* *
	sort sex year
	label define sex_ 1 "Women" 2 "Men" 3 "Both" ,modify
	label values sex sex_
	list sex year _*
	gen rid = 2
	save `d_sca`z'', replace
}

use `d_car1', clear
append using `d_car2'
append using `d_car3'
append using `d_sca1'
append using `d_sca2'
append using `d_sca3'
gen measure = 1
label define measure 1 "QDIF" 2 "QMD" 
label values measure measure
label define rid_ 1 "caribbean" 2 "sca", modify 
label values rid rid_
** And save the QDIF file for tabulation and graphing
order measure rid sex year 
label data "QDIF by SEX: (2000 to 2016)"
save "`datapath'/version01/2-working/d_dif.dta", replace 



** --------------------------------------------------------------------------
** We want to create country-level QMD for FOUR stratifications
** --------------------------------------------------------------------------
** (sex=1) CARIBBEAN Women only
** (sex=2) CARIBBEAN Men only
** (sex=1) SCA Women only
** (sex=2) SCA Men only
** --------------------------------------------------------------------------
** We then combine (append) the FOUR sets of DIFFERENCES into a single file
** --------------------------------------------------------------------------


tempfile cd_car1 cd_car2 cd_car3 cd_sca1 cd_sca2 cd_sca3

** COMPLEX INEQUALITY METRIC
** ABSOLUTE MEAN DIFFERENCE (QMD)
forval z = 1(1)3 {
	** Load the PM at birth dataset
	use `pmort', clear
	keep if rid==1 & sex==`z'
	reshape wide pm, i(iso3 unid sex) j(year)

	** Calculate QMD for each 4-year time period
	foreach var in pm2000 pm2004 pm2008 pm2012 pm2016 {
		gen J =  _N-1
		** Best rate in given sex-year group
		egen rref = max(`var')
		** Absolute difference between (group mean age) and (reference mean age)
		gen rdiff = abs(`var' - rref)
		** Sum the differences
		egen rsum = sum(rdiff)
		** QMD
		gen qmd_`var' = (rsum / J)
		format qmd_`var' %9.4f
		drop J rref rdiff  rsum 
		}
	keep if _n==1
	keep sex qmd_*
	order sex qmd_*

	forval x = 2000(4)2016 {
		** ABSOLUTE change in QMD between 2000 and each subsequent yr
		gen qmd_c`x' =  (-1) * (qmd_pm2000 - qmd_pm`x')
		** PERCENTAGE change in QMD between 2000 and each subsequent yr
		gen qmd_cp`x' = (qmd_c`x'/qmd_pm2000)*100
		}

	keep sex qmd_* 
	reshape long qmd_pm qmd_c qmd_cp , i(sex) j(year)	
	rename qmd* *
	sort sex year
	label define sex_ 1 "Women" 2 "Men" 3 "Both" ,modify
	label values sex sex_
	list sex year _*
	gen rid = 1
	dis "Filename will be = cd_car"`x'
	save `cd_car`z'', replace
}




** COMPLEX INEQUALITY METRIC
** ABSOLUTE MEAN DIFFERENCE (QMD)
forval z = 1(1)3 {
	** Load the PM at birth dataset
	use `pmort', clear
	keep if rid==2 & sex==`z'
	reshape wide pm, i(iso3 unid sex) j(year)

	** Calculate QMD for each 4-year time period
	foreach var in pm2000 pm2004 pm2008 pm2012 pm2016 {
		gen J =  _N-1
		** Best rate in given sex-year group
		egen rref = max(`var')
		** Absolute difference between (group mean age) and (reference mean age)
		gen rdiff = abs(`var' - rref)
		** Sum the differences
		egen rsum = sum(rdiff)
		** QMD
		gen qmd_`var' = (rsum / J)
		format qmd_`var' %9.4f
		drop J rref rdiff  rsum 
		}
	keep if _n==1
	keep sex qmd_*
	order sex qmd_*

	forval x = 2000(4)2016 {
		** ABSOLUTE change in QMD between 2000 and each subsequent yr
		gen qmd_c`x' =  (-1) * (qmd_pm2000 - qmd_pm`x')
		** PERCENTAGE change in QMD between 2000 and each subsequent yr
		gen qmd_cp`x' = (qmd_c`x'/qmd_pm2000)*100
		}

	keep sex qmd_* 
	reshape long qmd_pm qmd_c qmd_cp , i(sex) j(year)	
	rename qmd* *
	sort sex year
	label define sex_ 1 "Women" 2 "Men" 3 "Both" ,modify
	label values sex sex_
	list sex year _*
	gen rid = 2
	dis "Filename will be = cd_car"`x'
	save `cd_sca`z'', replace
}


use `cd_car1', clear
append using `cd_car2'
append using `cd_car3'
append using `cd_sca1'
append using `cd_sca2'
append using `cd_sca3'
gen measure = 2
label define measure 1 "QDIF" 2 "QMD" 
label values measure measure
label define rid_ 1 "caribbean" 2 "sca", modify 
label values rid rid_
** And save the QMD file for tabulation and graphing
order measure rid sex year 
label data "QMD by SEX: (2000 to 2016)"
save "`datapath'/version01/2-working/cd_dif.dta", replace 


** FINALLY
** Join the two datasets
use "`datapath'/version01/2-working/cd_dif.dta", replace 
append using "`datapath'/version01/2-working/d_dif.dta"

** Clean the MIN and MAX variables into just 2 VARS
gen 	low = l_pm2000 if year==2000
replace low = l_pm2004 if year==2004
replace low = l_pm2008 if year==2008
replace low = l_pm2012 if year==2012
replace low = l_pm2016 if year==2016
gen 	low_id = lc_pm2000 if year==2000
replace low_id = lc_pm2004 if year==2004
replace low_id = lc_pm2008 if year==2008
replace low_id = lc_pm2012 if year==2012
replace low_id = lc_pm2016 if year==2016
gen 	high = h_pm2000 if year==2000
replace high = h_pm2004 if year==2004
replace high = h_pm2008 if year==2008
replace high = h_pm2012 if year==2012
replace high = h_pm2016 if year==2016
gen 	high_id = hc_pm2000 if year==2000
replace high_id = hc_pm2004 if year==2004
replace high_id = hc_pm2008 if year==2008
replace high_id = hc_pm2012 if year==2012
replace high_id = hc_pm2016 if year==2016
label values low_id unid
label values high_id unid 
drop h_* hc_* l_* lc_*
