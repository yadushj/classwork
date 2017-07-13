## set and identify source of data for the plot

sourceRecords <- "emissions.zip"
sourceUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

## check if file is already present
if (!file.exists(sourceRecords)) {
        download.file(sourceUrl,sourceRecords)
}

## check if first file has been de-compressed or not
if (!file.exists("Source_Classification_Code.rds")){
        unzip(sourceRecords)
}

emissions <- "summarySCC_PM25.rds"

pm25data <- readRDS(emissions)
totals <- aggregate(Emissions~year, pm25data, sum)

png("plot1.png", width = 480, height = 480)

barplot(totals$Emissions, names.arg = totals$year,  xlab = "year", ylab = "PM2.5 Emissions (in tons)", main = "PM2.5 total emissions over time")

## important!! close the device
dev.off()