#follow-up from 1st day

# what are variables
# what are classes
# arrays immutable ?

# repeat the questions when asked
# if we have time leftover
#helpful forays - writing functions
#               - writing packages

#ls() - list the veiables in space


download.file("https://ndownloader.figshare.com/files/2292169",
              "data/portal_data_joined.csv")


# read from the surveys
surveys <- read.csv("data/portal_data_joined.csv")

names(surveys)

as.character(surveys$species)
as.numeric(c(1,3,4,5))
summary(surveys)


head(surveys)
tail(surveys)

surveys[1,1]
surveys[1,4]
surveys[34786,4]

surveys[,4]


surveys[1,]

dim(surveys)

nrow(surveys)
ncol(surveys)
levels(surveys$sex)
names(surveys)
surveys[1,'record_id']

#c1 - rename column 'sex' to gender
#c2 - count by gender
summary(surveys$gender)
#

#mix and match row s
surveys[c(1:6,8),1]

#select certain columns from sdurveys
surveys %>% select(gender,species_id)

#first 6 columns
surveys %>% select(names(surveys)[1:6])

#filter 
surveys %>% select(names(surveys)[1:6]) %>% filter(plot_id == 2)

#c3
#filter plot_ids 2,3,6
surveys %>% select(names(surveys)[1:6]) %>% filter(plot_id %in% c(2,3,6)) %>% head()

#filter plot_ids 2,3,6 and day 16 or day 1
surveys %>% select(names(surveys)[1:6]) %>% 
  filter(plot_id %in% c(2,3,6) & (day==16 | day==1)) %>% head()

#c4
#filter plot_ids 2,3,6 and day 16 or day 1 and for January only(1)
surveys %>% select(names(surveys)[1:6]) %>% 
  filter(plot_id %in% c(2,3,6) & (day==16 | day==1) & month==1) %>% head()

#adding new columns
surveys %>% select(names(surveys)[1:6]) %>% 
  filter(plot_id %in% c(2,3,6) & (day==16 | day==1) & month==1) %>% mutate(season='winter')


#c5 tag season to all the observations
# skip days

#winter
winter <- surveys %>% select(names(surveys)[1:6]) %>% 
  filter( month %in% c(1,2,3)) %>% mutate(season='winter') %>% as.data.frame()

#summer
summer <- surveys %>% select(names(surveys)[1:6]) %>% 
  filter( month %in% c(7,8,9)) %>% mutate(season='winter') %>% as.data.frame()

#rbind
all<- rbind(summer,winter)

#group by plots
surveys %>% group_by(plot_id) %>% head()

#group by plots
surveys %>% group_by(plot_id,year) %>% head()

#summarize()
surveys %>% group_by(plot_id,year) %>% summarise(mean_weight=mean(weight))

surveys %>% filter(!is.na(weight)) %>% 
  group_by(plot_id,year) %>%
  summarise(mean_weight=mean(weight))

#using tidyr
surveys %>% drop_na() %>% group_by(plot_id,year) %>%
  summarise(mean_weight=mean(weight))

surveys %>% drop_na() %>% group_by(plot_id,year) %>%
  summarise(mean_weight=mean(weight),min_weight=min(weight))

#find out how many rows contributed to the grouping functions
surveys %>% drop_na() %>% group_by(plot_id,year) %>%
  summarise(mean_weight=mean(weight),min_weight=min(weight),count=n()) 

#using complete cases
surveys[complete.cases(surveys),] %>% group_by(plot_id,year) %>%
  summarise(mean_weight=mean(weight),min_weight=min(weight),count=n()) 

library(lme4)
fm1 <- glmer(Reaction ~ Days + (Days|Subject), sleepstudy,family=binomial(link = "logit"))

#lets look at the iris dataset
library(lme4)
#add a new binary column to iris dataset

iris_clone <- iris
iris_clone$oblong <- iris$Petal.Length/iris$Petal.Width< 5

str(iris_clone)

#Petal width being a random effect, and length being linear
model_1 <- glmer(oblong ~ Petal.Length + (1| Petal.Width),
                 iris_clone,family=binomial(link = "logit"))

#Petal width still being a random effect
model_2 <- glmer(oblong ~ Petal.Length + I(Petal.Length^2) + (1|Petal.Width) ,
                 iris_clone,family=binomial(link = "logit"))

AIC(model_1,model_2)
