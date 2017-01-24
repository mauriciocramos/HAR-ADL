HAR-analysis
================
by Maurício Collaça
2017-01-24

Human Activity Recognition (HAR) using smartphones Data Set analysis
--------------------------------------------------------------------

An exciting area in Data Science is Wearable Computing - see for example this [article from Inside Activity Tracking](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/). Companies like [Fitbit](https://www.fitbit.com/), [Nike](http://www.nike.com/), [Jawbone Up](https://jawbone.com/up), [Strava](https://www.strava.com/), and many others are racing to develop the most advanced algorithms to attract new users.

The purpose of this project is to collect, tidy, filter and produce some statistics of the HAR data set, producing a new tidy data set.

The data set used in the project is from the University of California Irvine (UCI) Machine Learning Repository: Human Activity Recognition Using Smartphones Data Set Version 1.0. The data set represent data collected from the embedded accelerometer and gyroscope of the Samsung Galaxy S smartphone. A full description is available at:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

The data set for the project:

Mirror:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>
Original:
<http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip>

About this README:
------------------

This document is an explanation about the Github repository [HAR-analysis](https://github.com/mauriciocramos/HAR-analysis) and its files developed for the [Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science) at [John Hopkins University](https://www.jhu.edu/).

The repository [HAR-analysis](https://github.com/mauriciocramos/HAR-analysis) includes the following files:
-----------------------------------------------------------------------------------------------------------

-   [README.md](https://github.com/mauriciocramos/HAR-analysis/blob/master/README.md) - This README file.

-   [CodeBook.md](https://github.com/mauriciocramos/HAR-analysis/blob/master/CodeBook.md) - A code book markdown file that indicate all the variables and summaries calculated, along with units, and any other relevant information about the output file [averages](https://github.com/mauriciocramos/HAR-analysis/blob/master/averages.txt)

-   [run\_analysis.R](https://github.com/mauriciocramos/HAR-analysis/blob/master/run_analysis.R) - R script to perform the data download, tidying and analysis required by the project.

-   [averages.txt](https://github.com/mauriciocramos/HAR-analysis/blob/master/averages.txt) - Tidy data set output from [run\_analysis.R](https://github.com/mauriciocramos/HAR-analysis/blob/master/run_analysis.R), containing the the average of each mean and standard deviation variable for each activity and each subject. Specific details about the data are found in its [CodeBook.md](https://github.com/mauriciocramos/HAR-analysis/blob/master/CodeBook.md).

-   [HAR-utils.R](https://github.com/mauriciocramos/HAR-analysis/blob/master/HAR-utils.R) - R script containing functions developed to encapsulate code and improve the reusability and the readability of the [run\_analysis.R](https://github.com/mauriciocramos/HAR-analysis/blob/master/run_analysis.R).

General information about the environment used
----------------------------------------------

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

The [`run_analysis.R`](https://github.com/mauriciocramos/HAR-analysis/blob/master/run_analysis.R) script
--------------------------------------------------------------------------------------------------------

Requirements to run the script:

1.  Installation of the packages {dplyr} and {tidyr}.
2.  Download both `run_analysis.R` and `HAR-utils.R` in some local working directory

To run the script:

1.  Open `R` or `RStudio`
2.  Go to the directory where the scripts were download, for instance, `setwd("your-directory-here")`
3.  Run the command: `source("run_analysis.R")`

With the hardware and software configuration described earlier, it takes around 55 seconds to complete at the first time, which also includes the downloading and uncompressing tasks. That also depends on the internet connection to the <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> at running time.

`system.time(source("run_analysis.R"))`

     user  system elapsed
    17.86    7.71   54.25

On the next times you run it, there won't be any download and uncompressing tasks and it would take around 14 seconds.

`system.time(source("run_analysis.R"))`

     user  system elapsed
    12.85    0.36   13.36

The [`run_analysis.R`](https://github.com/mauriciocramos/HAR-analysis/blob/master/run_analysis.R) script was developed to fullfill the following formal requirements of the project:

> 1.  Merges the training and the test sets to create one data set.
> 2.  Extracts only the measurements on the mean and standard deviation for each measurement.
> 3.  Uses descriptive activity names to name the activities in the data set
> 4.  Appropriately labels the data set with descriptive variable names.
> 5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Before explaining the solutions developed for the requirements 1 through 5, first it's explained the additional R packages used and the loading of the HAR data set files which consists of multiple directories and files.

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

The script downloads the zip file `Dataset.zip` into your working directory only once, unless you delete it, letting the script download it again.

``` r
url <- 
'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
destfile = 'Dataset.zip'
if(!file.exists(destfile)) { download.file(url, destfile, mode = "wb") }
```

The zip file `Dataset.zip` contains a subdirectory structure and multiple files that `run_analysis.R` needs to read. The following command displays those files:

``` r
unzip(zipfile = "Dataset.zip", list = TRUE)[c(1:2,16:18,30:32),1]
```

    ## [1] "UCI HAR Dataset/activity_labels.txt"    
    ## [2] "UCI HAR Dataset/features.txt"           
    ## [3] "UCI HAR Dataset/test/subject_test.txt"  
    ## [4] "UCI HAR Dataset/test/X_test.txt"        
    ## [5] "UCI HAR Dataset/test/y_test.txt"        
    ## [6] "UCI HAR Dataset/train/subject_train.txt"
    ## [7] "UCI HAR Dataset/train/X_train.txt"      
    ## [8] "UCI HAR Dataset/train/y_train.txt"

`features.txt` is the list of the 561 feature names produced by the experiment.

`activity_labels.txt` is the list of the six activities carried out in the experiment. Each row contains an activity identifier and a label.

`X_train.txt` is the trainning observation set of the experiment. Each row contains a 561-feature vector with time and frequency domain variables.

`X_test.txt` is the test observation set of the experiment. Each row contains a 561-feature vector with time and frequency domain variables.

`y_train.txt` contains the identifiers of the activities associated with the trainning observation set.

`y_test.txt` contains the identifiers of the activities associated with the test observation set.

`subject_train.txt` contains the identifiers of the subjects who carried out the trainning activities of the experiment. Each row identifies the subject who performed the activity for each window sample.

`subject_test.txt` contains the identifiers of the subjects who carried out the trainning activities of the experiment. Each row identifies the subject who performed the activity for each window sample.

The script uncompress the zip file `Dataset.zip` into the the folder `UCI HAR Dataset` of the working directory only once, unless you delete this folder, letting the script uncompress the zip file again:

``` r
if(!dir.exists("UCI HAR Dataset")) { unzip(destfile, setTimes = TRUE) }
```

As mentioned above, in order to encapsulate code and improve the reusability and the readability of the [`run_analysis.R`](https://github.com/mauriciocramos/HAR-analysis/blob/master/run_analysis.R) script, the file reading functions were written in a separate R script called [HAR-utils.R](https://github.com/mauriciocramos/HAR-analysis/blob/master/HAR-utils.R).

``` r
source("HAR-utils.R")
```

It's not necessary to read the `HAR-utils.R` source code in order to understand the [`run_analysis.R`](https://github.com/mauriciocramos/HAR-analysis/blob/master/run_analysis.R).

These functions loads the data set files into R `data.frame` objects:

`read_feature()` reads the `features.txt`
`read_activity_labels()` reads the `activity_labels.txt`
`read_X()` reads either `X_train.txt` or `X_test.txt`
`read_y()` reads either `y_train.txt` or `y_test.txt`
`read_subject()` reads either `subject_train.txt` or `subject_test.txt`

### 1. Merges the training and the test sets to create one data set.

Based on Hadley Wickham's concept "Tidying messy data sets" and "One type in multiple tables" at <https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html>, the approach is to merge the observations (`X_train`, `X_test`) with their respective subjects (`subject_train`, `subject_test`) and respective activities (`y_train`, `y_test`), then finally merge both previously merged sets.

In other words:

-   Bind columns of the three trainning sets `subject_train`, `y_train`, `X_train`
-   Bind columns of the three test sets `subject_test`, `y_test`, `X_test`
-   Bind rows of the two previously bound sets

Used `dplyr` functions `bind_cols()` for horizontal merging and `bind_rows()` for vertical merging:

``` r
dataset <-
    bind_rows(
        bind_cols(read_subject("train"), read_y("train"), read_X("train")),
        bind_cols(read_subject("test"), read_y("test"), read_X("test"))
    )
```

Number of rows after merging:

``` r
nrow(dataset)
```

    ## [1] 10299

Number of columns after merging:

``` r
length(dataset)
```

    ## [1] 563

Preview of the data set, omitting 556 columns from its middle:

``` r
head(dataset[,c(1:5,562:563)])
```

    ##   subject activity         1           2          3       560         561
    ## 1       1        5 0.2885845 -0.02029417 -0.1329051 0.1799406 -0.05862692
    ## 2       1        5 0.2784188 -0.01641057 -0.1235202 0.1802889 -0.05431672
    ## 3       1        5 0.2796531 -0.01946716 -0.1134617 0.1806373 -0.04911782
    ## 4       1        5 0.2791739 -0.02620065 -0.1232826 0.1819348 -0.04766318
    ## 5       1        5 0.2766288 -0.01656965 -0.1153619 0.1851512 -0.04389225
    ## 6       1        5 0.2771988 -0.01009785 -0.1051373 0.1848225 -0.04212638

As mentioned in the rubric:

> "either long or wide form is acceptable”.

This data set can be tidier. In order to have a tidier (long) data set, it's necessary to collapse the 561 columns that are not variables into key-value pairs.

The following idiom is based on Hadley Wickham's concept "Tidying messy data sets" and "Column headers are values, not variable names" at: <https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html>

The `tidyr` function `gather()` takes the right-most 561 columns and collapse them into key-value pairs `feature,value`, duplicating rows for columns `subject` and `activity` as needed.

``` r
dataset <- dataset %>%
    gather(key = feature,
           value = value,
           3:563,
           convert = TRUE)
```

Preview of the tidy data set:

``` r
str(dataset)
```

    ## 'data.frame':    5777739 obs. of  4 variables:
    ##  $ subject : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ activity: int  5 5 5 5 5 5 5 5 5 5 ...
    ##  $ feature : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ value   : num  0.289 0.278 0.28 0.279 0.277 ...

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

Initially, this requirement \#2 was not perfectly clear whether the extraction should affect the results of the next requirements. Following a good sense and the discussions in the regarding forums, It is assumed the extraction shall affect the existent tidy dataset.

According to the `features_info.txt` provided by Human Activity Recognition Using Smartphones Dataset Version 1.0, relevant features were found:

> The set of variables that were estimated from these signals are:
> mean(): Mean value
> std(): Standard deviation
> (...)
> meanFreq(): Weighted average of the frequency components to obtain a mean frequency
> (...)

According to the `features_info.txt`, there are other vectors that, although means, their respective features are actually `angles`:

> Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable: gravityMean, tBodyAccMean, tBodyAccJerkMean, tBodyGyroMean, BodyGyroJerkMean.

> angle(tBodyAccMean,gravity)
> angle(tBodyAccJerkMean),gravityMean)
> angle(tBodyGyroMean,gravityMean)
> angle(tBodyGyroJerkMean,gravityMean)
> angle(X,gravityMean)
> angle(Y,gravityMean)
> angle(Z,gravityMean)

Thus, these `angle()` variables will not be extracted to fullfill the requirement \#2 because the atomic unit in the dataset is the `feature` and not an implicit `vector` that may composes a `feature`.

After all this reasoning and for the sake of the completeness, it is assumed that either `mean()` and `meanFreq()` and `std()` represent valid feature variables (substrings) to fullfill the requirement \#2.

Create a regular expression filter to subset the feature ids required, considering the substrings `mean()`, `meanFreq()` and `std()`

``` r
features<-read_features()
selectedFeatureIds <- features[grep("(mean|meanFreq|std)\\(\\)",features$name), 1]
```

Extract the mean and standard deviation variables

``` r
dataset <- dataset %>% filter(feature %in% selectedFeatureIds)
```

Preview of this filtered data set:

``` r
str(dataset)
```

    ## 'data.frame':    813621 obs. of  4 variables:
    ##  $ subject : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ activity: int  5 5 5 5 5 5 5 5 5 5 ...
    ##  $ feature : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ value   : num  0.289 0.278 0.28 0.279 0.277 ...

### 3. Uses descriptive activity names to name the activities in the data set

Used `dplyr` function `mutate()` to replace the activity id with the activity label from the `activity_labels` data set.

``` r
activity_labels <- read_activity_labels()
dataset <- mutate(dataset, activity = activity_labels$name[activity])
```

Preview of the named activities:

``` r
str(dataset)
```

    ## 'data.frame':    813621 obs. of  4 variables:
    ##  $ subject : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ activity: chr  "STANDING" "STANDING" "STANDING" "STANDING" ...
    ##  $ feature : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ value   : num  0.289 0.278 0.28 0.279 0.277 ...

### 4. Appropriately labels the data set with descriptive variable names.

Used `dplyr` function `mutate()` to replace the feature id with the feature name from the `features` data set.

``` r
dataset <- dataset %>%
    mutate(feature = features$name[feature])
```

Preview of the named features:

``` r
str(dataset)
```

    ## 'data.frame':    813621 obs. of  4 variables:
    ##  $ subject : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ activity: chr  "STANDING" "STANDING" "STANDING" "STANDING" ...
    ##  $ feature : chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-X" "tBodyAcc-mean()-X" "tBodyAcc-mean()-X" ...
    ##  $ value   : num  0.289 0.278 0.28 0.279 0.277 ...

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Used `dplyr` functions `group_by()` and `summarize()` with the `base` function `mean()` to fast and easily calculate the average of all `values` grouped by `subject`, `activity` and `variable`.

``` r
averages <- dataset %>%
    group_by(subject, activity, feature) %>%
    summarize(average = mean(value)) %>%
    as.data.frame
```

Preview of the result:

``` r
str(averages)
```

    ## 'data.frame':    14220 obs. of  4 variables:
    ##  $ subject : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ activity: chr  "LAYING" "LAYING" "LAYING" "LAYING" ...
    ##  $ feature : chr  "fBodyAcc-mean()-X" "fBodyAcc-mean()-Y" "fBodyAcc-mean()-Z" "fBodyAcc-meanFreq()-X" ...
    ##  $ average : num  -0.9391 -0.8671 -0.8827 -0.1588 0.0975 ...

The result is exported to the file [`averages.txt`](https://github.com/mauriciocramos/HAR-analysis/blob/master/averages.txt) in the current working directory

``` r
write.table(averages, file = "averages.txt", row.names = FALSE)
```

For the peer reviewing of the file [`averages.txt`](https://github.com/mauriciocramos/HAR-analysis/blob/master/averages.txt) one can load it with the following command

``` r
View(read.table("averages.txt", header = TRUE, stringsAsFactors = FALSE))
```

Acknowledgment
--------------

\[1\] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.
