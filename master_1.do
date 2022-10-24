/*
Jared Wright
18 October 2022
NLSY79 upwork project for Lena
*/

* initialize
clear all
set more off
ssc install tolower
cd "C:\Users\jared\OneDrive\Documents\nsly" //change to local nsly folder as needed

**# CLEAN AND MERGE DATASETS
* import child dataset
infile using "nlscya_2\nlsc79_2.dct", clear
do "nlscya_2\nlsc79_2-value-labels.do" // this file contains editable value labels and code to rename all variables
tolower
rename c0000200 r0000100
save "nlscya_2\children.dta", replace

* import parent dataset
infile using "nlsc79_2\nlsc79_2.dct", clear
do "nlsc79_2\nlsc79_2-value-labels.do" // this file contains editable value labels and code to rename all variables
tolower
save "nlsc79_2\parents.dta", replace

* merge datasets
merge 1:m r0000100 using "nlscya_2\children.dta", nogen keep(3)
order r0000100 c0000100
sort r0000100 c0000100
rename (r0000100 c0000100) (mom_id child_id)

**# RECODE VARIABLES
* DV: Delinquent
recode y2930600 y2930601 y2930602 y2930603 y2930604 (0=0) (1=1) (-7=.) (-2=.) (-1=.)
summarize y2930600 y2930601 y2930602 y2930603 y2930604 // ensure all nonbinary values are now missing
label list vlY2930600 vlY2930601 vlY2930602 vlY2930603 vlY2930604

* Mediator: Intention
recode y2930500 y2930501 y2930502 y2930503 y2930504 y2930505 (0=0) (1=1) (-7=.) (-2=.) (-1=.) (2=.)
summarize y2930500 y2930501 y2930502 y2930503 y2930504 y2930505
label list vlY2930500 vlY2930501 vlY2930502 vlY2930503 vlY2930504 vlY2930505

* IV: Perceived Control
recode y2930100 y2930200 y2930300 y2930400 y2929300 (0=0) (1=1) (-7=.) (-2=.) (-1=.)
summarize y2930100 y2930200 y2930300 y2930400 y2929300
label list vlY2930100 vlY2930200 vlY2930300 vlY2930400 vlY2929300

* IV: Attitude (impulsivity/lack of self control)
recode y1647500 y1647700 y1647800 y1648000 (0=0) (1=1) (-7=.) (-2=.) (-1=.) (2=.)
summarize y1647500 y1647700 y1647800 y1648000
label list vlY1647500 vlY1647700 vlY1647800 vlY1648000

* Maternal-Child relationship
recode c0008047 c3032700 c3032500 c3032600 c2845500 (0=0) (1=1) (-7=.) (-2=.) (-3=.) (-1=.) (2=.)
summarize c0008047 c3032700 c3032500 c3032600 c2845500
label list vlC0008047 vlC3032700 vlC3032500 vlC3032600 vlC2845500

* NLSCYA Young Adults
replace y2966400 = . if y2966400 < 0 //age
summarize y2966400

replace y2837500 = . if y2837500 < 0 //gender
recode y2837500 (1=0) (2=1)
label define vlY2837500 0 "0: MALE"  1 "1: FEMALE", replace
label values y2837500 vlY2837500
label list vlY2837500
summarize y2837500

label list vlY2966700 //education
replace y2966700 = . if y2966700 < 0
summarize y2966700

label list vlY2966900 //marital status
replace y2966900 = . if y2966900 < 0
summarize y2966900

* IV: Social Norms (Mother)
rename r8417600 tmp
gen r8417600 = .
replace r8417600 = 1 if tmp==0
replace r8417600 = 2 if (0 < tmp) & (tmp <= 3)
replace r8417600 = 3 if (3 < tmp) & (tmp < 10)
drop tmp
label define vlR8417600 1 "0" 2 "1 to 3" 3 "4 or more", replace
label values r8417600 vlR8417600

replace r8417500 = . if r8417500 < 0
replace r8417700 = . if r8417700 < 0

summarize r8417600 r8417500 r8417700
label list vlR8417600 vlR8417500 vlR8417700


**# GENERATE HOUSEHOLD INCOME


**# ENCODE MISSING VALUES AS -99
mvencode _all, mv(-99)

