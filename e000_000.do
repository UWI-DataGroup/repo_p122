
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
** Non-communicable disease mortality in Latin America and the Caribbean: are Small Island Developing States a hidden global community?
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
**      - 1st. Women and Men
**      - 2nd. Year (2000, 05, 10, 15)
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
