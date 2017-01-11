/*
Grant Aarons
gaarons@london.edu
Econometrics 1, London Business School
Assignment 1
*/
* Load the data
import excel "$datadir/PS1_insurance.xls", sheet("Sheet1") firstrow clear

* Want to treat as dummies to get summary statistics/quantitative information
gen lottery_dum = 1 if(lottery=="Selected")
gen sex_dum = 1 if(female=="1: Female")

* Tabulate the variables we were given
tabstat lottery_dum birthyear sex_dum doc_visit_num hh_inc, stat(mean sd min max p25 p50 p75)

* Generate new variables for analysis
gen age_2010 = 2010 - birthyear
gen visit_dum_2010 = 1 if(lottery_dum==1 & doc_visit_num>0)

* Summarize these new generated variables
summ age_2010 visit_dum_2010

* Generate a historgram with fixed bin width
histogram hh_inc, width(2500)
graph export "$outputdir/histogram_1.pdf", replace
