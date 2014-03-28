library(ggplot2)
data(movies)
data(EuStockMarkets)
movies<-subset(movies, budget>0)
genre <- rep(NA, nrow(movies))
count <- rowSums(movies[, 18:24])
genre[which(count > 1)] = "Mixed"
genre[which(count < 1)] = "None"
genre[which(count == 1 & movies$Action == 1)] = "Action"
genre[which(count == 1 & movies$Animation == 1)] = "Animation"
genre[which(count == 1 & movies$Comedy == 1)] = "Comedy"
genre[which(count == 1 & movies$Drama == 1)] = "Drama"
genre[which(count == 1 & movies$Documentary == 1)] = "Documentary"
genre[which(count == 1 & movies$Romance == 1)] = "Romance"
genre[which(count == 1 & movies$Short == 1)] = "Short"
movies$genre=genre
eu <- transform(data.frame(EuStockMarkets), time = time(EuStockMarkets))

##Plot1 ScatterPlot##

t<-qplot(budget, rating, data=movies, colour=rating)
t + scale_x_continuous(breaks= c(0.0e+00, 5.0e+07, 1.0e+08, 1.5e+08,2.0e+08),
                       labels=c(">0", ".5 Billion","1 Billion","1.5 Billion","2 Billion"))+
  scale_colour_gradient(low="black", high="red")+
  theme(axis.title.x=element_text(vjust=-0.03, face="bold",color="grey30"), 
        axis.title.y=element_text(face="bold",color="grey30"),
        legend.title=element_text(color="grey30"),
        plot.title=element_text(vjust= 1.4,size=16))+
  xlab("Budget")+
  ylab("IMDB Rating")+
  ggtitle("IMDB Rating V.S. Budget by Genre")
  
ggsave("hw1-scatter.png", width = 9, height = 4.25, dpi = 300, units = "in")


#Plot2 BarChart
# library(RColorBrewer)
# my.cols <- brewer.pal(9, "Reds")
# my.cols
# my.cols[1] <- "#FFF5F0"
# 
# library(ggplot2)
# df <- data.frame(x=1:9, type=9:1)
# ggplot(df, aes(x=x, fill=factor(type))) +
#   geom_bar(binwidth=1)+ 
#   scale_fill_manual(values = my.cols)

theTable <- within(movies, 
                   genre <- factor(genre, 
                                      levels=names(sort(table(genre), 
                                                        decreasing=TRUE))))

b<-ggplot(theTable, aes(x=genre, fill=genre), binwidth=3000)
b + geom_bar(fill="royalblue1")+
  #scale_fill_brewer(palette="Reds")+
  theme(axis.title.x=element_text(face="bold", vjust=-0.5, color="grey30"),
        axis.title.y=element_text(vjust=0.3,face="bold",color="grey30"),
        axis.line = element_line(colour = "grey80"),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                panel.border = element_blank(),
                panel.background = element_blank(),
        legend.position="none",
        plot.title=element_text(vjust= 1.4,size=16))+
  xlab("Movie Genres")+
  ylab("Number of Movies in the Genre")+
  ggtitle("Number of Movies in Genres")
ggsave("hw1-bar.png", width = 9, height = 4.25, dpi = 300, units = "in")

##Plot3 Small Multiples##

d<-ggplot(movies, aes(x=budget, y=rating))+
  geom_point(aes(group=factor(genre),
                 color=rating))+
  scale_colour_gradient(high = "red",low = "black")+
  scale_x_continuous(breaks= c(0.0e+00, 5.0e+07, 1.0e+08, 1.5e+08,2.0e+08),
                     labels=c(">0", ".5B","1B","1.5B","2B"))+
  theme(axis.title.x=element_text(vjust=-0.03, face="bold",color="grey30"), 
        axis.title.y=element_text(face="bold",color="grey30"),
        legend.title=element_text(color="grey30"),
        plot.title=element_text(vjust= 1.4,size=16))+
  xlab("Budget")+
  ylab("IMDB Rating")+
  ggtitle("IMDB Rating V.S. Budget by Genre")+
  facet_wrap(~genre)

print(d)

ggsave("hw1-multiples.png", width = 9, height = 4.25, dpi = 300, units = "in")

#Plot 4 Multi-line Chart# 
library(reshape)
eu[sapply(eu, is.ts)] <-lapply(eu[sapply(eu, is.ts)], unclass)
newframe<- melt(eu, id.vars=c("time"), value.name="price", variable.name="stock")
multiplot <-ggplot(newframe, aes(x=time, y=value, group=variable, colour=variable))+
  scale_x_continuous(breaks=c(1991,1992,1993,1994,1995,1996,1997,1998))+
  geom_line(size=0.5)+
  theme(axis.title.x=element_text(vjust=-0.03, face="bold",color="grey30"), 
        axis.title.y=element_text(face="bold",color="grey30"),
        plot.title=element_text(vjust= 1.4,size=16))+
  ggtitle("EU Stock Martkets (1991-1998)")+
  xlab("Time")+
  ylab("Stock Price")+
  scale_color_discrete(name="Stocks")
print(multiplot)
ggsave("hw1-multiline.png", width = 9, height = 4.25, dpi = 300, units = "in")

