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

# Define adjustments for conditions
severity_increase_in_rain <- 1.5  # Increment severity level when it's raining
severity_increase_in_snow <- 2    # More severe increment for snow

# Simulate basic data
sim_traffic_data <- tibble(
  date = sample(seq(from = as.Date("2019-01-01"), to = as.Date("2019-12-31"), by = "day"),
                size = num_observations, replace = TRUE),
  age = sample(18:80, num_observations, replace = TRUE),
  gender = sample(c("Male", "Female"), num_observations, replace = TRUE),
  weather = sample(c("Clear", "Overcast", "Raining", "Snowing", "Freezing Rain", "Foggy", "Windy", "Unknown"), 
                   num_observations, replace = TRUE, prob = c(0.2, 0.2, 0.15, 0.1, 0.05, 0.1, 0.05, 0.15)),
  road_surface = sample(c("Dry", "Wet", "Snowy", "Slushy", "Icy", "Sandy", "Muddy", "Oily", "Flooded", "Unknown"), 
                        num_observations, replace = TRUE, prob = c(0.15, 0.15, 0.1, 0.1, 0.1, 0.1, 0.1, 0.05, 0.05, 0.1)),
  person_position = sample(c("Driver", "Front Seat Passenger", "Rear Seat Passenger", "Unknown"), 
                           num_observations, replace = TRUE, prob = c(0.4, 0.3, 0.2, 0.1)),
  severity = sample(c("Fatal", "Non-Fatal", "Unknown"), num_observations, replace = TRUE, prob = c(0.1, 0.85, 0.05))
)

# Adjust severity based on weather and seat position conditions
sim_traffic_data <- sim_traffic_data |>
  mutate(
    severity = case_when(
      weather == "Raining" & severity != "Unknown" ~ ifelse(runif(n = n()) < 0.15, "Fatal", "Non-Fatal"),
      weather == "Snowing" & severity != "Unknown" ~ ifelse(runif(n = n()) < 0.25, "Fatal", "Non-Fatal"),
      person_position == "Driver" & severity != "Unknown" ~ ifelse(runif(n = n()) < 0.2, "Fatal", "Non-Fatal"),
      TRUE ~ severity
    )
  )

# Display the head of the simulated data
head(sim_traffic_data)

# Save the data to a CSV file
write_csv(sim_traffic_data, "data/simulated_data/simulated_data.csv")


