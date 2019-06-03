** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version04"
log using logfiles\a054_md, replace

**  GENERAL DO-FILE COMMENTS
**  program:      	a054_md.do
**  project:      	LE summary dataset: analysis
**  author:       	HAMBLETON \ 11-NOV-2014
**  task:         	AMD for mortality rates in the Caribbean 
 
** DO-FILE SET UP COMMANDS
version 13
clear all
macro drop _all
set more 1
set linesize 200




** ************************************************************
** CARIBBEAN
** UNADJUSTED
** ************************************************************
use "data\result\car_003\caribbean_data", clear
** Drop regional average
drop if cid==1000
** Reshape to long for time points (2000 and 2009)
reshape long rateadj, i(cid cod sex) j(year)


** RECAST of rate variables to type double
replace rateadj = round(rateadj, 0.01)
bysort cod sex year: egen rmin = min(rateadj)
bysort cod sex year: egen rmax = max(rateadj)
recast double rmin
recast double rmax
replace rmin = round(rmin, 0.01)
replace rmax = round(rmax, 0.01)

** RESHAPE TO WIDE for calculation of RR / RD and changes between 2000 and 2009
keep cod cid year sex rateadj
reshape wide rateadj, i(cod cid sex) j(year)

** Calculate ABSOLUTE MEAN DIFFERENCE and the INDEX OF DISPARITY for each year
forval x = 2000(9)2009 {
	bysort cod sex: gen J`x' =  _N
	** Best rate in given COD-YEAR group
	bysort cod sex: egen rref`x' = min(rateadj`x')
	gen rdiff`x' = abs(rref`x' - rateadj`x')
	bysort cod sex: egen md`x' = sum(rdiff`x'/J`x')
	** Average rate in given COD-YEAR group
	bysort cod sex: egen aref`x' = mean(rateadj`x')
	gen adiff`x' = abs(aref`x' - rateadj`x')
	bysort cod sex: egen ad`x' = sum(adiff`x'/J`x')

	** Index of Disparity (Average Rate)
	gen id`x' = ( (md`x') / rref`x') * 100
	format id`x' %9.4f

	drop J`x' rref`x' aref`x' rdiff`x' adiff`x'
	}
** Change and percentage change in AD (average rate) between 2000 and 2009
gen adc = ad2009 - ad2000
gen adcp = (adc/ad2000)*100
** Change and percentage change in MD (best rate) between 2000 and 2009
gen mdc = md2009 - md2000
gen mdcp = (mdc/md2000)*100
** Change and percentage change in IDisp (Best rate) between 2000 and 2009
gen idc = id2009 - id2000
gen idcp = (idc/id2000)*100
** Change and percentage change in Mortality Rate between 2000 and 2009
gen mrc = rateadj2009 - rateadj2000
gen mrcp = (mrc/rateadj2000)*100



preserve
	egen tag = tag(cod sex)
	keep if tag==1
	gen drop = 0
	keep cod sex drop ad* md* id*
	order cod sex drop ad* md* id* 
	table cod sex, c(mean md2000 mean md2009 mean mdc mean mdcp) format(%9.1f)
	table cod sex, c(mean id2000 mean id2009 mean idc mean idcp) format(%9.1f)
	save "data\result\sensitivity_md\full_car", replace
restore

** Data for SUPPLEMENTARY (GRAPHICAL) TABLE - summary of MR % change, absolute disparity % change, and relative disparity % change
table cod , by(sex) c(mean mrcp) format(%9.0f)
table cod , by(sex) c(mean mdcp ) format(%9.0f)
table cod , by(sex) c(mean idcp) format(%9.0f)




** ************************************************************
** CARIBBEAN
** QUALITY ADJUSTED
** ************************************************************
use "data\result_qa\car_003\caribbean_data", clear
** Drop regional average
drop if cid==1000
** Reshape to long for time points (2000 and 2009)
reshape long rateadj, i(cid cod sex) j(year)


** RECAST of rate variables to type double
replace rateadj = round(rateadj, 0.01)
bysort cod sex year: egen rmin = min(rateadj)
bysort cod sex year: egen rmax = max(rateadj)
recast double rmin
recast double rmax
replace rmin = round(rmin, 0.01)
replace rmax = round(rmax, 0.01)

** RESHAPE TO WIDE for calculation of RR / RD and changes between 2000 and 2009
keep cod cid year sex rateadj
reshape wide rateadj, i(cod cid sex) j(year)

** Calculate ABSOLUTE MEAN DIFFERENCE and the INDEX OF DISPARITY for each year
forval x = 2000(9)2009 {
	bysort cod sex: gen J`x' =  _N
	** Best rate in given COD-YEAR group
	bysort cod sex: egen rref`x' = min(rateadj`x')
	gen rdiff`x' = abs(rref`x' - rateadj`x')
	bysort cod sex: egen md`x' = sum(rdiff`x'/J`x')
	** Average rate in given COD-YEAR group
	bysort cod sex: egen aref`x' = mean(rateadj`x')
	gen adiff`x' = abs(aref`x' - rateadj`x')
	bysort cod sex: egen ad`x' = sum(adiff`x'/J`x')

	** Index of Disparity
	gen id`x' = ( (md`x') / rref`x') * 100
	format id`x' %9.4f
	drop J`x' rref`x' aref`x' rdiff`x' adiff`x'
	}
** Change and percentage change in AD (average rate) between 2000 and 2009
gen adc = ad2009 - ad2000
gen adcp = (adc/ad2000)*100
** Change and percentage change in MD (best rate) between 2000 and 2009
gen mdc = md2009 - md2000
gen mdcp = (mdc/md2000)*100
** Change and percentage change in IDisp between 2000 and 2009
gen idc = id2009 - id2000
gen idcp = (idc/id2000)*100
** Change and percentage change in Mortality Rate between 2000 and 2009
gen mrc = rateadj2009 - rateadj2000
gen mrcp = (mrc/rateadj2000)*100



preserve
	egen tag = tag(cod sex)
	keep if tag==1
	gen drop = 0
	keep cod sex drop ad* md* id*
	order cod sex drop ad* md* id* 
	table cod sex, c(mean md2000 mean md2009 mean mdc mean mdcp) format(%9.1f)
	table cod sex, c(mean id2000 mean id2009 mean idc mean idcp) format(%9.1f)
	save "data\result\sensitivity_md\full_car", replace
restore

** Data for SUPPLEMENTARY (GRAPHICAL) TABLE - summary of MR % change, absolute disparity % change, and relative disparity % change
table cod , by(sex) c(mean mrcp) format(%9.0f)
table cod , by(sex) c(mean mdcp ) format(%9.0f)
table cod , by(sex) c(mean idcp) format(%9.0f)







** ************************************************************
** US DATA (ALL RACES)
** ************************************************************** 
use "data\result\us_001\us_data", clear
keep if race==3
drop if race==.
rename measure cod
** Keep All-cause and top 6 causes
keep if cod>1
** Reshape to long
keep state cod sex i2000 i2009
reshape long i, i(state cod sex) j(year)
rename i rateadj
rename state cid 

** RECAST of rate variables to type double
replace rateadj = round(rateadj, 0.01)
bysort cod sex year: egen rmin = min(rateadj)
bysort cod sex year: egen rmax = max(rateadj)
recast double rmin
recast double rmax
replace rmin = round(rmin, 0.01)
replace rmax = round(rmax, 0.01)

** RESHAPE TO WIDE for calculation of RR / RD and changes between 2000 and 2009
keep cod cid year sex rateadj
reshape wide rateadj, i(cod cid sex) j(year)

** Calculate ABSOLUTE MEAN DIFFERENCE and the INDEX OF DISPARITY for each year
forval x = 2000(9)2009 {
	bysort cod sex: gen J`x' =  _N
	** Best rate in given COD-YEAR group
	bysort cod sex: egen rref`x' = min(rateadj`x')
	gen rdiff`x' = abs(rref`x' - rateadj`x')
	bysort cod sex: egen md`x' = sum(rdiff`x'/J`x')
	** Average rate in given COD-YEAR group
	bysort cod sex: egen aref`x' = mean(rateadj`x')
	gen adiff`x' = abs(aref`x' - rateadj`x')
	bysort cod sex: egen ad`x' = sum(adiff`x'/J`x')

	** Index of Disparity
	gen id`x' = ( (md`x') / rref`x') * 100
	format id`x' %9.4f
	drop J`x' rref`x' aref`x' rdiff`x' adiff`x'
	}
** Change and percentage change in AD (average rate) between 2000 and 2009
gen adc = ad2009 - ad2000
gen adcp = (adc/ad2000)*100
** Change and percentage change in MD (best rate) between 2000 and 2009
gen mdc = md2009 - md2000
gen mdcp = (mdc/md2000)*100
** Change and percentage change in IDisp between 2000 and 2009
gen idc = id2009 - id2000
gen idcp = (idc/id2000)*100
** Change and percentage change in Mortality Rate between 2000 and 2009
gen mrc = rateadj2009 - rateadj2000
gen mrcp = (mrc/rateadj2000)*100



preserve
	egen tag = tag(cod sex)
	keep if tag==1
	gen drop = 0
	keep cod sex drop ad* md* id*
	order cod sex drop ad* md* id* 
	table cod sex, c(mean md2000 mean md2009 mean mdc mean mdcp) format(%9.1f)
	table cod sex, c(mean id2000 mean id2009 mean idc mean idcp) format(%9.1f)
	save "data\result\sensitivity_md\full_us", replace
restore

** Data for SUPPLEMENTARY (GRAPHICAL) TABLE - summary of MR % change, absolute disparity % change, and relative disparity % change
table cod , by(sex) c(mean mrcp) format(%9.0f)
table cod , by(sex) c(mean mdcp ) format(%9.0f)
table cod , by(sex) c(mean idcp) format(%9.0f)







** ************************************************************
** US DATA (AFRICAN AMERICAN)
** ************************************************************** 
use "data\result\us_001\us_data", clear
keep if race==1
drop if race==.
rename measure cod
** Keep All-cause and top 6 causes
keep if cod>1
** Reshape to long
keep state cod sex i2000 i2009
reshape long i, i(state cod sex) j(year)
rename i rateadj
rename state cid 

** RECAST of rate variables to type double
replace rateadj = round(rateadj, 0.01)
bysort cod sex year: egen rmin = min(rateadj)
bysort cod sex year: egen rmax = max(rateadj)
recast double rmin
recast double rmax
replace rmin = round(rmin, 0.01)
replace rmax = round(rmax, 0.01)

** RESHAPE TO WIDE for calculation of RR / RD and changes between 2000 and 2009
keep cod cid year sex rateadj
reshape wide rateadj, i(cod cid sex) j(year)

** Calculate ABSOLUTE MEAN DIFFERENCE and the INDEX OF DISPARITY for each year
forval x = 2000(9)2009 {
	bysort cod sex: gen J`x' =  _N
	** Best rate in given COD-YEAR group
	bysort cod sex: egen rref`x' = min(rateadj`x')
	gen rdiff`x' = abs(rref`x' - rateadj`x')
	bysort cod sex: egen md`x' = sum(rdiff`x'/J`x')
	** Average rate in given COD-YEAR group
	bysort cod sex: egen aref`x' = mean(rateadj`x')
	gen adiff`x' = abs(aref`x' - rateadj`x')
	bysort cod sex: egen ad`x' = sum(adiff`x'/J`x')

	** Index of Disparity
	gen id`x' = ( (md`x') / rref`x') * 100
	format id`x' %9.4f
	drop J`x' rref`x' aref`x' rdiff`x' adiff`x'
	}
** Change and percentage change in AD (average rate) between 2000 and 2009
gen adc = ad2009 - ad2000
gen adcp = (adc/ad2000)*100
** Change and percentage change in MD (best rate) between 2000 and 2009
gen mdc = md2009 - md2000
gen mdcp = (mdc/md2000)*100
** Change and percentage change in IDisp between 2000 and 2009
gen idc = id2009 - id2000
gen idcp = (idc/id2000)*100
** Change and percentage change in Mortality Rate between 2000 and 2009
gen mrc = rateadj2009 - rateadj2000
gen mrcp = (mrc/rateadj2000)*100



preserve
	egen tag = tag(cod sex)
	keep if tag==1
	gen drop = 0
	keep cod sex drop ad* md* id*
	order cod sex drop ad* md* id* 
	table cod sex, c(mean md2000 mean md2009 mean mdc mean mdcp) format(%9.1f)
	table cod sex, c(mean id2000 mean id2009 mean idc mean idcp) format(%9.1f)
	save "data\result\sensitivity_md\full_us", replace
restore

** Data for SUPPLEMENTARY (GRAPHICAL) TABLE - summary of MR % change, absolute disparity % change, and relative disparity % change
table cod , by(sex) c(mean mrcp) format(%9.0f)
table cod , by(sex) c(mean mdcp ) format(%9.0f)
table cod , by(sex) c(mean idcp) format(%9.0f)



** ************************************************************
** US DATA (WHITE)
** ************************************************************** 
use "data\result\us_001\us_data", clear
keep if race==2
drop if race==.
rename measure cod
** Keep All-cause and top 6 causes
keep if cod>1
** Reshape to long
keep state cod sex i2000 i2009
reshape long i, i(state cod sex) j(year)
rename i rateadj
rename state cid 

** RECAST of rate variables to type double
replace rateadj = round(rateadj, 0.01)
bysort cod sex year: egen rmin = min(rateadj)
bysort cod sex year: egen rmax = max(rateadj)
recast double rmin
recast double rmax
replace rmin = round(rmin, 0.01)
replace rmax = round(rmax, 0.01)

** RESHAPE TO WIDE for calculation of RR / RD and changes between 2000 and 2009
keep cod cid year sex rateadj
reshape wide rateadj, i(cod cid sex) j(year)

** Calculate ABSOLUTE MEAN DIFFERENCE and the INDEX OF DISPARITY for each year
forval x = 2000(9)2009 {
	bysort cod sex: gen J`x' =  _N
	** Best rate in given COD-YEAR group
	bysort cod sex: egen rref`x' = min(rateadj`x')
	gen rdiff`x' = abs(rref`x' - rateadj`x')
	bysort cod sex: egen md`x' = sum(rdiff`x'/J`x')
	** Average rate in given COD-YEAR group
	bysort cod sex: egen aref`x' = mean(rateadj`x')
	gen adiff`x' = abs(aref`x' - rateadj`x')
	bysort cod sex: egen ad`x' = sum(adiff`x'/J`x')

	** Index of Disparity
	gen id`x' = ( (md`x') / rref`x') * 100
	format id`x' %9.4f
	drop J`x' rref`x' aref`x' rdiff`x' adiff`x'
	}
** Change and percentage change in AD (average rate) between 2000 and 2009
gen adc = ad2009 - ad2000
gen adcp = (adc/ad2000)*100
** Change and percentage change in MD (best rate) between 2000 and 2009
gen mdc = md2009 - md2000
gen mdcp = (mdc/md2000)*100
** Change and percentage change in IDisp between 2000 and 2009
gen idc = id2009 - id2000
gen idcp = (idc/id2000)*100
** Change and percentage change in Mortality Rate between 2000 and 2009
gen mrc = rateadj2009 - rateadj2000
gen mrcp = (mrc/rateadj2000)*100



preserve
	egen tag = tag(cod sex)
	keep if tag==1
	gen drop = 0
	keep cod sex drop ad* md* id*
	order cod sex drop ad* md* id* 
	table cod sex, c(mean md2000 mean md2009 mean mdc mean mdcp) format(%9.1f)
	table cod sex, c(mean id2000 mean id2009 mean idc mean idcp) format(%9.1f)
	save "data\result\sensitivity_md\full_us", replace
restore

** Data for SUPPLEMENTARY (GRAPHICAL) TABLE - summary of MR % change, absolute disparity % change, and relative disparity % change
table cod , by(sex) c(mean mrcp) format(%9.0f)
table cod , by(sex) c(mean mdcp ) format(%9.0f)
table cod , by(sex) c(mean idcp) format(%9.0f)

