HAR-features
================
by Maurício Collaça
2017-01-23

Introduction
------------

Analyzes the feature vectors, signals, statistics and angle vectors of the HAR Data Set V1.0

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
source("HAR-utils.R")
```

Load features, signals and calculus
-----------------------------------

``` r
features <- read_features()
str(features)
```

    ## 'data.frame':    561 obs. of  2 variables:
    ##  $ id  : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ name: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...

``` r
signals <- read_signals()
signals
```

    ##                 name
    ## 1       tBodyAcc-XYZ
    ## 2    tGravityAcc-XYZ
    ## 3   tBodyAccJerk-XYZ
    ## 4      tBodyGyro-XYZ
    ## 5  tBodyGyroJerk-XYZ
    ## 6        tBodyAccMag
    ## 7     tGravityAccMag
    ## 8    tBodyAccJerkMag
    ## 9       tBodyGyroMag
    ## 10  tBodyGyroJerkMag
    ## 11      fBodyAcc-XYZ
    ## 12  fBodyAccJerk-XYZ
    ## 13     fBodyGyro-XYZ
    ## 14       fBodyAccMag
    ## 15   fBodyAccJerkMag
    ## 16      fBodyGyroMag
    ## 17  fBodyGyroJerkMag

``` r
calculus <- read_calculus()
paste(calculus$name, calculus$description)
```

    ##  [1] "mean() Mean value"                                                                         
    ##  [2] "std() Standard deviation"                                                                  
    ##  [3] "mad() Median absolute deviation"                                                           
    ##  [4] "max() Largest value in array"                                                              
    ##  [5] "min() Smallest value in array"                                                             
    ##  [6] "sma() Signal magnitude area"                                                               
    ##  [7] "energy() Energy measure. Sum of the squares divided by the number of values."              
    ##  [8] "iqr() Interquartile range"                                                                 
    ##  [9] "entropy() Signal entropy"                                                                  
    ## [10] "arCoeff() Autorregresion coefficients with Burg order equal to 4"                          
    ## [11] "correlation() correlation coefficient between two signals"                                 
    ## [12] "maxInds() index of the frequency component with largest magnitude"                         
    ## [13] "meanFreq() Weighted average of the frequency components to obtain a mean frequency"        
    ## [14] "skewness() skewness of the frequency domain signal"                                        
    ## [15] "kurtosis() kurtosis of the frequency domain signal"                                        
    ## [16] "bandsEnergy() Energy of a frequency interval within the 64 bins of the FFT of each window."
    ## [17] "angle() Angle between to vectors."

Signal name decomposition
-------------------------

``` r
signals %>%
    mutate(domain = sub("^(t|f).+","\\1",name),
           component = sub("^.+(Body|Gravity).+","\\1",name),
           sensor = sub("^.+(Acc|Gyro).+","\\1",name),
           jerk = sub("^.+(Jerk).+|.+","\\1",name),
           magnitude = sub("^.+(Mag)$|.+","\\1",name),
           separator = sub("^.+(-)XYZ$|.+","\\1",name),
           X1 = sub("^.+(X)YZ$|.+","\\1",name),
           X2 = sub("^.+X(Y)Z$|.+","\\1",name),
           X3 = sub("^.+XY(Z)$|.+","\\1",name)) %>%
    mutate(name = NULL) %>%
    gather(X, axis, X1:X3) %>%
    mutate(X = NULL) %>%
    distinct() %>%
    unite(name, everything(), sep = "", remove = FALSE) %>%
    arrange(name)
```

    ##                name domain component sensor jerk magnitude separator axis
    ## 1        fBodyAcc-X      f      Body    Acc                        -    X
    ## 2        fBodyAcc-Y      f      Body    Acc                        -    Y
    ## 3        fBodyAcc-Z      f      Body    Acc                        -    Z
    ## 4    fBodyAccJerk-X      f      Body    Acc Jerk                   -    X
    ## 5    fBodyAccJerk-Y      f      Body    Acc Jerk                   -    Y
    ## 6    fBodyAccJerk-Z      f      Body    Acc Jerk                   -    Z
    ## 7   fBodyAccJerkMag      f      Body    Acc Jerk       Mag               
    ## 8       fBodyAccMag      f      Body    Acc            Mag               
    ## 9       fBodyGyro-X      f      Body   Gyro                        -    X
    ## 10      fBodyGyro-Y      f      Body   Gyro                        -    Y
    ## 11      fBodyGyro-Z      f      Body   Gyro                        -    Z
    ## 12 fBodyGyroJerkMag      f      Body   Gyro Jerk       Mag               
    ## 13     fBodyGyroMag      f      Body   Gyro            Mag               
    ## 14       tBodyAcc-X      t      Body    Acc                        -    X
    ## 15       tBodyAcc-Y      t      Body    Acc                        -    Y
    ## 16       tBodyAcc-Z      t      Body    Acc                        -    Z
    ## 17   tBodyAccJerk-X      t      Body    Acc Jerk                   -    X
    ## 18   tBodyAccJerk-Y      t      Body    Acc Jerk                   -    Y
    ## 19   tBodyAccJerk-Z      t      Body    Acc Jerk                   -    Z
    ## 20  tBodyAccJerkMag      t      Body    Acc Jerk       Mag               
    ## 21      tBodyAccMag      t      Body    Acc            Mag               
    ## 22      tBodyGyro-X      t      Body   Gyro                        -    X
    ## 23      tBodyGyro-Y      t      Body   Gyro                        -    Y
    ## 24      tBodyGyro-Z      t      Body   Gyro                        -    Z
    ## 25  tBodyGyroJerk-X      t      Body   Gyro Jerk                   -    X
    ## 26  tBodyGyroJerk-Y      t      Body   Gyro Jerk                   -    Y
    ## 27  tBodyGyroJerk-Z      t      Body   Gyro Jerk                   -    Z
    ## 28 tBodyGyroJerkMag      t      Body   Gyro Jerk       Mag               
    ## 29     tBodyGyroMag      t      Body   Gyro            Mag               
    ## 30    tGravityAcc-X      t   Gravity    Acc                        -    X
    ## 31    tGravityAcc-Y      t   Gravity    Acc                        -    Y
    ## 32    tGravityAcc-Z      t   Gravity    Acc                        -    Z
    ## 33   tGravityAccMag      t   Gravity    Acc            Mag

Feature name patches
--------------------

``` r
source("dsub.R")
```

### Feature names containing duplicated component

``` r
dsub(features, "name", "^.([A-Z][a-z]+)(\\1).*", "", explain = TRUE)
```

    ## It would affect 39 row(s) with the sentence: 
    ## 
    ## features[516:554, "name"] <- sub("Body", "", features[516:554, "name"])

    ##  [1] "fBodyBodyAccJerkMag-mean()" <- "fBodyAccJerkMag-mean()"          
    ##  [2] "fBodyBodyAccJerkMag-std()" <- "fBodyAccJerkMag-std()"            
    ##  [3] "fBodyBodyAccJerkMag-mad()" <- "fBodyAccJerkMag-mad()"            
    ##  [4] "fBodyBodyAccJerkMag-max()" <- "fBodyAccJerkMag-max()"            
    ##  [5] "fBodyBodyAccJerkMag-min()" <- "fBodyAccJerkMag-min()"            
    ##  [6] "fBodyBodyAccJerkMag-sma()" <- "fBodyAccJerkMag-sma()"            
    ##  [7] "fBodyBodyAccJerkMag-energy()" <- "fBodyAccJerkMag-energy()"      
    ##  [8] "fBodyBodyAccJerkMag-iqr()" <- "fBodyAccJerkMag-iqr()"            
    ##  [9] "fBodyBodyAccJerkMag-entropy()" <- "fBodyAccJerkMag-entropy()"    
    ## [10] "fBodyBodyAccJerkMag-maxInds" <- "fBodyAccJerkMag-maxInds"        
    ## [11] "fBodyBodyAccJerkMag-meanFreq()" <- "fBodyAccJerkMag-meanFreq()"  
    ## [12] "fBodyBodyAccJerkMag-skewness()" <- "fBodyAccJerkMag-skewness()"  
    ## [13] "fBodyBodyAccJerkMag-kurtosis()" <- "fBodyAccJerkMag-kurtosis()"  
    ## [14] "fBodyBodyGyroMag-mean()" <- "fBodyGyroMag-mean()"                
    ## [15] "fBodyBodyGyroMag-std()" <- "fBodyGyroMag-std()"                  
    ## [16] "fBodyBodyGyroMag-mad()" <- "fBodyGyroMag-mad()"                  
    ## [17] "fBodyBodyGyroMag-max()" <- "fBodyGyroMag-max()"                  
    ## [18] "fBodyBodyGyroMag-min()" <- "fBodyGyroMag-min()"                  
    ## [19] "fBodyBodyGyroMag-sma()" <- "fBodyGyroMag-sma()"                  
    ## [20] "fBodyBodyGyroMag-energy()" <- "fBodyGyroMag-energy()"            
    ## [21] "fBodyBodyGyroMag-iqr()" <- "fBodyGyroMag-iqr()"                  
    ## [22] "fBodyBodyGyroMag-entropy()" <- "fBodyGyroMag-entropy()"          
    ## [23] "fBodyBodyGyroMag-maxInds" <- "fBodyGyroMag-maxInds"              
    ## [24] "fBodyBodyGyroMag-meanFreq()" <- "fBodyGyroMag-meanFreq()"        
    ## [25] "fBodyBodyGyroMag-skewness()" <- "fBodyGyroMag-skewness()"        
    ## [26] "fBodyBodyGyroMag-kurtosis()" <- "fBodyGyroMag-kurtosis()"        
    ## [27] "fBodyBodyGyroJerkMag-mean()" <- "fBodyGyroJerkMag-mean()"        
    ## [28] "fBodyBodyGyroJerkMag-std()" <- "fBodyGyroJerkMag-std()"          
    ## [29] "fBodyBodyGyroJerkMag-mad()" <- "fBodyGyroJerkMag-mad()"          
    ## [30] "fBodyBodyGyroJerkMag-max()" <- "fBodyGyroJerkMag-max()"          
    ## [31] "fBodyBodyGyroJerkMag-min()" <- "fBodyGyroJerkMag-min()"          
    ## [32] "fBodyBodyGyroJerkMag-sma()" <- "fBodyGyroJerkMag-sma()"          
    ## [33] "fBodyBodyGyroJerkMag-energy()" <- "fBodyGyroJerkMag-energy()"    
    ## [34] "fBodyBodyGyroJerkMag-iqr()" <- "fBodyGyroJerkMag-iqr()"          
    ## [35] "fBodyBodyGyroJerkMag-entropy()" <- "fBodyGyroJerkMag-entropy()"  
    ## [36] "fBodyBodyGyroJerkMag-maxInds" <- "fBodyGyroJerkMag-maxInds"      
    ## [37] "fBodyBodyGyroJerkMag-meanFreq()" <- "fBodyGyroJerkMag-meanFreq()"
    ## [38] "fBodyBodyGyroJerkMag-skewness()" <- "fBodyGyroJerkMag-skewness()"
    ## [39] "fBodyBodyGyroJerkMag-kurtosis()" <- "fBodyGyroJerkMag-kurtosis()"

### Patch duplicated component

``` r
dsub(features, "name", "^.([A-Z][a-z]+)(\\1).*", "", explain = FALSE)
```

    ## It was affected 39 row(s) with the sentence: 
    ## 
    ## features[516:554, "name"] <- sub("Body", "", features[516:554, "name"])

    ##  [1] "fBodyAccJerkMag-mean()"      "fBodyAccJerkMag-std()"      
    ##  [3] "fBodyAccJerkMag-mad()"       "fBodyAccJerkMag-max()"      
    ##  [5] "fBodyAccJerkMag-min()"       "fBodyAccJerkMag-sma()"      
    ##  [7] "fBodyAccJerkMag-energy()"    "fBodyAccJerkMag-iqr()"      
    ##  [9] "fBodyAccJerkMag-entropy()"   "fBodyAccJerkMag-maxInds"    
    ## [11] "fBodyAccJerkMag-meanFreq()"  "fBodyAccJerkMag-skewness()" 
    ## [13] "fBodyAccJerkMag-kurtosis()"  "fBodyGyroMag-mean()"        
    ## [15] "fBodyGyroMag-std()"          "fBodyGyroMag-mad()"         
    ## [17] "fBodyGyroMag-max()"          "fBodyGyroMag-min()"         
    ## [19] "fBodyGyroMag-sma()"          "fBodyGyroMag-energy()"      
    ## [21] "fBodyGyroMag-iqr()"          "fBodyGyroMag-entropy()"     
    ## [23] "fBodyGyroMag-maxInds"        "fBodyGyroMag-meanFreq()"    
    ## [25] "fBodyGyroMag-skewness()"     "fBodyGyroMag-kurtosis()"    
    ## [27] "fBodyGyroJerkMag-mean()"     "fBodyGyroJerkMag-std()"     
    ## [29] "fBodyGyroJerkMag-mad()"      "fBodyGyroJerkMag-max()"     
    ## [31] "fBodyGyroJerkMag-min()"      "fBodyGyroJerkMag-sma()"     
    ## [33] "fBodyGyroJerkMag-energy()"   "fBodyGyroJerkMag-iqr()"     
    ## [35] "fBodyGyroJerkMag-entropy()"  "fBodyGyroJerkMag-maxInds"   
    ## [37] "fBodyGyroJerkMag-meanFreq()" "fBodyGyroJerkMag-skewness()"
    ## [39] "fBodyGyroJerkMag-kurtosis()"

### Feature names containing invalid parenthesis

``` r
dsub(features, "name", "^.+[\\(].+([\\)]).+[\\)].*", "", explain = TRUE)
```

    ## It would affect 1 row(s) with the sentence: 
    ## 
    ## features[556, "name"] <- sub("\\)", "", features[556, "name"])

    ## [1] "angle(tBodyAccJerkMean),gravityMean)" <- "angle(tBodyAccJerkMean,gravityMean)"

### Patch invalid parenthesis

``` r
dsub(features, "name", ".*[\\(\\)]+.*([\\(\\)])+.*[\\(\\)]+.*", "", explain = FALSE)
```

    ## It was affected 1 row(s) with the sentence: 
    ## 
    ## features[556, "name"] <- sub("\\)", "", features[556, "name"])

    ## [1] "angle(tBodyAccJerkMean,gravityMean)"

### Feature names containing calculus with missing enclosed parenthesis

``` r
dsub(features, "name", "^[a-zA-Z]+-([a-zA-Z]+)-?[XYZ]?$", "\\1\\(\\)", explain = TRUE)
```

    ## It would affect 13 row(s) with the sentence: 
    ## 
    ## features[c(291, 292, 293, 370, 371, 372, 449, 450, 451, 512, 525, 538, 551), "name"] <- sub("maxInds", "maxInds()", features[c(291, 292, 293, 370, 371, 372, 449, 450, 451, 512, 525, 538, 551), "name"])

    ##  [1] "fBodyAcc-maxInds-X" <- "fBodyAcc-maxInds()-X"            
    ##  [2] "fBodyAcc-maxInds-Y" <- "fBodyAcc-maxInds()-Y"            
    ##  [3] "fBodyAcc-maxInds-Z" <- "fBodyAcc-maxInds()-Z"            
    ##  [4] "fBodyAccJerk-maxInds-X" <- "fBodyAccJerk-maxInds()-X"    
    ##  [5] "fBodyAccJerk-maxInds-Y" <- "fBodyAccJerk-maxInds()-Y"    
    ##  [6] "fBodyAccJerk-maxInds-Z" <- "fBodyAccJerk-maxInds()-Z"    
    ##  [7] "fBodyGyro-maxInds-X" <- "fBodyGyro-maxInds()-X"          
    ##  [8] "fBodyGyro-maxInds-Y" <- "fBodyGyro-maxInds()-Y"          
    ##  [9] "fBodyGyro-maxInds-Z" <- "fBodyGyro-maxInds()-Z"          
    ## [10] "fBodyAccMag-maxInds" <- "fBodyAccMag-maxInds()"          
    ## [11] "fBodyAccJerkMag-maxInds" <- "fBodyAccJerkMag-maxInds()"  
    ## [12] "fBodyGyroMag-maxInds" <- "fBodyGyroMag-maxInds()"        
    ## [13] "fBodyGyroJerkMag-maxInds" <- "fBodyGyroJerkMag-maxInds()"

### Patch missing enclosed parenthesis

``` r
dsub(features, "name", "^[a-zA-Z]+-([a-zA-Z]+)-?[XYZ]?$", "\\1\\(\\)", explain = FALSE)
```

    ## It was affected 13 row(s) with the sentence: 
    ## 
    ## features[c(291, 292, 293, 370, 371, 372, 449, 450, 451, 512, 525, 538, 551), "name"] <- sub("maxInds", "maxInds()", features[c(291, 292, 293, 370, 371, 372, 449, 450, 451, 512, 525, 538, 551), "name"])

    ##  [1] "fBodyAcc-maxInds()-X"       "fBodyAcc-maxInds()-Y"      
    ##  [3] "fBodyAcc-maxInds()-Z"       "fBodyAccJerk-maxInds()-X"  
    ##  [5] "fBodyAccJerk-maxInds()-Y"   "fBodyAccJerk-maxInds()-Z"  
    ##  [7] "fBodyGyro-maxInds()-X"      "fBodyGyro-maxInds()-Y"     
    ##  [9] "fBodyGyro-maxInds()-Z"      "fBodyAccMag-maxInds()"     
    ## [11] "fBodyAccJerkMag-maxInds()"  "fBodyGyroMag-maxInds()"    
    ## [13] "fBodyGyroJerkMag-maxInds()"

Feature axes decomposition
--------------------------

``` r
featureAxes <- features %>%
    select(id,name) %>%
    mutate(axes = sub("^.+(Acc|Gyro|Jerk)(-)([a-zA-Z]+)\\(\\)-?([XYZ]?),?([YZ]?)[0-9]*,?[0-9]*$|.+","\\3\\4\\5",name),
           axes = sub("sma|bandsEnergy", "XYZ", axes),
           axes = sub("correlation(XY|YZ|XZ){1}","\\1",axes),
           axes = sub("arCoeff|energy|entropy|iqr|kurtosis|mad|max|maxInds|mean|meanFreq|min|skewness|std([XYZ])","\\1", axes),
           name = NULL,
           axis1 = sub("(X)?Y?Z?","\\1",axes),
           axis2 = sub("X?(Y)?Z?","\\1",axes),
           axis3 = sub("X?Y?(Z)?","\\1",axes),
           axes = NULL
           ) %>%
    gather(seq, axis, axis1:axis3) %>%
    mutate(seq = as.integer(sub("axis","",seq))) %>%
    filter(axis != "") %>%
    arrange(id)
head(featureAxes)
```

    ##   id seq axis
    ## 1  1   1    X
    ## 2  2   2    Y
    ## 3  3   3    Z
    ## 4  4   1    X
    ## 5  5   2    Y
    ## 6  6   3    Z

Feature name decomposition
--------------------------

``` r
features <- 
features %>%
    mutate(
    domain = sub("^(t|f)?.+","\\1",name),
    component = sub("^[tf]?(Body|Gravity)?.+","\\1",name),
    sensor = sub("^[a-zA-Z]+(Acc|Gyro).+|.+","\\1",name),
    jerk = sub("^[a-zA-Z]+(Jerk).+|.+","\\1",name),
    magnitude = sub("^[a-zA-Z]+(Mag).+|.+","\\1",name),
    signalSep = sub("^[a-zA-Z]+(-).+|.+","\\1",name),
    calculus = sub("^[a-zA-Z]+-([a-zA-Z]+).+|^(angle).+","\\1\\2",name),
    calcOpen = sub("^[a-zA-Z]+-[a-zA-Z]+(\\().+|.+","\\1",name),
    calcClose = sub("^[a-zA-Z]+-[a-zA-Z]+\\((\\)).*|.+","\\1",name),
    calcSep =  sub("^[a-zA-Z]+-[a-zA-Z]+\\(\\)(-).+|.+","\\1",name),
    axis = sub("^[a-zA-Z]+-[a-zA-Z]+\\(\\)-([XYZ]),?[1-4]?|.+","\\1",name),
    arCoeffSep = sub("^[a-zA-Z]+-arCoeff+\\(\\)-[XYZ](,).+|.+","\\1",name),
    arCoeffLevel = sub("^[a-zA-Z]+-arCoeff\\(\\)-?[XYZ]?,?([1-4])|.+","\\1",name),
    bandsEnergyLower = sub("^[a-zA-Z]+-bandsEnergy+\\(\\)-([0-9]+),[0-9]+|.+","\\1",name),
    bandsEnergySep = sub("^[a-zA-Z]+-bandsEnergy+\\(\\)-[0-9]+(,).+|.+","\\1",name),
    bandsEnergyUpper = sub("^[a-zA-Z]+-bandsEnergy+\\(\\)-[0-9]+,([0-9]+)|.+","\\1",name),
    correlationAxis1 = sub("^[a-zA-Z]+-correlation+\\(\\)-([XY]).+|.+","\\1",name),
    correlationSep =  sub("^[a-zA-Z]+-correlation+\\(\\)-[XY](,).+|.+","\\1",name),
    correlationAxis2 = sub("^[a-zA-Z]+-correlation+\\(\\)-[XY],([YZ])|.+","\\1",name),
    angleOpen = sub("^angle(\\().+|.+","\\1",name),
    angleArg1 = sub("^angle\\(([a-zA-Z]+).+|.+","\\1",name),
    angleSep = sub("^angle\\([a-zA-Z]+(,).+|.+","\\1",name),
    angleArg2 = sub("^angle\\([a-zA-Z]+,([a-zA-Z]+)\\)|.+","\\1",name),
    angleClose = sub("^angle\\([a-zA-Z]+,[a-zA-Z]+(\\))|.+","\\1",name),
    axesSep  = sub("^.+(Acc|Gyro|Jerk)(-).+|.+","\\2",name),
    axes = sub("^.+(Acc|Gyro|Jerk)(-)([a-zA-Z]+)\\(\\)-?([XYZ]?),?([YZ]?)[0-9]*,?[0-9]*$|.+","\\3\\4\\5",name),
    axes = sub("sma|bandsEnergy", "XYZ", axes),
    axes = sub("correlation(XY|YZ|XZ){1}","\\1",axes),
    axes = sub("arCoeff|energy|entropy|iqr|kurtosis|mad|max|maxInds|mean|meanFreq|min|skewness|std([XYZ])","\\1", axes))
str(features)
```

    ## 'data.frame':    561 obs. of  28 variables:
    ##  $ id              : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ name            : chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...
    ##  $ domain          : chr  "t" "t" "t" "t" ...
    ##  $ component       : chr  "Body" "Body" "Body" "Body" ...
    ##  $ sensor          : chr  "Acc" "Acc" "Acc" "Acc" ...
    ##  $ jerk            : chr  "" "" "" "" ...
    ##  $ magnitude       : chr  "" "" "" "" ...
    ##  $ signalSep       : chr  "-" "-" "-" "-" ...
    ##  $ calculus        : chr  "mean" "mean" "mean" "std" ...
    ##  $ calcOpen        : chr  "(" "(" "(" "(" ...
    ##  $ calcClose       : chr  ")" ")" ")" ")" ...
    ##  $ calcSep         : chr  "-" "-" "-" "-" ...
    ##  $ axis            : chr  "X" "Y" "Z" "X" ...
    ##  $ arCoeffSep      : chr  "" "" "" "" ...
    ##  $ arCoeffLevel    : chr  "" "" "" "" ...
    ##  $ bandsEnergyLower: chr  "" "" "" "" ...
    ##  $ bandsEnergySep  : chr  "" "" "" "" ...
    ##  $ bandsEnergyUpper: chr  "" "" "" "" ...
    ##  $ correlationAxis1: chr  "" "" "" "" ...
    ##  $ correlationSep  : chr  "" "" "" "" ...
    ##  $ correlationAxis2: chr  "" "" "" "" ...
    ##  $ angleOpen       : chr  "" "" "" "" ...
    ##  $ angleArg1       : chr  "" "" "" "" ...
    ##  $ angleSep        : chr  "" "" "" "" ...
    ##  $ angleArg2       : chr  "" "" "" "" ...
    ##  $ angleClose      : chr  "" "" "" "" ...
    ##  $ axesSep         : chr  "-" "-" "-" "-" ...
    ##  $ axes            : chr  "X" "Y" "Z" "X" ...

### Feature name recomposition

``` r
features %>%
    unite(recomposition, sep = "", everything(), -id, -name, -axesSep, -axes) %>%
    select(name,recomposition) %>%
    slice(1:6)
```

    ##                name     recomposition
    ## 1 tBodyAcc-mean()-X tBodyAcc-mean()-X
    ## 2 tBodyAcc-mean()-Y tBodyAcc-mean()-Y
    ## 3 tBodyAcc-mean()-Z tBodyAcc-mean()-Z
    ## 4  tBodyAcc-std()-X  tBodyAcc-std()-X
    ## 5  tBodyAcc-std()-Y  tBodyAcc-std()-Y
    ## 6  tBodyAcc-std()-Z  tBodyAcc-std()-Z

### Feature name recomposition validation

``` r
features %>%
    unite(recomposition, sep = "", everything(), -id, -name, -axesSep, -axes) %>%
    select(name,recomposition) %>%
    filter(name != recomposition)
```

    ## [1] name          recomposition
    ## <0 rows> (or 0-length row.names)

Build feature formulas
----------------------

``` r
features %>%
    select(everything(), -signalSep, -(calcSep:arCoeffSep), -(correlationAxis1:correlationAxis2)) %>%
    unite(open, calcOpen, angleOpen, sep = "") %>%
    unite(signal, domain:magnitude, axesSep, axes, sep = "") %>%
    mutate(arCoeffLevel = sub("(.+)",", \\1", arCoeffLevel)) %>%
    mutate(bandsEnergySep = sub(",", ", ", bandsEnergySep)) %>%
    unite(bandsEnergy, bandsEnergyLower, bandsEnergySep, bandsEnergyUpper, sep = "") %>%
    mutate(bandsEnergy = sub("(.+)",", \\1", bandsEnergy)) %>%
    mutate(angleSep = sub(",",", ",angleSep)) %>%
    unite(angle, angleArg1, angleSep, angleArg2, sep = "") %>%
    unite(close, calcClose, angleClose, sep = "") %>%
    mutate(key = paste0(calculus, "()")) %>%
    left_join(calculus, by = c("key"="name")) %>%
    mutate(key = NULL) %>%
    unite(formula, calculus, open, signal, arCoeffLevel, bandsEnergy, angle, close, sep = "") %>%
    #arrange(id) %>%
    slice(c(1,16,26,38,303,555))
```

    ##    id                        name                         formula
    ## 1   1           tBodyAcc-mean()-X                mean(tBodyAcc-X)
    ## 2  16              tBodyAcc-sma()               sma(tBodyAcc-XYZ)
    ## 3  26      tBodyAcc-arCoeff()-X,1          arCoeff(tBodyAcc-X, 1)
    ## 4  38  tBodyAcc-correlation()-X,Y        correlation(tBodyAcc-XY)
    ## 5 303  fBodyAcc-bandsEnergy()-1,8 bandsEnergy(fBodyAcc-XYZ, 1, 8)
    ## 6 555 angle(tBodyAccMean,gravity)    angle(tBodyAccMean, gravity)
    ##                                                                    description
    ## 1                                                                   Mean value
    ## 2                                                        Signal magnitude area
    ## 3                       Autorregresion coefficients with Burg order equal to 4
    ## 4                                  correlation coefficient between two signals
    ## 5 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 6                                                    Angle between to vectors.

Contingency Tables
------------------

### Features by domain

``` r
xtabs(~ domain, features)
```

    ## domain
    ##       f   t 
    ##   7 289 265

``` r
#or table(domain = features$domain)
```

### Features by sensor

``` r
xtabs(~ sensor, features)
```

    ## sensor
    ##       Acc Gyro 
    ##    7  343  211

``` r
#or table(sensor = features$sensor)
```

### Features by calculus

``` r
xtabs(~ calculus, features)
```

    ## calculus
    ##       angle     arCoeff bandsEnergy correlation      energy     entropy 
    ##           7          80         126          15          33          33 
    ##         iqr    kurtosis         mad         max     maxInds        mean 
    ##          33          13          33          33          13          33 
    ##    meanFreq         min    skewness         sma         std 
    ##          13          33          13          17          33

``` r
#or table(calculus = features$calculus)
```

### Features by signal

``` r
table(signal = with(features, paste0(domain, component, sensor, jerk, magnitude)))
```

    ## signal
    ##                          fBodyAcc     fBodyAccJerk  fBodyAccJerkMag 
    ##                7               79               79               13 
    ##      fBodyAccMag        fBodyGyro fBodyGyroJerkMag     fBodyGyroMag 
    ##               13               79               13               13 
    ##         tBodyAcc     tBodyAccJerk  tBodyAccJerkMag      tBodyAccMag 
    ##               40               40               13               13 
    ##        tBodyGyro    tBodyGyroJerk tBodyGyroJerkMag     tBodyGyroMag 
    ##               40               40               13               13 
    ##      tGravityAcc   tGravityAccMag 
    ##               40               13

``` r
#or xtabs(~ paste0(domain, component, sensor, jerk, magnitude), features)
```

### Features by domain by sensor

``` r
xtabs(~ domain + sensor, features)
```

    ##       sensor
    ## domain     Acc Gyro
    ##          7   0    0
    ##      f   0 184  105
    ##      t   0 159  106

``` r
#or table(domain = features$domain, sensor = features$sensor)
```

### Features by calculus by domain

``` r
xtabs(~ calculus + domain, features)
```

    ##              domain
    ## calculus            f   t
    ##   angle         7   0   0
    ##   arCoeff       0   0  80
    ##   bandsEnergy   0 126   0
    ##   correlation   0   0  15
    ##   energy        0  13  20
    ##   entropy       0  13  20
    ##   iqr           0  13  20
    ##   kurtosis      0  13   0
    ##   mad           0  13  20
    ##   max           0  13  20
    ##   maxInds       0  13   0
    ##   mean          0  13  20
    ##   meanFreq      0  13   0
    ##   min           0  13  20
    ##   skewness      0  13   0
    ##   sma           0   7  10
    ##   std           0  13  20

``` r
#or table(calculus = features$calculus, domain = features$domain)
```

### Features by calculus by sensor

``` r
xtabs(~ calculus + sensor, features)
```

    ##              sensor
    ## calculus         Acc Gyro
    ##   angle        7   0    0
    ##   arCoeff      0  48   32
    ##   bandsEnergy  0  84   42
    ##   correlation  0   9    6
    ##   energy       0  20   13
    ##   entropy      0  20   13
    ##   iqr          0  20   13
    ##   kurtosis     0   8    5
    ##   mad          0  20   13
    ##   max          0  20   13
    ##   maxInds      0   8    5
    ##   mean         0  20   13
    ##   meanFreq     0   8    5
    ##   min          0  20   13
    ##   skewness     0   8    5
    ##   sma          0  10    7
    ##   std          0  20   13

``` r
#or table(calculus = features$calculus, features$sensor)
```

### Features by signal by domain

``` r
table(signal = with(features, paste0(domain, component, sensor, jerk, magnitude)), domain = features$domain)
```

    ##                   domain
    ## signal                 f  t
    ##                     7  0  0
    ##   fBodyAcc          0 79  0
    ##   fBodyAccJerk      0 79  0
    ##   fBodyAccJerkMag   0 13  0
    ##   fBodyAccMag       0 13  0
    ##   fBodyGyro         0 79  0
    ##   fBodyGyroJerkMag  0 13  0
    ##   fBodyGyroMag      0 13  0
    ##   tBodyAcc          0  0 40
    ##   tBodyAccJerk      0  0 40
    ##   tBodyAccJerkMag   0  0 13
    ##   tBodyAccMag       0  0 13
    ##   tBodyGyro         0  0 40
    ##   tBodyGyroJerk     0  0 40
    ##   tBodyGyroJerkMag  0  0 13
    ##   tBodyGyroMag      0  0 13
    ##   tGravityAcc       0  0 40
    ##   tGravityAccMag    0  0 13

``` r
#or xtabs(~ paste0(domain, component, sensor, jerk, magnitude) + domain, features)
```

### Features by signal by sensor

``` r
table(signal = with(features, paste0(domain, component, sensor, jerk, magnitude)),  sensor = features$sensor)
```

    ##                   sensor
    ## signal                Acc Gyro
    ##                     7   0    0
    ##   fBodyAcc          0  79    0
    ##   fBodyAccJerk      0  79    0
    ##   fBodyAccJerkMag   0  13    0
    ##   fBodyAccMag       0  13    0
    ##   fBodyGyro         0   0   79
    ##   fBodyGyroJerkMag  0   0   13
    ##   fBodyGyroMag      0   0   13
    ##   tBodyAcc          0  40    0
    ##   tBodyAccJerk      0  40    0
    ##   tBodyAccJerkMag   0  13    0
    ##   tBodyAccMag       0  13    0
    ##   tBodyGyro         0   0   40
    ##   tBodyGyroJerk     0   0   40
    ##   tBodyGyroJerkMag  0   0   13
    ##   tBodyGyroMag      0   0   13
    ##   tGravityAcc       0  40    0
    ##   tGravityAccMag    0  13    0

``` r
#or xtabs(~ paste0(domain, component, sensor, jerk, magnitude) + sensor, features)
```

### Features by signal by calculus

``` r
table(signal = with(features, paste0(domain, component, sensor, jerk, magnitude)), calculus = features$calculus)
```

    ##                   calculus
    ## signal             angle arCoeff bandsEnergy correlation energy entropy
    ##                        7       0           0           0      0       0
    ##   fBodyAcc             0       0          42           0      3       3
    ##   fBodyAccJerk         0       0          42           0      3       3
    ##   fBodyAccJerkMag      0       0           0           0      1       1
    ##   fBodyAccMag          0       0           0           0      1       1
    ##   fBodyGyro            0       0          42           0      3       3
    ##   fBodyGyroJerkMag     0       0           0           0      1       1
    ##   fBodyGyroMag         0       0           0           0      1       1
    ##   tBodyAcc             0      12           0           3      3       3
    ##   tBodyAccJerk         0      12           0           3      3       3
    ##   tBodyAccJerkMag      0       4           0           0      1       1
    ##   tBodyAccMag          0       4           0           0      1       1
    ##   tBodyGyro            0      12           0           3      3       3
    ##   tBodyGyroJerk        0      12           0           3      3       3
    ##   tBodyGyroJerkMag     0       4           0           0      1       1
    ##   tBodyGyroMag         0       4           0           0      1       1
    ##   tGravityAcc          0      12           0           3      3       3
    ##   tGravityAccMag       0       4           0           0      1       1
    ##                   calculus
    ## signal             iqr kurtosis mad max maxInds mean meanFreq min skewness
    ##                      0        0   0   0       0    0        0   0        0
    ##   fBodyAcc           3        3   3   3       3    3        3   3        3
    ##   fBodyAccJerk       3        3   3   3       3    3        3   3        3
    ##   fBodyAccJerkMag    1        1   1   1       1    1        1   1        1
    ##   fBodyAccMag        1        1   1   1       1    1        1   1        1
    ##   fBodyGyro          3        3   3   3       3    3        3   3        3
    ##   fBodyGyroJerkMag   1        1   1   1       1    1        1   1        1
    ##   fBodyGyroMag       1        1   1   1       1    1        1   1        1
    ##   tBodyAcc           3        0   3   3       0    3        0   3        0
    ##   tBodyAccJerk       3        0   3   3       0    3        0   3        0
    ##   tBodyAccJerkMag    1        0   1   1       0    1        0   1        0
    ##   tBodyAccMag        1        0   1   1       0    1        0   1        0
    ##   tBodyGyro          3        0   3   3       0    3        0   3        0
    ##   tBodyGyroJerk      3        0   3   3       0    3        0   3        0
    ##   tBodyGyroJerkMag   1        0   1   1       0    1        0   1        0
    ##   tBodyGyroMag       1        0   1   1       0    1        0   1        0
    ##   tGravityAcc        3        0   3   3       0    3        0   3        0
    ##   tGravityAccMag     1        0   1   1       0    1        0   1        0
    ##                   calculus
    ## signal             sma std
    ##                      0   0
    ##   fBodyAcc           1   3
    ##   fBodyAccJerk       1   3
    ##   fBodyAccJerkMag    1   1
    ##   fBodyAccMag        1   1
    ##   fBodyGyro          1   3
    ##   fBodyGyroJerkMag   1   1
    ##   fBodyGyroMag       1   1
    ##   tBodyAcc           1   3
    ##   tBodyAccJerk       1   3
    ##   tBodyAccJerkMag    1   1
    ##   tBodyAccMag        1   1
    ##   tBodyGyro          1   3
    ##   tBodyGyroJerk      1   3
    ##   tBodyGyroJerkMag   1   1
    ##   tBodyGyroMag       1   1
    ##   tGravityAcc        1   3
    ##   tGravityAccMag     1   1

``` r
#or xtabs(~ paste0(domain, component, sensor, jerk, magnitude) + calculus, features)
```
