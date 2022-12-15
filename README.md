# confidently

This is a wrapper function for the **fantastic** package **`coefplot()`**, which can be viewed [here](http://repec.sowi.unibe.ch/stata/coefplot/getting-started.html). This wrapper uses three variables, at most: 

1. `variable`: the variable you'd like estimate a mean and confidence interval for.
2. `over()`: Compulsory grouping variable.
3. `by()`: Optional second group variable.

The wrapper will then estimate the mean(s) of [`variable`], condtional on [`by()`] and/or [`over()`]. It then produces a `coefplot()` type plot with labels and titles all automatically added. Confidence intervals are estimated using "vanilla" standard errors---weights and alternative variance estimation is not allowed, at present. 

```
* Note: all variables/values need to be labelled!

clear all
sysuse auto

* adding labels since program doesnt work without these and data should always have labels anyway
label define quality 1 "Poor" 2 "Fair" 3 "Average" 4 "Good" 5 "Excellent"
label values rep78 quality


* running the command with and without by() specified!
confidently price, over(rep78) by(foreign)
confidently price, over(rep78)

```
