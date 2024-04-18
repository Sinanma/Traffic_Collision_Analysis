# Purpose: Downloads and saves data from Open Canada concerning driver demographics
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
url <- "https://dq-prd-bucket1.s3.ca-central-1.amazonaws.com/saaq/Permis_Conduire_2019.csv"
file_path <- "data/Demographic_data/raw_data/raw_demographic_data.csv"

# Downloading the file
GET(url, write_disk(file_path, overwrite = TRUE))

# Load the dataset
driver_data <- read_csv(file_path, col_types = cols(
  AN = col_double(),
  AGE_1ER_JUIN = col_character(),  
  SEXE = col_character(),
  .default = col_skip()  
  ))
  
# Filter data to keep only the required columns
filtered_data <- driver_data |>
  select(AN, AGE_1ER_JUIN, SEXE)

#### Save data ####
write_csv(
  x = driver_data,
  file = "data/Demographic_data/raw_data/raw_demographic_data.csv"  
)

# Display the head of the filtered data
head(driver_data)



