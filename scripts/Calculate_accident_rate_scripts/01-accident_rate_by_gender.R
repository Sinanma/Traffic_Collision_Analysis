library(readr)
library(dplyr)
library(ggplot2)

# Load the datasets
demographic_data <- read_csv("data/Demographic_data/analysis_data/analysis_demographic_data.csv")
collision_data <- read_csv("data/Collision_data/analysis_data/analysis_collision_data.csv")

# Check data structures
print(head(demographic_data))
print(head(collision_data))

collision_summary_gender <- collision_data %>%
  group_by(Gender) %>%
  summarise(accidents = n(), .groups = 'drop')

demographic_summary_gender <- demographic_data %>%
  group_by(Gender) %>%
  summarise(drivers = n(), .groups = 'drop')  # This assumes each row is a unique driver, adjust as needed

# Merge datasets on Gender
accident_data_gender <- left_join(collision_summary_gender, demographic_summary_gender, by = "Gender")

# Calculate accident rates per 1000 drivers
accident_data_gender <- accident_data_gender %>%
  mutate(accident_rate = (accidents / drivers) * 1000)

write_csv(accident_data_gender, "data/Accident_rate_data/accident_data_gender.csv")
