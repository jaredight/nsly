*1.Merging datasets
use "/Users/lenagan/Desktop/children.dta", clear 
*rename mother id to match name of variable in mom dataset;
gen momid = c0000200
sort momid
save child_test, replace

use  "/Users/lenagan/Desktop/Mom.dta", clear
*rename NLSY79  id to match name of mother id variable in child dataset;
gen momid = r0000100
sort momid
save mom_test, replace

merge momid using "/Users/lenagan/Desktop/mom_test copy.dta" "/Users/lenagan/Desktop/child_test copy.dta" 
*eliminate NLSY79 respondents with no children in child data set, final data set has 11469 observations using data through 2006;
drop if C0000100 = = . ;


*2. CREATING VARIABLES
//Note: higher scores are "bad" so code "N0" as 0 and "YES" as 1
// Delinquent
gen agency=y2930600
recode agency(0=0) (1=1) (-7=.) (-2=.) (-1=.), gen(agency)

gen repo=y2930601
recode repo(0=0) (1=1) (-7=.) (-2=.) (-1=.), gen(repo1)

gen payday =y2930602
recode payday(0=0) (1=1) (-7=.) (-2=.) (-1=.), gen(payday1)

gen bankrup=y2930603
recode bankrup(0=0) (1=1) (-7=.) (-2=.) (-1=.), gen(bankrup1)

gen fclos=y2930604
recode fclos(0=0) (1=1) (-7=.) (-2=.) (-1=.), gen(fclose1)


*3.CREATING HOUSEHOLD INCOME (??)
//creating household income for NSLCYA (young adults)

//creating household income for NSLY79 (mothers)


*4. FINAL STEP
*missing . to -99
mvencode _all, mv(-99)
