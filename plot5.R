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
sources <- "Source_Classification_Code.rds"

pm25data <- readRDS(emissions)
codes <-readRDS(sources)

##subset for only Baltimore City
baltPM25data <- subset(pm25data, fips == "24510")


##merge the two sets of data by the source code
mergeBaltPM25data <- merge(baltPM25data, codes, by="SCC")

vehiclePM25data <-grep("vehicle", mergeBaltPM25data$SCC.Level.Two, ignore.case = TRUE)
finaldf <- mergeBaltPM25data[vehiclePM25data, ]


totals <- aggregate(Emissions~year, finaldf, sum)

png("plot5.png", width = 480, height = 480)

barplot(totals$Emissions, names.arg = totals$year,  xlab = "year", ylab = "PM2.5 Emissions (in tons)", main = "Baltimore City Motor Vehicle PM2.5 emissions over time")

## important!! close the device
dev.off()