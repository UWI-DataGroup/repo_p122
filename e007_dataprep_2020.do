** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e006_dataprep_2017.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    Reading WHO Progress Monitor data (2015 and 2017)

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
    log using "`logpath'\e006_dataprep_2017", replace
** HEADER -----------------------------------------------------

** For SAP --> See e000_000.do

** ------------------------------------------------------------
** FILE 7 - WHO Progress Monitor
** ------------------------------------------------------------
** Extracted manually from WHO reports (https://www.who.int/nmh/publications/ncd-progress-monitor-2017/en/)
** Download Date: 8-JUN-2019
import excel using "`datapath'/version01/1-input/NCD Progress monitor 2020.xlsx", clear sheet("2020") cellrange(a2:ax25)
sxpose, clear force

rename _var1 cid 
rename _var2 totpop
rename _var3 pmort 
rename _var4 tmort
rename _var5 pdeath

rename _var6 t1 
rename _var7 t2 
rename _var8 t3 
rename _var9 t4 
rename _var10 t5a 
rename _var11 t5b 
rename _var12 t5c 
rename _var13 t5d 
rename _var14 t5e  
rename _var15 t6a 
rename _var16 t6b 
rename _var17 t6c 
rename _var18 t7a
rename _var19 t7b 
rename _var20 t7c 
rename _var21 t7d 
rename _var22 t8 
rename _var23 t9 
rename _var24 t10 

** Variable formatting
drop if _n<=2

** Total country population 
rename totpop temp1
gen totpop  = real(temp1)
drop temp1
order totpop, after(cid)

** % deaths from NCDs  
rename pmort temp1
gen pmort  = real(temp1)
drop temp1
order pmort, after(totpop)

** Total # NCD deaths
rename tmort temp1
gen tmort  = real(temp1)
drop temp1
order tmort, after(pmort)

** Risk of premature death from NCD
rename pdeath temp1
gen pdeath = real(temp1)
drop temp1
order pdeath, after(tmort)

** Targets (categorization)
label define target_ 0 "not achieved" 1 "partially achieved" 2 "fully achieved" .a "DK" .b "NR"

foreach var in t1 t2 t3 t4 t5a t5b t5c t5d t5e t6a t6b t6c t7a t7b t7c t7d t8 t9 t10 {
    replace `var' = ".a" if `var'=="DK"  
    replace `var' = ".b" if `var'=="NR"  
    rename `var' temp1
    gen `var' = real(temp1)
    drop temp1
    label values `var' target_
}

label var cid "Country ID: ISO-3166"
label var totpop "Total country population"
label var pmort "% deaths from NCDs"
label var tmort "Total # NCD deaths"	
label var pdeath "Risk of premature death from NCD"	

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

label var t1 "National NCD targets"	
label var t2 "Mortality data"	
label var t3 "Risk factor surveys"	
label var t4 "National integrated NCD policy/strategy/action plan"
label var t5 "increased excise taxes and prices"	
label var t6 "smoke-free policies	"
label var t7 "large graphic health warnings/plain packaging"	
label var t8 "bans on advertising, promotion and sponsorship	"
label var t9 "mass media campaigns	"
label var t10 "restrictions on physical availability"	
label var t11 "advertising bans or comprehensive restrictions	"
label var t12 "increased excise taxes	"
label var t13 "salt/sodium policies"	
label var t14 "saturated fatty acids and trans-fats policies"	
label var t15 "marketing to children restrictions"	
label var t16 "marketing of breast-milk substitutes restrictions	"
label var t17 "Public education and awareness campaign on physical activity"	
label var t18 "Guidelines for management of cancer, CVD, diabetes and CRD"	
label var t19 "Drug therapy/counselling to prevent heart attacks and strokes"

** Gen total score in 2020
egen tscore2020 = rowtotal(t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19)
label data "WHO Progress monitor data"
save "`datapath'/version01/2-working/file07_who_progress_monitor_2020", replace




** COMBINED 2017 and 2020 file 
tempfile pm2017 pm2020
use "`datapath'/version01/2-working/file07_who_progress_monitor_2017", replace
foreach var in totpop pmort tmort pdeath t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 {
    rename `var' y17_`var'
}
save `pm2017' 


use "`datapath'/version01/2-working/file07_who_progress_monitor_2020", replace
foreach var in totpop pmort tmort pdeath t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 {
    rename `var' y20_`var'
}
save `pm2020'

merge 1:1 cid using `pm2017' 
drop _merge 

label data "WHO Progress monitor data"
save "`datapath'/version01/2-working/file07_who_progress_monitor_combined", replace
