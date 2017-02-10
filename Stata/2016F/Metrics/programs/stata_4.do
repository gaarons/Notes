cap log close _all
clear
cls
set more off
program drop _all
file close _all
est clear
pause on  
*** use q or BREAK

global projdir C:\Users\gaarons\Git\Notes\Stata\2016F\Metrics
global outdir "`projdir'\output"
log using $projdir\logs\stata_4, replace s name("Grant Aarons Assignment 4")
* Use s or t to get smcl or text log file
/*
Grant Aarons
gaarons@london.edu
Econometrics 1, London Business School
*/
global programdir C:\Users\gaarons\Git\Notes\Stata\2016F\Metrics\programs
global datadir C:\Users\gaarons\Git\Notes\Stata\2016F\Metrics\data
global outputdir C:\Users\gaarons\Git\Notes\Stata\2016F\Metrics\output
/*
Program: stata_41.do
Description: Introduction to econometrics in stata
*/

**********************************************************************
************************** START QUESTION 3 **************************
**********************************************************************
do $programdir/stata_41.do

log close _all
