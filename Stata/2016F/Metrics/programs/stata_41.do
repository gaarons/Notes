/*
Grant Aarons
gaarons@london.edu
Econometrics 1, London Business School
Assignment 4
*/
* Load the data
import excel "$datadir/problems.xls", sheet("problems12") firstrow clear
* pause Dataset has been loaded

* Generate all neccessary or helpful variables
*gen datenum = year+(quarter-1)*(0.25)
gen t = _n
gen newt = tq(1948q1) + t - 1
tsset newt, quarterly

gen cpta = (realconsumptionofnondurables +  realconsumptionofservices)/population
gen ypta = (realdisposableincome)/population

* Prettier ways of doing this but whatever
gen lcpta_1 = l.cpta 
gen lcpta_2 = l.lcpta_1
gen lcpta_3 = l.lcpta_2
gen lcpta_4 = l.lcpta_3
gen lcpta_5 = l.lcpta_4
gen lcpta_6 = l.lcpta_5
gen lypta_1 = l.ypta 

* first difference income per capita
gen fd_ypta = ypta-lypta_1
*cpta add lag 1
gen cpta_al1 = cpta+lcpta_1

* Logical thing to do, take logs and then do all the generated variables again
gen ln_cpta = ln(cpta)
gen ln_ypta = ln(ypta)
gen ln_lcpta_1 = l.ln_cpta 
gen ln_lypta_1 = l.ln_ypta 
* logarithm of first difference income per capita
gen ln_fd_ypta = ln_ypta-ln_lypta_1
* logarithm of cpta add lag 1
gen ln_cpta_al1 = ln_cpta+ln_lcpta_1

gen instrument1 = lcpta_2 - lcpta_3
gen instrument2 = lcpta_3 - lcpta_4
gen instrument3 = lcpta_4 - lcpta_5
gen instrument4 = lcpta_5 - lcpta_6 

*** Part A
* Do the simple regression of C_t on 4 period lags of C_t and a constant
reg cpta lcpta_1 lcpta_2 lcpta_3 lcpta_4

* Test the hypothesis that the beta_2 = beta_3 = beta_4 = 0
test lcpta_2=lcpta_3=lcpta_4=0

*pause Part A completed

*** Part B
* Set up the LHS variable to match the C_t + C_{t-1} in the homework write up
* Do the simple regression of C_t + C_{t-1} on first difference per capita income
* and a constant
reg cpta_al1 fd_ypta

*pause Part B completed

*** Part C
* Take logs of the relevant variables before running any regressions
* Run 2SLS with robust White standard errors as the question requests
* Run the first stage regression, where we try to separate the endogeneity of 
* first difference output from residuals from regression of consumption on fd output
reg ln_fd_ypta instrument1 instrument2 instrument3 instrument4
predict x_hat
reg ln_cpta_al1 x_hat, robust 

* Should get the same results as the one-shot Stata command:
ivregress 2sls ln_cpta_al1 (ln_fd_ypta=instrument1 instrument2 instrument3 instrument4), robust

*pause Part C completed
