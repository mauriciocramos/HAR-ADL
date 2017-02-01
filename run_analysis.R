# Script: run_analysis.R
# Author: Maurício Collaça
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
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile = 'Dataset.zip'
if(!file.exists(destfile)) {
    message("Please wait. Downloading file...\n")
    download.file(url, destfile, mode = "wb", cacheOK = FALSE, quiet = TRUE)
    message("...done\n")
}
if(!dir.exists("UCI HAR Dataset")) {
    message("Please wait.  Unzipping files...")
    unzip(destfile, setTimes = TRUE)
    message("...done\n")
}

message("1. Merges the training and the test sets to create one data set.")
dataset <-
    bind_rows(
        bind_cols(read_subject("train"), read_y("train"), read_X("train")),
        bind_cols(read_subject("test"), read_y("test"), read_X("test"))
    )
dataset <- gather(dataset,
                  feature,
                  value,
                  (length(dataset) - 560):(length(dataset)),
                  convert = TRUE)
str(dataset)

message("2. Extracts only the measurements on the mean and standard deviation for each measurement.")
features <- read_features()
selectedFeatureIds <-
    features[grep("(mean|meanFreq|std)\\(\\)", features$name), 1]
dataset <- dataset %>% filter(feature %in% selectedFeatureIds)
str(dataset)

message("3. Uses descriptive activity names to name the activities in the data set")
activity_labels <- read_activity_labels()
dataset <- mutate(dataset, activity = activity_labels$name[activity])
str(dataset)

message("4. Appropriately labels the data set with descriptive variable names.")
dataset <- dataset %>%
    mutate(feature = features$name[feature])
str(dataset)

message("5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.")
averages <- dataset %>%
    group_by(subject, activity, feature) %>%
    summarize(average = mean(value)) %>%
    as.data.frame
str(averages)
write.table(averages, file = "averages.txt", row.names = FALSE)
View(read.table("averages.txt", header = TRUE, stringsAsFactors = FALSE))
