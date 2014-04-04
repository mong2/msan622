library(ggplot2)
library(shiny)

# Load global data to be shared by all sessions
loadData <- function(){
  data("movies", package = "ggplot2")

  movies<-subset(movies, budget>0)
  movies<-subset(movies, mpaa !="")
  genre <- rep(NA, nrow(movies))
  count <- rowSums(movies[, 18:24])
  genre[which(count > 1)] = "Mixed"
  genre[which(count < 1)] = "None"
  genre[which(count == 1 & movies$Action == 1)] = "Action"
  genre[which(count == 1 & movies$Animation == 1)] = "Animation"
  genre[which(count == 1 & movies$Comedy == 1)] = "Comedy"
  genre[which(count == 1 & movies$Drama == 1)] = "Drama"
  genre[which(count == 1 & movies$Documentary == 1)] = "Documleveentary"
  genre[which(count == 1 & movies$Romance == 1)] = "Romance"
  genre[which(count == 1 & movies$Short == 1)] = "Short"
  movies$genre=genre
  df <- movies[, c("budget", "rating", "mpaa", "genre")]
  return(df)   
}




#Create plotting function
getPlot <- function(localFrame, MpaaRating = "None", colorScheme = "None", DotSize, 
                    DotAlpha){
        
        #Rating
        if(MpaaRating == "All"){
            localPlot <- ggplot(localFrame, aes(x = budget, y = rating, color=mpaa))
            localPlot <- localPlot + geom_point(size = DotSize,alpha = DotAlpha, position = "jitter") +
                         scale_x_continuous(breaks= c(0.0e+00, 5.0e+07, 1.0e+08, 1.5e+08,2.0e+08),
                                   labels=c(">0", ".5 Billion","1 Billion","1.5 Billion","2 Billion"))+
              theme(axis.title.x=element_text(vjust=-0.03, face="bold",color="grey30"), 
                    axis.title.y=element_text(face="bold",color="grey30"),
                    legend.title=element_text(color="grey30"),
                    legend.background= element_rect(),
                    legend.direction = "horizontal",
                    legend.justification = c(0,0),
                    legend.position = c(0.665,0),
                    legend.background = element_blank(),
                    plot.title=element_text(vjust= 1.4,size=16),
#                     panel.grid.minor.x = element_blank(),
#                     panel.grid.minor.y = element_blank(),
                    axis.ticks.x= element_blank())+
              labs(color="MPAA RATING")+
              xlab("Budget")+
              ylab("IMDB Rating")
    
        }
        else{
          
            if (MpaaRating == "NC-17"){
               localFrame <-subset(localFrame, mpaa == "NC-17")
            }else if (MpaaRating == "PG"){
               localFrame <-subset(localFrame, mpaa == "PG")    
            }else if (MpaaRating == "PG-13"){
               localFrame <-subset(localFrame, mpaa == "PG-13")
            }else{
                localFrame <-subset(localFrame, mpaa == "R")  
            }
            
          localPlot <- ggplot(localFrame, aes(x = budget, y = rating, color = genre))
          localPlot <- localPlot + geom_point(size = DotSize,alpha = DotAlpha, position = "jitter") +
            scale_x_continuous(breaks= c(0.0e+00, 5.0e+07, 1.0e+08, 1.5e+08,2.0e+08),
                               labels=c(">0", ".5 Billion","1 Billion","1.5 Billion","2 Billion"))+
            theme(axis.title.x=element_text(vjust=-0.03, face="bold",color="grey30"), 
                  axis.title.y=element_text(face="bold",color="grey30"),
                  legend.title=element_text(color="grey30"),
                  legend.direction = "horizontal",
                  legend.justification = c(0,0),
                  legend.position = "bottom",
                  legend.background = element_blank(),
                  plot.title=element_text(vjust= 1.4,size=16),
#                   panel.grid.minor.x = element_blank(),
#                   panel.grid.minor.y = element_blank(),
                  axis.ticks.x= element_blank())+
            labs(color="Movie Genres")+
            xlab("Budget")+
            ylab("IMDB Rating")
        }        
             
        #color scheme
        if(colorScheme == "Accent"){
          localPlot <- localPlot +
            scale_color_brewer(palette = "Accent")
        }
        else if (colorScheme == "Set1"){
          localPlot <- localPlot +
            scale_color_brewer(palette = "Set1")
        }
        else if (colorScheme == "Set2"){
          localPlot <- localPlot +
            scale_color_brewer(palette = "Set2")
        }
        else if (colorScheme == "Set3"){
          localPlot <- localPlot +
            scale_color_brewer(palette = "Set3")
        }
        else if (colorScheme == "Dark2"){
          localPlot <- localPlot +
            scale_color_brewer(palette = "Dark2")
        }
        else if (colorScheme == "Pastel1"){
          localPlot <- localPlot +
            scale_color_brewer(palette = "Pastel1")
        }
        else if (colorScheme == "Pastel2"){
          localPlot <- localPlot +
            scale_color_brewer(palette = "Pastel2")
        }
        else{
          localPlot <- localPlot +
            scale_color_grey(start = 0.2, end = 0.2)
        } 
        
        
        
        
        
        
        return(localPlot)

}


#shared data
globalData <- loadData()

####Shiny Server #####
shinyServer(function(input, output){
  
  cat("Press \"ESC\" to exit ...\n")
  
  localFrame <-globalData
  
  
  output$moviePlot <- renderPlot(
    {
      if(is.null(input$sortMovieGenres)){
          localFrame <-localFrame
        }
        else{
        localFrame <- subset(localFrame, localFrame$genre %in% input$sortMovieGenres)
        }
      
         moviePlot <- getPlot(
                   localFrame,
                   input$MpaaRating,
                   input$colorScheme,input$DotSize, input$DotAlpha)
  
  print(moviePlot,width = 10, height = 15)
    }
  )
  
  
})
