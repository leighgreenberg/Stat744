library(ggplot2)
library(ggpubr) #for pretty 
#setwd()
faceInv <- read.csv("Leder et al table 1.csv",header=T)
#put the orientations in order because for some reason they aren't by default
faceInv$Orientation <- factor(faceInv$Orientation, levels=c("0°", "90°", "180°"))
#head(faceInv)

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
