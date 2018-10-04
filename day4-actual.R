#day 4 actual

#check your folders
# data_output
# figure_output
library(tidyverse)

surveys <- read_csv('data/portal_data_joined.csv')
#Warm-up
# Q(a) Create a new dataframe from surveys , 
#  remove observations with missing(weight,hindfoot_length and sex)

surveys_complete <- surveys %>% 
  filter(!is.na(weight) &  !is.na(hindfoot_length) & !is.na(sex))

# verify the count (a)
surveys %>% 
  filter(!is.na(weight) &  !is.na(hindfoot_length) & !is.na(sex)) %>% dim()

# Q(b) Create a new dataframe -  select only those species 
# for which the count >=50

survey_species_50 <- surveys %>% 
  count(species_id) %>% 
  filter( n >= 50)

# Q(c)  Filter only those species from (b) with  criteria from (a), 
# and write it to folder "data_output/surveys_complete.csv"

surveys_complete <- surveys_complete %>% 
  filter(species_id  %in% survey_species_50$species_id) 

# verify that the row count is 30463 and column count is 13

write_csv(surveys_complete,"data_output/surveys_complete.csv")

ggplot(data=surveys_complete , mapping = aes(x=weight,y=hindfoot_length)) + 
  geom_line()

# point plot
ggplot(data=surveys_complete , mapping = aes(x=weight,y=hindfoot_length)) + 
  geom_point()
# using pipe%>%
surveys_complete %>% ggplot(aes(x=weight,y=hindfoot_length)) + geom_point()
#changing the transparency
surveys_complete %>% ggplot(aes(x=weight,y=hindfoot_length)) +
  geom_point(alpha=0.1)
# color my plots
surveys_complete %>% ggplot(aes(x=weight,y=hindfoot_length)) +
  geom_point(alpha=0.1,color="blue")

# coloring by species
surveys_complete %>% ggplot(aes(x=weight,y=hindfoot_length)) +
  geom_point(alpha=0.1,aes(color=species_id))
#glo
surveys_complete %>% ggplot(aes(x=weight,y=hindfoot_length,color=species_id)) +
  geom_point(alpha=0.1)

# challenge

#2
#Challenge
#Q Scatter plot of weight(y-axis) over species _id(x-axis),
# with plot types(from the dataframe) showing in diff color
# 
# plot_type of the dataframe surveys_complete$plot_type
surveys_complete %>% ggplot(aes(x=species_id,y=weight,color=plot_type)) +
   geom_point(alpha=0.1)

#Please fill the post-session survey
#https://www.surveymonkey.com/r/swc_post_workshop_v1?workshop_id=2018-08-28-UW
#Visualizing distributions 

#  Box plot
surveys_complete %>% ggplot(aes(x=species_id,y=weight,color=plot_type)) +
  geom_boxplot()

#  Box plot with no color
surveys_complete %>% ggplot(aes(x=species_id,y=weight)) +
  geom_boxplot() 
  
# jitter
surveys_complete %>% ggplot(aes(x=species_id,y=weight)) +
  geom_boxplot(alpha=0) + geom_jitter(alpha=0.2, color="tomato")  

#change the order
surveys_complete %>% ggplot(aes(x=species_id,y=weight)) +
  geom_jitter(alpha=0.2, color="tomato") +
  geom_boxplot(alpha=0)

# violin plots(multimodal distributions)
surveys_complete %>% ggplot(aes(x=species_id,y=weight)) +
  geom_jitter(alpha=0.2, color="tomato") +
  geom_violin()

# scaling x or y axis
surveys_complete %>% ggplot(aes(x=species_id,y=weight)) +
  geom_jitter(alpha=0.2, color="tomato") +
  geom_violin() + scale_y_log10()

# color the point plot by plot_id
surveys_complete %>% ggplot(aes(x=species_id,y=weight)) +
  geom_jitter(alpha=0.2, aes(color=plot_id)) +
  geom_violin() + scale_y_log10()

class(surveys_complete$plot_id)
# coloring by plot_id
surveys_complete %>% ggplot(aes(x=species_id,y=weight)) +
  geom_jitter(alpha=0.2, aes(color=as.character(plot_id))) +
  geom_violin() + scale_y_log10()


#time series - how number of species has changed over time
surveys_complete %>% count(year,species_id) %>%
   ggplot(aes(x=year,y=n)) + geom_line()
# issue with previous - overlayed all on one

# want to see by species as that is the intent
surveys_complete %>% count(year,species_id) %>%
  ggplot(aes(x=year,y=n,color=species_id)) + geom_line()

#time series - how weights of my species has changed over time
surveys_complete %>% group_by(year,species_id) %>%
     summarise(mean_weight = mean(weight)) %>%
     ggplot(aes(x=year,y=mean_weight,color=species_id)) + geom_line()
  

# Presentation of plots
# faceting - split one plot into multiple plots based on a factor(categorical variable)
surveys_complete %>% count(year,species_id) %>%
  ggplot(aes(x=year,y=n)) + geom_line() +
  facet_wrap(~species_id)

# specify the column name for facets
surveys_complete %>% count(year,species_id) %>%
  ggplot(aes(x=year,y=n)) + geom_line() +
  facet_wrap(c('species_id'))

# lines  for each sex within a species
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_wrap(~species_id)

# changing the presentation style
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_wrap(~species_id) + theme_bw()

# remove the grid
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_wrap(~species_id) + theme_bw() + theme(panel.grid = element_blank())

# Themes
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_wrap(~species_id) + theme_classic()

# Theme minimal
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_wrap(~species_id) + theme_minimal()

# no visualization
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_wrap(~species_id) + theme_void()

# labels
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_wrap(~species_id) + theme_minimal() +
  labs(x="Year of observation", y="Number of Species",title="Yearly Species distribution")

# facet.grid() gives the option to specify the rows and columns
#only one row, multiple columns 
#. is one row
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_grid(.~species_id) + theme_minimal() +
  labs(x="Year of observation", y="Number of Species",title="Yearly Species distribution")

# multiple rows
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_grid(species_id~.) + theme_minimal() +
  labs(x="Year of observation", y="Number of Species",title="Yearly Species distribution")


# sex and species ( rows - sex, and columns as species)
# multiple rows
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_grid(sex~species_id) + theme_minimal() +
  labs(x="Year of observation", y="Number of Species",title="Yearly Species distribution")

# fix the x labels
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_grid(sex~species_id) + theme(axis.text.x = element_text(size = 10,color = "red",angle = 90)) +
  labs(x="Year of observation", y="Number of Species",title="Yearly Species distribution") +
  

# Define your own themes
# justifying the plot title
  
theme_ideal <- theme(axis.text.x = element_text(size = 10,color = "red",angle = 90),
                     axis.text.y = element_text(size=10,color="blue"),
                     text= element_text(size=20),
                     axis.title = element_text(size=25),
                     plot.title = element_text(size=25,hjust = 0.5)
                     ) 

#writing functions which gives multiple themes 

my_t <- function ()
{
  
  theme_ideal <- theme(axis.text.x = element_text(size = 10,color = "red",angle = 90),
                       axis.text.y = element_text(size=10,color="blue"),
                       text= element_text(size=20),
                       axis.title = element_text(size=25),
                       plot.title = element_text(size=25,hjust = 0.5)
  ) 
  
  return(theme_ideal)
}


# talk about color scales (using scale color manual)
surveys_complete %>% group_by(sex,year,species_id) %>%
  summarise(mean_weight = mean(weight)) %>%
  ggplot(aes(x=year,y=mean_weight,color=sex)) + geom_line() +
  scale_color_manual(values = c('red','blue'))

# explore rgb 
# color brewer palletes (Cynthia Brewer)
surveys_complete %>% group_by(sex,year,species_id) %>%
  summarise(mean_weight = mean(weight)) %>%
  ggplot(aes(x=year,y=mean_weight,color=sex)) + geom_line() +
  scale_color_brewer(palette = 'Set1') 

#lts plot surveys complete
#continous color palette
surveys_complete %>% 
  ggplot(aes(x=weight,y=hindfoot_length,color=year)) + geom_point(alpha=0.1) +
  scale_color_continuous(low='white', high = 'dark red')

#modify the color scale

surveys_complete %>% 
  ggplot(aes(x=weight,y=hindfoot_length,color=year)) + geom_point(alpha=0.1) +
  scale_color_distiller(palette = 'Set1')


##modifying legends
surveys_complete %>% 
  ggplot(aes(x=weight,y=hindfoot_length,color=year)) + geom_point(alpha=0.1) +
  scale_color_distiller(palette = 'Set1',name="year of observation")

# filling the difference between two lines
#add paneling
library(gridExtra)
# or you could use 'cowplot'
# plot between two years

species_box <- surveys_complete %>% 
  ggplot(aes(x=species_id,y=weight)) + geom_boxplot() + scale_y_log10() + theme_classic()

species_count <- surveys_complete %>% count(year,species_id) %>% 
  ggplot(aes(x=year,y=n,color=species_id)) + geom_line() + theme_classic()

grid.arrange(species_box,species_count, ncol=2,widths= c(1,1.5))
# call your func with theme

# apply your own theme as a funtion 
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_grid(species_id~.) + my_t() +
  labs(x="Year of observation", y="Number of Species",title="Yearly Species distribution")

# apply your own theme
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_grid(species_id~.) + theme_ideal +
  labs(x="Year of observation", y="Number of Species",title="Yearly Species distribution")

# ggsave() - save your plots
# 
dist_by_species <- surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_grid(species_id~.) + theme_ideal +
  labs(x="Year of observation", y="Number of Species",title="Yearly Species distribution") 

#modifying legends
dist_by_species <- surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_grid(species_id~.) + theme_ideal +
  labs(x="Year of observation", y="Number of Species",title="Yearly Species distribution") 


ggsave("fig_output/dist_by_species.png",dist_by_species)



png(filename = "fig_output/dis_by_species_2.png")
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_grid(species_id~.) + theme_ideal +
  labs(x="Year of observation", y="Number of Species",title="Yearly Species distribution") 
dev.off()

#pdf save
pdf(file ="fig_output/dis_by_species_2.pdf")
surveys_complete %>% count(year,sex, species_id) %>%
  ggplot(aes(x=year,y=n,color=sex)) + geom_line() +
  facet_grid(species_id~.) + theme_ideal +
  labs(x="Year of observation", y="Number of Species",title="Yearly Species distribution") 
dev.off()



