** HEADER -----------------------------------------------------
**  DO-FILE METADATA
    //  algorithm name			    e0042_dataprep.do
    //  project:				    Premature Mortality in the Caribbean (2000-2016)
    //  analysts:				    Ian HAMBLETON
    // 	date last modified	    	6-JUN-2019
    //  algorithm task			    Reading the FAO land use dataset

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
    log using "`logpath'\e004_dataprep", replace
** HEADER -----------------------------------------------------

** For SAP --> See e000_000.do

** DATA PREPARATION OF COUNTRY POPULATION (2000 to 2015)

** ------------------------------------------------------------
** FILE 4 - LAND USE
** ------------------------------------------------------------
** Extracted from FAO STAT (http://www.fao.org/faostat/en/?#data/RL)
** Download Date: 8-JUN-2019
** Inputs_LandUse_E_All_Data_(Normalized).xlsx
import excel using "`datapath'/version01/1-input/Inputs_LandUse_E_All_Data_(Normalized).xlsx", first

** Keep selected metrics (6601=LandArea, 6602=Agriculture)
keep if ItemCode==6601 | ItemCode==6602
rename ItemCode metric
label var metric "Metric type"
labmask metric, values(Item)
drop Item
order metric

rename AreaCode cid
label var cid "Country ID"
labmask cid, values(Area)
order cid, before(metric)

rename Year year
label var year "Year of metric estimate"
order year, after(metric)

rename Value value
label var value "Metric value"
order value, after(year)
rename Unit unit
order unit, after(value)
drop Element ElementCode YearCode

** Keep selected countries and regions

** Caribbean (5206)
** 5206	Caribbean	258	Anguilla
** 5206	Caribbean	8	Antigua and Barbuda
** 5206	Caribbean	22	Aruba
** 5206	Caribbean	12	Bahamas
** 5206	Caribbean	14	Barbados
** 5206	Caribbean	239	British Virgin Islands
** 5206	Caribbean	36	Cayman Islands
** 5206	Caribbean	49	Cuba
** 5206	Caribbean	279	CuraÃ§ao
** 5206	Caribbean	55	Dominica
** 5206	Caribbean	56	Dominican Republic
** 5206	Caribbean	86	Grenada
** 5206	Caribbean	87	Guadeloupe
** 5206	Caribbean   69	French Guiana
** 5206	Caribbean	93	Haiti
** 5206	Caribbean	109	Jamaica
** 5206	Caribbean	135	Martinique
** 5206	Caribbean	142	Montserrat
** 5206	Caribbean	151	Netherlands Antilles (former)
** 5206	Caribbean	177	Puerto Rico
** 5206	Caribbean	188	Saint Kitts and Nevis
** 5206	Caribbean	189	Saint Lucia
** 5206	Caribbean	191	Saint Vincent and the Grenadines
** 5206	Caribbean	281	Saint-Martin (French Part)
** 5206	Caribbean	280	Sint Maarten (Dutch Part)
** 5206 Caribbean   207 Suriname
** 5206	Caribbean	220	Trinidad and Tobago
** 5206	Caribbean	224	Turks and Caicos Islands
** 5206	Caribbean	240	United States Virgin Islands
gen rid = .
#delimit ;
    replace rid = 1 if  cid==258 | cid==8  |
                        cid==22  | cid==12 |
                        cid==14  | cid==239|
                        cid==36  | cid==49 |
                        cid==279 | cid==55 |
                        cid==56  | cid==69 |
                        cid==86  |
                        cid==87  | cid==93 |
                        cid==109 | cid==135|
                        cid==142 | cid==151|
                        cid==177 | cid==188 |
                        cid==189 | cid==191 |
                        cid==281 | cid==280 |
                        cid==220 | cid==224 |
                        cid==240 | cid==207;
#delimit cr
order rid, after(cid)

** Latin America (XXXX)
** XXXX	Latin America	9	Argentina
** XXXX	Latin America	19	Bolivia
** XXXX	Latin America	21	Brazil
** XXXX	Latin America	40	Chile
** XXXX	Latin America	44	Colombia
** XXXX	Latin America	48	Costa Rica
** XXXX	Latin America	58	Ecuador
** XXXX	Latin America	60	El Salvador
** XXXX	Latin America	89	Guatemala
** XXXX	Latin America	95	Honduras
** XXXX	Latin America	138	Mexico
** XXXX	Latin America	157	Nicaragua
** XXXX	Latin America	166	Panama
** XXXX	Latin America	169	Paraguay
** XXXX	Latin America	170	Peru
** XXXX	Latin America	234	Uruguay
** XXXX	Latin America	236	Venezuela
#delimit ;
    replace rid = 2 if  cid==9   | cid==19  |
                        cid==21  | cid==40  | 
                        cid==44  | cid==48  | 
                        cid==58  | cid==60  | 
                        cid==89  | cid==95  | 
                        cid==138 | cid==157 | 
                        cid==166 | cid==169 |
                        cid==170 | cid==234 |
                        cid==236 ;
#delimit cr
order rid, after(cid)
label var rid "Region code"
label define rid_ 1 "caribbean" 2 "latin america"
label values rid rid_
keep if rid==1 | rid==2
label data "Country and region land use data - from FAOSTAT (Oct-2018)"
save "`datapath'/version01/2-working/file05_landuse", replace

