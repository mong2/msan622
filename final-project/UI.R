library(shiny)
library(gridExtra)
shinyUI(
  
  pageWithSidebar(
    
    headerPanel(""),
    sidebarPanel(

      conditionalPanel(
        condition = "input.tabs == 1",
        radioButtons(
          "league",
          "League",
          c("National League", "American League")
        ),
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
            "franchiseNames_AL",
            "Team :",
            choices = c("Orioles" = "BAL", "Red Sox" = "BOS", "White Sox" = "CHW", "Indians" = "CLE", " Tigers" = "DET",
                        "Astros" = "HOU", "Royals" = "KCR", " Angels" = "ANA", "Twins"="MIN", "Yankees" = "NYY", "Athletics" = "OAK",
                        "Mariners" = "SEA", "Rays" = "TBD", "Rangers" = "TEX", "Blue Jays" = "TOR")
            
          )
        ),
        
        radioButtons(
          "factors",
          "",
          choices = c("Runs Allow vs. Runs Scored" = "R_RA",
                      "WHIP vs. OPS" = "W_OPS"),
          selected = 'R_RA'
        ),
        
        br(),
        
        sliderInput(
          "year",
          "Year:",
          min = 2000, max =2013, value = c(2000,2013), step = 1,
          ticks = FALSE, format = "####"
        )
      ), 

      conditionalPanel(
        condition = "input.tabs == 2",
        helpText("Please read the overview on the data that this application provides before entering to next page.")        
        
        ),
      
      conditionalPanel(
        condition = "input.tabs == 3",
        
        radioButtons(
          "position",
          "",
          c("Pitchers", "Batters")
        ),
        selectInput(
          "appearance",
          "",
          choices = c("First Base" = "G_1b", "Second Base" = "G_2b", "Third Base" = "G_3b",
                      "Short Stop" = "G_ss", "Left Fielder" = "G_lf", "Center Fielder"= "G_cf",
                      "Right Fielder" = "G_rf", "Out Fielder" = "G_of", "Designated Hitter" = "G_dh","Catcher" = "G_c")
        )
        
        )

    ),
    

    mainPanel(
      tabsetPanel(
                  tabPanel("Teams",
                           fluidRow(
                             column(2,
                                    imageOutput("plot3", height = 72, width = 72)
                               ),
                             column(6,
                                    h2(textOutput("team"))
                               )),
                           
                           conditionalPanel(
                             condition = "input.factors == 'R_RA'",
                             showOutput("chart1","Highcharts")
                             
                             ),
                           conditionalPanel(
                             condition = "input.factors == 'W_OPS'",
                             showOutput("chart2","morris")
                             
                           ),
                           br(),

                           showOutput("chart3","Highcharts"),
                           value = 1),
                  tabPanel("Fantacy Team",
                           fluidRow(
                             column(8,
                                     
                                     strong("BA – Batting Average:", style = "font-size:14pt"), 
                                        p("This statistic is the traditional way to evaluate a player’s offensive ability; If his BA is high, he’s good, and if it’s low, he is not good. 
                                        A BA of .300 or higher is fairly impressive, while a BA under .200 is generally low enough to the player sent back to the minor leagues."),
                                        strong("BA = Total Hits / Total At-Bat"),
                                        p("Note: NO one has hit over .400 since 1941"),
                                    
                                        
                                        br(),
                                
                                        strong("BABIP – Batting Average on Balls In Play:", style ="font-size:14pt"),                                
                                        p("The statistic shows how often a player reaches base when a ball is hit into play. BABIP discounts home runs and strikeouts, so it’s a measure of how effectively a player can reach base when he hits the ball (or is walked or bit by pitch). 
                                        A typical BABIP stays close to .290."),                 
                                        strong("BABIP =  (Hits – Home Runs) / (At-Bat – Strikeouts – Home Runs – Sacrifice Flies)"),
                                        
                                        br(),
                                    
                                        strong("OBP – On-Base Percentage:", style = "font-size:14pt"),
                                        p("The statistic shows how often a player reaches. Nowadays managers have played an emphasis on players skilled in drawing walks, as a walk gets the player on base as effectively as a hit does. OBP is nearly always higher than BA due to walks are included. An average OBP today is around 0.340.
                                        A practical application of OBP comes into play when the bases are loaded. It’s not the batting average of the next batter up that matters, it’s his OBP, since getting on base by any method will bring in a run."),
                                        strong("OBP = (Hits + Walks + Hit by Pitch) / (At Bats + Walks + Hit by Pitch + Sacrifice Flies"),
                                       
                                        br(),
                                    
                                        strong("RBI – Runs Batted In:", style = "font-size:14pt"),
                                        p("The statistic credits a batter when the outcome of his at-bat result in a run being scored, except in certain situations such as when an error is made on the play.")

                                      ),
                                    
                             column(4,
                                    h2("Your Team"),
                                    tableOutput("fantacy")
                               )
                             
                             ),
                               
                           value = 2),
                  tabPanel("Players",
                           h2(textOutput("text")),
                           conditionalPanel(
                             condition = "output.text != 'Please Select a Player'",
                             plotOutput("Batter")
                           ),
                           dataTableOutput("plot_table"),
                           value = 3),
                  id = "tabs")
      
    )
    
    
    
  )
  
  
  
)