library(shiny)

shinyUI(
  
  pageWithSidebar(
    
    headerPanel(""),
    
    sidebarPanel(
      
      radioButtons(
        "league",
        "League",
        c("National League", "American League")
      ),
      
      br(),
      
      conditionalPanel(
        condition = "input.league == 'National League'",
        selectInput(
          "franchiseNames_NL",
          "Team :",
          choices = c("Nationals"= "WSN", "Cardinals" = "STL","Astros" = "HOU",
                      "Giants" = "SFG", " Padres" = "SDP", "Pirates" = "PIT", "Phillies" = "PHI", 
                      "Mets" = "NYM", "Brewers" = "MIL", "Marlins" = "FLA", "Dodgers" = "LAD", "Rockies" = "COL",
                      "Reds" = "CIN", "Cubs" = "CHC", "Braves" = "ATL", "Diamondbacks" = "ARI")
          
        )
      ), 
      conditionalPanel(
        condition = "input.league == 'American League'",
        selectInput(
          "franchiseNames_NL",
          "Team :",
          choices = c("Orioles" = "BAL", "Red Sox" = "BOS", "White Sox" = "CHW", "Indians" = "CLE", " Tigers" = "DET",
                      "Astros" = "HOU", "Royals" = "KCR", " Angels" = "ANA", "Twins"="MIN", "Yankees" = "NYY", "Athletics" = "OAK",
                      "Mariners" = "SEA", "Rays" = "TBD", "Rangers" = "TEX", "Blue Jays" = "TOR")
          
        )
      ),  
      
      checkboxGroupInput(
        "factors",
        "",
        choices = c("Hits Allowed" = 'HA', "Home Run Allowed" = "HRA",
          "Walks Allowed" = "BBA", "Strike Out" = "SOA", "Errors" = "E"),
        selected = 'HA'
        ),
      
      br(),
      
      sliderInput(
        "year",
        "Year:",
        min = 2000, max =2013, value = c(2000,2013), step = 1,
        ticks = FALSE, format = "####"
      )
    ),
    
    mainPanel(
      
      tabsetPanel(tabPanel("Plot",plotOutput("plot_detail"),
                                  plotOutput("plot",height='200px')
                                  ))
    )
    
    
    
  )
  
  
  
)