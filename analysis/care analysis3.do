/**************************************************************************************
*
*	PROGRAM TO ANALYSE LIFETIME PROFILES FOR CHILDCARE
*
*	Last version:  Justin van de Ven, 23 Jan 2025
*	First version: Justin van de Ven, 23 Jan 2025
*
**************************************************************************************/

clear all
global costsdir =     "C:\justin\dev\SimPaths\output\sc analysis4\csv"
global zerocostsdir = "C:\justin\dev\SimPaths\output\sc analysis2\csv"
global naivedir =     "C:\justin\dev\SimPaths\output\sc analysis4b\csv"
global outdir =       "C:\justin\dev\SimPaths\analysis\data"
cd "$outdir"


/**************************************************************************************
*	start
**************************************************************************************/

/**************************************************************************************
*	load data
**************************************************************************************/

//////// COSTS ////////////////////////
import delimited using "$costsdir/BenefitUnit.csv", clear
rename *, l
rename id_benefitunit idbenefitunit
gsort idbenefitunit time
save "$outdir/costs0cc", replace
import delimited using "$costsdir/Person.csv", clear
rename *, l
rename id_person idperson
rename socialcareprovision socialcareprovision_p
gsort idbenefitunit time idperson
merge m:1 idbenefitunit time using costs0cc
drop _merge
gsort time idbenefitunit idperson
gen refbenefitunit = 0
replace refbenefitunit = 1 if (idbenefitunit != idbenefitunit[_n-1])

gen child = (dag<18)
gen adult = 1 - child
bys time idbenefitunit: egen nk = sum(child) 
bys time idbenefitunit: egen na = sum(adult) 
gen partnered = adult * (na-1)

foreach vv of varlist carehoursfrompartnerweekly carehoursfromdaughterweekly carehoursfromsonweekly carehoursfromotherweekly carehoursfromparentweekly carehoursfromformalweekly {
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

gen needCare = (needsocialcare=="True")
gen informalCareHours = carehoursfrompartnerweekly + carehoursfromdaughterweekly + carehoursfromsonweekly + carehoursfromotherweekly + carehoursfromparentweekly
gen totalCareHours = informalCareHours + carehoursfromformalweekly
gen recCare = (totalCareHours>0.01)

save "$outdir/costs1cc", replace


//////// ZERO COSTS ////////////////////////
// import delimited using "$zerocostsdir/BenefitUnit.csv", clear
// rename *, l
// rename id_benefitunit idbenefitunit
// gsort idbenefitunit time
// save "$outdir/zero0", replace
// import delimited using "$zerocostsdir/Person.csv", clear
// rename *, l
// rename id_person idperson
// rename socialcareprovision socialcareprovision_p
// gsort idbenefitunit time idperson
// merge m:1 idbenefitunit time using zero0
// drop _merge
// gsort time idbenefitunit idperson
// gen refbenefitunit = 0
// replace refbenefitunit = 1 if (idbenefitunit != idbenefitunit[_n-1])
//
// gen child = (dag<18)
// gen adult = 1 - child
// bys time idbenefitunit: egen nk = sum(child) 
// bys time idbenefitunit: egen na = sum(adult) 
// gen partnered = adult * (na-1)
//
// foreach vv of varlist carehoursfrompartnerweekly carehoursfromdaughterweekly carehoursfromsonweekly carehoursfromotherweekly carehoursfromparentweekly carehoursfromformalweekly {
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
// gen needCare = (needsocialcare=="True")
// gen informalCareHours = carehoursfrompartnerweekly + carehoursfromdaughterweekly + carehoursfromsonweekly + carehoursfromotherweekly + carehoursfromparentweekly
// gen totalCareHours = informalCareHours + carehoursfromformalweekly
// gen recCare = (totalCareHours>0.01)
//
// save "$outdir/zero1", replace


//////// NAIVE ////////////////////////
import delimited using "$naivedir/BenefitUnit.csv", clear
rename *, l
rename id_benefitunit idbenefitunit
gsort idbenefitunit time
save "$outdir/naive0cc", replace
import delimited using "$naivedir/Person.csv", clear
rename *, l
rename id_person idperson
rename socialcareprovision socialcareprovision_p
gsort idbenefitunit time idperson
merge m:1 idbenefitunit time using naive0cc
drop _merge
gsort time idbenefitunit idperson
gen refbenefitunit = 0
replace refbenefitunit = 1 if (idbenefitunit != idbenefitunit[_n-1])

gen child = (dag<18)
gen adult = 1 - child
bys time idbenefitunit: egen nk = sum(child) 
bys time idbenefitunit: egen na = sum(adult) 
gen partnered = adult * (na-1)

foreach vv of varlist carehoursfrompartnerweekly carehoursfromdaughterweekly carehoursfromsonweekly carehoursfromotherweekly carehoursfromparentweekly carehoursfromformalweekly {
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

gen needCare = (needsocialcare=="True")
gen informalCareHours = carehoursfrompartnerweekly + carehoursfromdaughterweekly + carehoursfromsonweekly + carehoursfromotherweekly + carehoursfromparentweekly
gen totalCareHours = informalCareHours + carehoursfromformalweekly
gen recCare = (totalCareHours>0.01)

save "$outdir/naive1cc", replace


/**************************************************************************************
*	sample selection
**************************************************************************************/
forvalues kk = 1/3 {
	
	qui {
		
		if (`kk'==1) {
			use "$outdir/zero1", clear
		}
		if (`kk'==2) {
			use "$outdir/naive1cc", clear
		}
		if (`kk'==3) {
			use "$outdir/costs1cc", clear
		}

		// select by birth year, gender, and adulthood
		gen byear = time - dag
		gen chk1 = (byear>2000 & byear<2011 & dag>17 & dgn=="Female")

		// select women giving birth to first child at age 29
		gsort idperson time
		gen tmp1 = ((dag==29) & (nk==1) & (nk[_n-1]==0) & (idperson==idperson[_n-1]) & chk1==1)
		by idperson: egen tmp2 = max(tmp1)
		replace chk1 = 0 if (tmp2==0)
		drop tmp1 tmp2
		
		// select women who were never disabled
		gen tmp1 = (dlltsd=="True")
		by idperson: egen tmp2 = max(tmp1)
		replace chk1 = 0 if (tmp2==1)
		drop tmp1 tmp2

		// identify benefit units of selected population
		gsort idbenefitunit time
		bys idbenefitunit time: egen tmp1 = max(chk1)
		
		// limit sample
		keep if (tmp1==1 & dag>17)
		keep idperson idbenefitunit time chk1

		// identify spouse ids for selected sample
		gsort idbenefitunit time idperson
		gen nn = 1
		replace nn = nn[_n-1]+1 if (idbenefitunit==idbenefitunit[_n-1] & time==time[_n-1])
		keep idperson idbenefitunit time nn chk1
		save "$outdir/temp1", replace
		forvalues jj = 1/2 {
			
			use "$outdir/temp1", clear
			keep if (nn==`jj')
			save "$outdir/temp2", replace
			use "$outdir/temp1", clear
			drop if (nn==`jj')
			keep idperson idbenefitunit time
			rename idperson idspouse
			merge 1:1 idbenefitunit time using temp2
			keep idperson time idspouse idbenefitunit chk1
			order idperson time idspouse idbenefitunit chk1
			if (`jj'==1) {
				save "$outdir/temp3", replace
			}
			else {
				append using "$outdir/temp3"
			}
		}
		recode chk1 (.=-9)
		keep if (chk1==1)
		gsort idperson time
		recode idspouse (.=-9)
		keep idperson time idspouse
		gsort idperson time

		if (`kk'==1) {
			save "$outdir/zero2cc", replace
		}
		if (`kk'==2) {
			save "$outdir/naive2cc", replace
		}
		if (`kk'==3) {
			save "$outdir/costs2cc", replace
		}
	}
}

use "$outdir/zero2cc", clear
save "$outdir/temp1", replace

use "$outdir/naive2cc", clear
merge 1:1 idperson time idspouse using temp1
keep if (_merge==3)
keep idperson time idspouse
save "$outdir/temp2", replace

use "$outdir/costs2cc", clear
merge 1:1 idperson time idspouse using temp2
keep if (_merge==3)
keep idperson time idspouse

// keep only observations with full histories
gen chk = 0
replace chk = 1 if ((idperson==idperson[_n-1]) & ((time!=(time[_n-1]+1)) | (chk[_n-1])))
drop if (chk)

// save sample
keep idperson time
save "$outdir/selectedcc", replace


/**************************************************************************************
*	age profile analysis
**************************************************************************************/
// block a
matrix store1 = J(60-17,9,.)
forvalues kk = 1/3 {
	
	qui {
		
		if (`kk'==1) {
			use "$outdir/zero1", clear
		}
		if (`kk'==2) {
			use "$outdir/naive1cc", clear
		}
		if (`kk'==3) {
			use "$outdir/costs1cc", clear
		}

		// limit to selected sample
		gsort idperson time
		merge 1:1 idperson time using "$outdir/selectedcc"
		keep if (_merge==3)
		drop _merge
		
		gen byear = time - dag
		gen dbld = (dlltsd=="True")
		gen carer = (socialcareprovision_p!="None")
		gen worker = (les_c4=="EmployedOrSelfEmployed")
		gen dispinc = disposableincomemonthly * 12
		recode careformalexpenditureweekly (-9=0)
		gen careexpend = (careformalexpenditureweekly + childcarecostperweek) * 365.25/7

		//gen target = 1
		// target people observed to age 71
		gen chk = (dag==60)
		by idperson: egen target = max(chk)
		forvalues aa = 18/60 {
			
			local jj = 1
			sum dbld if (dag==`aa' & target), mean
			mat store1[`aa'-17,`jj'] = r(mean)
			local jj = `jj' + 1

			sum needCare if (dag==`aa' & target), mean
			mat store1[`aa'-17,`jj'] = r(mean)
			local jj = `jj' + 1

			sum carer if (dag==`aa' & target), mean
			mat store1[`aa'-17,`jj'] = r(mean)
			local jj = `jj' + 1

			sum worker if (dag==`aa' & target), mean
			mat store1[`aa'-17,`jj'] = r(mean)
			local jj = `jj' + 1

			sum hoursworkedweekly if (dag==`aa' & target), mean
			mat store1[`aa'-17,`jj'] = r(mean)
			local jj = `jj' + 1

			sum dispinc if (dag==`aa' & target), mean
			mat store1[`aa'-17,`jj'] = r(mean) * 1.305  // from 2015 to 2024 prices (ONS CPI Annual Average (All Items, D7BT))
			local jj = `jj' + 1

			sum discretionaryconsumptionperyear if (dag==`aa' & target), mean
			mat store1[`aa'-17,`jj'] = r(mean) * 1.305  // from 2015 to 2024 prices
			local jj = `jj' + 1

			sum careexpend if (dag==`aa' & target), mean
			mat store1[`aa'-17,`jj'] = r(mean) * 1.305  // from 2015 to 2024 prices
			local jj = `jj' + 1

			sum liquidwealth if (dag==`aa' & target), mean
			mat store1[`aa'-17,`jj'] = r(mean) * 1.305  // from 2015 to 2024 prices
			local jj = `jj' + 1
		}
	}
	matlist store1
}
