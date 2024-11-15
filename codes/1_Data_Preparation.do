* HONORATA BOGUSZ -- 1. DATA PREPARATION *

* 0. Prepare environment

log using "../logs/1_Data_Preparation.log", text replace

* 1. Load and filter VSKT files

* A: Load fixed traits from VSKT 2020
use "../original_data/VSKT2020FixEpisodenDs.dta", clear
count
* keep only women with German citizenship
tab GEH
keep if GEH==2
count
count if SA==0
keep if SA==0
/*
* keep only women with existing Kontenklaerung
keep if BXKLVS!=0
count
*/
keep PSY3 GBJA GBMO GBKIJ1 GBKIM1 GBKIJ2 GBKIM2
save "../generated_data/VSKT2020FixEpisodenDs_filtered.dta", replace

* B: Load fixed traits from VSKT 2021
use "../original_data/VSKT2021FixEpisodenDs.dta", clear
count
* keep only women with German citizenship
tab GEH
keep if GEH==2
count
count if SA==0
keep if SA==0
/*
* keep only women with existing Kontenklaerung
keep if BXKLVS!=0
count
*/
keep PSY3 GBJA GBMO GBKIJ1 GBKIM1 GBKIJ2 GBKIM2
save "../generated_data/VSKT2021FixEpisodenDs_filtered.dta", replace

* C: Load varying traits from VSKT 2020 + 2021 and merge them with fixed traits

use "../original_data/VSKT2020VarEpisodenDs.dta", clear
merge m:1 PSY3 using "../generated_data/VSKT2020FixEpisodenDs_filtered.dta"
tab _merge
keep if _merge==3
save "../generated_data/VSKT2020_filtered.dta", replace

use "../original_data/VSKT2021VarEpisodenDs.dta", clear
merge m:1 PSY3 using "../generated_data/VSKT2021FixEpisodenDs_filtered.dta"
tab _merge
keep if _merge==3
save "../generated_data/VSKT2021_filtered.dta", replace

* D: Merge the two VSKT versions and drop duplicates

use "../generated_data/VSKT2020_filtered.dta", clear
count
append using "../generated_data/VSKT2021_filtered.dta"
count
duplicates drop
count

* keep only women who had 1st child
drop if GBKIJ1==0
count

* create indicator for multiple-child pregnancies
gen mult_child = .
replace mult_child = 1 if (GBKIJ1 == GBKIJ2) & (GBKIM1 == GBKIM2)

tostring VNZR, replace
tostring BSZR, replace

drop _merge

* drop people with events coded for time in the future
gen begin_year = substr(VNZR, 1, 4)
gen end_year = substr(BSZR, 1, 4)
destring begin_year, replace
destring end_year, replace

sum begin_year end_year

drop if begin_year > 2021
sum begin_year end_year

save "../generated_data/VSKT_filtered_all.dta", replace

* 2. Prepare dates

use "../generated_data/VSKT_filtered_all.dta", clear

gen begin = date(VNZR, "YMD")
format begin %d
gen end = date(BSZR, "YMD")
format end %d

drop VNZR BSZR

* assign day of birth of a women and day of birth of children randomly
tab GBMO, nolabel
gen GBTG = runiformint(1, 31) if GBMO == 1 | GBMO == 3 | GBMO == 5 | GBMO == 7 | GBMO == 8 | GBMO == 10 | GBMO == 12
replace GBTG = runiformint(1, 30) if GBMO == 4 | GBMO == 6 | GBMO == 9 | GBMO == 11
replace GBTG = runiformint(1, 28) if GBMO == 2
bys PSY3: replace GBTG = GBTG[1]

tab GBKIM1, nolabel
gen GBKIT1 = runiformint(1, 31) if GBKIM1 == 1 | GBKIM1 == 3 | GBKIM1 == 5 | GBKIM1 == 7 | GBKIM1 == 8 | GBKIM1 == 10 | GBKIM1 == 12
replace GBKIT1 = runiformint(1, 30) if GBKIM1 == 4 | GBKIM1 == 6 | GBKIM1 == 9 | GBKIM1 == 11
replace GBKIT1 = runiformint(1, 28) if GBKIM1 == 2
bys PSY3: replace GBKIT1 = GBKIT1[1]

tab GBKIM2, nolabel
gen GBKIT2 = runiformint(1, 31) if GBKIM2 == 1 | GBKIM2 == 3 | GBKIM2 == 5 | GBKIM2 == 7 | GBKIM2 == 8 | GBKIM2 == 10 | GBKIM2 == 12
replace GBKIT2 = runiformint(1, 30) if GBKIM2 == 4 | GBKIM2 == 6 | GBKIM2 == 9 | GBKIM2 == 11
replace GBKIT2 = runiformint(1, 28) if GBKIM2 == 2
bys PSY3: replace GBKIT2 = GBKIT2[1]

gen mother_birth = mdy(GBMO, GBTG, GBJA)
format mother_birth %d

gen child1_birth = mdy(GBKIM1, GBKIT1, GBKIJ1)
format child1_birth %d

gen child2_birth = mdy(GBKIM2, GBKIT2, GBKIJ2)
format child2_birth %d

keep PSY3 mother_birth GBJA begin end SES child1_birth GBKIJ1 child2_birth GBKIJ2 mult_child
order PSY3 mother_birth GBJA begin end SES child1_birth GBKIJ1 child2_birth GBKIJ2 mult_child

* generate mother's age at first birth

gen age_at_child1 = child1_birth - mother_birth
replace age_at_child1 = age_at_child1/365

* keep mothers who were aged 20-45 at first birth

keep if age_at_child1>=20 & age_at_child1<45
count

* keep only people who gave birth between the beginning of 2012 and the end of 2018

keep if child1_birth > mdy(12, 31, 2011) & child1_birth < mdy(12, 31, 2018)
count

* discard people who had twins

drop if mult_child == 1
count

sum age_at_child1

* 3. Prepare events

tab SES
tab SES, nolabel
gen status = 1 if SES == 13 // employed
replace status = 2 if SES == 4 // parental leave
replace status = 3 if SES == 6 | SES == 7 | SES == 8 // unemployed
replace status = 0 if status == .
tab status

sort PSY3 begin

* discard spells which ended before the first childbirth

drop if child1_birth > end
count

* calculate time between birth of the first child and employment/unemployment/second birth

gen time_empl = begin - child1_birth if status == 1 // employment
gen time_unempl = begin - child1_birth if status == 3 // unemployment
gen time_child2 = child2_birth - child1_birth if child2_birth != . // second birth

sum time_empl time_unempl time_child2

replace time_empl = . if time_empl < 60
replace time_unempl = . if time_unempl < 60

* replace cases where women reported that 2nd childbirth occured less than 8 months from the first one
replace time_child2 = . if time_child2 < 240

sum time_empl time_unempl time_child2

egen time_empl_min = min(time_empl), by(PSY3)
egen time_unempl_min = min(time_unempl), by(PSY3)

gen event = 1 if (time_empl_min < time_unempl_min) & (time_empl_min < time_child2)
replace event = 2 if (time_unempl_min < time_empl_min) & (time_unempl_min < time_child2)
replace event = 3 if (time_child2 < time_empl_min) & (time_child2 < time_unempl_min)
replace event = 4 if event == .

gen to_keep = .
replace to_keep = 1 if !missing(time_empl) & (time_empl == time_empl_min)
replace to_keep = 1 if !missing(time_unempl) & (time_unempl == time_unempl_min)
replace to_keep = 1 if event == 3 | event == 4
keep if to_keep == 1

gen censor = mdy(2, 28, 2020)
format censor %d

gen time = .
replace time = begin if event == 1 | event == 2
replace time = child2_birth if event == 3
replace time = censor if event == 4
replace time = censor if event!=4 & begin > censor
format time %d

replace event = 4 if time > censor
replace time = censor if event == 4

gen duration = time - child1_birth

* keep only the first event for people who experienced multiple events

* check how many times a person is observed in the data

bys PSY3: egen num = count(PSY3)	
tab num

egen min_date = min(time), by(PSY3)
format min_date %d
keep if min_date == time

keep PSY3 mother_birth child1_birth age_at_child1 time event duration
order PSY3 mother_birth child1_birth age_at_child1 time event duration

duplicates drop
count

bys PSY3: egen num = count(PSY3)	
tab num
drop num

tab event
sum duration

save "../generated_data/VSKT_filtered_all_dates.dta", replace

* 3. Merge with AKVS file

use "../generated_data/VSKT_filtered_all_dates.dta", clear

merge m:m PSY3 using "../data/generated/akvs_filtered_all.dta", keep(match)
drop _merge

duplicates drop
sort PSY3 JA
rename JA year

* 4. Merge task measures

merge m:m kldb_2010_3d using "../original_data/task_measures_all_2006_occ_3d.dta"
drop if _merge == 2

sort PSY3 year
drop _merge

misstable sum

count

merge m:m kldb_2010_2d using "../original_data/task_measures_all_2006_occ_2d.dta"
drop if _merge == 2

sort PSY3 year
drop _merge

misstable sum

count

* 5. Prepare variables from the AKVS

* drop women who died
tab TD
keep if TD == 0
count

* generate indicator for a year before 1st birth

gen child_1 = 1 if year == year(child1_birth) - 1

* destring occupation
destring kldb_2010_3d, replace
replace kldb_2010_3d = 0 if kldb_2010_3d == .

destring kldb_2010_2d, replace
replace kldb_2010_2d = 0 if kldb_2010_2d == .

* set occupation to correspond to the year of childbirth
gen occ_childbirth_3d = kldb_2010_3d if child_1 == 1
egen max_occ_childbirth_3d = max(occ_childbirth_3d), by(PSY3) // X missing values generated
* those missing values correspond to cases where the year of childbirth was not observed in AKVS
drop if max_occ_childbirth_3d == .
count

gen occ_childbirth_2d = kldb_2010_2d if child_1 == 1
egen max_occ_childbirth_2d = max(occ_childbirth_2d), by(PSY3) // X missing values generated
* those missing values correspond to cases where the year of childbirth was not observed in AKVS

* set task variables to the one year before childbirth
* 3d
gen analytic_child_3d = analytic_2006_3d if child_1 == 1
egen max_analytic_child_3d = max(analytic_child_3d), by(PSY3)

gen interactive_child_3d = interactive_2006_3d if child_1 == 1
egen max_interactive_child_3d = max(interactive_child_3d), by(PSY3)

gen nonroutine_manual_child_3d = nonroutine_manual_2006_3d if child_1 == 1
egen max_nonroutine_manual_child_3d = max(nonroutine_manual_child_3d), by(PSY3)

gen routine_child_3d = routine_2006_3d if child_1 == 1
egen max_routine_child_3d = max(routine_child_3d), by(PSY3)

drop analytic_child_3d interactive_child_3d nonroutine_manual_child_3d routine_child_3d

* 2d
gen analytic_child_2d = analytic_2006_2d if child_1 == 1
egen max_analytic_child_2d = max(analytic_child_2d), by(PSY3)

gen interactive_child_2d = interactive_2006_2d if child_1 == 1
egen max_interactive_child_2d = max(interactive_child_2d), by(PSY3)

gen nonroutine_manual_child_2d = nonroutine_manual_2006_2d if child_1 == 1
egen max_nonroutine_manual_child_2d = max(nonroutine_manual_child_2d), by(PSY3)

gen routine_child_2d = routine_2006_2d if child_1 == 1
egen max_routine_child_2d = max(routine_child_2d), by(PSY3)

drop analytic_child_2d interactive_child_2d nonroutine_manual_child_2d routine_child_2d

* relabel education and set it to correspond to the year of childbirth
gen education = .
replace education = 1 if TTSCJA2_KLDB2010 == 0 | TTSCJA2_KLDB2010 == 9 | TTSCJA2_KLDB2010 == 1 | TTSCJA2_KLDB2010 == 2 | TTSCJA2_KLDB2010 == 3
replace education = 2 if TTSCJA2_KLDB2010 == 4 | TTSCJA3_KLDB2010 == 1 | TTSCJA3_KLDB2010 == 2 | TTSCJA3_KLDB2010 == 3
replace education = 3 if TTSCJA3_KLDB2010 == 4 | TTSCJA3_KLDB2010 == 5 | TTSCJA3_KLDB2010 == 6

tab education

gen education_child = education if child_1 == 1
egen max_education_child = max(education_child), by(PSY3)

tab max_education_child
drop education

* set residence to correspond to the year of childbirth
gen east_child = EAST if child_1 == 1
egen max_east_child = max(east_child), by(PSY3)

tab max_east_child
drop EAST

gen bland_child = WHOT_BLAND if child_1 == 1
egen max_bland_child = max(bland_child), by(PSY3)

tab max_bland_child
drop WHOT_BLAND

* set earning points to correspond to the year of childbirth
gen ep_child = EP if child_1 == 1
egen max_ep_child = max(ep_child), by(PSY3)

sum max_ep_child
drop EP ep_child

/*
preserve

	* check in how many cases occupation was the same in the year of childbirth and the year before
	gen year_before_birth = 1 if year == year(child1_birth) - 1
	* keep only women for who are observed a year before childbirth and in the year of childbirth

	bys PSY3: gen nvals = _n == 1
	count if nvals

	egen child_1_max = max(child_1), by(PSY3)
	egen year_before_birth_max = max(year_before_birth), by(PSY3)
	keep if child_1_max==1 & year_before_birth_max==1
	count
	count if nvals
	
	* gen occupation a year before childbirth
	gen occ_childbirth_1 = kldb_2010_3d if year_before_birth == 1
	egen max_occ_childbirth_1 = max(occ_childbirth_1), by(PSY3)
	
	keep if child_1 == 1
	count
	keep if max_occ_childbirth == max_occ_childbirth_1
	count
	
restore
*/

* create discrete task measures
* 3d
gen analytic_disc_3d = 0 if max_analytic_child_3d == .
replace analytic_disc_3d = 1 if max_analytic_child_3d != . & (max_analytic_child_3d > 0 & max_analytic_child_3d < 20)
replace analytic_disc_3d = 2 if max_analytic_child_3d != . & (max_analytic_child_3d >= 20 & max_analytic_child_3d < 40)
replace analytic_disc_3d = 3 if max_analytic_child_3d != . & (max_analytic_child_3d >= 40 & max_analytic_child_3d < 60)
replace analytic_disc_3d = 4 if max_analytic_child_3d != . & (max_analytic_child_3d >= 60 & max_analytic_child_3d < 80)
replace analytic_disc_3d = 5 if max_analytic_child_3d != . & (max_analytic_child_3d >= 80)
	
gen interactive_disc_3d = 0 if max_interactive_child_3d == .
replace interactive_disc_3d = 1 if max_interactive_child_3d != . & (max_interactive_child_3d > 0 & max_interactive_child_3d < 20)
replace interactive_disc_3d = 2 if max_interactive_child_3d != . & (max_interactive_child_3d >= 20 & max_interactive_child_3d < 40)
replace interactive_disc_3d = 3 if max_interactive_child_3d != . & (max_interactive_child_3d >= 40 & max_interactive_child_3d < 60)
replace interactive_disc_3d = 4 if max_interactive_child_3d != . & (max_interactive_child_3d >= 60 & max_interactive_child_3d < 80)
replace interactive_disc_3d = 5 if max_interactive_child_3d != . & (max_interactive_child_3d >= 80)
	
gen nonroutine_manual_disc_3d = 0 if max_nonroutine_manual_child_3d == .
replace nonroutine_manual_disc_3d = 1 if max_nonroutine_manual_child_3d != . & (max_nonroutine_manual_child_3d > 0 & max_nonroutine_manual_child_3d < 20)
replace nonroutine_manual_disc_3d = 2 if max_nonroutine_manual_child_3d != . & (max_nonroutine_manual_child_3d >= 20 & max_nonroutine_manual_child_3d < 40)
replace nonroutine_manual_disc_3d = 3 if max_nonroutine_manual_child_3d != . & (max_nonroutine_manual_child_3d >= 40 & max_nonroutine_manual_child_3d < 60)
replace nonroutine_manual_disc_3d = 4 if max_nonroutine_manual_child_3d != . & (max_nonroutine_manual_child_3d >= 60 & max_nonroutine_manual_child_3d < 80)
replace nonroutine_manual_disc_3d = 5 if max_nonroutine_manual_child_3d != . & (max_nonroutine_manual_child_3d >= 80)
	
gen routine_disc_3d = 0 if max_routine_child_3d == .
replace routine_disc_3d = 1 if max_routine_child_3d != . & (max_routine_child_3d > 0 & max_routine_child_3d < 20)
replace routine_disc_3d = 2 if max_routine_child_3d != . & (max_routine_child_3d >= 20 & max_routine_child_3d < 40)
replace routine_disc_3d = 3 if max_routine_child_3d != . & (max_routine_child_3d >= 40 & max_routine_child_3d < 60)
replace routine_disc_3d = 4 if max_routine_child_3d != . & (max_routine_child_3d >= 60 & max_routine_child_3d < 80)
replace routine_disc_3d = 5 if max_routine_child_3d != . & (max_routine_child_3d >= 80)
		
* 2d

gen analytic_disc_2d = 0 if max_analytic_child_2d == .
replace analytic_disc_2d = 1 if max_analytic_child_2d != . & (max_analytic_child_2d > 0 & max_analytic_child_2d < 20)
replace analytic_disc_2d = 2 if max_analytic_child_2d != . & (max_analytic_child_2d >= 20 & max_analytic_child_2d < 40)
replace analytic_disc_2d = 3 if max_analytic_child_2d != . & (max_analytic_child_2d >= 40 & max_analytic_child_2d < 60)
replace analytic_disc_2d = 4 if max_analytic_child_2d != . & (max_analytic_child_2d >= 60 & max_analytic_child_2d < 80)
replace analytic_disc_2d = 5 if max_analytic_child_2d != . & (max_analytic_child_2d >= 80)
	
gen interactive_disc_2d = 0 if max_interactive_child_2d == .
replace interactive_disc_2d = 1 if max_interactive_child_2d != . & (max_interactive_child_2d > 0 & max_interactive_child_2d < 20)
replace interactive_disc_2d = 2 if max_interactive_child_2d != . & (max_interactive_child_2d >= 20 & max_interactive_child_2d < 40)
replace interactive_disc_2d = 3 if max_interactive_child_2d != . & (max_interactive_child_2d >= 40 & max_interactive_child_2d < 60)
replace interactive_disc_2d = 4 if max_interactive_child_2d != . & (max_interactive_child_2d >= 60 & max_interactive_child_2d < 80)
replace interactive_disc_2d = 5 if max_interactive_child_2d != . & (max_interactive_child_2d >= 80)
	
gen nonroutine_manual_disc_2d = 0 if max_nonroutine_manual_child_2d == .
replace nonroutine_manual_disc_2d = 1 if max_nonroutine_manual_child_2d != . & (max_nonroutine_manual_child_2d > 0 & max_nonroutine_manual_child_2d < 20)
replace nonroutine_manual_disc_2d = 2 if max_nonroutine_manual_child_2d != . & (max_nonroutine_manual_child_2d >= 20 & max_nonroutine_manual_child_2d < 40)
replace nonroutine_manual_disc_2d = 3 if max_nonroutine_manual_child_2d != . & (max_nonroutine_manual_child_2d >= 40 & max_nonroutine_manual_child_2d < 60)
replace nonroutine_manual_disc_2d = 4 if max_nonroutine_manual_child_2d != . & (max_nonroutine_manual_child_2d >= 60 & max_nonroutine_manual_child_2d < 80)
replace nonroutine_manual_disc_2d = 5 if max_nonroutine_manual_child_2d != . & (max_nonroutine_manual_child_2d >= 80)
	
gen routine_disc_2d = 0 if max_routine_child_2d == .
replace routine_disc_2d = 1 if max_routine_child_2d != . & (max_routine_child_2d > 0 & max_routine_child_2d < 20)
replace routine_disc_2d = 2 if max_routine_child_2d != . & (max_routine_child_2d >= 20 & max_routine_child_2d < 40)
replace routine_disc_2d = 3 if max_routine_child_2d != . & (max_routine_child_2d >= 40 & max_routine_child_2d < 60)
replace routine_disc_2d = 4 if max_routine_child_2d != . & (max_routine_child_2d >= 60 & max_routine_child_2d < 80)
replace routine_disc_2d = 5 if max_routine_child_2d != . & (max_routine_child_2d >= 80)
		
* create numeric ID
egen id = group(PSY3)		

* keep only one row per person
keep if !missing(child_1)
count

* create a number of how many times a person is observed in the data	
	
bys id: egen num = count(id)	
tab num
drop num

* categorize age and cohort
gen age_disc = .
replace age_disc = 1 if age_at_child1<25
replace age_disc = 2 if age_at_child1>=25 & age_at_child1<30
replace age_disc = 3 if age_at_child1>=30 & age_at_child1<35
replace age_disc = 4 if age_at_child1>=35
tab age_disc

gen cohort = .
replace cohort = 1 if year(mother_birth)<1980
replace cohort = 2 if year(mother_birth)>=1980 & year(mother_birth)<1990
replace cohort = 3 if year(mother_birth)>=1990
tab cohort

* create birth year of child 1 and year of event

gen child_1_birth_y = year(child1_birth)
gen event_y = year(time)
tab event_y

gen event_2y = 1 if event_y == 2012 | event_y == 2013
replace event_2y = 2 if event_y == 2014 | event_y == 2015
replace event_2y = 3 if event_y == 2016 | event_y == 2017
replace event_2y = 4 if event_y == 2018 | event_y == 2019
replace event_2y = 5 if event_y == 2020
tab event_2y

keep PSY3 id mother_birth cohort child1_birth child_1_birth_y age_at_child1 age_disc event time event_y event_2y duration ///
max_education_child max_east_child max_bland_child max_ep_child ///
max_occ_childbirth_3d analytic_disc_3d interactive_disc_3d nonroutine_manual_disc_3d routine_disc_3d ///
max_analytic_child_3d max_interactive_child_3d max_nonroutine_manual_child_3d max_routine_child_3d ///
max_occ_childbirth_2d analytic_disc_2d interactive_disc_2d nonroutine_manual_disc_2d routine_disc_2d ///
max_analytic_child_2d max_interactive_child_2d max_nonroutine_manual_child_2d max_routine_child_2d

order PSY3 id mother_birth cohort child1_birth child_1_birth_y age_at_child1 age_disc event time event_y event_2y duration ///
max_education_child max_east_child max_bland_child max_ep_child ///
max_occ_childbirth_3d analytic_disc_3d interactive_disc_3d nonroutine_manual_disc_3d routine_disc_3d ///
max_analytic_child_3d max_interactive_child_3d max_nonroutine_manual_child_3d max_routine_child_3d ///
max_occ_childbirth_2d analytic_disc_2d interactive_disc_2d nonroutine_manual_disc_2d routine_disc_2d ///
max_analytic_child_2d max_interactive_child_2d max_nonroutine_manual_child_2d max_routine_child_2d

bys id: egen num = count(id)	
tab num
duplicates drop
drop num

compress

* drop people wwith unknown residence or residing abroad a year before birth
tab max_bland_child
drop if max_bland_child == 0
drop if max_bland_child == 99

* Label variables and values

label variable mother_birth "Date of Birth, Mother"
label variable cohort "Cohort (D)"
label variable child1_birth "Date of Birth, Child 1"
label variable child_1_birth_y "Year of Birth, Child 1"
label variable age_at_child1 "Age at Child 1"
label variable age_disc "Age at Child 1"
label variable event "Event"
label variable time "Date of Event"
label variable event_y "Year of Event"
label variable event_2y "Year of Event"
label variable duration "Duration"

label variable max_education_child "Education"
label variable max_east_child "East Germany"
label variable max_bland_child "Bundesland"
label variable max_occ_childbirth_3d "Occupation 3d"
label variable max_occ_childbirth_2d "Occupation 2d"
label variable max_ep_child "Earning Points"

label variable max_analytic_child_3d "Analytic"
label variable max_interactive_child_3d "Interactive"
label variable max_nonroutine_manual_child_3d "Non-routine Manual"
label variable max_routine_child_3d "Routine"

label variable analytic_disc_3d "Analytic (D)"
label variable interactive_disc_3d "Interactive (D)"
label variable nonroutine_manual_disc_3d "Non-routine Manual (D)"
label variable routine_disc_3d "Routine (D)"

label variable max_analytic_child_2d "Analytic"
label variable max_interactive_child_2d "Interactive"
label variable max_nonroutine_manual_child_2d "Non-routine Manual"
label variable max_routine_child_2d "Routine"

label variable analytic_disc_2d "Analytic (D)"
label variable interactive_disc_2d "Interactive (D)"
label variable nonroutine_manual_disc_2d "Non-routine Manual (D)"
label variable routine_disc_2d "Routine (D)"

lab def event 1 "Employment" 2 "Unemployment" 3 "Second Birth" 4 "Censored" , modify
lab val event event

label def event_2y 1 "2012-2013" 2 "2014-2015" 3 "2016-2017" 4 "2018-2029" 5 "2020", modify
label val event_2y event_2y

lab def age_disc 1 "Age: 20-24" 2 "Age: 25-29" 3 "Age: 30-34" 4 "Age: 35+", modify
lab val age_disc age_disc

lab def cohort 1 "Cohort: 1967-1979" 2 "Cohort: 1980-1989" 3 "Cohort: 1990-2000", modify
lab val cohort cohort

lab def max_east_child 0 "West Germany" 1 "East Germany", modify
lab val max_east_child max_east_child

lab def max_bland_child 1 "Schleswig-Holstein" 2 "Hamburg" 3 "Niedersachsen" 4 "Bremen" 5 "Nordrhein-Westfalen" 6 "Hessen" 7 "Rheinland-Pfalz" 8 "Baden-Wuerttemberg" 9 "Bayern" 10 "Saarland" 11 "Berlin" 12 "Brandenburg" 13 "Mecklenburg-Vorpommern" 14 "Sachsen" 15 "Sachsen-Anhalt" 16 "Thueringen", modify
lab val max_bland_child max_bland_child

lab def max_education_child 1 "Education: Low/Unknown" 2 "Education: Middle" 3 "Education: High", modify
lab val max_education_child max_education_child
	
lab def task 0 "Task Measure: Unknown" 1 "Task Measure: 0-20" 2 "Task Measure: 20-40" 3 "Task Measure: 40-60" 4 "Task Measure: 60-80" 5 "Task Measure: 80-100", modify
lab val analytic_disc_3d task
lab val interactive_disc_3d task
lab val nonroutine_manual_disc_3d task
lab val routine_disc_3d task
lab val analytic_disc_2d task
lab val interactive_disc_2d task
lab val nonroutine_manual_disc_2d task
lab val routine_disc_2d task

count

* split events to dummies

gen event_1 = 1 if event == 1
replace event_1 = 0 if event_1 == .
label variable event_1 "Employment"

gen event_2 = 1 if event == 2
replace event_2 = 0 if event_2 == .
label variable event_2 "Unemployment"

gen event_3 = 1 if event == 3
replace event_3 = 0 if event_3 == .
label variable event_3 "Second Birth"

gen event_4 = 1 if event == 4
replace event_4 = 0 if event_4 == .
label variable event_4 "Censored"

order PSY3 id mother_birth cohort child1_birth child_1_birth_y age_at_child1 age_disc event event_1 event_2 event_3 event_4 time event_y event_2y duration ///
max_education_child max_east_child max_bland_child max_ep_child ///
max_occ_childbirth_3d analytic_disc_3d interactive_disc_3d nonroutine_manual_disc_3d routine_disc_3d ///
max_analytic_child_3d max_interactive_child_3d max_nonroutine_manual_child_3d max_routine_child_3d ///
max_occ_childbirth_2d analytic_disc_2d interactive_disc_2d nonroutine_manual_disc_2d routine_disc_2d ///
max_analytic_child_2d max_interactive_child_2d max_nonroutine_manual_child_2d max_routine_child_2d
	
* save for analysis

save "../final_data/data_for_analysis_1st_birth.dta", replace
	
log close