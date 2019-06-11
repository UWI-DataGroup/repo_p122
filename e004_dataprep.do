** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e003_dataprep.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    Reading the UN WPP population file

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
    log using "`logpath'\e003_dataprep", replace
** HEADER -----------------------------------------------------

** For SAP --> See e000_000.do

** DATA PREPARATION OF COUNTRY POPULATION (2000 to 2015)

** ------------------------------------------------------------
** FILE 4 - POPULATION
** ------------------------------------------------------------
** Extracted from UN World Population Prospects (https://population.un.org/wpp/Download/Standard/Population/)
** Download Date: 8-JUN-2019
import excel "`datapath'/version01/1-input/WPP2017_POP_F01_1_TOTAL_POPULATION_BOTH_SEXES.xlsx", clear sheet("ESTIMATES") cellrange(a18:bs290)

drop A B D  

** Country and region text" 
rename C un_country
label var un_country "UN country / region names"

** Country and region UN id 
rename E unid 
label var unid "UN unique id for countries and regions" 

** Population values in years (1950 to 2015) 
local k = 1950 
foreach var in F G H I J K L M N O P Q R S T U V W X Y Z AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS {
    rename `var' p`k'
    local k = `k' + 1
} 
tempfile pop_1950to2015
save `pop_1950to2015', replace 


** Population estimate for 2016
import excel "`datapath'/version01/1-input/WPP2017_POP_F01_1_TOTAL_POPULATION_BOTH_SEXES.xlsx", clear sheet("MEDIUM VARIANT") cellrange(a18:cm290)
drop A B D  
** Country and region text" 
rename C un_country
label var un_country "UN country / region names"
** Country and region UN id 
rename E unid 
label var unid "UN unieuq id for countries and regions" 
drop L-CM
** Population values in years (1950 to 2015) 
local k = 2015
foreach var in F G H I J K {
    rename `var' p`k'
    local k = `k' + 1
} 
drop p2015 
tempfile pop_2016to2020
save `pop_2016to2020', replace 

** Merge 2016-2021 into 1950-2015 
use `pop_1950to2015', clear 
merge 1:1 unid using  `pop_2016to2020'
drop _merge 

save "`datapath'/version01/2-working/file04_population_both.dta", replace

