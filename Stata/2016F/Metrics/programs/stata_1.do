cap log close
clear
cls
set more off
program drop _all
file close _all
est clear

global projdir C:\Users\gaarons\Git\Notes\Stata\2016F\Metrics
log using $projdir\logs\stata_1, replace t name("Grant Aarons Assignment 1")
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
Program: stata_11.do
Description: Introduction to econometrics in stata
*/
do $programdir/stata_11.do

log close _all
