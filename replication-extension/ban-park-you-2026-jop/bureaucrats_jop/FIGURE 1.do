*-------------------------------------------------------------------------------
* REPLICATION FILES FOR "Bureaucrats in Congress: The politics of Interbranch 
* Information Sharing" by Pamela Ban, Ju Yeon Park, and Hye Young You
*-------------------------------------------------------------------------------

********************************************************************************
* FIGURE 1: LEGISLATIVE AND OVERSIGHT HEARING WITH BUREAUCRATIC WITNESSES, 1977-2014
********************************************************************************
clear
use bureaucrat_pol.dta
replace polappt = dod_pol if acr =="DOD"
grstyle init
bys hearingid: egen numpol = sum(polappt)
gen polappear = .
replace polappear = 0 if numpol ==0 
replace polappear =1 if numpol > 0	 
bys hearingid: egen polappear2 = max(polappear)  
bys hearingid: egen numbureau = count(congress)
bys hearingid: egen meanwitness = mean(numwitness_identified)
bys hearingid: egen numbureau_dept = sum(department)
bys hearingid: egen numbureau_ind = sum(independent)
bys hearingid agencycode: gen aa = _n ==1
bys hearingid: egen numagency = sum(aa)
gen polshare = numpol/numbureau 

* number of legislative vs. oversight hearings 
bys agencycode hearingid: gen hh = _n ==1 
bys agencycode: egen totalhearing = sum(hh)
bys agencycode: egen tot_leg = sum(hh) if legislative ==1
sort agencycode tot_leg 
bys agencycode: replace tot_leg = tot_leg[_n-1] if missing(tot_leg) >0 & _n > =1
bys agencycode: egen tot_ovs = sum(hh) if legislative ==0
sort agencycode tot_ovs 
bys agencycode: replace tot_ovs = tot_ovs[_n-1] if missing(tot_ovs) >0 & _n > =1
gen legisratio = tot_leg/totalhearing 
sort legisratio


******************************************
* FIGURE 1-Panel (a): Executive Department
******************************************
gen opm_agencyname2 = opm_agencyname 
bys agencycode: gen dd = _n ==1 

graph hbar tot_leg tot_ovs if dd==1 & agencycode !="" & department ==1, ///
      over(acr, sort(totalhearing) label(labsize(small))) stack graphregion(color(white))  /// 
      legend(cols(1) order (1 "Legislative" 2 "Oversight") size(small) position(1) ring(0)) ///
	  ytitle("Number of Hearings") ysize(6) ///
	  bar(1, fcolor(gs10) lcolor(gs10)) bar(2, fcolor(gs3) lcolor(gs3)) 


************************************
* FIGURE 1-Panel (b): Other Agencies
************************************
tab opm_agencyname if department == 0, sort
gsort -totalhearing

graph hbar tot_leg tot_ovs if dd==1 & agencycode !="" & department ==0 & totalhearing>300, ///
      over(opm_agencyname, sort(totalhearing) label(labsize(small))) stack graphregion(color(white)) /// 
      legend(cols(1) order (1 "Legislative" 2 "Oversight") size(small) position(1) ring(0)) ///
	  ytitle("Number of Hearings") ysize(6) ///
	  bar(1, fcolor(gs10) lcolor(gs10)) bar(2, fcolor(gs3) lcolor(gs3)) 


		