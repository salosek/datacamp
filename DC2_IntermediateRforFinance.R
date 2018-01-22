# [1] Dates

# [2] If Statements and Operators

# [3] Loops

# [4] Functions

# [5] Apply

#package 'xts' successfully unpacked and MD5 sums checked
#package 'TTR' successfully unpacked and MD5 sums checked
#package 'RColorBrewer' successfully unpacked and MD5 sums checked
#package 'dichromat' successfully unpacked and MD5 sums checked
#package 'munsell' successfully unpacked and MD5 sums checked
#package 'labeling' successfully unpacked and MD5 sums checked
#package 'rlang' successfully unpacked and MD5 sums checked
#package 'quadprog' successfully unpacked and MD5 sums checked
#package 'quantmod' successfully unpacked and MD5 sums checked
#package 'gtable' successfully unpacked and MD5 sums checked
#package 'reshape2' successfully unpacked and MD5 sums checked
#package 'scales' successfully unpacked and MD5 sums checked
#package 'tibble' successfully unpacked and MD5 sums checked
#package 'tseries' successfully unpacked and MD5 sums checked
#package 'fracdiff' successfully unpacked and MD5 sums checked
#package 'colorspace' successfully unpacked and MD5 sums checked
#package 'ggplot2' successfully unpacked and MD5 sums checked
#package 'lmtest' successfully unpacked and MD5 sums checked
#package 'zoo' successfully unpacked and MD5 sums checked
#package 'timeDate' successfully unpacked and MD5 sums checked
#package 'RcppArmadillo' successfully unpacked and MD5 sums checked
#package 'forecast' successfully unpacked and MD5 sums checked

sc <-200
jr <- 5
jm <- 1 + (jr/100)

class(sc)

#short cut one variable dataframe$variable

subset(cash,company=="b")
#factors
unique()
ordered(rank, ordered=TRUE, levels= c('low','medium','high'))
#Lists
list()
names()
split()
unsplit()
attributes()

#Intermediate R for Finance
#Dates - yearly to high frequency mili second
class(Sys.Date())
#number of days since Jan. 1 1970

?matrix
?Sys.time
?mean
install.packages("quantmod")
library(quantmod)
install.packages("tidyquant")
library(tidyquant)
apple <- tq_get("AAPL", get = "stock.prices", from = "2007-01-03", to = "2017-06-05")
head(apple)
plot(apple$date, apple$adjusted, type = "l")
apple <- tq_mutate(data = apple, ohlc_fun = Ad, mutate_fun = dailyReturn)
sorted_returns <- sort(apple$daily.returns)
plot(sorted_returns)

#apply over loops
lapply()
# Print stock_return
stock_return

# lapply to get the average returns
lapply(stock_return, FUN = mean)

# Sharpe ratio
sharpe <- function(returns) {
  (mean(returns) - .0003) / sd(returns)
}

# lapply to get the sharpe ratio
lapply(stock_return, FUN = sharpe)


sapply()

vapply()
