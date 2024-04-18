# Purpose: Simulate a dataset focusing on age and gender dynamics in Canadian Traffic Accidents in 2019.
# Author: Sinan Ma
# Email: sinan.ma@mail.utoronto.ca
# Date: 18 April 2024
# GitHub: https://github.com/Sinanma/Traffic_Collision_Analysis.git
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
library(tidyverse)
library(lubridate)

#### Simulate data ####
set.seed(853)

# Define the number of observations to simulate
num_observations <- 1000

# Create a sequence of dates for the year 2019
dates_2019 <- seq(ymd("2019-01-01"), ymd("2019-12-31"), by = "day")

# Define age groups with probabilities
age_groups <- c("16-19", 
                "20-24", 
                "25-34", 
                "35-44", 
                "45-54", 
                "55-64", 
                "65 or more"
                )
prob_age_groups <- c(0.05, 0.10, 0.20, 0.20, 0.20, 0.15, 0.10)

# Simulate data frame with date, age group, and gender
sim_traffic_data <- tibble(
  date = sample(dates_2019, size = num_observations, replace = TRUE),
  age_group = sample(age_groups, 
                     size = num_observations, 
                     replace = TRUE, 
                     prob = prob_age_groups
                     ),
  gender = sample(c("Male", "Female"), size = num_observations, replace = TRUE)
)

# Display the head of the simulated data
head(sim_traffic_data)

# Save the data to a CSV file
write_csv(sim_traffic_data, "data/Demographic_data/simulated_data/simulated_demographic_data.csv")


