require(tm)
require(SnowballC)
require(wordcloud)
require(ggplot2)

text_source <-DirSource(
  
  directory = file.path("NorthPacific"),
  encoding = "UTF-8",
  pattern = "*.txt", 
  recursive =FALSE, 
  ignore.case = FALSE

  )

text_corpus <- Corpus(
  text_source, 
  readerControl = list(
    reader = readPlain,
    language = "en"))  

text_corpus <-tm_map(text_corpus, tolower)

text_corpus <- tm_map(text_corpus, removePunctuation, 
                    preserve_intra_word_dashes = TRUE)

text_corpus <- tm_map(text_corpus, removeWords, stopwords("english"))

text_corpus<- tm_map(
  text_corpus,
  stemDocument,
  lang ="english"
)

text_corpus <- tm_map(text_corpus,stripWhitespace)

text_corpus <- tm_map(
  text_corpus,
  removeWords, 
  c("will", "can", "get", "that", "year", "let")
  )



text_tdm<-TermDocumentMatrix(text_corpus)


text_matrix <- as.matrix(text_tdm)
text_df <- data.frame(
  word = rownames(text_matrix), 
  freq = rowSums(text_matrix),
  stringsAsFactors = FALSE) 

text_df <- text_df[with(
  text_df, 
  order(freq, decreasing = TRUE)), ]

rownames(text_df) <- NULL




### Freq Plot ###

freq_df <- data.frame(
  Obama = text_matrix[,"Obama2009.txt"],
  Bush = text_matrix[,"Bush2001.txt"],
  stringAsFactors = FALSE
  )

freq_df <- freq_df[order(rowSums(freq_df),
                         decreasing = TRUE),]
freq_df <- head(freq_df, 20)

p <- ggplot(freq_df, aes(Obama, Bush))+ 
     geom_text(label = rownames(freq_df),
               color = "Navy",
               position = position_jitter(
                 width = 4,
                 height = 2))+
     ggtitle("First Term Presidency State of the Union Address")+
     geom_abline(intercept = 27.8, slope = -0.586, color="Orange")+
     xlab("Obama 2009")+
     ylab("Bush  2001")+
     theme_bw()+
     theme(panel.grid.major = element_line(size = 0.7, linetype = "dotted"),
           axis.title.x = element_text(vjust = -0.03, face = "bold"),
           axis.title.y = element_text(vjust =0.3,face = "bold"),
           plot.title = element_text(face="bold", vjust = 1.4, size =16))+
     scale_x_continuous(expand = c(0,0))+
     scale_y_continuous(expand = c(0,0))+
     coord_fixed(
       ratio = 5/6,
       xlim = c(0,45),
       ylim = c(0,45))

ggsave(
  filename = file.path("img", "freqPlot_hw4.png"),
  width = 10,
  height = 8, 
  dpi = 100
)


### bar chart ###

bar_df <-head(text_df,10)
bar_df$word <- factor(bar_df$word, 
                      levels = bar_df$word,
                      ordered = TRUE)
t <- ggplot(bar_df, aes(x = word, y = freq))+ 
     geom_bar(stat = "identity", fill = "royalblue1")+
     theme(axis.title.x = element_text(face = "bold", vjust = -0.5),
           axis.title.y = element_text(face = "bold", vjust = 0.3),
           panel.grid = element_blank(),
           panel.border = element_blank(),
           panel.background = element_blank(),
           axis.ticks = element_blank(),
           plot.title = element_text(face="bold", vjust = 1.4, size =16))+
      scale_x_discrete(expand = c(0,0))+
      scale_y_continuous(expand = c(0,0))+
      xlab("Top 10 Word Stems")+
      ylab("Frequency")+
      ggtitle("First Term Presidency State of the Union address (1989,1993,2001,2009)")
print(t)
ggsave(
  filename = file.path("img", "textBar_hw4.png"),
  width = 10,
  height = 7,
  dpi = 100
  )
     
###Word Cloud ### 
colnames(text_matrix) <- c("W. Bush", "Clinton", "Obama", "Bush")
matrix <- text_matrix[apply(text_matrix,1,sum) >10,]
png("wordCloud_hw4.png", 640, 480)
comparison.cloud(matrix, random.order=FALSE,max.words= 500)
dev.off()

