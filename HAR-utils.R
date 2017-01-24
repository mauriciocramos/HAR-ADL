# Script: HAR-utils.R
# Author: Maurício Collaça
# Date: 24/Jan/2017
# Description: a set of common functions for the HAR data set analysis V1.0

## HAR data set path builder
HARpath <- function(..., path = getwd()) {
    file.path(path, "UCI HAR Dataset", ...)
}

## HAR data set read wrappers
read_features <- function(file = HARpath("features.txt")) {
    read_naming(file, col.names = c("id", "name"))
}
read_activity_labels <- function(file = HARpath("activity_labels.txt")) {
    read_naming(file, col.names = c("id", "name"))
}
read_X <- function(set, file = HARpath(set,paste0("X_",set,".txt"))) {
    read_naming(file, col.names= 1:561, check.names = FALSE, colClasses = "numeric")
}
read_y <- function(set, file = HARpath(set,paste0("y_",set,".txt"))) {
    read_naming(file, col.names = "activity")
}
read_subject <- function(set, file = HARpath(set,paste0("subject_", set, ".txt"))) {
    read_naming(file, col.names = "subject")
}
## read.table wrapper
read_naming <- function(..., col.names = "name", check.names = TRUE, colClasses = NA, stringAsFactors = FALSE) {
    read.table(..., col.names = col.names, check.names = check.names, colClasses = colClasses, stringsAsFactors = stringAsFactors)
}

## Additional functions not used by run_analysis.R

## HAR features_info.txt wrapper
read_signals <- function(...) {
    read_features_info(..., skip = 12, nrows = 17, col.names = "name")
}
read_calculus <- function(...) {
    read_features_info(..., skip = 32, nrows = 17, col.names = c("name","description"), sep = ":", strip.white = TRUE)
}
read_angleVectors <- function(...) {
    read_features_info(..., skip = 52, nrows = 5, col.names = "name")
}
## read.table wrapper function to read "features_info.txt"
read_features_info <- function(..., file = HARpath("features_info.txt"), sep = "", strip.white = FALSE) {
    read.table(..., file = file, sep = sep, strip.white = strip.white, stringsAsFactors = FALSE)
}

read_inertial_signal <- function(set, signal, axis, colPrefix, file = HARpath(set, "Inertial Signals", paste0(signal, "_", axis, "_", set, ".txt"))) {
    read_naming(file, col.names = paste0(colPrefix, "-", toupper(axis), stringr::str_pad(1:128, 3, "left", "0")), check.names = FALSE, colClasses = "numeric")
}

tidy_inertial_signals <- function() {
    library(dplyr)
    library(tidyr)
    bind_cols(data.frame(window = seq_len(10299)),
          bind_rows(
              bind_cols(
                  read_subject("train"),
                  read_y("train"),
                  read_inertial_signal("train", "total_acc", "x", "tAcc"),
                  read_inertial_signal("train", "total_acc", "y", "tAcc"),
                  read_inertial_signal("train", "total_acc", "z", "tAcc"),
                  read_inertial_signal("train", "body_acc", "x", "tBodyAcc"),
                  read_inertial_signal("train", "body_acc", "y", "tBodyAcc"),
                  read_inertial_signal("train", "body_acc", "z", "tBodyAcc"),
                  read_inertial_signal("train", "body_gyro", "x", "tBodyGyro"),
                  read_inertial_signal("train", "body_gyro", "y", "tBodyGyro"),
                  read_inertial_signal("train", "body_gyro", "z", "tBodyGyro")
              ),
              bind_cols(
                  read_subject("test"),
                  read_y("test"),
                  read_inertial_signal("test", "total_acc", "x", "tAcc"),
                  read_inertial_signal("test", "total_acc", "y", "tAcc"),
                  read_inertial_signal("test", "total_acc", "z", "tAcc"),
                  read_inertial_signal("test", "body_acc", "x", "tBodyAcc"),
                  read_inertial_signal("test", "body_acc", "y", "tBodyAcc"),
                  read_inertial_signal("test", "body_acc", "z", "tBodyAcc"),
                  read_inertial_signal("test", "body_gyro", "x", "tBodyGyro"),
                  read_inertial_signal("test", "body_gyro", "y", "tBodyGyro"),
                  read_inertial_signal("test", "body_gyro", "z", "tBodyGyro")
              )
          )) %>%
        gather(signal_reading, value, 4:1155) %>%
        separate(signal_reading,
                 c("signal", "reading"),
                 sep = -4,
                 convert = TRUE)
    # %>% arrange(window, subject, activity, signal, reading)
}

## Interval series for bandsEnergy calculus
bandsEnergyBins <- function() {
    list(intervalSeries[1:8,1], intervalSeries[9:12,1], intervalSeries[13:14,1])
}
