library(shiny)

# Create a simple shiny page.
shinyUI(
  # We will create a page with a sidebar for input.
  pageWithSidebar(
    # Add title panel.
    headerPanel("IMBD Movie Rating"),
    
    # Setup sidebar widgets.
    sidebarPanel(
     
      # Add radio buttons for MPAA Rating.
      # Can only select one radio button at a time.
      radioButtons(
        "MpaaRating",
        "MPAA Rating:",
        c("All", "NC-17", "PG", "PG-13", "R")
      ),
      
      # Add a little bit of space between widgets.
      br(),
      
      # Add Movie Genres checkbox
      checkboxGroupInput(
        inputId ="sortMovieGenres",
        label ="Movie Genres",
        choices = c("Action","Animation","Comedy","Drama","Documentary","Romance","Short", "None"),
        ),
      
      # Add a little bit of space between widgets.
      br(),
      
      # Add a drop-down box for Color sorting.
      selectInput(
        # This will be the variable we access later.
        "colorScheme",
        # This will be the control title.
        "Color Scheme:",
        # This will be the control choices.
        choices = c("Default", "Accent", "Set1", "Set2", "Set3", "Dark2", "Pastel1", "Pastel2")
      ),
      
      # Add slider input for Dot Size 
      sliderInput(
        "DotSize",
        "Dot Size:",
        min = 1, max = 10, value = 3, step = 1
        ),
      
      br(),
      # Add slider input for Dot Alpha 
      sliderInput(
        "DotAlpha",
        "Dot Alpha:",
        min = 0.1, max = 1, value = 0.5, step = 0.1
      )
    ),
    
    # Setup main panel.
    mainPanel(
      plotOutput("moviePlot")
      
    )
  )
)
