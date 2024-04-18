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
cleaned_data <- read_csv("data/Collision_data/analysis_data/analysis_collision_data.csv")

# Define the tests
required_columns <- c("Year", "Gender", "Age", "Severity", "Person_Position")
missing_columns <- setdiff(required_columns, colnames(cleaned_data))
if (length(missing_columns) > 0) {
  stop("Missing required columns: ", paste(missing_columns, collapse=", "))
}

# Test data types
test_that("Data types are correct", {
  expect_type(cleaned_data$Year, "double")
  expect_type(cleaned_data$Gender, "character")
  expect_type(cleaned_data$Age, "double")
  expect_type(cleaned_data$Severity, "character")
  expect_type(cleaned_data$Person_Position, "character")
})

# Test for completeness
test_that("No missing values in key columns", {
  expect_true(all(complete.cases(cleaned_data[required_columns])))
})

# Test for age range
test_that("Age values are within the expected range", {
  expect_true(all(cleaned_data$Age >= 0 & cleaned_data$Age <= 120),
              info = "Ages should be between 0 and 120")
})

# Test for unique values in Gender
test_that("Gender column has only 'Male' and 'Female' values", {
  expect_true(all(cleaned_data$Gender %in% c("Male", "Female")),
              info = "Gender should have only 'Male' and 'Female' values")
})

# Test for unique values in Severity
test_that("Severity column has only 'Fatal' and 'Non-Fatal' values", {
  expect_true(all(cleaned_data$Severity %in% c("Fatal", "Non-Fatal")),
              info = "Severity should have only 'Fatal' and 'Non-Fatal' values")
})

# Test for Person_Position
test_that("Person_Position column has only 'Driver' values", {
  expect_true(all(cleaned_data$Person_Position == "Driver"),
              info = "Person_Position should have only 'Driver' values")
})

# Test for consistency between Age and Gender
test_that("Age and Gender are consistent", {
  expect_true(all((cleaned_data$Gender == "Male" & cleaned_data$Age >= 0 & cleaned_data$Age <= 120) |
                    (cleaned_data$Gender == "Female" & cleaned_data$Age >= 0 & cleaned_data$Age <= 120)),
              info = "Age and Gender should be consistent")
})
