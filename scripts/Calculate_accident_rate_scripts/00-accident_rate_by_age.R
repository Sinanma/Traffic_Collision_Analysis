library(readr)
library(dplyr)

# Load the demographic data
demographic_data <- read_csv("data/Demographic_data/analysis_data/analysis_demographic_data.csv")

# Load the collision data
collision_data <- read_csv("data/Collision_data/analysis_data/analysis_collision_data.csv")

# Convert Age_Range in demographic data to a factor (if not already)
demographic_data <- demographic_data %>%
  mutate(age_group = as.factor(Age_Range))

# Prepare collision data: Create age_group from Age
collision_data <- collision_data %>%
  filter(Age >= 16) %>%
  mutate(
    age_group = case_when(
      Age >= 16 & Age <= 19 ~ "16-19",
      Age >= 20 & Age <= 24 ~ "20-24",
      Age >= 25 & Age <= 34 ~ "25-34",
      Age >= 35 & Age <= 44 ~ "35-44",
      Age >= 45 & Age <= 54 ~ "45-54",
      Age >= 55 & Age <= 64 ~ "55-64",
      Age >= 65 ~ "65 or older"
    ),
    age_group = as.factor(age_group)
  )

# Summarize collision data by age_group
collision_summary <- collision_data %>%
  group_by(age_group) %>%
  summarise(accidents = n(), .groups = 'drop')

# Assuming demographic_data has a column 'Total_Drivers' to represent the number of drivers in each age group
# If not, you will need to add this based on external data or an estimation
demographic_summary <- demographic_data %>%
  group_by(age_group) %>%
  summarise(drivers = n(), .groups = 'drop')  # This is just an example and may not be correct

# Merge datasets
accident_rate_age <- left_join(collision_summary, demographic_summary, by = "age_group")

# Calculate accident rates per 1000 drivers
accident_rate_age <- accident_rate_age %>%
  mutate(accident_rate = (accidents / drivers) * 1000)

# Save the final dataset to a CSV file
write_csv(accident_rate_age, "data/Accident_rate_data/accident_data_age.csv")
