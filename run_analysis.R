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
unzip(zipfile = "Dataset.zip", list = TRUE)[c(1:5,16:19,30:32),1]
if(!dir.exists("UCI HAR Dataset")) { unzip(destfile, setTimes = TRUE) }

basedir <- getwd()
source("HAR-analysis.R")

path <- file.path(basedir,"UCI HAR Dataset")
features <- read_features(path,"features.txt")
activity_labels <- read_activity_labels(path,"activity_labels.txt")
path <- file.path(basedir,"UCI HAR Dataset","train")
X_train <- read_X_train(path,"X_train.txt")
y_train <- read_y_train(path,"y_train.txt")
subject_train <- read_subject_train(path,"subject_train.txt")
path <- file.path(basedir,"UCI HAR Dataset","test")
X_test <- read_X_test(path,"X_test.txt")
y_test <- read_y_test(path,"y_test.txt")
subject_test <- read_subject_test(path,"subject_test.txt")

### 1. Merges the training and the test sets to create one data set.

dataset <- bind_rows(bind_cols(subject_train, y_train, X_train),
                     bind_cols(subject_test, y_test, X_test))
dataset <- gather(dataset,
                  variable,
                  value,
                  (length(dataset) - 560):(length(dataset)),
                  convert = TRUE)

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

featureFilter <- features[grepl("mean\\(\\)|meanFreq\\(\\)|std\\(\\)",features$label), 1]
dataset <- dataset %>% filter(variable %in% featureFilter)

### 3. Uses descriptive activity names to name the activities in the data set

dataset <- dataset %>% mutate(activity = activity_labels$label[activity])

### 4. Appropriately labels the data set with descriptive variable names.

dataset <- dataset %>% mutate(variable = features$label[variable])

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

averages <- dataset %>%
group_by(subject, activity, variable) %>%
summarize(average = mean(value)) %>%
as.data.frame
write.table(averages, file = "tidyDataSet.txt", row.names = FALSE)
View(read.table("tidyDataSet.txt", header = TRUE, stringsAsFactors = FALSE))
