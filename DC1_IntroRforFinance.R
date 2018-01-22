# Intro to R for Finance

# [1] The Basics

1 + 2

# Variables or objects
my_number <- 5
my_number

#Arithmetic in R
dan <- 100
rob <- 50
dan + rob

# R Scripts

# Financial Returns
# stock Returns, growth rates or return multiplier
starting_cash <- 100
interest_rate <- 5
mult <- 1 + interest_rate / 100
new_cash <- starting_cash * mult
# Multiple periods
jan_ret <- 5
jan_mult <- 1 + jan_ret / 100
feb_ret <- 10
feb_mult <- 1 + feb_ret / 100
new_cash <- starting_cash * jan_mult * feb_mult

# Basic data types
# Numeric
42.5
5L
# Character
"Hello World"
# Logical
TRUE
FALSE
# Variables and data types
answer <- TRUE
class(answer)
class(5)

# [2] Vectors and Matrices

# What is a vector
apple <- 159.4
apple_stock <- c(159.4, 160.3, 161.3)
apple_stock
is.vector(apple_stock)

# c()ombine
grocery <- c("apple", "orange", "cereal")
grocery

# vector names()

names(apple_stock) <- c("Monday", "Tuesday", "Wednesday")
apple_stock

# Vectors of 12 months of returns, and month names
ret <- c(5, 2, 3, 7, 8, 3, 5, 9, 1, 4, 6, 3)
months <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
# Add names to ret
names(ret) <- months
# Print out ret to see the new names!
ret

# Look at the data
apple_stock
# Plot the data points
plot(apple_stock)
# Plot the data as a line graph
plot(apple_stock, type = "l")

# Vector Manipulation
dan <- c(100, 200, 150)
rob <- c(50, 75, 100)
monthly_total <- dan + rob
monthly_total

sum(monthly_total)

# Operators +, -, * 

# Vector Subsetting
# First 6 months of returns
ret[1:6]
# Just March and May
ret[c("Mar","May")]
# Omit the first month of returns
ret[-1]

# Matrices

my_matrix <- matrix(c(2, 3, 4, 5), nrow=2, ncol=2)
my_matrix

my_matrix <- matrix(c(2, 3, 4, 5), nrow=2, ncol=2, byrow=TRUE)
my_matrix

# Matrix - a 2D vector  cbind() rbind()

micr <- c(59.20, 59.25, 60.22, 59.95, 60.00)
ebay <- c(17.44, 18.22, 19.11, 18.22, 19.00)

cbind(micr, ebay)

rbind(micr, ebay)

# cor()relation

cor(micr, ebay)

me_matrix <- cbind(micr, ebay)
cor(me_matrix)

# A vector of 9 numbers
my_vector <- c(1, 2, 3, 4, 5, 6, 7, 8, 9)
# 3x3 matrix
my_matrix <- matrix(data = my_vector, nrow = 3, ncol = 3)
# Print my_matrix
my_matrix
# Filling across using byrow = TRUE
matrix(data = c(2, 3, 4, 5), nrow = 2, ncol = 2, byrow = TRUE)

apple <- c(109.49, 109.90, 109.11, 109.95, 111.03)
ibm <- c(159.82, 160.02, 159.84, 160.35, 164.79)
# cbind the vectors together
cbind_stocks <- cbind(apple, ibm)
cbind_stocks
# rbind the vectors together
rbind_stocks <- rbind(apple,ibm,micr)
rbind_stocks

micr_ebay_matrix <- cbind(micr, ebay)
plot(micr_ebay_matrix)

stocks <- cbind(micr, ebay, apple)
stocks
# Third row
stocks[3,]
# Fourth and fifth row of the ibm column
stocks[c(4,5),2]
# apple and micr columns
stocks[,c(1,3)]

# [3] Data Frames

# [4] Factors

# [5] Lists










