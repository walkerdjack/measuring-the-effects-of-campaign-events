/*-----------------------------------------------------------------------------
Public Replication Archive

Lockhart, M., Huber, G. A., Gerber, A. S., & Walker, J. D. II. [Date]. 
"Measuring the Effects of Campaign Events: Specifying and Comparing Estimates of the Effect of Trump's Conviction." Political Science Research and Methods.
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Table of contents:
	I. 		Data preparation			Line 17			
	II. 	Recode variables			Line 23
	III. 	Begin main text tables		Line 152
	IV.		Begin appendix tables 		Line 264
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
I. DATA PREPARATION
------------------------------------------------------------------------------*/

use "psrm_lockhart_etal_public.dta", clear

/*------------------------------------------------------------------------------
II. RECODE VARIABLES
------------------------------------------------------------------------------*/

* Recode variables to identify different types of Trump voters.
recode g4w16_vote_if_trump_guilty (1=0) (2=1) (3=0) (4=0) (5=0) (*=.), gen (vote_if_trump_guilty)
label var vote_if_trump_guilty "If Donald Trump is found guilty of falsifying business records, who would you vote for in November?"
label define vote_if_trump_guilty_lab 0 "Joe Biden/Someone else/Not sure/Will not vote" 1 "Donald Trump"
label values vote_if_trump_guilty vote_if_trump_guilty_lab

recode g4w16_vote_if_trump_not_guilty (1=0) (2=1) (3=0) (4=0) (5=0) (*=.), gen (vote_if_trump_not_guilty)
label var vote_if_trump_not_guilty "If Donald Trump is not found guilty of falsifying business records, who would you vote for in November?"
label define vote_if_trump_not_guilty_lab 0 "Joe Biden/Someone else/Not sure/Will not vote" 1 "Donald Trump"
label values vote_if_trump_not_guilty vote_if_trump_not_guilty_lab

gen conflicted_voters = (vote_if_trump_not_guilty == 1 & vote_if_trump_guilty == 0)
label var conflicted_voters "Conditional voter (binary)"

gen unconditional_voters = (vote_if_trump_not_guilty == 1 & vote_if_trump_guilty == 1)
label var unconditional_voters "Unconditional voter (binary)"

gen not_trump = (vote_if_trump_not_guilty == 0 & vote_if_trump_guilty == 0)
label var conflicted_voters "Not Trump voter (binary)"

* Recode vote choice for every survey week.
recode g4w4_heat_biden_trump (1=0) (2=1) (3=0) (4=0) (5=0) (*=.), gen(week_4_rc)
label var week_4_rc "Week 4 Vote Choice (1=Trump, 0=Everything else)"

recode b1_heat_biden_trump (1=0) (2=1) (3=0) (4=0) (5=0) (*=.), gen(b1_rc)
label var b1_rc "Baseline 1 Vote Choice (1=Trump, 0=Everything else)"

recode g4w8_heat_biden_trump (1=0) (2=1) (3=0) (4=0) (5=0) (*=.), gen(week_8_rc)
label var week_8_rc "Week 8 Vote Choice (1=Trump, 0=Everything else)"

recode g4w12_presvote24 (1=0) (2=1) (11=0) (12=0) (13=0) (88=0) (98=0) (99=0) (*=.), gen(week_12_rc)
label var week_12_rc "Week 12 Vote Choice (1=Trump, 0=Everything else)"

recode b2_presvote24 (1=0) (2=1) (11=0) (12=0) (13=0) (88=0) (98=0) (99=0) (*=.), gen(b2_rc)
label var b2_rc "Baseline 2 Vote Choice (1=Trump, 0=Everything else)"

recode g4w16_presvote24 (1=0) (2=1) (11=0) (12=0) (13=0) (88=0) (98=0) (99=0) (*=.), gen(week_16_rc)
label var week_16_rc "Week 16 Vote Choice (1=Trump, 0=Everything else)"

recode g4w20_presvote24 (1=0) (2=1) (11=0) (12=0) (13=0) (88=0) (98=0) (99=0) (*=.), gen(week_20_rc)
label var week_20_rc "Week 20 Vote Choice (1=Trump, 0=Everything else)"

recode deb_presvote24_pre (1=0) (2=1) (11=0) (12=0) (13=0) (88=0) (98=0) (99=0) (*=.), gen(week_24_rc)
label var week_24_rc "Week 24 Vote Choice (1=Trump, 0=Everything else)"

recode g4w28_presvote24h (1=0) (2=1) (11=0) (12=0) (13=0) (88=0) (98=0) (99=0) (*=.), gen(week_28_rc)
label var week_28_rc "Week 28 Vote Choice (1=Trump, 0=Everything else)"

recode g4w32_presvote24h (1=0) (2=1) (11=0) (12=0) (13=0) (88=0) (98=0) (99=0) (*=.), gen(week_32_rc)
label var week_32_rc "Week 32 Vote Choice (1=Trump, 0=Everything else)"

* Recode additional control variables.
recode g4w20_baseline_presvote20post (1=0) (2=1) (3=0) (4=0) (5=0) (6=0) (*=.), gen(g4w20_baseline_presvote20post_rc)
label define lab_1 1 "2020 Vote Choice = Donald Trump" 0 "2020 Vote Choice = Everything else"
label values g4w20_baseline_presvote20post_rc lab_1

recode g4w20_baseline_pid7 (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (*=.), gen(g4w20_baseline_pid7_rc)
label define lab_2 1 "Party ID = Strong Democrat" 2 "Party ID = Not very strong Democrat" 3 "Lean Democrat" 4 "Independent" 5 "Lean Republican" 6 "Not very strong Republican" 7 "Strong Republican" 8 "Not sure"
label values g4w20_baseline_pid7_rc lab_2

recode g4w20_baseline_age4 (1=1) (2=2) (3=3) (4=4) (*=.), gen (g4w20_baseline_age4_rc)
label define lab_3 1 "Age = Under 30" 2 "Age = 30-44" 3 "45-64" 4 "65+"
label values g4w20_baseline_age4_rc lab_3

recode g4w20_baseline_educ4 (1=1) (2=2) (3=3) (4=4) (*=.), gen (g4w20_baseline_educ4_rc)
label define lab_4 1 "Education level = HS or less" 2 "Education level = Some college" 3 "College grad" 4 "Postgrad"
label values g4w20_baseline_educ4_rc lab_4

recode g4w20_baseline_race4 (1=1) (2=2) (3=3) (4=4) (*=.), gen (g4w20_baseline_race4_rc)
label define lab_5 1 "Race/ethnicity = White" 2 "Race/ethnicity = Black" 3 "Hispanic" 4 "Other"
label values g4w20_baseline_race4_rc lab_5

* Recode survey times.
gen pre_guilty = (g4w20_trump_hush_verdict_announc == 2)
gen post_guilty = (g4w20_trump_hush_verdict_announc == 1)

* Generate week 16 placebo for week 20 timing.
generate double week16time = g4w16_starttime + mdyhms(1,1,1960,0,0,0)
format week16time %tc
list week16time in 1/6
gen day345 = week16time > mdyhms(5,03,2024,0,0,0)

* Generate indicators for when respondents took survey.
gen took_week_4 = week_4_rc != .
label var took_week_4 "Week 4 Respondent"
gen took_week_8 = week_8_rc != .
label var took_week_8 "Week 8 Respondent"
gen took_week_12 = week_12_rc != .
label var took_week_12 "Week 12 Respondent"
gen took_week_20 = week_20_rc != .
label var took_week_20 "Week 20 Respondent"
gen took_week_24 = week_24_rc != .
label var took_week_24 "Week 24 Respondent"
gen took_week_28 = week_28_rc != .
label var took_week_28 "Week 28 Respondent"

* Recode variables related to change in vote choice.
gen actual_change = week_20_rc - week_16_rc
label define actual_change_lab -1 ""

recode g4w20_trump_hush_trial_vote (1=2) (2=1) (3=0) (4=-1) (5=-2) (6=0) (*=.), gen(reported_change_rc)
label var reported_change_rc "Week 20: How Conviction Changed Trump Support (-2-2)"

* Generate measure of "Trumpiness," or how often respondent says they would support Trump.
gen week_4_trump = (week_4_rc == 1)
gen b1_trump = (b1_rc == 1)
gen week_8_trump = (week_8_rc == 1)
gen week_12_trump = (week_12_rc == 1)
gen b2_trump = (b2_rc == 1)

egen weeks_support_trump = rowtotal(week_4_trump b1_trump week_8_trump week_12_trump b2_trump)
gen weeks_answered = (week_4_rc!=.) + (b1_rc!=.) + (week_8_rc!=.) + (week_12_rc!=.) + (b2_rc!=.)
gen prop_weeks_trump = weeks_support_trump/weeks_answered

gen voterstatus = 1 if conflicted_voters==1
replace voterstatus = 2 if unconditional_voters==1
replace voterstatus = 3 if not_trump==1

label define labvoterstatus 1 "Conditional Trump Supporter" 2 "Unconditional Trump Supporter" 3 "Everyone else"
label values voterstatus labvoterstatus

* Recode prediction variable.
recode g4w16_trump_convicted_manhattan (1=1) (2=0) (3=0.5) (*=.), gen(week16_p)
label var week16_p "Do you think Donald Trump will be convicted? (Week 16 binary)"

/*------------------------------------------------------------------------------
III. BEGIN MAIN TEXT TABLES
------------------------------------------------------------------------------*/

* Table 1.

preserve
	* Col. 1. "Weighted."
reg week_20_rc post_guilty [aweight=g4w20_weight] if week_16_rc == 1, robust
eststo tab1_col1
	* Col. 2. "Unweighted."
reg week_20_rc post_guilty if week_16_rc == 1, robust
eststo tab1_col2
	* Col. 3. "With controls."
reg week_20_rc post_guilty g4w20_baseline_presvote20post_rc g4w20_baseline_pid7_rc g4w20_baseline_age4_rc g4w20_baseline_educ4_rc g4w20_baseline_race4_rc [aweight=g4w20_weight] if week_16_rc == 1, robust
eststo tab1_col3
	* Combine.
esttab tab1_col1 tab1_col2 tab1_col3 using "tab1.rtf", ///
    replace ///
    title("Table 1. Linear regression of week 20 vote choice on post-verdict respondents, among week 16 Trump supporters with robust standard errors. Weighted analysis.") ///
    b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2, fmt(%9.0f %9.3f)) ///
    drop(g4w20_baseline_*) ///
	varlabels(post_guilty "Post-Guilty Verdict" ///
              _cons "Constant")  ///
    varwidth(30) ///
	mtitles("Weighted" "Unweighted" "With controls") ///
    label ///
    compress      ///
    nonumber nogaps noomitted nobaselevels
restore

* Table 2.

preserve
	* Col. 1. "Percent supporting Trump in Week 20." (Note that the below table includes columns and rows omitted from the main text. Here, column 2 ("0") is the column of interest.)
asdoc tab reported_change_rc actual_change if week_16_rc == 1 [aweight=g4w20_weight], row replace save(tab2_col1.doc)
	* Col. 2. "Percent of sample." (Note that the below table was combined manually with the above table in the main text for formatting flexibility.)
scalar row1_total = 2.70
scalar row2_total = 26.47
scalar row3_total = 449.14
scalar row4_total = 45.84
scalar row5_total = 801.85
scalar total_sample = 1326

scalar prop_row1 = row1_total / total_sample
scalar prop_row2 = row2_total / total_sample
scalar prop_row3 = row3_total / total_sample
scalar prop_row4 = row4_total / total_sample
scalar prop_row5 = row5_total / total_sample

clear

set obs 5
gen str20 category = ""
gen proportion = .

replace category = "Much less likely" in 1
replace category = "Somewhat less likely" in 2
replace category = "No change" in 3
replace category = "Somewhat more likely" in 4
replace category = "Much more likely" in 5

replace proportion = `=prop_row1' in 1
replace proportion = `=prop_row2' in 2
replace proportion = `=prop_row3' in 3
replace proportion = `=prop_row4' in 4
replace proportion = `=prop_row5' in 5

asdoc list category proportion, replace save(tab2_col2.doc)

restore

* Table 3.

	* Col. 2 "Percent (among week 16 Trump supporters)." (Note that the below table includes columns omitted from the main text. Here, column 2 ("Percent") is the column of interest. Note also that "Everyone else" is relabeled to "Reverse Conditional." Finally, two columns are manually added for explanatory purposes: "Vote if guilty" and "Vote if not guilty.")
preserve
asdoc tab voterstatus if week_16_rc==1 [aweight=g4w16_weight], replace save(tab3.doc)
restore

* Table 4.

preserve
	* Col. 1. "Causal Estimate: Week 20 Vote Choice."
reg week_20_rc post_guilty##i.conflicted_voters [aweight=g4w20_weight] if vote_if_trump_not_guilty==1, robust
eststo tab4_col1
	* Col. 2. "Placebo Outcome: Week 4 Vote Choice."
reg week_4_rc post_guilty##i.conflicted_voters [aweight = g4w4_weight] if vote_if_trump_not_guilty==1, robust
eststo tab4_col2
	* Col. 3. "Placebo Outcome: Week 8 Vote Choice."
reg week_8_rc post_guilty##i.conflicted_voters [aweight = g4w8_weight] if vote_if_trump_not_guilty==1, robust
eststo tab4_col3
	* Col. 4. "Placebo Outcome: Week 12 Vote Choice."
reg week_12_rc post_guilty##i.conflicted_voters [aweight=g4w12_weight] if vote_if_trump_not_guilty==1, robust
eststo tab4_col4
	* Combine.
esttab tab4_col1 tab4_col2 tab4_col3 tab4_col4 using "tab4.rtf", ///
    replace ///
    title("Table 4. Combined test and placebo tests of conditional Trump support on vote choice among week 16 Trump supporters with robust standard errors. Weighted analysis.") ///
    b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2, fmt(%9.0f %9.3f)) ///
	varlabels(1.post_guilty "Post-Guilty Verdict" ///
              1.conflicted_voters "Conditional Supporter" ///
              1.post_guilty#1.conflicted_voters "Post-Guilty Verdict X Conditional Support" ///
				_cons "Constant")  ///
    varwidth(30) ///
	mtitles("Causal Estimate: Week 20 Vote Choice" "Placebo Outcome: Week 4 Vote Choice" "Week 8 Vote Choice" "Placebo Outcome: Week 12 Vote Choice") ///
    label ///
    compress      ///
    nonumber nogaps noomitted nobaselevels
restore

/*------------------------------------------------------------------------------
III. BEGIN APPENDIX TABLES
------------------------------------------------------------------------------*/

* Table A1. (Note that this table was computed directly in the Stata console and input manually in the main text for formatting flexibility. It is pasted below and commented out.)

preserve
	* Col. 1. "Absolute value of vote choice if guilty-week 16 vote choice: y*(1)-week 16."
gen y1_week16 = abs(vote_if_trump_guilty - week_16_rc)
label var y1_week16 "y(1)-week 16 vote choice"
	* Col. 2. "Absolute value of vote choice if not guilty-week 16 vote choice: y*(0)-week 16."
gen y0_week16 = abs(vote_if_trump_not_guilty - week_16_rc)
label var y0_week16 "y(0)-week 16 vote choice"
	* Col. 3. "Difference."
gen diff_y1_y0_week16 = y1_week16 - y0_week16
label var diff_y1_y0_week16 "Difference"
	* Combine.
estpost tabstat y1_week16 y0_week16 diff_y1_y0_week16, by(week16_p) stats(mean) columns(var)
/*
    week16_p | e(y1_~16)  e(y0_~16)  e(dif~16) 
-------------+---------------------------------
           0 |  .0734206    .035877   .0376497 
  _missing_5 |  .0687057   .0407621   .0279751 
           1 |  .0240964   .0175682   .0064905 
-------------+---------------------------------
       Total |  .0544482     .03125   .0232068 
*/
restore

* Table A2.

preserve
	* Analyze full sample.
keep if week_16_rc!=. & week_20_rc !=.
gen vote_16 = week_16_rc
gen vote_20 = week_20_rc
version 18: reshape long vote_, i(newid) j(time)   
tab vote_ time
	* Genereate post-treatment indicator.
gen post = (time == 20)
	* Col. 1. "DiD Weighted."
reg vote_ i.post_guilty##i.post [aweight=g4w20_weight], cluster(newid)
eststo taba2_col1
estadd scalar obs = e(N_clust)
	* Col. 2. "DiD Unweighted."
reg vote_ i.post_guilty##i.post , cluster(newid)
eststo taba2_col2
estadd scalar obs = e(N_clust)
	* Col. 3. "DiD Weighted w/ Controls."
reg vote_ i.post_guilty##i.post i.g4w20_baseline_presvote20post_rc i.g4w20_baseline_pid7_rc i.g4w20_baseline_age4_rc i.g4w20_baseline_educ4_rc i.g4w20_baseline_race4_rc [aweight=g4w20_weight], cluster(newid)
eststo taba2_col3
estadd scalar obs = e(N_clust)
	* Combine.
esttab taba2_col1 taba2_col2 taba2_col3 using "taba2.rtf", ///
    replace ///
    title("Linear regression of vote choice by week and post-verdict indicator, with robust standard errors.") ///
    b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
	stats(r2_a obs, fmt(%9.3f %9.0f) labels("Adj R-squared" "N")) ///
	varlabels(1.post_guilty "Post-Guilty Verdict" ///
				1.post "Week 20 Response" ///
				1.post_guilty#1.post "Post-Guilty X Week 20" ///
              _cons "Constant")  ///
	 keep(1.post_guilty 1.post 1.post_guilty#1.post _cons)   ///
    varwidth(30) ///
	mtitles("DiD Weighted" "DiD Unweighted" "DiD Weighted w/ Controls") ///
    label ///
    compress      ///
    nonumber nogaps noomitted nobaselevels	
restore

* Table A3.

preserve
reg week_20_rc post_guilty g4w20_baseline_presvote20post_rc g4w20_baseline_pid7_rc g4w20_baseline_age4_rc g4w20_baseline_educ4_rc g4w20_baseline_race4_rc [aweight=g4w20_weight] if week_16_rc == 1, robust
eststo taba3

esttab taba3 using "taba3.rtf", ///
    replace ///
    title("Linear regression of week 20 vote choice on post-verdict respondents, among week 16 Trump supporters with robust standard errors, weighted. With baseline controls.") ///
    b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2, fmt(%9.0f %9.3f)) ///
	varlabels(post_guilty "Post-Guilty Verdict" ///
			g4w20_baseline_presvote20post_rc "2020 Vote Choice" ///
			g4w20_baseline_pid7_rc "Party ID" ///
			g4w20_baseline_age4_rc "Age" ///
			g4w20_baseline_educ4_rc "Education level" ///
			g4w20_baseline_race4_rc "Race" ///
              _cons "Constant")  ///
    varwidth(30) ///
	mtitles("Week 20 Vote Choice (1=Trump, 0=Everything else)") ///
    label ///
    compress      ///
    nonumber nogaps noomitted nobaselevels
restore
	
* Table A4.

preserve
	* Col. 1. "Week 8 placebo" (Note that "w8_early" will appear in its own row in the final combined output but that it is a functionally similar regressor to "post_guilty" below.)
gen double w8_surveytime = g4w8_starttime + mdyhms(1,1,1960,0,0,0)
format w8_surveytime %tc
	* Use when respondents started the survey and generate their percentile scores for how early they took it.
xtile w8_percent = w8_surveytime, nq(100)
gen w8_early = (w8_percent <= 40)

reg week_8_rc w8_early [aweight=g4w20_weight] if week_4_rc == 1, robust
eststo taba4_col1
	* Col. 2. "Imputing missing data."
replace post_guilty = 1 if week_20_rc == . & week_16_rc != .
replace week_20_rc = week_28_rc if week_20_rc == . & week_16_rc != .
replace week_20_rc = week_32_rc if week_20_rc == . & week_16_rc != .

reg week_20_rc post_guilty [aweight=g4w16_weight] if vote_if_trump_not_guilty == 1, robust
eststo taba4_col2
	* Col. 3. "IV model."
	* Use early survey timing as an instrument for itself.
generate double w4_surveytime = g4w4_starttime + mdyhms(1,1,1960,0,0,0)
format w4_surveytime %tc
generate double w8_surveytime2 = g4w8_starttime + mdyhms(1,1,1960,0,0,0)
format w8_surveytime2 %tc
generate double w12_surveytime = g4w12_starttime + mdyhms(1,1,1960,0,0,0)
format w12_surveytime %tc
generate double w16_surveytime = g4w16_starttime + mdyhms(1,1,1960,0,0,0)
format w16_surveytime %tc
	* Use when respondents started the survey and generate their percentile scores for how early they took it.
xtile w4_percent = w4_surveytime, nq(100)
gen w4_early = (w4_percent <= 40)
xtile w8_percent2 = w8_surveytime2, nq(100)
gen w8_early2 = (w8_percent2 <= 40)
xtile w12_percent = w12_surveytime, nq(100)
gen w12_early = (w12_percent <= 40)
xtile w16_percent = w16_surveytime, nq(100)
gen w16_early = (w16_percent <= 40)

gen instrument  = w4_early + w8_early2 + w12_early + w16_early
replace instrument = . if (w4_surveytime==.|w8_surveytime==.|w12_surveytime==.|w16_surveytime==.)

ivregress 2sls week_20_rc (post_guilty = instrument) [aweight=g4w20_weight] if week_16_rc == 1, robust
eststo taba4_col3
predict yhat if e(sample)
gen resid = week_20_rc - yhat if e(sample)
gen sq_resid = resid^2
gen sq_total = (week_20_rc - r(mean))^2 if e(sample)
	* Weighted R-sq:
sum week_20_rc [aweight=g4w20_weight] if e(sample)
scalar ybar = r(mean)
gen total_dev = (week_20_rc - ybar)^2 if e(sample)
gen resid_dev = resid^2
	* Sum of squares
sum total_dev [aweight=g4w20_weight] if e(sample)
scalar ss_total = r(sum)

sum resid_dev [aweight=g4w20_weight] if e(sample)
scalar ss_resid = r(sum)
	* R^2
display "R-squared = " 1 - ss_resid/ss_total
	*Combine.
esttab taba4_col1 taba4_col2 taba4_col3 using "taba4.rtf", ///
    replace ///
    title("Linear regression of week 20 vote choice on post-verdict respondents, among week 16 Trump supporters with robust standard errors. Weighted analysis.") ///
    b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2, fmt(%9.0f %9.3f)) ///
    varlabels(w8_early "Post-Guilty Verdict" ///
	post_guilty "Post-Guilty Verdict" ///
        _cons "Constant") ///
    varwidth(30) ///
    mtitles("Week 8 placebo" "Imputing missing data" "IV model") ///
    label ///
    compress ///
    nonumber nogaps noomitted nobaselevels
restore

* Table A5.

preserve
	* Col. 1. "Week 4 Vote Choice."
reg week_4_rc post_guilty [aweight = g4w4_weight] if week_16_rc == 1, robust
eststo taba5_col1
	* Col. 2. "Week 8 Vote Choice."
reg week_8_rc post_guilty [aweight = g4w8_weight] if week_16_rc == 1, robust
eststo taba5_col2	
	* Col. 3. "Week 12 Vote Choice."
reg week_12_rc post_guilty [aweight=g4w12_weight] if week_16_rc == 1, robust
eststo taba5_col3
	* Combine.
esttab taba5_col1 taba5_col2 taba5_col3 using "taba5.rtf", ///
    replace ///
    title("Combined placebo tests of vote choice on post-verdict respondents, among week 16 Trump supporters with robust standard errors. Weighted analysis.") ///
    b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2, fmt(%9.0f %9.3f)) ///
	varlabels(post_guilty "Post-Guilty Verdict" ///
				_cons "Constant")  ///
    varwidth(30) ///
	mtitles("Week 4 Vote Choice" "Week 8 Vote Choice" "Week 12 Vote Choice") ///
    label ///
    compress      ///
    nonumber nogaps noomitted nobaselevels
restore

* Table A6.

preserve
reg post_guilty i.g4w20_baseline_presvote20post_rc i.g4w20_baseline_pid7_rc i.g4w20_baseline_age4_rc i.g4w20_baseline_educ4_rc i.g4w20_baseline_race4_rc [aweight=g4w20_weight] if vote_if_trump_not_guilty==1, robust
eststo taba6

esttab taba6 using "taba6.rtf", ///
    replace ///
    title("Linear regression of post-verdict response among week 16 Trump voters with robust standard errors, weighted") ///
    b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2, fmt(%9.0f %9.3f)) ///
    varwidth(30) ///
    mtitles("Post-verdict response (binary), weighted") ///
    compress      ///
    nonumber nogaps noomitted nobaselevels label
restore

* Table A7.

preserve
	* Cols. 1–3. (Note that the below table includes rows omitted from the main text. Here, percentages are the rows of interest.)
asdoc tab reported_change_rc actual_change [aweight=g4w20_weight], row replace save(taba7_cols1to3.doc)
	* Col. 4. "Proportion of sample." (Note that the below table was combined manually with the above table in the main text for formatting flexibility.)
scalar row1_total = 680.29
scalar row2_total = 92.44
scalar row3_total = 1554.46
scalar row4_total = 86.06
scalar row5_total = 905.76
scalar total_sample = 3319

scalar prop_row1 = row1_total / total_sample
scalar prop_row2 = row2_total / total_sample
scalar prop_row3 = row3_total / total_sample
scalar prop_row4 = row4_total / total_sample
scalar prop_row5 = row5_total / total_sample

clear
set obs 5

gen str20 category = ""
gen proportion = .

replace category = "Much less likely" in 1
replace category = "Somewhat less likely" in 2
replace category = "No change" in 3
replace category = "Somewhat more likely" in 4
replace category = "Much more likely" in 5

replace proportion = `=prop_row1' in 1
replace proportion = `=prop_row2' in 2
replace proportion = `=prop_row3' in 3
replace proportion = `=prop_row4' in 4
replace proportion = `=prop_row5' in 5

asdoc list category proportion, replace save(taba7_col4.doc)
restore

* Table A8.

preserve
	* Recode to omit negative values for regression.
recode reported_change_rc (-2 = 1) (-1 = 2) (0 = 3) (1 = 4) (2 = 5)
label define reported_change_rc_lab 1 "Much less likely" 2 "Somewhat less likely" 3 "No change" 4 "Somewhat more likely" 5 "Much more likely"
label values reported_change_rc reported_change_rc_lab

reg week_20_rc i.reported_change_rc [aweight=g4w20_weight], robust
eststo taba8

esttab taba8 using "taba8.rtf", ///
    replace ///
    title("Linear regression showing the correlation between reported change in support for Donald Trump and vote choice, among full sample with robust standard errors. Weighted analysis. Excluded are respondents saying the conviction made them 'much less likely' to vote for Donald Trump.") ///
    b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2, fmt(%9.0f %9.3f)) ///
	varlabels(i.reported_change_rc "Reported Change" _cons "Constant")  ///
    varwidth(30) ///
	mtitles("Week 20 Vote") ///
    label ///
    compress      ///
    nonumber nogaps noomitted nobaselevels
restore

* Table A9.

preserve
	* Cols. 2–8. "# Surveys Supporting Trump (out of 5)."
asdoc tab voterstatus weeks_support_trump, col nofreq replace save(taba9_cols2to8.doc)
	* Col. 1. "Average % weeks." (Note that the below table was combined manually with the above table in the main text for formatting flexibility.)
collapse (mean) avg_weeks_support_trump = prop_weeks_trump, by(voterstatus)
asdoc list voterstatus avg_weeks_support_trump, replace save(taba9_col1.doc)
restore

* Table A10.

preserve
reg conflicted_voters i.g4w20_baseline_presvote20post_rc i.g4w20_baseline_pid7_rc i.g4w20_baseline_age4_rc i.g4w20_baseline_educ4_rc i.g4w20_baseline_race4_rc [aweight=g4w20_weight] if vote_if_trump_not_guilty==1, robust
eststo taba10

esttab taba10 using "taba10.rtf", ///
    replace ///
    title("Linear regression of conflicted voter status on demographic correlates, among week 16 Trump voters with robust standard errors. Weighted analysis.") ///
    b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2, fmt(%9.0f %9.3f)) ///
    varwidth(30) ///
    mtitles("Conditional voter (binary), weighted") ///
    compress      ///
    nonumber nogaps noomitted nobaselevels label
restore

* Table A11.

preserve
	* Recode prediction variable, but drop DK responses.
recode g4w16_trump_convicted_manhattan (1=1) (2=0) (3=.) (*=.), gen(week16_p_nodk)
label var week16_p_nodk "Do you think Donald Trump will be convicted? (Week 16 binary)"
	* Col. 1. "Week 20 Vote Choice."
reg week_20_rc post_guilty##i.week16_p_nodk [aweight=g4w20_weight] if week_16_rc==1, robust
eststo taba11_col1
	* Col. 2. "Week 4 Vote Choice."
reg week_4_rc post_guilty##i.week16_p_nodk [aweight = g4w4_weight] if week_16_rc==1, robust
eststo taba11_col2
	* Col. 3. "Week 8 Vote Choice."
reg week_8_rc post_guilty##i.week16_p_nodk [aweight = g4w8_weight] if week_16_rc==1, robust
eststo taba11_col3
	* Col. 4. "Week 12 Vote Choice."
reg week_12_rc post_guilty##i.week16_p_nodk [aweight=g4w12_weight] if week_16_rc==1, robust
eststo taba11_col4
	* Combine.
esttab taba11_col1 taba11_col2 taba11_col3 taba11_col4 using "taba11.rtf", ///
    replace ///
    title("Combined test and placebo tests of those responding after the guilty verdict interacted with week 16 guilt expectation on vote choice, among week 16 Trump supporters with robust standard errors. Weighted analysis.") ///
    b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2, fmt(%9.0f %9.3f)) ///
	varlabels(1.post_guilty "Post-Guilty Verdict" ///
              1.week16_p_nodk "Expectation of Guilt" ///
              1.post_guilty#1.week16_p_nodk "Post-Guilty Verdict X Expectation of Guilt" ///
				_cons "Constant")  ///
    varwidth(30) ///
	mtitles("Week 20 Vote Choice" "Week 4 Vote Choice" "Week 8 Vote Choice" "Week 12 Vote Choice") ///
    label ///
    compress      ///
    nonumber nogaps noomitted nobaselevels
restore

* Table A12.

preserve
	* Col. 1. "Week 20 Vote Choice."
reg week_20_rc post_guilty##i.conflicted_voters if vote_if_trump_not_guilty==1, robust
eststo taba12_col1
	* Col. 2. "Week 4 Vote Choice."
reg week_4_rc post_guilty##i.conflicted_voters if vote_if_trump_not_guilty==1, robust
eststo taba12_col2
	* Col. 3. "Week 8 Vote Choice."
reg week_8_rc post_guilty##i.conflicted_voters if vote_if_trump_not_guilty==1, robust
eststo taba12_col3
	* Col. 4. "Week 12 Vote Choice."
reg week_12_rc post_guilty##i.conflicted_voters if vote_if_trump_not_guilty==1, robust
eststo taba12_col4
	* Combine.
esttab taba12_col1 taba12_col2 taba12_col3 taba12_col4 using "taba12.rtf", ///
    replace ///
    title("Combined test and placebo tests of conditional Trump supporters on vote choice among week 16 Trump supporters with robust standard errors. Unweighted analysis.") ///
    b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2, fmt(%9.0f %9.3f)) ///
	varlabels(1.post_guilty "Post-Guilty Verdict" ///
              1.conflicted_voters "Conditional Supporter" ///
              1.post_guilty#1.conflicted_voters "Post-Guilty Verdict X Conditional Support" ///
				_cons "Constant")  ///
    varwidth(30) ///
	mtitles("Week 20 Vote Choice" "Week 4 Vote Choice" "Week 8 Vote Choice" "Week 12 Vote Choice") ///
    label ///
    compress      ///
    nonumber nogaps noomitted nobaselevels
restore

* Table A13.
preserve

reg week_20_rc day345##i.conflicted_voters [aweight=g4w20_weight] if vote_if_trump_not_guilty==1, robust
eststo taba13

esttab taba13 using "taba13.rtf", ///
    replace ///
    title("Among week 16 Trump supporters, effect of taking the survey post-guilty verdict on vote choice. Weighted analysis. Reduced form replacing week 20 survey time with week 16 survey time to account for selection into treatment. Robust standard errors in parentheses.") ///
    b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2, fmt(%9.0f %9.3f)) ///
    varlabels(1.day345 "Late Survey Taker (Week 16)" ///
              1.conflicted_voters "Conditional Supporter" ///
              1.day345#1.conflicted_voters "Late Survey Taker X Conditional Support" ///
              _cons "Constant") ///
    varwidth(30) ///
	mtitles("Week 20 Vote Choice, weighted") ///
    label ///
    compress ///
    nonumber nogaps noomitted nobaselevels
restore

* Table A14. (Note that this table was computed directly in the Stata console and input manually in the main text for formatting flexibility.)

preserve
	* Col. 1. "Week 4."
asdoc tab voterstatus took_week_4 [aweight= g4w4_weight], row nofreq replace save(taba14_col1.doc)
	* Col. 2. "Week 8."
asdoc tab voterstatus took_week_8 [aweight= g4w8_weight], row nofreq replace save(taba14_col2.doc)
	* Col. 3. "Week 12."
asdoc tab voterstatus took_week_12 [aweight= g4w12_weight], row nofreq replace save(taba14_col3.doc)
	* Col. 4. "Week 20."
asdoc tab voterstatus took_week_20 [aweight= g4w20_weight], row nofreq replace save(taba14_col4.doc)
	* Col. 5. "Week 24."
asdoc tab voterstatus took_week_24 [aweight = g4w16_weight], row nofreq replace save(taba14_col5.doc)
	* Col. 6. "Week 28."
asdoc tab voterstatus took_week_28 [aweight= g4w28_weight], row nofreq replace save(taba14_col6.doc)
restore

* Table A15.

preserve
replace post_guilty= 1 if week_20_rc == . & week_16_rc !=.
replace week_20_rc = week_24_rc if week_20_rc == . & week_16_rc !=.
replace week_20_rc = week_28_rc if week_20_rc == . & week_16_rc !=.
replace week_20_rc = week_32_rc if week_20_rc == . & week_16_rc !=.

reg week_20_rc post_guilty##i.conflicted_voters [aweight=g4w16_weight] if vote_if_trump_not_guilty==1, robust
eststo taba15

esttab taba15 using "taba15.rtf", ///
    replace ///
    title("Among Week 16 Trump supporters, linear regression of week 20 vote choice on post-verdict respondents interacted with conditional Trump support. Weighted analysis. Missing respondents for Week 20 are imputed based on their week 24, 28 or 32 responses.") ///
    b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2, fmt(%9.0f %9.3f)) ///
    varlabels(1.post_guilty "Post-Guilty Verdict" ///
              1.conflicted_voters "Conditional Supporter Status" ///
              1.post_guilty#1.conflicted_voters "Post-Guilty Verdict X Conditional Support" ///
              _cons "Constant") ///
    varwidth(30) ///
	mtitles("Week 20 Vote Choice, weighted") ///
    label ///
    compress ///
    nonumber nogaps noomitted nobaselevels
restore
