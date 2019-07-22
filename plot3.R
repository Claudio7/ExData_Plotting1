# This script creates a PNG image with a graphics showing how the Global active power variates with time
# Import packages
library(zip)

# File names
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfilename <- "./powerConsumption.zip"
filename <- "./household_power_consumption.txt"
pngfile <- "./plot3.png"

# Download data
if(!file.exists(filename)) {
    download.file(url = fileUrl, destfile = zipfilename, method = "curl")
    downloadDate <- date()
    unzip(zipfilename)
}

# read data (first 70000 rows contain 1-2/2/2007)
completedf <- read.table(file = filename, sep=";", header = TRUE,
                         stringsAsFactors = FALSE, nrows = 70000)
df <- completedf[completedf$Date == "1/2/2007" | completedf$Date == "2/2/2007",]

names(df) <- names(completedf)

# Transform dates
df$DateTime <- paste(df$Date,df$Time)
df$DateTime <- strptime(df$DateTime, format = "%d/%m/%Y %H:%M:%S")

# Coerce data to numeric
df$Global_active_power <- as.numeric(df$Global_active_power)
df$Sub_metering_1 <- as.numeric(df$Sub_metering_1)
df$Sub_metering_2 <- as.numeric(df$Sub_metering_2)

# Draw the graphics on screen
par(mfcol=c(1,1))
plot(df$DateTime, df$Sub_metering_1, xlab = "", ylab="Energy sub metering", type = "n")
lines(df$DateTime, df$Sub_metering_1)
lines(df$DateTime, df$Sub_metering_2, col = "red")
lines(df$DateTime, df$Sub_metering_3, col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Copy the graphics to a PNG file
dev.copy(png, filename = pngfile)
dev.off()
