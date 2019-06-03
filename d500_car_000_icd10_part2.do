** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d500_car_000_icd10_part2, replace

**  GENERAL DO-FILE COMMENTS
**  program:      d500_car_000_icd10_part2.do
**  project:      Preparing Caribbean mortality data
**  author:       HAMBLETON \ 13-SEP-2015
**  task:         Preparing Caribbean mortality rate dataset
 
** DO-FILE SET UP COMMANDS
version 14
clear all
macro drop _all
set more 1
set linesize 200

** Using the WHO Mortality Database
** And coding the 10-leading causes of deaths in the US for the year 2010

** Load data from a053_001b.do --> and re-prepare the Mortality DataBase, keeping ALL causes of death
** And from these causes we create the 10 top CODs

** Possible countries of interest
** (2010) Antigua & Barbuda
** (2030) Bahamas
** (2040) Barbados
** (2230) Grenada
** (2400) St.Lucia
** (2290) Jamaica
** (2420) St.Vincent
** (2300) Martinique 
** (2240) Guadeloupe
** (2290) Jamaica
** (2420) St.Vincent
** (2300) Martinique 
** (2240) Guadeloupe

** QUESTION: Do we need ICD9 dataset
** ANSWER: NO. Only Cuba used ICD9 in 2000, and Cuba is NOT part of this analysis

** ICD10 first
insheet using "C:\statistics\analysis\a000\15_who_md\versions\version04\data\Morticd10_part2\Morticd10_part2.txt", clear

** Country indicator
rename country cid

** Restricting to 20 Caribbean countries and immediately saving
** Subsequent cleaning will take place in next data preparation do file
** The countries ARE:
** 	2010 "Antigua and Barbuda"
** 	2025 "Aruba"
** 	2030 "Bahamas"
** 	2040 "Barbados"
** 	2045 "Belize"
** 	2150" Cuba"
** 	2170 "Dominican Republic"
** 	2210 "French Guiana"
** 	2230 "Grenada"
** 	2240 "Guadeloupe"
** 	2260 "Guyana"
** 	2270 "Haiti"
** 	2290 "Jamaica"
** 	2300 "Martinique"
** 	2380 "Puerto Rico"
** 	2400 "St.Lucia"
** 	2420 "St.Vincent & Grenadines"
** 	2430 "Suriname"
** 	2440 "Trinidad and Tobago"
** 	2455 "USVI"
#delimit ;
keep if cid==2010 | cid==2025 | cid==2030 |
		cid==2040 | cid==2045 | 
		cid==2150 | cid==2170 |
		cid==2210 | cid==2230 | cid==2240 | cid==2260 |
		cid==2270 | cid==2290 | cid==2300 | 
		cid==2380 | cid==2400 |
		cid==2420 | cid==2430 | cid==2440 |
		cid==2455 |
		
		cid==2005 | cid==2085 | cid==2330 | cid==2110 | 
		cid==2160 | cid==2170 | cid==2270 | cid==2320 |
		cid==2380 | cid==2385 | cid==2445
		;

** Extra countries NOT included;
** 2005		Anguilla;
** 2085		British Virgin Islands;
** 2330		Caribbean Netherlands (Netherland Antilles);
** 2110		Cayman Islands;
** 			Curacao (See Neth Antilles);
** 2160		Dominica;
** 2170		Dominican Republic;
** 2270		Haiti;
** 2320		Monserrat;
** 2380		Puerto Rico;
** 2385		St Kitts and Nevis;
** 			Sint Maarten (See Neth Antilles);
** 2445		Turks and Caicos;

label define cid	 	
						2010 "Antigua and Barbuda"
						2025 "Aruba"
						2030 "Bahamas"
						2040 "Barbados"
						2045 "Belize"
						2150" Cuba"
						2170 "Dominican Republic"
						2210 "French Guiana"
						2230 "Grenada"
						2240 "Guadeloupe"
						2260 "Guyana"
						2270 "Haiti"
						2290 "Jamaica"
						2300 "Martinique"
						2380 "Puerto Rico"
						2400 "St.Lucia"
						2420 "St.Vincent & Grenadines"
						2430 "Suriname"
						2440 "Trinidad and Tobago"
						2455 "USVI"
							2005	"Anguilla"
							2085	"British Virgin Islands"
							2330	"Netherland Antilles"
							2110	"Cayman Islands"
							2160	"Dominica"
							2320	"Monserrat"
							2385	"St Kitts and Nevis"
							2445	"Turks and Caicos"						
						, modify;
label values cid cid;						
#delimit cr


** Only interested in 1999 and later in the ICD10 dataset
keep if year>=1999 

** Administrative variables not required
drop admin1 subdiv

** Save the file
sort cid year
save "data\input\who_md\pop_aging\carib_icd10_part2", replace

