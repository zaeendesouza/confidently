# confidently

This is a wrapper function for the **fantastic** package `**coefplot()**`, which can be viewed [here](http://repec.sowi.unibe.ch/stata/coefplot/getting-started.html). This wrapper uses three variables, at most: 

1. `variable`: the variable you'd like to plot
2. `over()`: Compulsory grouping variable
3. `by()`: optional second group variable

The wrapper will then estimate the mean(s) of [`variable`], condtional on [`by()`] and/or [`over()`]. It then produces a `coefplot()` type plot with labels and titles all automatically added. Confidence intervals are estimated using "vanilla" standard errors---weights and alternative variance estimation is not allowed, at present.  
