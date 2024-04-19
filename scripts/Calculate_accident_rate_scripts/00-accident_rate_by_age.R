#### Preamble ####
# Purpose: Calculate accident rate by age per 1000 driver
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

demographic_data <- demographic_data |>
  mutate(age_group = as.factor(Age_Range))

# Create age_group from Age
collision_data <- collision_data |>
  filter(Age >= 16) |>
  mutate(
    age_group = case_when(
      Age >= 16 & Age <= 19 ~ "16-19",
      Age >= 20 & Age <= 24 ~ "20-24",
      Age >= 25 & Age <= 34 ~ "25-34",
      Age >= 35 & Age <= 44 ~ "35-44",
      Age >= 45 & Age <= 54 ~ "45-54",
      Age >= 55 & Age <= 64 ~ "55-64",
      Age >= 65 ~ "65 or older"
    ),
    age_group = as.factor(age_group),
    is_severe = if_else(Severity == "Fatal", TRUE, FALSE)
  )

# Summarize collision data by age_group
collision_summary <- collision_data |>
  group_by(age_group) |>
  summarise(accidents = n(),
            severe_accidents = sum(is_severe),
            .groups = 'drop')


demographic_summary <- demographic_data |>
  group_by(age_group) |>
  summarise(drivers = n(), .groups = 'drop')  

# Merge datasets
accident_rate_age <- left_join(collision_summary, demographic_summary, by = "age_group")

# Calculate accident rates per 1000 drivers
accident_rate_age <- accident_rate_age |>
  mutate(accident_rate = (accidents / drivers) * 1000,
         severe_accident_rate = (severe_accidents / drivers) * 1000
         )
# Display the head of the cleaned data to verify
head(accident_rate_age)

# Save the final dataset to a CSV file
write_csv(accident_rate_age, "data/Accident_rate_data/accident_data_age.csv")
