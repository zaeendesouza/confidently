/*
Title:  long program to do a simple task
Author: Zaeen de Souza
Date:   30-05-2023
*/


clear all
set scheme white_tableau
sysuse auto


/// adding labels since program doesnt work without these and data should always have labels anyway
label define quality 1 "Poor"    /// 
                     2 "Fair"    /// 
					 3 "Average" /// 
					 4 "Good"    /// 
					 5 "Excellent"
lab val rep78 quality


*********************************************************************************
*                               program                                         *
*********************************************************************************

capture program drop confidently
program confidently

syntax varlist [if]            /// 
               [in],           /// 
               over(varname)   /// 
	       [by(varname)]   ///
               [name(string)]  ///
               [graphopts(string asis)] ///
	       [scale]

		
	
	
/// temp files
qui tempfile main stats 
qui save     `main'

/// sample indicator for maping the [IF] condition
marksample touse

/// keep if X == x
qui keep if `touse' == 1



/// this requires coefplot to work!
cap which coefplot
if _rc == 111{
			
	display as err "Sorry but this wrapper function requires the package coefplot!"
	display as err "You need to run:" 
	display as err "ssc install coefplot, replace"
	exit 198

}

********************************************************************************
* IF by has not been specified
********************************************************************************

if "`by'" =="" {
 
preserve


qui statsby,  /// 
by(`over')    /// 
clear:        /// 
ci            /// 
means         /// 
`varlist'

qui{
egen label = concat(`over'), decode p(" x ")
/// calculates the correct group-wise DoF --- note: DoF = N-1 foreach group mean
replace N  = N-1
/// making a matrix of summary stats
mkmat mean /// 
      se   /// 
	  lb   /// 
	  ub   /// 
	  N,   /// 
	  matrix(R)
mat  R = R' 
}

* labels
qui{
levelsof `over', local(levels)
local lbls
foreach   z of local levels {
    local lbl : label (`over') `z'
    local lbls      `" `lbls' "`lbl'" "'
}
local  lbls         `" `lbls' "'
matrix colnames R = `lbls'
restore
}

//// syntax to make a plot using coefplot() via a matrix
global call "(matrix(R), se(2) df(R[5,.]))"
	

qui sum 	`varlist'
qui local 	 var_mean: display %4.2f `r(mean)'


/*
making the plot using the all globals and our matrices
*/

if	 "`scale'" == "" {
	
 coefplot $call,                                      ///
 xline(`var_mean',                                    /// 
 lcolor(red))                                         ///
 ciopts(recast(rcap))                                 ///
 title("`: var la `varlist''",  size(medium))        ///
 subtitle("(Mean = `var_mean')", size(small))        /// 
 ytitle("`: var la `over' '")                         ///
 xtitle("`: var la `varlist''")                       ///
 mlabel                                               /// 
 format(%9.2f)                                        /// 
 mlabposition(12)                                     ///
 legend(subtitle("`: var la `over' '",                /// 
 size(small)))                                        /// 
 legend(position(6)                                   /// 
 size(small)                                          ///
 rows(1))                                             /// 
 levels(95)                                           ///
 xlab(#5)                                       ///
 legend(off)                                          ///
 plotregion(margin(large))                            /// 
 `graphopts'                                          ///
 name(`name', replace)
	}
	
	else{
		 coefplot $call,                                      ///
 xline(`var_mean',                                    /// 
 lcolor(red))                                         ///
 ciopts(recast(rcap))                                 ///
 title("`: var la `varlist''",  size(medium))        ///
 subtitle("(Mean = `var_mean')", size(small))        /// 
 ytitle("`: var la `over' '")                         ///
 xtitle("`: var la `varlist''")                       ///
 mlabel                                               /// 
 format(%9.2f)                                        /// 
 mlabposition(12)                                     ///
 legend(subtitle("`: var la `over' '",                /// 
 size(small)))                                        /// 
 legend(position(6)                                   /// 
 size(small)                                          ///
 rows(1))                                             /// 
 levels(95)                                           ///
 xlab(0(20)100)                                       ///
 legend(off)                                          ///
 plotregion(margin(large))                            /// 
 `graphopts'                                          ///
 name(`name', replace)
	}
}

********************************************************************************
* IF by() & SCALE has been specified
********************************************************************************
else{
qui levelsof `by', local(plot_levels)
foreach p of local plot_levels {  
preserve

qui keep if `by' == `p'

qui statsby, /// 
by(`over')   /// 
clear:       /// 
ci           /// 
means        /// 
`varlist'

qui{
egen label = concat(`over'), decode p(" x ")
replace N = N-1
mkmat mean /// 
	  se   /// 
	  lb   /// 
	  ub   /// 
	  N,   /// 
	  matrix(R_`p')
mat R_`p' = R_`p'' 
}

qui{
levelsof `over', local(levels)
local lbls_`p'
foreach   z of local levels {
	local lbl_`p' : label (`over') `z'
    local lbls_`p' `" `lbls_`p'' "`lbl_`p''" "'
}
local lbls `" `lbls_`p'' "'
matrix colnames R_`p' = `lbls_`p''
restore
	}
}

qui { 
levelsof `by', local(levels)
global call
qui local labl : value label `by'
qui foreach l of local levels {
		         local `by'`l' : label `labl' `l'	
		
* creating an empty variable that is labelled with the command we need - we then extract the command from the label
		gen cat_`l'   = ""	
		lab var cat_`l'     "(matrix(R_`l'), se(2) df(R_`l'[5,.]) label(``by'`l''))"
			foreach v of varlist cat_* {
						global call "$call `: var la `v''"		
						drop cat_*
		}	
	}	
}	


qui sum 	`varlist'
qui local 	 var_mean: display %4.2f `r(mean)'
	
	
/*
making the plot using the all globals and our new matrices
*/

if	 "`scale'" == "" {

 coefplot $call,                                      ///
 xline(`var_mean',                                    /// 
 lcolor(red))                                         ///
 ciopts(recast(rcap))                                 ///
 title("`: var la `varlist''",  size(medium))         ///
 subtitle("(Mean = `var_mean')", size(small))         /// 
 ytitle("`: var la `by' '")                           ///
 xtitle("`: var la `varlist''")                       ///
 mlabel                                               /// 
 format(%9.2f)                                        /// 
 mlabposition(12)                                     ///
 legend(subtitle("`: var la `over' '",                /// 
 size(small)))                                        /// 
 legend(position(6)                                   /// 
 size(small)                                          ///
 rows(1))                                             /// 
 levels(95)                                           ///
 xlab(#5)                                             ///
 legend(on)                                           ///
 plotregion(margin(large))                            ///
`graphopts'                                           ///
 name(`name', replace)
 }
else{
	 coefplot $call,                                      ///
 xline(`var_mean',                                    /// 
 lcolor(red))                                         ///
 ciopts(recast(rcap))                                 ///
 title("`: var la `varlist''",  size(medium))         ///
 subtitle("(Mean = `var_mean')", size(small))         /// 
 ytitle("`: var la `by' '")                           ///
 xtitle("`: var la `varlist''")                       ///
 mlabel                                               /// 
 format(%9.2f)                                        /// 
 mlabposition(12)                                     ///
 legend(subtitle("`: var la `over' '",                /// 
 size(small)))                                        /// 
 legend(position(6)                                   /// 
 size(small)                                          ///
 rows(1))                                             /// 
 levels(95)                                           ///
 xlab(0(20)100)                                             ///
 legend(on)                                           ///
 plotregion(margin(large))                            ///
`graphopts'                                           ///
 name(`name', replace)
	}
}
qui use `main', clear
macro drop call
end	


* run the command and see
confidently price, over(rep78) name("my_graph1") scale
confidently price, over(rep78) by(foreign) name("my_graph2") scale

