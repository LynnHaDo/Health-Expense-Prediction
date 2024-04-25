# Health Expense Prediction using Multiple Linear Regression Approach

## Introduction

From the perspective of the health insurance company, the medical expenses of the beneficiaries have direct impact on whether or not the cost of the insurance plan should be increased/decreased (in order to maximize profit). Therefore, they are especially interested in predicting the medical expenses, in order to gain insights into the potential predictors that might correlate with a change in this factor. 

### Dataset

The data set we look at is a synthetic data set that uses **actual demographic statistics from the US Census Bureau**. Therefore, it can give an approximate of real-world conditions. 

There are 1338 observations, each representing an individual enrolled in the insurance plan. There are 7 demographic statistics of concern: age, sex, BMI (which is a metric used to measure a person's weight wrt. height), number of children, smoking habits, and region of residence in the US. For this analysis, as expected, we will treat `charges` as the response variable, and the other 6 variables as potential explanatory variables.

### Hypotheses

$$H_0: \text{Age, sex, BMI, number of children, smoking habits, and region of residence are not associated with a change in average medical expense.}$$

$$H_A: \text{At least one of those factors are associated with a change in average medical expense.}$$

### Summary statistics

**1. Examining the numerical variables**

<img src = "img/ggpair_numerical.png" width = "400px"/>

Just from visual inspection, focusing on the last row, we observe a few things:

- There seems to be positive correlation between `age` and `charges`. In the plot, there are 3 clouds of points corresponding to each tier of charges. For each cloud, the positive correlation can be seen.
- The same with `bmi` and `charges`. There seems to be 2 tiers of charges, each both have a positive correlation with `bmi`.
- On the other hand, there is little to no relationship between `charges` and number of children.

**2. Examining the categorical variables**

<img src = "img/plot_categorical.png" width = "400px"/>

Smoking habit seems to be the factor that is most related with the change in `charges`. Specifically, the yes group (corresponding to the smoker group) tends to be associated with higher amount of charges.

## Method

### Final Model Equation

\begin{equation}
\mu(\text{charges}_i | X_i) = \beta_0 + \beta_1 \text{age} + \beta_2 I(\text{smoker = yes}) \\ + \beta_3\text{bmi} + \beta_4 (\text{smoker_yes} \times \text{bmi}) + \epsilon_i
\end{equation}

### Assumptions with Diagnostic plots

1.  Independence: There is not enough information to conclude about whether the patients included in this data set, by any chance, are related (there is no information on how the individuals with these demographic statistics are selected). However, since the medical expenses are simulated, we can assume independence in this case.

2.  Linearity: For the plot for Residuals vs BMI and residuals vs age, we differentiate `smokeryes` and `smokerno` with colors and notice the patterns as in the plot above; still we cannot make sure if linearity is met with this plot. However, as for the function of age, the linearity is met.

3.  Equal variance of residuals: The variance of the residuals for each smoker group indicates the equal variance condition satisfaction since the standard deviations are roughly similar (ratio = 1.19).

4.  Outliers: There are many points above the cutoff line y-intercepting at 0.0075 in the Leverage plot which we suspect to be outliers

5.  Normal distribution of residuals: Looking at the distribution of the residual, the plot looks quite symmetric, though there are some right-skewness present but it is still good.

6.  Multicollinearity

### Transformations

### Model statement

### Comparison between models

### Significant parameters in the model

## Results

### Interpretation

### Specific numerical results


## Discussions and Conclusions

### Limitations

-   Even though the characteristics of the observations are claimed to be taken from real-world data, the expenses are simulated. Meaning there are limits to the population we can extend the results to.

-   Data on medical expenses may be kept private (example, like in medical records), so it can be hard to access those.

### Future work

-   The model can be used to predict medical expenses for reference purposes but restricted to some particular population with similar statistics as those in this study.

-   We will perform other transformations to see if we can still find a better model.

-   Move on and learn new tools to predict other stuff on this dataset.

## References

Datta, A. (n.d.). US Health Insurance Dataset. [online] www.kaggle.com. Available at: <https://www.kaggle.com/datasets/teertha/ushealthinsurancedataset/discussion/156033> [Accessed 26 Mar. 2024].

