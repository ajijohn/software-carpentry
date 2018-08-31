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
#add transparency to remove overplotting(using alpha)
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

surveys_complete %>% ggplot(aes(species_id,weight)) +
  geom_point(aes(color = plot_type))


# nextup Boxplot - 

# visusalize distribition
# visualize distribution of weight within each species

ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_boxplot()

#what is the center line ?


#overlay points
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_boxplot(alpha = 0) +
  geom_jitter(alpha = 0.3, color = "tomato")

# observe how the box-plot is behind the jitter layer, lets bring it to the front
# we just change the order of layering ()
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
 geom_jitter(alpha = 0.3, color = "tomato") +
  geom_boxplot(alpha = 0) 


#Challenges ( exploring the shape of distributions)
# Q(a) Check shape (use geom_violin() ) - beneficial to see bimodality in distribution
# Q(b) Rescale a variable - to better distribute the observations in the space of the plot, use scale_y_log10()
# Q(c) Check some other variable i.e. explore its distribution, use hindfoot_length . 
#       - Use boxplot to see distribution of hindfoot_length
#       - Overlay it on top of a jitter layer of measurements
#       - color the datapoints with the plot_id (showing from where the observation was taken)

#(a)
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_jitter(alpha = 0.3, color = "tomato") +
  geom_violin(alpha = 0) 


#(b)
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
geom_jitter(alpha = 0.3, color = "tomato") +
  geom_violin(alpha = 0)  + scale_y_log10()
# we add to/modify existing layers
# Now you can see the bimodality

#(c)
#1way
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length)) +
  geom_jitter(alpha = 0.3,  aes(color = plot_id)) +
  geom_boxplot(alpha=0) 


#On the last plot considering the type of the variable(plot_id ), make it char or factor and plot
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length)) +
  geom_jitter(alpha = 0.3,  aes(color = as.factor(plot_id))) +
  geom_boxplot(alpha=0) 

# makes it continous or categorical - assigns distinct colors

# another good important use is to do timeseries plots , look over time how a variable of your interest has
# changed
# number of counts per year of each species

#lets create as new dataframe - and what do you think we should use ?
yearly_counts <- surveys_complete %>%
  count(year, species_id)

#time series can be visualized by line plots(but not appropriate when gaps are there)
head(yearly_counts)

# I can omit 'data', and 'mapping'
ggplot(yearly_counts,aes(x=year,y=n)) + geom_line()

# few issues with the plot, it plotted data for all the species together
# ideally, it is preferred to do a line for each species
ggplot(yearly_counts,aes(x=year,y=n)) + geom_line(aes(group=species_id))
# or you can do 
ggplot(yearly_counts,aes(x=year,y=n,group=species_id)) + geom_line()

#but they are all of same color, so lets make it better to distinguish
ggplot(yearly_counts,aes(x=year,y=n,color=species_id)) + geom_line()


#Presentation of plots
# often look at one plot, and have to do many plots
# ggplot has a technique or feature to support faceting  - split one plit into multiple plots
# based on a factor included in the dataset

# Lst plot we made, we like a timeseries for each species
ggplot(yearly_counts,aes(x=year,y=n)) + geom_line() + facet_wrap(~species_id)
#or
ggplot(yearly_counts,aes(x=year,y=n)) + geom_line() + facet_wrap(c('species_id'))

#Now, lets say, we want to see the line plot by sex

# but our DF does not have sex, lets add it
# what do I use ?
yearly_sex_counts <- surveys_complete %>%
  count(year, species_id,sex)

#now lets try the facetting with lines(indidicating sex of the species) for each year
ggplot(yearly_sex_counts,aes(x=year,y=n,color=sex)) + geom_line() + facet_wrap(~species_id)


#usually the plots with white are more readable , and ready for print or for publishing
ggplot(yearly_sex_counts,aes(x=year,y=n,color=sex)) +
  geom_line() + facet_wrap(~species_id) + theme_bw() + theme(panel.grid = element_blank())
#last option is to remove the grid lines

#good time  to switch to themes, we just touched on it
# theme changes the look of your visualizatiun

#theme_minimal() + theme_classic( ) are popular, and if you want to your iwn styling your theme_void()


#Challenge
#Q(a) Average weight of each species change through out the time( use %>%  or temp DF)

surveys_complete %>% group_by(year,species_id) %>% 
      summarise(mean_weight= mean(weight))  %>%
      ggplot(aes(x=year,y=mean_weight)) + geom_line() + facet_wrap(~species_id)  

# one imp clarification
# facet_wrap determines the rows and cols to best fit
# you can use facet_grid geometry to explicity specify the arrangement
# you can specify via formula notation (rows~columns) 
# '.' signifies only one row or column

# lets modify the previous plot to compare the weights of males and females
# has changed through the time

# ONLY one column, facet by rows
surveys_complete %>% group_by(year,sex, species_id) %>% 
  summarise(mean_weight= mean(weight))  %>%
  ggplot(aes(x=year,y=mean_weight,color=species_id)) + geom_line() +
  facet_grid(sex ~ .)

#one row, facet by column
surveys_complete %>% group_by(year,sex, species_id) %>% 
  summarise(mean_weight= mean(weight))  %>%
  ggplot(aes(x=year,y=mean_weight,color=species_id)) + geom_line() +
  facet_grid(. ~ sex)
# second looks slightly better


#Customization
# you can yse many ways to customize your plot, axis rename, title etc

#we will use the last plot we made 
surveys_complete %>% group_by(year,sex, species_id) %>% 
  summarise(mean_weight= mean(weight))  %>%
  ggplot(aes(x=year,y=mean_weight,color=species_id)) + geom_line() +
  facet_grid(. ~ sex) +
  labs(x="year",y="Mean weight", title="Distribution of weight by species")

# Axes are great but are not readable
surveys_complete %>% group_by(year,sex, species_id) %>% 
  summarise(mean_weight= mean(weight))  %>%
  ggplot(aes(x=year,y=mean_weight,color=species_id)) + geom_line() +
  facet_grid(. ~ sex) +
  labs(x="year",y="Mean weight", title="Distribution of weight by species") +
  theme_bw() +
  theme(text = element_text(size=16))

#If x-axis becomes cluttered, you can change the orientation
surveys_complete %>% group_by(year,sex, species_id) %>% 
  summarise(mean_weight= mean(weight))  %>%
  ggplot(aes(x=year,y=mean_weight,color=species_id)) + geom_line() +
  facet_grid(. ~ sex) +
  labs(x="year",y="Mean weight", title="Distribution of weight by species") +
  theme_bw() +
  theme(axis.text.x = element_text(size=16,angle = 90)) 
# very simple


# But you can also save a theme to be reused (across your plots)

theme_ideal <- theme(axis.text.x = element_text(size=10,color="red", angle = 90),
                     axis.text.y = element_text(size=10,color="blue"),
                     text= element_text(size=16)) 

surveys_complete %>% ggplot(aes(species_id,weight)) + geom_boxplot() + theme_ideal


#Challenge (Take few minutes to experiment with other options)

#last section - arranging and exporting the plots
# if you need single figure with multiple plots

#use gridExtra
install.packages('gridExtra')

library(gridExtra)


species_weight_boxplot <- ggplot(data = surveys_complete, 
                             mapping = aes(x = species_id, y = weight)) +
  geom_boxplot() +
  xlab("Species") + ylab("Weight (g)") +
  scale_y_log10()

species_count_plot <- ggplot(data = yearly_counts, 
                         mapping = aes(x = year, y = n, color = species_id)) +
  geom_line() + 
  xlab("Year") + ylab("Abundance")

grid.arrange(species_weight_boxplot, species_count_plot,ncol=2,widths=c(6,4))

# you can always save by using the Export

# or can use ggsave()

# be sure to have fig_output (recommended)
combined_plot <- grid.arrange(species_weight_boxplot, species_count_plot,ncol=2,widths=c(6,4))

ggsave("fig_output/combinedplot.png",combined_plot ,width = 16, height = 25)


my_plot <- ggplot(data = yearly_sex_counts, 
                  mapping = aes(x = year, y = n, color = sex)) +
  geom_line() 
ggsave("fig_output/simple_lineplot.png",my_plot ,width = 16, height = 25)




