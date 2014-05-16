data = data.frame(
  as.numeric(
    as.POSIXct(
      paste0(
        seq( from = 1910, to = 2010, by = 10 ),
        "-01-01"
      )
    )
  ),
  c(
    92228531, 
    106021568, 
    123202660, 
    132165129, 
    151325798, 
    179323175, 
    203211926,
    226545805,
    248709873,
    281421906,
    308745538
  ),
  stringsAsFactors = FALSE
)
colnames(data) <- c("x","y")
#build the plot
r3 <- Rickshaw$new()
r3$layer(
  y ~ x,
  data = data,
  type = "area",
  colors= "steelblue",
  height = 240,
  width = 540
)
#turn off all the nice built in features except xAxis
r3$set(
  hoverDetail = FALSE,
  yAxis = FALSE,
  shelving = FALSE,
  legend = FALSE,
  slider = FALSE,
  highlight = FALSE
)
#r3

r4 <- Rickshaw$new()
r4$layer(
  y ~ x,
  data = data,
  type = "area",
  colors= "steelblue",
  height = 240,
  width = 540
)
#turn off all the nice built in features except xAxis and yAxis
r4$set(
  hoverDetail = FALSE,
  shelving = FALSE,
  legend = FALSE,
  slider = FALSE,
  highlight = TRUE
)