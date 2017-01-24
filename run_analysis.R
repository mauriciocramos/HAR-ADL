# Script: run_analysis.R
# Author: Maurício Collaça Ramos
# Date: 24/Jan/2017
# Description: collect, tidy, filter and make some statistics of the HAR data
# set, producing a new tidy data set

library(dplyr)
library(tidyr)

if(!file.exists("HAR-utils.R"))
    download.file("https://raw.githubusercontent.com/mauriciocramos/HAR-analysis/master/HAR-utils.R",
                  "HAR-utils.R",
                  quiet = TRUE)
source("HAR-utils.R")
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
destfile = 'Dataset.zip'
if(!file.exists(destfile)) {
    message("Plese wait...\n")
    download.file(url, destfile, mode = "wb")
    message("...done\n")
}
if(!dir.exists("UCI HAR Dataset")) {
    message("Plese wait.  Unzipping files...")
    unzip(destfile, setTimes = TRUE)
    message("...done\n")
}

## 1. Merges the training and the test sets to create one data set.
message("Plese wait.  Reading files...")
dataset <-
    bind_rows(
        bind_cols(read_subject("train"), read_y("train"), read_X("train")),
        bind_cols(read_subject("test"), read_y("test"), read_X("test"))
    )
message("...done\n")
dataset <- gather(dataset,
                  feature,
                  value,
                  (length(dataset) - 560):(length(dataset)),
                  convert = TRUE)
message("1. Merges the training and the test sets to create one data set.")
str(dataset)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features<-read_features()
selectedFeatureIds <- features[grep("(mean|meanFreq|std)\\(\\)",features$name), 1]
dataset <- dataset %>% filter(feature %in% selectedFeatureIds)
message("2. Extracts only the measurements on the mean and standard deviation for each measurement.")
str(dataset)

## 3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read_activity_labels()
dataset <- mutate(dataset, activity = activity_labels$name[activity])
message("3. Uses descriptive activity names to name the activities in the data set")
str(dataset)

## 4. Appropriately labels the data set with descriptive variable names.
dataset <- dataset %>%
    mutate(feature = features$name[feature])
message("4. Appropriately labels the data set with descriptive variable names.")
str(dataset)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
averages <- dataset %>%
    group_by(subject, activity, feature) %>%
    summarize(average = mean(value)) %>%
    as.data.frame
message("5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.")
str(averages)
write.table(averages, file = "averages.txt", row.names = FALSE)
View(read.table("averages.txt", header = TRUE, stringsAsFactors = FALSE))
