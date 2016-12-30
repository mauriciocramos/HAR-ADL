inertialSignals
================

Analyzes the Inertial Signals of the HAR Data Set V1.0.
-------------------------------------------------------

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(tidyr)
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
destfile = 'Dataset.zip'
if(!file.exists(destfile)) { download.file(url, destfile) }
if(!dir.exists("UCI HAR Dataset")) { unzip(destfile, setTimes = TRUE) }
basedir <- getwd()
```

``` r
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
```

``` r
total_acc <- read.table(file.path(basedir,
                                "UCI HAR Dataset",
                                "train",
                                "Inertial Signals",
                                "total_acc_x_train.txt"),
                      header = FALSE,
                      col.names = 1:128,
                      check.names = FALSE,
                      colClasses = "numeric")
```

``` r
library(plyr)
```

    ## -------------------------------------------------------------------------

    ## You have loaded plyr after dplyr - this is likely to cause problems.
    ## If you need functions from both plyr and dplyr, please load plyr first, then dplyr:
    ## library(plyr); library(dplyr)

    ## -------------------------------------------------------------------------

    ## 
    ## Attaching package: 'plyr'

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     arrange, count, desc, failwith, id, mutate, rename, summarise,
    ##     summarize

``` r
rawsignals <- c("tAcc","tGyro")
signals <- c("tBodyAcc","tGravityAcc")
axials <- c("x","y","z")

subdirs <- c("train","test")

paths <- dir(file.path(basedir,
                       "UCI HAR Dataset",
                       "train",
                       "Inertial Signals"),
             pattern = "(^total_acc_).*(\\.txt$)",
             full.names = TRUE)
names(paths) <- basename(paths)
total_acc <- ldply(paths, 
                   read.table,
                   header = FALSE,
                   col.names = 1:128,
                   check.names = FALSE,
                   colClasses = "numeric")
```
