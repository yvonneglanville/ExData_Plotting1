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
DateANDTime <- as.data.frame(as.POSIXct(paste(TwoDaysofData$Date, TwoDaysofData$Time), 
                                        format = "%Y-%m-%d %H:%M:%S"))
names(DateANDTime) <- "DateAndTime"
SetofData <- cbind(DateANDTime, TwoDaysofData)


SetofData$Day <- weekdays(SetofData$DateAndTime)
SetofData$DayNum <- as.POSIXlt(DateANDTime$DateAndTime)$wday
SetofData$DayNum <- as.numeric(SetofData$DayNum)

## Save plot to png file
png("Plot3.png",width = 480, height = 480, units = "px")
## plots 3 line graphs metering
## The x-axis labels are placed so the days of the week
## with the are shown 
plot(SetofData$Sub_metering_1,  type = "l",
     xaxt ="n", ann =FALSE)
lines(SetofData$Sub_metering_2, col = "red")
lines(SetofData$Sub_metering_3, col = "blue")
xValues <- c(0,1441,2880)
xLabels <- c("Thu", "Fri", "Sat")
title(ylab = "Energy sub metering")
axis(1, at = xValues, labels = xLabels)
axis(2, tick = TRUE, tck =-0.05)

legend("topright", y = NULL, c("sub_metering_1", "sub_metering_2", "sub_metering_3"),
       col = c(1,2,4), lty = 1 )

dev.off()

