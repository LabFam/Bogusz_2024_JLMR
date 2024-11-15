* HONORATA BOGUSZ -- 2. MODELLING 3d*

clear

set max_memory .

log using "../logs/2_Modelling_First_Birth_3d.log", text replace

set scheme s1mono

global eq_analytic "ib1.analytic_disc_3d i.age_disc i.event_2y ib5.max_bland_child i.max_education_child"
global eq_interactive "ib1.interactive_disc_3d i.age_disc i.event_2y ib5.max_bland_child i.max_education_child"
global eq_nonroutine_manual "ib1.nonroutine_manual_disc_3d i.age_disc i.event_2y ib5.max_bland_child i.max_education_child"
global eq_routine "ib1.routine_disc_3d i.age_disc i.event_2y ib5.max_bland_child i.max_education_child"

global event_1 "event == 1"
global event_2 "event == 2"
global event_3 "event == 3"
global event_4 "event == 4"
global event_empl "event_empl == 1"

global competing_events_1 "event == 2 3 4"
global competing_events_2 "event == 1 3 4"
global competing_events_3 "event == 1 2 4"
global competing_events_4 "event == 1 2 3"

global cluster_se "cluster(max_occ_childbirth_3d)"

global range_yaxis1 "0(0.2)0.8"
global range_yaxis2 "0(0.1)0.3"
global range_yaxis3 "0(0.05)0.15"

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

		stcurve, cif title("Analytic") lwidth(thick) lcolor(black) ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis1, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis1)) ///
		name("event_1_analytic", replace)
		graph save "../plots/event_1_analytic.gph", replace
		graph export "../plots/event_1_analytic.png", replace
		
		stcurve, cif at1(analytic_disc_3d = 1) ///
		at2(analytic_disc_3d = 2) ///
		at3(analytic_disc_3d = 3) ///
		at4(analytic_disc_3d = 4) ///
		at5(analytic_disc_3d = 5) ///
		lwidth(thick thick thick thick thick) ///
		lcolor("5 0 244" "253 115 0" "1 81 0" "254 70 254" "217 194 99") ///
		title("Analytic") ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis1, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis1)) ///
		legend(off row(1) order(1 "0-19" 2 "20-39" 3 "40-59" 4 "60-79" 5 "80-100")) ///
		name("event_1_analytic_sep", replace)
		graph save "../plots/event_1_analytic_sep.gph", replace
		graph export "../plots/event_1_analytic_sep.png", replace

	* Event 1 Interactive
	stcrreg $eq_interactive, compete($competing_events_1) nolog $cluster_se
	estimates store event_1_interactive
	
		stcurve, cif title("Interactive") lwidth(thick) lcolor(black) ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis1, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis1)) ///
		name("event_1_interactive", replace)
		graph save "../plots/event_1_interactive.gph", replace
		graph export "../plots/event_1_interactive.png", replace
	
		stcurve, cif at1(interactive_disc_3d = 1) ///
		at2(interactive_disc_3d = 2) ///
		at3(interactive_disc_3d = 3) ///
		at4(interactive_disc_3d = 4) ///
		at5(interactive_disc_3d = 5) ///
		lwidth(thick thick thick thick thick) ///
		lcolor("5 0 244" "253 115 0" "1 81 0" "254 70 254" "217 194 99") ///
		title("Interactive") ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis1, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis1)) ///
		legend(off row(1) order(1 "0-19" 2 "20-39" 3 "40-59" 4 "60-79" 5 "80-100")) ///
		name("event_1_interactive_sep", replace)
		graph save "../plots/event_1_interactive_sep.gph", replace
		graph export "../plots/event_1_interactive_sep.png", replace
	

	* Event 1 Non-routine Manual
	stcrreg $eq_nonroutine_manual, compete($competing_events_1) nolog $cluster_se
	estimates store event_1_nonroutine_manual
	
		stcurve, cif title("Non-routine Manual") lwidth(thick) lcolor(black) ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis1, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis1)) ///
		name("event_1_nonroutine_manual", replace)
		graph save "../plots/event_1_nonroutine_manual.gph", replace
		graph export "../plots/event_1_nonroutine_manual.png", replace
		
		stcurve, cif at1(nonroutine_manual_disc_3d = 1) ///
		at2(nonroutine_manual_disc_3d = 2) ///
		at3(nonroutine_manual_disc_3d = 3) ///
		at4(nonroutine_manual_disc_3d = 4) ///
		at5(nonroutine_manual_disc_3d = 5) ///
		lwidth(thick thick thick thick thick) ///
		lcolor("5 0 244" "253 115 0" "1 81 0" "254 70 254" "217 194 99") ///
		title("Non-routine Manual") ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis1, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis1)) ///
		legend(off row(1) order(1 "0-19" 2 "20-39" 3 "40-59" 4 "60-79" 5 "80-100")) ///
		name("event_1_nonroutine_manual_sep", replace)
		graph save "../plots/event_1_nonroutine_manual_sep.gph", replace
		graph export "../plots/event_1_nonroutine_manual_sep.png", replace

	* Event 1 Routine
	stcrreg $eq_routine, compete($competing_events_1) nolog $cluster_se
	estimates store event_1_routine
	
		stcurve, cif title("Routine") lwidth(thick) lcolor(black) ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis1, labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis1)) ///
		name("event_1_routine", replace)
		graph save "../plots/event_1_routine.gph", replace
		graph export "../plots/event_1_routine.png", replace
		
		stcurve, cif at1(routine_disc_3d = 1) ///
		at2(routine_disc_3d = 2) ///
		at3(routine_disc_3d = 3) ///
		at4(routine_disc_3d = 4) ///
		at5(routine_disc_3d = 5) ///
		lwidth(thick thick thick thick thick) ///
		lcolor("5 0 244" "253 115 0" "1 81 0" "254 70 254" "217 194 99") ///
		title("Routine") ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis1, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis1)) ///
		legend(off row(1) order(1 "0-19" 2 "20-39" 3 "40-59" 4 "60-79" 5 "80-100")) ///
		name("event_1_routine_sep", replace)
		graph save "../plots/event_1_routine_sep.gph", replace
		graph export "../plots/event_1_routine_sep.png", replace
	
	graph combine event_1_analytic ///
	event_1_interactive ///
	event_1_nonroutine_manual ///
	event_1_routine
	graph save "../plots/event_1.gph", replace
	graph export "../plots/event_1.png", replace
	
	grc1leg event_1_analytic_sep ///
	event_1_interactive_sep ///
	event_1_nonroutine_manual_sep ///
	event_1_routine_sep
	graph save "../plots/event_1_sep.gph", replace 
	graph export "../plots/event_1_sep.png", replace 
	
********** Event 2 **********

stset, clear
stset time, fail($event_2) id(PSY3) origin(child1_birth)

	* Event 2 Analytic
	stcrreg $eq_analytic, compete($competing_events_2) nolog $cluster_se
	estimates store event_2_analytic
	
		stcurve, cif title("Analytic") lwidth(thick) lcolor(black) ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis2, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis2)) ///
		name("event_2_analytic", replace)
		graph save "../plots/event_2_analytic.gph", replace
		graph export "../plots/event_2_analytic.png", replace
	
		stcurve, cif at1(analytic_disc_3d = 1) ///
		at2(analytic_disc_3d = 2) ///
		at3(analytic_disc_3d = 3) ///
		at4(analytic_disc_3d = 4) ///
		at5(analytic_disc_3d = 5) ///
		lwidth(thick thick thick thick thick) ///
		lcolor("5 0 244" "253 115 0" "1 81 0" "254 70 254" "217 194 99") ///
		title("Analytic") ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis2, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis2)) ///
		legend(off row(1) order(1 "0-19" 2 "20-39" 3 "40-59" 4 "60-79" 5 "80-100")) ///
		name("event_2_analytic_sep", replace)
		graph save "../plots/event_2_analytic_sep.gph", replace
		graph export "../plots/event_2_analytic_sep.png", replace

	* Event 2 Interactive
	stcrreg $eq_interactive, compete($competing_events_2) nolog $cluster_se
	estimates store event_2_interactive
	
		stcurve, cif title("Interactive") lwidth(thick) lcolor(black) ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis2, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis2)) ///
		name("event_2_interactive", replace)
		graph save "../plots/event_2_interactive.gph", replace
		graph export "../plots/event_2_interactive.png", replace

		stcurve, cif at1(interactive_disc_3d = 1) ///
		at2(interactive_disc_3d = 2) ///
		at3(interactive_disc_3d = 3) ///
		at4(interactive_disc_3d = 4) ///
		at5(interactive_disc_3d = 5) ///
		lwidth(thick thick thick thick thick) ///
		lcolor("5 0 244" "253 115 0" "1 81 0" "254 70 254" "217 194 99") ///
		title("Interactive") ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis2, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis2)) ///
		legend(off row(1) order(1 "0-19" 2 "20-39" 3 "40-59" 4 "60-79" 5 "80-100")) ///
		name("event_2_interactive_sep", replace)
		graph save "../plots/event_2_interactive_sep.gph", replace
		graph export "../plots/event_2_interactive_sep.png", replace
		
	* Event 2 Non-routine Manual
	stcrreg $eq_nonroutine_manual, compete($competing_events_2) nolog $cluster_se
	estimates store event_2_nonroutine_manual
	
		stcurve, cif title("Non-routine Manual") lwidth(thick) lcolor(black) ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis2, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis2)) ///
		name("event_2_nonroutine_manual", replace)
		graph save "../plots/event_2_nonroutine_manual.gph", replace
		graph export "../plots/event_2_nonroutine_manual.png", replace

		stcurve, cif at1(nonroutine_manual_disc_3d = 1) ///
		at2(nonroutine_manual_disc_3d = 2) ///
		at3(nonroutine_manual_disc_3d = 3) ///
		at4(nonroutine_manual_disc_3d = 4) ///
		at5(nonroutine_manual_disc_3d = 5) ///
		lwidth(thick thick thick thick thick) ///
		lcolor("5 0 244" "253 115 0" "1 81 0" "254 70 254" "217 194 99") ///
		title("Non-routine Manual") ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis2, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis2)) ///
		legend(off row(1) order(1 "0-19" 2 "20-39" 3 "40-59" 4 "60-79" 5 "80-100")) ///
		name("event_2_nonroutine_manual_sep", replace)
		graph save "../plots/event_2_nonroutine_manual_sep.gph", replace
		graph export "../plots/event_2_nonroutine_manual_sep.png", replace

	* Event 2 Routine
	stcrreg $eq_routine, compete($competing_events_2) nolog $cluster_se
	estimates store event_2_routine
	
		stcurve, cif title("Routine") lwidth(thick) lcolor(black) ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis2, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis2)) ///
		name("event_2_routine", replace)
		graph save "../plots/event_2_routine.gph", replace
		graph export "../plots/event_2_routine.png", replace
			
		stcurve, cif at1(routine_disc_3d = 1) ///
		at2(routine_disc_3d = 2) ///
		at3(routine_disc_3d = 3) ///
		at4(routine_disc_3d = 4) ///
		at5(routine_disc_3d = 5) ///
		lwidth(thick thick thick thick thick) ///
		lcolor("5 0 244" "253 115 0" "1 81 0" "254 70 254" "217 194 99") ///
		title("Routine") ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis2, format(%03.1f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis2)) ///
		legend(off row(1) order(1 "0-19" 2 "20-39" 3 "40-59" 4 "60-79" 5 "80-100")) ///
		name("event_2_routine_sep", replace)
		graph save "../plots/event_2_routine_sep.gph", replace
		graph export "../plots/event_2_routine_sep.png", replace

	graph combine event_2_analytic ///
	event_2_interactive ///
	event_2_nonroutine_manual ///
	event_2_routine
	graph save "../plots/event_2.gph", replace
	graph export "../plots/event_2.png", replace
	
	grc1leg event_2_analytic_sep ///
	event_2_interactive_sep ///
	event_2_nonroutine_manual_sep ///
	event_2_routine_sep
	graph save "../plots/event_2_sep.gph", replace
	graph export "../plots/event_2_sep.png", replace

********** Event 3 **********

stset, clear
stset time, fail($event_3) id(PSY3) origin(child1_birth)

	* Event 3 Analytic
	stcrreg $eq_analytic, compete($competing_events_3) nolog $cluster_se
	estimates store event_3_analytic

		stcurve, cif title("Analytic") lwidth(thick) lcolor(black) ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis3, format(%03.2f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis3)) ///
		name("event_3_analytic", replace)
		graph save "../plots/event_3_analytic.gph", replace
		graph export "../plots/event_3_analytic.png", replace
		
		stcurve, cif at1(analytic_disc_3d = 1) ///
		at2(analytic_disc_3d = 2) ///
		at3(analytic_disc_3d = 3) ///
		at4(analytic_disc_3d = 4) ///
		at5(analytic_disc_3d = 5) ///
		lwidth(thick thick thick thick thick) ///
		lcolor("5 0 244" "253 115 0" "1 81 0" "254 70 254" "217 194 99") ///
		title("Analytic") ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis3, format(%03.2f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis3)) ///
		legend(off row(1) order(1 "0-19" 2 "20-39" 3 "40-59" 4 "60-79" 5 "80-100")) ///
		name("event_3_analytic_sep", replace)
		graph save "../plots/event_3_analytic_sep.gph", replace
		graph export "../plots/event_3_analytic_sep.png", replace
	
	* Event 3 Interactive
	stcrreg $eq_interactive, compete($competing_events_3) nolog $cluster_se
	estimates store event_3_interactive

		stcurve, cif title("Interactive") lwidth(thick) lcolor(black) ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis3, format(%03.2f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis3)) ///
		name("event_3_interactive", replace)
		graph save "../plots/event_3_interactive.gph", replace
		graph export "../plots/event_3_interactive.png", replace
			
		stcurve, cif at1(interactive_disc_3d = 1) ///
		at2(interactive_disc_3d = 2) ///
		at3(interactive_disc_3d = 3) ///
		at4(interactive_disc_3d = 4) ///
		at5(interactive_disc_3d = 5) ///
		lwidth(thick thick thick thick thick) ///
		lcolor("5 0 244" "253 115 0" "1 81 0" "254 70 254" "217 194 99") ///
		title("Interactive") ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis3, format(%03.2f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis3)) ///
		legend(off row(1) order(1 "0-19" 2 "20-39" 3 "40-59" 4 "60-79" 5 "80-100")) ///
		name("event_3_interactive_sep", replace)
		graph save "../plots/event_3_interactive_sep.gph", replace
		graph export "../plots/event_3_interactive_sep.png", replace

	* Event 3 Non-routine Manual
	stcrreg $eq_nonroutine_manual, compete($competing_events_3) nolog $cluster_se
	estimates store event_3_nonroutine_manual

		stcurve, cif title("Non-routine Manual") lwidth(thick) lcolor(black) ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis3, format(%03.2f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis3)) ///
		name("event_3_nonroutine_manual", replace)
		graph save "../plots/event_3_nonroutine_manual.gph", replace
		graph export "../plots/event_3_nonroutine_manual.png", replace
		
		stcurve, cif at1(nonroutine_manual_disc_3d = 1) ///
		at2(nonroutine_manual_disc_3d = 2) ///
		at3(nonroutine_manual_disc_3d = 3) ///
		at4(nonroutine_manual_disc_3d = 4) ///
		at5(nonroutine_manual_disc_3d = 5) ///
		lwidth(thick thick thick thick thick) ///
		lcolor("5 0 244" "253 115 0" "1 81 0" "254 70 254" "217 194 99") ///
		title("Non-routine Manual") ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis3, format(%03.2f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis3)) ///
		legend(off row(1) order(1 "0-19" 2 "20-39" 3 "40-59" 4 "60-79" 5 "80-100")) ///
		name("event_3_nonroutine_manual_sep", replace)
		graph save "../plots/event_3_nonroutine_manual_sep.gph", replace
		graph export "../plots/event_3_nonroutine_manual_sep.png", replace
	
	* Event 3 Routine
	stcrreg $eq_routine, compete($competing_events_3) nolog $cluster_se
	estimates store event_3_routine
	
		stcurve, cif title("Routine") lwidth(thick) lcolor(black) ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis3, format(%03.2f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis3)) ///
		name("event_3_routine", replace)
		graph save "../plots/event_3_routine.gph", replace
		graph export "../plots/event_3_routine.png", replace

		stcurve, cif at1(routine_disc_3d = 1) ///
		at2(routine_disc_3d = 2) ///
		at3(routine_disc_3d = 3) ///
		at4(routine_disc_3d = 4) ///
		at5(routine_disc_3d = 5) ///
		lwidth(thick thick thick thick thick) ///
		lcolor("5 0 244" "253 115 0" "1 81 0" "254 70 254" "217 194 99") ///
		title("Routine") ///
		xlabel(, labsize(medium)) xtitle("", size(medium)) ///
		ylabel($range_yaxis3, format(%03.2f) angle(0) labsize(medium)) ytitle("", size(medium)) ///
		yscale(range($range_yaxis3)) ///
		legend(off row(1) order(1 "0-19" 2 "20-39" 3 "40-59" 4 "60-79" 5 "80-100")) ///
		name("event_3_routine_sep", replace)
		graph save "../plots/event_3_routine_sep.gph", replace
		graph export "../plots/event_3_routine_sep.png", replace

	graph combine event_3_analytic ///
	event_3_interactive ///
	event_3_nonroutine_manual ///
	event_3_routine
	graph save "../plots/event_3.gph", replace
	graph export "../plots/event_3.png", replace
	
	grc1leg event_3_analytic_sep ///
	event_3_interactive_sep ///
	event_3_nonroutine_manual_sep ///
	event_3_routine_sep
	graph save "../plots/event_3_sep.gph", replace
	graph export "../plots/event_3_sep.png", replace
	
* Export tables to latex

	* Analytic

	esttab event_1_analytic event_2_analytic event_3_analytic using "../tables/First_Birth_3d/all_events_analytic.tex", replace eform ///
	 nogap noabbrev label ///
	b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
	keep(0.analytic_disc_3d 1.analytic_disc_3d 2.analytic_disc_3d 3.analytic_disc_3d 4.analytic_disc_3d 5.analytic_disc_3d) ///
	order(0.analytic_disc_3d 1.analytic_disc_3d 2.analytic_disc_3d 3.analytic_disc_3d 4.analytic_disc_3d 5.analytic_disc_3d) ///
	mlabel("Employment" "Unemployment" "Second Birth")

	* Interactive

	esttab event_1_interactive event_2_interactive event_3_interactive using "../tables/First_Birth_3d/all_events_interactive.tex", replace eform ///
	 nogap noabbrev label ///
	b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
	keep(0.interactive_disc_3d 1.interactive_disc_3d 2.interactive_disc_3d 3.interactive_disc_3d 4.interactive_disc_3d 5.interactive_disc_3d) ///
	order(0.interactive_disc_3d 1.interactive_disc_3d 2.interactive_disc_3d 3.interactive_disc_3d 4.interactive_disc_3d 5.interactive_disc_3d) ///
	mlabel("Employment" "Unemployment" "Second Birth")

	* Non-routine Manual

	esttab event_1_nonroutine_manual event_2_nonroutine_manual event_3_nonroutine_manual using "../tables/First_Birth_3d/all_events_nonroutine_manual.tex", replace eform ///
	 nogap noabbrev label ///
	b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
	keep(0.nonroutine_manual_disc_3d 1.nonroutine_manual_disc_3d 2.nonroutine_manual_disc_3d 3.nonroutine_manual_disc_3d 4.nonroutine_manual_disc_3d 5.nonroutine_manual_disc_3d) ///
	order(0.nonroutine_manual_disc_3d 1.nonroutine_manual_disc_3d 2.nonroutine_manual_disc_3d 3.nonroutine_manual_disc_3d 4.nonroutine_manual_disc_3d 5.nonroutine_manual_disc_3d) ///
	mlabel("Employment" "Unemployment" "Second Birth")

	* Routine

	esttab event_1_routine event_2_routine event_3_routine using "../tables/First_Birth_3d/all_events_routine.tex", replace eform ///
	 nogap noabbrev label ///
	b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
	keep(0.routine_disc_3d 1.routine_disc_3d 2.routine_disc_3d 3.routine_disc_3d 4.routine_disc_3d 5.routine_disc_3d) ///
	order(0.routine_disc_3d 1.routine_disc_3d 2.routine_disc_3d 3.routine_disc_3d 4.routine_disc_3d 5.routine_disc_3d) ///
	mlabel("Employment" "Unemployment" "Second Birth")

* Full tables

	* Analytic

	esttab event_1_analytic event_2_analytic event_3_analytic using "../tables/First_Birth_3d/full_all_events_analytic.tex", replace eform ///
	 nogap noabbrev label ///
	b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
	mlabel("Employment" "Unemployment" "Second Birth")

	* Interactive

	esttab event_1_interactive event_2_interactive event_3_interactive using "../tables/First_Birth_3d/full_all_events_interactive.tex", replace eform ///
	 nogap noabbrev label ///
	b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
	mlabel("Employment" "Unemployment" "Second Birth")

	* Non-routine Manual

	esttab event_1_nonroutine_manual event_2_nonroutine_manual event_3_nonroutine_manual using "../tables/First_Birth_3d/full_all_events_nonroutine_manual.tex", replace eform ///
	 nogap noabbrev label ///
	b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
	mlabel("Employment" "Unemployment" "Second Birth")

	* Routine

	esttab event_1_routine event_2_routine event_3_routine using "../tables/First_Birth_3d/full_all_events_routine.tex", replace eform ///
	 nogap noabbrev label ///
	b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
	mlabel("Employment" "Unemployment" "Second Birth")

log close	