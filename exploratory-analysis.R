library(dplyr) # functions like summarize
library(ggplot2) # for making plots
library(readr)
library(tidyverse)
options("pillar.sigfig" = 10) # print 10 significant digits in summarize output

# As a group, you should select a data set with at least 6 variables (at least 3 numeric, at least 1 categorical). This website (https://vincentarelbundock.github.io/Rdatasets/articles/data.html) includes an extensive list of data sets - I recommend choosing a data set from here unless you have already a data set in mind. Keep in mind that you should avoid time series data, as it is not independent (let me know if you are unsure about this). Using this data set, use linear regression to analyze the data set, including exploratory data analyses, graphics for checking regression assumptions, a final model, and inference on the regression coefficients. Based on this analysis, create a 10 minute presentation of your analysis, highlighting the background of the project, the specific questions you were investigating, and interesting exploratory analyses and results.

health_insurance <- read.csv("insurance.csv")
glimpse(health_insurance)

ggplot(data = health_insurance, aes(x = charges)) +
  geom_histogram(na.rm = TRUE) + 
  labs(
    title = "Distribution of medical charges",
    x = "Cost",
    y = "Number of Patients"
  )

ggplot(data = health_insurance, aes(y = charges, x = bmi)) +
  geom_point(na.rm = TRUE) + 
  geom_smooth(method = "lm") + 
  ggtitle("Charges by bmi")

ggplot(data = health_insurance, aes(y = charges, x = age)) +
  geom_point(na.rm = TRUE) + 
  geom_smooth(method = "lm") + 
  ggtitle("Charges by age")

ggplot(data = health_insurance, aes(y = charges, x = sex)) +
  geom_boxplot() + 
  labs(title = "Charges by Sex")

ggplot(data = health_insurance, aes(y = charges, x = children)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "Charges by number of children")

ggplot(data = health_insurance, aes(y = charges, x = smoker)) +
  geom_boxplot()+
  labs(title = "Charges by if the person is a smoker or not")

ggplot(data = health_insurance, aes(y = charges, x = region)) +
  geom_boxplot()+
  labs(title = "Charges by region of residence")
