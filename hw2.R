library(dplyr)
library(ggplot2)

diseases <- read.csv("vaccine_data_online.csv",header=TRUE)
measles <- filter(diseases,disease=="Measles")
#meas <- ggplot(measles, aes(year, cases))
#meas + geom_point() #quick dot plot

#show cumulative cases over time
ggplot(measles, aes(x=year, y=cumsum(cases/1000000))) + 
  geom_point(col = ifelse(measles$year == 1963, "blue3", "lightcoral")) + 
  xlab("Year") + ylab("Cumulative Cases (millions)") + scale_y_log10() + 
  ggtitle("Measles Cases Over Time") + annotate("text", y=10, x =1956,label= "Vaccine ->") 


#2 lines, before vs after vaccine
mea <- select(measles,year,cases)
mea$VaccineAvailable <- ifelse(measles$year >= 1963, "Yes", "No")
ggplot(mea, aes(x=year, y=cases, color = VaccineAvailable)) + geom_line() + scale_y_log10() +
  ggtitle("Measles Cases Over Time") + xlab("Year") + ylab("Yearly Cases")
