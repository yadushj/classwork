## set and identify source of data for the plot
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
sources <- "Source_Classification_Code.rds"

pm25data <- readRDS(emissions)
codes <-readRDS(sources)

##merge the two sets of data by the source code
mergedpm25data <- merge(pm25data, codes, by = "SCC")

##subset the data for only Baltimore and Los Angeles
subsetpm25data <- mergedpm25data[(mergedpm25data$fips == "24510" | mergedpm25data$fips == "06037") & mergedpm25data$type == "ON-ROAD", ]

totals <- aggregate(Emissions ~ year + fips, subsetpm25data, sum)
##assign city names 
totals$fips[totals$fips == "24510"] <- "Baltimore"
totals$fips[totals$fips == "06037"] <- "Los Angeles"

png("plot6.png", width = 1060, height = 480)

g <- ggplot(totals, aes(factor(year), Emissions))
g <- g + facet_grid(. ~fips)
g <- g + geom_bar(stat = "identity") + xlab("year") + ylab("Emissionsn(in Tons") + ggtitle("2 City Comparison of Vehicle PM2.5 emissions over time") +
        theme(plot.title = element_text(hjust = 0.5))
print(g)

## important!! close the device
dev.off()