##load package for melt function
library(reshape2)

##  set and identify source of data

sourceRecords <- "source.zip"
sourceUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## for reproducability, check if the file
## is already present or not

if (!file.exists(sourceRecords)){
        download.file(sourceUrl, sourceRecords)
}

## check if already unzipped or not and decompress if necessart

if (!file.exists("UCI HAR dataset")){
        unzip(sourceRecords)
}

## read and load activity labels and features. Only need the second column for the labels 
## and feature commands. Ensure data is character type for labels

activities <- read.table("UCI HAR Dataset/activity_labels.txt")
activities[,2] <- as.character(activities[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

## parse the feature commands for mean and std dev
## by finding (grepping) and using metacharacters

feature_functs <- grep(".*mean.*|.*std.*", features[,2])
feature_functs.names <- features[feature_functs,2]


##fix any character vectors to normalize the text
feature_functs.names = gsub('-mean', 'Mean', feature_functs.names)
feature_functs.names = gsub('-std', 'Std', feature_functs.names)
feature_functs.names <- gsub('[-()]', '', feature_functs.names)

## load the data values from both the train and test data sets and bind the result

train <- read.table("UCI HAR Dataset/train/X_train.txt")
train_activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_subjects, train_activities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")
test_activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_activities, test)

## combine the test and train data
combineData <- rbind(train, test)
colnames(combinedData) <- c("subject","activity", feature_functs.names)


## here is why we loaded reshape2 library
combineData.melted <- melt(combinedData, id = c("subject", "activity"))
## mean data
combinedData.mean <-dcast(combineData.melted, subject + activity ~ variable, mean)

## create an output of 'tidy' data
write.table(combinedData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)