knitr::purl(input = "TransformationAssumption.Rmd", output = "transformation.R",documentation = 0)

## #In your preliminary assumption validation, I expect you to look at the explanatory variables and the response variable in your dataset and #validate if the conditions for the simple linear regression (numerical explanatory variables) and ANOVA (categorical explanatory variables) are #met. Note that this is a preliminary analysis, as you will need to do this simultaneously for all variables when we consider multivariate #regression. However, this exercise will prepare to do the multivariate transformation step, if needed.

library(ggplot2)
library(readr)
library(dplyr)
library(gridExtra)
library(grid)
health_insurance <- read.csv("insurance.csv")

# Make a plot to visualize the data
p1 <- ggplot(data = health_insurance, mapping = aes(x = age, y = charges)) +
  geom_point() +
  geom_smooth() +
  geom_smooth(method = "lm", color = "orange", se = FALSE) +
  ggtitle ("age vs charges")

# Linear Model
fit_age <- lm(charges ~ age, data = health_insurance)
health_insurance <- health_insurance %>%
  mutate(
    residuals_age = residuals(fit_age),
    fitted_age = predict(fit_age)
  )

p2 <- ggplot(data = health_insurance, mapping = aes(x = age, y = residuals_age)) +
  geom_point() +
  geom_smooth() +
  ggtitle ("p2. residuals vs age")

p3 <- ggplot(data = health_insurance, mapping = aes(x = age)) +
  geom_density() +
  ggtitle("p3. Distribution of age")

# charges
p4 <- ggplot(data = health_insurance, mapping = aes(x = charges)) +
  geom_density() +
  ggtitle("p4. Distribution of charges")

# residuals
p5 <- ggplot(data = health_insurance, mapping = aes(x = residuals_age)) +
  geom_density() + 
  ggtitle("p5. Distribution of residuals")

grid.arrange(p1,p2,p3,p4,p5, ncol = 2)

health_insurance <- health_insurance %>%
  mutate(
    log_charges = log(charges)
  )

# Make a plot to visualize the data
p1 <- ggplot(data = health_insurance, mapping = aes(x = age, y = log_charges)) +
  geom_point() +
  geom_smooth() +
  geom_smooth(method = "lm", color = "orange", se = FALSE) +
  ggtitle ("log_charges vs age")

# Linear Model
fit_age <- lm(log_charges ~ age, data = health_insurance)
health_insurance <- health_insurance %>%
  mutate(
    residuals_age = residuals(fit_age),
    fitted_age = predict(fit_age)
  )

p2 <- ggplot(data = health_insurance, mapping = aes(x = age, y = residuals_age)) +
  geom_point() +
  geom_smooth() +
  ggtitle ("p2. residuals vs age")

p3 <- ggplot(data = health_insurance, mapping = aes(x = age)) +
  geom_density() +
  ggtitle("p3. Distribution of age")

# charges
p4 <- ggplot(data = health_insurance, mapping = aes(x = log_charges)) +
  geom_density() +
  ggtitle("p4. Distribution of log_charges")

# residuals
p5 <- ggplot(data = health_insurance, mapping = aes(x = residuals_age)) +
  geom_density() + 
  ggtitle("p5. Distribution of residuals")
grid.arrange(p1,p2,p3,p4,p5, ncol = 2)

health_insurance <- health_insurance %>%
  mutate(
    log_age = log(age)
  )

# Make a plot to visualize the data
p1 <- ggplot(data = health_insurance, mapping = aes(x = log_age, y = log_charges)) +
  geom_point() +
  geom_smooth() +
  geom_smooth(method = "lm", color = "orange", se = FALSE) +
  ggtitle ("log_charges vs log_age")

# Linear Model
fit_age <- lm(log_charges ~ log_age, data = health_insurance)
health_insurance <- health_insurance %>%
  mutate(
    residuals_age = residuals(fit_age),
    fitted_age = predict(fit_age)
  )

p2 <- ggplot(data = health_insurance, mapping = aes(x = log_age, y = residuals_age)) +
  geom_point() +
  geom_smooth() +
  ggtitle ("p2. residuals vs age")

p3 <- ggplot(data = health_insurance, mapping = aes(x = log_age)) +
  geom_density() +
  ggtitle("p3. Distribution of age")

# charges
p4 <- ggplot(data = health_insurance, mapping = aes(x = log_charges)) +
  geom_density() +
  ggtitle("p4. Distribution of charges")

# residuals
p5 <- ggplot(data = health_insurance, mapping = aes(x = residuals_age)) +
  geom_density() + 
  ggtitle("p5. Distribution of residuals")
grid.arrange(p1,p2,p3,p4,p5, ncol = 2)

p1 <- ggplot(data = health_insurance, aes(x = charges, color = sex)) +
  geom_density() + 
  labs(title = "Charges by Sex")

p2 <- ggplot(data = health_insurance, aes(x = charges, color = sex)) +
  geom_boxplot() + 
  labs(title = "Charges by Sex")

grid.arrange(p1, p2, ncol=1)

# Standard deviation for each gender group
health_insurance%>%
  group_by(sex) %>%
  summarize(
    sd_charges=sd(charges)
  )

# square root
health_insurance <- health_insurance %>%
  mutate(
    sqrt_charges = sqrt(charges)
  )

p3 <- ggplot(data = health_insurance, mapping = aes(x = sqrt_charges, color = sex)) +
  geom_density() +
  theme_bw()

# log
health_insurance <- health_insurance %>%
  mutate(
    log_charges = log(charges)
  )

p4 <- ggplot(data = health_insurance, mapping = aes(x = log_charges, color = sex)) +
  geom_density() +
  theme_bw()

grid.arrange(p3, p4, ncol=1)

health_insurance%>%
  group_by(sex) %>%
  summarize(
    sd_log_charges=sd(log_charges)
  )

# Make a plot to visualize the data
p1 <- ggplot(data = health_insurance, mapping = aes(x = bmi, y = charges)) +
  geom_point() +
  geom_smooth() +
  geom_smooth(method = "lm", color = "orange", se = FALSE) +
  ggtitle ("p1. bmi vs charges")

# Linear Model
fit_bmi <- lm(charges ~ bmi, data = health_insurance)
health_insurance <- health_insurance %>%
  mutate(
    residuals_bmi = residuals(fit_bmi),
    fitted_bmi = predict(fit_bmi)
  )

# Residuals vs bmi
p2 <- ggplot(data = health_insurance, mapping = aes(x = bmi, y = residuals_bmi)) +
  geom_point() +
  geom_smooth() +
  ggtitle ("p2. residuals vs bmi")

# bmi
p3 <- ggplot(data = health_insurance, mapping = aes(x = bmi)) +
  geom_density() +
  ggtitle("p3. Distribution of bmi")

# charges
p4 <- ggplot(data = health_insurance, mapping = aes(x = charges)) +
  geom_density() +
  ggtitle("p4. Distribution of charges")

# residuals
p5 <- ggplot(data = health_insurance, mapping = aes(x = residuals_bmi)) +
  geom_density() + 
  ggtitle("p5. Distribution of residuals")

grid.arrange(p1,p2,p3,p4,p5, ncol = 2)

health_insurance <- health_insurance %>%
  mutate(
    sqrt_charges = sqrt(charges)
  )
# Linear Model
fit_bmi <- lm(sqrt_charges ~ bmi, data = health_insurance)
health_insurance <- health_insurance %>%
  mutate(
    residuals_bmi = residuals(fit_bmi),
    fitted_bmi = predict(fit_bmi)
  )

# sqrt_charges vs bmi
p1 <- ggplot(data = health_insurance, mapping = aes(x = bmi, y = sqrt_charges)) +
  geom_point() +
  geom_smooth() +
  geom_smooth(method = "lm", color = "orange", se = FALSE) +
  ggtitle("sqrt_charges vs bmi")
    

# Residuals vs bmi
p2 <- ggplot(data = health_insurance, mapping = aes(x = bmi, y = residuals_bmi)) +
  geom_point() +
  geom_smooth() +
  ggtitle ("residuals vs bmi")

# bmi
p3 <- ggplot(data = health_insurance, mapping = aes(x = bmi)) +
  geom_density() +
  ggtitle("Distribution of bmi")

# sqrt_charges
p4 <- ggplot(data = health_insurance, mapping = aes(x = sqrt_charges)) +
  geom_density() +
  ggtitle("Distribution of sqrt_charges")

# residuals
p5 <- ggplot(data = health_insurance, mapping = aes(x = residuals_bmi)) +
  geom_density() + 
  ggtitle("Distribution of residuals")

grid.arrange(p1,p2,p3,p4,p5, ncol = 2)

health_insurance <- health_insurance %>%
  mutate(
    log_charges = log(charges)
  )
# Linear Model
fit_bmi <- lm(log_charges ~ bmi, data = health_insurance)
health_insurance <- health_insurance %>%
  mutate(
    residuals_bmi = residuals(fit_bmi),
    fitted_bmi = predict(fit_bmi)
  )

# log_charges vs bmi
p1 <- ggplot(data = health_insurance, mapping = aes(x = bmi, y = log_charges)) +
  geom_point() +
  geom_smooth() +
  geom_smooth(method = "lm", color = "orange", se = FALSE) +
  ggtitle("log_charges vs bmi")
    

# Residuals vs bmi
p2 <- ggplot(data = health_insurance, mapping = aes(x = bmi, y = residuals_bmi)) +
  geom_point() +
  geom_smooth() +
  ggtitle ("residuals vs bmi")

# bmi
p3 <- ggplot(data = health_insurance, mapping = aes(x = bmi)) +
  geom_density() +
  ggtitle("Distribution of bmi")

# log_charges
p4 <- ggplot(data = health_insurance, mapping = aes(x = log_charges)) +
  geom_density() +
  ggtitle("Distribution of log_charges")

# residuals
p5 <- ggplot(data = health_insurance, mapping = aes(x = residuals_bmi)) +
  geom_density() + 
  ggtitle("Distribution of residuals")

grid.arrange(p1,p2,p3,p4,p5, ncol = 2)

health_insurance <- health_insurance %>%
  mutate(
    charges_0.25 = charges^0.25
  )
# Linear Model
fit_bmi <- lm(charges_0.25 ~ bmi, data = health_insurance)
health_insurance <- health_insurance %>%
  mutate(
    residuals_bmi = residuals(fit_bmi),
    fitted_bmi = predict(fit_bmi)
  )

# charges_0.25 vs bmi
p1 <- ggplot(data = health_insurance, mapping = aes(x = bmi, y = charges_0.25)) +
  geom_point() +
  geom_smooth() +
  geom_smooth(method = "lm", color = "orange", se = FALSE) +
  ggtitle("charges_0.25 vs bmi")
    

# Residuals vs bmi
p2 <- ggplot(data = health_insurance, mapping = aes(x = bmi, y = residuals_bmi)) +
  geom_point() +
  geom_smooth() +
  ggtitle ("residuals vs bmi")

# bmi
p3 <- ggplot(data = health_insurance, mapping = aes(x = bmi)) +
  geom_density() +
  ggtitle("Distribution of bmi")

# charges_0.25
p4 <- ggplot(data = health_insurance, mapping = aes(x = charges_0.25)) +
  geom_density() +
  ggtitle("Distribution of charges_0.25")

# residuals
p5 <- ggplot(data = health_insurance, mapping = aes(x = residuals_bmi)) +
  geom_density() + 
  ggtitle("Distribution of residuals")

grid.arrange(p1,p2,p3,p4,p5, ncol = 2)

health_insurance <- health_insurance %>%
  mutate(
    log_charges = log(charges),
    bmi_0.25 = bmi^0.25
  )
# Linear Model
fit_bmi <- lm(log_charges ~ bmi_0.25, data = health_insurance)
health_insurance <- health_insurance %>%
  mutate(
    residuals_bmi = residuals(fit_bmi)
  )

# log_charges vs bmi_0.25
p1 <- ggplot(data = health_insurance, mapping = aes(x = bmi_0.25, y = log_charges)) +
  geom_point() +
  geom_smooth() +
  geom_smooth(method = "lm", color = "orange", se = FALSE) +
  ggtitle("charges_0.25 vs bmi_0.25")
    

# Residuals vs bmi
p2 <- ggplot(data = health_insurance, mapping = aes(x = bmi, y = residuals_bmi)) +
  geom_point() +
  geom_smooth() +
  ggtitle ("residuals vs bmi_0.25")

# bmi_0.25
p3 <- ggplot(data = health_insurance, mapping = aes(x = bmi_0.25)) +
  geom_density() +
  ggtitle("Distribution of bmi_0.25")

# log_charges
p4 <- ggplot(data = health_insurance, mapping = aes(x = log_charges)) +
  geom_density() +
  ggtitle("Distribution of charges_0.25")

# residuals
p5 <- ggplot(data = health_insurance, mapping = aes(x = residuals_bmi)) +
  geom_density() + 
  ggtitle("Distribution of residuals")

grid.arrange(p1,p2,p3,p4,p5, ncol = 2)

# Make a plot to visualize the data
p1 <- ggplot(data = health_insurance, mapping = aes(x = children, y = charges)) +
  geom_point() +
  geom_smooth() +
  geom_smooth(method = "lm", color = "orange", se = FALSE) +
  ggtitle ("children vs charges")

# Linear Model
fit_children <- lm(charges ~ children, data = health_insurance)
health_insurance <- health_insurance %>%
  mutate(
    residuals_children = residuals(fit_children),
    fitted_children = predict(fit_children)
  )

p2 <- ggplot(data = health_insurance, mapping = aes(x = children, y = residuals_children)) +
  geom_point() +
  geom_smooth() +
  ggtitle ("p2. residuals vs children")

p3 <- ggplot(data = health_insurance, mapping = aes(x = children)) +
  geom_density() +
  ggtitle("p3. Distribution of children")

# charges
p4 <- ggplot(data = health_insurance, mapping = aes(x = charges)) +
  geom_density() +
  ggtitle("p4. Distribution of charges")

# residuals
p5 <- ggplot(data = health_insurance, mapping = aes(x = residuals_children)) +
  geom_density() + 
  ggtitle("p5. Distribution of residuals")
grid.arrange(p1,p2,p3,p4,p5, ncol = 2)

health_insurance <- health_insurance %>%
  mutate(
    log_charges = log(charges),
    log_children = log(children+1)
  )

# Make a plot to visualize the data
p1 <- ggplot(data = health_insurance, mapping = aes(x = log_children, y = log_charges)) +
  geom_point() +
  geom_smooth() +
  geom_smooth(method = "lm", color = "orange", se = FALSE) +
  ggtitle ("log_charges vs log_children")

# Linear Model
fit_children <- lm(log_charges ~ log_children, data = health_insurance)
health_insurance <- health_insurance %>%
  mutate(
    residuals_children = residuals(fit_children),
    fitted_children = predict(fit_children)
  )

p2 <- ggplot(data = health_insurance, mapping = aes(x = log_children, y = residuals_children)) +
  geom_point() +
  geom_smooth() +
  ggtitle ("p2. residuals vs log_children")

p3 <- ggplot(data = health_insurance, mapping = aes(x = log_children)) +
  geom_density() +
  ggtitle("p3. Distribution of log_children")

# charges
p4 <- ggplot(data = health_insurance, mapping = aes(x = log_charges)) +
  geom_density() +
  ggtitle("p4. Distribution of log_charges")

# residuals
p5 <- ggplot(data = health_insurance, mapping = aes(x = residuals_children)) +
  geom_density() + 
  ggtitle("p5. Distribution of residuals")
grid.arrange(p1,p2,p3,p4,p5, ncol = 2)

p1 <- ggplot(data = health_insurance, aes(x = charges, color = smoker)) +
  geom_density()+
  labs(title = "Charges by if the person is a smoker or not")

p2 <- ggplot(data = health_insurance, aes(y = charges, x = smoker)) +
  geom_boxplot()+
  labs(title = "Charges by if the person is a smoker or not")

grid.arrange(p1, p2, ncol=1)

health_insurance %>%
  group_by(smoker) %>%
  summarize(
    sd_charges = sd(charges)
  )

# square root
p3 <- ggplot(data = health_insurance, mapping = aes(x = sqrt_charges, color = smoker)) +
  geom_density()

health_insurance %>%
  group_by(smoker) %>%
  summarise(
    sd_sqrt_charges = sd(sqrt_charges)
  )

# log
p4 <- ggplot(data = health_insurance, mapping = aes(x = log_charges, color = smoker)) +
  geom_density()

grid.arrange(p3, p4)

health_insurance %>%
  group_by(smoker) %>%
  summarise(
    sd_log_charges = sd(log_charges)
  )

# Plot the distribution by group
p1 <- ggplot(data = health_insurance, aes(x = charges, color = region)) +
  geom_density()+
  labs(title = "Charges by location of residence")

p2 <- ggplot(data = health_insurance, aes(y = charges, x = region)) +
  geom_boxplot()+
  labs(title = "Charges by location of residence")

grid.arrange(p1, p2, ncol=1)

# Standard deviation for each gender group
health_insurance%>%
  group_by(region) %>%
  summarize(
    sd_charges=sd(charges)
  )

ggplot(data = health_insurance, mapping = aes(x = log_charges, color = region)) +
  geom_density()

health_insurance %>%
  group_by(region) %>%
  summarise(
    sd_log_charges = sd(log_charges)
  )
