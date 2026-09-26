*-------------------------------------------------------------------------------
* REPLICATION FILES FOR "Bureaucrats in Congress: The politics of Interbranch 
* Information Sharing" by Pamela Ban, Ju Yeon Park, and Hye Young You
*-------------------------------------------------------------------------------

********************************************************************************
* FIGURE 4: Analyitical Information by Agencies
********************************************************************************
clear
use dyad_b.dta
grstyle init 
bys agencycode: egen info = mean(ascore_avg)
bys agencycode: gen tt = _n ==1
bys witness_id: gen bb = _n == 1

*******************************************
* FIGURE 4-Panel (a): Executive Department 
*******************************************
* executive department 
gsort ascore_avg
graph hbox ascore_avg if department ==1, over(acr, sort(1)) ///
      nooutsides graphregion(color(white)) ///
      ytitle("Analytical Score") box(1, col("128 128 128")) ///
	  medtype(marker) medmarker(msymbol(diamond) mcol(black)) note("") ysize(6)

************************************
* FIGURE 4-Panel (b): Other Agencies
************************************  
* include top 15 in terms of hearing 
gen include = 0
replace include = 1 if acr =="FTC"
replace include = 1 if acr =="FCC"
replace include = 1 if acr =="NRC"
replace include = 1 if acr =="SEC"
replace include = 1 if acr =="FED"
replace include = 1 if acr =="GSA"
replace include = 1 if acr =="EPA"
replace include = 1 if acr =="OPM"
replace include = 1 if acr =="USPS"
replace include = 1 if acr =="SSA"
replace include = 1 if acr =="USTR"
replace include = 1 if acr =="NASA"
replace include = 1 if acr =="SBA"
replace include = 1 if acr =="USAID"
replace include = 1 if acr =="NSF"

graph hbox ascore_avg if department ==0 & include ==1, ///
      over(acr, sort(1)) nooutsides graphregion(color(white)) ///
      ytitle("Analytical Score") box(1, col("128 128 128")) ///
	  medtype(marker) medmarker(msymbol(diamond) mcol(black)) note("") ysize(6)

	  