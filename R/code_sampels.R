# atribute variable value

x <- c(1,2,3)
v <- 1:4
l <- list (2, "a", "b", TRUE)
m <- matrix(1:9, nrow = 3, ncol = 8)


#vector x <- c(3, 5, 1, 10, 12, 6) and I want to set all elements of this vector that are less than 6 to be equal to zero

x <- c(3, 5, 1, 10, 12, 6)
x[x < 6] <- 0

lst <- list('one','two','three')

# operator [
a <- lst[1]
class(a)
## returns "list"

a <- lst[[1]]
class(a)
## returns "character"


#DATAFRAMES - http://www.r-tutor.com/r-introduction/data-frame
#data frame is used for storing data tables. It is a list of vectors of equal length.
#For example, the following variable df is a data frame containing three vectors n, s, b.




# read a *.csv file
 file <- read.csv("hw1_data.csv")

#number of rows in data frame
nrow(file)

#show first two lines
file2lines <-read.csv("hw1_data.csv", nrows=2)

#last two lines
fileslastlines <- read.csv("hw1_data.csv", header=TRUE,skip = 153-2)

#last lines
tail(file)

#What is the value of Ozone in the 47th row
fileslastlines <- read.csv("hw1_data.csv", skip = 46)

#missing values from a colum
targetColumn <- file$Ozone
length(targetColumn[is.na(targetColumn)])

#What is the mean of the Ozone column in this dataset? Exclude missing values (coded as NA) 
mean(targetColumn, na.rm = "TRUE")

#Extract the subset of rows of the data frame where COL1 values are above 31 and COL2  values are above 90. What is the mean of Solar.R COL30 in this subset

varx <- subset(file, Ozone > 31 & Temp > 90)
mean(varx)
mean(varx$COL32)

#What is the mean of "COl1" when "COL2" is equal to 6
var3 <- subset(file, Month ==6)
mean(varx$COL1)

#maximum from a column
varx <- subset(file, Month ==5)
max(varx$COLX, na.rm = "TRUE")
