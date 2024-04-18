#### Preamble ####
# Purpose: Cleans the raw driver demographics data, focusing on year, age ranges, and gender.
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
raw_data <- read_csv("data/Demographic_data/raw_data/raw_demographic_data.csv")

#### Clean data ####
cleaned_data <-
  raw_data |>
  janitor::clean_names() |>  
  rename(
    Year = an,
    Age_Range = age_1er_juin,
    Gender = sexe
  ) |> 
  mutate(
    Gender = case_when(
      Gender == "M" ~ "Male",
      Gender == "F" ~ "Female",
      TRUE ~ NA_character_
    ),
    Age_Range = case_when(
      Age_Range == "65 ans ou plus" ~ "65 or older",
      Age_Range == "Moins de 16 ans" ~ "under 16",
      TRUE ~ Age_Range
    )
  ) |> 
  filter(!is.na(Age_Range), !is.na(Gender))


#### Save data ####
write_csv(cleaned_data, "data/Demographic_data/analysis_data/analysis_demographic_data.csv")
write_parquet(cleaned_data, "data/Demographic_data/analysis_data/analysis_demographic_data.parquet")

# Display the head of the cleaned data to verify
head(cleaned_data)

