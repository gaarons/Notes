/*
Grant Aarons
gaarons@london.edu
Econometrics 1, London Business School
Assignment 1
*/
* Load the data
import excel "$datadir/NLS_2006.xls", sheet("Sheet1") firstrow clear

*** Part A
* Tabulate the variables we were given
tabstat luwe educ exper age fed med kww iq white, stat(min max mean sd)

*** Part B
* nomenclature: p=power, r=root, a=add, s=subtract
* Generate a new variable for experience power squared
gen exper_p2 = exper^2

* Regression of luwe = alpha + beta_1*educ + beta_2*exper + beta_3*(exper^2)
reg luwe educ exper exper_p2

* Want to look at the mean of original predicted/fitted values (tell a story in 
* Part C) and D) of this assignment 
predict luwe_b_hat
summ luwe_b_hat

* The variance of the residual variance can be estimated as follows: 
* (under the assumption of normally distributed error terms)
scalar resid_variance = e(rmse)^2
scalar var_resid_variance = 2*resid_variance^2/e(df_r)
disp var_resid_variance
* So the variance-covariance matrix for all parameters is 
*(note the residual variance is uncorrelated with the regression parameters)
matrix define full_varcov_matrix=((e(V)\0,0,0,0),(0\0\0\0\var_resid_variance))
matrix rownames full_varcov_matrix =  educ  exper exper2 _cons resid_var
matrix colnames full_varcov_matrix =  educ  exper exper2 _cons resid_var

* Return the matrix for variance/covariance
matrix list full_varcov_matrix

*** Part C
* Preserve the current dataset, while we do the next steps
preserve

* Need to use in calculation later
egen exper_mean = mean(exper)

* Predict the effect of decreasing everyones education by one year
* This would increase everyones experience by a year 
* -> 1:1 tradeoff education for experience in years time
* We make these changes to the current dataset, before making predictions
replace educ = educ - 1
replace exper = exper + 1
replace exper_p2 = exper^2
tabstat luwe educ exper age fed med kww iq white, stat(min max mean sd)

* Predict, uses the most recent regression output to run inference
predict luwe_c_hat
summ luwe_c_hat
tabstat luwe_b_hat luwe_c_hat, stat(mean)
egen b_mean = mean(luwe_b_hat)
egen c_mean = mean(luwe_c_hat)
scalar observed_diff = c_mean[1] - b_mean[1]
matrix list e(b)
scalar delta = -1*_b[educ] + 1*_b[exper] + (2*exper_mean[1]+1)*_b[exper_p2] 
di observed_diff
di delta

* Give us the original dataset back
restore

* Make sure the dataset reverted 
tabstat luwe educ exper age fed med kww iq white, stat(min max mean sd)

*** Part D
* We are asked to redefine the covariates
* luwe = alpha + beta_1(educ) + beta_2(exper + educ)...
* 			   + beta_3(exper^2+(2*bar(exper)-1)*educ) + e

* Need to create these new covariates
gen educ_a_exper = educ + exper
egen bar_exper = mean(exper)
* Need to create everyone's experience increased by 1 year variable
gen exper_p2_a_n = (exper^2) + educ*(2*(bar_exper)+1)

* When we redefine the covariates we have to rerun the regression
reg luwe educ educ_a_exper exper_p2_a_n

* The variance of the residual variance can be estimated as follows: 
* (under the assumption of normally distributed error terms)
scalar resid_variance = e(rmse)^2
scalar var_resid_variance = 2*resid_variance^2/e(df_r)
disp var_resid_variance
* So the variance-covariance matrix for all parameters is 
*(note the residual variance is uncorrelated with the regression parameters)
matrix define full_varcov_matrix=((e(V)\0,0,0,0),(0\0\0\0\var_resid_variance))
matrix rownames full_varcov_matrix =  educ  educ_a_exper exper_p2_a_n _cons resid_var
matrix colnames full_varcov_matrix =  educ  educ_a_exper exper_p2_a_n _cons resid_var

* Return the matrix for variance/covariance
matrix list full_varcov_matrix

* Predict, uses the most recent regression output to run inference
predict luwe_d_hat
summ luwe_d_hat

* ANSWER: 	We get the same results from Part C), because when we redefined
* 			the covariates and updated the regression coefficients, we preserved
*			the relationships derived in the regression of Part C).  

*** Part E
* Back to the original variables
* Need to reset these values to original Part B) regression levels
* Regression of luwe = alpha + beta_1*educ + beta_2*(exper^2)
reg luwe educ exper_p2
predict luwe_e_hat 

* Compute the residual (y-y_hat)
gen e_luwe = luwe - luwe_e_hat

* Regression of exper = alpha + beta_1*educ + beta_2*(exper^2)
*reg exper educ exper_p2
reg exper educ exper_p2
predict exper_e_hat

* Compute the residual (y-y_hat)
gen e_exper = exper - exper_e_hat

* Regression of luwe = alpha + beta_1*educ + beta_2*(exper^2)
reg e_luwe e_exper

* The variance of the residual variance can be estimated as follows: 
* (under the assumption of normally distributed error terms)
scalar resid_variance = e(rmse)^2
scalar var_resid_variance = 2*resid_variance^2/e(df_r)
disp var_resid_variance
* So the variance-covariance matrix for all parameters is 
*(note the residual variance is uncorrelated with the regression parameters)
matrix define full_varcov_matrix=((e(V)\0,0),(0\0\var_resid_variance))
matrix rownames full_varcov_matrix =  e_luwe  e_exper resid_var
matrix colnames full_varcov_matrix =  e_luwe  e_exper resid_var

* Return the matrix for variance/covariance
matrix list full_varcov_matrix

