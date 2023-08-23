# plot_confidently 

`plot_confidently` allows users to visualize the mean and confidence interval of a specified variable, with options for up to two levels of disaggregation. This command has been jointly developed with [Kabira Namit](https://github.com/kabira-namit-kapoor).

# Syntax
```
plot_confidently varlist [IF] [IN], [over(varname)] [by(varname)] [graphopts()] [scale]]
```

1. `over(varname)`: This specifies the first of up to two grouping variables. varname must be a labelled factor variable.
2. `by(varname)`: This specifies the second grouping variable. varname must be a labelled factor variable.
3. `graphopts(string)`: Allows the user to pass any Stata graph options into the program. For example, a custom title, subtitle and/or note (or make changes to the axis labels, ticks and so on). Must be specified as a string enclosed in quotation marks. See examples below.
4. `scale`: Allows the user to scale the Y-Axis to the percentage scale. Useful for visualizing percentages, proportions and rates.


# Installation
```
ssc install plot_confidently, replace
```
# Examples
```
sysuse auto.dta, clear
label define quality 1 "Poor" 2 "Fair" 3 "Average" 4 "Good" 5 "Excellent"
lab val rep78 quality
gen pct_score = runiform()*100
lab var pct_score "Percentage Score"`
```

## Example 1: Mean + 95% confidence interval of a continuous variable with no group variable.
```
plot_confidently price
```
## Example #2: Mean + 95% confidence interval of a continuous variable with a single group variable.
```
plot_confidently price, over(rep78)
```

## Example #3: Mean + 95% confidence interval of a continuous variable using two grouping variables.
```
plot_confidently price, over(rep78) by(foreign)
```
## Example 4: Mean + 95% confidence interval of a percentage variable while using the "scale" option.
```
plot_confidently pct_score, scale
```        
 ## Example #5: Editing the look of the graph via "graphopts".
```
plot_confidently price, over(rep78) by(foreign) graphopts(msymbol(S) xtitle("My X-Axis"))
```
        
## Example #6: Using an IF/IN condition.
```
plot_confidently price if foreign == 0, over(rep78)
```        
# Acknowledgments

We would like to thank Ben Jann, who developed coefplot, which our command builds on. We are grateful to Prabhmeet Kaur for creating an early iteration of the program, which was the inspiration for plot_confidently. We would also like to thank Professor Iram Siraj and Sakshi Hallan for feedback and support in the development stages of plot_confidently. All errors are our own.

# Authors

Zaeen de Souza, Frontline Impact<br>
zaeen@frontline-impact.com<br>

Kabira Namit, World Bank<br>
knamit@worldbank.org<br>
