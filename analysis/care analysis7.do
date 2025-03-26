/**************************************************************************************
*
*	PROGRAM TO ANALYSE FORWARD PROJECTIONS FOR SOCIAL CARE PROVISION
*
*	Last version:  Justin van de Ven, 11 Mar 2025
*	First version: Justin van de Ven, 11 Mar 2025
*
*************************************************************************************/

global moddir = "C:\Justin\dev\WELLCARE\output\\$run_name\csv"
global outdir = "C:\Justin\dev\WELLCARE\analysis\data"
cd "$outdir"
log using "${run_name}_provision", replace


/**************************************************************************************
*	start
*************************************************************************************/
use "$outdir\\${run_name}_temp1", clear

// block 1 statistics
matrix store1 = J(2070-2018,4,.)
forvalues yy = 2019/2070 {
	qui {
		local jj = 1
		count if (time==`yy' & prvCare & dag<45)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & prvCare & dag>44 & dag<65)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & prvCare & dag>64 & dag<80)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & prvCare & dag>79)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
	}
}
matlist store1

// block 2 statistics
gen prvCareU5 = (carehoursprovidedweekly<5)
gen prvCare5to9 = (carehoursprovidedweekly>4.95 & carehoursprovidedweekly<10)
gen prvCare10to19 = (carehoursprovidedweekly>9.95 & carehoursprovidedweekly<20)
gen prvCare20to29 = (carehoursprovidedweekly>19.95 & carehoursprovidedweekly<30)
gen prvCare30p = (carehoursprovidedweekly>29.95)
matrix store2 = J(2070-2018,6,.)
forvalues yy = 2019/2070 {
	qui {
		count if (time==`yy' & dag<45 & prvCare & prvCareU5)
		mat store2[`yy'-2018,1] = r(N)
		count if (time==`yy' & dag<45 & prvCare & prvCare5to9)
		mat store2[`yy'-2018,2] = r(N)
		count if (time==`yy' & dag<45 & prvCare & prvCare10to19)
		mat store2[`yy'-2018,3] = r(N)
		count if (time==`yy' & dag<45 & prvCare & prvCare20to29)
		mat store2[`yy'-2018,4] = r(N)
		count if (time==`yy' & dag<45 & prvCare & prvCare30p)
		mat store2[`yy'-2018,5] = r(N)
		sum carehoursprovidedweekly if (time==`yy' & dag<45 & prvCare), mean
		mat store2[`yy'-2018,6] = r(mean)
	}
}
matlist store2

// block 3 statistics
matrix store3 = J(2070-2018,6,.)
forvalues yy = 2019/2070 {
	qui {
		count if (time==`yy' & dag<65 & dag>44.5 & prvCare & prvCareU5)
		mat store3[`yy'-2018,1] = r(N)
		count if (time==`yy' & dag<65 & dag>44.5 & prvCare & prvCare5to9)
		mat store3[`yy'-2018,2] = r(N)
		count if (time==`yy' & dag<65 & dag>44.5 & prvCare & prvCare10to19)
		mat store3[`yy'-2018,3] = r(N)
		count if (time==`yy' & dag<65 & dag>44.5 & prvCare & prvCare20to29)
		mat store3[`yy'-2018,4] = r(N)
		count if (time==`yy' & dag<65 & dag>44.5 & prvCare & prvCare30p)
		mat store3[`yy'-2018,5] = r(N)
		sum carehoursprovidedweekly if (time==`yy' & dag<65 & dag>44.5& prvCare), mean
		mat store3[`yy'-2018,6] = r(mean)
	}
}
matlist store3

// block 4 statistics
matrix store4 = J(2070-2018,6,.)
forvalues yy = 2019/2070 {
	qui {
		count if (time==`yy' & dag<80 & dag>64.5 & prvCare & prvCareU5)
		mat store4[`yy'-2018,1] = r(N)
		count if (time==`yy' & dag<80 & dag>64.5 & prvCare & prvCare5to9)
		mat store4[`yy'-2018,2] = r(N)
		count if (time==`yy' & dag<80 & dag>64.5 & prvCare & prvCare10to19)
		mat store4[`yy'-2018,3] = r(N)
		count if (time==`yy' & dag<80 & dag>64.5 & prvCare & prvCare20to29)
		mat store4[`yy'-2018,4] = r(N)
		count if (time==`yy' & dag<80 & dag>64.5 & prvCare & prvCare30p)
		mat store4[`yy'-2018,5] = r(N)
		sum carehoursprovidedweekly if (time==`yy' & dag<80 & dag>64.5 & prvCare), mean
		mat store4[`yy'-2018,6] = r(mean)
	}
}
matlist store4

// block 5 statistics
matrix store5 = J(2070-2018,6,.)
forvalues yy = 2019/2070 {
	qui {
		count if (time==`yy' & dag>79.5 & prvCare & prvCareU5)
		mat store5[`yy'-2018,1] = r(N)
		count if (time==`yy' & dag>79.5 & prvCare & prvCare5to9)
		mat store5[`yy'-2018,2] = r(N)
		count if (time==`yy' & dag>79.5 & prvCare & prvCare10to19)
		mat store5[`yy'-2018,3] = r(N)
		count if (time==`yy' & dag>79.5 & prvCare & prvCare20to29)
		mat store5[`yy'-2018,4] = r(N)
		count if (time==`yy' & dag>79.5 & prvCare & prvCare30p)
		mat store5[`yy'-2018,5] = r(N)
		sum carehoursprovidedweekly if (time==`yy' & dag>79.5 & prvCare), mean
		mat store5[`yy'-2018,6] = r(mean)
	}
}
matlist store5

// block 6 statistics
gen crBen = carersupportpermonth * (carersupportpermonth>0) * 1.2663	// from 2015 prices (consistent with model assumptions)
bys time idbenefitunit: egen nocr = sum(prvCare)
replace crBen = crBen / nocr if (nocr>1)
gen recCrBen = (crBen>0.01)*prvCare
matrix store6 = J(2070-2018,4,.)
forvalues yy = 2019/2070 {
	qui {
		count if (time==`yy' & dag<45 & recCrBen)
		mat store6[`yy'-2018,1] = r(N)
		count if (time==`yy' & dag>44 & dag<65 & recCrBen)
		mat store6[`yy'-2018,2] = r(N)
		count if (time==`yy' & dag>64 & dag<80 & recCrBen)
		mat store6[`yy'-2018,3] = r(N)
		count if (time==`yy' & dag>79 & recCrBen)
		mat store6[`yy'-2018,4] = r(N)
	}
}
matlist store6

// block 7 statistics
matrix store7 = J(2070-2018,4,.)
forvalues yy = 2019/2070 {
	qui {
		sum crBen if (time==`yy' & dag<45 & recCrBen)
		mat store7[`yy'-2018,1] = r(mean)
		sum crBen if (time==`yy' & dag>44 & dag<65 & recCrBen)
		mat store7[`yy'-2018,2] = r(mean)
		sum crBen if (time==`yy' & dag>64 & dag<80 & recCrBen)
		mat store7[`yy'-2018,3] = r(mean)
		sum crBen if (time==`yy' & dag>79 & recCrBen)
		mat store7[`yy'-2018,4] = r(mean)
	}
}
matlist store7

// block 8 statistics
gsort time idbenefitunit
gen flagBU = 0
replace flagBU = 1 if (idbenefitunit != idbenefitunit[_n-1])
gen prvCareU45 = (dag<45) * prvCare
gen prvCare45to64 = (dag<65) * (dag>44) * prvCare
gen prvCare65to79 = (dag<80) * (dag>64) * prvCare
gen prvCare80p = (dag>79) * prvCare
bys time idbenefitunit: egen buprvCareAll = max(prvCare)
bys time idbenefitunit: egen buprvCareU45 = max(prvCareU45)
bys time idbenefitunit: egen buprvCare45to64 = max(prvCare45to64)
bys time idbenefitunit: egen buprvCare65to79 = max(prvCare65to79)
bys time idbenefitunit: egen buprvCare80p = max(prvCare80p)

bys time idbenefitunit: egen buprvCareU5 = max(prvCareU5)
bys time idbenefitunit: egen buprvCare5to9 = max(prvCare5to9)
bys time idbenefitunit: egen buprvCare10to19 = max(prvCare10to19)
bys time idbenefitunit: egen buprvCare20to29 = max(prvCare20to29)
bys time idbenefitunit: egen buprvCare30p = max(prvCare30p)

matrix store8 = J(2070-2018,11,.)
forvalues yy = 2019/2070 {
	qui {
		preserve
		keep if (time==`yy')
		
		//noisily display "analysis for year " + `yy'
		sum equivaliseddisposableincomeyearl if (time==`yy' & flagBU), detail
		local povLine = 0.6 * r(p50)
		gen poor = (equivaliseddisposableincomeyearl < `povLine')
		sum poor, mean
		mat store8[`yy'-2018,1] = r(mean)
		sum poor if (buprvCareAll), mean
		mat store8[`yy'-2018,2] = r(mean)
		sum poor if (buprvCareU45), mean
		mat store8[`yy'-2018,3] = r(mean)
		sum poor if (buprvCare45to64), mean
		mat store8[`yy'-2018,4] = r(mean)
		sum poor if (buprvCare65to79), mean
		mat store8[`yy'-2018,5] = r(mean)
		sum poor if (buprvCare80p), mean
		mat store8[`yy'-2018,6] = r(mean)

		sum poor if (buprvCareU5), mean
		mat store8[`yy'-2018,7] = r(mean)
		sum poor if (buprvCare5to9), mean
		mat store8[`yy'-2018,8] = r(mean)
		sum poor if (buprvCare10to19), mean
		mat store8[`yy'-2018,9] = r(mean)
		sum poor if (buprvCare20to29), mean
		mat store8[`yy'-2018,10] = r(mean)
		sum poor if (buprvCare30p), mean
		mat store8[`yy'-2018,11] = r(mean)
		
		restore
	}
}
matlist store8

// block 9 statistics
matrix store9 = J(2070-2018,10,.)
forvalues yy = 2019/2070 {
	qui {
		preserve
		keep if (time==`yy')
		
		//noisily display "analysis for year " + `yy'
		sum equivaliseddisposableincomeyearl if (time==`yy' & flagBU), detail
		local povLine = 0.6 * r(p50)
		gen poor = (equivaliseddisposableincomeyearl < `povLine')
		gen povGap = `povLine' - equivaliseddisposableincomeyearl
		replace povGap = 0 if (povGap<0)

		sum poor, mean
		mat store9[`yy'-2018,1] = r(mean)
		sum poor if (buprvCareAll & recCrBen), mean
		mat store9[`yy'-2018,2] = r(mean)
		sum poor if (buprvCareU45 & recCrBen), mean
		mat store9[`yy'-2018,3] = r(mean)
		sum poor if (buprvCare45to64 & recCrBen), mean
		mat store9[`yy'-2018,4] = r(mean)
		sum poor if (buprvCare65to79 & recCrBen), mean
		mat store9[`yy'-2018,5] = r(mean)
		
		sum povGap if (poor), mean
		mat store9[`yy'-2018,6] = r(mean)
		sum povGap if (poor & buprvCareU45)
		mat store9[`yy'-2018,7] = r(mean)
		sum povGap if (poor & buprvCareU45 & recCrBen)
		mat store9[`yy'-2018,8] = r(mean)
		sum povGap if (poor & buprvCare45to64)
		mat store9[`yy'-2018,9] = r(mean)
		sum povGap if (poor & buprvCare45to64 & recCrBen)
		mat store9[`yy'-2018,10] = r(mean)
		
		restore
	}
}
matlist store9

// block 10 statistics
gsort time idbenefitunit
bys time idbenefitunit: egen buHoursWorkedWeekly = sum(hoursworkedweekly)
gen dy = disposableincomemonthly * 1.2663	// from 2015 prices (consistent with model assumptions)
matrix store10 = J(2070-2018,4,.)
forvalues yy = 2019/2070 {
	qui {
		preserve
		keep if (time==`yy')
		
		local ii = 1
		sum buHoursWorkedWeekly if (time==`yy' & buprvCareU45 & flagBU), mean
		mat store10[`yy'-2018,`ii'] = r(mean)
		local ii = `ii' + 1
		sum buHoursWorkedWeekly if (time==`yy' & buprvCare45to64 & flagBU), mean
		mat store10[`yy'-2018,`ii'] = r(mean)
		local ii = `ii' + 1
		sum dy if (time==`yy' & buprvCareU45 & flagBU), mean
		mat store10[`yy'-2018,`ii'] = r(mean)
		local ii = `ii' + 1
		sum dy if (time==`yy' & buprvCare45to64 & flagBU), mean
		mat store10[`yy'-2018,`ii'] = r(mean)
		local ii = `ii' + 1
		
		restore
	}
}
matlist store10


log close
