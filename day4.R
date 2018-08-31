#day 4

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

# Q(b)
surveys_complete_species <- surveys %>% count(species_id) %>% filter(n > 50) 
# Q(c) verification
surveys_complete <- surveys_complete  %>% filter(species_id %in% surveys_complete_species$species_id) 

surveys_complete  %>%   filter(species_id %in% surveys_complete_species$species_id   ) %>%
  write_csv(path = "data_output/surveys_complete.csv")
#verify - check that surveys_complete has 30463 rows and 13 columns

#Prepare the data
surveys_complete <- read_csv("data_output/surveys_complete.csv")


#ggplot

#ggplot - complex plots from data in DF 
# likes long format - column for every dimension and row for every observation
# you build step by step
#ggplot(data = <DATA>, mapping = aes(<MAPPINGS>)) +  <GEOM_FUNCTION>()

# <DATA> = df
# <MAPPINGS> = aes(), aesthetics - select the variables to be plotted
#       how to present them - size, shape and color

ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length))


#next we add geometrical representation  using geom_function

#we will cover most common
#geom_point()
#geom_boxplot()
#geom_line()

# we use + to add the geometry

# lers look weight and hind_foot length

# both are contonos so use geom_point
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point()

# if you use %>%, data and mapping optional

# + useful, helps in modifyig
# Assign plot to a variable
surveys_plot <- ggplot(data = surveys_complete, 
                       mapping = aes(x = weight, y = hindfoot_length))

# Draw the plot
surveys_plot + 
  geom_point()

# alter it to a line
# Draw the plot
surveys_plot + 
  geom_line()


#ggplot is plotting by iteratoin
#dataset -> lay the axrs -> chose the geometry
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point()


#start modifiction
#add transparency to remove overplotting
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1)

#add color
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1, color = "blue")

#color by each secies
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1, aes(color = species_id))


#Challenge
#Q Scatter plot of weight(y) over species _id(x), with plot types showing in diff color
#
ggplot(surveys_complete,mapping = aes(y = weight, x = species_id)) +
  geom_point( aes(color = plot_type))

surveys_complete %>% ggplot(aes( species_id,weight)) +
  geom_point(aes(color = plot_type))


# nextup Boxplot

#visusalize distribition
# visualize distribution of weight within each species

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_boxplot()
#what is the center line ?


#overlay points
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_boxplot(alpha = 0) +
  geom_jitter(alpha = 0.3, color = "tomato")


