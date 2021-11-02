library(tidyverse)
library(ggplot2)
library(plotly)
library(gapminder)
library(RColorBrewer)

#goal: visualize some store data, where x=time and y=weekly sales

#dataset about Walmart stores, from https://www.kaggle.com/rutuspatel/walmart-dataset-retail/version/1
walmart <- read.csv("Walmart_Store_sales.csv",header=TRUE)

#keep only 12 stores because looking at 45 graphs is hard and 12 is probably representative enough
walmart <- filter(walmart, Store<=12)

#make a new Date column that's easier to work with and will show better on plots
#also faster to load plot
#add in real dates as interactive element later?
walmart <- cbind(walmart, WeekPeriod=1:143)

#time to make some plots with sales in millions
#line graph for weekly sales during period length, red points are holidays
#automatic colour isn't great
#df2 <- tidyr::pivot_longer(walmart, -Date, names_to = "type", values_to = "value") #figure this out later
p <-ggplot(walmart, mapping = aes(WeekPeriod, Weekly_Sales/1000000, color = Store)) +
    geom_line() +
    geom_point(data=filter(walmart, Holiday_Flag==1),
      aes(x=WeekPeriod,Weekly_Sales/1000000),
      color='red',
      size=1) +
  facet_wrap(~Store)
## BMB: maybe you wanted colour = factor(Store)? In any case colours
## are redundant with facets.
## Too we don't have more data (e.g. geographic) about stores

ggplotly(p)
#from above, we can see that some holidays have an effect on sales, others dont, and some holidays have different effects than others
#for example, some high points are on the holiday, like thanksgiving/black friday, but other high points come before a holiday, like christmas
#the above is not something we can easily discern without inspecting a ton of points, but is interesting

#lets try again, get the data for which holidays are which
# class(walmart$Date)
SuperBowl <- c("12-02-2010","11-02-2011","10-02-2012","08-02-2013") #from the kaggle link, not sure why the xmas dates vary
LabourDay <- c("10-09-2010","09-09-2011","07-09-2012","06-09-2013")
Thanksgiving <- c("26-11-2010","25-11-2011","23-11-2012","29-11-2013")
Christmas <- c("31-12-2010","30-12-2011","28-12-2012","27-12-2013")

#add this into to df
walmart$Holiday <- ifelse(walmart$Date %in% SuperBowl,"SuperBowl","None")
walmart$Holiday[walmart$Date %in% LabourDay] <- "LabourDay"
walmart$Holiday[walmart$Date %in% Thanksgiving] <- "Thanksgiving"
walmart$Holiday[walmart$Date %in% Christmas] <- "Christmas"

walmart$Holiday <- as.factor(walmart$Holiday)
walmart$Store <- as.factor(walmart$Store)


#make a plot that shows each holiday highlighted, separate
walmartPlot<- ggplot(walmart,aes(WeekPeriod,Weekly_Sales/1000000))+
      geom_line()+
  geom_point(data=walmart[walmart$Holiday != "None", ],
             aes(color=Holiday))+ #exclude days with no holiday
      xlab("Week of Data Collection Period") + ylab("Weekly Sales (millions of USD)") + ggtitle("Walmart Sales at 12 Stores")+
  facet_wrap(~Store)

ggplotly(walmartPlot + scale_color_brewer(palette = "Dark2")) #good mid-range colours, nothing too close to background or line
## BMB: definitely nicer

## BMB: order stores by average sales?
## BMB: scaling weekly sales is definitely a good idea. Could have cleaned
## up hovertext formatting a bit more:

#interactive elements, in this visualization, help with getting specific data for points of interest. In our case, we might want to see exactly how a certain holiday affects sales within a store or across stores
#further, zooming allows viewers to subset a specific x or y range of interest, e.g. only sales above 3 mil or only data points in the first half of the period
##lastly, viewers can customize the holidays that are plotted by clicking on their names on the legend
## BMB nice (although I wouldn't have guessed this)

## mark: 2.3; reasonable graphs, some discussion








# f <-ggplot(walmart, mapping = aes(NewDate, Weekly_Sales/1000000, color = Store)) +
#   geom_line() +
#   geom_point(data=filter(walmart,Holiday2!="None"),
#              color=walmart$Holiday2,
#              size=1) +
#   facet_wrap(~Store)
#
# ggplotly(f)
#
# q <-ggplot(walmart, mapping = aes(NewDate, Weekly_Sales/1000000, color = Store)) +
#   geom_line()+
#   geom_point(data=filter(walmart,as.integer(Holiday2)>1), mapping = aes(NewDate, Weekly_Sales/1000000, color = Holiday2)) +
#   facet_wrap(~Store)
#
# ggplotly(q)
#
#
# q <-ggplot(walmart, mapping = aes(NewDate, Weekly_Sales/1000000, color = Holiday2)) +
#       geom_point() +
#
#       facet_wrap(~Store)













