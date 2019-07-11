xts and zoo

# Introducing time based queries

# Select all of 2016 from x

x_2016 <- x["2016"]


# Select January 1, 2016 to March 22, 2016

jan_march <- x["2016/2016-03-22"]

# Verify that jan_march contains 82 rows

82 == length(jan_march)

# Extract all data from irreg between 8AM and 10AM
morn_2010 <- irreg["T08:00/T10:00"]


# Extract the observations in morn_2010 for January 13th, 2010
morn_2010["2010-01-13"]

# Alternative Extraction Techniques

# Subset x using the vector dates
x[dates]


# Subset x using dates as POSIXct

x[as.POSIXct(dates)]

# Replace the values in x contained in the dates vector with NA

x[dates] <- NA


# Replace all values in x for dates starting June 9, 2016 with 0

x[index(x) >= "2016-06-09"] <- 0
# Verify that the value in x for June 11, 2016 is now indeed 0

x["2016-06-11"]

# Methods to find periods in data

# Create lastweek using the last 1 week of temps

lastweek <- last(temps, "1 week")
lastweek

# Print the last 2 observations in lastweek
last(lastweek,n = 2)
# Extract all but the first two days of lastweek

first(lastweek, "-2 days")

# Extract the first three days of the second week of temps

first(last(temps, "2 weeks"),"3 days")

# Math Operations, xts is a matrix, times make is different than normal matrix

# Add a and b

a + b


# Add a with the numeric value of b

a + as.numeric(b)

# Add a to b, and fill all missing rows of b with 0

a + merge(b, index(a), fill = 0)


# Add a to b and fill NAs with the last observation

a + merge(b, index(a), fill = na.locf)

## Chapter 3, Merging Time Series
# joins inner-intersection, outer-union

# Perform an inner join of a and b

merge(a, b, join = "inner")


# Perform a left-join of a and b, fill missing values with 0

merge(a, b, join = "left", fill = 0)

# Row bind temps_june30 to temps, assign this to temps2

temps2 <- rbind(temps, temps_june30)
temps2
# Row bind temps_july17 and temps_july18 to temps2, call this temps3

temps3 <- rbind(temps2,temps_july17,temps_july18)

# Handling missingness, locf last observastion carried forward

# maxgap argument !!

# Fill missing values in temps using the last observation

temps_last <- na.locf(temps)


# Fill missing values in temps using the next observation

temps_next <- na.locf(temps, fromLast = TRUE)

# Interpolate NAs using linear approximation

AirPass
na.approx(AirPass)

# Lags and differences

# Create a leading object called lead_x

lead_x <- lag(x, k = -1)


# Create a lagging object called lag_x
lag_x <- lag(x, k = 1)


# Merge your three series together and assign to z

z <- merge(lead_x, x, lag_x)
z

# Calculate the first difference of AirPass and assign to diff_by_hand

diff_by_hand <- AirPass - lag(AirPass,k=1)


# Use merge to compare the first parts of diff_by_hand and diff(AirPass)

merge(head(diff_by_hand), head(diff(AirPass, differences=1)))


# Calculate the first order 12 month difference of AirPass

diff(AirPass, lag = 12, differences = 1)


## Chapter 4 Apply functions by time

# Locate the weeks

endpoints(temps, on = "weeks")


# Locate every two weeks

endpoints(temps, on = "weeks", k = 2)

# Calculate the weekly endpoints

ep <- endpoints(temps, on = "weeks")
# Now calculate the weekly mean and display the results

period.apply(temps[, "Temp.Mean"], INDEX = ep, FUN = mean)

# Split temps by week

head(temps)

temps_weekly <- split(temps, f = "weeks")

temps_weekly

# Create a list of weekly means, temps_avg, and print this list

temps_avg <- lapply(X = temps_weekly, FUN = mean)

temps_avg

# Use the proper combination of split, lapply and rbind

temps_1 <- do.call(rbind, lapply(split(temps, "weeks"), function(w) last(w, n = "1 day")))

temps_1

# Create last_day_of_weeks using endpoints()

last_day_of_weeks <- endpoints(temps,"weeks")
last_day_of_weeks 

# Subset temps using last_day_of_weeks 

temps_2 <- temps[last_day_of_weeks,]

temps_2

# Converting periodicity

# Convert usd_eur to weekly and assign to usd_eur_weekly

usd_eur_weekly <- to.period(usd_eur, period = "weeks")


# Convert usd_eur to monthly and assign to usd_eur_monthly

usd_eur_monthly <- to.period(usd_eur, period = "months")


# Convert usd_eur to yearly univariate and assign to usd_eur_yearly

usd_eur_yearly <- to.period(usd_eur, period = "years", OHLC = FALSE)

# Convert eq_mkt to quarterly OHLC

mkt_quarterly <- to.period(eq_mkt, period = "quarters")


# Convert eq_mkt to quarterly using shortcut function

mkt_quarterly2 <- to.quarterly(eq_mkt, name = 'edhec_equity', indexAt ="firstof")

# Rolling functions

# Split edhec into years

edhec
edhec_years <- split(edhec , f = "years")


# Use lapply to calculate the cumsum for each year in edhec_years

edhec_ytd <- lapply(edhec_years, FUN = cumsum)


# Use do.call to rbind the results

edhec_xts <- do.call(rbind, edhec_ytd)



# Use rollapply to calculate the rolling 3 period sd of eq_mkt

eq_sd <- rollapply(eq_mkt, 3, FUN = sd)


## Chapter 5 Index, attributes, and time zones

# sprintf syntax   "%b %d, %Y"

# View the first three indexes of temps

index(temps)[1:3]


# Get the index class of temps

indexClass(temps)


# Get the timezone of temps

tzone(temps)


# Change the format of the time display

indexFormat(temps) <- "%b-%d-%Y"


# View the new format

temps

# Construct times_xts with tzone set to America/Chicago

times_xts <- xts(1:10, order.by = times, tzone = "America/Chicago")


# Change the time zone of times_xts to Asia/Hong_Kong

tzone(times_xts) <- "Asia/Hong_Kong"
  

# Extract the current time zone of times_xts

tzone(times_xts)

# Periods, periodicity, and Timestamps

#align.time(x, n=60) minutes,  n=3600 hourly

# Calculate the periodicity of temps

periodicity(temps)


# Calculate the periodicity of edhec

periodicity(edhec)


# Convert edhec to yearly

edhec_yearly <- to.yearly(edhec)


# Calculate the periodicity of edhec_yearly

periodicity(edhec_yearly)

# Count the months

nmonths(edhec)


# Count the quarters

nquarters(edhec)


# Count the years

nyears(edhec)

# Explore underlying units of temps in two commands: .index() and .indexwday()

.index(temps)

.indexwday(temps)


# Create an index of weekend days using which()

index <- which(.indexwday(temps) == 0 | .indexwday(temps) == 6)

temps

# Select the index

temps[which(.indexwday(temps) == 0 | .indexwday(temps) == 6)]


# Make z have unique timestamps

z_unique <- make.index.unique(z, eps = 1e-4)

z_unique

# Remove duplicate times in z

z_dup <- make.index.unique(z, drop = TRUE)


# Round observations in z to the next hour

z_round <- align.time(z, n = 3600)












