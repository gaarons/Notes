/*
Grant Aarons
gaarons@london.edu
Econometrics 1, London Business School
Assignment 3
*/
* Load the data
import excel "$datadir/ps3.xls", sheet("Sheet1") firstrow clear
*pause Dataset has been loaded

* Need to identify panelists/firms
gen individual = _n

* Reshape the data from wide to long
reshape long w ed a, i(individual) j(year)
replace w = log(w)
gen xp = a-ed-6
gen xp_p2 = xp^2

* Create necessary variables
by individual: egen luwe=mean(w)
by individual: egen educ=mean(ed)
by individual: egen exp=mean(xp)
by individual: egen exp_p2=mean(xp_p2)

*pause Check the means calculated above by individual

*** Part A
* For the 1990 portion of the data, regress log(wage) on constant, educ, exp, exp2
* NOT SURE THAT THE PSET is written correctly, want the means of the individual over each variable...?

* should we regress the average over all individuals or just 1990 
* (average by individual used later) NOT THIS: reg luwe educ exp exp_p2
reg w ed xp xp_p2 if year==0

* Pooled Regression (1990-1992)
reg w ed xp xp_p2

*pause Part A completed


*** Part B
* Discussed in the LaTex write-up
* Not asked to compute anything in Stata, but helpful to do so

*Combined for all IV 
rvfplot
graph export "..\output\fittedResid_hettest.pdf", replace
estat hettest

*For individual IV 
rvpplot ed
graph export "..\output\edResid_hettest.pdf", replace
rvpplot xp
graph export "..\output\xpResid_hettest.pdf", replace
rvpplot xp_p2
graph export "..\output\xp_p2Resid_hettest.pdf", replace

estat hettest ed
estat hettest xp
estat hettest xp_p2

*** Part C
* Purely analytical and addressed in the LaTex write-up
* Not asked to compute anything in Stata
* The problem set should have asked us to compute the FE estimated coefficients
xi year
reg w ed xp xp_p2 i.year

* To show the effect of different years on the coefficient estimates
reg w ed xp xp_p2 if year==0
reg w ed xp xp_p2 if year==1
reg w ed xp xp_p2 if year==2

*** Part D
* Only MATLAB

*** Part E
* Estimate the within estimator \tilde{\beta}_W for the wage equation

preserve
* Need demeaned variables
replace w = w - luwe
replace ed = ed - educ
replace xp = xp - exp
replace xp_p2 = xp_p2 - exp_p2
* Need to do this to get the same coefficient names for Hausman test

* Pooled Regression (1990-1992) but after demeaned/Within/FixedEffects
*reg w_dm ed_dm xp_dm xp_p2_dm
reg w ed xp xp_p2
estimates store fixedEffects
restore
* Firm fixed effect
* FOR within each individual demean the average over time, firm fixed effect

* Follow up questions addressed in the LaTex write-up

*pause Part E completed

*** Part F
* Only MATLAB

*** Part G
* Only Stata - WE CANNOT DO THIS PROBLEM WITH THE STATA IC license that we are 
* given.  Max matsize=800 on IC and we need 1500. 

* Check if the results match with Stata by using the command xtgls on the 
* variable from the original wage equation.

/* xtset individual year
set matsize 2000
xtgls w ed xp xp_p2
estimates store gls
*/

* Follow up questions addressed in the LaTex write-up

*pause Part G completed


*** Part H
* Are the FGLS (MATLAB should match) results different than the FE ones? Perform a Hausman test. 

/* hausman fixedEffects gls
*/

* Follow up questions addressed in the LaTex write-up

*pause Part H completed

