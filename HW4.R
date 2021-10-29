#Seoul Bike Sharing data from UCI Repository
#Outcome of interest: number of bikes rented

library(tidyverse)
#library(car)
#library(broom)
#library(broom.mixed)
#library(magrittr)
## modeling
# library(lme4)
# library(MCMCglmm)
# library(glmmTMB)
library(DHARMa)
library(dotwhisker)

#library(coda) ## Bayesian methods (trace plots etc.)
#library(lattice) ## built-in
#library(cowplot)
#library(nullabor) ## visual inference
bikes <- read.csv("SeoulBikeData.csv",header=TRUE, fileEncoding = "Latin1")

#make Seasons, Holiday factors
bikes$Seasons <- as.factor(bikes$Seasons)
bikes$Holiday <- as.factor(bikes$Holiday)

lmBike = lm(Rented.Bike.Count~Hour+Hour+Temperature..C.+Humidity...+Wind.speed..m.s.+Visibility..10m.+
              Dew.point.temperature..C.+Solar.Radiation..MJ.m2.+Rainfall.mm.+Snowfall..cm.
            +Seasons+Holiday, data = bikes)
summary(lmBike)
#all significant @ a=0.05 except visibility, dew point temp, and SeasonsSummer

#coefficient plot
gg0 <- dotwhisker::dwplot(lmBike, by_2sd=TRUE)
gg1 <- gg0 + geom_vline(xintercept=0,lty=2)
print(gg1) #visualize the lm summary table but with more detail: temp, humidity, SeasonsWinter, hour have larger coefficients than the other predictors, even if most are significant
#can also see large CIs for temp,dew point

g1 <- DHARMa::simulateResiduals(lmBike)
plot(g1) #lots of red, right plot is non-uniform, so data deviates significantly from model expectation

#conclusion: choose a different model 

## JD: Perfectly reasonable, but no dataviz, really. Did you think about units in your coefplot? The numbers are high, do we know why? Do you think the background is a good visual choice? Grade 2/3



#stuff I didn't use, mostly playing around/personal interest

#variable importance plot
# library(randomForest)
# len<-nrow(bikes)
# train <- sample(1:len,(len/2))
# bag.bike=randomForest(Rented.Bike.Count~.,data=bikes,subset=train,mtry=13,importance=TRUE,type="class")
# varImpPlot(bag.bike) #hour, temp, functioning.day most imp, also humidity and solar radiation
# 

#visualize individual predcitors against outcome
# bikes_long <- pivot_longer(bikes[,-c(1,3,12,13,14)], #exclude non-continuous predictors and non-predictive info e.g. date
#                            -Rented.Bike.Count, #don't melt the outcome variable
#                            names_to="xvar", values_to="xval")
# g1 <- (ggplot(bikes_long,aes(xval,Rented.Bike.Count)) +
#          geom_point() +
#          facet_wrap(~xvar, scale="free_x") +
#          ## include defaults to suppress message
#          geom_smooth(method = "loess", formula = y ~ x)
# )
# print(g1)
# 
