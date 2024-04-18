#### Preamble ####
# Purpose: Testing cleaned driver demographics data across Canada in 2019, focusing on year, age ranges, and gender
# Author: Sinan Ma
# Email: sinan.ma@mail.utoronto.ca
# Date: 18 April 2024
# GitHub: https://github.com/Sinanma/Traffic_Collision_Analysis.git
# License: MIT
# Pre-requisites: Need to have cleaned the data

#### Workspace set-up ####
library(testthat)
library(tidyverse)
library(readr)

# Setting the working directory to the project root
setwd("C:/Users/msn01/OneDrive/Desktop/R/Traffic_Collision_Analysis")
file_path <- "data/Demographic_data/analysis_data/analysis_demographic_data.csv"
cleaned_data <- read_csv(file_path)

# Define the tests
required_columns <- c("Year", "Age_Range", "Gender")
missing_columns <- setdiff(required_columns, names(cleaned_data))
if (length(missing_columns) > 0) {
  stop("Missing required columns: ", paste(missing_columns, collapse=", "))
}

# Test data types
test_that("Data types are correct", {
  expect_type(cleaned_data$Year, "double")
  expect_type(cleaned_data$Age_Range, "character")
  expect_type(cleaned_data$Gender, "character")
})

# Test for completeness
test_that("No missing values in key columns", {
  expect_true(all(complete.cases(cleaned_data[required_columns])))
})

# Test for valid age ranges
test_that("Age ranges are valid", {
  valid_age_ranges <- c("under 16", 
                        "16-19", 
                        "20-24", 
                        "25-34", 
                        "35-44", 
                        "45-54", 
                        "55-64", 
                        "65 or older"
                        )
  cleaned_data$Age_Range <- as.character(cleaned_data$Age_Range) 
  invalid_age_ranges <- unique(cleaned_data$Age_Range[!cleaned_data$Age_Range %in% valid_age_ranges])
  
  if (length(invalid_age_ranges) > 0) {
    print("Invalid Age Ranges Found:")
    print(invalid_age_ranges)
  }
  
  expect_equal(length(invalid_age_ranges), 0, 
               info = paste("Invalid age ranges found:", 
                            paste(invalid_age_ranges, collapse = ", ")
                            )
               )
})

# Test for gender values
test_that("Gender values are valid", {
  valid_genders <- c("Male", "Female")
  invalid_genders <- setdiff(cleaned_data$Gender, valid_genders)
  
  if (length(invalid_genders) > 0) {
    print("Invalid Gender Values Found:")
    print(invalid_genders)
  }
  
  expect_equal(length(invalid_genders), 0)
})