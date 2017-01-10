# Script: run_analysis.R
# Author: Maurício Collaça Ramos
# Date: 27/Dec/2016
# Description: collect, tidy, filter and make some statistics of the HAR data
# set, producing a new tidy data set

library(dplyr)
library(tidyr)

## Download zip file
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
destfile = 'Dataset.zip'
if(!file.exists(destfile)) { download.file(url, destfile) }

## Uncompress file
if(!dir.exists("UCI HAR Dataset")) { unzip(destfile, setTimes = TRUE) }

## Read files
source("HAR-utils.R")
features <- read_features()
head(features)
activity_labels <- read_activity_labels()
activity_labels

X_train <- read_X_train()
y_train <- read_y_train()
subject_train <- read_subject_train()
X_test <- read_X_test()
y_test <- read_y_test()
subject_test <- read_subject_test()

## 1. Merges the training and the test sets to create one data set.

dataset <- bind_rows(bind_cols(subject_train, y_train, X_train),
                     bind_cols(subject_test, y_test, X_test))
nrow(dataset)
length(dataset)
head(dataset[,c(1:5,562:563)])

dataset <- gather(dataset,
                  feature,
                  value,
                  (length(dataset) - 560):(length(dataset)),
                  convert = TRUE)
str(dataset)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

selectedFeatureIds <- features[grep("(mean|meanFreq|std)\\(\\)",features$name), 1]
dataset <- dataset %>% filter(feature %in% selectedFeatureIds)
str(dataset)

## 3. Uses descriptive activity names to name the activities in the data set

dataset <- mutate(dataset, activity = activity_labels$name[activity])
str(dataset)

## 4. Appropriately labels the data set with descriptive variable names.

dataset <- dataset %>%
    mutate(feature = features$name[feature]) %>%
    arrange(subject, activity, feature)
str(dataset)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

averages <- dataset %>%
    group_by(subject, activity, feature) %>%
    summarize(average = mean(value)) %>%
    as.data.frame
str(averages)
write.table(averages, file = "averages.txt", row.names = FALSE)
