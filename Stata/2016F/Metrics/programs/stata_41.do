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
gen fd_cpta = cpta-lcpta_1

* Logical thing to do, take logs and then do all the generated variables again
gen ln_cpta = ln(cpta)
gen ln_ypta = ln(ypta)

* Prettier ways of doing this but whatever
gen ln_lcpta_1 = l.ln_cpta 
gen ln_lcpta_2 = l.ln_lcpta_1
gen ln_lcpta_3 = l.ln_lcpta_2
gen ln_lcpta_4 = l.ln_lcpta_3
gen ln_lcpta_5 = l.ln_lcpta_4
gen ln_lcpta_6 = l.ln_lcpta_5
gen ln_lypta_1 = l.ln_ypta 

* logarithm of first difference income per capita
gen ln_fd_ypta = ln_ypta-ln_lypta_1
* logarithm of first difference consumption per capita
gen ln_fd_cpta = ln_cpta-ln_lcpta_1

gen instrument1 = ln_lcpta_2 - ln_lcpta_3
gen instrument2 = ln_lcpta_3 - ln_lcpta_4
gen instrument3 = ln_lcpta_4 - ln_lcpta_5
gen instrument4 = ln_lcpta_5 - ln_lcpta_6 

*** Part A
* Do the simple regression of C_t on 4 period lags of C_t and a constant
reg cpta lcpta_1 lcpta_2 lcpta_3 lcpta_4

* Test the hypothesis that the beta_2 = beta_3 = beta_4 = 0
test lcpta_2=lcpta_3=lcpta_4=0

*pause Part A completed

*** Part B
* Set up the LHS variable to match the C_t - C_{t-1} in the homework write up
* Do the simple regression of C_t - C_{t-1} on first difference per capita income
* and a constant
reg fd_cpta fd_ypta

*pause Part B completed

*** Part C
* Take logs of the relevant variables before running any regressions
* Run 2SLS with robust White standard errors as the question requests
* Run the first stage regression, where we try to separate the endogeneity of 
* first difference output from residuals from regression of consumption on fd output
reg ln_fd_ypta instrument1 instrument2 instrument3 instrument4
predict x_hat
reg ln_fd_cpta x_hat, robust 

* Should get the same results as the one-shot Stata command:
ivregress 2sls ln_fd_cpta (ln_fd_ypta=instrument1 instrument2 instrument3 instrument4), robust

* The two results have exact same coefficient values, but the top two step that
* I set up for 2 SLS has a larger SE because I have not corrected for the compounded SE
* from the first stage.  Should use 1 step command, because corrects for this which
* I was not told to do, and do not want to do here.

* In MATLAB, I will try to replicate the larger SE version that hasnt had correction
* for regressor/regression compounding of the SE.
*pause Part C completed
