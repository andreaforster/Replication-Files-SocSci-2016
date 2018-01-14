
/*---------------------------------------------------------------------------------------------
This do-file prepares: 
-	a combined working data set from the single data files downloaded from PIAAC and the 
	educational system indicators
-	all variable on the individual and country level needed for the analyses in the paper

This do-file produces the following tables and figures:

-	Table 1: Descriptive Statistics
	
Programs that need to be downloaded:
-	piaacdes
-	estout
-	usespss

Data needed:
                                                     		  
-	PIAAC 2012, Public use file, has to be downloaded from: 
	http://www.oecd.org/site/piaac/publicdataandanalysis.htm, release Nov. 2013																	  
	
-	Educational systems indicators (Bol & vd Werfhorst), 								  
	http://thijsbol.com/data.php, version 4,
	This data set is already in the replication folder

---------------------------------------------------------------------------------------------*/

/* Customize this path to the location on your computer where the downloaded replication 
folder is located*/
global workingDir "C:\Users\...\...\replication files"

global workingDir "C:\Users\aforste1\Dropbox\andrea\research\03_papers\2015_vocational_decline_paper\05_replication files\replication files"
global workingDir "D:\Dropbox\andrea\research\03_papers\2015_vocational_decline_paper\05_replication files\replication files"

*---------------------------------------------------------------------------------------------*
global dofiles		"${workingDir}\01_dofiles"		// do-files
global data 		"${workingDir}\02_data"			// raw data
global posted		"${workingDir}\03_posted"		// saved results data
global graphs		"${workingDir}\04_graphs"		// graphs
global tables		"${workingDir}\05_tables"		// output for the tables
global logs			"${workingDir}\06_logs"			// logs
*---------------------------------------------------------------------------------------------*

capture log close
clear all
set more off

* Opening a log
log using "$logs\dataprep.log", replace

***********************************************************************************************
* PREPARE WORKING DATA SET FROM DOWNLOADED DATA FILES
***********************************************************************************************

/* Download the .sav files from the PIAAC website. There is one file
for every country. Put these files in the folger "02_data" in the replication files folder 
structure. You can also use the .csv files instead of the SPSS files, however, these do not
contain variable labels */

* Read the SAV files from the PIAAC website into Stata and save as DTA files

usespss "$data\prgautp1.sav", clear
save "$data\AUT.dta", replace

usespss "$data\prgbelp1.sav", clear
save "$data\BEL.dta", replace

usespss "$data\prgcanp1.sav", clear
save "$data\CAN.dta", replace

usespss "$data\prgczep1.sav", clear
save "$data\CZE.dta", replace

usespss "$data\prgdeup1.sav", clear
save "$data\DEU.dta", replace

usespss "$data\prgdnkp1.sav", clear
save "$data\DNK.dta", replace

usespss "$data\prgespp1.sav", clear
save "$data\ESP.dta", replace

usespss "$data\prgestp1.sav", clear
save "$data\EST.dta", replace

usespss "$data\prgfinp1.sav", clear
save "$data\FIN.dta", replace

usespss "$data\prgfrap1.sav", clear
save "$data\FRA.dta", replace

usespss "$data\prggbrp1.sav", clear
save "$data\GBR.dta", replace

usespss "$data\prgirlp1.sav", clear
save "$data\IRL.dta", replace

usespss "$data\prgitap1.sav", clear
save "$data\ITA.dta", replace

usespss "$data\prgjpnp1.sav", clear
save "$data\JPN.dta", replace

usespss "$data\prgkorp1.sav", clear
save "$data\KOR.dta", replace

usespss "$data\prgnldp1.sav", clear
save "$data\NLD.dta", replace

usespss "$data\prgnorp1.sav", clear
save "$data\NOR.dta", replace

usespss "$data\prgpolp1.sav", clear
save "$data\POL.dta", replace

usespss "$data\prgrusp1.sav", clear
save "$data\RUS.dta", replace

usespss "$data\prgsvkp1.sav", clear
save "$data\SVK.dta", replace

usespss "$data\prgswep1.sav", clear
save "$data\SWE.dta", replace

usespss "$data\prgusap1.sav", clear
save "$data\USA.dta", replace

* append the single files to one cross-national data set

use "$data\AUT.dta", clear
append using "$data\BEL.dta"
append using "$data\CAN.dta"
append using "$data\CZE.dta"
append using "$data\DEU.dta"
append using "$data\DNK.dta"
append using "$data\ESP.dta"
append using "$data\EST.dta"
append using "$data\FIN.dta"
append using "$data\FRA.dta"
append using "$data\GBR.dta"
append using "$data\IRL.dta"
append using "$data\ITA.dta"
append using "$data\JPN.dta"
append using "$data\KOR.dta"
append using "$data\NLD.dta"
append using "$data\NOR.dta"
append using "$data\POL.dta"
append using "$data\RUS.dta"
append using "$data\SVK.dta"
append using "$data\SWE.dta"
append using "$data\USA.dta"

save "$data\PIAAC2012.dta", replace

/* The educational systems indicator data set is already in the folder with the 
replication files */

* Recode the country variable to get a identifyer to match educational system data
	
recode CNTRYID (40=1 "AUT")(56=2 "BEL")(124=3 "CAN")(203=4 "CZE")		///
	(208=5 "DNK")(233=6 "EST")(246=7 "FIN") (250=8 "FRA") (276=9 "DEU")	///	
	(372=10 "IRL") (380=11 "ITA")(392=12 "JPN") (410=13 "KOR")			///
	(528=14 "NLD") (578=15 "NOR") (616=16 "POL") 						///
	(643=17 "RUS")(703=18 "SVK") (724=19 "ESP") 						///	
	(752=20 "SWE") (826=21 "GBR")(840=22 "USA"), gen(cnt)

decode cnt, gen(cntry)

* merge the educational system indicator data set

merge m:1 cntry using "$data\bw-educsysdata-full-v4.dta"

save "$data\PIAAC2012_edusystem_indicators.dta", replace

***********************************************************************************************
								**** Variables ****
***********************************************************************************************
use "$data\PIAAC2012_edusystem_indicators.dta", clear

*---------------------------------------------------------------------------------------------*
* Countries
*---------------------------------------------------------------------------------------------*

recode CNTRYID(40=1 "Austria")(56=2 "Belgium")(124=3 "Canada")(203=4 "Czech Republic")		///
	(208=5 "Denmark")(233=6 "Estonia")(246=7 "Finland") (250=8 "France") (276=9 "Germany")	///	
	(372=10 "Ireland") (380=11 "Italy")(392=12 "Japan") (410=13 "Korea, Republic of")		///
	(528=14 "Netherlands") (578=15 "Norway") (616=16 "Poland") 								///
	(643=17 "Russian Federation")(703=18 "Slovak Republic") (724=19 "Spain") 				///	
	(752=20 "Sweden") (826=21 "United Kingdom")(840=22 "United States"), gen(c)
	
*---------------------------------------------------------------------------------------------*
* DV: Employment status
*---------------------------------------------------------------------------------------------*
recode C_D05 (1=1)(2 3=0)(4 9 =.), gen(employed)
lab var employed "Employment status"

*---------------------------------------------------------------------------------------------*
* Age
*---------------------------------------------------------------------------------------------*
clonevar age = AGE_R 
clonevar age5 = AGEG5LFS

* replace missing values in age (Germany, Austria, Canada, US) by midpoints of age5 categories
recode age5 (1=18)(2=22)(3=27)(4=32)(5=37)(6=42)(7=47)(8=52)(9=57)(10=63), gen(age5_midpoints)
replace age = age5_midpoints if c==1 | c==3 | c==9 | c==22

* center age
sum age, meanonly
replace age = age - 16
lab var age "Age (age 16 = value 0)"

* quadratic term
gen age2 = age*age
lab var age2 "Age squared"

gen Age=age+16
lab var Age "Age"

*---------------------------------------------------------------------------------------------*
* Education type (general vs. vocational)
*---------------------------------------------------------------------------------------------*

gen vet=0
replace vet=1 if (EDCAT6==2|EDCAT6==3) & VET==1   
replace vet=1 if EDCAT6==4 		 

lab var vet "Vocational"
label def vet 0 "General" 1 "Vocational"
label val vet vet

*---------------------------------------------------------------------------------------------*
* Skills Testscores 
*---------------------------------------------------------------------------------------------*

foreach var of varlist PVNUM* PVLIT* {    // we divide the variables by 100 so that the coefficients/se's are readable
replace `var'=`var'/100
}


*---------------------------------------------------------------------------------------------*
* Level of education
*---------------------------------------------------------------------------------------------*

recode EDCAT7 (99=.)(1=0 "Primary")(2=1 "Lower secondary")(3 4=2 "Upper or post secondary") ///
	(5 6 7 8 =3 "Tertiary"), gen(edulevel)
lab var edulevel "Level of Education"

*---------------------------------------------------------------------------------------------*
* Gender
*---------------------------------------------------------------------------------------------*

recode GENDER_R (9=.)(1=0 "male")(2=1 "female"), gen(gender)
lab var gender "Female"

*---------------------------------------------------------------------------------------------*
* Highest education parents
*---------------------------------------------------------------------------------------------*

recode PARED (7 8 9=.), gen(edupar)
lab var edupar "Parental Education"

*---------------------------------------------------------------------------------------------*
* Indicators of Vocational Education on Country Level
*---------------------------------------------------------------------------------------------*

* zvoc	
lab var zvoc "Vocational Enrolment"

* zdual
replace zdual = zdual/100
lab var zdual "Dual System Enrolment"
			
***********************************************************************************************
							**** ANALYTICAL SAMPLE ****
***********************************************************************************************

*---------------------------------------------------------------------------------------------*
* EXLUDE CASES
*---------------------------------------------------------------------------------------------*

* currently in education
drop if B_Q02a==1	

* not completed lower secondary education
drop if EDCAT7==1

*---------------------------------------------------------------------------------------------*
* reduce set to have same N for all individual variables
*---------------------------------------------------------------------------------------------*

regress employed age vet edupar gender edulevel PVNUM1 
gen sample = e(sample)
drop if sample==0	

***********************************************************************************************
								**** Weights ****	
**********************************************************************************************
/* Rescale the weights so that they all add up to 1 in a country, This means that all countries 
have equal weight. If we want country size to matter (e.g., Germany more important than 
Belgium in analyses) we should use SPFWT0. We prefer wgt, since we are interested in effects 
at the country level as well. */

//weight for full sample
bys c: egen sw=sum(SPFWT0) 
table c, c(mean sw)
gen wgt=SPFWT0/sw 
sum wgt 
bys c:egen x=sum(wgt) 
table c, c(mean sw mean x)

//weight for male sample
bys c: egen sw_m=sum(SPFWT0) if gender==0
table c if gender==0, c(mean sw_m)
gen wgt_m=SPFWT0/sw_m if gender==0
sum wgt_m if gender==0
bys c:egen x_m=sum(wgt_m) if gender==0
table c if gender==0, c(mean sw_m mean x_m)

//weigth for female sample
bys c: egen sw_f=sum(SPFWT0) if gender==1
table c if gender==1, c(mean sw_f)
gen wgt_f=SPFWT0/sw_f if gender==1
sum wgt_f if gender==1
bys c:egen x_f=sum(wgt_f) if gender==1
table c if gender==1, c(mean sw_f mean x_f)

***********************************************************************************************
						**** Table 1: Descriptive Statistics ****
***********************************************************************************************

* Individual level variables
tab gender

* Male
preserve
	keep if gender==0
			
	piaacdes employed Age vet edulevel edupar, /// 
		save("$posted/des_m") countryid(c) pv("PVNUM") ///
		stats("mean" "sd" "min" "max" "N")
restore

* Female
preserve
	keep if gender==1

	piaacdes employed Age vet edulevel edupar, /// 
		save("$posted/des_f") countryid(c) pv("PVNUM") ///
		stats("mean" "sd" "min" "max" "N")
restore

***********************************************************************************************
							**** Only select variables for analyses ****	
*********************************************************************************************
/*We only keep the variables that we use for our analyses */

keep employed age age2 vet edupar gender edulevel PVNUM* PVLIT* wgt* zvoc zdual Age c cnt 
compress

***********************************************************************************************
								**** SAVE PREPARED DATA ****	
**********************************************************************************************

save "$posted/workingdata.dta", replace

log close
