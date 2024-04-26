library(dplyr) # functions like summarize
library(ggplot2) # for making plots
library(readr)
library(tidyverse)
library(GGally)
library(grid)
library(gridExtra)
library(leaps)
library(car)
options("pillar.sigfig" = 10) # print 10 significant digits in summarize output
knitr::purl(input = "medical-expense-code.Rmd", output = "medical-expense-code.R",documentation = 0)

health_insurance <- read.csv("insurance.csv")

ggpairs(health_insurance %>% select(age, bmi, children, charges)) +
  theme_bw()

p1 <- ggplot(data = health_insurance, aes(y = charges, x = sex)) +
  geom_boxplot() + 
  labs(title = "Charges by Sex")

p2 <- ggplot(data = health_insurance, aes(y = charges, x = smoker)) +
  geom_boxplot()+
  labs(title = "Charges by if the person is a smoker or not")

p3 <- ggplot(data = health_insurance, aes(y = charges, x = region)) +
  geom_boxplot()+
  labs(title = "Charges by region of residence")

grid.arrange(p1, p2, p3, nrow = 1)

m1 <- regsubsets(charges ~ ., data = health_insurance)
plot(m1)

summary(m1)
summary(m1)$bic
vis_bic <- data.frame(Model = 1:8,
                      BIC = summary(m1)$bic)
ggplot(data = vis_bic, aes(x = Model, y = BIC)) +
  geom_point(aes(color = BIC < -1812), size = 3) +
  geom_line() +
  theme_bw() 

#lm1 <- lm(charges ~ ., data = health_insurance)
#summary(lm1)

lm3 <- lm(charges ~ age + bmi * smoker, data = health_insurance)
lm4 <- lm(charges ~ age + children + bmi * smoker, data = health_insurance)
#summary(lm3)

health_insurance <- health_insurance %>% 
  mutate(
    region_new = ifelse(region == "southeast", "southeast", "other")
  )

lm5 <- lm(charges ~ age + bmi * smoker + children + region_new, data = health_insurance)

p4 <- ggplot(data = health_insurance, aes(x = bmi, y = charges, color = smoker)) +
  geom_point()+
  geom_smooth(method = "lm", se.fit = FALSE) +
  labs(title = "BMI vs. Charges")
p4

health_insurance <- health_insurance %>% 
  mutate(residual = residuals(lm3) 
)

p5 <- ggplot(data = health_insurance, aes(x = residual)) +
  geom_density()+
  labs(title = "Distribution of residuals")

p6 <- ggplot(data = health_insurance, aes(x = bmi, y = residual, color=smoker)) +
  geom_point() + 
  geom_hline(yintercept=0,color="red") + 
  labs(title = "Residuals vs. BMI") +
  theme_bw()

p7 <- ggplot(data = health_insurance, aes(x = age, y = residual)) +
  geom_point() + 
  geom_hline(yintercept=0,color="red") + 
  labs(title = "Residuals vs. Age") +
  theme_bw()

grid.arrange(p5, p6, p7, ncol=2)

health_insurance %>% 
  group_by(smoker) %>% 
  summarize(std_dev=sd(residual))

lm1 <- lm(charges ~ age + bmi + smoker, data = health_insurance)
vif(lm1)
#confint(lm1)

health_insurance <- health_insurance %>%
  mutate(
    obs_index = row_number(),
    h = hatvalues(lm3),
    studres = rstudent(lm3),
    D = cooks.distance(lm3)
  )

ggplot(data = health_insurance, aes(x = obs_index, y = h)) +
  geom_point() +
  geom_hline(yintercept = 2 * 5/nrow(health_insurance)) +
  theme_bw() +
  ggtitle ("Leverage")

ggplot(data = health_insurance, aes(x = obs_index, y = studres)) +
  geom_point() +
  ggtitle("Studentized Residuals") +
  theme_bw() 

ggplot(data = health_insurance, aes(x = obs_index, y = D)) +
  geom_point() +
  ggtitle ("Cook's Distance") +
  theme_bw()


lm2 <- lm(charges ~ bmi + region + smoker, data = health_insurance)
vif(lm2)

outliers_lev <- health_insurance %>% filter(
  health_insurance$h > (2 * 5/nrow(health_insurance)) # leverage
)

outliers_stu <- health_insurance %>% filter(
  abs(health_insurance$studres) > 2 # studentized
)

outliers_cook <- health_insurance %>% filter(
  health_insurance$D > 4/nrow(health_insurance) # cook
)

outliers_summary <- data.frame(
  Leverage_count = dim(outliers_lev)[1],
  Studentized_count = dim(outliers_stu)[1],
  Cook_count = dim(outliers_cook)[1]
)

outliers_summary

### outliers
obs_to_investigate <- outliers_lev$obs_index

### All data
round(summary(lm3) $ coefficients, 4 )

### All data but outliers
health_insurance_minus_suspicious <- health_insurance[-obs_to_investigate, ]
lm3_without_suspicious <- lm(charges ~ bmi*smoker + age, data = 
                               health_insurance_minus_suspicious)
round(summary(lm3_without_suspicious) $ coefficients, 4 )

### Try stepping down the ladder with charges
health_insurance <- health_insurance %>% mutate(
  charges_log = log(charges),
  age_q = age^3
)

lm2_log <- lm(charges_log ~ bmi*smoker + age + age_q, data = health_insurance)
health_insurance <- health_insurance %>% 
  mutate(residual_log = residuals(lm2_log) 
)

p5 <- ggplot(data = health_insurance, aes(x = residual_log)) +
  geom_density()+
  labs(title = "Distribution of residual_log")

p6 <- ggplot(data = health_insurance, aes(x = bmi, y = residual_log)) +
  geom_point() + 
  geom_hline(yintercept=0,color="red") + 
  labs(title = "residual_log vs. bmi") +
  theme_bw()

p7 <- ggplot(data = health_insurance, aes(x = age, y = residual_log)) +
  geom_point() + 
  geom_hline(yintercept=0,color="red") + 
  labs(title = "residual_log vs. age") +
  theme_bw()

p8 <- ggplot(data = health_insurance, aes(x = residual_log, color = smoker)) +
  geom_density() + 
  theme(legend.position="bottom") +
  labs(title = "residual_log vs. Smoke or not smoke")
  theme_bw()

#grid.arrange(p5, p6, p7, p8, ncol = 2)
p7

health_insurance %>%
  group_by(smoker) %>%
  summarize(std_dev = sd(residual_log))

library(lattice)
library(flexmix)

lm3 <- lm(charges ~ bmi*smoker + age, data = health_insurance)
lm3_without_suspicious <- lm(charges ~ bmi*smoker + age, data = health_insurance_minus_suspicious)

lm4 <- lm(charges ~ bmi*smoker + age + children, data = health_insurance)
lm4_without_suspicious <- lm(charges ~ bmi*smoker + age + children, data = health_insurance_minus_suspicious)

lm5 <- lm(charges ~ bmi*smoker + age + children + region_new, data = health_insurance)
lm5_without_suspicious <- lm(charges ~ bmi*smoker + age + children + region_new, data = health_insurance_minus_suspicious)

bic_summary <- data.frame(row.names = c("all data", "all but outliers"))
bic_summary$m3 <- c(BIC(lm3), BIC(lm3_without_suspicious))

bic_summary$m4 <- c(BIC(lm4), BIC(lm4_without_suspicious))

bic_summary$m5 <- c(BIC(lm5), BIC(lm5_without_suspicious))

bic_summary

summary(lm3)
