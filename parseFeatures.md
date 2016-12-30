parseFeatures
================

Analyzes the feature vectors of the HAR Data Set V1.0
-----------------------------------------------------

Load features, signals, variables, angleVectors
-----------------------------------------------

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
basedir <- getwd()
features <- read.table(file.path(basedir,
                                 "UCI HAR Dataset",
                                 "features.txt"),
                       col.names = c("id", "name"),
                       stringsAsFactors = FALSE)
signals <- read.table(file.path(basedir,
                                "UCI HAR Dataset",
                                "features_info.txt"),
                      col.names = "name",
                      stringsAsFactors = FALSE,
                      skip = 12, nrows = 17)
variables <-  read.table(file.path(basedir,
                                   "UCI HAR Dataset",
                                   "features_info.txt"),
                         sep = ":",
                         strip.white = TRUE,
                         col.names = c("name","description"),
                         stringsAsFactors = FALSE,
                         skip = 32, nrows = 17)
angleVectors <- read.table(file.path(basedir,
                                     "UCI HAR Dataset",
                                     "features_info.txt"),
                           col.names = "name",
                           stringsAsFactors = FALSE,
                           skip = 52,
                           nrows = 5)
```

Create a domain parameters data frame
-------------------------------------

``` r
domains <- data.frame(list(name = c("time","frequency","angle"),
                           domain.prefix = c("t",
                                             "f",
                                             "angle"),
                           domain.prefix.pattern = c("^t.*",
                                                     "^f.*",
                                                     "^angle.*"),
                           domain.prefix.replacement = c("time",
                                                         "frequency",
                                                         "angle"),
                           signal.prefix.pattern = c("^t|-XYZ$",
                                                     "^f|-XYZ$",
                                                     "^angle[(]|[)]"),
                           signal.prefix.replacement = c("","",""),
                           signal.suffix = c("-XYZ",
                                           "-XYZ",
                                           ""),
                           signal.suffix.pattern = c(".+-|.+Mag$",
                                                     ".+-|.+Mag$",""),
                           signal.suffix.replacement = c("","",""),
                           symbol = c("t","f","<U+2220>")),
                      #row.names = c("time","frequency","angle"),
                      stringsAsFactors = FALSE)
```

Tidy signals:
-------------

``` r
signals <- signals %>%
    mutate(prefix = gsub("-XYZ$","",name),
           separator = gsub("[a-zA-Z]+|XYZ$|.+Mag$","",name),
           X1 = gsub(".+-|YZ$|.+Mag$","",name),
           X2 = gsub(".+-X|Z$|.+Mag$","",name),
           X3 = gsub(".+-XY|.+Mag$","",name)) %>%
    gather(X, axis, X1:X3) %>%
    mutate(X = NULL,
             name = paste0(prefix, separator, axis)) %>%
    arrange(name) %>%
    distinct() %>%
    print
```

    ##                name           prefix separator axis
    ## 1        fBodyAcc-X         fBodyAcc         -    X
    ## 2        fBodyAcc-Y         fBodyAcc         -    Y
    ## 3        fBodyAcc-Z         fBodyAcc         -    Z
    ## 4    fBodyAccJerk-X     fBodyAccJerk         -    X
    ## 5    fBodyAccJerk-Y     fBodyAccJerk         -    Y
    ## 6    fBodyAccJerk-Z     fBodyAccJerk         -    Z
    ## 7   fBodyAccJerkMag  fBodyAccJerkMag               
    ## 8       fBodyAccMag      fBodyAccMag               
    ## 9       fBodyGyro-X        fBodyGyro         -    X
    ## 10      fBodyGyro-Y        fBodyGyro         -    Y
    ## 11      fBodyGyro-Z        fBodyGyro         -    Z
    ## 12 fBodyGyroJerkMag fBodyGyroJerkMag               
    ## 13     fBodyGyroMag     fBodyGyroMag               
    ## 14       tBodyAcc-X         tBodyAcc         -    X
    ## 15       tBodyAcc-Y         tBodyAcc         -    Y
    ## 16       tBodyAcc-Z         tBodyAcc         -    Z
    ## 17   tBodyAccJerk-X     tBodyAccJerk         -    X
    ## 18   tBodyAccJerk-Y     tBodyAccJerk         -    Y
    ## 19   tBodyAccJerk-Z     tBodyAccJerk         -    Z
    ## 20  tBodyAccJerkMag  tBodyAccJerkMag               
    ## 21      tBodyAccMag      tBodyAccMag               
    ## 22      tBodyGyro-X        tBodyGyro         -    X
    ## 23      tBodyGyro-Y        tBodyGyro         -    Y
    ## 24      tBodyGyro-Z        tBodyGyro         -    Z
    ## 25  tBodyGyroJerk-X    tBodyGyroJerk         -    X
    ## 26  tBodyGyroJerk-Y    tBodyGyroJerk         -    Y
    ## 27  tBodyGyroJerk-Z    tBodyGyroJerk         -    Z
    ## 28 tBodyGyroJerkMag tBodyGyroJerkMag               
    ## 29     tBodyGyroMag     tBodyGyroMag               
    ## 30    tGravityAcc-X      tGravityAcc         -    X
    ## 31    tGravityAcc-Y      tGravityAcc         -    Y
    ## 32    tGravityAcc-Z      tGravityAcc         -    Z
    ## 33   tGravityAccMag   tGravityAccMag

Cross check features
--------------------

    1) features X signals 
    2) features X variables 
    3) features X angleVectors

Time Magnitude Signal Pattern:
------------------------------

`timeMagnitudeSignal-variable()`

    occurrences: 5 signals X 9 variables = 45
    timeMagnitudeSignals:   tBodyAccMag, tGravityAccMag,
                            tBodyAccJerkMag, tBodyGyroMag,                                          
                            tBodyGyroJerkMag
    variables:  mean(), std(), mad(), max(), min(), sma(), energy(),
                iqr(), entropy()

`timeMagnitudeSignal-variable()level`

    occurrences: 5 signals X 1 variable X 4 levels = 20
    timeMagnituedSignals:   tBodyAccMag, tGravityAccMag,
                            tBodyAccJerkMag, tBodyGyroMag,
                            tBodyGyroJerkMag
    variables: arCoeff()
    levels: 4    

Frequency Magnitude Signal Pattern:
-----------------------------------

`frequencyMagnitudeSignal-variable()`

    occurrences: 4 signals X 12 variable = 48
    frequencyMagnitudeSignals:  fBodyAccMag, fBody*Body*AccJerkMag,
                                fBody*Body*GyroMag,
                                fBody*Body*GyroJerkMag 
    variables:  mean(), std(), mad(), max(), min(), sma(), energy(),
                iqr(), entropy() `plus` meanFreq(), skewness(),
                kurtosis()

`frequencyMagnitudeSignal-variable`

    occurrences: 4 signals X 1 variable = 4
    frequencyMagnitudeSignals:  fBodyAccMag, fBody*Body*AccJerkMag,
                                fBody*Body*GyroMag,
                                fBody*Body*GyroJerkMag 
    variable: maxInds

Time Axial Signal Pattern:
--------------------------

`timeAxialSignal-variable()`

    occurrences: 5 3-axial-signals X 1 variable = 5
    timeAxialSignals:   tBodyAcc, tGravityAcc, tBodyAccJerk,
                        tBodyGyro, tBodyGyroJerk, 
    variables:  sma()
    axis: 3-axial (XYZ)

`timeAxialSignal-variable()-X`

    occurrences: 5 signals X 8 variables X 3 axis = 120
    timeAxialSignals:   tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro,
                        tBodyGyroJerk, 
    variables:  mean(), std(), mad(), max(), min(), energy(), iqr(),
                entropy(), 
    axis: X, Y, Z

`timeAxialSignal-variable()-X,Y`

    occurrences: 5 signals X 1 variable = 5
    timeAxialSignals:   tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro,
                        tBodyGyroJerk
    variable: correlation()
    (axis: X, Y)

`timeAxialSignal-variable()-Y,Z`

    occurrences: 5 signals X 1 variable = 5
    timeAxialSignals:   tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro,
                        tBodyGyroJerk
    variable: correlation()
    (axis: Y, Z)

`timeAxialSignal-variable()-X,Z`

    occurrences: 5 signals X 1 variable = 5
    timeAxialSignals:   tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro,
                        tBodyGyroJerk
    variable: correlation()
    (axis: X, Z)

`timeAxialSignal-variable()-axis,level`

    occurrences: 5 signals X 1 variable X 3 axis X 4 levels  = 60
    timeAxialSignals:   tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro,
                        tBodyGyroJerk
    variables:  arCoeff()
    axis: X, Y, Z
    levels: 1, 2, 3, 4

Frequency Axial Signal Pattern:
-------------------------------

`frequencyAxialSignal-variable()`

    occurrences: 3 3-axial-signals X 1 variable = 3
    frequencyAxialSignals: fBodyAcc, fBodyAccJerk, fBodyGyro
    variables: sma()
    axis: 3-axial (XYZ)

`frequencyAxialSignal-variable-axis`

    occurrences: 3 signals X 1 variable X 3 axis = 9
    frequencyAxialSignals: fBodyAcc, fBodyAccJerk, fBodyGyro
    variables: maxInds
    axis: X, Y, Z

`frequencyAxialSignal-variable()-axis`

    occurrences: 3 signals X 11 X 3 axis = 99
    frequencyAxialSignals: fBodyAcc, fBodyAccJerk, fBodyGyro
    variables:  mean(), std(), mad(), max(), min(), energy(), iqr(), entropy(),
                meanFreq(), skewnewss(), kurtosis()
    axis: X, Y, Z

Frequency Interval Energy Signal Pattern:
-----------------------------------------

`frequencyIntervalEnergySignal-variable()-lower,upper`

    occurrences: 3 3-axial-signals X 1 variable X 3 series X (8+4+2 levels)=126
    frequencyIntervalEnergySignals: fBodyAcc, fBodyAccJerk, fBodyGyro
    variables:  bandsEnergy() - Energy of a frequency interval
                within the 64 bins of the FFT of each window.
    axis: 3-axial (XYZ)
    interval series:
        8 in 64: [1,8],[9,16],[17,24],[25,32],[33,40],[41,48],[49,56],[57,64]
        4 in 64: [1,16],[17,32],[33,48],[49,64]
        2 in 48: [1,24],[25,48]

``` r
bins <- c(1:64)
levels(cut(bins, breaks = 8))
```

    ## [1] "(0.937,8.88]" "(8.88,16.8]"  "(16.8,24.6]"  "(24.6,32.5]" 
    ## [5] "(32.5,40.4]"  "(40.4,48.2]"  "(48.2,56.1]"  "(56.1,64.1]"

``` r
levels(cut(bins, breaks = 4))
```

    ## [1] "(0.937,16.8]" "(16.8,32.5]"  "(32.5,48.2]"  "(48.2,64.1]"

``` r
bins <- c(1:48)
levels(cut(bins, breaks = 2))
```

    ## [1] "(0.953,24.5]" "(24.5,48]"

Angle Pattern
-------------

`angle(angleArgument,angleArgument)`

    occurrences: 1 variable X 7 paired arguments = 7
    variable: angle()
    AngleArguments: (tBodyAccMean,gravity)
                    (tBodyAccJerkMean*)*,gravityMean)
                    (tBodyGyroMean,gravityMean)
                    (tBodyGyroJerkMean,gravityMean)
                    (X,gravityMean)
                    (Y,gravityMean)
                    (Z,gravityMean)
                    

``` r
examples <- c("tBodyAcc-mean()-X",
              "tBodyAcc-sma()",
                "tBodyAcc-arCoeff()-X,1",
              "tBodyAcc-correlation()-X,Y",
              "tBodyAccMag-arCoeff()1",
              "fBodyAcc-bandsEnergy()-57,64",
              "fBodyAccMag-maxInds",
              "angle(tBodyAccMean,gravity)",
              "angle(tBodyAccJerkMean),gravityMean)",
              "angle(tBodyGyroMean,gravityMean)",
              "angle(tBodyGyroJerkMean,gravityMean)",
              "angle(X,gravityMean)",
              "angle(Y,gravityMean)",
              "angle(Z,gravityMean)")
```
