library(shiny)
library(ggplot2)
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
    localFrame <- subset(localFrame, localFrame$franchID %in% franchiseNames_NL)
  }else{
    localFrame <- subset(localFrame, localFrame$franchID %in% franchiseNames_AL)
  }
  
  localFrame <- subset(localFrame, localFrame$yearID >= year[1] & localFrame$yearID <= year[2])
  d <- ggplot(localFrame, aes(x = yearID, y= HA)) + geom_line()
  
  
}


global <- teams 
### Shiny Server ### 

shinyServer(
  function(input, output){
    
    localFrame <- global
    
    output$plot <- renderPlot({
      
      plot <- getPlot(localFrame,
                      input$franchiseNames_NL,
                      input$franchiseNames_AL,
                      input$league,
                      input$year
                      )
      
      print(plot)
    })
    
    output$plot_detail <- renderPlot({
      
      plot_detail <- getDetail(localFrame,
                               input$franchiseNames_NL,
                               input$franchiseNames_AL,
                               input$league,
                               input$year,
                               input$factors)
      
      print(plot_detail)
    })
    
  } 
)