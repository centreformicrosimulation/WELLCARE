/**************************************************************************************
*
*	PROGRAM TO ANALYSE FORWARD PROJECTIONS FOR SOCIAL CARE RECEIPT
*
*	Last version:  Justin van de Ven, 11 Mar 2025
*	First version: Justin van de Ven, 11 Mar 2025
*
*************************************************************************************/

global moddir = "C:\Justin\dev\WELLCARE\output\\$run_name\csv"
global outdir = "C:\Justin\dev\WELLCARE\analysis\data"
cd "$outdir"
log using "${run_name}_receipt", replace


/**************************************************************************************
*	start
*************************************************************************************/

/**************************************************************************************
*	load data
*************************************************************************************/
// import delimited using "$moddir\BenefitUnit.csv", clear
// rename *, l
// rename id_benefitunit idbenefitunit
// gsort idbenefitunit time
// save "$outdir\\${run_name}_temp0", replace
// import delimited using "$moddir\Person.csv", clear
// rename *, l
// rename id_person idperson
// rename socialcareprovision socialcareprovision_p
// gsort idbenefitunit time idperson
// merge m:1 idbenefitunit time using ${run_name}_temp0
// gsort time idbenefitunit idperson
// gen refbenefitunit = 0
// replace refbenefitunit = 1 if (idbenefitunit != idbenefitunit[_n-1])
//
// foreach vv of varlist carehoursfrompartnerweekly carehoursfromdaughterweekly ///
// carehoursfromsonweekly carehoursfromotherweekly carehoursfromparentweekly ///
// carehoursfromformalweekly socialcaresupportpermonth disabilitysupportpermonth ///
// carersupportpermonth {
// 	destring `vv', replace force
// 	recode `vv' (missing=0)
// }
//
// destring hoursworkedweekly, replace force
// recode hoursworkedweekly (missing=0)
// gen idNotEmployedAdult = (hoursworkedweekly<0.1 & dag>17)
//
// gen led = (deh_c3=="Low")
// gen med = (deh_c3=="Medium")
// gen hed = (deh_c3=="High")
//
// gen male = (dgn=="Male")
//
// gen idna = (dag>17)
// gen idnk = (dag<18)
// bys time idbenefitunit: egen partnered = sum(idna)
// replace partnered = partnered - 1
// bys time idbenefitunit: egen nk = sum(idnk)
//
// gen needCare = (needsocialcare=="True")
// gen informalCareHours = carehoursfrompartnerweekly + carehoursfromdaughterweekly + carehoursfromsonweekly + carehoursfromotherweekly + carehoursfromparentweekly
// gen totalCareHours = informalCareHours + carehoursfromformalweekly
// gen recCare = (totalCareHours>0.01)
// gen prvCare = (carehoursprovidedweekly>0.01)
//
// save "$outdir\\${run_name}_temp1", replace


/*******************************************************************************
*	social care receipt
*******************************************************************************/
use "$outdir\\${run_name}_temp1", clear

// block 1 statistics
matrix store1 = J(2070-2018,11,.)
forvalues yy = 2019/2070 {
	qui {
		local jj = 1
		count if (time==`yy' & needCare & dag<45)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & needCare & dag>44 & dag<65)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & needCare & dag>64 & dag<80)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & needCare & dag>79)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & recCare & dag<45)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & recCare & dag>44 & dag<65)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & recCare & dag>64 & dag<80)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & recCare & dag>79)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & recCare & needCare & dag>64 & dag<80)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & recCare & needCare & dag>79)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy')
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
	}
}
matlist store1

// block 1b statistics
gen WL = (region=="UKL")
gen SC = (region=="UKM")
gen NI = (region=="UKN")
gen EN = 1 - WL - SC - NI
matrix store1b = J(2070-2018,12,.)
forvalues yy = 2019/2070 {
	qui {
		local jj = 1
		count if (time==`yy' & dag>64 & needCare & EN)
		mat store1b[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & dag>64 & needCare & WL)
		mat store1b[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & dag>64 & needCare & SC)
		mat store1b[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & dag>64 & needCare & NI)
		mat store1b[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & dag>64 & recCare & EN)
		mat store1b[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & dag>64 & recCare & WL)
		mat store1b[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & dag>64 & recCare & SC)
		mat store1b[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & dag>64 & recCare & NI)
		mat store1b[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & dag>64 & recCare & needCare & EN)
		mat store1b[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & dag>64 & recCare & needCare & WL)
		mat store1b[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & dag>64 & recCare & needCare & SC)
		mat store1b[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & dag>64 & recCare & needCare & NI)
		mat store1b[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
	}
}
matlist store1b

matrix store1c = J(2070-2018,4,.)
forvalues yy = 2019/2070 {
	qui {
		local jj = 1
		sum totalCareHours if (time==`yy' & dag>64 & recCare & EN), mean
		mat store1c[`yy'-2018,`jj'] = r(mean)
		local jj = `jj' + 1
		sum totalCareHours if (time==`yy' & dag>64 & recCare & WL), mean
		mat store1c[`yy'-2018,`jj'] = r(mean)
		local jj = `jj' + 1
		sum totalCareHours if (time==`yy' & dag>64 & recCare & SC), mean
		mat store1c[`yy'-2018,`jj'] = r(mean)
		local jj = `jj' + 1
		sum totalCareHours if (time==`yy' & dag>64 & recCare & NI), mean
		mat store1c[`yy'-2018,`jj'] = r(mean)
		local jj = `jj' + 1
	}
}
matlist store1c

// block 2 statistics
matrix store2 = J(2070-2018,4,.)
forvalues yy = 2019/2070 {
	qui {
		sum totalCareHours if (time==`yy' & dag<45 & recCare), mean
		mat store2[`yy'-2018,1] = r(mean)
		sum totalCareHours if (time==`yy' & dag>44 & dag<65 & recCare), mean
		mat store2[`yy'-2018,2] = r(mean)
		sum totalCareHours if (time==`yy' & dag>64 & dag<80 & recCare), mean
		mat store2[`yy'-2018,3] = r(mean)
		sum totalCareHours if (time==`yy' & dag>79 & recCare), mean
		mat store2[`yy'-2018,4] = r(mean)
	}
}
matlist store2

// block 3 statistics
matrix store3 = J(2070-2018,4,.)
forvalues yy = 2019/2070 {
	qui {
		count if (time==`yy' & dag<45 & carehoursfromformalweekly>0.0)
		mat store3[`yy'-2018,1] = r(N)
		count if (time==`yy' & dag>44 & dag<65 & carehoursfromformalweekly>0.0)
		mat store3[`yy'-2018,2] = r(N)
		count if (time==`yy' & dag>64 & dag<80 & carehoursfromformalweekly>0.0)
		mat store3[`yy'-2018,3] = r(N)
		count if (time==`yy' & dag>79 & carehoursfromformalweekly>0.0)
		mat store3[`yy'-2018,4] = r(N)
	}
}
matlist store3

// block 4 statistics
matrix store4 = J(2070-2018,2,.)
forvalues yy = 2019/2070 {
	qui {
		sum carehoursfromformalweekly if (time==`yy' & dag>64 & dag<80 & carehoursfromformalweekly>0), mean
		mat store4[`yy'-2018,1] = r(mean)
		sum carehoursfromformalweekly if (time==`yy' & dag>79 & carehoursfromformalweekly>0), mean
		mat store4[`yy'-2018,2] = r(mean)
	}
}
matlist store4

// block 5 statistics
matrix store5 = J(2070-2018,2,.)
forvalues yy = 2019/2070 {
	qui {
		sum careformalexpenditureweekly if (time==`yy' & dag>64 & dag<80 & carehoursfromformalweekly>0), mean
		mat store5[`yy'-2018,1] = r(mean)
		sum careformalexpenditureweekly if (time==`yy' & dag>79 & carehoursfromformalweekly>0), mean
		mat store5[`yy'-2018,2] = r(mean)
	}
}
matlist store5

// block 6 statistics
gen disBen = disabilitysupportpermonth * (disabilitysupportpermonth>0) * 1.2663	// from 2015 prices (consistent with model assumptions)
gen dbld = (dlltsd=="True")
bys time idbenefitunit: egen nodbld = sum(dbld)
replace disBen = disBen / nodbld if (nodbld>1)
gen recDisBen = (disBen>0.01)*dbld
matrix store6 = J(2070-2018,4,.)
forvalues yy = 2019/2070 {
	qui {
		count if (time==`yy' & dag>17 & dag<45 & recDisBen)
		mat store6[`yy'-2018,1] = r(N)
		sum disBen if (time==`yy' & dag>17 & dag<45 & recDisBen), mean
		mat store6[`yy'-2018,2] = r(mean)
		count if (time==`yy' & dag>44 & dag<65 & recDisBen)
		mat store6[`yy'-2018,3] = r(N)
		sum disBen if (time==`yy' & dag>44 & dag<65 & recDisBen), mean
		mat store6[`yy'-2018,4] = r(mean)
	}
}
matlist store6

// block 7 statistics
matrix store7 = J(2070-2018,2,.)
forvalues yy = 2019/2070 {
	qui {
		count if (time==`yy' & dag>17 & dag<45 & dbld)
		mat store7[`yy'-2018,1] = r(N)
		count if (time==`yy' & dag>44 & dag<65 & dbld)
		mat store7[`yy'-2018,2] = r(N)
	}
}
matlist store7

// block 8 statistics
matrix store8 = J(2070-2018,4,.)
forvalues yy = 2019/2070 {
	qui {
		count if (time==`yy' & dag>17 & dag<45)
		mat store8[`yy'-2018,1] = r(N)
		count if (time==`yy' & dag>44 & dag<65)
		mat store8[`yy'-2018,2] = r(N)
		count if (time==`yy' & dag>64 & dag<80)
		mat store8[`yy'-2018,3] = r(N)
		count if (time==`yy' & dag>79)
		mat store8[`yy'-2018,4] = r(N)
	}
}
matlist store8

// block 9 statistics
gen scBen = socialcaresupportpermonth * (socialcaresupportpermonth>0) * 1.2663	// from 2015 prices (consistent with model assumptions)
gen fc = (carehoursfromformalweekly>0)
bys time idbenefitunit: egen nofc = sum(fc)
replace scBen = scBen / nofc if (nofc>1)
gen recScBen = (scBen>0.01) * fc
matrix store9 = J(2070-2018,6,.)
forvalues yy = 2019/2070 {
	qui {
		count if (time==`yy' & dag>64 & dag<80 & needCare)
		mat store9[`yy'-2018,1] = r(N)
		count if (time==`yy' & dag>79 & needCare)
		mat store9[`yy'-2018,2] = r(N)
		count if (time==`yy' & dag>64 & dag<80 & fc & recScBen)
		mat store9[`yy'-2018,3] = r(N)
		sum scBen if (time==`yy' & dag>64 & dag<80 & fc & recScBen), mean
		mat store9[`yy'-2018,4] = r(mean)
		count if (time==`yy' & dag>79 & fc & recScBen)
		mat store9[`yy'-2018,5] = r(N)
		sum scBen if (time==`yy' & dag>79 & fc & recScBen), mean
		mat store9[`yy'-2018,6] = r(mean)
	}
}
matlist store9

// block 10 statistics
gsort time idbenefitunit
gen flagBU = 0
replace flagBU = 1 if (idbenefitunit != idbenefitunit[_n-1])
gen needCareU45 = (dag<45) * needCare
gen needCare45to64 = (dag<65) * (dag>44) * needCare
gen needCare65to79 = (dag<80) * (dag>64) * needCare
gen needCare80p = (dag>79) * needCare
bys time idbenefitunit: egen buNeedCareAll = max(needCare)
bys time idbenefitunit: egen buNeedCareU45 = max(needCareU45)
bys time idbenefitunit: egen buNeedCare45to64 = max(needCare45to64)
bys time idbenefitunit: egen buNeedCare65to79 = max(needCare65to79)
bys time idbenefitunit: egen buNeedCare80p = max(needCare80p)
matrix store10 = J(2070-2018,6,.)
forvalues yy = 2019/2070 {
	qui {
		preserve
		keep if (time==`yy')
		
		noisily display "analysis for year " + `yy'
		sum equivaliseddisposableincomeyearl if (time==`yy' & flagBU), detail
		local povLine = 0.6 * r(p50)
		gen poor = (equivaliseddisposableincomeyearl < `povLine')
		sum poor, mean
		mat store10[`yy'-2018,1] = r(mean)
		sum poor if (buNeedCareAll), mean
		mat store10[`yy'-2018,2] = r(mean)
		sum poor if (buNeedCareU45), mean
		mat store10[`yy'-2018,3] = r(mean)
		sum poor if (buNeedCare45to64), mean
		mat store10[`yy'-2018,4] = r(mean)
		sum poor if (buNeedCare65to79), mean
		mat store10[`yy'-2018,5] = r(mean)
		sum poor if (buNeedCare80p), mean
		mat store10[`yy'-2018,6] = r(mean)
		
		restore
	}
}
matlist store10


log close

