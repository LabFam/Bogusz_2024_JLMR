* HONORATA BOGUSZ -- 3. DESCRIPTIVES 3d *

clear

log using "../logs/3_Descriptives.log", text replace

set scheme s1mono

use "../data/final_data/data_for_analysis_1st_birth.dta", clear
replace child1_birth = mofd(child1_birth)
format child1_birth %tmCYN
replace time = mofd(time)
format time %tmCYN
replace duration = time - child1_birth

* 1. Tab unique values

foreach v in child_1_birth_y event_y event_2y event age_disc cohort max_east_child max_education_child analytic_disc_3d interactive_disc_3d nonroutine_manual_disc_3d routine_disc_3d max_analytic_child_2d max_interactive_child_2d max_nonroutine_manual_child_2d max_routine_child_2d {
	tab `v'
}

foreach v in event age_disc cohort max_east_child max_education_child analytic_disc_3d interactive_disc_3d nonroutine_manual_disc_3d routine_disc_3d max_analytic_child_2d max_interactive_child_2d max_nonroutine_manual_child_2d max_routine_child_2d {
	tab `v' child_1_birth_y
}

foreach v in age_disc cohort max_east_child max_education_child analytic_disc_3d interactive_disc_3d nonroutine_manual_disc_3d routine_disc_3d max_analytic_child_2d max_interactive_child_2d max_nonroutine_manual_child_2d max_routine_child_2d {
	tab `v' event
}

foreach v in age_disc cohort max_east_child max_education_child analytic_disc_3d interactive_disc_3d nonroutine_manual_disc_3d routine_disc_3d max_analytic_child_2d max_interactive_child_2d max_nonroutine_manual_child_2d max_routine_child_2d {
	tab `v' event_1
}

sum child_1_birth_y event_y duration max_ep_child

hist duration if event==1, percent title("Employment") ytitle("% Mothers") xtitle("Months") bcolor(black) ///
xscale(range(0(20)100)) xlabel(0(20)100, labsize(medium)) yscale(range(0(10)30)) ylabel(0(10)30, labsize(medium)) ///
name(hist_empl, replace)
//graph save "../plots/hist_duration_empl.gph", replace
//graph export "../plots/hist_duration_empl.png", replace

hist duration if event==2, percent title("Unemployment") ytitle("% Mothers") xtitle("Months") bcolor(black) ///
xscale(range(0(20)100)) xlabel(0(20)100, labsize(medium)) yscale(range(0(10)30)) ylabel(0(10)30, labsize(medium)) ///
name(hist_unmpl, replace)
//graph save "../plots/hist_duration_unempl.gph", replace
//graph export "../plots/hist_duration_unempl.png", replace

hist duration if event==3, percent title("Second Birth") ytitle("% Mothers") xtitle("Months") bcolor(black) ///
xscale(range(0(20)100)) xlabel(0(20)100, labsize(medium)) yscale(range(0(10)30)) ylabel(0(10)30, labsize(medium)) ///
name(hist_child2, replace)
//graph save "../plots/hist_duration_sb.gph", replace
//graph export "../plots/hist_duration_sb.png", replace

hist duration if event==4, percent title("Censored") ytitle("% Mothers") xtitle("Months") bcolor(black) ///
xscale(range(0(20)100)) xlabel(0(20)100, labsize(medium)) yscale(range(0(10)30)) ylabel(0(10)30, labsize(medium)) ///
name(hist_censored, replace)
//graph save "../plots/hist_duration_censored.gph", replace
//graph export "../plots/hist_duration_censored.png", replace

graph combine hist_empl hist_unmpl hist_child2 hist_censored
graph save "../plots/hist_duration_by_event.gph", replace
graph export "../plots/hist_duration_by_event.png", replace

sum max_analytic_child_3d max_interactive_child_3d max_nonroutine_manual_child_3d max_routine_child_3d

bys child_1_birth_y: sum max_analytic_child_3d max_interactive_child_3d max_nonroutine_manual_child_3d max_routine_child_3d

corr max_ep_child max_analytic_child_3d max_interactive_child_3d max_nonroutine_manual_child_3d max_routine_child_3d

* 2. Histograms of task measures

foreach v in max_analytic_child_3d max_interactive_child_3d max_nonroutine_manual_child_3d max_routine_child_3d {

	hist `v', percent title(`: variable label `v'') bcolor(black) ///
	xscale(range(0(20)100)) xlabel(0(20)100, labsize(medium)) xtitle("") ///
	yscale(range(0(10)30)) ylabel(0(10)30, labsize(medium)) ytitle("% Mothers") ///
	name(`v', replace)
	
}

graph combine max_analytic_child_3d max_interactive_child_3d max_nonroutine_manual_child_3d max_routine_child_3d
graph save "../plots/hist_all_task_measures_3d.gph", replace
graph export "../plots/hist_all_task_measures_3d.png", replace

foreach v in max_analytic_child_2d max_interactive_child_2d max_nonroutine_manual_child_2d max_routine_child_2d {

	hist `v', percent title(`: variable label `v'') bcolor(black) ///
	xscale(range(0(20)100)) xlabel(0(20)100, labsize(medium)) xtitle("") ///
	yscale(range(0(10)30)) ylabel(0(10)30, labsize(medium)) ytitle("% Mothers") ///
	name(`v', replace)
	
}

graph combine max_analytic_child_2d max_interactive_child_2d max_nonroutine_manual_child_2d max_routine_child_2d
graph save "../plots/hist_all_task_measures_2d.gph", replace
graph export "../plots/hist_all_task_measures_2d.png", replace

graph combine max_analytic_child_3d max_interactive_child_3d max_nonroutine_manual_child_3d max_routine_child_3d, title("3-digits") name(hist_sample_3d, replace)
graph combine max_analytic_child_2d max_interactive_child_2d max_nonroutine_manual_child_2d max_routine_child_2d, title("2-digits") name(hist_sample_2d, replace)
graph combine hist_sample_3d hist_sample_2d
graph save "../plots/hist_all_task_measures_both.gph", replace
graph export "../plots/hist_all_task_measures_both.png", replace

corr max_analytic_child_3d max_analytic_child_2d
corr max_interactive_child_3d max_interactive_child_2d
corr max_nonroutine_manual_child_3d max_nonroutine_manual_child_2d
corr max_routine_child_3d max_routine_child_2d

* 3. Task measures in time

* by child 1 birth year

collapse max_analytic_child_3d max_interactive_child_3d max_nonroutine_manual_child_3d max_routine_child_3d, by(child_1_birth_y) 

twoway (line max_analytic_child_3d child_1_birth_y, lwidth(thick) lcolor(black) lpattern(solid)) ///
(line max_interactive_child_3d child_1_birth_y, lwidth(thick) lcolor(black) lpattern(dash)) ///
(line max_nonroutine_manual_child_3d child_1_birth_y, lwidth(thick) lcolor(black) lpattern(dot)) ///
(line max_routine_child_3d child_1_birth_y, lwidth(thick) lcolor(black) lpattern(shortdash)), ///
legend(row(3) order(1 "Analytic" 2 "Interactive" 3 "Non-routine Manual" 4 "Routine")) ///
xlabel(2012(1)2018, labsize(medium)) xtitle("") ///
yscale(range(0(20)100)) ylabel(0(20)100, angle(0) labsize(medium)) ytitle("") ///
title("")
graph save "../plots/mean_tm_child1_y.gph", replace
graph export "../plots/mean_tm_child1_y.png", replace

* by event year

use "../data/generated_monthly/data_for_analysis_1st_birth.dta", clear
collapse max_analytic_child_3d max_interactive_child_3d max_nonroutine_manual_child_3d max_routine_child_3d, by(event_y) 

twoway (line max_analytic_child_3d event_y, lwidth(thick) lcolor(black) lpattern(solid)) ///
(line max_interactive_child_3d event_y, lwidth(thick) lcolor(black) lpattern(dash)) ///
(line max_nonroutine_manual_child_3d event_y, lwidth(thick) lcolor(black) lpattern(dot)) ///
(line max_routine_child_3d event_y, lwidth(thick) lcolor(black) lpattern(shortdash)), ///
legend(row(3) order(1 "Analytic" 2 "Interactive" 3 "Non-routine Manual" 4 "Routine")) ///
xlabel(2012(1)2020, labsize(medium)) xtitle("") ///
yscale(range(0(20)100)) ylabel(0(20)100, angle(0) labsize(medium)) ytitle("") ///
title("")
graph save "../plots/mean_tm_event_y.gph", replace
graph export "../plots/mean_tm_event_y.png", replace

* 3. Event incidence

* by child 1 birth year

use "../data/generated_monthly/data_for_analysis_1st_birth.dta", clear
collapse event_1 event_2 event_3 event_4, by(child_1_birth_y) 

twoway (line event_1 child_1_birth_y, lwidth(thick) lcolor(black) lpattern(solid)) ///
(line event_2 child_1_birth_y, lwidth(thick) lcolor(black) lpattern(dash)) ///
(line event_3 child_1_birth_y, lwidth(thick) lcolor(black) lpattern(dot)) ///
(line event_4 child_1_birth_y, lwidth(thick) lcolor(black) lpattern(shortdash)), ///
legend(row(2) order(1 "Employment" 2 "Unemployment" 3 "Second Birth" 4 "Censored")) ///
xlabel(2012(1)2018, labsize(medium)) xtitle("") ///
yscale(range(0(0.2)1)) ylabel(0(0.2)1, angle(0) format(%03.1f) labsize(medium)) ytitle("") ///
title("")
graph save "../plots/share_event_child1_y.gph", replace
graph export "../plots/share_event_child1_y.png", replace

* by event year

use "../data/generated_monthly/data_for_analysis_1st_birth.dta", clear
collapse event_1 event_2 event_3 event_4, by(event_y) 

twoway (line event_1 event_y, lwidth(thick) lcolor(black) lpattern(solid)) ///
(line event_2 event_y, lwidth(thick) lcolor(black) lpattern(dash)) ///
(line event_3 event_y, lwidth(thick) lcolor(black) lpattern(dot)) ///
(line event_4 event_y, lwidth(thick) lcolor(black) lpattern(shortdash)), ///
legend(row(2) order(1 "Employment" 2 "Unemployment" 3 "Second Birth" 4 "Censored")) ///
xlabel(2012(1)2020, labsize(medium)) xtitle("") ///
yscale(range(0(0.2)1)) ylabel(0(0.2)1, angle(0) format(%03.1f) labsize(medium)) ytitle("") ///
title("")
graph save "../plots/share_event_event_y.gph", replace
graph export "../plots/share_event_event_y.png", replace

* 4. Histograms of task aggregate data

use "../data/original/task_measures_all_2006_occ_3d.dta", clear
hist n, percent title("3-digits") ytitle("% Occupations (Total = 144)") xtitle("Number of cases") bcolor(black) yscale(range(0(20)60)) ylabel(0(20)60, labsize(medium)) xscale(range(0(850)1700)) xlabel(0(850)1700, labsize(medium)) name(hist_3d, replace)

use "../data/original/task_measures_all_2006_occ_2d.dta", clear
hist n, percent title("2-digits") ytitle("% Occupations (Total = 37)") xtitle("Number of cases") bcolor(black) yscale(range(0(20)60)) ylabel(0(20)60, labsize(medium)) xscale(range(0(850)1700)) xlabel(0(850)1700, labsize(medium)) name(hist_2d, replace)

graph combine hist_3d hist_2d
graph save "../plots/hist_task_n.gph", replace
graph export "../plots/hist_task_n.png", replace

log close