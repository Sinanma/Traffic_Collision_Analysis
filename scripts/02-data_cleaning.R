#### Preamble ####
# Purpose: Cleans the raw traffic accident data recorded across Canada in 2019, focusing on age and gender dynamics and the severity of outcomes.
# Author: Sinan Ma
# Email: sinan.ma@mail.utoronto.ca
# Date: 18 April 2024
# GitHub: https://github.com/Sinanma/Traffic_Collision_Analysis.git
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
library(tidyverse)
library(janitor)  
library(lubridate)
library(arrow)

# Load the data
raw_data <- read_csv("data/raw_data/raw_data.csv")

#### Clean data ####
cleaned_data <-
  raw_data |> 
  janitor::clean_names() |>  # Standardizes variable names
  mutate(
    age = as.numeric(p_age),  
    gender = case_when(  
      p_sex == "M" ~ "Male",
      p_sex == "F" ~ "Female",
      TRUE ~ NA_character_
    ),
    person_position = factor(p_psn, levels = c("Driver", 
                                               "Front Right Passenger", 
                                               "Rear Left Passenger",
                                               "Rear Center Passenger", 
                                               "Rear Right Passenger", 
                                               "Other/Unknown")
                             ),
    month = factor(month, levels = c("January", 
                                     "February", "March", "April", "May", "June", 
                                     "July", "August", "September", "October", 
                                     "November", "December")),
    day_of_week = factor(day_of_week, levels = c("Monday", "Tuesday", 
                                                 "Wednesday", "Thursday", 
                                                 "Friday", "Saturday", 
                                                 "Sunday"))
  ) |> 
  filter(!is.na(age), !is.na(gender)) |>  # Ensure no NAs in age and gender
  select(
    month, day_of_week, hour, gender, age, severity = c_sev, weather = c_wthr, road_surface = c_rsur, person_position
  ) |> 
  drop_na()  # Drop any rows that still contain NAs


#### Save data ####
write_csv(cleaned_data, "data/analysis_data/analysis_data.csv")
write_parquet(cleaned_data, "data/analysis_data/analysis_data.parquet")

# Display the head of the cleaned data to verify
head(cleaned_data)

