data(Seatbelts)
require(reshape2)
times <- time(UKDriverDeaths)

years <- floor(times)
years <- factor(years, ordered = TRUE )


months <- factor (
  month.abb[cycle(times)],
  levels = month.abb,
  ordered = TRUE
  )

seatbelts_df <- data.frame(
  year = years,
  month = months, 
  time = as.numeric(times),
  killed = as.numeric(Seatbelts[,1]),
  total = as.numeric(Seatbelts[,2]),
  front = as.numeric(Seatbelts[,3]),
  rear = as.numeric(Seatbelts[,4]),
  kms = as.numeric(Seatbelts[,5]),
  Gas = as.numeric(Seatbelts[,6]),
  law = as.numeric(Seatbelts[,8]),
  percentage = (seatbelts_df$killed/seatbelts_df$total)*100 
  
)


