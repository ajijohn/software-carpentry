#purpose of dplyr and tidyr
#convenient pkg to do operations on tabular data


# We will use the umbrella pkg called 'tidyverse' whichinstalls 
# several pkgs for data analysis - tidyr, dplyr, ggplot2 and tibble

# a little about dplyr - eliminates in-memory operations, works with connections
# to data sources

# tidyr - sophisticated way to reshape the data

#lets load the required pkgs

library(tidyverse)

download.file("https://ndownloader.figshare.com/files/2292169",
              "data/portal_data_joined.csv")


# we will use the readr pkg which has read_csv to read in the csv file
# read from the surveys
surveys <- read_csv("data/portal_data_joined.csv")

# lets inspect the data
str(surveys)


#preview the data
View(surveys)


# look at class of the data, not data.frame anymore, but a wrapper on it.

class(surveys)

#It is type 'tbl_df', referred to as "tibble", for purpose of this class
# differences are
# - columns of class character are never converted to factor
# - displays data type of each column under that , and only few rows, as many
# - as that can fit on the screen

#next we will learn

# select() - selecting coumns  - subset columns
# filter() - as the name indicates - subset rows on conditions
# mutate() - create new columns by using informations on the other columns
# group_by() and summarize() - create summary stats on grouped data
# arrange()  - sort results
# count() - count discrete values

#Selecting columns and filtering rows

# To select columns of a dataframe, we use 
# select(name of the dataframe, columns to keep)

# so, to choose plot id, species and weight)
select(surveys,plot_id,species,weight)

# to subset the rows , we use filter
filter(surveys,year==1995)

#segway to pipes

# What if you wanted to do select and filter at the sametime

# three ways
# way 1 - intermediate or two step
# create a temporary dataframe, and then use the next function on that

# in our context, its filter() and then select() 

# so, how should we do it?
surveys2 <- filter(surveys,weight < 5)  
surveys_sml <- select(surveys2,species_id,sex,weight)
# lets check our result
head(surveys_sml)

# next way is to nest it
# so within the select we filter

surveys_sml <- select(filter(surveys,weight < 5),species_id,sex,weight)
head(surveys_sml)

#its great, but don't you think its bit difficult to read, nesting creates
# aversion in my opinion

#but, fear not, we have pipes
# takes the output of one function and sends it to the next
# very useful when douing many things to a same dataset

# pipes look like %>%, part of magrittr pkg but installed with dplyr
# takes the object on the left and sends it to the right, so not necssary
# to include the first parameter

#redoing with pipes
surveys %>% filter(weight <5) %>% select(species_id,sex,weight)

# good way to think of pipe  as then 

#dplyr functions are simple, but joining then gives you command on doing
#complex operations

# to create a subsetted data frame (new object with smaller version of data)
surveys_sml <- surveys %>% filter(weight <5) %>% select(species_id,sex,weight)


#time for challenge
# Q include animals collected before 1995 and retain only columns year, sex and weight

surveys_before_1995 <- surveys %>% filter(year <1995) %>% 
  select(year,sex,weight)

# Q subset the surveys data to include female animals collected before 1980 
#    and retain only the columns year, sex, and weight.

surveys_before_1980_female <- surveys %>% filter(year <1980 & sex == "F") %>% 
  select(year,sex,weight)

#Lets move to Mutate

# often times there is a need to add a new column based on the existing columns
# for eg ratio of two columns or unit conversions

#conversion from lbs to kg
surveys %>% mutate(weight_kg = weight/1000)

# as you might have noticed, it dropped three columns , how do I fix it
# thats right, use select

surveys %>% mutate(weight_kg = weight/1000) %>% select(weight_kg)


# you can create multiple columns within the same call
# for eg create a weight multiplied by 2
surveys %>% mutate(weight_kg = weight/1000,weight_kg_2 = weight * 2)

#as you have seee it again, if you want to get few rows on the top
surveys %>% mutate(weight_kg = weight/1000,weight_kg_2 = weight * 2) %>% head()

# random rows - sample_frac or sample_n
surveys %>% mutate(weight_kg = weight/1000,weight_kg_2 = weight * 2) %>% sample_n(2)

# we saw bunch on NAs, we can use the handy filter

#drop nulls
surveys %>% filter(!is.na(weight)) %>%
  mutate(weight_kg = weight/1000) %>% select(weight_kg) %>% head()


# time for challenge

# create new dataframe with following criteria, hindfoot_half length less than 30, should not contain NAs
# and new column called hindfoot half, selects species_id column and the new column

surveys %>% filter(!is.na(hindfoot_length)) %>%
  mutate(hindfoot_half = hindfoot_length/2) %>% filter(hindfoot_half < 30) %>% 
  select(species_id,hindfoot_half) %>% head()
# Q create new dataframe with following criteria, male, hindfoot_half length less than 30, should not contain NAs
# the output contains new column called hindfoot half and species_id
# select species_id column and the new column

surveys %>% filter(!is.na(hindfoot_length) & sex=="M") %>%
  mutate(hindfoot_half = hindfoot_length/2) %>% filter(hindfoot_half < 30) %>% 
  select(species_id,hindfoot_half) %>% head()

#lets do next, split-apply-combine paradiagm
# this is somewhat a common requirement
# concept is split the data into groups, apply some analysis to each group, 
# and then combine

# dplyr offers a convenient function to do grouping 'group_by'
# group_by takes arguments that are categorical
# summarize() is normally which is sttached next to it

# lets try that
# we will group by sex, and then we will calculate the mean weight for each sex

surveys %>% 
  group_by(sex) %>%
    summarise(mean_weight = mean(weight,na.rm = TRUE))

# you might have noticed I put in the na.rm=TRUE , na usually put in when
# there is a missing value, and when the variable value is missing
# the summary function escapes with 'NA',
# to prevent that default behaviour, we add na.rm=TRUE

# We can also group by muliple columns its grouped in that order
# lets next group by sex, and species id

surveys %>% 
  group_by(sex,species_id) %>%
  summarise(mean_weight = mean(weight,na.rm = TRUE))

# I want to focus your attention on the last few rows
# we have head(), tail()

# if we use tail(), we see NaN for some of the rows
# We see that because we have the weight missing for some of the
# animals, they escaped before the sex could be determined

#we can do filter() to remove it beforehand

surveys %>% 
  filter(!is.na(weight)) %>%
     group_by(sex,species_id) %>%
      summarise(mean_weight = mean(weight))

#notice, I've not used na.rm=TRUE, not required anymore as we are filtering
# na.rm 

#also notice is that the display out put never runs off the screen,
# you can uise the print() function 
surveys %>% 
  filter(!is.na(weight)) %>%
    group_by(sex,species_id) %>%
     summarise(mean_weight = mean(weight)) %>%
      print(5)

# might mention top_n()
# top n rows in a group
# once the data is grouped, we can do summarize odditional
# variables and call other summary functions


# lets add the minimum weight

surveys %>%
  filter(!is.na(weight)) %>%
    group_by(sex,species_id) %>%
      summarise(mean_weight = mean(weight), min_weight = min(weight))

# as an additional todo, add max function

# moving on, sometimes it is necessary
# rearrange the result of the query 

#uses - inspect the values

# foe eg, we want to look into the lighter values

#how should we do it ?

surveys %>%
  filter(!is.na(weight)) %>%
    group_by(sex,species_id) %>%
     summarise(mean_weight = mean(weight), min_weight = min(weight)) %>%
      arrange(min_weight)

# by default - ascending - lower value first
# if you want to do descending - decreasing order of mean_weight

surveys %>%
  filter(!is.na(weight)) %>%
    group_by(sex,species_id) %>%
      summarise(mean_weight = mean(weight), min_weight = min(weight)) %>%
        arrange(desc(mean_weight))

# moving on
# Sometimes, when working with data, we need to know how many observations found for a factor or
# a group of factors. dplyr provides a convenient function called count()

# for eg, number of rows by sex

surveys %>%
   count(sex)

# By two factors
surveys %>%
  count(plot_id,sex)

# basically what it did was did group by and applied a summary function

# i.e
surveys %>%
  group_by(sex) %>%
   summarise(count=n())

# with count(), it provides a sort argument
# default is high to low (ascending)
surveys %>%
   count(sex,sort = TRUE )

# if we want to count combination of factors, we could pass the additional one along
# for eg lets want to add species

surveys %>%
   count(sex,species)

# we can next arrange by a number of criteria
# for eg, alphabetic by species, but descending with number of them
surveys %>%
   count(sex,species) %>%
     arrange(species,desc(n))

# we notice 75 of 'albigula' have sex which is not determined.


# time for challenge

#1 how many animals were caught in each plot_type
surveys %>% count(plot_type)

#2 use group_by and summarise() to find mean, minand max hindfoot length for each species (use species_id)
# also add number of observations for each
surveys %>% filter(!is.na(hindfoot_length)) %>%
  group_by(species_id) %>% 
  summarise(min_hfl=min(hindfoot_length),max_hfl=max(hindfoot_length),mean_hfl=mean(hindfoot_length),noofob= n())
     

#3 what was the heaviest animal measured for each year(year)? Return the columns year, genus, species_id and weight
surveys %>% filter(!is.na(weight)) %>%
  group_by(year) %>%
    filter(weight == max(weight)) %>%
     select(year,genus,species_id,weight) %>%
      arrange(weight)
  

#surveys %>% filter(!is.na(weight)) %>% group_by(year) %>% top_n(1,weight) %>%
#  select(year,genus,species_id,weight)

#Next we will cover reshaping your data
# rows become columns - spread
# colums become rows - gather

# compare mean weights of species between plots ?

#spread() takes three main args - (data, key column -> new column, value column -> fill the new column)

# we will use spread to transform, but lets first create the summary by species and plot

surveys_gw <- surveys %>% filter(!is.na(weight)) %>%
              group_by(genus,plot_id) %>%
              summarise(mean_weight = mean(weight))


# we then use pipes to do spread

surveys_spread <- surveys_gw %>% spread(key=genus,value = mean_weight)
str(surveys_spread)

#to remove NAs use fill
surveys_spread <- surveys_gw %>% spread(key=genus,value = mean_weight,fill=0)


#Gathering is opposite of spread

# four main args

# gather(data,key column-> from column names, column variables to create and fill, names of the columns to fill)

# to recreate surveys_gw from survey_spread

surveys_gather <- gather(surveys_spread,key = genus,value=mean_weight,-plot_id)

# Use : to include if in a row
surveys_gather <- gather(surveys_spread,key = genus,value=mean_weight,Baiomys:Spermophilus)

# Q Spread the surveys data frame with year as columns, plot_id as rows, and 
#the number of genera per plot as the values. You will need to summarize before reshaping, and use the 
#function n_distinct() to get the number of unique genera within a particular chunk of data. 
#It’s a powerful function! See ?n_distinct for more.

rich_time <- surveys %>%
  group_by(plot_id, year) %>%
  summarize(n_genera = n_distinct(genus)) %>%   spread(year, n_genera)

  
# Q Now take that data frame and gather() it again, so each row is a unique plot_id by year combination.

rich_time %>%
  gather(year, n_genera, -plot_id)

# Talk about exporting
