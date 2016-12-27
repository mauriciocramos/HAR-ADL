HAR-analysis
================
by Maurício Collaça

Human Activity Recognition (HAR) using smartphones Data Set analysis
--------------------------------------------------------------------

An exciting area in Data Science is Wearable Computing - see for example this [article from Inside Activity Tracking](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/). Companies like [Fitbit](https://www.fitbit.com/), [Nike](http://www.nike.com/), [Jawbone Up](https://jawbone.com/up), [Strava](https://www.strava.com/), and many others are racing to develop the most advanced algorithms to attract new users.

The purpose of this project is to collect, tidy, filter and make some statistics of the HAR data set, producing a new tidy data set.

The data set used in the project is the University of California Irvine (UCI) Machine Learning Repository: Human Activity Recognition Using Smartphones Data Set Version 1.0. The data set represent data collected from the embedded accelerometer and gyroscope of the Samsung Galaxy S smartphone. A full description is available at:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

The data set for the project:

Mirror: <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> Original: <http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip>

About this README:
------------------

This document is an explanation about the Github repository [HAR-analysis](https://github.com/mauriciocramos/HAR-analysis) and its containing project files developed for the course [Getting and Cleaning Data](https://www.coursera.org/learn/data-cleaning/) of the [Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science) from [John Hopkins University](https://www.jhu.edu/) powered by [Coursera](https://www.coursera.org/)

This repository includes the following files:
---------------------------------------------

-   `README.md` - This README markdown file,
-   `CodeBook.md` - A code book markdown file that indicate all the variables and summaries calculated, along with units, and any other relevant information about the output file `tidyDataSet.txt`
-   `run_analysis.R` - R script to perform the data download, tidying and analysis required by the project.
-   `tidyDataSet.txt` - Tidy data set output from `run_analysis.R`, containing the the average of each mean and standard deviation variable for each activity and each subject. Specific details about the data are found in is dictionary `CodeBook.md` .

General information about the environment used
----------------------------------------------

Coffee machine:

    NESPRESSO Inissia, model D40

Hardware:

    Processor: Inter(R) Core(TM) i5-2300 CPU @ 2.80Ghz
    Number of Cores: 4
    Installed RAM: 8.00 GB  
    System type: x64-based processor

Operating System:

    Edition: Windows 10 Home  
    System type: 64-bit

R version:

    R version 3.3.2 (2016-10-31) -- "Sincere Pumpkin Patch"
    Copyright (C) 2016 The R Foundation for Statistical Computing
    Platform: x86_64-w64-mingw32/x64 (64-bit)

R Studio:

    Version 1.0.44

R packages used beyond the R defaults `{base}`, `{utils}`, `{stat}`:

`{dplyr}` (Windows binary r-release: [dplyr\_0.5.0](https://cran.r-project.org/bin/windows/contrib/3.3/dplyr_0.5.0.zip))

`{tidyr}` (Windows binary r-relase: [tidyr\_0.6.0](https://cran.r-project.org/bin/windows/contrib/3.3/tidyr_0.6.0.zip))

The run\_analysis.R script
--------------------------

To run this script, just save it in some working directory, open `R` or `RStudio`, go to that directory and run it with the following command:

`source("run_analysis.R")`

With the hardware and software configuration described earlier, it takes around 55 seconds to complete at the first time, which also includes the downloading and uncompressing tasks.

`system.time(source("run_analysis.R"))`

     user  system elapsed
    18.22    8.89   54.79

At the next times, you run it, there won't be any download and uncompressing task, then it takes around 14 seconds.

`system.time(source("run_analysis.R"))`

     user  system elapsed
    12.93    0.12   13.53

The R script was developed to fullfill the following formal requirements of the project:

> 1.  Merges the training and the test sets to create one data set.
> 2.  Extracts only the measurements on the mean and standard deviation for each measurement.
> 3.  Uses descriptive activity names to name the activities in the data set
> 4.  Appropriately labels the data set with descriptive variable names.
> 5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Before explaining the solutions developed for the requirements 1 to 2, first it's explained the process to load the required R packages and the HAR data set which consists of multiple directories and files.

The `{dplyr}` functions `group_by()` and `summarize()` are used with the function `mean() {base}` to fast and easily calculate the average of all values grouped by `subject`, `activity` and `variable`. It's also used the `{dplyr}` chain operator `"%>%"` to improve the code readability.

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

The `{tidyr}` function `gather()` is used to take multiple columns and collapses into key-value pairs, duplicating all other columns as needed.

``` r
library(tidyr)
```

The script downloads the zip file `Dataset.zip` into your working directory only once, unless you delete it.

``` r
url <- 
'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
destfile = 'Dataset.zip'
if(!file.exists(destfile)) { download.file(url, destfile) }
```

The zip file `Dataset.zip` contains a subdirectory structure and multiple files that the `run_analysis.R` script needs to dealth with. The following command displays the exaclty files the project need to either understand or process:

``` r
unzip(zipfile = "Dataset.zip", list = TRUE)[c(1:5,16:19,30:32),1]
```

    ##  [1] "UCI HAR Dataset/activity_labels.txt"    
    ##  [2] "UCI HAR Dataset/features.txt"           
    ##  [3] "UCI HAR Dataset/features_info.txt"      
    ##  [4] "UCI HAR Dataset/README.txt"             
    ##  [5] "UCI HAR Dataset/test/"                  
    ##  [6] "UCI HAR Dataset/test/subject_test.txt"  
    ##  [7] "UCI HAR Dataset/test/X_test.txt"        
    ##  [8] "UCI HAR Dataset/test/y_test.txt"        
    ##  [9] "UCI HAR Dataset/train/"                 
    ## [10] "UCI HAR Dataset/train/subject_train.txt"
    ## [11] "UCI HAR Dataset/train/X_train.txt"      
    ## [12] "UCI HAR Dataset/train/y_train.txt"

The script uncompress the zip file `Dataset.zip` only once into the working directory:

``` r
if(!dir.exists("UCI HAR Dataset")) { unzip(destfile, setTimes = TRUE) }
```

The current working directory path is saved to build the path names to the necessary subdirectories

``` r
basedir <- getwd()
```

The script loads three groups os data sets tied-up with the subdirectory structure: General, Training sets and Testing data sets. All eight data set files area loaded into R `data.frame` objects.

Loading the General data sets from directory `./UCI HAR Dataset/`:

Load the `features.txt`:

``` r
features <- read.table(file.path(basedir,"UCI HAR Dataset","features.txt"),
                       col.names = c("id", "description"),
                       stringsAsFactors = FALSE)
```

Load the `activity_labels.txt`:

``` r
activity_labels <- read.table(file.path(basedir,
                                        "UCI HAR Dataset",
                                        "activity_labels.txt"),
                              col.names = c("id", "description"),
                              stringsAsFactors = FALSE)
```

Loading the Trainning data sets from the directory `./UCI HAR Dataset/train`:

Load the `X_train.txt` file:

``` r
X_train <- read.table(file.path(basedir,"UCI HAR Dataset","train","X_train.txt"),
                      header = FALSE,
                      col.names = 1:561,
                      check.names = FALSE,
                      colClasses = "numeric")
```

NOTE: The use of the argument `check.names = FALSE` forces the column names of `X_train` data frame as `numeric` `1:561` rather than `character` `X1:X561` (R default behaviour). That simplifies labeling variables in requirement \#4 bellow. This approach is based on from Hadley Wickham's concept "Tidying messy data sets" and "Column headers are values, not variable names" at: <https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html>

Load `y_train.txt` and `subject_train.txt` files:

``` r
y_train <- read.table(file.path(basedir,"UCI HAR Dataset","train","y_train.txt"),
                      header = FALSE,
                      col.names = "activity")
subject_train <- read.table(file.path(basedir,
                                      "UCI HAR Dataset",
                                      "train",
                                      "subject_train.txt"),
                            header = FALSE,
                            col.names = "subject")
```

Loading the Test data sets from the directory `./UCI HAR Dataset/test`:

Load the `X_test.txt`, `y_test.txt` and `subject_test.txt` files:

``` r
X_test <- read.table(file.path(basedir,"UCI HAR Dataset","test","X_test.txt"),
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

After explained the loading of all data set files it's now time to explain the solution to each requirement.

### 1. Merges the training and the test sets to create one data set.

In this requirement it's anticipated part of requirements \#3 and \#5. It's decided to merge the measurements (`X_train`, `X_test`) with their respectives subjects (`subject_train`, `subject_test`) and activities (`y_train`, `y_test`) prior to merge both results in one single data set. This approach is based on Hadley Wickham's concept "Tidying messy data sets" and "One type in multiple tables" at: <https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html>

-   Horizontally merge the three trainning-related data frames
-   Horizontally merge the three test-related data frames
-   Vertically merge the previously merged data frames

Used `dplyr` package functions `bind_cols()` for horizontal merge and `bind_rows()` for vertical merge:

``` r
dataset <- bind_rows(bind_cols(subject_train, y_train, X_train),
                     bind_cols(subject_test, y_test, X_test))
```

In order to have a tidier long (or tall) data set, it's necessary to collapse the 561 columns that are not variables into key-value pairs, as mentioned in the rubric "either long or wide form is acceptable”. This approach is based on Hadley Wickham's concept "Tidying messy data sets" and "Column headers are values, not variable names" at: <https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html>

Used `tidyr` package function `gather()` to take multiple columns and collapses into key-value pairs, duplicating all other columns as needed.

``` r
dataset <- gather(dataset,
                  variable,
                  value,
                  (length(dataset) - 560):(length(dataset)),
                  convert = TRUE)
```

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

Initially, this requirement \#2 was not perfectly clear whether the extraction should affect the results of the next requirements. Following a good sense and the discussions in the regarding forums, It is assumed the extraction shall affect the existent tidy dataset.

Additional considerations about the feature selection reasoning:

According to the Wikipedia (<https://en.wikipedia.org/wiki/Mean>):

> In mathematics, mean has several different definitions depending on the context.

> In probability and statistics, mean and expected value are used synonymously to refer to one measure of the central tendency either of a probability distribution or of the random variable characterized by that distribution. In the case of a discrete probability distribution of a random variable X, the mean is equal to the sum over every possible value weighted by the probability of that value

According to the Wikipedia (<https://en.wikipedia.org/wiki/Arithmetic_mean>):

> In mathematics and statistics, the arithmetic mean, or simply the mean or average when the context is clear, is the sum of a collection of numbers divided by the number of numbers in the collection.

> Generalizations - Weighted average
> A weighted average, or weighted mean, is an average in which some data points count more strongly than others, in that they are given more weight in the calculation.

According to the `features_info.txt` provided by Human Activity Recognition Using Smartphones Dataset Version 1.0, relevant features were found:

> The set of variables that were estimated from these signals are:
> mean(): Mean value
> std(): Standard deviation
> (...) meanFreq(): Weighted average of the frequency components to obtain a mean frequency

According to the "features\_info.txt", there are other vectors that, although means, their respective features are actually `angles`:

> Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable: gravityMean, tBodyAccMean, tBodyAccJerkMean, tBodyGyroMean, BodyGyroJerkMean".

> angle(tBodyAccMean,gravity)
> angle(tBodyAccJerkMean),gravityMean)
> angle(tBodyGyroMean,gravityMean)
> angle(tBodyGyroJerkMean,gravityMean)
> angle(X,gravityMean)
> angle(Y,gravityMean)
> angle(Z,gravityMean)

Thus, these `angle()` variables will not be extracted to fullfill the requirement \#2 because the atomic unit in the dataset is the `feature` and not an implicit `vector` that may composes a `feature`.

After all this reasoning and for the sake of the completeness, it is assumed that either `mean()` and `meanFreq()` and `std()` represent valid feature variables (substrings) to fullfill the requirement \#2.

Create a filter of the features required by this project considering the substrings `mean()`, `meanFreq()` and `std()`

``` r
featureFilter <-
    features[grepl("mean\\(\\)|meanFreq\\(\\)|std\\(\\)", features$description), 1]
```

Extract the mean and standard deviation variables

``` r
dataset <- dataset %>% filter(variable %in% featureFilter)
```

### 3. Uses descriptive activity names to name the activities in the data set

``` r
dataset <- dataset %>% mutate(activity = activity_labels$description[activity])
```

### 4. Appropriately labels the data set with descriptive variable names.

``` r
dataset <- dataset %>% mutate(variable = features$description[variable])
```

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Used `dplyr` package functions `group_by()` and `summarize()` with the `base` package function `mean()` to fast and easily calculate the average of all `values` grouped by `subject`, `activity` and `variable`. It's also used the `dplyr` package chain operator `%>%` to improve code readability.

``` r
averages <- dataset %>%
    group_by(subject, activity, variable) %>%
    summarize(average = mean(value)) %>%
    as.data.frame
```

Write the tidy data set file `tidyDataSet.txt` in the current working directory

``` r
write.table(averages, file = "tidyDataSet.txt", row.names = FALSE)
```

For the peer evaluation of the tidy data set file `tidyDataSet.txt`:

``` r
View(read.table("tidyDataSet.txt", header = TRUE, stringsAsFactors = FALSE))
```
