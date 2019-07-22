# This script creates a PNG image with a histogram of the Global active power
# Import packages
library(zip)

# File names
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfilename <- "./powerConsumption.zip"
filename <- "./household_power_consumption.txt"
pngfile <- "./plot1.png"

# Download data
if(!file.exists(filename)) {
    download.file(url = fileUrl, destfile = zipfilename, method = "curl")
    downloadDate <- date()
    unzip(zipfilename)
}

# Read data (first 70000 rows contain 1-2/2/2007)
completedf <- read.table(file = filename, sep=";", header = TRUE,
                         stringsAsFactors = FALSE, nrows = 70000)

# Subset data 
df <- completedf[completedf$Date == "1/2/2007" | completedf$Date == "2/2/2007",]
names(df) <- names(completedf)

df$Global_active_power <- as.numeric(df$Global_active_power)

# Draw the histogram on screen
par(mfcol=c(1,1))
hist(df$Global_active_power, col = "red", xlab = "Global active power (kilowatts)", 
     main = "Global Active Power")

# Copy the histogram to a PNG file
dev.copy(png, filename = pngfile)
dev.off()
