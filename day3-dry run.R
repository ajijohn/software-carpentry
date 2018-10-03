
library(tidyverse)
#Challenge
# Q(a) Create a new dataframe from surveys , remove observations with missing(weight,hindfoot_length and sex)
# Q(b)  select only those species for which the count >=50
# Q(c)  Filter only those species from (b) with  criteria from (a), and write it to folder "data_output/surveys_complete.csv"

# we will use the readr pkg which has read_csv to read in the csv file
# read from the surveys
surveys <- read_csv("data/portal_data_joined.csv")
# Q(a) 

surveys_complete <- surveys %>% 
  filter(!is.na(weight) & !is.na(hindfoot_length) & !is.na(sex)  )


#new data frame with only the species_id column and hindfoot_half
#In hindfood_half: No NAs, and all values less than 30

surveys_hf_half <- surveys %>% 
  mutate(hindfoot_half = hindfoot_length/2) %>% 
  filter(hindfoot_half<30  )
  
# Return the columns year, genus, species_id and weight
# groupby , filter and select  
surveys %>%  
  filter(!is.na(weight)) %>%
  group_by(year) %>%
  filter(weight == max(weight)) %>%
  select(year,genus,species_id,weight) %>%
  arrange(weight)

#alternate way
surveys %>%  
  filter(!is.na(weight)) %>%
  group_by(year) %>%
  summarise(species_id = species_id[weight == max(weight)][1])
#reshaping
