#### Preamble ####
# Purpose: Downloads and saves the 2019 National Collision Database data from Open Canada
# Author: Sinan Ma
# Email: sinan.ma@mail.utoronto.ca
# Date: 18 April 2024
# GitHub: https://github.com/Sinanma/Traffic_Collision_Analysis.git
# License: MIT
# Pre-requisites: None

#### Workspace setup ####
library(httr)
library(readr)
library(dplyr)
library(lubridate)

Sys.setlocale("LC_TIME", "C")

#### Data download ####
url <- "https://open.canada.ca/data/dataset/1eb9eba7-71d1-4b30-9fb1-30cbdab7e63a/resource/1e2a6aa0-c35f-4736-984a-71f2eac1c1dc/download/2019_dataset_en.csv"
file_path <- "data/Collision_data/raw_data/raw_collision_data.csv"

# Downloading the file
GET(url, write_disk(file_path, overwrite = TRUE))

#### Load and prepare the data ####
collision_data <- read_csv(file_path)

# Clean and prepare the dataset
collision_data_filtered <- collision_data |>
  mutate(
    C_YEAR = as.numeric(C_YEAR),
    P_AGE = str_replace_all(P_AGE, "[^0-9]", ""),  
    P_AGE = na_if(P_AGE, ""),                     
    P_AGE = as.numeric(P_AGE), 
    P_PSN = case_when(
      P_PSN == "11" ~ "Driver",
      P_PSN == "13" ~ "Front Right Passenger",
      P_PSN == "21" ~ "Rear Left Passenger",
      P_PSN == "22" ~ "Rear Center Passenger",
      P_PSN == "23" ~ "Rear Right Passenger",
      TRUE ~ "Other/Unknown"
    ),
    C_SEV = case_when(
      C_SEV == "1" ~ "Fatal",
      C_SEV == "2" ~ "Non-Fatal",
      TRUE ~ "Unknown"
    )
  ) |>
  filter(!is.na(P_AGE)) |>
  select(C_YEAR, P_SEX, P_AGE, C_SEV, P_PSN)  

#### Save data ####
write_csv(
  x = collision_data_filtered,
  file = "data/Collision_data/raw_data/raw_collision_data.csv"  
)

# Display the head of the filtered data
head(collision_data_filtered)



