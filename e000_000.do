
** CLOSE ANY OPEN LOG FILE AND OPEN A NEW LOG FILE
capture log close
cd "C:\statistics\analysis\a054\versions\version05"
log using logfiles\d000_000, replace

**  GENERAL DO-FILE COMMENTS
**  program:      e000_000.do
**  project:      Premature mortality in Caribbean and US
**  author:       HAMBLETON \ 6-JUN-2018
**  task:         
 
** DO-FILE SET UP COMMANDS
version 15
clear all
macro drop _all
set more 1
set linesize 200

**----------------------------------------------------------------
** ARTICLE OUTLINE
** Non-communicable disease mortality in Latin America and the Caribbean: are Small Island Developing States a forgotten/lost global community?
**
** DATASET: WHO mortality estimates (2000-2016)
**
** BACKGROUND
** The WHO in 2011 introduced a global ambition of a 25% reduction in NCD mortality by 2025 - "25 by 25" 
** This was updated by SDG goal 3.4, suggesting a one-third NCD mortality reduction by 2030 
** These two goals have underpinned recent movements towards tackling the lifestyle contributors to the NCD burden
**
** Systematic global monitoring is gathering pace, with WHO and associated groups providing regular updates of
** country, regional, and global progress. These monitoring efforts are hugely beneficial, provising a wealth of 
** comparable data for assessing high-level progress by member States.
**  
** The global monitoring infrastructure relies fundamentally on functioning reporting structures at the country level. 
** Available data are gathered, quality controlled, analysed, and publically reported, often via peer-reviewed literature, 
** grey literature, or data repositories.  
**
** Although countries are then able to review and interpret published results relevant to their situation, the
** monitoring infrastructure has not been systematically extended to helping individual countries with progress interpretation
** and adaptation. Localized help, when available, is rightly focussed on the most needy, with need regularly guided 
** by World Bank income group designation or UN LDC classification. More recently, there has been a growing recognition that
** SIDS represent a third vulnerable country grouping. SIDS are often classified as high or middle income, but nevertheless 
** have limited absolute resources to systematically tackle the complexities of the NCD burden.  
** 
** The Caribbean is made up of x SIDS. Describe briefly the Caribbean structure. Geographically, the Caribbean is located 
** in the region of the Americas, and is generally subsumed into "Latin America and the Caribbean" for the purposes of 
** succinct regional reporting. The combined population of the Caribbean SIDS is X, compared to Y in Latin America. 
** The Caribbean SIDS therefore contribute little information to a LAC regional grouping, in effect becoming
** a hidden global community. 
**
** The Caribbean in 2007 was at the forefront of the global NCD awareness movement - Port of Spain (2007) 
** Since that time... efforts to systematically tackle the epidemic have been ongoing, but patchy.
** Efforts have been influenced by the economic reality of a region struggling with recession, unemployment, debt
** And it has been a struggle interupted by weather events causing temporary but devastating damage to whole country  
** healthcare infrastructures.
**
** AIM OF STUDY
** In this study, we review the recent progress towards the WHO and SDG NCD mortality targets in Latin American 
** and the Caribbean, disaggreating by country to allow a re-focus on the Caribbean SIDS. 
**
** (A) 	We report the probability of dying from 4 NCDs between 30 and 70 years of age (30q70) in 2000 and in 2016. 
**		- we focus on the 15-year change between 2000 and 2015
**		- we focus on sub-regional differences (LA vs. Caribbean)
**		- we focus on formal measures of absolute and relative disparity between sub-regions / countries 
**
** (B) 	We then explore the association of (30q70) with three groups of structural variables
**		- country structural variables (country size, pop size, economic wellbeing, social wellbeing, vulnerability)
**		- healthcare structural variables (per capita healthcare spending, # healthcare professionals etc)
**		- health and healthcare response variables (See WHO Progress Monitor 2017)  
**
** ANALYSIS DETAILS
**
** TABLE 1. LAC Countries and sub-Regions in 2016
** Table to introduce the XX countries by sub-region
** METRICS
**      - Population
**      - Percentage of world population
**      - Number of NCD deaths
**      - Percentage of world NCD deaths
**      - 30q70 in 2016
**      - 30q70 change since 2000
**
**
** FIGURE 1. Regional EquiPlot
** Figure to show the absolute change in 30q70 between 2000 and 2016
** STRATIFIED by
**      - 1st. Women, Men., Both
**      - 2nd. Year (2000, annually, 2016)
**      - 3rd. LAC (?), LA and Caribbean
** 
** TABLE 2. The association of country characteristics on 30q70
** OUTCOME 1: 30q70 in 2016 (latest value)
** OUTCOME 2: Change in 30q70 (Outcome is 30q70 in 2016, adjusted for 30q70 in 2000)
** PREDICTORS
** Group 1. Country structure (collect 2000 to 2016 when possible)
**          - Land mass
**          - Population size
**          - Absolute GDP / GNI
**          - GNI per capita
**          - HDI
**          - World Bank categorization
**          - SIDS classification
** Group 2. Country vulnerability (collect longitudinal as possible)
**          - economic vulnerability
**          - environmental vulnerability ??
**          - food import ratio
** Group 3. Healthcare vulnerability
**          - % healthcare spending (of government budget)
**          - # healthcare professionals per capita
**          - ???
** Group 4. NCD Progress monitoring variables
**          - NCD tartgets set (3 targets, 3 indicators)
**          - Multisectoral policies (1 target, 1 indicator)
**          - Reduce NCD risk factors (4 targets, 13 indicators)
**          - Strengthen heakth systems (2 targets, 2 indicators)
**          - Summary count of targets met

** Risk of NCD premature death
** https://apps.who.int/gho/data/view.main.2485



** DO FILE DESCRIPTION 
**
** e001_dataprep.do 
** ------------------------------------------------------------
** FILE 1 - PREMATURE MORTALITY FROM NCDs (30q70)
** ------------------------------------------------------------
** UNIQUE IS: ISO-3 
** Extracted from NCD CountDown (http://www.ncdcountdown.org/data-downloads-ncd4.html)
** Download Date: 6-JUN-2019
** Includes data from 30q70 for 2016, for women and men.
** Also includes:
**      major geographical region
**      vital registration quality
**      SDG 3.4 met by 2030 (categorical), separately for women and men
** DATASET: file01_pmort2016.dta
** N=186 rows
** COUNTRIES = 186. LAC COUNTRIES = 32
** 
**
**
** e002_dataprep.do 
** ------------------------------------------------------------
** FILE 2 - PREMATURE MORTALITY FROM NCDs (30q70)
** ------------------------------------------------------------
** Extracted from WHO Observatory (https://apps.who.int/gho/data/view.main.2485)
** Download Date: 6-JUN-2019
** It includes data from 30q70 for 2000, 2005, 2010, 2015 and 2016, for women, men and both sexes
** Also includes:
**      Major region code 
** DATASET: file02_pmort2000_2016.dta
** N=2,745 rows
** COUNTRIES = 183. (x3 sex) (x5 years) = 2,745 rows
** AMERICAS COUNTRIES = 33
**
**
**
**
** ** e003_dataprep.do
** ------------------------------------------------------------
** FILE 3 - COUNTRY CODES
** ------------------------------------------------------------
** Extracted from WHO Observatory (https://apps.who.int/gho/data/view.main.2485)
** Download Date: 6-JUN-2019
** It includes data iso-3 code (cid), FAO code (faoid), UN code (unid), WHO mortality database code (mid)
** Also includes:
**      World Bank income grouping, English country name 
** DATASET: file03_country.dta
** N=182 rows
** COUNTRIES = 182.
** AMERICAS COUNTRIES = (no region code in this dataset)
**
**
**
** e004_dataprep.do
** ------------------------------------------------------------
** FILE 4 - POPULATION
** ------------------------------------------------------------
** Extracted from UN World Population Prospects (https://population.un.org/wpp/Download/Standard/Population/)
** Download Date: 8-JUN-2019
** We prepare the country-level UN population data (not age-stratified)
** Years: 1950 to 2020
**      both sexes: WPP2017_POP_F01_1_TOTAL_POPULATION_BOTH_SEXES
**      women only: WPP2017_POP_F01_3_TOTAL_POPULATION_FEMALE
**      men only: WPP2017_POP_F01_3_TOTAL_POPULATION_MALE
** DATASET: file04_population_both.dta / file04_population_women.dta / file04_population_men.dta  
** N=273 rows
** COUNTRIES = 233 (unid<900). Region populations = 40 (unid>=900)
** AMERICAS COUNTRIES = (no region code in this dataset) 
**
**
**
** e005_dataprep.do
** ------------------------------------------------------------
** FILE 5 - LAND USE
** ------------------------------------------------------------
** Extracted from FAO STAT (http://www.fao.org/faostat/en/?#data/RL)
** Download Date: 8-JUN-2019
** Inputs_LandUse_E_All_Data_(Normalized).xlsx
** We prepare the FAO data on country land are and agricultural land. 
** Years: 1961 to 2016 (yrs not complete necessarily)
** 
** DATASET: file05_landuse.dta  
** N=4,741 rows
** COUNTRIES = 43 (Data restricted to LAC)
** CARIBBEAN COUNTRIES = 26
** LATIN AMERICA COUNTRIES = 17
**
**
**
** e006_dataprep.do
** ------------------------------------------------------------
** FILE 6 - WORLD BANK VARIABLES
** ------------------------------------------------------------
** Extracted from World Bank  (https://data.worldbank.org/indicator)
** Download Date: 8-JUN-2019
** Importation via the -wbopendata- software package
** We prepare a range of variables using the World Bank Open Data Portal 
** Years: 1961 to 2016 (yrs not complete necessarily)
** METRICS CURRENTLY EXTRACTED
**      Metric 01. GNI Atlas Method. NY.GNP.ATLS.CD. 
**      Metric 02. GNI per capita, Atlas method (current US$).  NY.GNP.PCAP.CD
**      Metric 03. Food production index (2004-2006 = 100). AG.PRD.FOOD.XD
**      Metric 04. Surface area (sq. km). AG.SRF.TOTL.K2
**      Metric 05. Agricultural land (% of land area). AG.LND.AGRI.ZS
**      Metric 06. Population density (people per sq. km of land area). EN.POP.DNST
**      Metric 07. Current health expenditure per capita (current US$). SH.XPD.CHEX.PC.CD
**      Metric 08. Current health expenditure (% of GDP). SH.XPD.CHEX.GD.ZS
**      Metric 09. Out-of-pocket expenditure (% of current health expenditure). SH.XPD.OOPC.CH.ZS
**      Metric 10. External health expenditure (% of current health expenditure). SH.XPD.EHEX.CH.ZS
**      Metric 11. Physicians (per 1,000 people). SH.MED.PHYS.ZS
**      Metric 12. Nurses and midwives (per 1,000 people). SH.MED.NUMW.P3
** DATASET: file06_worldbank.dta  
** N=4,488 rows
** COUNTRIES = 264 
** LATIN AMERICA and CARIBBEAN COUNTRIES = 41
**
**
**
** e007_dataprep.do
** ------------------------------------------------------------
** FILE 7 - WHO Progress Monitor
** ------------------------------------------------------------
** Extracted manually from WHO reports (https://www.who.int/nmh/publications/ncd-progress-monitor-2017/en/)
** Download Date: 8-JUN-2019
** Data extracted from reports in 2015 and 2017
** We have the following monitoring metrics:
**      t1 "National NCD targets"	
**      t2 "Mortality data"	
**      t3 "Risk factor surveys"	
**      t4 "National integrated NCD policy/strategy/action plan"
**      t5a "increased excise taxes and prices"	
**      t5b "smoke-free policies	"
**      t5c "large graphic health warnings/plain packaging"	
**      t5d "bans on advertising, promotion and sponsorship	"
**      t5e "mass media campaigns	"
**      t6a "restrictions on physical availability"	
**      t6b "advertising bans or comprehensive restrictions	"
**      t6c "increased excise taxes	"
**      t7a "salt/sodium policies"	
**      t7b "saturated fatty acids and trans-fats policies"	
**      t7c "marketing to children restrictions"	
**      t7d "marketing of breast-milk substitutes restrictions	"
**      t8 "Public education and awareness campaign on physical activity"	
**      t9 "Guidelines for management of cancer, CVD, diabetes and CRD"	
**      t10 "Drug therapy/counselling to prevent heart attacks and strokes"
** DATASET: file07_who_progress_monitor
** N=48 rows
** COUNTRIES = 48 
** LATIN AMERICA and CARIBBEAN COUNTRIES = 48
**
**
**
** e008_dataprep.do
** Reading WHO Death data for 2016, ready for Life Table test
** ------------------------------------------------------------
** FILE 8 - WHO Mortality Estimates
** ------------------------------------------------------------
** Disease burden and mortality estimates. CAUSE-SPECIFIC MORTALITY, 2000–2016
** https://www.who.int/healthinfo/global_burden_disease/estimates/en/
** Download Date: 6-JUN-2019
** Input datasets:
** COMPREHENSIVE ESTIMATES DATABASE
**    GlobalCOD_method_2000_2016.pdf          Methods
**    ghe2016_deaths_country_allages.zip      Deaths by country and age    
**    ghe2016_deaths_country_btsx.zip         Deaths by country: women and men
**    ghe2016_deaths_country_fmle.zip         Deaths by country: women
**    ghe2016_deaths_country_mle.zip          Deaths by country: men
**    ghe2016_deaths_region_allages.zip       Deaths by region and age
**    ghe2016_deaths_region_btsx.zip          Deaths by region: women and men
**    ghe2016_deaths_region_fmle.zip          Deaths by region: women
**    ghe2016_deaths_region_mle.zip           Deaths by region: men
** COUNTRIES = 50 
** CARIBBEAN COUNTRIES          = 30
** CENTRAL AMERICA COUNTRIES    = 6
** LATIN AMERICA COUNTRIES      = 14
** DATASETS: 
**      file08_who_deaths_both_lac.dta
**      file08_who_deaths_female_lac.dta
**      file08_who_deaths_male_lac.dta
**      file08_who_deaths_both_brb.dta
**      file08_who_deaths_female_brb.dta
**      file08_who_deaths_male_brb.dta
**
**
**
**
** ------------------------------------------------------------
** FILE 9 - UN POPULATION DATA - for entry into life tables 
** ------------------------------------------------------------
** Extracted manually from UN website (https://population.un.org/wpp/Download/Standard/Population//)
** Download Date: 6-JUN-2019
** Datasets: 
**      WPP2017_POP_F15_1_ANNUAL_POPULATION_BY_AGE_BOTH_SEXES.xlsx
**      WPP2017_POP_F15_2_ANNUAL_POPULATION_BY_AGE_MALE
**      WPP2017_POP_F15_3_ANNUAL_POPULATION_BY_AGE_FEMALE
**
** DATASETS
**      file09_un_population_both_brb
**      file09_un_population_female_brb
**      file09_un_population_male_brb
**      file09_un_population_both_lac
**      file09_un_population_female_lac
**      file09_un_population_male_lac
**
**
**
** e101_analysis.do 
** ------------------------------------------------------------
** NOT CURRENTLY USED
** ------------------------------------------------------------
**
**
**
**
** e102_analysis.do / e102_analysis_region.do
** ------------------------------------------------------------
** TABLE 1 for paper
** METRICS
**      - 30q70 in 2016
**      - 30q70 change since 2000
** ------------------------------------------------------------
** Calculation of 30q70 from first principles
** Input datasets:
**      file 08 --> death information (age stratified)
**      file 09 --> population information (age stratified)
** 
** We calculate 30q70 for BOTH SEXES, WOMEN, MEN
** We calculate 30q70 for all LAC countries and years (2000 to 2016) 
** and for various combinations of LAC sub-regions.
** 
** We use a looping structure to calculate 30q70 for all combinations
** SEX (x3), YEAR (x17), COUNTRY (x30) = 1,530 values
** These calculations are split into sub-regions as follows:
**
** N.America: "USA CAN MEX"
** S.America: "ARG BOL BRA CHL COL ECU PER PRY URY VEN"
** C.America: "CRI GTM HND NIC PAN SLV "
** Caribbean: "ATG BHS BLZ BRB CUB DOM GRD GUY HTI JAM LCA SUR TTO VCT"
**
** We 'post' all results to an output dataset:
** COUNTRY DATASET: file100_q3070_lac.dta
** 
** For the sub-regions, we create several alternative groupings:
** Caribbean
** C. America
** S. America
** N. America (incl. Mexico)
** CA and SA combined
** CA with Mexico
** LAC without NA
** SUB-REGION DATASET: file100_q3070_region_various.dta 
**
**
**
**
** e103_analysis.do
** ------------------------------------------------------------
** TABLE 1 for paper
** METRICS
**      - 30q70 in 2000 and 2016
**      - 30q70 relative change since 2000 (relative to 2016)
**      - Population size (countries and sub-regions)
**      - Number of premature deaths (countries and sub-regions)
** ------------------------------------------------------------
**
**
**
**
** e104_analysis.do
** ------------------------------------------------------------
** TABLE 1 for paper
** METRICS
**      - Average Annual Change in 30q70 between 2000 and 2016
** ------------------------------------------------------------
**
** This is calculated as the regression slope, taking into account
** all 30q70 values in the time period.
**
** NOT PRESENTED IN TABLE 1 for now.
**
**
**
**
** e105_analysis.do
** ------------------------------------------------------------
** FIGURES. 
**
** FIGURE 1. 
** EquiPlot of 30q70
** Stratified by Sex, Year (2000, 2004, 2008, 2012, 2016)
** and sub-region (Caribbean, CA+SA)
** Plots regional average, lowest 30q70 value, highest 30q70 value
**
** FIGURE 2. 
** Line chart
** 30q70 change between 2000 and 2016
** Plotted by SEX, and by sub-region (Caribbean, CA+SA) 
**      
** FIGURE 3.
** Scatterplot.
** 30q70 in 2016 against 30q70 in 2000
** Plotted for all individual countries
** ------------------------------------------------------------**
**
**
**
** e106_analysis.do
** ------------------------------------------------------------
** REGRESSION.
** Bringing datasets together for regression work 
** ------------------------------------------------------------
