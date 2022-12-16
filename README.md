# confidently

This is a wrapper function for the **fantastic** package **`coefplot`**, which can be viewed [here](http://repec.sowi.unibe.ch/stata/coefplot/getting-started.html). This wrapper uses three variables, *at most*: 

1. `variable`: the variable you'd like estimate a mean and confidence interval for.
2. `over()`: Compulsory grouping variable.
3. `by()`: Optional second group variable.

The wrapper will then estimate the mean(s) of [`variable`], condtional on [`by()`] and/or [`over()`]. It then produces a `coefplot()` type plot with labels and titles all automatically added. Confidence intervals are estimated using "vanilla" standard errors; weights and alternative variance estimation is not allowed, at present, but I will add these soon, along with an option for plotting the median/group-specific medians, along with confidence intervals estimated via bootstrap.

```
clear all
sysuse auto

* adding labels since program doesnt work without these and data should always have labels anyway
label def    quality 1 "Poor"     ///
                     2 "Fair"     ///
                     3 "Average"  ///
                     4 "Good"     ///
                     5 "Excellent"
                     
lab val rep78 quality

* run the do file that contains the program
do "confidently_beta.do"

* a nice scheme to use
set scheme white_tableau

* running the command with and without by() specified!
confidently price, over(rep78) by(foreign)
confidently price, over(rep78)

```

This produces the following graph!

![image](https://user-images.githubusercontent.com/35003392/207943717-3ffd8388-5194-425e-b89f-ce51f766028d.png)
