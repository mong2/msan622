source("data.R")
require(reshape2)
require(ggplot2)

basic <- data.frame (
  year = seatbelts_df$year,
  month = seatbelts_df$month,
  time = seatbelts_df$time,
  killed = seatbelts_df$killed,
  Front = seatbelts_df$front,
  Rear = seatbelts_df$rear
)


basic_melt <- melt(
  basic, 
  id = c("year", "month", "time")
)

p <- ggplot(basic_melt, aes( x = time, y = value)) + geom_line(
  data = subset(basic_melt, variable != "killed"),
  aes(
    goup = variable,
    fill = variable, 
    color = variable,
    order = -as.numeric(variable)
  )) + 
  theme(legend.title = element_blank(),
        legend.key = element_blank()
        )+
  scale_color_manual(values=c("Navy", "Royalblue1"))+
  scale_x_continuous(expand = c(0,0),
                     )+
  xlab("Time")+
  ylab("Deaths & Injuries")+
  geom_vline(
    xintercept = c(1983), size = 1.5,linetype ="dotted",color = "red"
  ) +
  coord_fixed(ratio = 4/1000)

ggsave(
  filename = file.path("multi_hw5.png"),
  width = 10,
  height = 8, 
  dpi = 100
)
print(p)



l <- ggplot(seatbelts_df, aes( x = time, y = percentage)) +
     geom_line(colour="Royalblue1") + coord_fixed (ratio = 1/2) + 
     scale_x_continuous(expand = c(0,0),
                        breaks = c(1970, 1975, 1983))+
     scale_y_continuous(breaks= c(5, 6, 7, 8, 9),
                     labels=c("5%", "6%","7%","8%","9%"))+
     xlab("Time")+
     ylab("")+
     ggtitle("Death Rate 1970-1984")+
     geom_vline(xintercept = c(1983), size = 1.5,linetype ="dotted",color = "Orange")
print(l)

ggsave(
  filename = file.path("single_hw5.png"),
  width = 10,
  height = 8, 
  dpi = 100
)



g <- ggplot(seatbelts_df, aes(x = year, y= month)) +
     geom_tile(aes(fill = Gas), color = "grey40")+
     theme(legend.direction = "horizontal", 
           legend.position = "bottom",
           legend.justification = c(1,1),
           legend.background = element_blank(),
           legend.key = element_blank(),
           axis.ticks = element_blank(),
           panel.background = element_blank())+
     xlab("")+
     ylab("")+
     ggtitle("Monthly Gas Price 1969-1984")

ggsave(
  filename = file.path("heat_hw5.png"),
  width = 10,
  height = 8, 
  dpi = 100
)
print(g)