# Script: run_analysis.R
# Author: Maurício Collaça Ramos
# Date: 27/Dec/2016
# Description: collect, tidy, filter and make some statistics of the HAR data
# set, producing a new tidy data set

library(dplyr)
library(tidyr)
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
destfile = 'Dataset.zip'
if(!file.exists(destfile)) { download.file(url, destfile) }
if(!dir.exists("UCI HAR Dataset")) { unzip(destfile, setTimes = TRUE) }
basedir <- getwd()

features <- read.table(file.path(basedir,"UCI HAR Dataset","features.txt"),
                       col.names = c("id", "description"),
                       stringsAsFactors = FALSE)

activity_labels <- read.table(file.path(basedir,
                                        "UCI HAR Dataset",
                                        "activity_labels.txt"),
                              col.names = c("id", "description"),
                              stringsAsFactors = FALSE)

X_train <- read.table(file.path(basedir,
                                "UCI HAR Dataset",
                                "train",
                                "X_train.txt"),
                      header = FALSE,
                      col.names = 1:561,
                      check.names = FALSE,
                      colClasses = "numeric")

y_train <- read.table(file.path(basedir,
                                "UCI HAR Dataset",
                                "train",
                                "y_train.txt"),
                      header = FALSE,
                      col.names = "activity")

subject_train <- read.table(file.path(basedir,
                                      "UCI HAR Dataset",
                                      "train",
                                      "subject_train.txt"),
                            header = FALSE,
                            col.names = "subject")

X_test <- read.table(file.path(basedir,
                               "UCI HAR Dataset",
                               "test",
                               "X_test.txt"),
                     header = FALSE,
                     col.names = 1:561,
                     check.names = FALSE,
                     colClasses = "numeric")

y_test <- read.table(file.path(basedir,"UCI HAR Dataset","test","y_test.txt"),
                     header = FALSE,
                     col.names = "activity")

subject_test <- read.table(file.path(basedir,
                                     "UCI HAR Dataset",
                                     "test",
                                     "subject_test.txt"),
                           header = FALSE,
                           col.names = "subject")

## REQUIREMENT #1. Merges the training and the test sets to create one data set.
dataset <- bind_rows(bind_cols(subject_train, y_train, X_train),
                     bind_cols(subject_test, y_test, X_test))
dataset <- gather(dataset,
                  variable,
                  value,
                  (length(dataset) - 560):(length(dataset)),
                  convert = TRUE)

## REQUIREMENT #2. Extracts only the measurements on the mean and standard 
## deviation for each measurement.
featureFilter <- features[grepl("mean\\(\\)|meanFreq\\(\\)|std\\(\\)",
                                features$description)
                          , 1]
dataset <- dataset %>% filter(variable %in% featureFilter)

## REQUIREMENT #3. Uses descriptive activity names to name the activities in the
## data set
dataset <- dataset %>% mutate(activity = activity_labels$description[activity])

## REQUIREMENT #4. Appropriately labels the data set with descriptive variable
## names.
dataset <- dataset %>% mutate(variable = features$description[variable])

## REQUIREMENT #5. From the data set in step 4, creates a second, independent
## tidy data set with the average of each variable for each activity and each
## subject.
averages <- dataset %>%
    group_by(subject, activity, variable) %>%
    summarize(average = mean(value)) %>%
    as.data.frame
write.table(averages, file = "tidyDataSet.txt", row.names = FALSE)
View(read.table("tidyDataSet.txt", header = TRUE, stringsAsFactors = FALSE))

