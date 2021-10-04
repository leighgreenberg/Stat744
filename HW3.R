library(ggplot2)
library(ggpubr) #for pretty
##setwd()
## BMB: please use TRUE instead of T
## BMB: couldn't reproduce because you didn't push the CSV file to the repo ...
faceInv <- read.csv("Leder et al table 1.csv",header=T)
#put the orientations in order because for some reason they aren't by default
faceInv$Orientation <- factor(faceInv$Orientation, levels=c("0°", "90°", "180°"))
#head(faceInv)


## BMB: you should definitely work out how to do this by using pivot_longer() + facet_wrap() ...
## less code, more reliable, far better when there are more categories of responses, etc.
## BMB: should make sure to set things up so your legend says "Sex", not "factor(Sex)" (i.e.
## convert to a factor upstream.
## Consider flipping order of the legend since female values are more often below male values,
## especially for the rightmost panel?
## It would cute to add little face icons with the correct rotation (maybe for a seminar or poster
## presentation but not for a paper ...)

## BMB: did you consider non-default colours?
attPlot <- ggplot(faceInv,aes(Orientation, Attractiveness, colour = factor(Sex), fill = factor(Sex))) +
  geom_point()+geom_line(aes(group=Sex)) + #points and lines
  #ribbons, 95% CI
  geom_ribbon(aes(ymin=A_CI_lower,ymax=A_CI_upper,group=Sex,fill=Sex),colour=NA,alpha=0.3)

unattPlot <- ggplot(faceInv,aes(Orientation, Unattractiveness, colour = factor(Sex), fill = factor(Sex))) +
  geom_point()+geom_line(aes(group=Sex)) + #points and lines
  #ribbons, 95% CI
  geom_ribbon(aes(ymin=U_CI_lower,ymax=U_CI_upper,group=Sex,fill=Sex),colour=NA,alpha=0.3)

distPlot <- ggplot(faceInv,aes(Orientation, Distinctiveness, colour = factor(Sex), fill = factor(Sex))) +
  geom_point()+geom_line(aes(group=Sex)) + #points and lines
  #ribbons, 95% CI
  geom_ribbon(aes(ymin=D_CI_lower,ymax=D_CI_upper,group=Sex,fill=Sex),colour=NA,alpha=0.3)


#put them all side by side
ggarrange(attPlot, unattPlot, distPlot, ncol = 3, nrow = 1, common.legend = TRUE, legend="right")
