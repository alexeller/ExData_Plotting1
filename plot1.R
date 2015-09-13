library(sqldf)

# guard against downloading/unziping the file every run
if(!file.exists("xdata-data-household_power_consumption.zip")){
    download.file(url='https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', destfile='xdata-data-household_power_consumption.zip', method='curl')
}

if(!file.exists("household_power_consumption.txt")){
    unzip("./xdata-data-household_power_consumption.zip")
}

# only read in the data for the days needed
data <- read.csv.sql("household_power_consumption.txt", sql = 'select * from file where strftime(Date) = "1/2/2007" or strftime(Date) = "2/2/2007" and Date IS NOT \"?\" and Global_active_power IS NOT \"?\"', header = TRUE, sep = ";")

# open png to write the plot to
png("plot1.png", width=480, height=480)

# make the plot
hist(data$Global_active_power, xlab="Global Active Power (kilowatts)", col="red", main="Global Active Power")

# close the plot file
dev.off()

