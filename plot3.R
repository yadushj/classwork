## set and identify source of data for the plot
## ensure ggplot 2 is loaded
library(ggplot2)

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

##subset for only Baltimore City
baltPM25data <- subset(pm25data, fips == "24510")
##create totals for plotting
totals <- aggregate(baltPM25data[c("Emissions")], list(type=baltPM25data$type, year=baltPM25data$year), sum)

png("plot3.png", width = 480, height = 480)

## create and smooth the lines of the four types over time assign each a color
plotdata <- ggplot(totals, aes(x=year, y=Emissions, colour = type)) + geom_point(alpha=0.1) + geom_smooth(method="loess") + ggtitle("PM2.5 emissions in Baltimore City by Type")
                                                                                   
print(plotdata)

## important!! close the device
dev.off()