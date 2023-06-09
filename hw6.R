library(tidyverse)
library(dplyr)
library(ggplot2)

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
## Filtering data only for observations in NC and SC
NCandSC = filter(data, State == "NC"| State == "SC")
## Viewing the cities in these states
NCandSC$City

## Question 3
## Making a separate column for genus extracted from Scientific Name
NCandSC[,c("Genus")] = str_extract(NCandSC$ScientificName, "^[:alpha:]+\\b")

## Updating NCandSC to be sorted by AvgCdia (m) in descending order
NCandSC = arrange(NCandSC, desc(`AvgCdia (m)`))

## Grouping and summarizing to find average crown size per genus
avg_crown = group_by(NCandSC, Genus) %>% 
  summarize(MeanCrownSize = mean(`AvgCdia (m)`))
## Arranging in descending order
avg_crown = arrange(avg_crown, desc(MeanCrownSize))

## Extra Credit Question 1
avg_age = group_by(NCandSC, Genus) %>% 
  summarize(MeanAge = mean(Age))
avg_age = arrange(avg_age, desc(MeanAge))

## Extra Credit Question 2
## Merging the two columns above
merged = merge(avg_age, avg_crown, by="Genus")
## Adding a column for rate of growth and arranging in descending order
merged[,c("RateofGrowth")] = merged$MeanCrownSize / merged$MeanAge
merged = arrange(merged, desc(RateofGrowth))

## Extra Credit Question 3
NCandSC[,c("Species")] = str_extract(NCandSC$ScientificName, "\\b[:lower:]+($|\\b)")

## Using group by to make a table of counts of distinct species per Genus
species_per_genus = group_by(NCandSC, Genus) %>%
  summarize(SpeciesCount=n_distinct(Species))
