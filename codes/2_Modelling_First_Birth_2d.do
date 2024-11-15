* HONORATA BOGUSZ -- 2. MODELLING 2d*

clear

set max_memory .

log using "../logs/2_Modelling_First_Birth_2d.log", text replace

set scheme s1mono

global eq_analytic "ib1.analytic_disc_2d i.age_disc i.event_2y ib5.max_bland_child i.max_education_child"
global eq_interactive "ib1.interactive_disc_2d i.age_disc i.event_2y ib5.max_bland_child i.max_education_child"
global eq_nonroutine_manual "ib1.nonroutine_manual_disc_2d i.age_disc i.event_2y ib5.max_bland_child i.max_education_child"
global eq_routine "ib1.routine_disc_2d i.age_disc i.event_2y ib5.max_bland_child i.max_education_child"

global event_1 "event == 1"
global event_2 "event == 2"
global event_3 "event == 3"
global event_4 "event == 4"
global event_empl "event_empl == 1"

global competing_events_1 "event == 2 3 4"
global competing_events_2 "event == 1 3 4"
global competing_events_3 "event == 1 2 4"
global competing_events_4 "event == 1 2 3"

global cluster_se "cluster(max_occ_childbirth_2d)"

// global range_yaxis1 "0(0.2)0.8"
// global range_yaxis2 "0(0.1)0.3"
// global range_yaxis3 "0(0.05)0.15"

use "../data/final_data/data_for_analysis_1st_birth.dta", clear

* change duration to months

replace child1_birth = mofd(child1_birth)
format child1_birth %tmCYN
replace time = mofd(time)
format time %tmCYN

* optional: delete occupations with less than 100 instances

// bys max_occ_childbirth: egen num = count(max_occ_childbirth)
// drop if num < 100

// sample 1000, count

********** Event 1 **********

// stset, clear
stset time, fail($event_1) id(PSY3) origin(child1_birth)

	* Event 1 Analytic

	stcrreg $eq_analytic, compete($competing_events_1) nolog $cluster_se
	estimates store event_1_analytic

	* Event 1 Interactive
	stcrreg $eq_interactive, compete($competing_events_1) nolog $cluster_se
	estimates store event_1_interactive	

	* Event 1 Non-routine Manual
	stcrreg $eq_nonroutine_manual, compete($competing_events_1) nolog $cluster_se
	estimates store event_1_nonroutine_manual
	
	* Event 1 Routine
	stcrreg $eq_routine, compete($competing_events_1) nolog $cluster_se
	estimates store event_1_routine
		
********** Event 2 **********

stset, clear
stset time, fail($event_2) id(PSY3) origin(child1_birth)

	stcrreg $eq_analytic, compete($competing_events_2) nolog $cluster_se
	estimates store event_2_analytic

	* Event 2 Interactive
	stcrreg $eq_interactive, compete($competing_events_2) nolog $cluster_se
	estimates store event_2_interactive
			
	* Event 2 Non-routine Manual
	stcrreg $eq_nonroutine_manual, compete($competing_events_2) nolog $cluster_se
	estimates store event_2_nonroutine_manual
	
	* Event 2 Routine
	stcrreg $eq_routine, compete($competing_events_2) nolog $cluster_se
	estimates store event_2_routine
	
********** Event 3 **********

stset, clear
stset time, fail($event_3) id(PSY3) origin(child1_birth)

	* Event 3 Analytic
	stcrreg $eq_analytic, compete($competing_events_3) nolog $cluster_se
	estimates store event_3_analytic
	
	* Event 3 Interactive
	stcrreg $eq_interactive, compete($competing_events_3) nolog $cluster_se
	estimates store event_3_interactive

	* Event 3 Non-routine Manual
	stcrreg $eq_nonroutine_manual, compete($competing_events_3) nolog $cluster_se
	estimates store event_3_nonroutine_manual
	
	* Event 3 Routine
	stcrreg $eq_routine, compete($competing_events_3) nolog $cluster_se
	estimates store event_3_routine
		
* Export tables to latex

* Full tables

	* Analytic

	esttab event_1_analytic event_2_analytic event_3_analytic using "../tables/First_Birth_2d/full_all_events_analytic_2d.tex", replace eform ///
	 nogap noabbrev label ///
	b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
	mlabel("Employment" "Unemployment" "Second Birth")

	* Interactive

	esttab event_1_interactive event_2_interactive event_3_interactive using "../tables/First_Birth_2d/full_all_events_interactive_2d.tex", replace eform ///
	 nogap noabbrev label ///
	b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
	mlabel("Employment" "Unemployment" "Second Birth")

	* Non-routine Manual

	esttab event_1_nonroutine_manual event_2_nonroutine_manual event_3_nonroutine_manual using "../tables/First_Birth_2d/full_all_events_nonroutine_manual_2d.tex", replace eform ///
	 nogap noabbrev label ///
	b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
	mlabel("Employment" "Unemployment" "Second Birth")

	* Routine

	esttab event_1_routine event_2_routine event_3_routine using "../tables/First_Birth_2d/full_all_events_routine_2d.tex", replace eform ///
	 nogap noabbrev label ///
	b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
	mlabel("Employment" "Unemployment" "Second Birth")

log close	