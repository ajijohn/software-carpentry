# We will be using the R script

#use command-enter(return) to run the line(keyboard shortcut)
getwd()

#keyboard shortcut

# carat - shortcut
# press escape to leave the open +
# stackoverflow -

# how do you assign
a= 5
b <- 5
c <- 5

( weight_kg <- 6)

(2.2 * weight_kg)


#functions in R
# describe built-in functions

#difference between vectors and lists

#vector must contain the same type

animals <- c('mouse', 'rat',"dog")
animals_list <- list(1,'mouse', 'rat',"dog")

#length of list and vectors
length(animals)
length(animals_list)


#subsetting the vectors, talk about -1, -2
#

# why is it forcing to number ?
# vectors to a single datatype
num_logical <- c(1,2,3,TRUE)
char_logical <-  c('1','2','3',TRUE)


combined_logical <- c(num_logical, char_logical)


#subsetting by indices


# subset by filtering
weight_kg <- c(87,66,23,55,99,199)
#subsetting by conditions
# returns the logical vectors
weight_kg[weight_kg < 60]


# or and and operators
weight_kg[weight_kg < 60 | weight_kg <90]
#[1] 87 66 23 55

#order is umportant
weight_kg[(weight_kg < 60 & weight_kg <90)]
# [1] 23 55

weight_kg[(weight_kg < 90 & weight_kg <60)]

#animals in 
animals[animals %in% c('rat','dog')]
animals[!(animals  %in% c('rat','dog'))]
#handling NAs
# reprcussions of NAs

heights <- c(63, 69, 60, 65, NA, 68, 61, 70, 61, 59, 64, 69, 63, 63, NA, 72, 65, 64, 70, 63, 65)

median(heights,na.rm=TRUE)
#with NAs
length(heights[heights >65])

#without