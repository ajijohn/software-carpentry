# Software Carpentry - Day 2 
# bring in data
# survey data 

download.file("https://ndownloader.figshare.com/files/2292169",   "data/portal_data_joined.csv")
surveys <- read.csv('./data/portal_data_joined.csv')

#type of object
str(surveys)
class(surveys)


#2-d tabular storage structure

# same variable type
# same length

surveys

# quick view
# first six rows
head(surveys)
#last six rows
tail(surveys)

#size
dim(surveys)
# number of rows
nrow(surveys)

#no of columns
ncol(surveys)

#content
head(surveys$species)

#names
colnames(surveys)
#row names
rownames(surveys)

#summary
str(surveys)
summary(surveys)

unique(surveys$species_id)


#Challenge

# Q Class of object 'surveys'
class(surveys)
#[1] "data.frame"
# Q How many rows and columns are there 
dim(surveys)
#[1] 34786    13
# Q How many species do you have ? (species_id)
str(surveys$species_id)

# Q how many rows have complete data ? or don't NAs ? (Not required)
# hint - one way to do  use complete.cases
nrow(surveys[complete.cases(surveys),])

#Indexing and 
# row 1 and col 1
surveys[1,1]
# row 1 but all the columns
surveys[1,]

# all rows, first column
surveys[,1]

# ':' is a special function that creates numeric vectors of integers
# in increasing or decreasing order
(1:4)
(4:1)

# give me first 4 rows
surveys[1:4,]
# give me first 4 rows, and give me 4 columns
surveys[1:4,1:4]

#skip the first row,but all columns
head(surveys[-1,])
#skip first six
head(surveys[-c(1:6),])

#accessing it by column names
head(surveys[,"species_id"])

#filtering by conditions
head(surveys[surveys$year==1977 & surveys$sex=="F",])

#accessing variables
#give me number of years of observatiobn
surveys["species_id"]

#Why use brackets
(1:4)

View(surveys)


#Challenge questions
# fetch row 200
surveys[200,]
# fetch the first row
surveys[1,]
# fetch and visually verify with last row
tail(surveys)
surveys[34786,]
# find the middle
surveys[(nrow(surveys)/2),]
# implement your own tail or head statement (Involved - but optional)
#head
surveys[1:6,]

#tail
surveys[((nrow(surveys)-6):nrow(surveys)),]

# Factors
str(surveys)
factors_sample <- surveys$species
str(factors_sample)

#unique list of values
unique(factors_sample)
levels(factors_sample)

#shows the internal ordering
factors_2 <- as.factor(c('female','male','male','female'))
levels(factors_2)
nlevels(factors_2)

factors_2 <- factor(factors_2 ,levels=c('male','female'))
levels(factors_2)
# Assgining values for factors
as.numeric(factors_2)

#plot the distribution by gender
by_gender <- surveys$sex

plot(by_gender)
levels(by_gender)

#Challenge
# Q Rename the levels to "unknown","Female", "Male"
by_gender <- factor(by_gender,labels = c("unknown","Female", "Male"))
plot(by_gender)

by_gender_3 <- factor(by_gender,levels  = c("unknown","Female", "Male"))
plot(by_gender_3)
surveys$sex <- factor(by_gender,levels  = c("unknown","Female", "Male"))

plot(surveys$sex)

# Q Do a plot of the dustribution

#default - read.csv - its loaded with stringsasfactors = TRUE
surveys <- read.csv('./data/portal_data_joined.csv',stringsAsFactors = TRUE)
str(surveys) 

#notice factors are replaced by char
surveys_2 <- read.csv('./data/portal_data_joined.csv',stringsAsFactors = FALSE)
str(surveys_2) 

#creating new data frames
df_test <- data.frame(age= c(45,23,56),firstnames=c("Audrey","Sam","Bob"))
# top 6 rows
head(df_test)

#Challenge
# Create a new dataframe from surveys, include "species_id","sex","weight"
df_new <- data.frame(species_id=surveys$species_id,sex=surveys$sex,weight=surveys$weight)
head(df_new)
# $
library(lubridate)
#parse a string to date
date_ymd <- ymd('2018-08-28')
class(date_ymd)

tmp_date <- paste('2018','08','09',sep = '-')
date_new <- ymd(tmp_date)

date_survey <- ymd(paste(surveys$year,surveys$month,surveys$day, sep='-'))
class(date_survey)
#Add a new variable called 'date'
surveys$date <- date_survey
str(surveys)
