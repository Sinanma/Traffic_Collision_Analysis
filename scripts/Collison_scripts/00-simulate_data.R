#### Preamble ####
# Purpose: Simulate a dataset focusing on age and gender dynamics in Canadian Traffic Accidents in 2019.
# Author: Sinan Ma
# Email: sinan.ma@mail.utoronto.ca
# Date: 18 April 2024
# GitHub: https://github.com/Sinanma/Traffic_Collision_Analysis.git
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
set.seed(853)

# Define the number of observations to simulate
num_observations <- 1000

# Simulate basic data
sim_traffic_data <- tibble(
  year = rep(2019, num_observations),
  age = sample(18:80, num_observations, replace = TRUE),
  gender = sample(c("Male", "Female"), num_observations, replace = TRUE),
  severity = sample(c("Fatal", "Non-Fatal", "Unknown"), 
                    num_observations, 
                    replace = TRUE, 
                    prob = c(0.1, 0.85, 0.05)),
  person_position = sample(c("Driver", 
                             "Front Seat Passenger", 
                             "Rear Seat Passenger", 
                             "Unknown"), 
                           num_observations, 
                           replace = TRUE, 
                           prob = c(0.4, 0.3, 0.2, 0.1)
                           )
)

# Display the head of the simulated data
head(sim_traffic_data)

# Save the data to a CSV file
write_csv(sim_traffic_data, "data/Collision_data/simulated_data/simulated_collision_data.csv")
