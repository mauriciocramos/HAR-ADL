# Script: HAR-utils.R
# Author: Maurício Collaça Ramos
# Date: 05/Jan/2017
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
read_inertial_signal <- function(set, signal, axis, colPrefix, file = HARpath(set, "Inertial Signals", paste0(signal, "_", axis, "_", set, ".txt"))) {
    read_naming(file, col.names = paste0(colPrefix, "-", toupper(axis), str_pad(1:128, 3, "left", "0")), check.names = FALSE, colClasses = "numeric")
}
test1 <- function() {
    cbind(window = seq_len(10299),
          rbind(
              cbind(
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
              cbind(
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

test2 <- function() {
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

tidy_inertial_signal <- function(set, signal, axis, colPrefix, file = HARpath(set, "Inertial Signals", paste0(signal, "_", axis, "_", set, ".txt"))) {
    read_inertial_signal(set, signal, axis, colPrefix, file) %>%
    mutate(window = row_number()) %>%
    gather(signal_reading, value, 1:128) %>%
    separate(signal_reading,
             c("signal", "reading"),
             sep = -4,
             convert = TRUE) %>% arrange(window, signal, reading)
}


















deprecated_tidy_inertial_signals <- function() {
    max.print <- options(max.print = 6)
    sets <- c("train","test")
    signals <- c("total_acc","body_acc","body_gyro")
    axes <- c("x","y","z")
    results <- numeric(length(sets)*length(signals)*length(axes))
    for(set in seq_along(sets)) {
        for(signal in seq_along(signals)) {
            for(axis in seq_along(axes)) {
                cbind(read_subject(set), read_y(sets[set]), read_inertial_signal(sets[set], signals[signal], axes[axis]))
            }
        }
    }
    options(max.print)
}




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

## Interval series for bandsEnergy calculus
bandsEnergyBins <- function() {
    list(intervalSeries[1:8,1], intervalSeries[9:12,1], intervalSeries[13:14,1])
}

parser <- function() {
    parsers <-
        data.frame(stringsAsFactors = FALSE,
                   id = 1:5,
                   class = c("nosignal",
                             "magnitude",
                             "uniaxial",
                             "biaxial",
                             "triaxial"),#,
                             #"triaxialBandsEnergy",
                             #"triaxialSma"),
                   description = c("No signal features",
                                   "Magnitude Signal features",
                                   "Uniaxial Signal features",
                                   "Biaxial Signal features",
                                   "Triaxial Signals features"),#,
                                   #"Triaxial Signal bandsEnergy features",
                                   #"Triaxial Signal Magnitude Area features"),
                   pattern = c("^angle\\([a-zA-Z]+,[a-zA-Z]+\\)$",
                               "^[f]*?[t]*?[Body]*?[Gravity]*?[Acc]*?[Gyro]*?[Jerk]*?Mag-[a-zA-z]+\\(\\)[1-4]?$",
                               "^[f]*?[t]*?[Body]*?[Gravity]*?[Acc]*?[Gyro]*?[Jerk]*?-[a-zA-Z]+\\(\\)-([XYZ]),?[1-4]?$",
                               "^[f]*?[t]*?[Body]*?[Gravity]*?[Acc]*?[Gyro]*?[Jerk]*?-correlation\\(\\)-([XY]),([YZ])$",
                               "^[f]*?[t]*?[Body]*?[Gravity]*?[Acc]*?[Gyro]*?[Jerk]*?-[bandsEnergy|sma]*?\\(\\)[-]?[0-9]*?[,]?[0-9]*?$"))#,
                               #"^[f]*?[t]*?[Body]*?[Gravity]*?[Acc]*?[Gyro]*?[Jerk]*?-bandsEnergy\\(\\)-[0-9]*?,[0-9]*?$",
                               #"^[f]*?[t]*?[Body]*?[Gravity]*?[Acc]*?[Gyro]*?[Jerk]*?-sma\\(\\)$"))
    parser_replacements <- 
        data.frame(stringsAsFactors = FALSE,
                   #id = c(1L, 2L, 3L, 4L, 4L, 5L, 5L, 5L), #, 6L, 6L, 6L, 7L, 7L, 7L),
                   id = c(3L, 4L, 4L, 5L, 5L, 5L), #, 6L, 6L, 6L, 7L, 7L, 7L),
                   seq = c(1L, 1L, 2L, 1L, 2L, 3L), #, 1L, 2L, 3L, 1L, 2L, 3L),
                   #replacement = c("", "", "\\1", "\\1", "\\2", "X", "Y", "Z")) #, "X", "Y", "Z", "X", "Y", "Z"))
                   replacement = c("\\1", "\\1", "\\2", "X", "Y", "Z")) #, "X", "Y", "Z", "X", "Y", "Z"))

    getPattern <- function(string) {
        unlist(
            lapply(string, # pass through all string vector
                   function(f) {
                       lapply(parsers$pattern, # pass through all parsers$pattern
                              function(p) {
                                  parsers$pattern[parsers$pattern == p & grepl(p, f)] # subsets current p and when grepl match. SLOW?
                              }
                       )
                   }
            )            
        )


    }
    
    getId <- function(string) { 
        unlist(
            lapply(string,  # pass through all string vector
                   function(f) {
                       lapply(parsers$pattern, # pass through all parsers$pattern
                              function(p) {
                                  parsers$id[parsers$pattern == p & grepl(p, f)] # subsets current p and when grepl match. SLOW?
                              }
                       )
                   }
            )
        )
    }

    getParserReplacements <- function(string) {
        unlist(
            lapply(getId(string),
                   function(i) {
                       paste0(parser_replacements$replacement[parser_replacements$id == i], collapse = "")
                   }
            )
        )
    }
 
    getResults <- function(string) { 
        unlist(
            lapply(string,
                   function(f) {
                       lapply(getId(f), ## pass on parsers$id at a time
                              function(i) {
                                  lapply(parsers$pattern[parsers$id == i], # pass on parsers$pattern at a time
                                         function(p) {
                                             sub(p,
                                                 paste(parser_replacements$replacement[parser_replacements$id == i], collapse = ""),
                                                 f)
                                         }
                                  )
                              }
                       )                      
                   }
            )
        )        
        
    }
    
    list(getId = getId,
         getPattern = getPattern,
         getParserReplacements = getParserReplacements,
         getResults = getResults)
}
