#### Preamble ####
# Purpose: To predict the severity of traffic collisions using demographic, temporal, and environmental factors.
# Author: Sinan Ma
# Email: sinan.ma@mail.utoronto.ca
# Date: 18 April 2024
# License: MIT
# Pre-requisites: This script requires the 'rstanarm' package for Bayesian regression and 'tidyverse' for data manipulation.
# Any other information needed?: Data should be pre-processed as per the script provided to ensure correct formats and types.

#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
analysis_data <- read_csv("data/analysis_data/analysis_data.csv")

analysis_data <- analysis_data |>
  mutate(
    severity = case_when(
      severity == "Fatal" ~ 1,
      severity == "Non-Fatal" ~ 0,
      TRUE ~ NA_real_  # Handle potential 'Unknown' or other cases as NA
    ),
    gender = factor(gender),
    person_position = factor(person_position),
    month = factor(month),
    day_of_week = factor(day_of_week),
    weather = factor(weather),
    road_surface = factor(road_surface)
  ) |>
  drop_na(severity)

### Model data ####
# Fit a Bayesian logistic regression model using 'stan_glm'
severity_model <- stan_glm(
  formula = severity ~ age + gender + weather + road_surface + month + day_of_week + hour + person_position,
  data = analysis_data,
  family = binomial(link = "logit"),  # Logistic regression for binary outcome
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),  # Normal prior for regression coefficients
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),  # Normal prior for the intercept
  prior_aux = exponential(rate = 1, autoscale = TRUE),  # Exponential prior for the auxiliary parameter
  seed = 853  # Set seed for reproducibility
)

#### Save model ####
saveRDS(severity_model, file = "models/severity_model.rds")

#### Output Model Summary ####
print(summary(severity_model))


