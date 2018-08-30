#Day 3 actual

library(tidyverse)

surveys <- read_csv('data/portal_data_joined.csv')

# tbl-df - tibble data frame
class(surveys)
surveys
# observe the didsplay

# select
select(surveys,month,year) 

# filter
filter(surveys,month==7)
#surveys[surveys$month==7,] old way

# select and filter at the same time
# way 1

sub_select_columns <- select(surveys,month,year,species_id)
sub_select_columns

# filtered result for month 7 with 3 columns
sub_select_columns_7 <- filter(sub_select_columns,month==7)

# Using of %>% 

surveys %>% filter(month==7) %>% select(month,year,species_id)

# Using pipes, 
# Q subset the surveys data to include animals collected before 1995 
#    and retain only the columns year, sex, and weight.
surveys %>% filter(year < 1995) %>% select(year,sex,weight) %>% head()
  
# Q subset the surveys data to include female animals collected before 1980 
#    and retain only the columns year, sex, and weight.
# | or
# & and 
surveys %>% filter(year < 1980 & sex=='F' ) %>% select(year,sex,weight) %>% head()


# Mutate - add new columns

# weight in kg 
surveys %>% 
  mutate(weight_kg  = weight/1000)%>% 
  select(weight,weight_kg) %>% head()

# add another column - weight * 2
surveys %>% mutate(weight_kg  = weight/1000,weight_by2 = weight*2) %>% 
  select(weight,weight_kg,weight_by2) %>% head()

# skip NAs
surveys %>% filter(!is.na(weight)) %>% select(weight)

# remove NAs and do the weight conversion
surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg  = weight/1000) %>% 
  select(weight,weight_kg) %>%
  head()

# only observations with real weights

notNA_surveys <- surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg  = weight/1000) 

# Challenge questions

#2nd
# Using chaining (filtering and selection)
# & - and 
# Q create new dataframe with following criteria, 
# hindfoot_half length less than 30, should not contain NAs
# the output contains new column called 'hindfoot_half' and species_id
# select species_id column and the new column 'hindfoot_half'
surveys %>% filter(!is.na(hindfoot_length)) %>%
   mutate(hindfoot_half = hindfoot_length/2) %>%
   filter(hindfoot_half < 30) %>%
   select(species_id,hindfoot_half) %>%
   head()

# Q create new dataframe with following criteria, male, 
# hindfoot_half length less than 30, should not contain NAs
# the output contains new column called 'hindfoot_half' and species_id
# select species_id column and the new column 'hindfoot_half'

surveys %>% filter(!is.na(hindfoot_length)) %>%
  mutate(hindfoot_half = hindfoot_length/2) %>%
  filter(hindfoot_half < 30 & sex=="M") %>%
  select(species_id,hindfoot_half) %>%
  head()


# split-combine

surveys %>% 
  group_by(species_id,sex) %>% 
  summarise(min_weight = min(weight))

# take out NAs
surveys %>% 
  filter(!is.na(weight)) %>%
  group_by(species_id,sex) %>% 
  summarise(min_weight = min(weight))
# additional summary columns
surveys %>% 
  filter(!is.na(weight)) %>%
  group_by(species_id,sex) %>% 
  summarise(min_weight = min(weight),max_weight = max(weight),mean_weight= mean(weight)) %>%
  select(species_id,min_weight,max_weight,mean_weight)

#use the na.rm , to do the same with summary operations
surveys %>% 
  group_by(species_id,sex,weight) %>% 
  summarise(min_weight = min(weight,na.rm = TRUE))
# todo - get back to na.rm parameter

# arrange - sort 
surveys %>% 
  filter(!is.na(weight)) %>%
  group_by(species_id,sex) %>% 
  summarise(min_weight = min(weight)) %>%
  arrange(min_weight)

# descending

surveys %>% 
  filter(!is.na(weight)) %>%
  group_by(species_id,sex) %>% 
  summarise(min_weight = min(weight)) %>%
  arrange(desc(min_weight))

# Sampling rows and counting based on factors(keys)
surveys %>% 
  filter(!is.na(weight)) %>%
  group_by(species_id,sex) %>% 
  summarise(min_weight = min(weight)) %>% print(5)

# sample n rows
surveys %>% 
  filter(!is.na(weight)) %>% sample_n(10)
# fraction
surveys %>% 
  filter(!is.na(weight)) %>% sample_frac(.25)

# observations by gender
surveys %>% count(sex)

# by plot
surveys %>% count(plot_id,sex)

# by plot, by species
surveys %>% count(plot_id,species_id,sex,sort = TRUE)

# arrange
surveys %>% 
   count(plot_id,species_id,sex) %>% 
       arrange(species_id,desc(n))

surveys %>% count(plot_id,sex) %>% arrange(plot_id,desc(n))
#3rd Challenge
#Q how many animals were caught in each plot_type
# count

surveys %>% count(plot_type)
  
#Q Use group_by and summarise() to find mean, min and max
# hindfoot length for each species (use species_id)
# also add number of observations for each (noob = n())
# group_by filter and summarise

surveys%>% filter(!is.na(hindfoot_length)) %>%
     group_by(species_id) %>% 
     summarise(noofob=n(),mean_length= mean(hindfoot_length),min_length= min(hindfoot_length),max_length= max(hindfoot_length))
  
# Q which one was the heaviest animal measured for each year(year)? 
# Return the columns year, genus, species_id and weight
# groupby , filter and select  
surveys %>%  
  filter(!is.na(weight)) %>%
  group_by(year) %>%
  filter(weight == max(weight)) %>%
  select(year,genus,species_id,weight) %>%
  arrange(weight)
  

#how do I get more columns
surveys%>% filter(!is.na(hindfoot_length)) %>%
  group_by(species_id,sex) %>% 
  summarise(noofob=n(),max_length= max(hindfoot_length))

# spread and gather

# Compare mean weights of species between plots

# spread()
# three main args
# (data, key_column -> new_column,value_column -> fill the new column)

surveys_summary <- surveys %>%
         filter(!is.na(weight)) %>%
         group_by(genus,plot_id) %>%
         summarise( mean_weight = mean(weight))

#spread
survey_spread <- surveys_summary %>% 
  spread(key = genus,value = mean_weight)
#fill the NAs with 0
survey_spread <- surveys_summary %>%
  spread(key = genus,value = mean_weight,fill=0)

#
survey_spread
#gather

# 3 args are
# gather(data,key column -> from column namesand fill, value = correspomding to key
#names of the column to fill)
surveys_gather <- gather(survey_spread,key=genus,value = mean_weight, -plot_id)

surveys_gather <- gather(survey_spread,key=genus,value = mean_weight, Baiomys:Spermophilus)

#Closing - saving your analysis

surveys%>% filter(!is.na(hindfoot_length)) %>%
  group_by(species_id,sex) %>% 
  summarise(noofob=n(),max_length= max(hindfoot_length)) %>%
  write_csv('data/summary_by_species.csv')

# save your species weight analysis
write_csv(survey_spread,'data/spread_by_species.csv')

# read in survey spread you just created
survey_spread_n <- read_csv('data/spread_by_species.csv')
