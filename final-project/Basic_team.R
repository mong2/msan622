library(shiny)
library(ggplot2)
library(reshape)
teams <- read.csv("Teams.csv", header = TRUE)
teams <- subset(teams, yearID >= 2000)
teams[,"percentW"] <- teams$W/teams$G


getPlot <- function(localFrame,franchiseNames_NL, franchiseNames_AL,league, year){
  
  ## NL or AL ##
  if(league == "National League"){
    localFrame <- subset(localFrame, localFrame$franchID %in% franchiseNames_NL)
  }else{
    localFrame <- subset(localFrame, localFrame$franchID %in% franchiseNames_AL)
  }
  
  ## time range ##
  p <- ggplot(localFrame, aes(x = yearID, y = percentW))
  p <- p +
    geom_rect(xmin = year[1], xmax = year[2], ymin = -Inf, ymax = Inf, alpha = 0.4,fill = 'grey') + 
    geom_line()
  
}

getDetail <- function(localFrame,franchiseNames_NL, franchiseNames_AL,league, year, factors){
  
  if(league == "National League"){
    print(head(localFrame))
    localFrame <- subset(localFrame, localFrame$franchID %in% franchiseNames_NL)
  }else{
    print(head(localFrame))
    localFrame <- subset(localFrame, localFrame$franchID %in% franchiseNames_AL)
    
  }
  
  
  localFrame <- subset(localFrame, localFrame$yearID >= year[1] & localFrame$yearID <= year[2])
  #   print(factors)
  mel_D <- melt(localFrame[,c("yearID", factors)], id = c("yearID"))
  #   print(mel_D)
  d <- ggplot(mel_D,aes(x = yearID,y= value)) +
    facet_wrap(~variable) + 
    geom_line()
  
  
  
}


global <- teams