data <- read.csv("household_power_consumption.txt", sep=";", 
                 colClasses=c("character"), header=TRUE)
keep.rows <- which(data$Date=="1/2/2007"|data$Date=="2/2/2007")
col.names <- names(data)
data <- read.csv("household_power_consumption.txt", sep=";", 
                 colClasses="character", skip=keep.rows[1], nrows=length(keep.rows),
                 header=FALSE)
names(data) <- col.names
str(data)

data$datetime <- paste(data$Date, data$Time, sep=" ")
data$datetime <- strptime(data$datetime, "%d/%m/%Y %H:%M:%S")
data$Date <- strptime(data$Date, "%d/%m/%Y")
data$Time <- strptime(data$Time, "%H:%M:%S")
data$Global_active_power <- as.numeric(data$Global_active_power)
data$Global_reactive_power <- as.numeric(data$Global_reactive_power)
data$Voltage <- as.numeric(data$Voltage)
data$Global_intensity <- as.numeric(data$Global_intensity)
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)

str(data)
summary(data)

start <- strptime("2007-02-01", "%Y-%m-%d")
end <- strptime("2007-02-02", "%Y-%m-%d")

data <- data[data$Date >= start & data$Date <= end,]
data$Time$year <- data$Date$year
data$Time$mon <- data$Date$mon
data$Time$day <- data$Date$day

png(file="plot4.png", width = 480, height = 480)
par(mfrow=c(2,2))

with(data, plot(datetime, Global_active_power, type="l", 
                ylab="Global Active Power (kilowatts)", xlab=""))

with(data, plot(datetime, Voltage, type="l"))

with(data, {
      plot(datetime, Sub_metering_1, type="l", ylim=c(0,40),
           ylab="Energy sub metering", xlab="")
      par(new=TRUE)
      plot(datetime, Sub_metering_2, type="l", col="red", ylab="", xlab="", ylim=c(0,40))
      par(new=TRUE)
      plot(datetime, Sub_metering_3, type="l", col="blue", ylab="", xlab="", ylim=c(0,40))
      par(new=TRUE)
      legend("topright", lty=c(1,1,1), col=c("black", "red", "blue"), 
             c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), bty="n")
})

with(data, plot(datetime, Global_reactive_power, type="l"))
dev.off()