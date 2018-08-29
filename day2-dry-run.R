# download the survey data
download.file("https://ndownloader.figshare.com/files/2292169",   "data/portal_data_joined.csv")

# load the data - dplyr
surveys <- read_csv('data/portal_data_joined.csv')
surveys <- read.csv('data/portal_data_joined.csv')

# 
#data frame - a structure to hold r=tabular data , rows by columns
# columns as vectors
# Vectors - Same type , Same length  

# type of variable 'surveys' is ?

class(surveys)
str(surveys)

# inspecting our data frame
head(surveys)
tail(surveys)

# size aspect of dataframes
dim(surveys)
# rows first, and then columns

#no of rows
nrow(surveys)

#no of columns
ncol(surveys)


# Content
#use head() or tail()

# Names 
colnames(surveys)
rownames(surveys)

#Summary
str(surveys)
summary(surveys)

# generic functions, they can be used for most ttypes of objects

#chsallenge 
# Q what is the class of object ;surveys'
# Q How many rows and columns - 
# Q how many species have been recorded n- 48
# Q how many rows have complete data ? or don't NAs ? (Not required)


#indexing and subsetting data frames
# are two dimensional

#row 1, column 4 (year)
surveys[1,4]

#row 2,column 3 (day)
surveys[2,3]

#all rows
surveys[,2]

# wrap it in head()
head(surveys[,2])

# all columns
surveys[1,]

#':' is a special function which creates numeric vectors of integers
surveys[1:3,]
surveys[3:1,]

#skip certain rows or columns
head(surveys[-1,])
#skip first column
head(surveys[,-1])

head(surveys[-c(1:4),])
surveys[-c(7:nrow(surveys)),]

str(surveys['species_id']$species_id)

#challenge

# fetch row 200
# fetch the last row
# verify with last row
# find the middle
# implement your own tail statement (Involved - but optional)


#Factors

# One of the class 
# Factors are cstegorial variasbles, and R stores them internasly as numeric values but
# have labels assoviated with it
# thet can be ordered or unordered, by defauklt they are sorted alphabetically

class(surveys$sex)
levels(surveys$sex)
as.numeric(surveys$sex)


#reordering
sex <- factor(c("male","female","female","male"))
#levels to see the ordering
levels(sex)
sex

sex <- factor(c("male","female","female","male"))
sex <- factor(sex,levels = c("male","female"))
sex
#very often you may require the factor of numeric values of a factor, like year
#is.numeric gives index so, not right

#Modifying  or renaming factors

levels(surveys$sex)

#get a copy

sex <- surveys$sex

levels(sex)[1] <- "undetermined"
levels(sex)

plot(sex)


#Challenge

# Q rename "F" to female, "M" male respectively
# Q recreate bar plot
# Q use nrow and subsetting to find number of M/F and undetermined (Involved)
    

#Next we are going to do StringsAsFactors=FALSE
#by default it is true

#load surveys with both options
# convert plot type
# creating your own data frame
my_df <- data.frame(
  names = c('Audrey',"Matt","Selva"),
  Age = c(24,23,21)
  
)
#Challenge
#Q Whats wrong with this dataframe
#Q Predict the class of Country Climate DF
#Q Change the StringsAsFactors and now assess
#Q how would you fix it so that you have right data type
#Q Create your own dataframe(with stringsasFactors = FALSE) - it should contain 'taxa' ,'species' and 'weight'
# Loading strings


#dates

#install dplyr
#install.packages('dplyr')

#lubridate is part of dy but not loaded by defaukt
library(lubridate)

ymd("2015-01-09")

class(ymd("2015-01-09"))
str(ymd("2015-01-09"))

my_date<- ymd(paste(surveys$year,surveys$month,surveys$day,sep = '-'))

#assign a new column
surveys$date <- my_date
summary(surveys)

#Q how do you find missing data rows
missing_dates <- surveys[is.na(surveys$date),]
nrow(missing_dates)

head(missing_dates[,c('year','month','day')])

#HW
#Qa Count number of species by year
#Qb Count number of species by plot 

# Plot a and b