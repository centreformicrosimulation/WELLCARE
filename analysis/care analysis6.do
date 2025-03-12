/**************************************************************************************
*
*	PROGRAM TO ANALYSE FORWARD PROJECTIONS FOR SOCIAL CARE
*
*	Last version:  Justin van de Ven, 11 Mar 2025
*	First version: Justin van de Ven, 11 Mar 2025
*
*************************************************************************************/

clear all
global moddir = "C:\Justin\dev\WELLCARE\output\sc analysis1\csv"
global outdir = "C:\Justin\dev\WELLCARE\analysis\data"
cd "$outdir"


/**************************************************************************************
*	start
*************************************************************************************/

/**************************************************************************************
*	load data
*************************************************************************************/
import delimited using "$moddir/BenefitUnit.csv", clear
rename *, l
rename id_benefitunit idbenefitunit
gsort idbenefitunit time
save "$outdir/sc_analysis1_temp0", replace
import delimited using "$moddir/Person.csv", clear
rename *, l
rename id_person idperson
rename socialcareprovision socialcareprovision_p
gsort idbenefitunit time idperson
merge m:1 idbenefitunit time using sc_analysis1_temp0
gsort time idbenefitunit idperson
gen refbenefitunit = 0
replace refbenefitunit = 1 if (idbenefitunit != idbenefitunit[_n-1])

foreach vv of varlist carehoursfrompartnerweekly carehoursfromdaughterweekly ///
carehoursfromsonweekly carehoursfromotherweekly carehoursfromparentweekly ///
carehoursfromformalweekly socialcaresupportpermonth disabilitysupportpermonth ///
carersupportpermonth {
	destring `vv', replace force
	recode `vv' (missing=0)
}

destring hoursworkedweekly, replace force
recode hoursworkedweekly (missing=0)
gen idNotEmployedAdult = (hoursworkedweekly<0.1 & dag>17)

gen led = (deh_c3=="Low")
gen med = (deh_c3=="Medium")
gen hed = (deh_c3=="High")

gen male = (dgn=="Male")

gen idna = (dag>17)
gen idnk = (dag<18)
bys time idbenefitunit: egen partnered = sum(idna)
replace partnered = partnered - 1
bys time idbenefitunit: egen nk = sum(idnk)

gen needCare = (needsocialcare=="True")
gen informalCareHours = carehoursfrompartnerweekly + carehoursfromdaughterweekly + carehoursfromsonweekly + carehoursfromotherweekly + carehoursfromparentweekly
gen totalCareHours = informalCareHours + carehoursfromformalweekly
gen recCare = (totalCareHours>0.01)

save "$outdir/sc_analysis1_temp1", replace


/*******************************************************************************
*	social care receipt
*******************************************************************************/
use "$outdir/sc_analysis1_temp1", clear

// block 1 statistics
matrix store1 = J(2070-2018,7,.)
forvalues yy = 2019/2070 {
	qui {
		local jj = 1
		count if (time==`yy' & recCare & dag<45)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & recCare & dag>44 & dag<65)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & recCare & dag>64 & dag<80)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & recCare & needCare & dag>64 & dag<80)
		mat store1[`yy'-2018,`jj'] = r(N)
		local jj = `jj' + 1
		count if (time==`yy' & recCare & dag>79)
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
matrix store3 = J(2070-2018,2,.)
forvalues yy = 2019/2070 {
	qui {
		count if (time==`yy' & dag>64 & dag<80 & carehoursfromformalweekly>0.0)
		mat store3[`yy'-2018,1] = r(N)
		count if (time==`yy' & dag>79 & carehoursfromformalweekly>0.0)
		mat store3[`yy'-2018,2] = r(N)
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
matrix store6 = J(2070-2018,4,.)
forvalues yy = 2019/2070 {
	qui {
		sum disabilitysupportpermonth if (time==`yy' & dag<45 & recCare), mean
		mat store6[`yy'-2018,1] = r(mean)
		sum disabilitysupportpermonth if (time==`yy' & dag>44 & dag<65 & recCare), mean
		mat store6[`yy'-2018,2] = r(mean)
		sum socialcaresupportpermonth if (time==`yy' & dag>64 & dag<80 & carehoursfromformalweekly>0), mean
		mat store6[`yy'-2018,3] = r(mean)
		sum socialcaresupportpermonth if (time==`yy' & dag>79 & carehoursfromformalweekly>0), mean
		mat store6[`yy'-2018,4] = r(mean)
	}
}
matlist store6

