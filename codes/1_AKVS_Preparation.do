* HONORATA BOGUSZ -- 1. AKVS PREPARATION *

* 0. Prepare environment

log using "../logs/1_AKVS_Preparation.log", text replace

* 1. Load and filter AKVS files

* it seems that there is no occupation in 2010
global akvs "AKVS2011f AKVS2012f AKVS2013f AKVS2014f AKVS2015f AKVS2016f AKVS2017f AKVS2018f AKVS2019f AKVS2020f" 
global akvs_filtered "AKVS2011f_filtered AKVS2012f_filtered AKVS2013f_filtered AKVS2014f_filtered AKVS2015f_filtered AKVS2016f_filtered AKVS2017f_filtered AKVS2018f_filtered AKVS2019f_filtered AKVS2020f_filtered" 


foreach dataset in $akvs {
	
	use "../original_data/`dataset'.dta", clear
	count
	
	* keep only women with German citizenship
	keep if SAVS==0
	count
	
	*CODE EARNING POINTS (in case you want to work with an income variable)
	*social security contributions
	g entgelt1 = BHEGJA1 + BHEGJA2 + BAEGJA + TLEGJA + BHGZEGJA + VORUGLJA1 + VORUGLJA2 + UBAEGJA

	*artist  + self employed + ...
	g entgelt2=.
	replace entgelt2 = 100*HDBYJA1/18.7 + 100*HDBYJA2/18.7 + 100*KSBYJA1/18.7 + 100*KSBYJA2/18.7 + 100*SSGKBYJA1/18.7 + 100*SSGKBYJA2/18.7 + 100*SSAQBYJA1/18.7 + 100*SSAQBYJA2/18.7 + 100*FWBYJA1/18.7 + 100*GIFHBYJA/15 + 100*GIPFBYJA/18.7 + 100*GIPHFHBYJA/5 + 100*GIPHPFBYJA/18.7
	g EP = entgelt1 + entgelt2

	*divide by average income (2015) to get earning points
	egen EP_mean = mean(EP)
	replace EP = EP / EP_mean 
	sum EP
	
	* keep only relevant variables
	keep PSY JA GBJA GBMO WHOT_BLAND TD BHTGJA1 BHTGJA2 AFGTGJA1 AFGTGJA2 ALHITGJA1 TTSCJA1_KLDB2010-TTSCJA5_KLDB2010 EP
	
	* generate employment status
	g EMP_STAT=0
	
	g empl_time = BHTGJA1 + BHTGJA2
	g unempl_time = AFGTGJA1 + AFGTGJA2 + ALHITGJA1
	
	* Check how many women were both employed and unemployed in one year.
	count if empl_time > 0 & unempl_time > 0
	
	replace EMP_STAT=1 if unempl_time!=0 & unempl_time>empl_time
	replace EMP_STAT=2 if empl_time!=0 & unempl_time<empl_time
	lab var EMP_STAT "Employment Status"
	lab def EMP_STAT 0 "Other" 1 "Unemployed" 2 "Employed" , modify
	lab val EMP_STAT EMP_STAT
	g EMP=1 if EMP_STAT==2
	replace EMP=0 if EMP==.
	
	count if empl_time>0 & unempl_time>0
	drop empl_time unempl_time
	
	* keep the first 3 digits of occupation
	tostring TTSCJA1_KLDB2010, replace
	gen kldb_2010_3d = substr(TTSCJA1_KLDB2010, 1, 3)
	gen kldb_2010_2d = substr(TTSCJA1_KLDB2010, 1, 2)
	
	* generate East Germany indicator
	gen EAST = 99
	replace EAST = 0 if WHOT_BLAND >= 1 & WHOT_BLAND <= 10 // West
	replace EAST = 1 if WHOT_BLAND > 10 & WHOT_BLAND < 99 // West
	
	save "../generated_data/`dataset'_filtered.dta", replace
	clear
}

* merge all waves of filtered AKVS and save

foreach dataset in $akvs_filtered {

	cap append using "../generated_data/`dataset'.dta"

}
count
tab JA

save "../generated_data/akvs_filtered_all.dta", replace 
clear
		
log close