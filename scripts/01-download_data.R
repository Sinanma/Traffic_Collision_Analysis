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

#### Data download ####
url <- "https://open.canada.ca/data/dataset/1eb9eba7-71d1-4b30-9fb1-30cbdab7e63a/resource/1e2a6aa0-c35f-4736-984a-71f2eac1c1dc/download/2019_dataset_en.csv"
file_path <- "data/raw_data/raw_data.csv"

# Downloading the file
GET(url, write_disk(file_path, overwrite = TRUE))

#### Load and prepare the data ####
collision_data <- read_csv(file_path)

# Clean and prepare the dataset
collision_data_filtered <- collision_data |>
  mutate(
    P_AGE = str_replace_all(P_AGE, "[^0-9]", ""),  
    P_AGE = na_if(P_AGE, ""),                     
    P_AGE = as.numeric(P_AGE), 
    C_MNTH = na_if(C_MNTH, "UU"),                  
    C_MNTH = na_if(C_MNTH, "XX"),  
    month = if_else(is.na(as.numeric(C_MNTH)), 
                    "Unknown", 
                    month(make_date(2019, as.numeric(C_MNTH), 1), 
                          label = TRUE, abbr = FALSE)),  
    day_of_week = if_else(is.na(as.numeric(C_MNTH)), 
                          "Unknown",
                          wday(make_date(2019, as.numeric(C_MNTH), 1), 
                               label = TRUE, abbr = FALSE, week_start = 1)),  
    C_HOUR = na_if(C_HOUR, "UU"),
    C_HOUR = na_if(C_HOUR, "XX"),
    hour = if_else(is.na(as.numeric(C_HOUR)), 
                   "Unknown", 
                   format(make_datetime(2019, as.numeric(C_MNTH), 
                                        1, as.numeric(C_HOUR)), 
                          "%H:%M")),  
    C_WTHR = case_when(
      C_WTHR == "1" ~ "Clear",
      C_WTHR == "2" ~ "Overcast",
      C_WTHR == "3" ~ "Raining",
      C_WTHR == "4" ~ "Snowing",
      C_WTHR == "5" ~ "Freezing rain",
      C_WTHR == "6" ~ "Foggy",
      C_WTHR == "7" ~ "Windy",
      TRUE ~ "Unknown"
    ),
    P_PSN = case_when(
      P_PSN == "11" ~ "Driver",
      P_PSN == "13" ~ "Front Right Passenger",
      P_PSN == "21" ~ "Rear Left Passenger",
      P_PSN == "22" ~ "Rear Center Passenger",
      P_PSN == "23" ~ "Rear Right Passenger",
      TRUE ~ "Other/Unknown"
    ),
    C_RSUR = case_when(
      C_RSUR == "1" ~ "Dry",
      C_RSUR == "2" ~ "Wet",
      C_RSUR == "3" ~ "Snowy",
      C_RSUR == "4" ~ "Slushy",
      C_RSUR == "5" ~ "Icy",
      C_RSUR == "6" ~ "Sandy",
      C_RSUR == "7" ~ "Muddy",
      C_RSUR == "8" ~ "Oily",
      C_RSUR == "9" ~ "Flooded",
      TRUE ~ "Unknown"
    ),
    C_SEV = case_when(
      C_SEV == "1" ~ "Fatal",
      C_SEV == "2" ~ "Non-Fatal",
      TRUE ~ "Unknown"
    )
  ) |>
  filter(!is.na(P_AGE)) |>
  select(month, day_of_week, hour, P_SEX, P_AGE, C_SEV, C_WTHR, C_RSUR, P_PSN)  

#### Save data ####
write_csv(
  x = collision_data_filtered,
  file = "data/raw_data/raw_data.csv"  
)

# Display the head of the filtered data
head(collision_data_filtered)



