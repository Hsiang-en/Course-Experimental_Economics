clear all

import excel "/Users/shawn/Documents/實驗專題/selection.xlsx"

save "/Users/shawn/Documents/實驗專題/selection.dta", replace


ren A id
gen sooner_week = real(B)
gen later_week = real(C)
gen switch_point = real(D)
gen group = real(E)
gen female = real(F)
gen Econ_major = real(G)
drop if id == "id"

gen gap = later_week - sooner_week
gen delayed = 0
replace delayed = 1 if sooner_week > 1
gen treatment = 0
replace treatment = 1 if group > 1

save "/Users/shawn/Documents/實驗專題/selection.dta", replace


reg switch_point treatment, cluster(id)
outreg2 using "/Users/shawn/Documents/實驗專題/reg,excel" ,replace ctitle(switch_point)
reg switch_point treatment gap delayed, cluster(id)
outreg2 using "/Users/shawn/Documents/實驗專題/reg,excel" ,append ctitle(switch_point)
reg switch_point treatment gap delayed female Econ_major, cluster(id)
outreg2 using "/Users/shawn/Documents/實驗專題/reg,excel" ,append ctitle(switch_point)

foreach i of varlist id{
  bysort id:gen idx = _n
} 

gen TRIAL_INDEX = idx


bysort id: egen total_switch_point = sum(switch_point)
gen average_switch_point = total_switch_point/8

save "/Users/shawn/Documents/實驗專題/selection2.dta", replace

drop if idx<8

gen control = 0
replace control = 1 if treatment == 0
ranksum average_switch_point, by(control) porder

save "/Users/shawn/Documents/實驗專題/selection3.dta", replace

import excel "/Users/shawn/Documents/實驗專題/eyetrack.xlsx", firstrow clear

tostring J, gen (id)

**replace IA_DWELL_TIME_ = IA_DWELL_TIME_*100 
**replace IA_FIXATION_ = IA_FIXATION_*100 

merge m:1 id TRIAL_INDEX using "/Users/shawn/Documents/實驗專題/selection2.dta"


replace IA_DWELL_TIME = 0 if IA_DWELL_TIME == .
replace IA_DWELL_TIME_ = 0 if IA_DWELL_TIME_ == .
replace IA_FIXATION_COUNT = 0 if IA_FIXATION_COUNT == .
replace IA_FIXATION_ = 0 if IA_FIXATION_ == .
replace IA_AREA = 0 if IA_AREA == .


*foreach x in id{ 
*	bysort id TRIAL_INDEX: egen sum_IA_DWELL_TIME = sum(IA_DWELL_TIME) 
*	bysort id TRIAL_INDEX: egen sum_IA_DWELL_TIME_ = sum(IA_DWELL_TIME_) 
*	bysort id TRIAL_INDEX: egen sum_IA_FIXATION_COUNT = sum(IA_FIXATION_COUNT) 
*	bysort id TRIAL_INDEX: egen sum_IA_FIXATION_ = sum(IA_FIXATION_) 
*}


sort J TRIAL_INDEX IA_ID
drop if IA_ID == 2
drop if id == "94"


/*pdslasso average_switch_point treatment (IA_AREA IA_DWELL_TIME IA_DWELL_TIME_ IA_FIXATION_COUNT IA_FIXATION_) , cluster(id)*/
reg average_switch_point treatment IA_AREA IA_DWELL_TIME IA_DWELL_TIME_ IA_FIXATION_COUNT IA_FIXATION_ , cluster(id)

reg average_switch_point IA_DWELL_TIME IA_DWELL_TIME_ IA_FIXATION_COUNT IA_FIXATION_ IA_AREA , cluster(id)


reg average_switch_point sum_IA_DWELL_TIME , cluster(id)
outreg2 using test, replace
reg average_switch_point sum_IA_DWELL_TIME_ , cluster(id)
outreg2 using test, append
reg average_switch_point sum_IA_FIXATION_COUNT , cluster(id)
outreg2 using test, append
reg average_switch_point sum_IA_FIXATION_ , cluster(id)
outreg2 using test, append



bysort id : egen sum_IA_DWELL_TIME = sum(IA_DWELL_TIME) 
bysort id : egen sum_IA_DWELL_TIME_ = sum(IA_DWELL_TIME_) 
bysort id : egen sum_IA_FIXATION_COUNT = sum(IA_FIXATION_COUNT) 
bysort id : egen sum_IA_FIXATION_ = sum(IA_FIXATION_) 



sum sum_IA_DWELL_TIME if sum_IA_DWELL_TIME > 0
sum sum_IA_DWELL_TIME_ if sum_IA_DWELL_TIME_ > 0
sum sum_IA_FIXATION_COUNT if sum_IA_FIXATION_COUNT > 0
sum sum_IA_FIXATION_ if sum_IA_FIXATION_ > 0



