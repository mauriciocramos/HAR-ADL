# Script: HAR-ADL-utils.R
# Author: Maurício Collaça
# Date: 10/Oct/2017
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
    read_naming(file, col.names= 1:561, check.names = FALSE, 
                colClasses = "numeric")
}
read_y <- function(set, file = HARpath(set,paste0("y_",set,".txt"))) {
    read_naming(file, col.names = "activity")
}
read_subject <- function(set, file = HARpath(set,paste0("subject_", set,
                                                        ".txt"))) {
    read_naming(file, col.names = "subject")
}
## read.table wrapper
read_naming <- function(..., col.names = "name", check.names = TRUE,
                        colClasses = NA, stringAsFactors = FALSE) {
    read.table(..., col.names = col.names, check.names = check.names,
               colClasses = colClasses, stringsAsFactors = stringAsFactors)
}













## Additional functions not used by run_analysis.R

downloadUnzip <-
    function(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
             destfile = 'Dataset.zip',
             quiet = TRUE) {
        if(!file.exists(destfile)) {
            download.file(url, destfile, mode = "wb", cacheOK = FALSE, quiet = quiet)
        }
        if(!dir.exists("UCI HAR Dataset")) {
            unzip(destfile, setTimes = TRUE)
        }
}

patchFeatures <- function() {
    source("dsub.R")
    # Feature names with duplicated component
    dsub("features", "name", "^.([A-Z][a-z]+)(\\1).*", "\\1", "",
         explain = FALSE, verbose = FALSE)
    # Feature names containing invalid parenthesis
    dsub("features", "name", "^.+[\\(].+([\\)]).+[\\)].*", "\\1", "",
         explain = FALSE, verbose = FALSE)
    # Feature names missing parenthesis
    dsub("features", "name", "^[a-zA-Z]+-([a-zA-Z]+)-?[XYZ]?$", "(\\1)",
         "\\1()", explain = FALSE, verbose = FALSE)
    return(invisible(TRUE))
}

getFeatureAxes <- function(feature) {
    axes <-
        sub(
            "^.+(Acc|Gyro|Jerk)(-)([a-zA-Z]+)\\(\\)-?([XYZ]?),?([YZ]?)[0-9]*,?[0-9]*$|.+",
            "\\3\\4\\5",
            feature
        )
    axes = sub("sma|bandsEnergy", "XYZ", axes)
    axes = sub("correlation(XY|YZ|XZ){1}","\\1",axes)
    axes = sub(
        "arCoeff|energy|entropy|iqr|kurtosis|mad|max|maxInds|mean|meanFreq|min|skewness|std([XYZ])",
        "\\1",
        axes
    )
    axes
}

## HAR features_info.txt wrapper
read_signals <- function(...) {
    read_features_info(..., skip = 12, nrows = 17, col.names = "name")
}
read_calculus <- function(...) {
    read_features_info(..., skip = 32, nrows = 17,
                       col.names = c("name","description"), sep = ":",
                       strip.white = TRUE)
}
read_angleVectors <- function(...) {
    read_features_info(..., skip = 52, nrows = 5, col.names = "name")
}
## read.table wrapper function to read "features_info.txt"
read_features_info <-
    function(...,
             file = HARpath("features_info.txt"),
             sep = "",
             strip.white = FALSE) {
        read.table(..., file = file, sep = sep, strip.white = strip.white, stringsAsFactors = FALSE)        
    }

decomposeFeatureNames <- function(features) {
    require(dplyr, warn.conflicts = FALSE, quietly = TRUE)
    features %>%
        mutate(
            signal = sub("^([a-zA-Z]+)-.+|.+", "\\1", name),
            axesSep  = sub("^.+(Acc|Gyro|Jerk)(-).+|.+", "\\2", name),
            axes = getFeatureAxes(name),
            domain = sub("^(t|f)?.+", "\\1", name),
            component = sub("^[tf]?(Body|Gravity)?.+", "\\1", name),
            sensor = sub("^[a-zA-Z]+(Acc|Gyro).+|.+", "\\1", name),
            jerk = sub("^[a-zA-Z]+(Jerk).+|.+", "\\1", name),
            magnitude = sub("^[a-zA-Z]+(Mag).+|.+", "\\1", name),
            signalSep = sub("^[a-zA-Z]+(-).+|.+", "\\1", name),
            calculus = sub("^[a-zA-Z]+-([a-zA-Z]+).+|^(angle).+", "\\1\\2",
                           name),
            calcOpen = sub("^[a-zA-Z]+-[a-zA-Z]+(\\().+|.+", "\\1", name),
            calcClose = sub("^[a-zA-Z]+-[a-zA-Z]+\\((\\)).*|.+", "\\1", name),
            calcSep =  sub("^[a-zA-Z]+-[a-zA-Z]+\\(\\)(-).+|.+", "\\1", name),
            axis = sub("^[a-zA-Z]+-[a-zA-Z]+\\(\\)-([XYZ]),?[1-4]?|.+", "\\1",
                       name),
            arCoeffSep = sub("^[a-zA-Z]+-arCoeff+\\(\\)-[XYZ](,).+|.+", "\\1", name),
            arCoeffLevel = sub("^[a-zA-Z]+-arCoeff\\(\\)-?[XYZ]?,?([1-4])|.+", "\\1",
                               name),
            bandsEnergyLower = sub("^[a-zA-Z]+-bandsEnergy+\\(\\)-([0-9]+),[0-9]+|.+",
                                   "\\1", name),
            bandsEnergySep = sub("^[a-zA-Z]+-bandsEnergy+\\(\\)-[0-9]+(,).+|.+", "\\1",
                                 name),
            bandsEnergyUpper = sub("^[a-zA-Z]+-bandsEnergy+\\(\\)-[0-9]+,([0-9]+)|.+",
                                   "\\1", name),
            correlationAxis1 = sub("^[a-zA-Z]+-correlation+\\(\\)-([XY]).+|.+", "\\1",
                                   name),
            correlationSep =  sub("^[a-zA-Z]+-correlation+\\(\\)-[XY](,).+|.+", "\\1",
                                  name),
            correlationAxis2 = sub("^[a-zA-Z]+-correlation+\\(\\)-[XY],([YZ])|.+", "\\1",
                                   name),
            angleOpen = sub("^angle(\\().+|.+", "\\1", name),
            angleArg1 = sub("^angle\\(([a-zA-Z]+).+|.+", "\\1", name),
            angleSep = sub("^angle\\([a-zA-Z]+(,).+|.+", "\\1", name),
            angleArg2 = sub("^angle\\([a-zA-Z]+,([a-zA-Z]+)\\)|.+", "\\1",
                            name),
            angleClose = sub("^angle\\([a-zA-Z]+,[a-zA-Z]+(\\))|.+", "\\1",
                             name)
        )
}

read_feature_measurements <- function() {
    require(dplyr, warn.conflicts = FALSE, quietly = TRUE)
    require(tidyr, quietly = TRUE)
    bind_cols(
        data.frame(window = seq_len(10299)),
        bind_rows(
            bind_cols(read_subject("train"), read_y("train"), read_X("train")),
            bind_cols(read_subject("test"), read_y("test"), read_X("test"))
        )) %>%
        gather(feature, value, 4:564, convert = TRUE) %>%
        #mutate(activity = read_activity_labels()$name[activity]) %>%
        #mutate(feature = read_features()$name[feature]) %>%
        arrange(window)
}

read_inertial_signal <- function(set, signal, axis, colPrefix, 
                                 file = HARpath(set, "Inertial Signals",
                                                paste0(signal, "_", axis, "_",
                                                       set, ".txt"))) {
    read_naming(file, col.names = paste0(colPrefix, "-", toupper(axis), stringr::str_pad(1:128, 3, "left", "0")), check.names = FALSE, colClasses = "numeric")    
}

read_inertial_signals <- function() {
    require(dplyr, warn.conflicts = FALSE, quietly = TRUE)
    require(tidyr, quietly = TRUE)
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
                 convert = TRUE) %>%
        #mutate(activity = read_activity_labels()$name[activity]) %>%
        arrange(window)
}

## Interval series for bandsEnergy calculus
bandsEnergyBins <- function() {
    list(intervalSeries[1:8,1], intervalSeries[9:12,1], intervalSeries[13:14,1])
}
