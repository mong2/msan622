library(shiny)
require(rCharts)
d3IO <- function(inputoutputID) {
  div(id=inputoutputID,
      class=inputoutputID,
      tag('svg', ''));
}
shinyUI(
  fluidPage(
    headerPanel("The Importance of High School Education"),
    tabsetPanel(
      tabPanel('Parallel coordinates',
               br(),
               br(),
               includeHTML('parallel.html'),
               d3IO('parallel')
      ),
      
      ## Bubble Plot ##
      tabPanel('Bubble Plot',
               showOutput("bPlot", "Highcharts"),
               radioButtons("Education", 
                            "Variable:",
                            c("Income", "Illiteracy", "Murder"))
               
      ),
      
      ### ScatterPlot Matrix ###
      tabPanel('ScatterPlot Matrix',
               includeHTML('scatter.html'),
               d3IO('scatter')
               )
    )
  )
  
)



