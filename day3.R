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


# look at class of the data

class(surveys)

#It is type 'tbl_df', referred to as "tibble", for purpose of this class
# differences are
# - columns of class character are never converted to factor
# - displays data type of each column under that , and only few rows, as many
# as that can fit on the screen

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

#What if you wanted to do select and filter at the sametime

# three ways
# way 1 - intermediate or two step
# create a temporary dataframe, and then use the next function on that

# in our context, its filter() and then select() 

# so, how should we do it?
surveys2 <- filter(surveys,weight < 5)  
surveys_sml <- select(surveys2,species_id,sex,weight)
# lets check our result
head(surveys_sml)

#next way is to nest it
# so within the select we filter

surveys_sml <- select(filter(surveys,weight < 5),species_id,sex,weight)
head(surveys_sml)

#its great, but don't you think its bit difficult to read, nesting creates
# aversion in my opinion

#but, fear not, we have pipes
# takes the output of one function and sends it to the next
# very useful when douing many things to a same dataset

#pipes look like %>%, part of magrittr pkg but installed with dplyr
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
# include animals collected before 1995 and retain only columns year, sex and weight

surveys_before_1995 <- surveys %>% filter(year <1995) %>% 
  select(year,sex,weight)


#Lets move to Mutate

#often times there is a need 
