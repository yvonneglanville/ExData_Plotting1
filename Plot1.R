########################### Steps to reproduce plots ##########################
## 1. Set working directory to the folder, which holds the data
## 2. Load the following libraries: sqldf, chron
## 3. Highlight code and run to produce plots


## Reads in data using sqldf package so that only dates of interest are choosen
## Reads in each date as a table then binds the rows of the tables
data <- read.csv.sql("household_power_consumption.txt", 
                    sql = 'select * from file where Date = "1/2/2007" ',
                    header = TRUE, sep = ";")
data1 <- read.csv.sql("household_power_consumption.txt", 
                    sql = 'select * from file where Date = "2/2/2007" ',
                    header = TRUE, sep = ";")
closeAllConnections()
TwoDaysofData <- rbind(data, data1)
##############################################################################
## Converts each column to the appropriate class
TwoDaysofData$Date <- as.POSIXct(TwoDaysofData$Date, format= '%d/%m/%Y')
TwoDaysofData$Time <- times(TwoDaysofData$Time)
## Histogram plot of Frequency vs Global Active Power in kilowatts
png("Plot1.png",width = 480, height = 480, units = "px")
hist(TwoDaysofData$Global_active_power,freq = TRUE, axes=FALSE, main="Global Active Power",
        xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")
xValues <- c(0,2,4,6)
xLabels <- c("0", "2", "4", "6")
yValues <- c(0, 200, 400, 600, 800, 1000, 1200)
yLabels <- c("0", "200", "400", "600", "800", "1000", "1200")
axis(1, at = xValues, labels = xLabels,tck=-0.05)
axis(2, las = 2, at=yValues, labels = yLabels, tck =-0.05)
dev.off()

