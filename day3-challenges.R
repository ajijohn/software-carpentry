#Day 3 Challenges

#1st

# Using pipes, 
# Q subset the surveys data to include animals collected before 1995 
#    and retain only the columns year, sex, and weight.
# Q subset the surveys data to include female animals collected before 1980 
#    and retain only the columns year, sex, and weight.

#2nd
# Using chaining (filtering and selectiong)
# Q create new dataframe with following criteria, hindfoot_half length less than 30, should not contain NAs
# the output contains new column called hindfoot half and species_id
# select species_id column and the new column
# Q create new dataframe with following criteria, male, hindfoot_half length less than 30, should not contain NAs
# the output contains new column called hindfoot half and species_id
# select species_id column and the new column

#3rd
#Q how many animals were caught in each plot_type
#Q Use group_by and summarise() to find mean, min and max hindfoot length for each species (use species_id)
# also add number of observations for each
#Q which one was the heaviest animal measured for each year(year)? 
# Return the columns year, genus, species_id and weight

#4th
# Q Spread the surveys data frame with year as columns, plot_id as rows, and 
#the number of genera per plot as the values. You will need to summarize before reshaping, and use the 
#function n_distinct() to get the number of unique genera within a particular chunk of data. 
#It’s a powerful function! See ?n_distinct for more.
# Q Now take that data frame and gather() it again, so each row is a unique plot_id by year combination.

