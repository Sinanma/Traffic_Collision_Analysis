#### Preamble ####
# Purpose: Cleans the raw traffic accident data recorded across Canada in 2019, focusing on age and gender dynamics and the severity of outcomes.
# Author: Sinan Ma
# Email: sinan.ma@mail.utoronto.ca
# Date: 18 April 2024
# GitHub: https://github.com/Sinanma/Traffic_Collision_Analysis.git
# License: MIT
# Pre-requisites: Need to have raw data

#### Workspace setup ####
library(tidyverse)
library(janitor)  
library(lubridate)
library(arrow)

# Load the data
raw_data <- read_csv("data/Collision_data/raw_data/raw_collision_data.csv")

#### Clean data ####
cleaned_data <-
  raw_data |> 
  janitor::clean_names() |>  
  mutate(
    Age = as.numeric(p_age),  
    Gender = case_when(  
      p_sex == "M" ~ "Male",
      p_sex == "F" ~ "Female",
      TRUE ~ NA_character_
    ),
    Person_Position = factor(p_psn, levels = c("Driver", 
                                               "Front Right Passenger", 
                                               "Rear Left Passenger",
                                               "Rear Center Passenger", 
                                               "Rear Right Passenger", 
                                               "Other/Unknown")
                             )
    
  ) |> 
  filter(!is.na(Age), !is.na(Gender), Person_Position == "Driver") |>  # Ensure no NAs in age and gender
  select(
    Year = c_year, Age, Gender, Severity = c_sev, Person_Position
  ) |> 
  drop_na()  # Drop any rows that still contain NAs


#### Save data ####
write_csv(cleaned_data, "data/Collision_data/analysis_data/analysis_collision_data.csv")
write_parquet(cleaned_data, "data/Collision_data/analysis_data/analysis_collision_data.parquet")

# Display the head of the cleaned data to verify
head(cleaned_data)

