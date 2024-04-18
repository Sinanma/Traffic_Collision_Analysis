#### Preamble ####
# Purpose: To explore demographic factors affecting driver counts using Bayesian models.
# Author: Sinan Ma
# Email: sinan.ma@mail.utoronto.ca
# Date: 18 April 2024
# GitHub: https://github.com/Sinanma/Traffic_Collision_Analysis.git
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
driver_data <- read_csv("data/Demographic_data/analysis_data/analysis_demographic_data.csv")

# Convert these to factors and create a count for each group
driver_data <- driver_data |>
  mutate(Age_Group = factor(Age_Range),
         Gender = factor(Gender)) |>
  group_by(Age_Group, Gender) |>
  summarise(Count = n(), .groups = 'drop')  

### Model data ####
demographics_model <- stan_glm(
  formula = Count ~ Age_Group + Gender,
  data = driver_data,
  family = poisson(link = "log"), 
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),  
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE), 
  seed = 853  
)

#### Save model ####
saveRDS(demographics_model, file = "models/demographics_model.rds")

#### Output Model Summary ####
print(summary(demographics_model))


