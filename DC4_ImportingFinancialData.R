# Course 4, Importing and Managing Financial Data in R
rm(list=ls())
cat("\014")

library(quantmod)

# [1.1] Introduction  getSymbols() stores data as xts

help("getSymbols")
help("OHLC.Transformations")

getSymbols(Symbols = "AAPL", src = "yahoo")
getSymbols("AAPL")
head(AAPL)

# auto.assign = TRUE is default, if FALSE you need to use assignment
getSymbols("AAPL", auto.assign = TRUE)
# is the same as, remember R is case sensitive
aapl <- getSymbols("AAPL", auto.assign = FALSE)

# practice

getSymbols("CAB",auto.assign = TRUE, src="google")
str(CAB)
head(CAB)
last(CAB)
getSymbols("QQQ",auto.assign = TRUE, src="google")
str(QQQ)
head(QQQ)
last(QQQ)
getSymbols( c("GDP", "GDPC1"), auto.assign = TRUE, src="FRED")
str(c(GDP, GDPC1))
head(GDP)
last(GDP)
last(GDPC1)
# auto.assign = FALSE, functionally equivalent to env = NULL, but use the first
spy <- getSymbols("SPY", auto.assign = FALSE)
str(spy)
head(spy)
jnj <- getSymbols("SPY", env = NULL)
str(jnj)
head(jnj)

# [1.2] Introduction to Quandl   https://www.quandl.com/

##Quandl() API returns a data.frame by default
library(Quandl)

# always use an assignment statement
dgs10 <- Quandl(code = "FRED/DGS10", type = "xts")
str(dgs10)
head(dgs10)
# Import GDP data from FRED as xts
gdp_xts <- Quandl(code = "FRED/GDP", type = "xts")
str(gdp_xts)
head(gdp_xts)
# Import GDP data from FRED as zoo
gdp_zoo <- Quandl(code = "FRED/GDP", type = "zoo")
str(gdp_zoo)
head(gdp_zoo)

# [1.3] Finding and downloading data from the internet, look for the download link, sometimes download is not available

# Exchange Rate data, https://www.oanda.com/currency/live-exchange-rates/

# list of currency symbols
quantmod::oanda.currencies

# Practice
# Create an object containing the Pfizer ticker symbol
symbol <- "PFE"
# Use getSymbols to import the data
getSymbols(symbol,auto.assign = TRUE, src="google")
# Look at the first few rows of data
head(PFE)

# Create a currency_pair object
currency_pair <- "CAD/GBP"
getSymbols(currency_pair, auto.assign = TRUE, src="oanda")
str(CADGBP)
# from 190 days ago?, Oanda provides only 180 days
#getSymbols(currency_pair, from = Sys.Date() - days(160), to = Sys.Date(), src = "oanda")
getSymbols(currency_pair, from = Sys.Date() - 190, to = Sys.Date(), src = "oanda")
str(CADGBP)

library(lubridate)
Sys.Date() - days(190)

# Create a series_name object
series_name <- "UNRATE"
# Load the data using getSymbols
getSymbols( series_name, auto.assign = TRUE, src="FRED")
# Create a quandl_code object
quandl_code <- "FRED/UNRATE"
# Load the data using Quandl
unemploy_rate <- Quandl(code = quandl_code )

# [2.1] Extracting and transforming, extracting specific columns

# OHLC Volume - quantmod package functions first two letters of the column
# Op() Hi() Lo() CL() Vo() Ad()

#getPrice(x, symbol, prefer = )

head(aapl)
aapl_cl <- getPrice(aapl, prefer = "close")
head(aapl_cl)

aapl_cl <- Cl(aapl)
head(aapl_cl)

# Extract the high, low, and close columns
aapl_hlc <- HLC(aapl)
# Look at the head of dc_hlc
head(aapl_hlc)
# Extract the open, high, low, close, and volume columns
aapl_ohlcv <- OHLCV(aapl)
# Look at the head of dc_ohlcv
head(aapl_ohlcv)

# Download CME data for CL and BZ as an xts object
oil_data <- Quandl(code = c("CME/CLH2016", "CME/BZH2016"), type = "xts")
# Look at the column names of the oil_data object
colnames(oil_data)
# Extract the Open price for CLH2016
cl_open <- getPrice(oil_data, symbol = "CLH2016", prefer = "Open$")
# Look at January, 2016 using xts' ISO-8601 subsetting
cl_open["2016-01"]


# [2.2] Importing and transforming multiple instruments

# Download instruments into a custom environment
data_env <- new.env()
getSymbols(c("SPY","QQQ"), env = data_env, auto.assign=TRUE )
head(data_env$SPY)

# using lapply() and do.call()

adjusted_list <- lapply(data_env, Ad)
adjusted <- do.call(merge, adjusted_list)
head(adjusted)

# Practice

quandl_codes <- c("CME/CLH2016","CME/BZH2016")
qtr_price <- Quandl(quandl_codes, type="xts", collapse="quarterly" )
# View the high prices for both series
Hi(qtr_price)

qtr_return <- Quandl(code=quandl_codes, type="xts", collapse="quarterly", transform = "rdiff" )
getPrice(qtr_return, prefer="Settle")

# Call head on each object in data_env using eapply
data_list <- eapply(data_env, head)
data_list
# Merge all the list elements into one xts object
data_merged <- do.call(merge, data_list)
data_merged
# Ensure the columns are ordered: open, high, low, close
data_ohlc <- OHLC(data_merged)

# Symbols
symbols <- c("AAPL", "MSFT", "IBM")
# Create new environment
data_env <- new.env()
# Load symbols into data_env
getSymbols(symbols, env=data_env)
# Extract the close column from each object and combine into one xts object
close_data <- do.call(merge, eapply(data_env, Cl))
# View the head of close_data
head(close_data)



# [3.1] Setting default arguments for getSymbols() to customize default arguments [ name value pairs ]

setDefaults(getSymbols, src = "FRED")
gdp <- getSymbols("GDP", auto.assign = FALSE)
str(gdp)

setDefaults(getSymbols, src = "yahoo")

# to see the defaults
args(getSymbols.yahoo)
help("getSymbols.yahoo")

setDefaults(getSymbols.yahoo, from="2016-01-01", to="2016-12-31")
aapl <- getSymbols("AAPL", auto.assign = FALSE)
str(aapl)

# to see user defined defaults
getDefaults()
getDefaults(getSymbols.yahoo)
setDefaults(load, file = "my_file.RData")
getDefaults(load) #will not alter behavior

##practice
# Set the default to pull data from Google Finance
setDefaults(getSymbols, src = "google")
getSymbols("GOOG")
str(GOOG)

# Look at getSymbols.yahoo arguments
args(getSymbols.yahoo)
setDefaults(getSymbols.yahoo, from = "2000-01-01")
# Confirm defaults were set correctly
getDefaults("getSymbols.yahoo")

# [3.2] Setting per-instrument default arguments in getSymobols()

setSymbolLookup(AAPL="google")
setSymbolLookup(MSFT = list(src = "google", from = "2016-01-01"))
msft <- getSymbols("MSFT", auto.assign = FALSE)
str(msft)

# Look at the first few rows of CP
head(CP)
# Set the source for CP to FRED
setSymbolLookup(CP="FRED")
# Load CP data again
CP <- getSymbols("CP",auto.assign=FALSE)
# Look at the first few rows of CP
head(CP)

# Save symbol lookup table
setSymbolLookup(AAPL="google")
saveSymbolLookup("my_symbol_lookup.rda")
# Set default source for CP to "yahoo"
setSymbolLookup(CP="yahoo")
# Verify the default source is "yahoo"
getSymbolLookup("CP")
# Load symbol lookup table
loadSymbolLookup("my_symbol_lookup.rda")
# Verify the default source is "FRED"
getSymbolLookup("CP")

getSymbolLookup()
saveSymbolLookup("symbol_lookup.rda")
setSymbolLookup(AAPL=NULL, MSFT=NULL)

getSymbolLookup()
loadSymbolLookup("symbol_lookup.rda")
getSymbolLookup()

# [3.3] Handling instrument symbols that clash or are not valid R object names

# valid R names can contain letters, numbers, ., and _ and start with a letter or period followed by non-number

getSymbols("^GSPC")   # S&P 500 Index
head(GSPC)

getSymbols("000001.SS", auto.assign = TRUE)  #Shanghai index
head(000001.SS)
# so use
head("000001.SS", n = 3)
head(get("000001.SS"), n = 3)

sse <- getSymbols("000001.SS", auto.assign = FALSE)
head(sse)
# so use
colnames(sse) <-paste("SSE", c("Open", "High", "Low", "Close", "Volume", "Adjusted"), sep = ".")
head(sse)
# to map a valid symbol name to replace and invalid symbol name use
setSymbolLookup(SSE = list(name = "000001.SS"), FORD = list(name = "F"))
getSymbols(c("SSE", "FORD"))
colnames(SSE) <-paste("SSE", c("Open", "High", "Low", "Close", "Volume", "Adjusted"), sep = ".")
colnames(FORD) <-paste("FORD", c("Open", "High", "Low", "Close", "Volume", "Adjusted"), sep = ".")
head(SSE)
head(FORD)

# practice
getSymbols("BRK-A")
head(`BRK-A`)
BRK.A <- get(getSymbols("BRK-A"))
head(BRK.A)

BRK.A <- getSymbols("BRK-A", auto.assign = FALSE)
head(BRK.A)
col_names <- colnames(BRK.A) 
# Set BRK.A column names to syntactically valid names
col_names <- make.names(col_names)
names(BRK.A) <- make.names(col_names)
colnames(BRK.A) <- make.names(col_names)
head(BRK.A)

# [4.1] Creating regularly time-spaced data out of irregular, making irregular data regular
library(xts)

from_date <- as.Date("2017-01-01")
to_date <- as.Date("2017-01-03")
date_seq <- seq(from = from_date, to = to_date, by = "day")

regular_xts <- xts(seq_along(date_seq), order.by = date_seq)
start(regular_xts)
end(regular_xts)
seq(from = start(regular_xts), to = end(regular_xts), by = "day")

# zero width xts object
zero_width_xts <- xts(, order.by = date_seq)
zero_width_xts
str(zero_width_xts)

irregular <- xts(c(20.01, 20.02, 20.05), order.by = as.Date(c("2017-01-02", "2017-01-04", "2017-01-10")))
colnames(irregular) <- c("Price")
irregular
date_seq <- seq(from = start(irregular), to = end(irregular), by = "day")
regular_xts <- xts(, date_seq)
merge(irregular, regular_xts)

# to replace missing values
merge(irregular, regular_xts, fill= na.locf)

# practice
irregular_xts <- irregular
# Extract the start date of the series
start_date <- start(irregular_xts)
# Extract the end date of the series
end_date <- end(irregular_xts)
# Create a regular date sequence
regular_index <- seq(from = start_date, to = end_date, by = "day")
# Create a zero-width xts object
regular_xts <- xts(, regular_index)

# [4.2] Aggregating to lower frequency
library(zoo)

getSymbols(c("FEDFUNDS", "DFF"), src = "FRED")
# Aggregate DFF to monthly
monthly_fedfunds <- apply.monthly(DFF, FUN = "mean")
# Convert index to yearmon
index(monthly_fedfunds) <- as.yearmon(index(monthly_fedfunds))
# Merge FEDFUNDS with the monthly aggregate
merged_fedfunds <- merge(FEDFUNDS, monthly_fedfunds)
# Look at the first few rows of the merged object
head(merged_fedfunds)

# Look at the first few rows of merged_fedfunds
head(merged_fedfunds)
# Fill NA forward
merged_fedfunds_locf <- na.locf(merged_fedfunds)
head(merged_fedfunds_locf)
# Extract index values containing last day of month
aligned_last_day <- merged_fedfunds_locf[index(monthly_fedfunds)]
head(aligned_last_day)
# Fill NA backward
merged_fedfunds_locb <- na.locf(merged_fedfunds, fromLast = TRUE)
# Extract index values containing first day of month
aligned_first_day <- merged_fedfunds_locb[index(FEDFUNDS)]
head(aligned_first_day)

# Extract index weekdays
index_weekdays <- .indexwday(DFF)
# Find locations of Wednesdays
wednesdays <- which(index_weekdays == 3)
# Create custom end points
end_points <- c(0, wednesdays, nrow(DFF))
# Calculate weekly mean using custom end points
weekly_mean <- period.apply(DFF, end_points, mean)
head(weekly_mean)

# [4.3] intra-day data 

# Create a regular date-time sequence
regular_index <- seq(as.POSIXct("2010-01-04 09:00"), as.POSIXct("2010-01-08 16:00"), by = "30 min")
# Create a zero-width xts object
regular_xts <- xts(, order.by = regular_index)
# Merge irregular_xts and regular_xts, filling NA with their previous value
merged_xts <- merge(irregular_xts, regular_xts, fill= na.locf)
# Subset to trading day (9AM - 4PM)
trade_day <- merged_xts["T09:00/T16:00"]

# Split trade_day into days
daily_list <- split(trade_day , f = "days")
# Use lapply to call na.locf for each day in daily_list
daily_filled <- lapply(daily_list, FUN = na.locf)
# Use do.call to rbind the results
filled_by_trade_day <- do.call(rbind, daily_filled)

# Convert raw prices to 5-second prices
xts_5sec <- to.period(intraday_xts, period = "seconds", k = 5)
# Convert raw prices to 10-minute prices
xts_10min <- to.period(intraday_xts, period = "minutes", k = 10)
# Convert raw prices to 1-hour prices
xts_1hour <- to.period(intraday_xts, period = "hours", k = 1)

# [5.1] importing text files








