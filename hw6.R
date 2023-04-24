library(tidyverse)
library(dplyr)

data = read_csv("RDS-2016-0005/Data/TS3_raw_tree_data.csv")

## Question 1
## Splitting City and State into different columns  
data[,c("State")] = str_extract(data$City, "\\b[:upper:]+$")
data[,c("City")] = str_extract(data$City, "^[:alpha:]+\\b")
data = data %>% relocate(State, .after=City)

## Grouping and summarizing data to get counts per state
## Creates new table to show the counts
state_counts = group_by(data, State) %>% 
  summarize(count= n())

## Question 2
NCandSC = filter(data, State == "NC"| State == "SC")

NCandSC$City
