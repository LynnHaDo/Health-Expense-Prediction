# Health Expense Prediction using Multiple Linear Regression Approach

## Introduction

From the perspective of the health insurance company, the medical expenses of the beneficiaries have direct impact on whether or not the cost of the insurance plan should be increased/decreased (in order to maximize profit). Therefore, they are especially interested in predicting the medical expenses, in order to gain insights into the potential predictors that might correlate with a change in this factor. 

### Dataset

The data set we look at is a synthetic data set that uses **actual demographic statistics from the US Census Bureau**. Therefore, it can give an approximate of real-world conditions. 

There are 1338 observations, each representing an individual enrolled in the insurance plan. There are 7 demographic statistics of concern: age, sex, BMI (which is a metric used to measure a person's weight wrt. height), number of children, smoking habits, and region of residence in the US. For this analysis, as expected, we will treat `charges` as the response variable, and the other 6 variables as potential explanatory variables.

### Hypotheses

$H_0: \text{Age, sex, BMI, number of children, smoking habits, and region of residence are not associated with a change in average medical expense.}$

$H_A: \text{At least one of those factors are associated with a change in average medical expense.}$

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

<img src = "img/bic.png" width = "400px" />

Using the BIC metric, we were able to confirm that the best model (model 4) included these variables: `age`, `bmi`, `children`, `smoker`. However, as observed above, we may encounter a problem with linearity condition if we include `children` in the model. Specifically, `children` when standing alone has visibly no correlation with `charges`. 

<img src = "img/slr_children.png" width = "400px" />

Our simple linear regression results for these 2 variables alone, even after some trials of transformation, also proved this point. That leads us to select just 3 variables: `age`, `bmi`, `smoker`. 

Remember that we noticed that there are clearly 2 distinct clouds in the `bmi` vs. `charges` plot. When we look closely into the interactions between the 4 variables selected, we also observe the 2 distinct slopes for each smoker group, meaning: an additional increase in the `bmi` for people who don't smoke is associated with *less increase* in `charges` compared with people who smoke.   

<img src = "img/bmi_smoker.png" width = "400px" />

This guides us to add an interaction for `bmi` and `smoker` in our final model to account for the pattern we observed:

Estimated model:

$$\hat{\mu}(\text{charges}_i | X_i) = -2290.008 + 266.758 \times \text{age} \\ + 7.109 \times \text{bmi} \\ - 20093.508 \times I(\text{smoker = yes}) \\ + 1430.920 \times (\text{smoker=yes} \times \text{bmi})$$

<img src = "img/model_summary.png" width = "400px"/>

The predictors $X_i$ are:

- $X_1$: age
- $X_2$: bmi
- $X_3$: indicator for smoke group (1 if that individual smokes, 0 otherwise)
- $X_4$: $x_3 \times bmi$

### Assumptions with Diagnostic plots

1.  Independence: There is not enough information to conclude about whether the patients included in this data set, by any chance, are related (there is no information on how the individuals with these demographic statistics are selected). In this case, we have to assume independence.

2.  Linearity:

-  Residuals vs BMI: we differentiate `smokeryes` and `smokerno` with colors and notice the patterns as in the plot above, which makes us unsure about whether this condition is met. As shown, there are 2 distinct slopes for each smoker group, which we have accounted for using the interaction term. We will still revisit this when we transform the variables. 

<img src = "img/cond_resid_bmi.png" width = "400px" />

-  Residuals vs age: the linearity is met (no observable pattern).

<img src = "img/cond_resid_age.png" width = "400px" />

4.  Equal variance of residuals: The variance of the residuals for each smoker group indicates the equal variance condition satisfaction since the standard deviations are roughly similar (ratio = 1.22).

<img src = "img/ev.png" width = "400px"/>

4.  Outliers: Across all metrics for identifying outliers, we observe the same pattern: there are many points with exceptionally high `y`. 

<img src = "img/leverage.png" width = "400px"/>

For leverage, there are many points above the cutoff line y-intercepting at 0.0075 in the Leverage plot which are detected to be outliers. 

<img src = "img/studentized.png" width = "400px"/>

Same for studentized, there are many studentized residuals that are larger than 2.

<img src = "img/cook.png" width = "400px"/>

The Cook's distance plot helps us gain more insight into the points that if omitted from the model, will have the most effect. 

It's definitely an issue we will need to examine.

5. Normal distribution of residuals: Looking at the distribution of the residual, the plot looks right-skewed, which we will attempt to transform to meet this condition. 

<img src = "img/cond_normal.png" width = "400px"/>

6. Multicollinearity: As observed in part 1, and also confirmed in the results of the VIF metric, we can see that there is no concerning correlation between the variables.

<img src = "img/cond_mult.png" width = "400px"/>

### Transformations

So there are 2 conditions which we will need to examine: outliers, normal distribution of residuals, linearity for `bmi`. We will then show that, actually no transformation is better than if we did transform.

#### Normal distribution of residuals

We determine a set of transformations for `charges`, `age` and `bmi` according to our findings in the simple linear regression analysis as follows:

First, we will go down the ladder for charges since the residuals plot is right-skewed. We choose `log`. Other variables are left as is.

<img src = "img/trans_normal.png" width = "400px"/>

Based on our observation:

- Linearity for `age` vs. `charges` goes from "met" to "unmet" with this transformation. There is a curve in this plot once we take the log of charges, which is visible even with an additional term $age^3$.

<img src = "img/trans_normal_ageq.png" width = "400px"/>

Going further down the ladder for the response even makes the curvy pattern more obvious.

- Outliers issue seems to persist, even after we went down the ladder further. There just seems to be a lot of data points with extremely high `charges` value. We will examine this issue closely in a minute.  

#### Outliers

If we use the threshold $2 \times 5/\text{number of rows}$ for leverage (class notes), 2 for studentized, greater than $4/nrow$ for Cook's distance, there are in fact 113, 88, 86 outliers respectively in this dataset!  

<img src = "img/outliers_comp.png" width = "400px" />

Just to make sure we handle the worst case scenario, we performed a quick analysis of the model with and without the suspicious leverage points:

- The p-values for the parameters do not significantly change.
- The estimates: If we consider the estimates that are above 3 SDs away from the original estimate to be "weird"
  - `age` and `bmi` coefficients do not seem to significantly change. New estimates are < 3 SDs away from the old ones 
  - Change in $I(smoker=yes)$ and interaction term coefficients: most significant change. 

**What does this mean?** We took a closer look at the data points which are suspicious and got an interesting finding: 88% of the high leverage points (100 points out of 113) come from the smoker group! This confirms our previous assumption about the distinction between these 2 groups. 

<img src = "img/outliers_smoker.png" width = "400px" />

**Long story short**: We do not see it necessary to do transformation with charge here as it does not bring about clear improvement with the residuals, or better the linearity condition. The interaction term, as we saw, has accounted for this distinction in the slope of `bmi` and `charges` for 2 smoker groups.

### Model statement for the other models 

Going back to our BIC results, there are 2 other models with the same or even better performance to our final model: model 4 and 5.

<img src = "img/bic_comp.png" width = "400px"/>

But these models both have the `children` variable as a predictor, which we already confirmed has little to no correlation with the response. Since the assumptions may not meet for these 2 models, we will leave these model equations here, but with cautious application:

Model 4: `age`, `bmi`, `children`, `smoker`

$$\hat{\mu}(\text{charges}_i | X_i) = -2729.002 + 264.948 \times \text{age} \\ +508.924 \times \text {children} \\ + 5.656 \times \text{bmi} \\ - 20194.709 \times I(\text{smoker = yes}) \\ + 1433.788 \times (\text{smoker=yes} \times \text{bmi})$$

Model 5: `age`, `bmi`, `children`, `smoker`, `regionsoutheast`

For this model, we need to create a new variable `region_new` that groups all regions other than southeast into 1 group.

$$\hat{\mu}(\text{charges}_i | X_i) = -2902.567 + 264.231 \times \text{age} \\ + 17.308 \times \text{bmi} \\ - 20153.078 \times I(\text{smoker = yes}) \\ + 503.458 \times \text {children} \\ - 582.178 \times I(\text{region = southeast}) \\ + 1433.826 \times (\text{smoker=yes} \times \text{bmi})$$

### Comparison between models

We compare the 3 models performance with and without the outliers, using BIC as the metric:

<img src = "img/bic_outliers_comp.png" width = "400px" />

As we can see, model 4 has the lowest BIC of all 3, both for a fit with all data or data without the outliers. We don't know for sure if the differences in BIC is statistically significant in order to conclude where `children` is actually important. This might be an area for future work. 

### Significant parameters in the final model

In our final model, from the summary, we can see that `age`, `smoker`, and the interaction term are statistically significant in predicting mean charge. `bmi` when standing alone actually is not a significant term in the model.

## Results

### Interpretation

#### Final model: 
- $Y$: charges
  
The predictors $X_i$ are:

- $X_1$: age
- $X_2$: bmi
- $X_3$: indicator for smoke group (1 if that individual smokes, 0 otherwise)
- $X_4$: $x_3 \times bmi$
Final model decribing the relationship between `charges` (response variable) with `bmi`, `smoke`, and `age`:

$$\mu_(Y_i|X_1) = \beta_0 + \beta_1 \times \text{age} \\ + \beta_2 \times \text{bmi} \\ + \beta_3 \times \ I(\text{smoker = yes}) \\ + \beta_4 \times (\text{smoker = yes} \times \text{bmi}) $$

#### Estimated model:

$$\hat{\mu}(\text{charges}_i | \text{bmi}, \text{smoker = yes}, \text{age}) = -2290.008 + 266.758 \times \text{age} \\ + 7.109 \times \text{bmi} \\ - 20093.508 \times I(\text{smoker = yes}) \\ + 1430.920 \times (\text{smoker = yes} \times \text{bmi})$$

<img src = "img/model_summary.png" width = "400px"/>

## Interpretation

#### Parameters

$\hat{\beta_0}$ = -2290.008: It is estimated the the mean insurance medical charges of non-smokers of 0 year old, with bmi = 0 is -2290.008 (currency unit) (unrealistic)

$\hat{\beta_1}$ = 266.758: It is estimated that the mean insurance medical charges increase by 266.758 (currency unit) for each increase in the age of people like those in the study, for a fixed type of smokers and bmi on average

$\hat{\beta_2}$ = 7.109: It is estimated that the mean insurance medical charges increase by 7.109 for each increase in the bmi of non-smokers, for a fixed age level.

$\hat{\beta_3}$ = -20093.508: It is estimated that the mean insurance medical charges for smokers is 20093.508 (currency unit) less than that for non-smokers at a fixed age level and bmi = 0.

$\hat{\beta_4}$ = 1430.920: It is estimated that the mean insurance medical charges for smokers increase by 1430.920 (currency unit) for each increase in the bmi compared to non-smokers, at fixed level of age.

### Specific numerical results

#### Confidence intervals

<img src = "https://github.com/LynnHaDo/Health-Expense-Prediction/assets/144966197/b64e4c9d-cad3-4560-bd80-ae047a7a0b37)" width = "400px"/>

We are 95% confident that the true $\hat{\beta_0}$ is between -3922.18 and -657.84, $\hat{\beta_1}$ is between 247.9 and 285.62, $\hat{\beta_2}$ is between -42.05 and 56.27, $\hat{\beta_3}$ is between -23363.4 and -16823.6, $\hat{\beta_4}$ 1326.5 and 1535.3. By 95% confident, we mean that for 95% of samples from a similar population, confidence intervals computed in this way would capture those true parameters respectively, keeping other variables constant, in the population of people like those in the study. 

#### Hypothesis conclusion


## Discussions and Conclusions

### Limitations

-   Even though the characteristics of the observations are claimed to be taken from real-world data from US Census Bureau, the expenses are simulated. Meaning there are limits to the population we can extend the results to;

-   Data on medical expenses may be kept private (example, like in medical records), so there might be some limitations in approaching data;
  
-   There might be many other economic factors though not being covered in this study might be one of the deteminant factors in medical expenses and insurance purchase
  
### Future work

-   The model can be used to predict medical expenses for reference purposes but restricted to some particular population with similar statistics as those in this study. The study, if possible, can be expanded to larger demographics for better generalization;

-   We hope to get access to updated data set to reflect better current market conditions and consumers' tendencies in the market bracket of insurance and medicine

-   We will perform other transformations to see if we can still find a better model;

-   More variables can be updated in future data set, such as people's income, occupations, health conditions, etc to create more comprehensive model

## References

1. Datta, A. (n.d.). US Health Insurance Dataset. [online] www.kaggle.com. Available at: <https://www.kaggle.com/datasets/teertha/ushealthinsurancedataset/discussion/156033> [Accessed 26 Mar. 2024].
2. www.scikit-yb.org. (n.d.). Cook’s Distance — Yellowbrick v1.5 Documentation. [online] Available at: https://www.scikit-yb.org/en/latest/api/regressor/influence.html#:~:text=Because%20of%20this%2C%20Cook [Accessed 25 Apr. 2024].
3. Class notes: Multiple Regression Outliers, Multiple Regression Model Selection, Multiple Regression Multicollinearity, HW8 Key

**R libraries**
```
library(dplyr) # functions like summarize
library(ggplot2) # for making plots
library(readr)
library(tidyverse)
library(GGally)
library(grid)
library(gridExtra)
library(leaps)
library(car)
```
