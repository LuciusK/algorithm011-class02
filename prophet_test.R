

mydata <- read.table("C:/Users/steven/Desktop/BTCUSD1440.csv",sep=',')
mydata
class(mydata)
data <- mydata[,1]
data1 <- as.character(data)

b <- NULL
q=1
for(i in data1){
  l <-  substring(i,1,4)
  m <-  substring(i,6,7)
  n <-  substring(i,9,10)
  s <- c(l,m,n)
  t <- paste(s,collapse='-')
  b[q] <- t
  q=q+1
}
ds <- b

y <- mydata[,2]


BTCUSD <- data.frame(ds, y)


library(prophet)
m <- prophet(BTCUSD, daily.seasonality=TRUE)

future <- make_future_dataframe(m, periods = 180)
tail(future)


forecast <- predict(m, future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])

plot(m, forecast)


prophet_plot_components(m, forecast)


dyplot.prophet(m, forecast)

