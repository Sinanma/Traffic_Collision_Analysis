#### Preamble ####
# Purpose: Calculate accident rate by gender per 1000 driver
# Author: Sinan Ma
# Email: sinan.ma@mail.utoronto.ca
# Date: 18 April 2024
# License: MIT
# Pre-requisites: Cleaned data

#### Workspace setup ####
library(readr)
library(dplyr)

#### Read data ####

demographic_data <- read_csv("data/Demographic_data/analysis_data/analysis_demographic_data.csv")
collision_data <- read_csv("data/Collision_data/analysis_data/analysis_collision_data.csv")


### Calculate Data ###

collision_summary_gender <- collision_data |>
  group_by(Gender) |>
  summarise(accidents = n(), .groups = 'drop')

demographic_summary_gender <- demographic_data |>
  group_by(Gender) |>
  summarise(drivers = n(), .groups = 'drop') 

# Merge datasets on Gender
accident_data_gender <- left_join(collision_summary_gender, demographic_summary_gender, by = "Gender")

# Calculate accident rates per 1000 drivers
accident_data_gender <- accident_data_gender |>
  mutate(accident_rate = (accidents / drivers) * 1000)

write_csv(accident_data_gender, "data/Accident_rate_data/accident_data_gender.csv")
