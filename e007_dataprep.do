** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e006_dataprep.do
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
    log using "`logpath'\e006_dataprep", replace
** HEADER -----------------------------------------------------

** For SAP --> See e000_000.do

** ------------------------------------------------------------
** FILE 7 - WHO Progress Monitor
** ------------------------------------------------------------
** Extracted manually from WHO reports (https://www.who.int/nmh/publications/ncd-progress-monitor-2017/en/)
** Download Date: 8-JUN-2019
import excel using "`datapath'/version01/1-input/NCD Progress monitor.xlsx", clear sheet("2017") cellrange(a2:ax25)
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

label var t1 "National NCD targets"	
label var t2 "Mortality data"	
label var t3 "Risk factor surveys"	
label var t4 "National integrated NCD policy/strategy/action plan"
label var t5a "increased excise taxes and prices"	
label var t5b "smoke-free policies	"
label var t5c "large graphic health warnings/plain packaging"	
label var t5d "bans on advertising, promotion and sponsorship	"
label var t5e "mass media campaigns	"
label var t6a "restrictions on physical availability"	
label var t6b "advertising bans or comprehensive restrictions	"
label var t6c "increased excise taxes	"
label var t7a "salt/sodium policies"	
label var t7b "saturated fatty acids and trans-fats policies"	
label var t7c "marketing to children restrictions"	
label var t7d "marketing of breast-milk substitutes restrictions	"
label var t8 "Public education and awareness campaign on physical activity"	
label var t9 "Guidelines for management of cancer, CVD, diabetes and CRD"	
label var t10 "Drug therapy/counselling to prevent heart attacks and strokes"

label data "WHO Progress monitor data"
save "`datapath'/version01/2-working/file07_who_progress_monitor", replace
