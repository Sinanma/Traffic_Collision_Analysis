#### Preamble ####
# Purpose: To predict the severity of traffic collisions using demographic, temporal, and environmental factors.
# Author: Sinan Ma
# Email: sinan.ma@mail.utoronto.ca
# Date: 18 April 2024
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
analysis_data <- read_csv("data/Collision_data/analysis_data/analysis_collision_data.csv")

### Data Preprocessing ###
analysis_data <- analysis_data |>
  mutate(
    Severity = case_when(
      Severity == "Fatal" ~ 1,
      Severity == "Non-Fatal" ~ 0,
      TRUE ~ NA_real_  
    ),
    Gender = factor(Gender),
    Age = as.numeric(Age)
  ) |>
  drop_na(Severity, Age)

### Model data ####
severity_model <- stan_glm(
  formula = Severity ~ Age + Gender,
  data = analysis_data,
  family = binomial(link = "logit"),  
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE), 
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE), 
  prior_aux = exponential(rate = 1, autoscale = TRUE),  
  seed = 853  
)

#### Save model ####
saveRDS(severity_model, file = "models/collision_model.rds")

#### Output Model Summary ####
print(summary(severity_model))


