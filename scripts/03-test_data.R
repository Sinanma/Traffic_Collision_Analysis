#### Preamble ####
# Purpose: Testing cleaned traffic accident data from Canada 2019 focusing on age, gender, and accident severity
# Author: Sinan Ma
# Email: sinan.ma@mail.utoronto.ca
# Date: 18 April 2024
# GitHub: https://github.com/Sinanma/Traffic_Collision_Analysis.git
# License: MIT
# Pre-requisites: Need to have cleaned the data

#### Workspace set-up ####
library(testthat)
library(tidyverse)
library(janitor)

# Setting the working directory to the project root
setwd("C:/Users/msn01/OneDrive/Desktop/R/Traffic_Collision_Analysis")
file_path <- "data/analysis_data/analysis_data.csv"
cleaned_data <- read_csv(file_path)


cleaned_data <- read_csv("data/analysis_data/analysis_data.csv")

# Define the tests
required_columns <- c("month", "day_of_week", "hour", "gender", "age", "severity", "weather", "road_surface")
missing_columns <- setdiff(required_columns, colnames(cleaned_data))
if (length(missing_columns) > 0) {
  stop("Missing required columns: ", paste(missing_columns, collapse=", "))
}

# Test data types
test_that("Data types are correct", {
  expect_type(cleaned_data$month, "character")
  expect_type(cleaned_data$day_of_week, "character")
  expect_type(cleaned_data$hour, "character")
  expect_type(cleaned_data$gender, "character")
  expect_type(cleaned_data$age, "double")
  expect_type(cleaned_data$severity, "character")
  expect_type(cleaned_data$weather, "character")
  expect_type(cleaned_data$road_surface, "character")
})

# Test for completeness
test_that("No missing values in key columns", {
  expect_true(all(complete.cases(cleaned_data[required_columns])))
})

# Test for age range
test_that("Age values are within the expected range", {
  expect_true(all(cleaned_data$age >= 0 & cleaned_data$age <= 120),
              info = "Ages should be between 0 and 120")
})

# Test for day of week format
test_that("Day of the week is correctly formatted", {
  expected_days <- c("Monday", "Tuesday", "Wednesday", "Thursday", 
                     "Friday", "Saturday", "Sunday")
  actual_days <- unique(cleaned_data$day_of_week)
  
  if (!setequal(actual_days, expected_days)) {
    print("Unexpected Days of the Week Found:")
    print(actual_days)
  }
  
  expect_setequal(actual_days, expected_days)
})

