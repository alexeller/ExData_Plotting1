library(sqldf)

# guard against downloading/unziping the file every run
if(!file.exists("xdata-data-household_power_consumption.zip")){
    download.file(url='https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', destfile='xdata-data-household_power_consumption.zip', method='curl')
}

if(!file.exists("household_power_consumption.txt")){
    unzip("./xdata-data-household_power_consumption.zip")
}

# only read in the data for the days needed
data <- read.csv.sql("household_power_consumption.txt", sql = 'select * from file where (strftime(Date) = "1/2/2007" or strftime(Date) = "2/2/2007") and Date IS NOT \"?\" and Global_active_power IS NOT \"?\"', header = TRUE, sep = ";")

# add a datetime to plot by
data$goodDate<-strptime(paste(data$Date, data$Time, sep=" "), format="%d/%m/%Y %H:%M:%S")

# open png to write the plot to
png("plot4.png", width=480, height=480)

# setup for 2x2 plots, 4 plots on a page
par(mfcol = c(2,2))

# top left plot
plot(data$goodDate,data$Global_active_power, ylab="Global Active Power", type="l", xlab="")

# bottom left plot
plot(data$goodDate, data$Sub_metering_1, xlab="", ylab="Energy sub metering", type="l")
lines(data$goodDate, data$Sub_metering_2, col="red")
lines(data$goodDate, data$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty="n", lty=c(1,1,1), lwd=c(1,1,1), col=c("black", "red", "blue"))

# top right plot
plot(data$goodDate,data$Voltage, ylab="Voltage", type="l", xlab="datetime")

#bottom right
plot(data$goodDate,data$Global_reactive_power, ylab="Global_reactive_power", type="l", xlab="datetime")

dev.off()

