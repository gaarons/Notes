/*
Grant Aarons
gaarons@london.edu
Econometrics 1, London Business School
Assignment 3
*/
* Load the data
import excel "$datadir/schaller.xls", sheet("Sheet1") firstrow clear
*pause Dataset has been loaded


*** Part A
* Tabulate the variables we were given as standard practice
tabstat inv q, stat(min max mean sd)
tabstat inv q, by(year) stat(min max mean sd)
* Too long a printout by firm, but could be used
*tabstat inv q, by(firm) stat(min max mean sd)

* Run the required regression of inv = alpha + beta_1*q
reg inv q

*pause Part A completed


*** Part B
* Create dummy variables corresponding to each firm using ``xi'' command
xi firm
reg inv q i.firm

*pause Part B completed

*** Part C
* regress inv on firm dummies alone and obtain the residual
reg inv i.firm
predict einv, residuals

* regress q on firm dummies alone and obtain the residual
reg q i.firm
predict eq, residuals

* regress einv on eq, the partitioned regression, partialing out result 
reg einv eq

* Follow up questions addressed in the LaTex write-up

*pause Part C completed


*** Part D
* Purely analytical and addressed in the LaTex write-up
* Not asked to compute anything in Stata


*** Part E
* Regress inv on eq 
reg inv eq

* Follow up questions addressed in the LaTex write-up

*pause Part E completed
