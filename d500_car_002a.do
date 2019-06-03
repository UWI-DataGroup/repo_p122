* CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d004_car_002a, replace

**  GENERAL DO-FILE COMMENTS
**  program:      d004_car_002a.do
**  project:      HD mortality analysis 2
**  author:       HAMBLETON \ 28-SEP-2015
**  task:         Preparing Caribbean mortality files
 
** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200

** Cleaning Mortality Files
use "data\input\who_md\pop_aging\car_deaths_002_a", clear

** CID UN
** And drop N=8 countries with small numbers not used in this analysis
** 2005	"Anguilla"
** 2085	"British Virgin Islands"
** 2330	"Netherland Antilles"
** 2110	"Cayman Islands"
** 2160	"Dominica"
** 2320	"Monserrat"
** 2385	"St Kitts and Nevis"
** 2445	"Turks and Caicos"	
rename cidun t1
bysort cid: egen cidun = min(t1)
drop if cidun==.
drop t1

** Fill WHO/PAHO dataset indicator
** Currently missing for (women + men) cobined
rename md t1
bysort cid year: egen md = min(t1)
order md, after(t1)
label values md md
drop t1

** Order the variables
order cid cidun deaths year sex age11 ageunk cod md pop poptot 
label var cid "WHO country ID"
label var cidun "UN country ID"
label var deaths "Number of deaths by stratified group"
label var year "Year of death"
label var sex "Sex of death. 1=female, 2=male, 3=both"
label var age11 "Age in 11 age groups"
label var ageunk "Unknown age at death"
label var cod "Cause of death group"
label var md "Mortality database. 1=WHO database, 2=PAHO database"
label var pop "Population by country, year, sex, age"
label var poptot "Population by country, year, sex"

** Save the file
label data "Caribbean deaths (1990-2012) from WHO Mortality Database: dataset v1, 28-9-15"
save "data\input\who_md\pop_aging\caribbean_deaths_001", replace
saveold "data\input\who_md\pop_aging\caribbean_deaths_001_v13", version(13) replace
saveold "data\input\who_md\pop_aging\caribbean_deaths_001_v12", version(12) replace

