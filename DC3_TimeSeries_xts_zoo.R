cat("\014")
rm(list=ls())

# xts and zoo
library(xts)
# xts = matrix + time
# data + an array of times

# X <- xts(x, order.by = idx)
# coredata()
# index()
# as.xts()

data("sunspots")

sunspots_xts <-as.xts(sunspots)
class(sunspots_xts)
head(sunspots_xts)
tail(sunspots_xts)

# read.table() read.csv() read.zoo()
# write.zoo() saveRDS()

# subsetting by time ISO 8601:2004 - "YYYY-MM-DDTHH:MM:SS" format
# time based queries

# Load Fund data
data(edhec, package = "PerformanceAnalytics")

head(edhec["2007-01", 1])
head(edhec["2007-01/2007-03", 1])
# shortcut
head(edhec["2007-01/03", 1])

# T/T for times

#subseting by rows
#which.i = TRUE integer vector
x[index(x) >= '2016-05-01']

#head()
#tail()
#first()
#last()
#edhec

lastweek <- last(edhec, "1 week")
lastweek

first(last(edhec, "2 weeks"),"3 days")

# Math operations in xts  ops behavior
# xts is a matrix
# times are used different from normal r
# 

# Merging time series
# cbind() merge()  inner, outer, left and right joins, outer is default
# merge(..., fill = NA, join = "outer") fill argument handles missingness
# rbind() must have times and the same number of columns

# missing values

# apply l.o.c.f last observation carried forwardsolve
na.locf()
# interpolate linear
na.approx()

# Fill missing values in temps using the last observation
temps_last <- na.locf(temps)
temps
# Fill missing values in temps using the next observation
temps_next <- na.locf(temps, fromLast= TRUE)

#Lags and difference operators, Seasonality and stationarity

#lag() backward or forward

# Create a leading object called lead_x
lead_x <- lag(x, k = -1)
lead_x
# Create a lagging object called lag_x
lag_x <- lag(x, k = 1)

# Merge your three series together and assign to z
z <- merge(lead_x,x,lag_x)

# diff()

# Calculate the first difference of AirPass and assign to diff_by_hand
diff_by_hand <- AirPass - lag(AirPass,k=1)

# Use merge to compare the first parts of diff_by_hand and diff(AirPass)
merge(head(diff_by_hand), head(diff(AirPass, differences=1)))

# Calculate the first order 12 month difference of AirPass
diff(AirPass, lag = 12, differences = 1)

# aggregation

#period.apply()
#endpoints()
#split()
#lapply()

#converting periodicity  high low open close
#to.period()
#to.quarterly()

#Rolling functions  cumsum(), cumprod(), cummin(), cummax()


#Index, Attributes, and Timezones
#tclass tzone 
help(OlsonNames)


#Periods, periodicity(),













