
/* 
This dofile produces the following figures and tables in the paper:

*	Figure 1: Scatterplot of country level variables

*	Table 2: Pooled Logistic Regression Models with Country Fixed Effects and Employment 
			 as Dependent Variable

*	Table 3: Three-way Interaction Logistic Regression Models with Employment as Dependent
			 Variable

*	Table 4: Country-by-Country Logistic Regressions with Employment as the Dependent Variable 
			 (Selected Coefficients for Men)

*	APPENDIX Table B1: Country-by-Country Logistic Regressions with Employment as the Dependent 
			 Variable (Selected Coefficients for Women)
	
This dofile also prepares data that is used to create figures in R:

*	Marginal effects data used for Figure 2 (Predicted Probabilities of Employment 
	by Type of Education)

*	Marginal effects data of Three-way interaction models used for Figure 3(Average Marginal 
	Effect of VET on Employment in Countries with Low and High Vocational Enrollment)

*	Marginal effects data of Three-way interaction models used for Figure 4(Average Marginal 
	Effect of VET on Employment in Countries with Low and High Dual System Enrollment)

*	Marginal Effects data used for Figure 5: Predicted Probabilities of Employment 
	per Country (Men)

* 	APPENDIX: Marginal Effects Data used for Figure A1 (Predicted Probabilities of Employment 
	by Type of Education (Vocational/General) with Additional Interaction between Age squared 
	and VET)

*	APPENDIX: Marginal Effects Data used for Figure A2 (Average Marginal Effects of VET on 
	Employment for Countries with Low and High Vocational Enrollment (Including Interactions 
	with Age Squared)

* 	Marginal Effects Data used for Figure A3 (Average Marginal Effects of VET on Employment for 
	Countries with Low and High Dual System Enrollment (Including Interactions with Age Squared)

*	APPENDIX Marginal Effects Data used for Figure B1: Predicted Probabilities of Employment 
	per Country (Women)			
*/


/* Customize this path to the location on your computer where you put the downloaded replication 
folder */

* global workingDir "C:\Users\...\...\replication files"

capture global workingDir "C:\Users\aforste1\Dropbox\andrea\research\03_papers\2015_vocational_decline_paper\05_replication files\replication files"
* capture global workingDir "D:\Dropbox\andrea\research\03_papers\2015_vocational_decline_paper\05_replication files\replication files"


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
log using "$logs\analyses.log", replace


* Opening prepped data
use "$posted/workingdata.dta", clear

***********************************************************************************************
									**** MI SET data ****
***********************************************************************************************

gen pvnum=.
gen pvlit=.

mi import wide, imputed(pvnum = PVNUM1-PVNUM10 pvlit = PVLIT1-PVLIT10) clear

lab var pvnum "Numeracy"
lab var pvlit "Literacy"

*---------------------------------------------------------------------------------------------*
* Figure 1: Scatterplot of country level variables
*---------------------------------------------------------------------------------------------*/

egen t_c=tag(c) //country tag

scatter zvoc zdual if t_c==1, mlab(c) mlabsize(vsmall) mlabcolor(black) msymbol(S) mcolor(black) ///
	ytitle("Vocational Enrollment") xtitle("Dual System Enrollment") graphregion(color(white)) ///
	ylab(,nogrid angle(horizontal)) 

	graph export "$graphs/Figure_1.pdf", replace

	
***********************************************************************************************
								**** Regression results ****
***********************************************************************************************

/*---------------------------------------------------------------------------------------------
* Scale age squared to enhance the readability of coefficient and standard error in the tables
---------------------------------------------------------------------------------------------*/

replace age2 = age2/10


/*---------------------------------------------------------------------------------------------
Table 2: Pooled Logistic Regression Models with Country Fixed Effects and Employment 
as Dependent Variable
---------------------------------------------------------------------------------------------*/



	//Men
	mi estimate, post: logit employed age age2 i.edulevel i.edupar i.c ///
		[pweight=wgt_m] if gender==0, robust

	mi estimate, post: logit employed age age2 vet i.edulevel i.edupar i.c ///
		[pweight=wgt_m] if gender==0, robust
	estimate store Im

	mi estimate, post: logit employed age age2 vet c.age#vet i.edulevel i.edupar i.c ///
		[pweight=wgt_m] if gender==0, robust
	estimate store IIm

	mi estimate, post: logit employed age age2 vet c.age#vet ///
		pvnum i.edulevel i.edupar i.c [pweight=wgt_m] if gender==0, robust													

	mi estimate, post: logit employed age age2 vet c.age#vet ///
		pvnum c.age#c.pvnum i.edulevel i.edupar i.c [pweight=wgt_m] if gender==0, robust													
	estimate store IIIm

	//Women
	mi estimate, post: logit employed age age2 i.edulevel i.edupar i.c ///
		[pweight=wgt_f] if gender==1, robust

	mi estimate, post: logit employed age age2 vet i.edulevel i.edupar i.c ///
		[pweight=wgt_f] if gender==1, robust
	estimate store If

	mi estimate, post: logit employed age age2 vet c.age#vet i.edulevel i.edupar i.c ///
		[pweight=wgt_f] if gender==1, robust
	estimate store IIf

	mi estimate, post: logit employed age age2 vet c.age#vet ///
		pvnum i.edulevel i.edupar i.c [pweight=wgt_f] if gender==1, robust													

	mi estimate, post: logit employed age age2 vet c.age#vet ///
		pvnum c.age#c.pvnum i.edulevel i.edupar i.c [pweight=wgt_f] if gender==1, robust													
	estimate store IIIf
			
* Table men and women

esttab Im IIm IIIm If IIf IIIf using "$tables/Table_2.tex", replace label ///
	nodepvar ///
	alignment (S S) ///	
	order(age age2 vet 1.vet#c.age pvnum c.age#c.pvnum 2.edulevel 3.edulevel 2.edupar 3.edupar) ///
	drop(*.c 1.edulevel 1.edupar 0.vet#c.age)  ///
	star(* 0.05 \dag 0.01) ///
	coeflabels(1.vet#c.age "Age $\times$ Vet" c.age#c.pvnum  "Age $\times$ Numeracy" 2.edupar "Secondary" 3.edupar "Tertiary") ///
	refcat(2.edupar "Parental Education" 2.edulevel "Level of Education", nolabel) ///
	b(3) se
	
estimates clear 

/*---------------------------------------------------------------------------------------------
 Marginal effects data used for Figure 2 (Predicted Probabilities of Employment 
 by Type of Education)
---------------------------------------------------------------------------------------------*/

	//MEN					
	mi estimate, post saving(est, replace): logit employed  	///
		c.Age##c.Age c.Age##i.vet c.Age##c.pvnum i.edulevel i.edupar i.c [pweight=wgt_m] if gender==0, robust												
	
	mimrgns vet, at(Age=(15(5)65)) predict(pr) post cmdmargins

	preserve
		matrix b=e(b)
		matrix V=e(V)
		
		keep vet
		bys vet: gen Age=_n

		label drop vet
		label def vet 0 "General" 1 "Vocational"
		lab val vet vet
		gen b=.
		gen se=.
		
		forval x=1(2)21{
			replace b=b[1,`x'] if Age==`x' & vet==0
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==0
		}
		
		forval x=2(2)22{
			replace b=b[1,`x'] if Age==`x' & vet==1
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==1
		}		
		
		drop if b==.
		
		recode Age 1 2=15 3 4=20 5 6=25 7 8=30 9 10=35 11 12=40 13 14=45 15 16=50 17 18=55 19 20=60 21 22=65 
		saveold "$posted/fig2_data_m.dta", replace
	restore

		
	//WOMEN
	mi estimate, post saving(est, replace): logit employed  	///
		c.Age##c.Age c.Age##i.vet c.Age##c.pvnum i.edulevel i.edupar i.c [pweight=wgt_f] if gender==1, robust												

		mimrgns vet, at(Age=(15(5)65)) predict(pr) post cmdmargins

	preserve
		matrix b=e(b)
		matrix V=e(V)
		
		keep vet
		bys vet: gen Age=_n

		label drop vet
		label def vet 0 "General" 1 "Vocational"
		lab val vet vet
		gen b=.
		gen se=.
		
		forval x=1(2)21{
			replace b=b[1,`x'] if Age==`x' & vet==0
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==0
		}
		
		forval x=2(2)22{
			replace b=b[1,`x'] if Age==`x' & vet==1
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==1
		}		
		
		drop if b==.
		
		recode Age 1 2=15 3 4=20 5 6=25 7 8=30 9 10=35 11 12=40 13 14=45 15 16=50 17 18=55 19 20=60 21 22=65 
		saveold "$posted/fig2_data_f.dta", replace
	restore
estimates clear

/*---------------------------------------------------------------------------------------------
Table 3: Three-way Interaction Logistic Regression Models with Employment as Dependent
Variable
---------------------------------------------------------------------------------------------*/

//ZVOC
	
	//Men
	mi estimate, post: logit employed  i.c c.age2 c.age##vet##c.zvoc	/// 
		c.age##c.pvnum i.edulevel i.edupar [pw=wgt_m] if gender==0
	estimates store zvoc_m

	//Women
	mi estimate, post: logit employed  i.c c.age2 c.age##vet##c.zvoc	/// 
		c.age##c.pvnum i.edulevel i.edupar [pw=wgt_f] if gender==1
	estimates store zvoc_f
	
	esttab zvoc_m zvoc_f using "$tables/Table_3_zvoc.tex", replace label ///
	nodepvar ///
	alignment (S S) ///
	order(age vet 1.vet#c.age ) ///
	drop(*.c 1.vet#c.age 1.edulevel 1.edupar pvnum)  ///
	star(* 0.05 \dag 0.01) ///
	coeflabels(1.vet#c.age "Age $\times$ Vet") ///
	b(3) se
	
	estimates clear 	
	
//ZDUAL
	
	//Men
	mi estimate, post: logit employed  i.c c.age2 c.age##vet##c.zdual									/// 
		c.age##c.pvnum i.edulevel i.edupar [pw=wgt_m] if gender==0
	estimates store zdual_m
	
	//Women
	mi estimate, post: logit employed  i.c c.age2 c.age##vet##c.zdual									/// 
		c.age##c.pvnum i.edulevel i.edupar [pw=wgt_f] if gender==1
	estimates store zdual_f
	
	esttab zdual_m zdual_f using "$tables/Table_3_zdual.tex", replace label ///
	nodepvar ///
	alignment (S S) ///
	order(age vet 1.vet#c.age ) ///
	drop(*.c 1.vet#c.age 1.edulevel 1.edupar pvnum)  ///
	star(* 0.05 \dag 0.01) ///
	coeflabels(1.vet#c.age "Age $\times$ Vet") ///
	b(3) se
	
	estimates clear 

	
/*---------------------------------------------------------------------------------------------
Marginal effects data of Three-way interaction models used for Figure 3(Average Marginal 
Effect of VET on Employment in Countries with Low and High Vocational Enrollment)
---------------------------------------------------------------------------------------------*/

	//Men
	mi estimate, post: logit employed  i.c c.Age##c.Age c.Age##vet##c.zvoc									/// 
		c.Age##c.pvnum i.edulevel i.edupar [pw=wgt_m] if gender==0

	mimrgns, dydx(vet) at(Age=(15(5)65) zvoc=(-1.5 1.5))  post predict(pr) noestimcheck cmdmargins

	
	preserve
		matrix b=e(b)
		matrix V=e(V)
		
		keep Age vet
		duplicates drop Age vet, force
		label drop vet
		label def vet 0 "Low % Voc. Enrollment" 1 "High % Voc. Enrollment"
		lab val vet vet
		gen b=.
		gen se=.
		
		forval x=23(2)43{
			replace b=b[1,`x'] if Age==`x' & vet==0
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==0
		}
		
		forval x=24(2)44{
			replace b=b[1,`x'] if Age==`x' & vet==1
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==1
		}		
		
		drop if b==.
		
		recode Age 23 24=15 25 26=20 27 28=25 29 30=30 31 32=35 33 34=40 35 36=45 37 38=50 39 40=55 41 42=60 43 44=65 
		saveold "$posted/fig3_data_m.dta", replace
	restore
	

	//Women
	mi estimate, post: logit employed  i.c c.Age##c.Age c.Age##vet##c.zvoc									/// 
		c.Age##c.pvnum i.edulevel i.edupar [pw=wgt_f] if gender==1

	mimrgns, dydx(vet) at(Age=(15(5)65) zvoc=(-1.5 1.5))  post predict(pr) noestimcheck cmdmargins

	preserve
		matrix b=e(b)
		matrix V=e(V)
		
		keep Age vet
		duplicates drop Age vet, force
		label drop vet
		label def vet 0 "Low % Voc. Enrollment" 1 "High % Voc. Enrollment"
		lab val vet vet
		gen b=.
		gen se=.
		
		forval x=23(2)43{
			replace b=b[1,`x'] if Age==`x' & vet==0
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==0
		}
		
		forval x=24(2)44{
			replace b=b[1,`x'] if Age==`x' & vet==1
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==1
		}		
		
		drop if b==.
		
		recode Age 23 24=15 25 26=20 27 28=25 29 30=30 31 32=35 33 34=40 35 36=45 37 38=50 39 40=55 41 42=60 43 44=65 
		saveold "$posted/fig3_data_f.dta", replace
	restore
	
/*---------------------------------------------------------------------------------------------
Marginal effects data of Three-way interaction models used for Figure 4(Average Marginal 
Effect of VET on Employment in Countries with Low and High Dual System Enrollment)
---------------------------------------------------------------------------------------------*/

	//Men
	mi estimate, post: logit employed  i.c c.Age##c.Age c.Age##vet##c.zdual	c.Age##vet##c.zdual								/// 
		c.Age##c.pvnum i.edulevel i.edupar [pw=wgt_m] if gender==0

	mimrgns, dydx(vet) at(Age=(15(5)65) zdual=(0 0.45))  post predict(pr) noestimcheck cmdmargins

	preserve
		matrix b=e(b)
		matrix V=e(V)
		
		keep Age vet
		duplicates drop Age vet, force
		label drop vet
		label def vet 0 "Low % Dual System" 1 "High % Dual System"
		lab val vet vet
		gen b=.
		gen se=.
		
		forval x=23(2)43{
			replace b=b[1,`x'] if Age==`x' & vet==0
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==0
		}
		
		forval x=24(2)44{
			replace b=b[1,`x'] if Age==`x' & vet==1
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==1
		}		
		
		drop if b==.
		
		recode Age 23 24=15 25 26=20 27 28=25 29 30=30 31 32=35 33 34=40 35 ///
			36=45 37 38=50 39 40=55 41 42=60 43 44=65 
		saveold "$posted/fig4_data_m.dta", replace
	restore
	
	
	//Women
	mi estimate, post: logit employed  i.c c.Age##c.Age c.Age##vet##c.zdual									/// 
		c.Age##c.pvnum i.edulevel i.edupar [pw=wgt_f] if gender==1

	mimrgns, dydx(vet) at(Age=(15(5)65) zdual=(0 0.45))  post predict(pr) noestimcheck cmdmargins
	preserve
		matrix b=e(b)
		matrix V=e(V)
		
		keep Age vet
		duplicates drop Age vet, force
		label drop vet
		label def vet 0 "Low % Dual System" 1 "High % Dual System"
		lab val vet vet
		gen b=.
		gen se=.
		
		forval x=23(2)43{
			replace b=b[1,`x'] if Age==`x' & vet==0
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==0
		}
		
		forval x=24(2)44{
			replace b=b[1,`x'] if Age==`x' & vet==1
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==1
		}		
		
		drop if b==.
		
		recode Age 23 24=15 25 26=20 27 28=25 29 30=30 31 32=35 33 ///
		34=40 35 36=45 37 38=50 39 40=55 41 42=60 43 44=65 
		saveold "$posted/fig4_data_f.dta", replace
	restore
	
/*---------------------------------------------------------------------------------------------
Table 4: Country-by-Country Logistic Regressions with Employment as the Dependent Variable 
(Selected Coefficients for Men)
---------------------------------------------------------------------------------------------*/
estimates clear 

* men
forval x=1(1)22 {
  local t : label c_short `x'
   display "`t'"

   mi estimate, post: logit employed  	///
	c.age2 c.age##i.vet c.age##c.pvnum i.edulevel i.edupar ///
	[pweight=wgt_m] if gender==0 & c==`x', robust												
	
	estimates store cnt`x'

}
*
esttab cnt1 cnt2 cnt3 cnt4 cnt5 cnt6 cnt7 cnt8 cnt9 cnt10 cnt11 ///
	using "$tables/Table_4a.tex", replace label ///
	nodepvar ///
	order(age c.age2 vet) ///
	drop(*.edulevel *.edupar pvnum c.age#c.pvnum)  ///
	star(* 0.05 \dag 0.01) ///
	b(3) se	

esttab cnt12 cnt13 cnt14 cnt15 cnt16 cnt17 cnt18 cnt19 cnt20 cnt21 cnt22 ///
	using "$tables/Table_4b.tex", replace label ///
	nodepvar ///
	order(age c.age2 vet) ///
	drop(*.edulevel *.edupar pvnum c.age#c.pvnum)  ///
	star(* 0.05 \dag 0.01) ///
	b(3) se	
	
*---------------------------------------------------------------------------------------------*
* Marginal Effects data used for Figure 5: Predicted Probabilities of Employment per Country (Men)
*---------------------------------------------------------------------------------------------*

///MEN
forval x=1(1)22 {
  local t : label c_short `x'
   display "`t'"
  local l : label c `x'
   display "`l'"
  local y=`x' 
   
   mi estimate, post saving(est, replace): logit employed  	///
	c.Age##c.Age c.Age##i.vet c.Age##c.pvnum i.edulevel i.edupar ///
	[pweight=wgt_m] if gender==0 & c==`x', robust												
	
	mimrgns vet, at(Age=(15(5)65)) predict(pr) post cmdmargins

	
	
	
		preserve
			matrix b=e(b)
			matrix V=e(V)
			
			keep vet
			bys vet: gen Age=_n

			label drop vet
			label def vet 0 "General" 1 "Vocational"
			lab val vet vet
			gen b=.
			gen se=.
			
			forval x=1(2)21{
				replace b=b[1,`x'] if Age==`x' & vet==0
				replace se=sqrt(V[`x',`x']) if Age==`x' & vet==0
			}
			
			forval x=2(2)22{
				replace b=b[1,`x'] if Age==`x' & vet==1
				replace se=sqrt(V[`x',`x']) if Age==`x' & vet==1
			}		
			
			drop if b==.
			
			gen country="`l'"
			recode Age 1 2=15 3 4=20 5 6=25 7 8=30 9 10=35 11 12=40 13 ///
				14=45 15 16=50 17 18=55 19 20=60 21 22=65 
			
			set trace on
			tempfile temp`y'    /* create a temporary file */
			save `temp`y''
			set trace off
		restore
	} 
	
	
preserve
	use `temp1', clear
	
	forval x=2(1)22 {
		append using `temp`x''
	}
	
	saveold "$posted/fig5_data.dta", replace
 restore
		
/*---------------------------------------------------------------------------------------------
APPENDIX: Marginal Effects Data used for Figure A1 (Predicted Probabilities of Employment by 
Type of Education (Vocational/General) with Additional Interaction between Age squared and VET)
---------------------------------------------------------------------------------------------*/

//MEN					
	mi estimate, post saving(est, replace): logit employed  	///
		c.Age##c.Age##i.vet c.Age##c.pvnum i.edulevel i.edupar i.c ///
		[pweight=wgt_m] if gender==0, robust												
	
	mimrgns vet, at(Age=(15(5)65)) predict(pr) post cmdmargins

	preserve
		matrix b=e(b)
		matrix V=e(V)
		
		keep vet
		bys vet: gen Age=_n

		label drop vet
		label def vet 0 "General" 1 "Vocational"
		lab val vet vet
		gen b=.
		gen se=.
		
		forval x=1(2)21{
			replace b=b[1,`x'] if Age==`x' & vet==0
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==0
		}
		
		forval x=2(2)22{
			replace b=b[1,`x'] if Age==`x' & vet==1
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==1
		}		
		
		drop if b==.
		
		recode Age 1 2=15 3 4=20 5 6=25 7 8=30 9 10=35 11 12=40 13 14=45 15 ///
			16=50 17 18=55 19 20=60 21 22=65 
		saveold "$posted/app1_data_m.dta", replace
	restore
		
//WOMEN
	mi estimate, post saving(est, replace): logit employed  	///
		c.Age##c.Age##i.vet c.Age##c.pvnum i.edulevel i.edupar i.c ///
		[pweight=wgt_f] if gender==1, robust												

		mimrgns vet, at(Age=(15(5)65)) predict(pr) post cmdmargins

	preserve
		matrix b=e(b)
		matrix V=e(V)
		
		keep vet
		bys vet: gen Age=_n

		label drop vet
		label def vet 0 "General" 1 "Vocational"
		lab val vet vet	
		gen b=.
		gen se=.
		
		forval x=1(2)21{
			replace b=b[1,`x'] if Age==`x' & vet==0
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==0
		}
		
		forval x=2(2)22{
			replace b=b[1,`x'] if Age==`x' & vet==1
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==1
		}		
		
		drop if b==.
		
		recode Age 1 2=15 3 4=20 5 6=25 7 8=30 9 10=35 11 12=40 13 14=45 15 ///
			16=50 17 18=55 19 20=60 21 22=65 
		saveold "$posted/app1_data_f.dta", replace
	restore
estimates clear

/*---------------------------------------------------------------------------------------------
APPENDIX: Marginal Effects Data used for Figure A2 (Average Marginal Effects of VET on 
Employment for Countries with Low and High Vocational Enrollment (Including Interactions 
with Age Squared)
---------------------------------------------------------------------------------------------*/

//Men
	mi estimate, post: logit employed  i.c c.Age##c.Age##vet##c.zvoc									/// 
		c.Age##c.pvnum i.edulevel i.edupar [pw=wgt_m] if gender==0

	mimrgns, dydx(vet) at(Age=(15(5)65) zvoc=(-1.5 1.5))  post predict(pr) noestimcheck cmdmargins

	
	preserve
		matrix b=e(b)
		matrix V=e(V)
		
		keep Age vet
		duplicates drop Age vet, force
		label drop vet
		label def vet 0 "Low % Voc. Enrollment" 1 "High % Voc. Enrollment"
		lab val vet vet
		gen b=.
		gen se=.
		
		forval x=23(2)43{
			replace b=b[1,`x'] if Age==`x' & vet==0
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==0
		}
		
		forval x=24(2)44{
			replace b=b[1,`x'] if Age==`x' & vet==1
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==1
		}		
		
		drop if b==.
		
		recode Age 23 24=15 25 26=20 27 28=25 29 30=30 31 32=35 33 ///
			34=40 35 36=45 37 38=50 39 40=55 41 42=60 43 44=65 
		saveold "$posted/app2_data_zvoc_m.dta", replace
	restore
	

//Women
	mi estimate, post: logit employed  i.c c.Age##c.Age##vet##c.zvoc									/// 
		c.Age##c.pvnum i.edulevel i.edupar [pw=wgt_f] if gender==1

	mimrgns, dydx(vet) at(Age=(15(5)65) zvoc=(-1.5 1.5))  post predict(pr) noestimcheck cmdmargins

	preserve
		matrix b=e(b)
		matrix V=e(V)
		
		keep Age vet
		duplicates drop Age vet, force
		label drop vet
		label def vet 0 "Low % Voc. Enrollment" 1 "High % Voc. Enrollment"
		lab val vet vet
		gen b=.
		gen se=.
		
		forval x=23(2)43{
			replace b=b[1,`x'] if Age==`x' & vet==0
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==0
		}
		
		forval x=24(2)44{
			replace b=b[1,`x'] if Age==`x' & vet==1
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==1
		}		
		
		drop if b==.
		
		recode Age 23 24=15 25 26=20 27 28=25 29 30=30 31 32=35 33 ///
			34=40 35 36=45 37 38=50 39 40=55 41 42=60 43 44=65 
		saveold "$posted/app2_data_zvoc_f.dta", replace
	restore
	
/*---------------------------------------------------------------------------------------------
Marginal Effects Data used for Figure A3 (Average Marginal Effects of VET on Employment for 
Countries with Low and High Dual System Enrollment (Including Interactions with Age Squared)
---------------------------------------------------------------------------------------------*/

//Men
	mi estimate, post: logit employed  i.c c.Age##c.Age##vet##c.zdual						/// 
		c.Age##c.pvnum i.edulevel i.edupar [pw=wgt_m] if gender==0

	mimrgns, dydx(vet) at(Age=(15(5)65) zdual=(0 0.45))  post predict(pr) noestimcheck cmdmargins

	preserve
		matrix b=e(b)
		matrix V=e(V)
		
		keep Age vet
		duplicates drop Age vet, force
		label drop vet
		label def vet 0 "Low % Dual System" 1 "High % Dual System"
		lab val vet vet
		gen b=.
		gen se=.
		
		forval x=23(2)43{
			replace b=b[1,`x'] if Age==`x' & vet==0
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==0
		}
		
		forval x=24(2)44{
			replace b=b[1,`x'] if Age==`x' & vet==1
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==1
		}		
		
		drop if b==.
		
		recode Age 23 24=15 25 26=20 27 28=25 29 30=30 31 32=35 33 34=40 35 36=45 37 38=50 39 40=55 41 42=60 43 44=65 
		saveold "$posted/app2_data_zdual_m.dta", replace
	restore
	
	
//Women
	mi estimate, post: logit employed  i.c c.Age##c.Age##vet##c.zdual									/// 
		c.Age##c.pvnum i.edulevel i.edupar [pw=wgt_f] if gender==1

	mimrgns, dydx(vet) at(Age=(15(5)65) zdual=(0 0.45))  post predict(pr) noestimcheck cmdmargins
	preserve
		matrix b=e(b)
		matrix V=e(V)
		
		keep Age vet
		duplicates drop Age vet, force
		label drop vet
		label def vet 0 "Low % Dual System" 1 "High % Dual System"
		lab val vet vet
		gen b=.
		gen se=.
		
		forval x=23(2)43{
			replace b=b[1,`x'] if Age==`x' & vet==0
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==0
		}
		
		forval x=24(2)44{
			replace b=b[1,`x'] if Age==`x' & vet==1
			replace se=sqrt(V[`x',`x']) if Age==`x' & vet==1
		}		
		
		drop if b==.
		
		recode Age 23 24=15 25 26=20 27 28=25 29 30=30 31 32=35 33 34=40 35 36=45 37 38=50 39 40=55 41 42=60 43 44=65 
		saveold "$posted/app2_data_zdual_f.dta", replace
	restore

/*---------------------------------------------------------------------------------------------
APPENDIX Table B2: Country-by-Country Logistic Regressions with Employment as the Dependent 
Variable (Selected Coefficients for Women)
---------------------------------------------------------------------------------------------*/
estimates clear 

forval x=1(1)22 {
  local t : label c_short `x'
   display "`t'"

   mi estimate, post: logit employed  	///
	c.age2 c.age##i.vet c.age##c.pvnum i.edulevel i.edupar ///
	[pweight=wgt_f] if gender==1 & c==`x', robust												
	
	estimates store cnt`x'

}
*		
	
esttab cnt1 cnt2 cnt3 cnt4 cnt5 cnt6 cnt7 cnt8 cnt9 cnt10 cnt11 ///
	using "$tables/Appendix_B1a.tex", replace label ///
	nodepvar ///
	order(age c.age2 vet) ///
	drop(*.edulevel *.edupar pvnum c.age#c.pvnum)  ///
	star(* 0.05 \dag 0.01) ///
	b(3) se	

esttab cnt12 cnt13 cnt14 cnt15 cnt16 cnt17 cnt18 cnt19 cnt20 cnt21 cnt22 ///
	using "$tables/Appendix_B1b.tex", replace label ///
	nodepvar ///
	order(age c.age2 vet) ///
	drop(*.edulevel *.edupar pvnum c.age#c.pvnum)  ///
	star(* 0.05 \dag 0.01) ///
	b(3) se	
	
/*---------------------------------------------------------------------------------------------
APPENDIX Marginal Effects Data used for Figure B1: Predicted Probabilities of Employment 
per Country (Women)		
---------------------------------------------------------------------------------------------*/

forval x=1(1)22 {
  local t : label c_short `x'
   display "`t'"
  local l : label c `x'
   display "`l'"
  local y=`x' 
   
   mi estimate, post saving(est, replace): logit employed  	///
	c.Age##c.Age c.Age##i.vet c.Age##c.pvnum i.edulevel i.edupar ///
	[pweight=wgt_f] if gender==1 & c==`x', robust												
	
	mimrgns vet, at(Age=(15(5)65)) predict(pr) post cmdmargins

		preserve
			matrix b=e(b)
			matrix V=e(V)
			
			keep vet
			bys vet: gen Age=_n

			label drop vet
			label def vet 0 "General" 1 "Vocational"
			lab val vet vet
			gen b=.
			gen se=.
			
			forval x=1(2)21{
				replace b=b[1,`x'] if Age==`x' & vet==0
				replace se=sqrt(V[`x',`x']) if Age==`x' & vet==0
			}
			
			forval x=2(2)22{
				replace b=b[1,`x'] if Age==`x' & vet==1
				replace se=sqrt(V[`x',`x']) if Age==`x' & vet==1
			}		
			
			drop if b==.
			
			gen country="`l'"
			recode Age 1 2=15 3 4=20 5 6=25 7 8=30 9 10=35 11 12=40 ///
			13 14=45 15 16=50 17 18=55 19 20=60 21 22=65 
			
			set trace on
			tempfile temp`y'    /* create a temporary file */
			save `temp`y''
			set trace off
		restore
	} 
	
	
preserve
	use `temp1', clear
	
	forval x=2(1)22 {
		append using `temp`x''
	}
	
	saveold "$posted/app3_data.dta", replace
 restore
		
		
		

log close			
			
