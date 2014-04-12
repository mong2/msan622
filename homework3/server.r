library(ggplot2)
library(shiny)
library(reshape)
require(rCharts)

####Shiny Server########
shinyServer(function(input, output){
  
  states <- state.x77
  states_df <- data.frame(state.x77,
                          Abbrev = state.abb,
                          Region = state.region,
                          Division = state.division
                          )
  states <- cbind(states,
                  'State' = rownames(states),
                  'Region' = state.region)
  
  states_df <- states_df[order(df[,1]),]
  states_df<- states_df[ , -which(names(states_df) %in% c("Life.Exp","Area"))]
  
  ### Bubble Plot ###
  output$bPlot <- renderChart2({
    localPlot <- hPlot(x="HS.Grad", y= input$Education, data = states_df,group = "Region",type = "bubble",size ="Population")
    localPlot$xAxis(title = list(text="High School Graduates"))
    localPlot$set(dom = 'bPlot') 
    localPlot$chart(color = c('yellow', 'blue', '#594c26', 'green'))
    return(localPlot)
  })
  
  ### Parallel Coord ###
  output$parallel<- reactive(function(){    
    states[,1:6]
  })
  
  output$scatter <- reactive(function(){    
    states[,c(2:6,10)]
  })
}
)
