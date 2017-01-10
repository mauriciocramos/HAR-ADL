HAR-features
================
by Maurício Collaça
2017-01-10

Introduction
------------

Analyzes the feature vectors, signals, statistics and angle vectors of the HAR Data Set V1.0

Load features, signals, statistics, angleVectors
------------------------------------------------

``` r
source("HAR-utils.R")
features <- read_features()
signals <- read_signals()
statistics <- read_statistics()
angleVectors <- read_angleVectors()
```

Signal decomposition
--------------------

``` r
signals <- signals %>%
    mutate(domain = sub("^(t|f).+","\\1",name),
           prefix = sub(".+(Body|Gravity).+","\\1",name),
           rawSignal = sub(".+(Acc|Gyro).+","\\1",name),
           suffix1 = sub(".+(Jerk).+|.+","\\1",name),
           suffix2 = sub(".+(Mag)$|.+","\\1",name),
           axisSep = sub(".+(-)XYZ|.+","\\1",name),
           X1 = sub(".+(X)YZ|.+","\\1",name),
           X2 = sub(".+X(Y)Z|.+","\\1",name),
           X3 = sub(".+XY(Z)|.+","\\1",name)) %>%
    gather(X, axis, X1:X3) %>%
    mutate(X = NULL) %>%
    distinct() %>%
    rename(group = name) %>%
    unite(name, everything(), -group, sep = "", remove = FALSE) %>%
    select(name, everything()) %>%
    arrange(name)
head(signals)
```

    ##             name            group domain prefix rawSignal suffix1 suffix2
    ## 1     fBodyAcc-X     fBodyAcc-XYZ      f   Body       Acc                
    ## 2     fBodyAcc-Y     fBodyAcc-XYZ      f   Body       Acc                
    ## 3     fBodyAcc-Z     fBodyAcc-XYZ      f   Body       Acc                
    ## 4 fBodyAccJerk-X fBodyAccJerk-XYZ      f   Body       Acc    Jerk        
    ## 5 fBodyAccJerk-Y fBodyAccJerk-XYZ      f   Body       Acc    Jerk        
    ## 6 fBodyAccJerk-Z fBodyAccJerk-XYZ      f   Body       Acc    Jerk        
    ##   axisSep axis
    ## 1       -    X
    ## 2       -    Y
    ## 3       -    Z
    ## 4       -    X
    ## 5       -    Y
    ## 6       -    Z

Feature patches
---------------

### Features containing duplicated "Body" prefix

``` r
dsub(features,"name","^f(BodyBody)","Body",explain=TRUE)
```

    ## Would affect 39 row(s): features[516:554, "name"]<-sub("BodyBody", "Body", features[516:554, "name"])

    ##  [1] "fBodyBodyAccJerkMag-mean()"      "fBodyBodyAccJerkMag-std()"      
    ##  [3] "fBodyBodyAccJerkMag-mad()"       "fBodyBodyAccJerkMag-max()"      
    ##  [5] "fBodyBodyAccJerkMag-min()"       "fBodyBodyAccJerkMag-sma()"      
    ##  [7] "fBodyBodyAccJerkMag-energy()"    "fBodyBodyAccJerkMag-iqr()"      
    ##  [9] "fBodyBodyAccJerkMag-entropy()"   "fBodyBodyAccJerkMag-maxInds"    
    ## [11] "fBodyBodyAccJerkMag-meanFreq()"  "fBodyBodyAccJerkMag-skewness()" 
    ## [13] "fBodyBodyAccJerkMag-kurtosis()"  "fBodyBodyGyroMag-mean()"        
    ## [15] "fBodyBodyGyroMag-std()"          "fBodyBodyGyroMag-mad()"         
    ## [17] "fBodyBodyGyroMag-max()"          "fBodyBodyGyroMag-min()"         
    ## [19] "fBodyBodyGyroMag-sma()"          "fBodyBodyGyroMag-energy()"      
    ## [21] "fBodyBodyGyroMag-iqr()"          "fBodyBodyGyroMag-entropy()"     
    ## [23] "fBodyBodyGyroMag-maxInds"        "fBodyBodyGyroMag-meanFreq()"    
    ## [25] "fBodyBodyGyroMag-skewness()"     "fBodyBodyGyroMag-kurtosis()"    
    ## [27] "fBodyBodyGyroJerkMag-mean()"     "fBodyBodyGyroJerkMag-std()"     
    ## [29] "fBodyBodyGyroJerkMag-mad()"      "fBodyBodyGyroJerkMag-max()"     
    ## [31] "fBodyBodyGyroJerkMag-min()"      "fBodyBodyGyroJerkMag-sma()"     
    ## [33] "fBodyBodyGyroJerkMag-energy()"   "fBodyBodyGyroJerkMag-iqr()"     
    ## [35] "fBodyBodyGyroJerkMag-entropy()"  "fBodyBodyGyroJerkMag-maxInds"   
    ## [37] "fBodyBodyGyroJerkMag-meanFreq()" "fBodyBodyGyroJerkMag-skewness()"
    ## [39] "fBodyBodyGyroJerkMag-kurtosis()"

### Patch duplicated "Body" prefix

``` r
dsub(features,"name","^f(BodyBody)","Body",explain=FALSE)
```

    ## Affected 39 row(s): features[516:554, "name"]<-sub("BodyBody", "Body", features[516:554, "name"])

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

### Features containing invalid parenthesis

``` r
dsub(features,"name",".*[\\(\\)]+.*([\\(\\)])+.*[\\(\\)]+.*","",explain=TRUE)
```

    ## Would affect 1 row(s): features[556, "name"]<-sub(")", "", features[556, "name"])

    ## [1] "angle(tBodyAccJerkMean),gravityMean)"

### Patch invalid parenthesis

``` r
dsub(features,"name",".*[\\(\\)]+.*([\\(\\)])+.*[\\(\\)]+.*","",explain=FALSE)
```

    ## Affected 1 row(s): features[556, "name"]<-sub(")", "", features[556, "name"])

    ## [1] "angle(tBodyAccJerkMean,gravityMean)"

### Features containing statistics with missing parenthesis

``` r
dsub(features,"name","[a-zA-Z]+-([a-zA-Z]+)-?[XYZ]?$","maxInds\\(\\)",explain=TRUE)
```

    ## Would affect 13 row(s): features[c(291, 292, 293, 370, 371, 372, 449, 450, 451, 512, 525, 538, 551), "name"]<-sub("maxInds", "maxInds\\(\\)", features[c(291, 292, 293, 370, 371, 372, 449, 450, 451, 512, 525, 538, 551), "name"])

    ##  [1] "fBodyAcc-maxInds-X"       "fBodyAcc-maxInds-Y"      
    ##  [3] "fBodyAcc-maxInds-Z"       "fBodyAccJerk-maxInds-X"  
    ##  [5] "fBodyAccJerk-maxInds-Y"   "fBodyAccJerk-maxInds-Z"  
    ##  [7] "fBodyGyro-maxInds-X"      "fBodyGyro-maxInds-Y"     
    ##  [9] "fBodyGyro-maxInds-Z"      "fBodyAccMag-maxInds"     
    ## [11] "fBodyAccJerkMag-maxInds"  "fBodyGyroMag-maxInds"    
    ## [13] "fBodyGyroJerkMag-maxInds"

### Patch missing parenthesis

``` r
dsub(features,"name","[a-zA-Z]+-([a-zA-Z]+)-?[XYZ]?$","maxInds\\(\\)",explain=FALSE)
```

    ## Affected 13 row(s): features[c(291, 292, 293, 370, 371, 372, 449, 450, 451, 512, 525, 538, 551), "name"]<-sub("maxInds", "maxInds\\(\\)", features[c(291, 292, 293, 370, 371, 372, 449, 450, 451, 512, 525, 538, 551), "name"])

    ##  [1] "fBodyAcc-maxInds()-X"       "fBodyAcc-maxInds()-Y"      
    ##  [3] "fBodyAcc-maxInds()-Z"       "fBodyAccJerk-maxInds()-X"  
    ##  [5] "fBodyAccJerk-maxInds()-Y"   "fBodyAccJerk-maxInds()-Z"  
    ##  [7] "fBodyGyro-maxInds()-X"      "fBodyGyro-maxInds()-Y"     
    ##  [9] "fBodyGyro-maxInds()-Z"      "fBodyAccMag-maxInds()"     
    ## [11] "fBodyAccJerkMag-maxInds()"  "fBodyGyroMag-maxInds()"    
    ## [13] "fBodyGyroJerkMag-maxInds()"

### TODO? Patch features "fbodyAcc-bandsEnergy()"" whose names are duplicated due to missing Interval Series Identifier

    fBodyAcc-bandsEnergy() duplicates:
        fBodyAcc-bandsEnergy()-1,16 :  3
        fBodyAcc-bandsEnergy()-1,24 :  3
        fBodyAcc-bandsEnergy()-1,8  :  3
        fBodyAcc-bandsEnergy()-17,24:  3
        fBodyAcc-bandsEnergy()-17,32:  3
        fBodyAcc-bandsEnergy()-25,32:  3

``` r
bandsEnergyBins()
```

    ## [[1]]
    ## [1] "(0.94,8.9]" "(8.9,17]"   "(17,25]"    "(25,32]"    "(32,40]"   
    ## [6] "(40,48]"    "(48,56]"    "(56,64]"   
    ## 
    ## [[2]]
    ## [1] "(0.94,17]" "(17,32]"   "(32,48]"   "(48,64]"  
    ## 
    ## [[3]]
    ## [1] "(0.95,24]" "(24,48]"

Feature name decomposition
--------------------------

``` r
features <- 
features %>%
    mutate(
    domain = gsub("^(t|f).*|.*","\\1",name),
    prefix = sub("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?(Mag)?.*|.*","\\2",name),
    rawSignal = sub("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?(Mag)?.*|.*","\\3",name),
    jerkSuffix = sub("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?(Mag)?.*|.*","\\4",name),
    magSuffix = sub("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?(Mag)?.*|.*","\\5",name),
    
    statSep1 = sub("^[a-zA-Z]+(-).*|^.*","\\1",name),
    statistic = sub("^[a-zA-Z]+-([a-zA-Z]+).*|^(angle)\\(.*","\\1\\2",name),
    #statSep2 = sub("^[a-zA-Z]+-[a-zA-Z]+(\\(?).*|^.*","\\1",name), removed ? from \\( after fixing maxInds()
    statSep2 = sub("^[a-zA-Z]+-[a-zA-Z]+(\\().*|^.*","\\1",name),
    #statSep3 = sub("^[a-zA-Z]+-[a-zA-Z]+\\(?(\\)?).*|^.*","\\1",name), removed ? from \\) after fixing maxInds()
    statSep3 = sub("^[a-zA-Z]+-[a-zA-Z]+\\((\\)).*|^.*","\\1",name),
    
    axisSep =  sub("^[a-zA-Z]+-[a-zA-Z]+\\(?\\)?(-)([XYZ]){1},?[1-4]?$|^.*","\\1",name),
    axis = sub("^[a-zA-Z]+-[a-zA-Z]+\\(?\\)?-([XYZ]){1},?[1-4]?$|^.*","\\1",name),
    
    axesSep = sub("^.+(Acc|Gyro|Jerk)(-)(sma\\(\\)$|correlation\\(\\)-[XY],[YZ]$|bandsEnergy\\(\\)-[0-9]+,[0-9]+$|arCoeff\\(\\)[1-4]$){1}|^.*","\\2",name),
    axes = sub("^.+(Acc|Gyro|Jerk)(-)(sma|correlation|bandsEnergy){1}\\(\\)-?([XY]?),?([YZ]?)[0-9]*,?[0-9]*$|^.+(Acc|Gyro|Jerk)(-)(arCoeff){1}\\(\\)[1-4]?$|^.*","\\3\\4\\5",name),
    axes = sub("sma|bandsEnergy|arCoeff","XYZ",axes),
    axes = sub("correlation(XY|YZ|XZ){1}","\\1",axes),
    
    arCoeffSep = sub("^[a-zA-Z]+-arCoeff+\\(\\)-([XYZ]){1}(,).*|^.*","\\2",name),
    arCoeffLevel = sub("^[a-zA-Z]+-arCoeff\\(\\)(-?)[XYZ]?,?([1-4]){1}|^.*","\\2",name),
    
    correlationSep1 =  sub("^[a-zA-Z]+-correlation+\\(\\)(-).*|^.*","\\1",name),
    correlationAxis1 = sub("^[a-zA-Z]+-correlation+\\(\\)-([XY]){1}.*|^.*","\\1",name),
    correlationSep2 =  sub("^[a-zA-Z]+-correlation+\\(\\)-([XY]){1}(,).*|^.*","\\2",name),
    correlationAxis2 = sub("^[a-zA-Z]+-correlation+\\(\\)-([XY]){1},([YZ]){1}|^.*","\\2",name),
    
    bandsEnergySep1 = sub("^[a-zA-Z]+-bandsEnergy+\\(\\)(-).*|^.*","\\1",name),
    bandsEnergyLower = sub("^[a-zA-Z]+-bandsEnergy+\\(\\)-([0-9]+),[0-9]+|^.*","\\1",name),
    bandsEnergySep2 = sub("^[a-zA-Z]+-bandsEnergy+\\(\\)-[0-9]+(,).*|^.*","\\1",name),
    bandsEnergyUpper = sub("^[a-zA-Z]+-bandsEnergy+\\(\\)-[0-9]+,([0-9]+)|^.*","\\1",name),
    
    angleSep1 = sub("^angle(\\().*|^.*","\\1",name),
    angleArg1 = sub("^angle\\(([a-zA-Z]+).*|^.*","\\1",name),
    angleSep2 = sub("^angle\\([a-zA-Z]+(,).*|^.*","\\1",name),
    angleArg2 = sub("^angle\\([a-zA-Z]+,([a-zA-Z]+).*|^.*","\\1",name),
    angleSep3 = sub("^angle\\([a-zA-Z]+,[a-zA-Z]+(\\))|^.*","\\1",name)
    ) %>%
print
```

    ##      id                                 name domain  prefix rawSignal
    ## 1     1                    tBodyAcc-mean()-X      t    Body       Acc
    ## 2     2                    tBodyAcc-mean()-Y      t    Body       Acc
    ## 3     3                    tBodyAcc-mean()-Z      t    Body       Acc
    ## 4     4                     tBodyAcc-std()-X      t    Body       Acc
    ## 5     5                     tBodyAcc-std()-Y      t    Body       Acc
    ## 6     6                     tBodyAcc-std()-Z      t    Body       Acc
    ## 7     7                     tBodyAcc-mad()-X      t    Body       Acc
    ## 8     8                     tBodyAcc-mad()-Y      t    Body       Acc
    ## 9     9                     tBodyAcc-mad()-Z      t    Body       Acc
    ## 10   10                     tBodyAcc-max()-X      t    Body       Acc
    ## 11   11                     tBodyAcc-max()-Y      t    Body       Acc
    ## 12   12                     tBodyAcc-max()-Z      t    Body       Acc
    ## 13   13                     tBodyAcc-min()-X      t    Body       Acc
    ## 14   14                     tBodyAcc-min()-Y      t    Body       Acc
    ## 15   15                     tBodyAcc-min()-Z      t    Body       Acc
    ## 16   16                       tBodyAcc-sma()      t    Body       Acc
    ## 17   17                  tBodyAcc-energy()-X      t    Body       Acc
    ## 18   18                  tBodyAcc-energy()-Y      t    Body       Acc
    ## 19   19                  tBodyAcc-energy()-Z      t    Body       Acc
    ## 20   20                     tBodyAcc-iqr()-X      t    Body       Acc
    ## 21   21                     tBodyAcc-iqr()-Y      t    Body       Acc
    ## 22   22                     tBodyAcc-iqr()-Z      t    Body       Acc
    ## 23   23                 tBodyAcc-entropy()-X      t    Body       Acc
    ## 24   24                 tBodyAcc-entropy()-Y      t    Body       Acc
    ## 25   25                 tBodyAcc-entropy()-Z      t    Body       Acc
    ## 26   26               tBodyAcc-arCoeff()-X,1      t    Body       Acc
    ## 27   27               tBodyAcc-arCoeff()-X,2      t    Body       Acc
    ## 28   28               tBodyAcc-arCoeff()-X,3      t    Body       Acc
    ## 29   29               tBodyAcc-arCoeff()-X,4      t    Body       Acc
    ## 30   30               tBodyAcc-arCoeff()-Y,1      t    Body       Acc
    ## 31   31               tBodyAcc-arCoeff()-Y,2      t    Body       Acc
    ## 32   32               tBodyAcc-arCoeff()-Y,3      t    Body       Acc
    ## 33   33               tBodyAcc-arCoeff()-Y,4      t    Body       Acc
    ## 34   34               tBodyAcc-arCoeff()-Z,1      t    Body       Acc
    ## 35   35               tBodyAcc-arCoeff()-Z,2      t    Body       Acc
    ## 36   36               tBodyAcc-arCoeff()-Z,3      t    Body       Acc
    ## 37   37               tBodyAcc-arCoeff()-Z,4      t    Body       Acc
    ## 38   38           tBodyAcc-correlation()-X,Y      t    Body       Acc
    ## 39   39           tBodyAcc-correlation()-X,Z      t    Body       Acc
    ## 40   40           tBodyAcc-correlation()-Y,Z      t    Body       Acc
    ## 41   41                 tGravityAcc-mean()-X      t Gravity       Acc
    ## 42   42                 tGravityAcc-mean()-Y      t Gravity       Acc
    ## 43   43                 tGravityAcc-mean()-Z      t Gravity       Acc
    ## 44   44                  tGravityAcc-std()-X      t Gravity       Acc
    ## 45   45                  tGravityAcc-std()-Y      t Gravity       Acc
    ## 46   46                  tGravityAcc-std()-Z      t Gravity       Acc
    ## 47   47                  tGravityAcc-mad()-X      t Gravity       Acc
    ## 48   48                  tGravityAcc-mad()-Y      t Gravity       Acc
    ## 49   49                  tGravityAcc-mad()-Z      t Gravity       Acc
    ## 50   50                  tGravityAcc-max()-X      t Gravity       Acc
    ## 51   51                  tGravityAcc-max()-Y      t Gravity       Acc
    ## 52   52                  tGravityAcc-max()-Z      t Gravity       Acc
    ## 53   53                  tGravityAcc-min()-X      t Gravity       Acc
    ## 54   54                  tGravityAcc-min()-Y      t Gravity       Acc
    ## 55   55                  tGravityAcc-min()-Z      t Gravity       Acc
    ## 56   56                    tGravityAcc-sma()      t Gravity       Acc
    ## 57   57               tGravityAcc-energy()-X      t Gravity       Acc
    ## 58   58               tGravityAcc-energy()-Y      t Gravity       Acc
    ## 59   59               tGravityAcc-energy()-Z      t Gravity       Acc
    ## 60   60                  tGravityAcc-iqr()-X      t Gravity       Acc
    ## 61   61                  tGravityAcc-iqr()-Y      t Gravity       Acc
    ## 62   62                  tGravityAcc-iqr()-Z      t Gravity       Acc
    ## 63   63              tGravityAcc-entropy()-X      t Gravity       Acc
    ## 64   64              tGravityAcc-entropy()-Y      t Gravity       Acc
    ## 65   65              tGravityAcc-entropy()-Z      t Gravity       Acc
    ## 66   66            tGravityAcc-arCoeff()-X,1      t Gravity       Acc
    ## 67   67            tGravityAcc-arCoeff()-X,2      t Gravity       Acc
    ## 68   68            tGravityAcc-arCoeff()-X,3      t Gravity       Acc
    ## 69   69            tGravityAcc-arCoeff()-X,4      t Gravity       Acc
    ## 70   70            tGravityAcc-arCoeff()-Y,1      t Gravity       Acc
    ## 71   71            tGravityAcc-arCoeff()-Y,2      t Gravity       Acc
    ## 72   72            tGravityAcc-arCoeff()-Y,3      t Gravity       Acc
    ## 73   73            tGravityAcc-arCoeff()-Y,4      t Gravity       Acc
    ## 74   74            tGravityAcc-arCoeff()-Z,1      t Gravity       Acc
    ## 75   75            tGravityAcc-arCoeff()-Z,2      t Gravity       Acc
    ## 76   76            tGravityAcc-arCoeff()-Z,3      t Gravity       Acc
    ## 77   77            tGravityAcc-arCoeff()-Z,4      t Gravity       Acc
    ## 78   78        tGravityAcc-correlation()-X,Y      t Gravity       Acc
    ## 79   79        tGravityAcc-correlation()-X,Z      t Gravity       Acc
    ## 80   80        tGravityAcc-correlation()-Y,Z      t Gravity       Acc
    ## 81   81                tBodyAccJerk-mean()-X      t    Body       Acc
    ## 82   82                tBodyAccJerk-mean()-Y      t    Body       Acc
    ## 83   83                tBodyAccJerk-mean()-Z      t    Body       Acc
    ## 84   84                 tBodyAccJerk-std()-X      t    Body       Acc
    ## 85   85                 tBodyAccJerk-std()-Y      t    Body       Acc
    ## 86   86                 tBodyAccJerk-std()-Z      t    Body       Acc
    ## 87   87                 tBodyAccJerk-mad()-X      t    Body       Acc
    ## 88   88                 tBodyAccJerk-mad()-Y      t    Body       Acc
    ## 89   89                 tBodyAccJerk-mad()-Z      t    Body       Acc
    ## 90   90                 tBodyAccJerk-max()-X      t    Body       Acc
    ## 91   91                 tBodyAccJerk-max()-Y      t    Body       Acc
    ## 92   92                 tBodyAccJerk-max()-Z      t    Body       Acc
    ## 93   93                 tBodyAccJerk-min()-X      t    Body       Acc
    ## 94   94                 tBodyAccJerk-min()-Y      t    Body       Acc
    ## 95   95                 tBodyAccJerk-min()-Z      t    Body       Acc
    ## 96   96                   tBodyAccJerk-sma()      t    Body       Acc
    ## 97   97              tBodyAccJerk-energy()-X      t    Body       Acc
    ## 98   98              tBodyAccJerk-energy()-Y      t    Body       Acc
    ## 99   99              tBodyAccJerk-energy()-Z      t    Body       Acc
    ## 100 100                 tBodyAccJerk-iqr()-X      t    Body       Acc
    ## 101 101                 tBodyAccJerk-iqr()-Y      t    Body       Acc
    ## 102 102                 tBodyAccJerk-iqr()-Z      t    Body       Acc
    ## 103 103             tBodyAccJerk-entropy()-X      t    Body       Acc
    ## 104 104             tBodyAccJerk-entropy()-Y      t    Body       Acc
    ## 105 105             tBodyAccJerk-entropy()-Z      t    Body       Acc
    ## 106 106           tBodyAccJerk-arCoeff()-X,1      t    Body       Acc
    ## 107 107           tBodyAccJerk-arCoeff()-X,2      t    Body       Acc
    ## 108 108           tBodyAccJerk-arCoeff()-X,3      t    Body       Acc
    ## 109 109           tBodyAccJerk-arCoeff()-X,4      t    Body       Acc
    ## 110 110           tBodyAccJerk-arCoeff()-Y,1      t    Body       Acc
    ## 111 111           tBodyAccJerk-arCoeff()-Y,2      t    Body       Acc
    ## 112 112           tBodyAccJerk-arCoeff()-Y,3      t    Body       Acc
    ## 113 113           tBodyAccJerk-arCoeff()-Y,4      t    Body       Acc
    ## 114 114           tBodyAccJerk-arCoeff()-Z,1      t    Body       Acc
    ## 115 115           tBodyAccJerk-arCoeff()-Z,2      t    Body       Acc
    ## 116 116           tBodyAccJerk-arCoeff()-Z,3      t    Body       Acc
    ## 117 117           tBodyAccJerk-arCoeff()-Z,4      t    Body       Acc
    ## 118 118       tBodyAccJerk-correlation()-X,Y      t    Body       Acc
    ## 119 119       tBodyAccJerk-correlation()-X,Z      t    Body       Acc
    ## 120 120       tBodyAccJerk-correlation()-Y,Z      t    Body       Acc
    ## 121 121                   tBodyGyro-mean()-X      t    Body      Gyro
    ## 122 122                   tBodyGyro-mean()-Y      t    Body      Gyro
    ## 123 123                   tBodyGyro-mean()-Z      t    Body      Gyro
    ## 124 124                    tBodyGyro-std()-X      t    Body      Gyro
    ## 125 125                    tBodyGyro-std()-Y      t    Body      Gyro
    ## 126 126                    tBodyGyro-std()-Z      t    Body      Gyro
    ## 127 127                    tBodyGyro-mad()-X      t    Body      Gyro
    ## 128 128                    tBodyGyro-mad()-Y      t    Body      Gyro
    ## 129 129                    tBodyGyro-mad()-Z      t    Body      Gyro
    ## 130 130                    tBodyGyro-max()-X      t    Body      Gyro
    ## 131 131                    tBodyGyro-max()-Y      t    Body      Gyro
    ## 132 132                    tBodyGyro-max()-Z      t    Body      Gyro
    ## 133 133                    tBodyGyro-min()-X      t    Body      Gyro
    ## 134 134                    tBodyGyro-min()-Y      t    Body      Gyro
    ## 135 135                    tBodyGyro-min()-Z      t    Body      Gyro
    ## 136 136                      tBodyGyro-sma()      t    Body      Gyro
    ## 137 137                 tBodyGyro-energy()-X      t    Body      Gyro
    ## 138 138                 tBodyGyro-energy()-Y      t    Body      Gyro
    ## 139 139                 tBodyGyro-energy()-Z      t    Body      Gyro
    ## 140 140                    tBodyGyro-iqr()-X      t    Body      Gyro
    ## 141 141                    tBodyGyro-iqr()-Y      t    Body      Gyro
    ## 142 142                    tBodyGyro-iqr()-Z      t    Body      Gyro
    ## 143 143                tBodyGyro-entropy()-X      t    Body      Gyro
    ## 144 144                tBodyGyro-entropy()-Y      t    Body      Gyro
    ## 145 145                tBodyGyro-entropy()-Z      t    Body      Gyro
    ## 146 146              tBodyGyro-arCoeff()-X,1      t    Body      Gyro
    ## 147 147              tBodyGyro-arCoeff()-X,2      t    Body      Gyro
    ## 148 148              tBodyGyro-arCoeff()-X,3      t    Body      Gyro
    ## 149 149              tBodyGyro-arCoeff()-X,4      t    Body      Gyro
    ## 150 150              tBodyGyro-arCoeff()-Y,1      t    Body      Gyro
    ## 151 151              tBodyGyro-arCoeff()-Y,2      t    Body      Gyro
    ## 152 152              tBodyGyro-arCoeff()-Y,3      t    Body      Gyro
    ## 153 153              tBodyGyro-arCoeff()-Y,4      t    Body      Gyro
    ## 154 154              tBodyGyro-arCoeff()-Z,1      t    Body      Gyro
    ## 155 155              tBodyGyro-arCoeff()-Z,2      t    Body      Gyro
    ## 156 156              tBodyGyro-arCoeff()-Z,3      t    Body      Gyro
    ## 157 157              tBodyGyro-arCoeff()-Z,4      t    Body      Gyro
    ## 158 158          tBodyGyro-correlation()-X,Y      t    Body      Gyro
    ## 159 159          tBodyGyro-correlation()-X,Z      t    Body      Gyro
    ## 160 160          tBodyGyro-correlation()-Y,Z      t    Body      Gyro
    ## 161 161               tBodyGyroJerk-mean()-X      t    Body      Gyro
    ## 162 162               tBodyGyroJerk-mean()-Y      t    Body      Gyro
    ## 163 163               tBodyGyroJerk-mean()-Z      t    Body      Gyro
    ## 164 164                tBodyGyroJerk-std()-X      t    Body      Gyro
    ## 165 165                tBodyGyroJerk-std()-Y      t    Body      Gyro
    ## 166 166                tBodyGyroJerk-std()-Z      t    Body      Gyro
    ## 167 167                tBodyGyroJerk-mad()-X      t    Body      Gyro
    ## 168 168                tBodyGyroJerk-mad()-Y      t    Body      Gyro
    ## 169 169                tBodyGyroJerk-mad()-Z      t    Body      Gyro
    ## 170 170                tBodyGyroJerk-max()-X      t    Body      Gyro
    ## 171 171                tBodyGyroJerk-max()-Y      t    Body      Gyro
    ## 172 172                tBodyGyroJerk-max()-Z      t    Body      Gyro
    ## 173 173                tBodyGyroJerk-min()-X      t    Body      Gyro
    ## 174 174                tBodyGyroJerk-min()-Y      t    Body      Gyro
    ## 175 175                tBodyGyroJerk-min()-Z      t    Body      Gyro
    ## 176 176                  tBodyGyroJerk-sma()      t    Body      Gyro
    ## 177 177             tBodyGyroJerk-energy()-X      t    Body      Gyro
    ## 178 178             tBodyGyroJerk-energy()-Y      t    Body      Gyro
    ## 179 179             tBodyGyroJerk-energy()-Z      t    Body      Gyro
    ## 180 180                tBodyGyroJerk-iqr()-X      t    Body      Gyro
    ## 181 181                tBodyGyroJerk-iqr()-Y      t    Body      Gyro
    ## 182 182                tBodyGyroJerk-iqr()-Z      t    Body      Gyro
    ## 183 183            tBodyGyroJerk-entropy()-X      t    Body      Gyro
    ## 184 184            tBodyGyroJerk-entropy()-Y      t    Body      Gyro
    ## 185 185            tBodyGyroJerk-entropy()-Z      t    Body      Gyro
    ## 186 186          tBodyGyroJerk-arCoeff()-X,1      t    Body      Gyro
    ## 187 187          tBodyGyroJerk-arCoeff()-X,2      t    Body      Gyro
    ## 188 188          tBodyGyroJerk-arCoeff()-X,3      t    Body      Gyro
    ## 189 189          tBodyGyroJerk-arCoeff()-X,4      t    Body      Gyro
    ## 190 190          tBodyGyroJerk-arCoeff()-Y,1      t    Body      Gyro
    ## 191 191          tBodyGyroJerk-arCoeff()-Y,2      t    Body      Gyro
    ## 192 192          tBodyGyroJerk-arCoeff()-Y,3      t    Body      Gyro
    ## 193 193          tBodyGyroJerk-arCoeff()-Y,4      t    Body      Gyro
    ## 194 194          tBodyGyroJerk-arCoeff()-Z,1      t    Body      Gyro
    ## 195 195          tBodyGyroJerk-arCoeff()-Z,2      t    Body      Gyro
    ## 196 196          tBodyGyroJerk-arCoeff()-Z,3      t    Body      Gyro
    ## 197 197          tBodyGyroJerk-arCoeff()-Z,4      t    Body      Gyro
    ## 198 198      tBodyGyroJerk-correlation()-X,Y      t    Body      Gyro
    ## 199 199      tBodyGyroJerk-correlation()-X,Z      t    Body      Gyro
    ## 200 200      tBodyGyroJerk-correlation()-Y,Z      t    Body      Gyro
    ## 201 201                   tBodyAccMag-mean()      t    Body       Acc
    ## 202 202                    tBodyAccMag-std()      t    Body       Acc
    ## 203 203                    tBodyAccMag-mad()      t    Body       Acc
    ## 204 204                    tBodyAccMag-max()      t    Body       Acc
    ## 205 205                    tBodyAccMag-min()      t    Body       Acc
    ## 206 206                    tBodyAccMag-sma()      t    Body       Acc
    ## 207 207                 tBodyAccMag-energy()      t    Body       Acc
    ## 208 208                    tBodyAccMag-iqr()      t    Body       Acc
    ## 209 209                tBodyAccMag-entropy()      t    Body       Acc
    ## 210 210               tBodyAccMag-arCoeff()1      t    Body       Acc
    ## 211 211               tBodyAccMag-arCoeff()2      t    Body       Acc
    ## 212 212               tBodyAccMag-arCoeff()3      t    Body       Acc
    ## 213 213               tBodyAccMag-arCoeff()4      t    Body       Acc
    ## 214 214                tGravityAccMag-mean()      t Gravity       Acc
    ## 215 215                 tGravityAccMag-std()      t Gravity       Acc
    ## 216 216                 tGravityAccMag-mad()      t Gravity       Acc
    ## 217 217                 tGravityAccMag-max()      t Gravity       Acc
    ## 218 218                 tGravityAccMag-min()      t Gravity       Acc
    ## 219 219                 tGravityAccMag-sma()      t Gravity       Acc
    ## 220 220              tGravityAccMag-energy()      t Gravity       Acc
    ## 221 221                 tGravityAccMag-iqr()      t Gravity       Acc
    ## 222 222             tGravityAccMag-entropy()      t Gravity       Acc
    ## 223 223            tGravityAccMag-arCoeff()1      t Gravity       Acc
    ## 224 224            tGravityAccMag-arCoeff()2      t Gravity       Acc
    ## 225 225            tGravityAccMag-arCoeff()3      t Gravity       Acc
    ## 226 226            tGravityAccMag-arCoeff()4      t Gravity       Acc
    ## 227 227               tBodyAccJerkMag-mean()      t    Body       Acc
    ## 228 228                tBodyAccJerkMag-std()      t    Body       Acc
    ## 229 229                tBodyAccJerkMag-mad()      t    Body       Acc
    ## 230 230                tBodyAccJerkMag-max()      t    Body       Acc
    ## 231 231                tBodyAccJerkMag-min()      t    Body       Acc
    ## 232 232                tBodyAccJerkMag-sma()      t    Body       Acc
    ## 233 233             tBodyAccJerkMag-energy()      t    Body       Acc
    ## 234 234                tBodyAccJerkMag-iqr()      t    Body       Acc
    ## 235 235            tBodyAccJerkMag-entropy()      t    Body       Acc
    ## 236 236           tBodyAccJerkMag-arCoeff()1      t    Body       Acc
    ## 237 237           tBodyAccJerkMag-arCoeff()2      t    Body       Acc
    ## 238 238           tBodyAccJerkMag-arCoeff()3      t    Body       Acc
    ## 239 239           tBodyAccJerkMag-arCoeff()4      t    Body       Acc
    ## 240 240                  tBodyGyroMag-mean()      t    Body      Gyro
    ## 241 241                   tBodyGyroMag-std()      t    Body      Gyro
    ## 242 242                   tBodyGyroMag-mad()      t    Body      Gyro
    ## 243 243                   tBodyGyroMag-max()      t    Body      Gyro
    ## 244 244                   tBodyGyroMag-min()      t    Body      Gyro
    ## 245 245                   tBodyGyroMag-sma()      t    Body      Gyro
    ## 246 246                tBodyGyroMag-energy()      t    Body      Gyro
    ## 247 247                   tBodyGyroMag-iqr()      t    Body      Gyro
    ## 248 248               tBodyGyroMag-entropy()      t    Body      Gyro
    ## 249 249              tBodyGyroMag-arCoeff()1      t    Body      Gyro
    ## 250 250              tBodyGyroMag-arCoeff()2      t    Body      Gyro
    ## 251 251              tBodyGyroMag-arCoeff()3      t    Body      Gyro
    ## 252 252              tBodyGyroMag-arCoeff()4      t    Body      Gyro
    ## 253 253              tBodyGyroJerkMag-mean()      t    Body      Gyro
    ## 254 254               tBodyGyroJerkMag-std()      t    Body      Gyro
    ## 255 255               tBodyGyroJerkMag-mad()      t    Body      Gyro
    ## 256 256               tBodyGyroJerkMag-max()      t    Body      Gyro
    ## 257 257               tBodyGyroJerkMag-min()      t    Body      Gyro
    ## 258 258               tBodyGyroJerkMag-sma()      t    Body      Gyro
    ## 259 259            tBodyGyroJerkMag-energy()      t    Body      Gyro
    ## 260 260               tBodyGyroJerkMag-iqr()      t    Body      Gyro
    ## 261 261           tBodyGyroJerkMag-entropy()      t    Body      Gyro
    ## 262 262          tBodyGyroJerkMag-arCoeff()1      t    Body      Gyro
    ## 263 263          tBodyGyroJerkMag-arCoeff()2      t    Body      Gyro
    ## 264 264          tBodyGyroJerkMag-arCoeff()3      t    Body      Gyro
    ## 265 265          tBodyGyroJerkMag-arCoeff()4      t    Body      Gyro
    ## 266 266                    fBodyAcc-mean()-X      f    Body       Acc
    ## 267 267                    fBodyAcc-mean()-Y      f    Body       Acc
    ## 268 268                    fBodyAcc-mean()-Z      f    Body       Acc
    ## 269 269                     fBodyAcc-std()-X      f    Body       Acc
    ## 270 270                     fBodyAcc-std()-Y      f    Body       Acc
    ## 271 271                     fBodyAcc-std()-Z      f    Body       Acc
    ## 272 272                     fBodyAcc-mad()-X      f    Body       Acc
    ## 273 273                     fBodyAcc-mad()-Y      f    Body       Acc
    ## 274 274                     fBodyAcc-mad()-Z      f    Body       Acc
    ## 275 275                     fBodyAcc-max()-X      f    Body       Acc
    ## 276 276                     fBodyAcc-max()-Y      f    Body       Acc
    ## 277 277                     fBodyAcc-max()-Z      f    Body       Acc
    ## 278 278                     fBodyAcc-min()-X      f    Body       Acc
    ## 279 279                     fBodyAcc-min()-Y      f    Body       Acc
    ## 280 280                     fBodyAcc-min()-Z      f    Body       Acc
    ## 281 281                       fBodyAcc-sma()      f    Body       Acc
    ## 282 282                  fBodyAcc-energy()-X      f    Body       Acc
    ## 283 283                  fBodyAcc-energy()-Y      f    Body       Acc
    ## 284 284                  fBodyAcc-energy()-Z      f    Body       Acc
    ## 285 285                     fBodyAcc-iqr()-X      f    Body       Acc
    ## 286 286                     fBodyAcc-iqr()-Y      f    Body       Acc
    ## 287 287                     fBodyAcc-iqr()-Z      f    Body       Acc
    ## 288 288                 fBodyAcc-entropy()-X      f    Body       Acc
    ## 289 289                 fBodyAcc-entropy()-Y      f    Body       Acc
    ## 290 290                 fBodyAcc-entropy()-Z      f    Body       Acc
    ## 291 291                 fBodyAcc-maxInds()-X      f    Body       Acc
    ## 292 292                 fBodyAcc-maxInds()-Y      f    Body       Acc
    ## 293 293                 fBodyAcc-maxInds()-Z      f    Body       Acc
    ## 294 294                fBodyAcc-meanFreq()-X      f    Body       Acc
    ## 295 295                fBodyAcc-meanFreq()-Y      f    Body       Acc
    ## 296 296                fBodyAcc-meanFreq()-Z      f    Body       Acc
    ## 297 297                fBodyAcc-skewness()-X      f    Body       Acc
    ## 298 298                fBodyAcc-kurtosis()-X      f    Body       Acc
    ## 299 299                fBodyAcc-skewness()-Y      f    Body       Acc
    ## 300 300                fBodyAcc-kurtosis()-Y      f    Body       Acc
    ## 301 301                fBodyAcc-skewness()-Z      f    Body       Acc
    ## 302 302                fBodyAcc-kurtosis()-Z      f    Body       Acc
    ## 303 303           fBodyAcc-bandsEnergy()-1,8      f    Body       Acc
    ## 304 304          fBodyAcc-bandsEnergy()-9,16      f    Body       Acc
    ## 305 305         fBodyAcc-bandsEnergy()-17,24      f    Body       Acc
    ## 306 306         fBodyAcc-bandsEnergy()-25,32      f    Body       Acc
    ## 307 307         fBodyAcc-bandsEnergy()-33,40      f    Body       Acc
    ## 308 308         fBodyAcc-bandsEnergy()-41,48      f    Body       Acc
    ## 309 309         fBodyAcc-bandsEnergy()-49,56      f    Body       Acc
    ## 310 310         fBodyAcc-bandsEnergy()-57,64      f    Body       Acc
    ## 311 311          fBodyAcc-bandsEnergy()-1,16      f    Body       Acc
    ## 312 312         fBodyAcc-bandsEnergy()-17,32      f    Body       Acc
    ## 313 313         fBodyAcc-bandsEnergy()-33,48      f    Body       Acc
    ## 314 314         fBodyAcc-bandsEnergy()-49,64      f    Body       Acc
    ## 315 315          fBodyAcc-bandsEnergy()-1,24      f    Body       Acc
    ## 316 316         fBodyAcc-bandsEnergy()-25,48      f    Body       Acc
    ## 317 317           fBodyAcc-bandsEnergy()-1,8      f    Body       Acc
    ## 318 318          fBodyAcc-bandsEnergy()-9,16      f    Body       Acc
    ## 319 319         fBodyAcc-bandsEnergy()-17,24      f    Body       Acc
    ## 320 320         fBodyAcc-bandsEnergy()-25,32      f    Body       Acc
    ## 321 321         fBodyAcc-bandsEnergy()-33,40      f    Body       Acc
    ## 322 322         fBodyAcc-bandsEnergy()-41,48      f    Body       Acc
    ## 323 323         fBodyAcc-bandsEnergy()-49,56      f    Body       Acc
    ## 324 324         fBodyAcc-bandsEnergy()-57,64      f    Body       Acc
    ## 325 325          fBodyAcc-bandsEnergy()-1,16      f    Body       Acc
    ## 326 326         fBodyAcc-bandsEnergy()-17,32      f    Body       Acc
    ## 327 327         fBodyAcc-bandsEnergy()-33,48      f    Body       Acc
    ## 328 328         fBodyAcc-bandsEnergy()-49,64      f    Body       Acc
    ## 329 329          fBodyAcc-bandsEnergy()-1,24      f    Body       Acc
    ## 330 330         fBodyAcc-bandsEnergy()-25,48      f    Body       Acc
    ## 331 331           fBodyAcc-bandsEnergy()-1,8      f    Body       Acc
    ## 332 332          fBodyAcc-bandsEnergy()-9,16      f    Body       Acc
    ## 333 333         fBodyAcc-bandsEnergy()-17,24      f    Body       Acc
    ## 334 334         fBodyAcc-bandsEnergy()-25,32      f    Body       Acc
    ## 335 335         fBodyAcc-bandsEnergy()-33,40      f    Body       Acc
    ## 336 336         fBodyAcc-bandsEnergy()-41,48      f    Body       Acc
    ## 337 337         fBodyAcc-bandsEnergy()-49,56      f    Body       Acc
    ## 338 338         fBodyAcc-bandsEnergy()-57,64      f    Body       Acc
    ## 339 339          fBodyAcc-bandsEnergy()-1,16      f    Body       Acc
    ## 340 340         fBodyAcc-bandsEnergy()-17,32      f    Body       Acc
    ## 341 341         fBodyAcc-bandsEnergy()-33,48      f    Body       Acc
    ## 342 342         fBodyAcc-bandsEnergy()-49,64      f    Body       Acc
    ## 343 343          fBodyAcc-bandsEnergy()-1,24      f    Body       Acc
    ## 344 344         fBodyAcc-bandsEnergy()-25,48      f    Body       Acc
    ## 345 345                fBodyAccJerk-mean()-X      f    Body       Acc
    ## 346 346                fBodyAccJerk-mean()-Y      f    Body       Acc
    ## 347 347                fBodyAccJerk-mean()-Z      f    Body       Acc
    ## 348 348                 fBodyAccJerk-std()-X      f    Body       Acc
    ## 349 349                 fBodyAccJerk-std()-Y      f    Body       Acc
    ## 350 350                 fBodyAccJerk-std()-Z      f    Body       Acc
    ## 351 351                 fBodyAccJerk-mad()-X      f    Body       Acc
    ## 352 352                 fBodyAccJerk-mad()-Y      f    Body       Acc
    ## 353 353                 fBodyAccJerk-mad()-Z      f    Body       Acc
    ## 354 354                 fBodyAccJerk-max()-X      f    Body       Acc
    ## 355 355                 fBodyAccJerk-max()-Y      f    Body       Acc
    ## 356 356                 fBodyAccJerk-max()-Z      f    Body       Acc
    ## 357 357                 fBodyAccJerk-min()-X      f    Body       Acc
    ## 358 358                 fBodyAccJerk-min()-Y      f    Body       Acc
    ## 359 359                 fBodyAccJerk-min()-Z      f    Body       Acc
    ## 360 360                   fBodyAccJerk-sma()      f    Body       Acc
    ## 361 361              fBodyAccJerk-energy()-X      f    Body       Acc
    ## 362 362              fBodyAccJerk-energy()-Y      f    Body       Acc
    ## 363 363              fBodyAccJerk-energy()-Z      f    Body       Acc
    ## 364 364                 fBodyAccJerk-iqr()-X      f    Body       Acc
    ## 365 365                 fBodyAccJerk-iqr()-Y      f    Body       Acc
    ## 366 366                 fBodyAccJerk-iqr()-Z      f    Body       Acc
    ## 367 367             fBodyAccJerk-entropy()-X      f    Body       Acc
    ## 368 368             fBodyAccJerk-entropy()-Y      f    Body       Acc
    ## 369 369             fBodyAccJerk-entropy()-Z      f    Body       Acc
    ## 370 370             fBodyAccJerk-maxInds()-X      f    Body       Acc
    ## 371 371             fBodyAccJerk-maxInds()-Y      f    Body       Acc
    ## 372 372             fBodyAccJerk-maxInds()-Z      f    Body       Acc
    ## 373 373            fBodyAccJerk-meanFreq()-X      f    Body       Acc
    ## 374 374            fBodyAccJerk-meanFreq()-Y      f    Body       Acc
    ## 375 375            fBodyAccJerk-meanFreq()-Z      f    Body       Acc
    ## 376 376            fBodyAccJerk-skewness()-X      f    Body       Acc
    ## 377 377            fBodyAccJerk-kurtosis()-X      f    Body       Acc
    ## 378 378            fBodyAccJerk-skewness()-Y      f    Body       Acc
    ## 379 379            fBodyAccJerk-kurtosis()-Y      f    Body       Acc
    ## 380 380            fBodyAccJerk-skewness()-Z      f    Body       Acc
    ## 381 381            fBodyAccJerk-kurtosis()-Z      f    Body       Acc
    ## 382 382       fBodyAccJerk-bandsEnergy()-1,8      f    Body       Acc
    ## 383 383      fBodyAccJerk-bandsEnergy()-9,16      f    Body       Acc
    ## 384 384     fBodyAccJerk-bandsEnergy()-17,24      f    Body       Acc
    ## 385 385     fBodyAccJerk-bandsEnergy()-25,32      f    Body       Acc
    ## 386 386     fBodyAccJerk-bandsEnergy()-33,40      f    Body       Acc
    ## 387 387     fBodyAccJerk-bandsEnergy()-41,48      f    Body       Acc
    ## 388 388     fBodyAccJerk-bandsEnergy()-49,56      f    Body       Acc
    ## 389 389     fBodyAccJerk-bandsEnergy()-57,64      f    Body       Acc
    ## 390 390      fBodyAccJerk-bandsEnergy()-1,16      f    Body       Acc
    ## 391 391     fBodyAccJerk-bandsEnergy()-17,32      f    Body       Acc
    ## 392 392     fBodyAccJerk-bandsEnergy()-33,48      f    Body       Acc
    ## 393 393     fBodyAccJerk-bandsEnergy()-49,64      f    Body       Acc
    ## 394 394      fBodyAccJerk-bandsEnergy()-1,24      f    Body       Acc
    ## 395 395     fBodyAccJerk-bandsEnergy()-25,48      f    Body       Acc
    ## 396 396       fBodyAccJerk-bandsEnergy()-1,8      f    Body       Acc
    ## 397 397      fBodyAccJerk-bandsEnergy()-9,16      f    Body       Acc
    ## 398 398     fBodyAccJerk-bandsEnergy()-17,24      f    Body       Acc
    ## 399 399     fBodyAccJerk-bandsEnergy()-25,32      f    Body       Acc
    ## 400 400     fBodyAccJerk-bandsEnergy()-33,40      f    Body       Acc
    ## 401 401     fBodyAccJerk-bandsEnergy()-41,48      f    Body       Acc
    ## 402 402     fBodyAccJerk-bandsEnergy()-49,56      f    Body       Acc
    ## 403 403     fBodyAccJerk-bandsEnergy()-57,64      f    Body       Acc
    ## 404 404      fBodyAccJerk-bandsEnergy()-1,16      f    Body       Acc
    ## 405 405     fBodyAccJerk-bandsEnergy()-17,32      f    Body       Acc
    ## 406 406     fBodyAccJerk-bandsEnergy()-33,48      f    Body       Acc
    ## 407 407     fBodyAccJerk-bandsEnergy()-49,64      f    Body       Acc
    ## 408 408      fBodyAccJerk-bandsEnergy()-1,24      f    Body       Acc
    ## 409 409     fBodyAccJerk-bandsEnergy()-25,48      f    Body       Acc
    ## 410 410       fBodyAccJerk-bandsEnergy()-1,8      f    Body       Acc
    ## 411 411      fBodyAccJerk-bandsEnergy()-9,16      f    Body       Acc
    ## 412 412     fBodyAccJerk-bandsEnergy()-17,24      f    Body       Acc
    ## 413 413     fBodyAccJerk-bandsEnergy()-25,32      f    Body       Acc
    ## 414 414     fBodyAccJerk-bandsEnergy()-33,40      f    Body       Acc
    ## 415 415     fBodyAccJerk-bandsEnergy()-41,48      f    Body       Acc
    ## 416 416     fBodyAccJerk-bandsEnergy()-49,56      f    Body       Acc
    ## 417 417     fBodyAccJerk-bandsEnergy()-57,64      f    Body       Acc
    ## 418 418      fBodyAccJerk-bandsEnergy()-1,16      f    Body       Acc
    ## 419 419     fBodyAccJerk-bandsEnergy()-17,32      f    Body       Acc
    ## 420 420     fBodyAccJerk-bandsEnergy()-33,48      f    Body       Acc
    ## 421 421     fBodyAccJerk-bandsEnergy()-49,64      f    Body       Acc
    ## 422 422      fBodyAccJerk-bandsEnergy()-1,24      f    Body       Acc
    ## 423 423     fBodyAccJerk-bandsEnergy()-25,48      f    Body       Acc
    ## 424 424                   fBodyGyro-mean()-X      f    Body      Gyro
    ## 425 425                   fBodyGyro-mean()-Y      f    Body      Gyro
    ## 426 426                   fBodyGyro-mean()-Z      f    Body      Gyro
    ## 427 427                    fBodyGyro-std()-X      f    Body      Gyro
    ## 428 428                    fBodyGyro-std()-Y      f    Body      Gyro
    ## 429 429                    fBodyGyro-std()-Z      f    Body      Gyro
    ## 430 430                    fBodyGyro-mad()-X      f    Body      Gyro
    ## 431 431                    fBodyGyro-mad()-Y      f    Body      Gyro
    ## 432 432                    fBodyGyro-mad()-Z      f    Body      Gyro
    ## 433 433                    fBodyGyro-max()-X      f    Body      Gyro
    ## 434 434                    fBodyGyro-max()-Y      f    Body      Gyro
    ## 435 435                    fBodyGyro-max()-Z      f    Body      Gyro
    ## 436 436                    fBodyGyro-min()-X      f    Body      Gyro
    ## 437 437                    fBodyGyro-min()-Y      f    Body      Gyro
    ## 438 438                    fBodyGyro-min()-Z      f    Body      Gyro
    ## 439 439                      fBodyGyro-sma()      f    Body      Gyro
    ## 440 440                 fBodyGyro-energy()-X      f    Body      Gyro
    ## 441 441                 fBodyGyro-energy()-Y      f    Body      Gyro
    ## 442 442                 fBodyGyro-energy()-Z      f    Body      Gyro
    ## 443 443                    fBodyGyro-iqr()-X      f    Body      Gyro
    ## 444 444                    fBodyGyro-iqr()-Y      f    Body      Gyro
    ## 445 445                    fBodyGyro-iqr()-Z      f    Body      Gyro
    ## 446 446                fBodyGyro-entropy()-X      f    Body      Gyro
    ## 447 447                fBodyGyro-entropy()-Y      f    Body      Gyro
    ## 448 448                fBodyGyro-entropy()-Z      f    Body      Gyro
    ## 449 449                fBodyGyro-maxInds()-X      f    Body      Gyro
    ## 450 450                fBodyGyro-maxInds()-Y      f    Body      Gyro
    ## 451 451                fBodyGyro-maxInds()-Z      f    Body      Gyro
    ## 452 452               fBodyGyro-meanFreq()-X      f    Body      Gyro
    ## 453 453               fBodyGyro-meanFreq()-Y      f    Body      Gyro
    ## 454 454               fBodyGyro-meanFreq()-Z      f    Body      Gyro
    ## 455 455               fBodyGyro-skewness()-X      f    Body      Gyro
    ## 456 456               fBodyGyro-kurtosis()-X      f    Body      Gyro
    ## 457 457               fBodyGyro-skewness()-Y      f    Body      Gyro
    ## 458 458               fBodyGyro-kurtosis()-Y      f    Body      Gyro
    ## 459 459               fBodyGyro-skewness()-Z      f    Body      Gyro
    ## 460 460               fBodyGyro-kurtosis()-Z      f    Body      Gyro
    ## 461 461          fBodyGyro-bandsEnergy()-1,8      f    Body      Gyro
    ## 462 462         fBodyGyro-bandsEnergy()-9,16      f    Body      Gyro
    ## 463 463        fBodyGyro-bandsEnergy()-17,24      f    Body      Gyro
    ## 464 464        fBodyGyro-bandsEnergy()-25,32      f    Body      Gyro
    ## 465 465        fBodyGyro-bandsEnergy()-33,40      f    Body      Gyro
    ## 466 466        fBodyGyro-bandsEnergy()-41,48      f    Body      Gyro
    ## 467 467        fBodyGyro-bandsEnergy()-49,56      f    Body      Gyro
    ## 468 468        fBodyGyro-bandsEnergy()-57,64      f    Body      Gyro
    ## 469 469         fBodyGyro-bandsEnergy()-1,16      f    Body      Gyro
    ## 470 470        fBodyGyro-bandsEnergy()-17,32      f    Body      Gyro
    ## 471 471        fBodyGyro-bandsEnergy()-33,48      f    Body      Gyro
    ## 472 472        fBodyGyro-bandsEnergy()-49,64      f    Body      Gyro
    ## 473 473         fBodyGyro-bandsEnergy()-1,24      f    Body      Gyro
    ## 474 474        fBodyGyro-bandsEnergy()-25,48      f    Body      Gyro
    ## 475 475          fBodyGyro-bandsEnergy()-1,8      f    Body      Gyro
    ## 476 476         fBodyGyro-bandsEnergy()-9,16      f    Body      Gyro
    ## 477 477        fBodyGyro-bandsEnergy()-17,24      f    Body      Gyro
    ## 478 478        fBodyGyro-bandsEnergy()-25,32      f    Body      Gyro
    ## 479 479        fBodyGyro-bandsEnergy()-33,40      f    Body      Gyro
    ## 480 480        fBodyGyro-bandsEnergy()-41,48      f    Body      Gyro
    ## 481 481        fBodyGyro-bandsEnergy()-49,56      f    Body      Gyro
    ## 482 482        fBodyGyro-bandsEnergy()-57,64      f    Body      Gyro
    ## 483 483         fBodyGyro-bandsEnergy()-1,16      f    Body      Gyro
    ## 484 484        fBodyGyro-bandsEnergy()-17,32      f    Body      Gyro
    ## 485 485        fBodyGyro-bandsEnergy()-33,48      f    Body      Gyro
    ## 486 486        fBodyGyro-bandsEnergy()-49,64      f    Body      Gyro
    ## 487 487         fBodyGyro-bandsEnergy()-1,24      f    Body      Gyro
    ## 488 488        fBodyGyro-bandsEnergy()-25,48      f    Body      Gyro
    ## 489 489          fBodyGyro-bandsEnergy()-1,8      f    Body      Gyro
    ## 490 490         fBodyGyro-bandsEnergy()-9,16      f    Body      Gyro
    ## 491 491        fBodyGyro-bandsEnergy()-17,24      f    Body      Gyro
    ## 492 492        fBodyGyro-bandsEnergy()-25,32      f    Body      Gyro
    ## 493 493        fBodyGyro-bandsEnergy()-33,40      f    Body      Gyro
    ## 494 494        fBodyGyro-bandsEnergy()-41,48      f    Body      Gyro
    ## 495 495        fBodyGyro-bandsEnergy()-49,56      f    Body      Gyro
    ## 496 496        fBodyGyro-bandsEnergy()-57,64      f    Body      Gyro
    ## 497 497         fBodyGyro-bandsEnergy()-1,16      f    Body      Gyro
    ## 498 498        fBodyGyro-bandsEnergy()-17,32      f    Body      Gyro
    ## 499 499        fBodyGyro-bandsEnergy()-33,48      f    Body      Gyro
    ## 500 500        fBodyGyro-bandsEnergy()-49,64      f    Body      Gyro
    ## 501 501         fBodyGyro-bandsEnergy()-1,24      f    Body      Gyro
    ## 502 502        fBodyGyro-bandsEnergy()-25,48      f    Body      Gyro
    ## 503 503                   fBodyAccMag-mean()      f    Body       Acc
    ## 504 504                    fBodyAccMag-std()      f    Body       Acc
    ## 505 505                    fBodyAccMag-mad()      f    Body       Acc
    ## 506 506                    fBodyAccMag-max()      f    Body       Acc
    ## 507 507                    fBodyAccMag-min()      f    Body       Acc
    ## 508 508                    fBodyAccMag-sma()      f    Body       Acc
    ## 509 509                 fBodyAccMag-energy()      f    Body       Acc
    ## 510 510                    fBodyAccMag-iqr()      f    Body       Acc
    ## 511 511                fBodyAccMag-entropy()      f    Body       Acc
    ## 512 512                fBodyAccMag-maxInds()      f    Body       Acc
    ## 513 513               fBodyAccMag-meanFreq()      f    Body       Acc
    ## 514 514               fBodyAccMag-skewness()      f    Body       Acc
    ## 515 515               fBodyAccMag-kurtosis()      f    Body       Acc
    ## 516 516               fBodyAccJerkMag-mean()      f    Body       Acc
    ## 517 517                fBodyAccJerkMag-std()      f    Body       Acc
    ## 518 518                fBodyAccJerkMag-mad()      f    Body       Acc
    ## 519 519                fBodyAccJerkMag-max()      f    Body       Acc
    ## 520 520                fBodyAccJerkMag-min()      f    Body       Acc
    ## 521 521                fBodyAccJerkMag-sma()      f    Body       Acc
    ## 522 522             fBodyAccJerkMag-energy()      f    Body       Acc
    ## 523 523                fBodyAccJerkMag-iqr()      f    Body       Acc
    ## 524 524            fBodyAccJerkMag-entropy()      f    Body       Acc
    ## 525 525            fBodyAccJerkMag-maxInds()      f    Body       Acc
    ## 526 526           fBodyAccJerkMag-meanFreq()      f    Body       Acc
    ## 527 527           fBodyAccJerkMag-skewness()      f    Body       Acc
    ## 528 528           fBodyAccJerkMag-kurtosis()      f    Body       Acc
    ## 529 529                  fBodyGyroMag-mean()      f    Body      Gyro
    ## 530 530                   fBodyGyroMag-std()      f    Body      Gyro
    ## 531 531                   fBodyGyroMag-mad()      f    Body      Gyro
    ## 532 532                   fBodyGyroMag-max()      f    Body      Gyro
    ## 533 533                   fBodyGyroMag-min()      f    Body      Gyro
    ## 534 534                   fBodyGyroMag-sma()      f    Body      Gyro
    ## 535 535                fBodyGyroMag-energy()      f    Body      Gyro
    ## 536 536                   fBodyGyroMag-iqr()      f    Body      Gyro
    ## 537 537               fBodyGyroMag-entropy()      f    Body      Gyro
    ## 538 538               fBodyGyroMag-maxInds()      f    Body      Gyro
    ## 539 539              fBodyGyroMag-meanFreq()      f    Body      Gyro
    ## 540 540              fBodyGyroMag-skewness()      f    Body      Gyro
    ## 541 541              fBodyGyroMag-kurtosis()      f    Body      Gyro
    ## 542 542              fBodyGyroJerkMag-mean()      f    Body      Gyro
    ## 543 543               fBodyGyroJerkMag-std()      f    Body      Gyro
    ## 544 544               fBodyGyroJerkMag-mad()      f    Body      Gyro
    ## 545 545               fBodyGyroJerkMag-max()      f    Body      Gyro
    ## 546 546               fBodyGyroJerkMag-min()      f    Body      Gyro
    ## 547 547               fBodyGyroJerkMag-sma()      f    Body      Gyro
    ## 548 548            fBodyGyroJerkMag-energy()      f    Body      Gyro
    ## 549 549               fBodyGyroJerkMag-iqr()      f    Body      Gyro
    ## 550 550           fBodyGyroJerkMag-entropy()      f    Body      Gyro
    ## 551 551           fBodyGyroJerkMag-maxInds()      f    Body      Gyro
    ## 552 552          fBodyGyroJerkMag-meanFreq()      f    Body      Gyro
    ## 553 553          fBodyGyroJerkMag-skewness()      f    Body      Gyro
    ## 554 554          fBodyGyroJerkMag-kurtosis()      f    Body      Gyro
    ## 555 555          angle(tBodyAccMean,gravity)                         
    ## 556 556  angle(tBodyAccJerkMean,gravityMean)                         
    ## 557 557     angle(tBodyGyroMean,gravityMean)                         
    ## 558 558 angle(tBodyGyroJerkMean,gravityMean)                         
    ## 559 559                 angle(X,gravityMean)                         
    ## 560 560                 angle(Y,gravityMean)                         
    ## 561 561                 angle(Z,gravityMean)                         
    ##     jerkSuffix magSuffix statSep1   statistic statSep2 statSep3 axisSep
    ## 1                               -        mean        (        )       -
    ## 2                               -        mean        (        )       -
    ## 3                               -        mean        (        )       -
    ## 4                               -         std        (        )       -
    ## 5                               -         std        (        )       -
    ## 6                               -         std        (        )       -
    ## 7                               -         mad        (        )       -
    ## 8                               -         mad        (        )       -
    ## 9                               -         mad        (        )       -
    ## 10                              -         max        (        )       -
    ## 11                              -         max        (        )       -
    ## 12                              -         max        (        )       -
    ## 13                              -         min        (        )       -
    ## 14                              -         min        (        )       -
    ## 15                              -         min        (        )       -
    ## 16                              -         sma        (        )        
    ## 17                              -      energy        (        )       -
    ## 18                              -      energy        (        )       -
    ## 19                              -      energy        (        )       -
    ## 20                              -         iqr        (        )       -
    ## 21                              -         iqr        (        )       -
    ## 22                              -         iqr        (        )       -
    ## 23                              -     entropy        (        )       -
    ## 24                              -     entropy        (        )       -
    ## 25                              -     entropy        (        )       -
    ## 26                              -     arCoeff        (        )       -
    ## 27                              -     arCoeff        (        )       -
    ## 28                              -     arCoeff        (        )       -
    ## 29                              -     arCoeff        (        )       -
    ## 30                              -     arCoeff        (        )       -
    ## 31                              -     arCoeff        (        )       -
    ## 32                              -     arCoeff        (        )       -
    ## 33                              -     arCoeff        (        )       -
    ## 34                              -     arCoeff        (        )       -
    ## 35                              -     arCoeff        (        )       -
    ## 36                              -     arCoeff        (        )       -
    ## 37                              -     arCoeff        (        )       -
    ## 38                              - correlation        (        )        
    ## 39                              - correlation        (        )        
    ## 40                              - correlation        (        )        
    ## 41                              -        mean        (        )       -
    ## 42                              -        mean        (        )       -
    ## 43                              -        mean        (        )       -
    ## 44                              -         std        (        )       -
    ## 45                              -         std        (        )       -
    ## 46                              -         std        (        )       -
    ## 47                              -         mad        (        )       -
    ## 48                              -         mad        (        )       -
    ## 49                              -         mad        (        )       -
    ## 50                              -         max        (        )       -
    ## 51                              -         max        (        )       -
    ## 52                              -         max        (        )       -
    ## 53                              -         min        (        )       -
    ## 54                              -         min        (        )       -
    ## 55                              -         min        (        )       -
    ## 56                              -         sma        (        )        
    ## 57                              -      energy        (        )       -
    ## 58                              -      energy        (        )       -
    ## 59                              -      energy        (        )       -
    ## 60                              -         iqr        (        )       -
    ## 61                              -         iqr        (        )       -
    ## 62                              -         iqr        (        )       -
    ## 63                              -     entropy        (        )       -
    ## 64                              -     entropy        (        )       -
    ## 65                              -     entropy        (        )       -
    ## 66                              -     arCoeff        (        )       -
    ## 67                              -     arCoeff        (        )       -
    ## 68                              -     arCoeff        (        )       -
    ## 69                              -     arCoeff        (        )       -
    ## 70                              -     arCoeff        (        )       -
    ## 71                              -     arCoeff        (        )       -
    ## 72                              -     arCoeff        (        )       -
    ## 73                              -     arCoeff        (        )       -
    ## 74                              -     arCoeff        (        )       -
    ## 75                              -     arCoeff        (        )       -
    ## 76                              -     arCoeff        (        )       -
    ## 77                              -     arCoeff        (        )       -
    ## 78                              - correlation        (        )        
    ## 79                              - correlation        (        )        
    ## 80                              - correlation        (        )        
    ## 81        Jerk                  -        mean        (        )       -
    ## 82        Jerk                  -        mean        (        )       -
    ## 83        Jerk                  -        mean        (        )       -
    ## 84        Jerk                  -         std        (        )       -
    ## 85        Jerk                  -         std        (        )       -
    ## 86        Jerk                  -         std        (        )       -
    ## 87        Jerk                  -         mad        (        )       -
    ## 88        Jerk                  -         mad        (        )       -
    ## 89        Jerk                  -         mad        (        )       -
    ## 90        Jerk                  -         max        (        )       -
    ## 91        Jerk                  -         max        (        )       -
    ## 92        Jerk                  -         max        (        )       -
    ## 93        Jerk                  -         min        (        )       -
    ## 94        Jerk                  -         min        (        )       -
    ## 95        Jerk                  -         min        (        )       -
    ## 96        Jerk                  -         sma        (        )        
    ## 97        Jerk                  -      energy        (        )       -
    ## 98        Jerk                  -      energy        (        )       -
    ## 99        Jerk                  -      energy        (        )       -
    ## 100       Jerk                  -         iqr        (        )       -
    ## 101       Jerk                  -         iqr        (        )       -
    ## 102       Jerk                  -         iqr        (        )       -
    ## 103       Jerk                  -     entropy        (        )       -
    ## 104       Jerk                  -     entropy        (        )       -
    ## 105       Jerk                  -     entropy        (        )       -
    ## 106       Jerk                  -     arCoeff        (        )       -
    ## 107       Jerk                  -     arCoeff        (        )       -
    ## 108       Jerk                  -     arCoeff        (        )       -
    ## 109       Jerk                  -     arCoeff        (        )       -
    ## 110       Jerk                  -     arCoeff        (        )       -
    ## 111       Jerk                  -     arCoeff        (        )       -
    ## 112       Jerk                  -     arCoeff        (        )       -
    ## 113       Jerk                  -     arCoeff        (        )       -
    ## 114       Jerk                  -     arCoeff        (        )       -
    ## 115       Jerk                  -     arCoeff        (        )       -
    ## 116       Jerk                  -     arCoeff        (        )       -
    ## 117       Jerk                  -     arCoeff        (        )       -
    ## 118       Jerk                  - correlation        (        )        
    ## 119       Jerk                  - correlation        (        )        
    ## 120       Jerk                  - correlation        (        )        
    ## 121                             -        mean        (        )       -
    ## 122                             -        mean        (        )       -
    ## 123                             -        mean        (        )       -
    ## 124                             -         std        (        )       -
    ## 125                             -         std        (        )       -
    ## 126                             -         std        (        )       -
    ## 127                             -         mad        (        )       -
    ## 128                             -         mad        (        )       -
    ## 129                             -         mad        (        )       -
    ## 130                             -         max        (        )       -
    ## 131                             -         max        (        )       -
    ## 132                             -         max        (        )       -
    ## 133                             -         min        (        )       -
    ## 134                             -         min        (        )       -
    ## 135                             -         min        (        )       -
    ## 136                             -         sma        (        )        
    ## 137                             -      energy        (        )       -
    ## 138                             -      energy        (        )       -
    ## 139                             -      energy        (        )       -
    ## 140                             -         iqr        (        )       -
    ## 141                             -         iqr        (        )       -
    ## 142                             -         iqr        (        )       -
    ## 143                             -     entropy        (        )       -
    ## 144                             -     entropy        (        )       -
    ## 145                             -     entropy        (        )       -
    ## 146                             -     arCoeff        (        )       -
    ## 147                             -     arCoeff        (        )       -
    ## 148                             -     arCoeff        (        )       -
    ## 149                             -     arCoeff        (        )       -
    ## 150                             -     arCoeff        (        )       -
    ## 151                             -     arCoeff        (        )       -
    ## 152                             -     arCoeff        (        )       -
    ## 153                             -     arCoeff        (        )       -
    ## 154                             -     arCoeff        (        )       -
    ## 155                             -     arCoeff        (        )       -
    ## 156                             -     arCoeff        (        )       -
    ## 157                             -     arCoeff        (        )       -
    ## 158                             - correlation        (        )        
    ## 159                             - correlation        (        )        
    ## 160                             - correlation        (        )        
    ## 161       Jerk                  -        mean        (        )       -
    ## 162       Jerk                  -        mean        (        )       -
    ## 163       Jerk                  -        mean        (        )       -
    ## 164       Jerk                  -         std        (        )       -
    ## 165       Jerk                  -         std        (        )       -
    ## 166       Jerk                  -         std        (        )       -
    ## 167       Jerk                  -         mad        (        )       -
    ## 168       Jerk                  -         mad        (        )       -
    ## 169       Jerk                  -         mad        (        )       -
    ## 170       Jerk                  -         max        (        )       -
    ## 171       Jerk                  -         max        (        )       -
    ## 172       Jerk                  -         max        (        )       -
    ## 173       Jerk                  -         min        (        )       -
    ## 174       Jerk                  -         min        (        )       -
    ## 175       Jerk                  -         min        (        )       -
    ## 176       Jerk                  -         sma        (        )        
    ## 177       Jerk                  -      energy        (        )       -
    ## 178       Jerk                  -      energy        (        )       -
    ## 179       Jerk                  -      energy        (        )       -
    ## 180       Jerk                  -         iqr        (        )       -
    ## 181       Jerk                  -         iqr        (        )       -
    ## 182       Jerk                  -         iqr        (        )       -
    ## 183       Jerk                  -     entropy        (        )       -
    ## 184       Jerk                  -     entropy        (        )       -
    ## 185       Jerk                  -     entropy        (        )       -
    ## 186       Jerk                  -     arCoeff        (        )       -
    ## 187       Jerk                  -     arCoeff        (        )       -
    ## 188       Jerk                  -     arCoeff        (        )       -
    ## 189       Jerk                  -     arCoeff        (        )       -
    ## 190       Jerk                  -     arCoeff        (        )       -
    ## 191       Jerk                  -     arCoeff        (        )       -
    ## 192       Jerk                  -     arCoeff        (        )       -
    ## 193       Jerk                  -     arCoeff        (        )       -
    ## 194       Jerk                  -     arCoeff        (        )       -
    ## 195       Jerk                  -     arCoeff        (        )       -
    ## 196       Jerk                  -     arCoeff        (        )       -
    ## 197       Jerk                  -     arCoeff        (        )       -
    ## 198       Jerk                  - correlation        (        )        
    ## 199       Jerk                  - correlation        (        )        
    ## 200       Jerk                  - correlation        (        )        
    ## 201                  Mag        -        mean        (        )        
    ## 202                  Mag        -         std        (        )        
    ## 203                  Mag        -         mad        (        )        
    ## 204                  Mag        -         max        (        )        
    ## 205                  Mag        -         min        (        )        
    ## 206                  Mag        -         sma        (        )        
    ## 207                  Mag        -      energy        (        )        
    ## 208                  Mag        -         iqr        (        )        
    ## 209                  Mag        -     entropy        (        )        
    ## 210                  Mag        -     arCoeff        (        )        
    ## 211                  Mag        -     arCoeff        (        )        
    ## 212                  Mag        -     arCoeff        (        )        
    ## 213                  Mag        -     arCoeff        (        )        
    ## 214                  Mag        -        mean        (        )        
    ## 215                  Mag        -         std        (        )        
    ## 216                  Mag        -         mad        (        )        
    ## 217                  Mag        -         max        (        )        
    ## 218                  Mag        -         min        (        )        
    ## 219                  Mag        -         sma        (        )        
    ## 220                  Mag        -      energy        (        )        
    ## 221                  Mag        -         iqr        (        )        
    ## 222                  Mag        -     entropy        (        )        
    ## 223                  Mag        -     arCoeff        (        )        
    ## 224                  Mag        -     arCoeff        (        )        
    ## 225                  Mag        -     arCoeff        (        )        
    ## 226                  Mag        -     arCoeff        (        )        
    ## 227       Jerk       Mag        -        mean        (        )        
    ## 228       Jerk       Mag        -         std        (        )        
    ## 229       Jerk       Mag        -         mad        (        )        
    ## 230       Jerk       Mag        -         max        (        )        
    ## 231       Jerk       Mag        -         min        (        )        
    ## 232       Jerk       Mag        -         sma        (        )        
    ## 233       Jerk       Mag        -      energy        (        )        
    ## 234       Jerk       Mag        -         iqr        (        )        
    ## 235       Jerk       Mag        -     entropy        (        )        
    ## 236       Jerk       Mag        -     arCoeff        (        )        
    ## 237       Jerk       Mag        -     arCoeff        (        )        
    ## 238       Jerk       Mag        -     arCoeff        (        )        
    ## 239       Jerk       Mag        -     arCoeff        (        )        
    ## 240                  Mag        -        mean        (        )        
    ## 241                  Mag        -         std        (        )        
    ## 242                  Mag        -         mad        (        )        
    ## 243                  Mag        -         max        (        )        
    ## 244                  Mag        -         min        (        )        
    ## 245                  Mag        -         sma        (        )        
    ## 246                  Mag        -      energy        (        )        
    ## 247                  Mag        -         iqr        (        )        
    ## 248                  Mag        -     entropy        (        )        
    ## 249                  Mag        -     arCoeff        (        )        
    ## 250                  Mag        -     arCoeff        (        )        
    ## 251                  Mag        -     arCoeff        (        )        
    ## 252                  Mag        -     arCoeff        (        )        
    ## 253       Jerk       Mag        -        mean        (        )        
    ## 254       Jerk       Mag        -         std        (        )        
    ## 255       Jerk       Mag        -         mad        (        )        
    ## 256       Jerk       Mag        -         max        (        )        
    ## 257       Jerk       Mag        -         min        (        )        
    ## 258       Jerk       Mag        -         sma        (        )        
    ## 259       Jerk       Mag        -      energy        (        )        
    ## 260       Jerk       Mag        -         iqr        (        )        
    ## 261       Jerk       Mag        -     entropy        (        )        
    ## 262       Jerk       Mag        -     arCoeff        (        )        
    ## 263       Jerk       Mag        -     arCoeff        (        )        
    ## 264       Jerk       Mag        -     arCoeff        (        )        
    ## 265       Jerk       Mag        -     arCoeff        (        )        
    ## 266                             -        mean        (        )       -
    ## 267                             -        mean        (        )       -
    ## 268                             -        mean        (        )       -
    ## 269                             -         std        (        )       -
    ## 270                             -         std        (        )       -
    ## 271                             -         std        (        )       -
    ## 272                             -         mad        (        )       -
    ## 273                             -         mad        (        )       -
    ## 274                             -         mad        (        )       -
    ## 275                             -         max        (        )       -
    ## 276                             -         max        (        )       -
    ## 277                             -         max        (        )       -
    ## 278                             -         min        (        )       -
    ## 279                             -         min        (        )       -
    ## 280                             -         min        (        )       -
    ## 281                             -         sma        (        )        
    ## 282                             -      energy        (        )       -
    ## 283                             -      energy        (        )       -
    ## 284                             -      energy        (        )       -
    ## 285                             -         iqr        (        )       -
    ## 286                             -         iqr        (        )       -
    ## 287                             -         iqr        (        )       -
    ## 288                             -     entropy        (        )       -
    ## 289                             -     entropy        (        )       -
    ## 290                             -     entropy        (        )       -
    ## 291                             -     maxInds        (        )       -
    ## 292                             -     maxInds        (        )       -
    ## 293                             -     maxInds        (        )       -
    ## 294                             -    meanFreq        (        )       -
    ## 295                             -    meanFreq        (        )       -
    ## 296                             -    meanFreq        (        )       -
    ## 297                             -    skewness        (        )       -
    ## 298                             -    kurtosis        (        )       -
    ## 299                             -    skewness        (        )       -
    ## 300                             -    kurtosis        (        )       -
    ## 301                             -    skewness        (        )       -
    ## 302                             -    kurtosis        (        )       -
    ## 303                             - bandsEnergy        (        )        
    ## 304                             - bandsEnergy        (        )        
    ## 305                             - bandsEnergy        (        )        
    ## 306                             - bandsEnergy        (        )        
    ## 307                             - bandsEnergy        (        )        
    ## 308                             - bandsEnergy        (        )        
    ## 309                             - bandsEnergy        (        )        
    ## 310                             - bandsEnergy        (        )        
    ## 311                             - bandsEnergy        (        )        
    ## 312                             - bandsEnergy        (        )        
    ## 313                             - bandsEnergy        (        )        
    ## 314                             - bandsEnergy        (        )        
    ## 315                             - bandsEnergy        (        )        
    ## 316                             - bandsEnergy        (        )        
    ## 317                             - bandsEnergy        (        )        
    ## 318                             - bandsEnergy        (        )        
    ## 319                             - bandsEnergy        (        )        
    ## 320                             - bandsEnergy        (        )        
    ## 321                             - bandsEnergy        (        )        
    ## 322                             - bandsEnergy        (        )        
    ## 323                             - bandsEnergy        (        )        
    ## 324                             - bandsEnergy        (        )        
    ## 325                             - bandsEnergy        (        )        
    ## 326                             - bandsEnergy        (        )        
    ## 327                             - bandsEnergy        (        )        
    ## 328                             - bandsEnergy        (        )        
    ## 329                             - bandsEnergy        (        )        
    ## 330                             - bandsEnergy        (        )        
    ## 331                             - bandsEnergy        (        )        
    ## 332                             - bandsEnergy        (        )        
    ## 333                             - bandsEnergy        (        )        
    ## 334                             - bandsEnergy        (        )        
    ## 335                             - bandsEnergy        (        )        
    ## 336                             - bandsEnergy        (        )        
    ## 337                             - bandsEnergy        (        )        
    ## 338                             - bandsEnergy        (        )        
    ## 339                             - bandsEnergy        (        )        
    ## 340                             - bandsEnergy        (        )        
    ## 341                             - bandsEnergy        (        )        
    ## 342                             - bandsEnergy        (        )        
    ## 343                             - bandsEnergy        (        )        
    ## 344                             - bandsEnergy        (        )        
    ## 345       Jerk                  -        mean        (        )       -
    ## 346       Jerk                  -        mean        (        )       -
    ## 347       Jerk                  -        mean        (        )       -
    ## 348       Jerk                  -         std        (        )       -
    ## 349       Jerk                  -         std        (        )       -
    ## 350       Jerk                  -         std        (        )       -
    ## 351       Jerk                  -         mad        (        )       -
    ## 352       Jerk                  -         mad        (        )       -
    ## 353       Jerk                  -         mad        (        )       -
    ## 354       Jerk                  -         max        (        )       -
    ## 355       Jerk                  -         max        (        )       -
    ## 356       Jerk                  -         max        (        )       -
    ## 357       Jerk                  -         min        (        )       -
    ## 358       Jerk                  -         min        (        )       -
    ## 359       Jerk                  -         min        (        )       -
    ## 360       Jerk                  -         sma        (        )        
    ## 361       Jerk                  -      energy        (        )       -
    ## 362       Jerk                  -      energy        (        )       -
    ## 363       Jerk                  -      energy        (        )       -
    ## 364       Jerk                  -         iqr        (        )       -
    ## 365       Jerk                  -         iqr        (        )       -
    ## 366       Jerk                  -         iqr        (        )       -
    ## 367       Jerk                  -     entropy        (        )       -
    ## 368       Jerk                  -     entropy        (        )       -
    ## 369       Jerk                  -     entropy        (        )       -
    ## 370       Jerk                  -     maxInds        (        )       -
    ## 371       Jerk                  -     maxInds        (        )       -
    ## 372       Jerk                  -     maxInds        (        )       -
    ## 373       Jerk                  -    meanFreq        (        )       -
    ## 374       Jerk                  -    meanFreq        (        )       -
    ## 375       Jerk                  -    meanFreq        (        )       -
    ## 376       Jerk                  -    skewness        (        )       -
    ## 377       Jerk                  -    kurtosis        (        )       -
    ## 378       Jerk                  -    skewness        (        )       -
    ## 379       Jerk                  -    kurtosis        (        )       -
    ## 380       Jerk                  -    skewness        (        )       -
    ## 381       Jerk                  -    kurtosis        (        )       -
    ## 382       Jerk                  - bandsEnergy        (        )        
    ## 383       Jerk                  - bandsEnergy        (        )        
    ## 384       Jerk                  - bandsEnergy        (        )        
    ## 385       Jerk                  - bandsEnergy        (        )        
    ## 386       Jerk                  - bandsEnergy        (        )        
    ## 387       Jerk                  - bandsEnergy        (        )        
    ## 388       Jerk                  - bandsEnergy        (        )        
    ## 389       Jerk                  - bandsEnergy        (        )        
    ## 390       Jerk                  - bandsEnergy        (        )        
    ## 391       Jerk                  - bandsEnergy        (        )        
    ## 392       Jerk                  - bandsEnergy        (        )        
    ## 393       Jerk                  - bandsEnergy        (        )        
    ## 394       Jerk                  - bandsEnergy        (        )        
    ## 395       Jerk                  - bandsEnergy        (        )        
    ## 396       Jerk                  - bandsEnergy        (        )        
    ## 397       Jerk                  - bandsEnergy        (        )        
    ## 398       Jerk                  - bandsEnergy        (        )        
    ## 399       Jerk                  - bandsEnergy        (        )        
    ## 400       Jerk                  - bandsEnergy        (        )        
    ## 401       Jerk                  - bandsEnergy        (        )        
    ## 402       Jerk                  - bandsEnergy        (        )        
    ## 403       Jerk                  - bandsEnergy        (        )        
    ## 404       Jerk                  - bandsEnergy        (        )        
    ## 405       Jerk                  - bandsEnergy        (        )        
    ## 406       Jerk                  - bandsEnergy        (        )        
    ## 407       Jerk                  - bandsEnergy        (        )        
    ## 408       Jerk                  - bandsEnergy        (        )        
    ## 409       Jerk                  - bandsEnergy        (        )        
    ## 410       Jerk                  - bandsEnergy        (        )        
    ## 411       Jerk                  - bandsEnergy        (        )        
    ## 412       Jerk                  - bandsEnergy        (        )        
    ## 413       Jerk                  - bandsEnergy        (        )        
    ## 414       Jerk                  - bandsEnergy        (        )        
    ## 415       Jerk                  - bandsEnergy        (        )        
    ## 416       Jerk                  - bandsEnergy        (        )        
    ## 417       Jerk                  - bandsEnergy        (        )        
    ## 418       Jerk                  - bandsEnergy        (        )        
    ## 419       Jerk                  - bandsEnergy        (        )        
    ## 420       Jerk                  - bandsEnergy        (        )        
    ## 421       Jerk                  - bandsEnergy        (        )        
    ## 422       Jerk                  - bandsEnergy        (        )        
    ## 423       Jerk                  - bandsEnergy        (        )        
    ## 424                             -        mean        (        )       -
    ## 425                             -        mean        (        )       -
    ## 426                             -        mean        (        )       -
    ## 427                             -         std        (        )       -
    ## 428                             -         std        (        )       -
    ## 429                             -         std        (        )       -
    ## 430                             -         mad        (        )       -
    ## 431                             -         mad        (        )       -
    ## 432                             -         mad        (        )       -
    ## 433                             -         max        (        )       -
    ## 434                             -         max        (        )       -
    ## 435                             -         max        (        )       -
    ## 436                             -         min        (        )       -
    ## 437                             -         min        (        )       -
    ## 438                             -         min        (        )       -
    ## 439                             -         sma        (        )        
    ## 440                             -      energy        (        )       -
    ## 441                             -      energy        (        )       -
    ## 442                             -      energy        (        )       -
    ## 443                             -         iqr        (        )       -
    ## 444                             -         iqr        (        )       -
    ## 445                             -         iqr        (        )       -
    ## 446                             -     entropy        (        )       -
    ## 447                             -     entropy        (        )       -
    ## 448                             -     entropy        (        )       -
    ## 449                             -     maxInds        (        )       -
    ## 450                             -     maxInds        (        )       -
    ## 451                             -     maxInds        (        )       -
    ## 452                             -    meanFreq        (        )       -
    ## 453                             -    meanFreq        (        )       -
    ## 454                             -    meanFreq        (        )       -
    ## 455                             -    skewness        (        )       -
    ## 456                             -    kurtosis        (        )       -
    ## 457                             -    skewness        (        )       -
    ## 458                             -    kurtosis        (        )       -
    ## 459                             -    skewness        (        )       -
    ## 460                             -    kurtosis        (        )       -
    ## 461                             - bandsEnergy        (        )        
    ## 462                             - bandsEnergy        (        )        
    ## 463                             - bandsEnergy        (        )        
    ## 464                             - bandsEnergy        (        )        
    ## 465                             - bandsEnergy        (        )        
    ## 466                             - bandsEnergy        (        )        
    ## 467                             - bandsEnergy        (        )        
    ## 468                             - bandsEnergy        (        )        
    ## 469                             - bandsEnergy        (        )        
    ## 470                             - bandsEnergy        (        )        
    ## 471                             - bandsEnergy        (        )        
    ## 472                             - bandsEnergy        (        )        
    ## 473                             - bandsEnergy        (        )        
    ## 474                             - bandsEnergy        (        )        
    ## 475                             - bandsEnergy        (        )        
    ## 476                             - bandsEnergy        (        )        
    ## 477                             - bandsEnergy        (        )        
    ## 478                             - bandsEnergy        (        )        
    ## 479                             - bandsEnergy        (        )        
    ## 480                             - bandsEnergy        (        )        
    ## 481                             - bandsEnergy        (        )        
    ## 482                             - bandsEnergy        (        )        
    ## 483                             - bandsEnergy        (        )        
    ## 484                             - bandsEnergy        (        )        
    ## 485                             - bandsEnergy        (        )        
    ## 486                             - bandsEnergy        (        )        
    ## 487                             - bandsEnergy        (        )        
    ## 488                             - bandsEnergy        (        )        
    ## 489                             - bandsEnergy        (        )        
    ## 490                             - bandsEnergy        (        )        
    ## 491                             - bandsEnergy        (        )        
    ## 492                             - bandsEnergy        (        )        
    ## 493                             - bandsEnergy        (        )        
    ## 494                             - bandsEnergy        (        )        
    ## 495                             - bandsEnergy        (        )        
    ## 496                             - bandsEnergy        (        )        
    ## 497                             - bandsEnergy        (        )        
    ## 498                             - bandsEnergy        (        )        
    ## 499                             - bandsEnergy        (        )        
    ## 500                             - bandsEnergy        (        )        
    ## 501                             - bandsEnergy        (        )        
    ## 502                             - bandsEnergy        (        )        
    ## 503                  Mag        -        mean        (        )        
    ## 504                  Mag        -         std        (        )        
    ## 505                  Mag        -         mad        (        )        
    ## 506                  Mag        -         max        (        )        
    ## 507                  Mag        -         min        (        )        
    ## 508                  Mag        -         sma        (        )        
    ## 509                  Mag        -      energy        (        )        
    ## 510                  Mag        -         iqr        (        )        
    ## 511                  Mag        -     entropy        (        )        
    ## 512                  Mag        -     maxInds        (        )        
    ## 513                  Mag        -    meanFreq        (        )        
    ## 514                  Mag        -    skewness        (        )        
    ## 515                  Mag        -    kurtosis        (        )        
    ## 516       Jerk       Mag        -        mean        (        )        
    ## 517       Jerk       Mag        -         std        (        )        
    ## 518       Jerk       Mag        -         mad        (        )        
    ## 519       Jerk       Mag        -         max        (        )        
    ## 520       Jerk       Mag        -         min        (        )        
    ## 521       Jerk       Mag        -         sma        (        )        
    ## 522       Jerk       Mag        -      energy        (        )        
    ## 523       Jerk       Mag        -         iqr        (        )        
    ## 524       Jerk       Mag        -     entropy        (        )        
    ## 525       Jerk       Mag        -     maxInds        (        )        
    ## 526       Jerk       Mag        -    meanFreq        (        )        
    ## 527       Jerk       Mag        -    skewness        (        )        
    ## 528       Jerk       Mag        -    kurtosis        (        )        
    ## 529                  Mag        -        mean        (        )        
    ## 530                  Mag        -         std        (        )        
    ## 531                  Mag        -         mad        (        )        
    ## 532                  Mag        -         max        (        )        
    ## 533                  Mag        -         min        (        )        
    ## 534                  Mag        -         sma        (        )        
    ## 535                  Mag        -      energy        (        )        
    ## 536                  Mag        -         iqr        (        )        
    ## 537                  Mag        -     entropy        (        )        
    ## 538                  Mag        -     maxInds        (        )        
    ## 539                  Mag        -    meanFreq        (        )        
    ## 540                  Mag        -    skewness        (        )        
    ## 541                  Mag        -    kurtosis        (        )        
    ## 542       Jerk       Mag        -        mean        (        )        
    ## 543       Jerk       Mag        -         std        (        )        
    ## 544       Jerk       Mag        -         mad        (        )        
    ## 545       Jerk       Mag        -         max        (        )        
    ## 546       Jerk       Mag        -         min        (        )        
    ## 547       Jerk       Mag        -         sma        (        )        
    ## 548       Jerk       Mag        -      energy        (        )        
    ## 549       Jerk       Mag        -         iqr        (        )        
    ## 550       Jerk       Mag        -     entropy        (        )        
    ## 551       Jerk       Mag        -     maxInds        (        )        
    ## 552       Jerk       Mag        -    meanFreq        (        )        
    ## 553       Jerk       Mag        -    skewness        (        )        
    ## 554       Jerk       Mag        -    kurtosis        (        )        
    ## 555                                     angle                          
    ## 556                                     angle                          
    ## 557                                     angle                          
    ## 558                                     angle                          
    ## 559                                     angle                          
    ## 560                                     angle                          
    ## 561                                     angle                          
    ##     axis axesSep axes arCoeffSep arCoeffLevel correlationSep1
    ## 1      X                                                     
    ## 2      Y                                                     
    ## 3      Z                                                     
    ## 4      X                                                     
    ## 5      Y                                                     
    ## 6      Z                                                     
    ## 7      X                                                     
    ## 8      Y                                                     
    ## 9      Z                                                     
    ## 10     X                                                     
    ## 11     Y                                                     
    ## 12     Z                                                     
    ## 13     X                                                     
    ## 14     Y                                                     
    ## 15     Z                                                     
    ## 16             -  XYZ                                        
    ## 17     X                                                     
    ## 18     Y                                                     
    ## 19     Z                                                     
    ## 20     X                                                     
    ## 21     Y                                                     
    ## 22     Z                                                     
    ## 23     X                                                     
    ## 24     Y                                                     
    ## 25     Z                                                     
    ## 26     X                       ,            1                
    ## 27     X                       ,            2                
    ## 28     X                       ,            3                
    ## 29     X                       ,            4                
    ## 30     Y                       ,            1                
    ## 31     Y                       ,            2                
    ## 32     Y                       ,            3                
    ## 33     Y                       ,            4                
    ## 34     Z                       ,            1                
    ## 35     Z                       ,            2                
    ## 36     Z                       ,            3                
    ## 37     Z                       ,            4                
    ## 38             -   XY                                       -
    ## 39             -   XZ                                       -
    ## 40             -   YZ                                       -
    ## 41     X                                                     
    ## 42     Y                                                     
    ## 43     Z                                                     
    ## 44     X                                                     
    ## 45     Y                                                     
    ## 46     Z                                                     
    ## 47     X                                                     
    ## 48     Y                                                     
    ## 49     Z                                                     
    ## 50     X                                                     
    ## 51     Y                                                     
    ## 52     Z                                                     
    ## 53     X                                                     
    ## 54     Y                                                     
    ## 55     Z                                                     
    ## 56             -  XYZ                                        
    ## 57     X                                                     
    ## 58     Y                                                     
    ## 59     Z                                                     
    ## 60     X                                                     
    ## 61     Y                                                     
    ## 62     Z                                                     
    ## 63     X                                                     
    ## 64     Y                                                     
    ## 65     Z                                                     
    ## 66     X                       ,            1                
    ## 67     X                       ,            2                
    ## 68     X                       ,            3                
    ## 69     X                       ,            4                
    ## 70     Y                       ,            1                
    ## 71     Y                       ,            2                
    ## 72     Y                       ,            3                
    ## 73     Y                       ,            4                
    ## 74     Z                       ,            1                
    ## 75     Z                       ,            2                
    ## 76     Z                       ,            3                
    ## 77     Z                       ,            4                
    ## 78             -   XY                                       -
    ## 79             -   XZ                                       -
    ## 80             -   YZ                                       -
    ## 81     X                                                     
    ## 82     Y                                                     
    ## 83     Z                                                     
    ## 84     X                                                     
    ## 85     Y                                                     
    ## 86     Z                                                     
    ## 87     X                                                     
    ## 88     Y                                                     
    ## 89     Z                                                     
    ## 90     X                                                     
    ## 91     Y                                                     
    ## 92     Z                                                     
    ## 93     X                                                     
    ## 94     Y                                                     
    ## 95     Z                                                     
    ## 96             -  XYZ                                        
    ## 97     X                                                     
    ## 98     Y                                                     
    ## 99     Z                                                     
    ## 100    X                                                     
    ## 101    Y                                                     
    ## 102    Z                                                     
    ## 103    X                                                     
    ## 104    Y                                                     
    ## 105    Z                                                     
    ## 106    X                       ,            1                
    ## 107    X                       ,            2                
    ## 108    X                       ,            3                
    ## 109    X                       ,            4                
    ## 110    Y                       ,            1                
    ## 111    Y                       ,            2                
    ## 112    Y                       ,            3                
    ## 113    Y                       ,            4                
    ## 114    Z                       ,            1                
    ## 115    Z                       ,            2                
    ## 116    Z                       ,            3                
    ## 117    Z                       ,            4                
    ## 118            -   XY                                       -
    ## 119            -   XZ                                       -
    ## 120            -   YZ                                       -
    ## 121    X                                                     
    ## 122    Y                                                     
    ## 123    Z                                                     
    ## 124    X                                                     
    ## 125    Y                                                     
    ## 126    Z                                                     
    ## 127    X                                                     
    ## 128    Y                                                     
    ## 129    Z                                                     
    ## 130    X                                                     
    ## 131    Y                                                     
    ## 132    Z                                                     
    ## 133    X                                                     
    ## 134    Y                                                     
    ## 135    Z                                                     
    ## 136            -  XYZ                                        
    ## 137    X                                                     
    ## 138    Y                                                     
    ## 139    Z                                                     
    ## 140    X                                                     
    ## 141    Y                                                     
    ## 142    Z                                                     
    ## 143    X                                                     
    ## 144    Y                                                     
    ## 145    Z                                                     
    ## 146    X                       ,            1                
    ## 147    X                       ,            2                
    ## 148    X                       ,            3                
    ## 149    X                       ,            4                
    ## 150    Y                       ,            1                
    ## 151    Y                       ,            2                
    ## 152    Y                       ,            3                
    ## 153    Y                       ,            4                
    ## 154    Z                       ,            1                
    ## 155    Z                       ,            2                
    ## 156    Z                       ,            3                
    ## 157    Z                       ,            4                
    ## 158            -   XY                                       -
    ## 159            -   XZ                                       -
    ## 160            -   YZ                                       -
    ## 161    X                                                     
    ## 162    Y                                                     
    ## 163    Z                                                     
    ## 164    X                                                     
    ## 165    Y                                                     
    ## 166    Z                                                     
    ## 167    X                                                     
    ## 168    Y                                                     
    ## 169    Z                                                     
    ## 170    X                                                     
    ## 171    Y                                                     
    ## 172    Z                                                     
    ## 173    X                                                     
    ## 174    Y                                                     
    ## 175    Z                                                     
    ## 176            -  XYZ                                        
    ## 177    X                                                     
    ## 178    Y                                                     
    ## 179    Z                                                     
    ## 180    X                                                     
    ## 181    Y                                                     
    ## 182    Z                                                     
    ## 183    X                                                     
    ## 184    Y                                                     
    ## 185    Z                                                     
    ## 186    X                       ,            1                
    ## 187    X                       ,            2                
    ## 188    X                       ,            3                
    ## 189    X                       ,            4                
    ## 190    Y                       ,            1                
    ## 191    Y                       ,            2                
    ## 192    Y                       ,            3                
    ## 193    Y                       ,            4                
    ## 194    Z                       ,            1                
    ## 195    Z                       ,            2                
    ## 196    Z                       ,            3                
    ## 197    Z                       ,            4                
    ## 198            -   XY                                       -
    ## 199            -   XZ                                       -
    ## 200            -   YZ                                       -
    ## 201                                                          
    ## 202                                                          
    ## 203                                                          
    ## 204                                                          
    ## 205                                                          
    ## 206                                                          
    ## 207                                                          
    ## 208                                                          
    ## 209                                                          
    ## 210                                         1                
    ## 211                                         2                
    ## 212                                         3                
    ## 213                                         4                
    ## 214                                                          
    ## 215                                                          
    ## 216                                                          
    ## 217                                                          
    ## 218                                                          
    ## 219                                                          
    ## 220                                                          
    ## 221                                                          
    ## 222                                                          
    ## 223                                         1                
    ## 224                                         2                
    ## 225                                         3                
    ## 226                                         4                
    ## 227                                                          
    ## 228                                                          
    ## 229                                                          
    ## 230                                                          
    ## 231                                                          
    ## 232                                                          
    ## 233                                                          
    ## 234                                                          
    ## 235                                                          
    ## 236                                         1                
    ## 237                                         2                
    ## 238                                         3                
    ## 239                                         4                
    ## 240                                                          
    ## 241                                                          
    ## 242                                                          
    ## 243                                                          
    ## 244                                                          
    ## 245                                                          
    ## 246                                                          
    ## 247                                                          
    ## 248                                                          
    ## 249                                         1                
    ## 250                                         2                
    ## 251                                         3                
    ## 252                                         4                
    ## 253                                                          
    ## 254                                                          
    ## 255                                                          
    ## 256                                                          
    ## 257                                                          
    ## 258                                                          
    ## 259                                                          
    ## 260                                                          
    ## 261                                                          
    ## 262                                         1                
    ## 263                                         2                
    ## 264                                         3                
    ## 265                                         4                
    ## 266    X                                                     
    ## 267    Y                                                     
    ## 268    Z                                                     
    ## 269    X                                                     
    ## 270    Y                                                     
    ## 271    Z                                                     
    ## 272    X                                                     
    ## 273    Y                                                     
    ## 274    Z                                                     
    ## 275    X                                                     
    ## 276    Y                                                     
    ## 277    Z                                                     
    ## 278    X                                                     
    ## 279    Y                                                     
    ## 280    Z                                                     
    ## 281            -  XYZ                                        
    ## 282    X                                                     
    ## 283    Y                                                     
    ## 284    Z                                                     
    ## 285    X                                                     
    ## 286    Y                                                     
    ## 287    Z                                                     
    ## 288    X                                                     
    ## 289    Y                                                     
    ## 290    Z                                                     
    ## 291    X                                                     
    ## 292    Y                                                     
    ## 293    Z                                                     
    ## 294    X                                                     
    ## 295    Y                                                     
    ## 296    Z                                                     
    ## 297    X                                                     
    ## 298    X                                                     
    ## 299    Y                                                     
    ## 300    Y                                                     
    ## 301    Z                                                     
    ## 302    Z                                                     
    ## 303            -  XYZ                                        
    ## 304            -  XYZ                                        
    ## 305            -  XYZ                                        
    ## 306            -  XYZ                                        
    ## 307            -  XYZ                                        
    ## 308            -  XYZ                                        
    ## 309            -  XYZ                                        
    ## 310            -  XYZ                                        
    ## 311            -  XYZ                                        
    ## 312            -  XYZ                                        
    ## 313            -  XYZ                                        
    ## 314            -  XYZ                                        
    ## 315            -  XYZ                                        
    ## 316            -  XYZ                                        
    ## 317            -  XYZ                                        
    ## 318            -  XYZ                                        
    ## 319            -  XYZ                                        
    ## 320            -  XYZ                                        
    ## 321            -  XYZ                                        
    ## 322            -  XYZ                                        
    ## 323            -  XYZ                                        
    ## 324            -  XYZ                                        
    ## 325            -  XYZ                                        
    ## 326            -  XYZ                                        
    ## 327            -  XYZ                                        
    ## 328            -  XYZ                                        
    ## 329            -  XYZ                                        
    ## 330            -  XYZ                                        
    ## 331            -  XYZ                                        
    ## 332            -  XYZ                                        
    ## 333            -  XYZ                                        
    ## 334            -  XYZ                                        
    ## 335            -  XYZ                                        
    ## 336            -  XYZ                                        
    ## 337            -  XYZ                                        
    ## 338            -  XYZ                                        
    ## 339            -  XYZ                                        
    ## 340            -  XYZ                                        
    ## 341            -  XYZ                                        
    ## 342            -  XYZ                                        
    ## 343            -  XYZ                                        
    ## 344            -  XYZ                                        
    ## 345    X                                                     
    ## 346    Y                                                     
    ## 347    Z                                                     
    ## 348    X                                                     
    ## 349    Y                                                     
    ## 350    Z                                                     
    ## 351    X                                                     
    ## 352    Y                                                     
    ## 353    Z                                                     
    ## 354    X                                                     
    ## 355    Y                                                     
    ## 356    Z                                                     
    ## 357    X                                                     
    ## 358    Y                                                     
    ## 359    Z                                                     
    ## 360            -  XYZ                                        
    ## 361    X                                                     
    ## 362    Y                                                     
    ## 363    Z                                                     
    ## 364    X                                                     
    ## 365    Y                                                     
    ## 366    Z                                                     
    ## 367    X                                                     
    ## 368    Y                                                     
    ## 369    Z                                                     
    ## 370    X                                                     
    ## 371    Y                                                     
    ## 372    Z                                                     
    ## 373    X                                                     
    ## 374    Y                                                     
    ## 375    Z                                                     
    ## 376    X                                                     
    ## 377    X                                                     
    ## 378    Y                                                     
    ## 379    Y                                                     
    ## 380    Z                                                     
    ## 381    Z                                                     
    ## 382            -  XYZ                                        
    ## 383            -  XYZ                                        
    ## 384            -  XYZ                                        
    ## 385            -  XYZ                                        
    ## 386            -  XYZ                                        
    ## 387            -  XYZ                                        
    ## 388            -  XYZ                                        
    ## 389            -  XYZ                                        
    ## 390            -  XYZ                                        
    ## 391            -  XYZ                                        
    ## 392            -  XYZ                                        
    ## 393            -  XYZ                                        
    ## 394            -  XYZ                                        
    ## 395            -  XYZ                                        
    ## 396            -  XYZ                                        
    ## 397            -  XYZ                                        
    ## 398            -  XYZ                                        
    ## 399            -  XYZ                                        
    ## 400            -  XYZ                                        
    ## 401            -  XYZ                                        
    ## 402            -  XYZ                                        
    ## 403            -  XYZ                                        
    ## 404            -  XYZ                                        
    ## 405            -  XYZ                                        
    ## 406            -  XYZ                                        
    ## 407            -  XYZ                                        
    ## 408            -  XYZ                                        
    ## 409            -  XYZ                                        
    ## 410            -  XYZ                                        
    ## 411            -  XYZ                                        
    ## 412            -  XYZ                                        
    ## 413            -  XYZ                                        
    ## 414            -  XYZ                                        
    ## 415            -  XYZ                                        
    ## 416            -  XYZ                                        
    ## 417            -  XYZ                                        
    ## 418            -  XYZ                                        
    ## 419            -  XYZ                                        
    ## 420            -  XYZ                                        
    ## 421            -  XYZ                                        
    ## 422            -  XYZ                                        
    ## 423            -  XYZ                                        
    ## 424    X                                                     
    ## 425    Y                                                     
    ## 426    Z                                                     
    ## 427    X                                                     
    ## 428    Y                                                     
    ## 429    Z                                                     
    ## 430    X                                                     
    ## 431    Y                                                     
    ## 432    Z                                                     
    ## 433    X                                                     
    ## 434    Y                                                     
    ## 435    Z                                                     
    ## 436    X                                                     
    ## 437    Y                                                     
    ## 438    Z                                                     
    ## 439            -  XYZ                                        
    ## 440    X                                                     
    ## 441    Y                                                     
    ## 442    Z                                                     
    ## 443    X                                                     
    ## 444    Y                                                     
    ## 445    Z                                                     
    ## 446    X                                                     
    ## 447    Y                                                     
    ## 448    Z                                                     
    ## 449    X                                                     
    ## 450    Y                                                     
    ## 451    Z                                                     
    ## 452    X                                                     
    ## 453    Y                                                     
    ## 454    Z                                                     
    ## 455    X                                                     
    ## 456    X                                                     
    ## 457    Y                                                     
    ## 458    Y                                                     
    ## 459    Z                                                     
    ## 460    Z                                                     
    ## 461            -  XYZ                                        
    ## 462            -  XYZ                                        
    ## 463            -  XYZ                                        
    ## 464            -  XYZ                                        
    ## 465            -  XYZ                                        
    ## 466            -  XYZ                                        
    ## 467            -  XYZ                                        
    ## 468            -  XYZ                                        
    ## 469            -  XYZ                                        
    ## 470            -  XYZ                                        
    ## 471            -  XYZ                                        
    ## 472            -  XYZ                                        
    ## 473            -  XYZ                                        
    ## 474            -  XYZ                                        
    ## 475            -  XYZ                                        
    ## 476            -  XYZ                                        
    ## 477            -  XYZ                                        
    ## 478            -  XYZ                                        
    ## 479            -  XYZ                                        
    ## 480            -  XYZ                                        
    ## 481            -  XYZ                                        
    ## 482            -  XYZ                                        
    ## 483            -  XYZ                                        
    ## 484            -  XYZ                                        
    ## 485            -  XYZ                                        
    ## 486            -  XYZ                                        
    ## 487            -  XYZ                                        
    ## 488            -  XYZ                                        
    ## 489            -  XYZ                                        
    ## 490            -  XYZ                                        
    ## 491            -  XYZ                                        
    ## 492            -  XYZ                                        
    ## 493            -  XYZ                                        
    ## 494            -  XYZ                                        
    ## 495            -  XYZ                                        
    ## 496            -  XYZ                                        
    ## 497            -  XYZ                                        
    ## 498            -  XYZ                                        
    ## 499            -  XYZ                                        
    ## 500            -  XYZ                                        
    ## 501            -  XYZ                                        
    ## 502            -  XYZ                                        
    ## 503                                                          
    ## 504                                                          
    ## 505                                                          
    ## 506                                                          
    ## 507                                                          
    ## 508                                                          
    ## 509                                                          
    ## 510                                                          
    ## 511                                                          
    ## 512                                                          
    ## 513                                                          
    ## 514                                                          
    ## 515                                                          
    ## 516                                                          
    ## 517                                                          
    ## 518                                                          
    ## 519                                                          
    ## 520                                                          
    ## 521                                                          
    ## 522                                                          
    ## 523                                                          
    ## 524                                                          
    ## 525                                                          
    ## 526                                                          
    ## 527                                                          
    ## 528                                                          
    ## 529                                                          
    ## 530                                                          
    ## 531                                                          
    ## 532                                                          
    ## 533                                                          
    ## 534                                                          
    ## 535                                                          
    ## 536                                                          
    ## 537                                                          
    ## 538                                                          
    ## 539                                                          
    ## 540                                                          
    ## 541                                                          
    ## 542                                                          
    ## 543                                                          
    ## 544                                                          
    ## 545                                                          
    ## 546                                                          
    ## 547                                                          
    ## 548                                                          
    ## 549                                                          
    ## 550                                                          
    ## 551                                                          
    ## 552                                                          
    ## 553                                                          
    ## 554                                                          
    ## 555                                                          
    ## 556                                                          
    ## 557                                                          
    ## 558                                                          
    ## 559                                                          
    ## 560                                                          
    ## 561                                                          
    ##     correlationAxis1 correlationSep2 correlationAxis2 bandsEnergySep1
    ## 1                                                                    
    ## 2                                                                    
    ## 3                                                                    
    ## 4                                                                    
    ## 5                                                                    
    ## 6                                                                    
    ## 7                                                                    
    ## 8                                                                    
    ## 9                                                                    
    ## 10                                                                   
    ## 11                                                                   
    ## 12                                                                   
    ## 13                                                                   
    ## 14                                                                   
    ## 15                                                                   
    ## 16                                                                   
    ## 17                                                                   
    ## 18                                                                   
    ## 19                                                                   
    ## 20                                                                   
    ## 21                                                                   
    ## 22                                                                   
    ## 23                                                                   
    ## 24                                                                   
    ## 25                                                                   
    ## 26                                                                   
    ## 27                                                                   
    ## 28                                                                   
    ## 29                                                                   
    ## 30                                                                   
    ## 31                                                                   
    ## 32                                                                   
    ## 33                                                                   
    ## 34                                                                   
    ## 35                                                                   
    ## 36                                                                   
    ## 37                                                                   
    ## 38                 X               ,                Y                
    ## 39                 X               ,                Z                
    ## 40                 Y               ,                Z                
    ## 41                                                                   
    ## 42                                                                   
    ## 43                                                                   
    ## 44                                                                   
    ## 45                                                                   
    ## 46                                                                   
    ## 47                                                                   
    ## 48                                                                   
    ## 49                                                                   
    ## 50                                                                   
    ## 51                                                                   
    ## 52                                                                   
    ## 53                                                                   
    ## 54                                                                   
    ## 55                                                                   
    ## 56                                                                   
    ## 57                                                                   
    ## 58                                                                   
    ## 59                                                                   
    ## 60                                                                   
    ## 61                                                                   
    ## 62                                                                   
    ## 63                                                                   
    ## 64                                                                   
    ## 65                                                                   
    ## 66                                                                   
    ## 67                                                                   
    ## 68                                                                   
    ## 69                                                                   
    ## 70                                                                   
    ## 71                                                                   
    ## 72                                                                   
    ## 73                                                                   
    ## 74                                                                   
    ## 75                                                                   
    ## 76                                                                   
    ## 77                                                                   
    ## 78                 X               ,                Y                
    ## 79                 X               ,                Z                
    ## 80                 Y               ,                Z                
    ## 81                                                                   
    ## 82                                                                   
    ## 83                                                                   
    ## 84                                                                   
    ## 85                                                                   
    ## 86                                                                   
    ## 87                                                                   
    ## 88                                                                   
    ## 89                                                                   
    ## 90                                                                   
    ## 91                                                                   
    ## 92                                                                   
    ## 93                                                                   
    ## 94                                                                   
    ## 95                                                                   
    ## 96                                                                   
    ## 97                                                                   
    ## 98                                                                   
    ## 99                                                                   
    ## 100                                                                  
    ## 101                                                                  
    ## 102                                                                  
    ## 103                                                                  
    ## 104                                                                  
    ## 105                                                                  
    ## 106                                                                  
    ## 107                                                                  
    ## 108                                                                  
    ## 109                                                                  
    ## 110                                                                  
    ## 111                                                                  
    ## 112                                                                  
    ## 113                                                                  
    ## 114                                                                  
    ## 115                                                                  
    ## 116                                                                  
    ## 117                                                                  
    ## 118                X               ,                Y                
    ## 119                X               ,                Z                
    ## 120                Y               ,                Z                
    ## 121                                                                  
    ## 122                                                                  
    ## 123                                                                  
    ## 124                                                                  
    ## 125                                                                  
    ## 126                                                                  
    ## 127                                                                  
    ## 128                                                                  
    ## 129                                                                  
    ## 130                                                                  
    ## 131                                                                  
    ## 132                                                                  
    ## 133                                                                  
    ## 134                                                                  
    ## 135                                                                  
    ## 136                                                                  
    ## 137                                                                  
    ## 138                                                                  
    ## 139                                                                  
    ## 140                                                                  
    ## 141                                                                  
    ## 142                                                                  
    ## 143                                                                  
    ## 144                                                                  
    ## 145                                                                  
    ## 146                                                                  
    ## 147                                                                  
    ## 148                                                                  
    ## 149                                                                  
    ## 150                                                                  
    ## 151                                                                  
    ## 152                                                                  
    ## 153                                                                  
    ## 154                                                                  
    ## 155                                                                  
    ## 156                                                                  
    ## 157                                                                  
    ## 158                X               ,                Y                
    ## 159                X               ,                Z                
    ## 160                Y               ,                Z                
    ## 161                                                                  
    ## 162                                                                  
    ## 163                                                                  
    ## 164                                                                  
    ## 165                                                                  
    ## 166                                                                  
    ## 167                                                                  
    ## 168                                                                  
    ## 169                                                                  
    ## 170                                                                  
    ## 171                                                                  
    ## 172                                                                  
    ## 173                                                                  
    ## 174                                                                  
    ## 175                                                                  
    ## 176                                                                  
    ## 177                                                                  
    ## 178                                                                  
    ## 179                                                                  
    ## 180                                                                  
    ## 181                                                                  
    ## 182                                                                  
    ## 183                                                                  
    ## 184                                                                  
    ## 185                                                                  
    ## 186                                                                  
    ## 187                                                                  
    ## 188                                                                  
    ## 189                                                                  
    ## 190                                                                  
    ## 191                                                                  
    ## 192                                                                  
    ## 193                                                                  
    ## 194                                                                  
    ## 195                                                                  
    ## 196                                                                  
    ## 197                                                                  
    ## 198                X               ,                Y                
    ## 199                X               ,                Z                
    ## 200                Y               ,                Z                
    ## 201                                                                  
    ## 202                                                                  
    ## 203                                                                  
    ## 204                                                                  
    ## 205                                                                  
    ## 206                                                                  
    ## 207                                                                  
    ## 208                                                                  
    ## 209                                                                  
    ## 210                                                                  
    ## 211                                                                  
    ## 212                                                                  
    ## 213                                                                  
    ## 214                                                                  
    ## 215                                                                  
    ## 216                                                                  
    ## 217                                                                  
    ## 218                                                                  
    ## 219                                                                  
    ## 220                                                                  
    ## 221                                                                  
    ## 222                                                                  
    ## 223                                                                  
    ## 224                                                                  
    ## 225                                                                  
    ## 226                                                                  
    ## 227                                                                  
    ## 228                                                                  
    ## 229                                                                  
    ## 230                                                                  
    ## 231                                                                  
    ## 232                                                                  
    ## 233                                                                  
    ## 234                                                                  
    ## 235                                                                  
    ## 236                                                                  
    ## 237                                                                  
    ## 238                                                                  
    ## 239                                                                  
    ## 240                                                                  
    ## 241                                                                  
    ## 242                                                                  
    ## 243                                                                  
    ## 244                                                                  
    ## 245                                                                  
    ## 246                                                                  
    ## 247                                                                  
    ## 248                                                                  
    ## 249                                                                  
    ## 250                                                                  
    ## 251                                                                  
    ## 252                                                                  
    ## 253                                                                  
    ## 254                                                                  
    ## 255                                                                  
    ## 256                                                                  
    ## 257                                                                  
    ## 258                                                                  
    ## 259                                                                  
    ## 260                                                                  
    ## 261                                                                  
    ## 262                                                                  
    ## 263                                                                  
    ## 264                                                                  
    ## 265                                                                  
    ## 266                                                                  
    ## 267                                                                  
    ## 268                                                                  
    ## 269                                                                  
    ## 270                                                                  
    ## 271                                                                  
    ## 272                                                                  
    ## 273                                                                  
    ## 274                                                                  
    ## 275                                                                  
    ## 276                                                                  
    ## 277                                                                  
    ## 278                                                                  
    ## 279                                                                  
    ## 280                                                                  
    ## 281                                                                  
    ## 282                                                                  
    ## 283                                                                  
    ## 284                                                                  
    ## 285                                                                  
    ## 286                                                                  
    ## 287                                                                  
    ## 288                                                                  
    ## 289                                                                  
    ## 290                                                                  
    ## 291                                                                  
    ## 292                                                                  
    ## 293                                                                  
    ## 294                                                                  
    ## 295                                                                  
    ## 296                                                                  
    ## 297                                                                  
    ## 298                                                                  
    ## 299                                                                  
    ## 300                                                                  
    ## 301                                                                  
    ## 302                                                                  
    ## 303                                                                 -
    ## 304                                                                 -
    ## 305                                                                 -
    ## 306                                                                 -
    ## 307                                                                 -
    ## 308                                                                 -
    ## 309                                                                 -
    ## 310                                                                 -
    ## 311                                                                 -
    ## 312                                                                 -
    ## 313                                                                 -
    ## 314                                                                 -
    ## 315                                                                 -
    ## 316                                                                 -
    ## 317                                                                 -
    ## 318                                                                 -
    ## 319                                                                 -
    ## 320                                                                 -
    ## 321                                                                 -
    ## 322                                                                 -
    ## 323                                                                 -
    ## 324                                                                 -
    ## 325                                                                 -
    ## 326                                                                 -
    ## 327                                                                 -
    ## 328                                                                 -
    ## 329                                                                 -
    ## 330                                                                 -
    ## 331                                                                 -
    ## 332                                                                 -
    ## 333                                                                 -
    ## 334                                                                 -
    ## 335                                                                 -
    ## 336                                                                 -
    ## 337                                                                 -
    ## 338                                                                 -
    ## 339                                                                 -
    ## 340                                                                 -
    ## 341                                                                 -
    ## 342                                                                 -
    ## 343                                                                 -
    ## 344                                                                 -
    ## 345                                                                  
    ## 346                                                                  
    ## 347                                                                  
    ## 348                                                                  
    ## 349                                                                  
    ## 350                                                                  
    ## 351                                                                  
    ## 352                                                                  
    ## 353                                                                  
    ## 354                                                                  
    ## 355                                                                  
    ## 356                                                                  
    ## 357                                                                  
    ## 358                                                                  
    ## 359                                                                  
    ## 360                                                                  
    ## 361                                                                  
    ## 362                                                                  
    ## 363                                                                  
    ## 364                                                                  
    ## 365                                                                  
    ## 366                                                                  
    ## 367                                                                  
    ## 368                                                                  
    ## 369                                                                  
    ## 370                                                                  
    ## 371                                                                  
    ## 372                                                                  
    ## 373                                                                  
    ## 374                                                                  
    ## 375                                                                  
    ## 376                                                                  
    ## 377                                                                  
    ## 378                                                                  
    ## 379                                                                  
    ## 380                                                                  
    ## 381                                                                  
    ## 382                                                                 -
    ## 383                                                                 -
    ## 384                                                                 -
    ## 385                                                                 -
    ## 386                                                                 -
    ## 387                                                                 -
    ## 388                                                                 -
    ## 389                                                                 -
    ## 390                                                                 -
    ## 391                                                                 -
    ## 392                                                                 -
    ## 393                                                                 -
    ## 394                                                                 -
    ## 395                                                                 -
    ## 396                                                                 -
    ## 397                                                                 -
    ## 398                                                                 -
    ## 399                                                                 -
    ## 400                                                                 -
    ## 401                                                                 -
    ## 402                                                                 -
    ## 403                                                                 -
    ## 404                                                                 -
    ## 405                                                                 -
    ## 406                                                                 -
    ## 407                                                                 -
    ## 408                                                                 -
    ## 409                                                                 -
    ## 410                                                                 -
    ## 411                                                                 -
    ## 412                                                                 -
    ## 413                                                                 -
    ## 414                                                                 -
    ## 415                                                                 -
    ## 416                                                                 -
    ## 417                                                                 -
    ## 418                                                                 -
    ## 419                                                                 -
    ## 420                                                                 -
    ## 421                                                                 -
    ## 422                                                                 -
    ## 423                                                                 -
    ## 424                                                                  
    ## 425                                                                  
    ## 426                                                                  
    ## 427                                                                  
    ## 428                                                                  
    ## 429                                                                  
    ## 430                                                                  
    ## 431                                                                  
    ## 432                                                                  
    ## 433                                                                  
    ## 434                                                                  
    ## 435                                                                  
    ## 436                                                                  
    ## 437                                                                  
    ## 438                                                                  
    ## 439                                                                  
    ## 440                                                                  
    ## 441                                                                  
    ## 442                                                                  
    ## 443                                                                  
    ## 444                                                                  
    ## 445                                                                  
    ## 446                                                                  
    ## 447                                                                  
    ## 448                                                                  
    ## 449                                                                  
    ## 450                                                                  
    ## 451                                                                  
    ## 452                                                                  
    ## 453                                                                  
    ## 454                                                                  
    ## 455                                                                  
    ## 456                                                                  
    ## 457                                                                  
    ## 458                                                                  
    ## 459                                                                  
    ## 460                                                                  
    ## 461                                                                 -
    ## 462                                                                 -
    ## 463                                                                 -
    ## 464                                                                 -
    ## 465                                                                 -
    ## 466                                                                 -
    ## 467                                                                 -
    ## 468                                                                 -
    ## 469                                                                 -
    ## 470                                                                 -
    ## 471                                                                 -
    ## 472                                                                 -
    ## 473                                                                 -
    ## 474                                                                 -
    ## 475                                                                 -
    ## 476                                                                 -
    ## 477                                                                 -
    ## 478                                                                 -
    ## 479                                                                 -
    ## 480                                                                 -
    ## 481                                                                 -
    ## 482                                                                 -
    ## 483                                                                 -
    ## 484                                                                 -
    ## 485                                                                 -
    ## 486                                                                 -
    ## 487                                                                 -
    ## 488                                                                 -
    ## 489                                                                 -
    ## 490                                                                 -
    ## 491                                                                 -
    ## 492                                                                 -
    ## 493                                                                 -
    ## 494                                                                 -
    ## 495                                                                 -
    ## 496                                                                 -
    ## 497                                                                 -
    ## 498                                                                 -
    ## 499                                                                 -
    ## 500                                                                 -
    ## 501                                                                 -
    ## 502                                                                 -
    ## 503                                                                  
    ## 504                                                                  
    ## 505                                                                  
    ## 506                                                                  
    ## 507                                                                  
    ## 508                                                                  
    ## 509                                                                  
    ## 510                                                                  
    ## 511                                                                  
    ## 512                                                                  
    ## 513                                                                  
    ## 514                                                                  
    ## 515                                                                  
    ## 516                                                                  
    ## 517                                                                  
    ## 518                                                                  
    ## 519                                                                  
    ## 520                                                                  
    ## 521                                                                  
    ## 522                                                                  
    ## 523                                                                  
    ## 524                                                                  
    ## 525                                                                  
    ## 526                                                                  
    ## 527                                                                  
    ## 528                                                                  
    ## 529                                                                  
    ## 530                                                                  
    ## 531                                                                  
    ## 532                                                                  
    ## 533                                                                  
    ## 534                                                                  
    ## 535                                                                  
    ## 536                                                                  
    ## 537                                                                  
    ## 538                                                                  
    ## 539                                                                  
    ## 540                                                                  
    ## 541                                                                  
    ## 542                                                                  
    ## 543                                                                  
    ## 544                                                                  
    ## 545                                                                  
    ## 546                                                                  
    ## 547                                                                  
    ## 548                                                                  
    ## 549                                                                  
    ## 550                                                                  
    ## 551                                                                  
    ## 552                                                                  
    ## 553                                                                  
    ## 554                                                                  
    ## 555                                                                  
    ## 556                                                                  
    ## 557                                                                  
    ## 558                                                                  
    ## 559                                                                  
    ## 560                                                                  
    ## 561                                                                  
    ##     bandsEnergyLower bandsEnergySep2 bandsEnergyUpper angleSep1
    ## 1                                                              
    ## 2                                                              
    ## 3                                                              
    ## 4                                                              
    ## 5                                                              
    ## 6                                                              
    ## 7                                                              
    ## 8                                                              
    ## 9                                                              
    ## 10                                                             
    ## 11                                                             
    ## 12                                                             
    ## 13                                                             
    ## 14                                                             
    ## 15                                                             
    ## 16                                                             
    ## 17                                                             
    ## 18                                                             
    ## 19                                                             
    ## 20                                                             
    ## 21                                                             
    ## 22                                                             
    ## 23                                                             
    ## 24                                                             
    ## 25                                                             
    ## 26                                                             
    ## 27                                                             
    ## 28                                                             
    ## 29                                                             
    ## 30                                                             
    ## 31                                                             
    ## 32                                                             
    ## 33                                                             
    ## 34                                                             
    ## 35                                                             
    ## 36                                                             
    ## 37                                                             
    ## 38                                                             
    ## 39                                                             
    ## 40                                                             
    ## 41                                                             
    ## 42                                                             
    ## 43                                                             
    ## 44                                                             
    ## 45                                                             
    ## 46                                                             
    ## 47                                                             
    ## 48                                                             
    ## 49                                                             
    ## 50                                                             
    ## 51                                                             
    ## 52                                                             
    ## 53                                                             
    ## 54                                                             
    ## 55                                                             
    ## 56                                                             
    ## 57                                                             
    ## 58                                                             
    ## 59                                                             
    ## 60                                                             
    ## 61                                                             
    ## 62                                                             
    ## 63                                                             
    ## 64                                                             
    ## 65                                                             
    ## 66                                                             
    ## 67                                                             
    ## 68                                                             
    ## 69                                                             
    ## 70                                                             
    ## 71                                                             
    ## 72                                                             
    ## 73                                                             
    ## 74                                                             
    ## 75                                                             
    ## 76                                                             
    ## 77                                                             
    ## 78                                                             
    ## 79                                                             
    ## 80                                                             
    ## 81                                                             
    ## 82                                                             
    ## 83                                                             
    ## 84                                                             
    ## 85                                                             
    ## 86                                                             
    ## 87                                                             
    ## 88                                                             
    ## 89                                                             
    ## 90                                                             
    ## 91                                                             
    ## 92                                                             
    ## 93                                                             
    ## 94                                                             
    ## 95                                                             
    ## 96                                                             
    ## 97                                                             
    ## 98                                                             
    ## 99                                                             
    ## 100                                                            
    ## 101                                                            
    ## 102                                                            
    ## 103                                                            
    ## 104                                                            
    ## 105                                                            
    ## 106                                                            
    ## 107                                                            
    ## 108                                                            
    ## 109                                                            
    ## 110                                                            
    ## 111                                                            
    ## 112                                                            
    ## 113                                                            
    ## 114                                                            
    ## 115                                                            
    ## 116                                                            
    ## 117                                                            
    ## 118                                                            
    ## 119                                                            
    ## 120                                                            
    ## 121                                                            
    ## 122                                                            
    ## 123                                                            
    ## 124                                                            
    ## 125                                                            
    ## 126                                                            
    ## 127                                                            
    ## 128                                                            
    ## 129                                                            
    ## 130                                                            
    ## 131                                                            
    ## 132                                                            
    ## 133                                                            
    ## 134                                                            
    ## 135                                                            
    ## 136                                                            
    ## 137                                                            
    ## 138                                                            
    ## 139                                                            
    ## 140                                                            
    ## 141                                                            
    ## 142                                                            
    ## 143                                                            
    ## 144                                                            
    ## 145                                                            
    ## 146                                                            
    ## 147                                                            
    ## 148                                                            
    ## 149                                                            
    ## 150                                                            
    ## 151                                                            
    ## 152                                                            
    ## 153                                                            
    ## 154                                                            
    ## 155                                                            
    ## 156                                                            
    ## 157                                                            
    ## 158                                                            
    ## 159                                                            
    ## 160                                                            
    ## 161                                                            
    ## 162                                                            
    ## 163                                                            
    ## 164                                                            
    ## 165                                                            
    ## 166                                                            
    ## 167                                                            
    ## 168                                                            
    ## 169                                                            
    ## 170                                                            
    ## 171                                                            
    ## 172                                                            
    ## 173                                                            
    ## 174                                                            
    ## 175                                                            
    ## 176                                                            
    ## 177                                                            
    ## 178                                                            
    ## 179                                                            
    ## 180                                                            
    ## 181                                                            
    ## 182                                                            
    ## 183                                                            
    ## 184                                                            
    ## 185                                                            
    ## 186                                                            
    ## 187                                                            
    ## 188                                                            
    ## 189                                                            
    ## 190                                                            
    ## 191                                                            
    ## 192                                                            
    ## 193                                                            
    ## 194                                                            
    ## 195                                                            
    ## 196                                                            
    ## 197                                                            
    ## 198                                                            
    ## 199                                                            
    ## 200                                                            
    ## 201                                                            
    ## 202                                                            
    ## 203                                                            
    ## 204                                                            
    ## 205                                                            
    ## 206                                                            
    ## 207                                                            
    ## 208                                                            
    ## 209                                                            
    ## 210                                                            
    ## 211                                                            
    ## 212                                                            
    ## 213                                                            
    ## 214                                                            
    ## 215                                                            
    ## 216                                                            
    ## 217                                                            
    ## 218                                                            
    ## 219                                                            
    ## 220                                                            
    ## 221                                                            
    ## 222                                                            
    ## 223                                                            
    ## 224                                                            
    ## 225                                                            
    ## 226                                                            
    ## 227                                                            
    ## 228                                                            
    ## 229                                                            
    ## 230                                                            
    ## 231                                                            
    ## 232                                                            
    ## 233                                                            
    ## 234                                                            
    ## 235                                                            
    ## 236                                                            
    ## 237                                                            
    ## 238                                                            
    ## 239                                                            
    ## 240                                                            
    ## 241                                                            
    ## 242                                                            
    ## 243                                                            
    ## 244                                                            
    ## 245                                                            
    ## 246                                                            
    ## 247                                                            
    ## 248                                                            
    ## 249                                                            
    ## 250                                                            
    ## 251                                                            
    ## 252                                                            
    ## 253                                                            
    ## 254                                                            
    ## 255                                                            
    ## 256                                                            
    ## 257                                                            
    ## 258                                                            
    ## 259                                                            
    ## 260                                                            
    ## 261                                                            
    ## 262                                                            
    ## 263                                                            
    ## 264                                                            
    ## 265                                                            
    ## 266                                                            
    ## 267                                                            
    ## 268                                                            
    ## 269                                                            
    ## 270                                                            
    ## 271                                                            
    ## 272                                                            
    ## 273                                                            
    ## 274                                                            
    ## 275                                                            
    ## 276                                                            
    ## 277                                                            
    ## 278                                                            
    ## 279                                                            
    ## 280                                                            
    ## 281                                                            
    ## 282                                                            
    ## 283                                                            
    ## 284                                                            
    ## 285                                                            
    ## 286                                                            
    ## 287                                                            
    ## 288                                                            
    ## 289                                                            
    ## 290                                                            
    ## 291                                                            
    ## 292                                                            
    ## 293                                                            
    ## 294                                                            
    ## 295                                                            
    ## 296                                                            
    ## 297                                                            
    ## 298                                                            
    ## 299                                                            
    ## 300                                                            
    ## 301                                                            
    ## 302                                                            
    ## 303                1               ,                8          
    ## 304                9               ,               16          
    ## 305               17               ,               24          
    ## 306               25               ,               32          
    ## 307               33               ,               40          
    ## 308               41               ,               48          
    ## 309               49               ,               56          
    ## 310               57               ,               64          
    ## 311                1               ,               16          
    ## 312               17               ,               32          
    ## 313               33               ,               48          
    ## 314               49               ,               64          
    ## 315                1               ,               24          
    ## 316               25               ,               48          
    ## 317                1               ,                8          
    ## 318                9               ,               16          
    ## 319               17               ,               24          
    ## 320               25               ,               32          
    ## 321               33               ,               40          
    ## 322               41               ,               48          
    ## 323               49               ,               56          
    ## 324               57               ,               64          
    ## 325                1               ,               16          
    ## 326               17               ,               32          
    ## 327               33               ,               48          
    ## 328               49               ,               64          
    ## 329                1               ,               24          
    ## 330               25               ,               48          
    ## 331                1               ,                8          
    ## 332                9               ,               16          
    ## 333               17               ,               24          
    ## 334               25               ,               32          
    ## 335               33               ,               40          
    ## 336               41               ,               48          
    ## 337               49               ,               56          
    ## 338               57               ,               64          
    ## 339                1               ,               16          
    ## 340               17               ,               32          
    ## 341               33               ,               48          
    ## 342               49               ,               64          
    ## 343                1               ,               24          
    ## 344               25               ,               48          
    ## 345                                                            
    ## 346                                                            
    ## 347                                                            
    ## 348                                                            
    ## 349                                                            
    ## 350                                                            
    ## 351                                                            
    ## 352                                                            
    ## 353                                                            
    ## 354                                                            
    ## 355                                                            
    ## 356                                                            
    ## 357                                                            
    ## 358                                                            
    ## 359                                                            
    ## 360                                                            
    ## 361                                                            
    ## 362                                                            
    ## 363                                                            
    ## 364                                                            
    ## 365                                                            
    ## 366                                                            
    ## 367                                                            
    ## 368                                                            
    ## 369                                                            
    ## 370                                                            
    ## 371                                                            
    ## 372                                                            
    ## 373                                                            
    ## 374                                                            
    ## 375                                                            
    ## 376                                                            
    ## 377                                                            
    ## 378                                                            
    ## 379                                                            
    ## 380                                                            
    ## 381                                                            
    ## 382                1               ,                8          
    ## 383                9               ,               16          
    ## 384               17               ,               24          
    ## 385               25               ,               32          
    ## 386               33               ,               40          
    ## 387               41               ,               48          
    ## 388               49               ,               56          
    ## 389               57               ,               64          
    ## 390                1               ,               16          
    ## 391               17               ,               32          
    ## 392               33               ,               48          
    ## 393               49               ,               64          
    ## 394                1               ,               24          
    ## 395               25               ,               48          
    ## 396                1               ,                8          
    ## 397                9               ,               16          
    ## 398               17               ,               24          
    ## 399               25               ,               32          
    ## 400               33               ,               40          
    ## 401               41               ,               48          
    ## 402               49               ,               56          
    ## 403               57               ,               64          
    ## 404                1               ,               16          
    ## 405               17               ,               32          
    ## 406               33               ,               48          
    ## 407               49               ,               64          
    ## 408                1               ,               24          
    ## 409               25               ,               48          
    ## 410                1               ,                8          
    ## 411                9               ,               16          
    ## 412               17               ,               24          
    ## 413               25               ,               32          
    ## 414               33               ,               40          
    ## 415               41               ,               48          
    ## 416               49               ,               56          
    ## 417               57               ,               64          
    ## 418                1               ,               16          
    ## 419               17               ,               32          
    ## 420               33               ,               48          
    ## 421               49               ,               64          
    ## 422                1               ,               24          
    ## 423               25               ,               48          
    ## 424                                                            
    ## 425                                                            
    ## 426                                                            
    ## 427                                                            
    ## 428                                                            
    ## 429                                                            
    ## 430                                                            
    ## 431                                                            
    ## 432                                                            
    ## 433                                                            
    ## 434                                                            
    ## 435                                                            
    ## 436                                                            
    ## 437                                                            
    ## 438                                                            
    ## 439                                                            
    ## 440                                                            
    ## 441                                                            
    ## 442                                                            
    ## 443                                                            
    ## 444                                                            
    ## 445                                                            
    ## 446                                                            
    ## 447                                                            
    ## 448                                                            
    ## 449                                                            
    ## 450                                                            
    ## 451                                                            
    ## 452                                                            
    ## 453                                                            
    ## 454                                                            
    ## 455                                                            
    ## 456                                                            
    ## 457                                                            
    ## 458                                                            
    ## 459                                                            
    ## 460                                                            
    ## 461                1               ,                8          
    ## 462                9               ,               16          
    ## 463               17               ,               24          
    ## 464               25               ,               32          
    ## 465               33               ,               40          
    ## 466               41               ,               48          
    ## 467               49               ,               56          
    ## 468               57               ,               64          
    ## 469                1               ,               16          
    ## 470               17               ,               32          
    ## 471               33               ,               48          
    ## 472               49               ,               64          
    ## 473                1               ,               24          
    ## 474               25               ,               48          
    ## 475                1               ,                8          
    ## 476                9               ,               16          
    ## 477               17               ,               24          
    ## 478               25               ,               32          
    ## 479               33               ,               40          
    ## 480               41               ,               48          
    ## 481               49               ,               56          
    ## 482               57               ,               64          
    ## 483                1               ,               16          
    ## 484               17               ,               32          
    ## 485               33               ,               48          
    ## 486               49               ,               64          
    ## 487                1               ,               24          
    ## 488               25               ,               48          
    ## 489                1               ,                8          
    ## 490                9               ,               16          
    ## 491               17               ,               24          
    ## 492               25               ,               32          
    ## 493               33               ,               40          
    ## 494               41               ,               48          
    ## 495               49               ,               56          
    ## 496               57               ,               64          
    ## 497                1               ,               16          
    ## 498               17               ,               32          
    ## 499               33               ,               48          
    ## 500               49               ,               64          
    ## 501                1               ,               24          
    ## 502               25               ,               48          
    ## 503                                                            
    ## 504                                                            
    ## 505                                                            
    ## 506                                                            
    ## 507                                                            
    ## 508                                                            
    ## 509                                                            
    ## 510                                                            
    ## 511                                                            
    ## 512                                                            
    ## 513                                                            
    ## 514                                                            
    ## 515                                                            
    ## 516                                                            
    ## 517                                                            
    ## 518                                                            
    ## 519                                                            
    ## 520                                                            
    ## 521                                                            
    ## 522                                                            
    ## 523                                                            
    ## 524                                                            
    ## 525                                                            
    ## 526                                                            
    ## 527                                                            
    ## 528                                                            
    ## 529                                                            
    ## 530                                                            
    ## 531                                                            
    ## 532                                                            
    ## 533                                                            
    ## 534                                                            
    ## 535                                                            
    ## 536                                                            
    ## 537                                                            
    ## 538                                                            
    ## 539                                                            
    ## 540                                                            
    ## 541                                                            
    ## 542                                                            
    ## 543                                                            
    ## 544                                                            
    ## 545                                                            
    ## 546                                                            
    ## 547                                                            
    ## 548                                                            
    ## 549                                                            
    ## 550                                                            
    ## 551                                                            
    ## 552                                                            
    ## 553                                                            
    ## 554                                                            
    ## 555                                                           (
    ## 556                                                           (
    ## 557                                                           (
    ## 558                                                           (
    ## 559                                                           (
    ## 560                                                           (
    ## 561                                                           (
    ##             angleArg1 angleSep2   angleArg2 angleSep3
    ## 1                                                    
    ## 2                                                    
    ## 3                                                    
    ## 4                                                    
    ## 5                                                    
    ## 6                                                    
    ## 7                                                    
    ## 8                                                    
    ## 9                                                    
    ## 10                                                   
    ## 11                                                   
    ## 12                                                   
    ## 13                                                   
    ## 14                                                   
    ## 15                                                   
    ## 16                                                   
    ## 17                                                   
    ## 18                                                   
    ## 19                                                   
    ## 20                                                   
    ## 21                                                   
    ## 22                                                   
    ## 23                                                   
    ## 24                                                   
    ## 25                                                   
    ## 26                                                   
    ## 27                                                   
    ## 28                                                   
    ## 29                                                   
    ## 30                                                   
    ## 31                                                   
    ## 32                                                   
    ## 33                                                   
    ## 34                                                   
    ## 35                                                   
    ## 36                                                   
    ## 37                                                   
    ## 38                                                   
    ## 39                                                   
    ## 40                                                   
    ## 41                                                   
    ## 42                                                   
    ## 43                                                   
    ## 44                                                   
    ## 45                                                   
    ## 46                                                   
    ## 47                                                   
    ## 48                                                   
    ## 49                                                   
    ## 50                                                   
    ## 51                                                   
    ## 52                                                   
    ## 53                                                   
    ## 54                                                   
    ## 55                                                   
    ## 56                                                   
    ## 57                                                   
    ## 58                                                   
    ## 59                                                   
    ## 60                                                   
    ## 61                                                   
    ## 62                                                   
    ## 63                                                   
    ## 64                                                   
    ## 65                                                   
    ## 66                                                   
    ## 67                                                   
    ## 68                                                   
    ## 69                                                   
    ## 70                                                   
    ## 71                                                   
    ## 72                                                   
    ## 73                                                   
    ## 74                                                   
    ## 75                                                   
    ## 76                                                   
    ## 77                                                   
    ## 78                                                   
    ## 79                                                   
    ## 80                                                   
    ## 81                                                   
    ## 82                                                   
    ## 83                                                   
    ## 84                                                   
    ## 85                                                   
    ## 86                                                   
    ## 87                                                   
    ## 88                                                   
    ## 89                                                   
    ## 90                                                   
    ## 91                                                   
    ## 92                                                   
    ## 93                                                   
    ## 94                                                   
    ## 95                                                   
    ## 96                                                   
    ## 97                                                   
    ## 98                                                   
    ## 99                                                   
    ## 100                                                  
    ## 101                                                  
    ## 102                                                  
    ## 103                                                  
    ## 104                                                  
    ## 105                                                  
    ## 106                                                  
    ## 107                                                  
    ## 108                                                  
    ## 109                                                  
    ## 110                                                  
    ## 111                                                  
    ## 112                                                  
    ## 113                                                  
    ## 114                                                  
    ## 115                                                  
    ## 116                                                  
    ## 117                                                  
    ## 118                                                  
    ## 119                                                  
    ## 120                                                  
    ## 121                                                  
    ## 122                                                  
    ## 123                                                  
    ## 124                                                  
    ## 125                                                  
    ## 126                                                  
    ## 127                                                  
    ## 128                                                  
    ## 129                                                  
    ## 130                                                  
    ## 131                                                  
    ## 132                                                  
    ## 133                                                  
    ## 134                                                  
    ## 135                                                  
    ## 136                                                  
    ## 137                                                  
    ## 138                                                  
    ## 139                                                  
    ## 140                                                  
    ## 141                                                  
    ## 142                                                  
    ## 143                                                  
    ## 144                                                  
    ## 145                                                  
    ## 146                                                  
    ## 147                                                  
    ## 148                                                  
    ## 149                                                  
    ## 150                                                  
    ## 151                                                  
    ## 152                                                  
    ## 153                                                  
    ## 154                                                  
    ## 155                                                  
    ## 156                                                  
    ## 157                                                  
    ## 158                                                  
    ## 159                                                  
    ## 160                                                  
    ## 161                                                  
    ## 162                                                  
    ## 163                                                  
    ## 164                                                  
    ## 165                                                  
    ## 166                                                  
    ## 167                                                  
    ## 168                                                  
    ## 169                                                  
    ## 170                                                  
    ## 171                                                  
    ## 172                                                  
    ## 173                                                  
    ## 174                                                  
    ## 175                                                  
    ## 176                                                  
    ## 177                                                  
    ## 178                                                  
    ## 179                                                  
    ## 180                                                  
    ## 181                                                  
    ## 182                                                  
    ## 183                                                  
    ## 184                                                  
    ## 185                                                  
    ## 186                                                  
    ## 187                                                  
    ## 188                                                  
    ## 189                                                  
    ## 190                                                  
    ## 191                                                  
    ## 192                                                  
    ## 193                                                  
    ## 194                                                  
    ## 195                                                  
    ## 196                                                  
    ## 197                                                  
    ## 198                                                  
    ## 199                                                  
    ## 200                                                  
    ## 201                                                  
    ## 202                                                  
    ## 203                                                  
    ## 204                                                  
    ## 205                                                  
    ## 206                                                  
    ## 207                                                  
    ## 208                                                  
    ## 209                                                  
    ## 210                                                  
    ## 211                                                  
    ## 212                                                  
    ## 213                                                  
    ## 214                                                  
    ## 215                                                  
    ## 216                                                  
    ## 217                                                  
    ## 218                                                  
    ## 219                                                  
    ## 220                                                  
    ## 221                                                  
    ## 222                                                  
    ## 223                                                  
    ## 224                                                  
    ## 225                                                  
    ## 226                                                  
    ## 227                                                  
    ## 228                                                  
    ## 229                                                  
    ## 230                                                  
    ## 231                                                  
    ## 232                                                  
    ## 233                                                  
    ## 234                                                  
    ## 235                                                  
    ## 236                                                  
    ## 237                                                  
    ## 238                                                  
    ## 239                                                  
    ## 240                                                  
    ## 241                                                  
    ## 242                                                  
    ## 243                                                  
    ## 244                                                  
    ## 245                                                  
    ## 246                                                  
    ## 247                                                  
    ## 248                                                  
    ## 249                                                  
    ## 250                                                  
    ## 251                                                  
    ## 252                                                  
    ## 253                                                  
    ## 254                                                  
    ## 255                                                  
    ## 256                                                  
    ## 257                                                  
    ## 258                                                  
    ## 259                                                  
    ## 260                                                  
    ## 261                                                  
    ## 262                                                  
    ## 263                                                  
    ## 264                                                  
    ## 265                                                  
    ## 266                                                  
    ## 267                                                  
    ## 268                                                  
    ## 269                                                  
    ## 270                                                  
    ## 271                                                  
    ## 272                                                  
    ## 273                                                  
    ## 274                                                  
    ## 275                                                  
    ## 276                                                  
    ## 277                                                  
    ## 278                                                  
    ## 279                                                  
    ## 280                                                  
    ## 281                                                  
    ## 282                                                  
    ## 283                                                  
    ## 284                                                  
    ## 285                                                  
    ## 286                                                  
    ## 287                                                  
    ## 288                                                  
    ## 289                                                  
    ## 290                                                  
    ## 291                                                  
    ## 292                                                  
    ## 293                                                  
    ## 294                                                  
    ## 295                                                  
    ## 296                                                  
    ## 297                                                  
    ## 298                                                  
    ## 299                                                  
    ## 300                                                  
    ## 301                                                  
    ## 302                                                  
    ## 303                                                  
    ## 304                                                  
    ## 305                                                  
    ## 306                                                  
    ## 307                                                  
    ## 308                                                  
    ## 309                                                  
    ## 310                                                  
    ## 311                                                  
    ## 312                                                  
    ## 313                                                  
    ## 314                                                  
    ## 315                                                  
    ## 316                                                  
    ## 317                                                  
    ## 318                                                  
    ## 319                                                  
    ## 320                                                  
    ## 321                                                  
    ## 322                                                  
    ## 323                                                  
    ## 324                                                  
    ## 325                                                  
    ## 326                                                  
    ## 327                                                  
    ## 328                                                  
    ## 329                                                  
    ## 330                                                  
    ## 331                                                  
    ## 332                                                  
    ## 333                                                  
    ## 334                                                  
    ## 335                                                  
    ## 336                                                  
    ## 337                                                  
    ## 338                                                  
    ## 339                                                  
    ## 340                                                  
    ## 341                                                  
    ## 342                                                  
    ## 343                                                  
    ## 344                                                  
    ## 345                                                  
    ## 346                                                  
    ## 347                                                  
    ## 348                                                  
    ## 349                                                  
    ## 350                                                  
    ## 351                                                  
    ## 352                                                  
    ## 353                                                  
    ## 354                                                  
    ## 355                                                  
    ## 356                                                  
    ## 357                                                  
    ## 358                                                  
    ## 359                                                  
    ## 360                                                  
    ## 361                                                  
    ## 362                                                  
    ## 363                                                  
    ## 364                                                  
    ## 365                                                  
    ## 366                                                  
    ## 367                                                  
    ## 368                                                  
    ## 369                                                  
    ## 370                                                  
    ## 371                                                  
    ## 372                                                  
    ## 373                                                  
    ## 374                                                  
    ## 375                                                  
    ## 376                                                  
    ## 377                                                  
    ## 378                                                  
    ## 379                                                  
    ## 380                                                  
    ## 381                                                  
    ## 382                                                  
    ## 383                                                  
    ## 384                                                  
    ## 385                                                  
    ## 386                                                  
    ## 387                                                  
    ## 388                                                  
    ## 389                                                  
    ## 390                                                  
    ## 391                                                  
    ## 392                                                  
    ## 393                                                  
    ## 394                                                  
    ## 395                                                  
    ## 396                                                  
    ## 397                                                  
    ## 398                                                  
    ## 399                                                  
    ## 400                                                  
    ## 401                                                  
    ## 402                                                  
    ## 403                                                  
    ## 404                                                  
    ## 405                                                  
    ## 406                                                  
    ## 407                                                  
    ## 408                                                  
    ## 409                                                  
    ## 410                                                  
    ## 411                                                  
    ## 412                                                  
    ## 413                                                  
    ## 414                                                  
    ## 415                                                  
    ## 416                                                  
    ## 417                                                  
    ## 418                                                  
    ## 419                                                  
    ## 420                                                  
    ## 421                                                  
    ## 422                                                  
    ## 423                                                  
    ## 424                                                  
    ## 425                                                  
    ## 426                                                  
    ## 427                                                  
    ## 428                                                  
    ## 429                                                  
    ## 430                                                  
    ## 431                                                  
    ## 432                                                  
    ## 433                                                  
    ## 434                                                  
    ## 435                                                  
    ## 436                                                  
    ## 437                                                  
    ## 438                                                  
    ## 439                                                  
    ## 440                                                  
    ## 441                                                  
    ## 442                                                  
    ## 443                                                  
    ## 444                                                  
    ## 445                                                  
    ## 446                                                  
    ## 447                                                  
    ## 448                                                  
    ## 449                                                  
    ## 450                                                  
    ## 451                                                  
    ## 452                                                  
    ## 453                                                  
    ## 454                                                  
    ## 455                                                  
    ## 456                                                  
    ## 457                                                  
    ## 458                                                  
    ## 459                                                  
    ## 460                                                  
    ## 461                                                  
    ## 462                                                  
    ## 463                                                  
    ## 464                                                  
    ## 465                                                  
    ## 466                                                  
    ## 467                                                  
    ## 468                                                  
    ## 469                                                  
    ## 470                                                  
    ## 471                                                  
    ## 472                                                  
    ## 473                                                  
    ## 474                                                  
    ## 475                                                  
    ## 476                                                  
    ## 477                                                  
    ## 478                                                  
    ## 479                                                  
    ## 480                                                  
    ## 481                                                  
    ## 482                                                  
    ## 483                                                  
    ## 484                                                  
    ## 485                                                  
    ## 486                                                  
    ## 487                                                  
    ## 488                                                  
    ## 489                                                  
    ## 490                                                  
    ## 491                                                  
    ## 492                                                  
    ## 493                                                  
    ## 494                                                  
    ## 495                                                  
    ## 496                                                  
    ## 497                                                  
    ## 498                                                  
    ## 499                                                  
    ## 500                                                  
    ## 501                                                  
    ## 502                                                  
    ## 503                                                  
    ## 504                                                  
    ## 505                                                  
    ## 506                                                  
    ## 507                                                  
    ## 508                                                  
    ## 509                                                  
    ## 510                                                  
    ## 511                                                  
    ## 512                                                  
    ## 513                                                  
    ## 514                                                  
    ## 515                                                  
    ## 516                                                  
    ## 517                                                  
    ## 518                                                  
    ## 519                                                  
    ## 520                                                  
    ## 521                                                  
    ## 522                                                  
    ## 523                                                  
    ## 524                                                  
    ## 525                                                  
    ## 526                                                  
    ## 527                                                  
    ## 528                                                  
    ## 529                                                  
    ## 530                                                  
    ## 531                                                  
    ## 532                                                  
    ## 533                                                  
    ## 534                                                  
    ## 535                                                  
    ## 536                                                  
    ## 537                                                  
    ## 538                                                  
    ## 539                                                  
    ## 540                                                  
    ## 541                                                  
    ## 542                                                  
    ## 543                                                  
    ## 544                                                  
    ## 545                                                  
    ## 546                                                  
    ## 547                                                  
    ## 548                                                  
    ## 549                                                  
    ## 550                                                  
    ## 551                                                  
    ## 552                                                  
    ## 553                                                  
    ## 554                                                  
    ## 555      tBodyAccMean         ,     gravity         )
    ## 556  tBodyAccJerkMean         , gravityMean         )
    ## 557     tBodyGyroMean         , gravityMean         )
    ## 558 tBodyGyroJerkMean         , gravityMean         )
    ## 559                 X         , gravityMean         )
    ## 560                 Y         , gravityMean         )
    ## 561                 Z         , gravityMean         )

Feature name recomposition
--------------------------

``` r
features %>%
    unite(recomposition, sep = "", everything(), -id, -name, -axesSep, -axes) %>%
    select(name,recomposition)
```

    ##                                     name
    ## 1                      tBodyAcc-mean()-X
    ## 2                      tBodyAcc-mean()-Y
    ## 3                      tBodyAcc-mean()-Z
    ## 4                       tBodyAcc-std()-X
    ## 5                       tBodyAcc-std()-Y
    ## 6                       tBodyAcc-std()-Z
    ## 7                       tBodyAcc-mad()-X
    ## 8                       tBodyAcc-mad()-Y
    ## 9                       tBodyAcc-mad()-Z
    ## 10                      tBodyAcc-max()-X
    ## 11                      tBodyAcc-max()-Y
    ## 12                      tBodyAcc-max()-Z
    ## 13                      tBodyAcc-min()-X
    ## 14                      tBodyAcc-min()-Y
    ## 15                      tBodyAcc-min()-Z
    ## 16                        tBodyAcc-sma()
    ## 17                   tBodyAcc-energy()-X
    ## 18                   tBodyAcc-energy()-Y
    ## 19                   tBodyAcc-energy()-Z
    ## 20                      tBodyAcc-iqr()-X
    ## 21                      tBodyAcc-iqr()-Y
    ## 22                      tBodyAcc-iqr()-Z
    ## 23                  tBodyAcc-entropy()-X
    ## 24                  tBodyAcc-entropy()-Y
    ## 25                  tBodyAcc-entropy()-Z
    ## 26                tBodyAcc-arCoeff()-X,1
    ## 27                tBodyAcc-arCoeff()-X,2
    ## 28                tBodyAcc-arCoeff()-X,3
    ## 29                tBodyAcc-arCoeff()-X,4
    ## 30                tBodyAcc-arCoeff()-Y,1
    ## 31                tBodyAcc-arCoeff()-Y,2
    ## 32                tBodyAcc-arCoeff()-Y,3
    ## 33                tBodyAcc-arCoeff()-Y,4
    ## 34                tBodyAcc-arCoeff()-Z,1
    ## 35                tBodyAcc-arCoeff()-Z,2
    ## 36                tBodyAcc-arCoeff()-Z,3
    ## 37                tBodyAcc-arCoeff()-Z,4
    ## 38            tBodyAcc-correlation()-X,Y
    ## 39            tBodyAcc-correlation()-X,Z
    ## 40            tBodyAcc-correlation()-Y,Z
    ## 41                  tGravityAcc-mean()-X
    ## 42                  tGravityAcc-mean()-Y
    ## 43                  tGravityAcc-mean()-Z
    ## 44                   tGravityAcc-std()-X
    ## 45                   tGravityAcc-std()-Y
    ## 46                   tGravityAcc-std()-Z
    ## 47                   tGravityAcc-mad()-X
    ## 48                   tGravityAcc-mad()-Y
    ## 49                   tGravityAcc-mad()-Z
    ## 50                   tGravityAcc-max()-X
    ## 51                   tGravityAcc-max()-Y
    ## 52                   tGravityAcc-max()-Z
    ## 53                   tGravityAcc-min()-X
    ## 54                   tGravityAcc-min()-Y
    ## 55                   tGravityAcc-min()-Z
    ## 56                     tGravityAcc-sma()
    ## 57                tGravityAcc-energy()-X
    ## 58                tGravityAcc-energy()-Y
    ## 59                tGravityAcc-energy()-Z
    ## 60                   tGravityAcc-iqr()-X
    ## 61                   tGravityAcc-iqr()-Y
    ## 62                   tGravityAcc-iqr()-Z
    ## 63               tGravityAcc-entropy()-X
    ## 64               tGravityAcc-entropy()-Y
    ## 65               tGravityAcc-entropy()-Z
    ## 66             tGravityAcc-arCoeff()-X,1
    ## 67             tGravityAcc-arCoeff()-X,2
    ## 68             tGravityAcc-arCoeff()-X,3
    ## 69             tGravityAcc-arCoeff()-X,4
    ## 70             tGravityAcc-arCoeff()-Y,1
    ## 71             tGravityAcc-arCoeff()-Y,2
    ## 72             tGravityAcc-arCoeff()-Y,3
    ## 73             tGravityAcc-arCoeff()-Y,4
    ## 74             tGravityAcc-arCoeff()-Z,1
    ## 75             tGravityAcc-arCoeff()-Z,2
    ## 76             tGravityAcc-arCoeff()-Z,3
    ## 77             tGravityAcc-arCoeff()-Z,4
    ## 78         tGravityAcc-correlation()-X,Y
    ## 79         tGravityAcc-correlation()-X,Z
    ## 80         tGravityAcc-correlation()-Y,Z
    ## 81                 tBodyAccJerk-mean()-X
    ## 82                 tBodyAccJerk-mean()-Y
    ## 83                 tBodyAccJerk-mean()-Z
    ## 84                  tBodyAccJerk-std()-X
    ## 85                  tBodyAccJerk-std()-Y
    ## 86                  tBodyAccJerk-std()-Z
    ## 87                  tBodyAccJerk-mad()-X
    ## 88                  tBodyAccJerk-mad()-Y
    ## 89                  tBodyAccJerk-mad()-Z
    ## 90                  tBodyAccJerk-max()-X
    ## 91                  tBodyAccJerk-max()-Y
    ## 92                  tBodyAccJerk-max()-Z
    ## 93                  tBodyAccJerk-min()-X
    ## 94                  tBodyAccJerk-min()-Y
    ## 95                  tBodyAccJerk-min()-Z
    ## 96                    tBodyAccJerk-sma()
    ## 97               tBodyAccJerk-energy()-X
    ## 98               tBodyAccJerk-energy()-Y
    ## 99               tBodyAccJerk-energy()-Z
    ## 100                 tBodyAccJerk-iqr()-X
    ## 101                 tBodyAccJerk-iqr()-Y
    ## 102                 tBodyAccJerk-iqr()-Z
    ## 103             tBodyAccJerk-entropy()-X
    ## 104             tBodyAccJerk-entropy()-Y
    ## 105             tBodyAccJerk-entropy()-Z
    ## 106           tBodyAccJerk-arCoeff()-X,1
    ## 107           tBodyAccJerk-arCoeff()-X,2
    ## 108           tBodyAccJerk-arCoeff()-X,3
    ## 109           tBodyAccJerk-arCoeff()-X,4
    ## 110           tBodyAccJerk-arCoeff()-Y,1
    ## 111           tBodyAccJerk-arCoeff()-Y,2
    ## 112           tBodyAccJerk-arCoeff()-Y,3
    ## 113           tBodyAccJerk-arCoeff()-Y,4
    ## 114           tBodyAccJerk-arCoeff()-Z,1
    ## 115           tBodyAccJerk-arCoeff()-Z,2
    ## 116           tBodyAccJerk-arCoeff()-Z,3
    ## 117           tBodyAccJerk-arCoeff()-Z,4
    ## 118       tBodyAccJerk-correlation()-X,Y
    ## 119       tBodyAccJerk-correlation()-X,Z
    ## 120       tBodyAccJerk-correlation()-Y,Z
    ## 121                   tBodyGyro-mean()-X
    ## 122                   tBodyGyro-mean()-Y
    ## 123                   tBodyGyro-mean()-Z
    ## 124                    tBodyGyro-std()-X
    ## 125                    tBodyGyro-std()-Y
    ## 126                    tBodyGyro-std()-Z
    ## 127                    tBodyGyro-mad()-X
    ## 128                    tBodyGyro-mad()-Y
    ## 129                    tBodyGyro-mad()-Z
    ## 130                    tBodyGyro-max()-X
    ## 131                    tBodyGyro-max()-Y
    ## 132                    tBodyGyro-max()-Z
    ## 133                    tBodyGyro-min()-X
    ## 134                    tBodyGyro-min()-Y
    ## 135                    tBodyGyro-min()-Z
    ## 136                      tBodyGyro-sma()
    ## 137                 tBodyGyro-energy()-X
    ## 138                 tBodyGyro-energy()-Y
    ## 139                 tBodyGyro-energy()-Z
    ## 140                    tBodyGyro-iqr()-X
    ## 141                    tBodyGyro-iqr()-Y
    ## 142                    tBodyGyro-iqr()-Z
    ## 143                tBodyGyro-entropy()-X
    ## 144                tBodyGyro-entropy()-Y
    ## 145                tBodyGyro-entropy()-Z
    ## 146              tBodyGyro-arCoeff()-X,1
    ## 147              tBodyGyro-arCoeff()-X,2
    ## 148              tBodyGyro-arCoeff()-X,3
    ## 149              tBodyGyro-arCoeff()-X,4
    ## 150              tBodyGyro-arCoeff()-Y,1
    ## 151              tBodyGyro-arCoeff()-Y,2
    ## 152              tBodyGyro-arCoeff()-Y,3
    ## 153              tBodyGyro-arCoeff()-Y,4
    ## 154              tBodyGyro-arCoeff()-Z,1
    ## 155              tBodyGyro-arCoeff()-Z,2
    ## 156              tBodyGyro-arCoeff()-Z,3
    ## 157              tBodyGyro-arCoeff()-Z,4
    ## 158          tBodyGyro-correlation()-X,Y
    ## 159          tBodyGyro-correlation()-X,Z
    ## 160          tBodyGyro-correlation()-Y,Z
    ## 161               tBodyGyroJerk-mean()-X
    ## 162               tBodyGyroJerk-mean()-Y
    ## 163               tBodyGyroJerk-mean()-Z
    ## 164                tBodyGyroJerk-std()-X
    ## 165                tBodyGyroJerk-std()-Y
    ## 166                tBodyGyroJerk-std()-Z
    ## 167                tBodyGyroJerk-mad()-X
    ## 168                tBodyGyroJerk-mad()-Y
    ## 169                tBodyGyroJerk-mad()-Z
    ## 170                tBodyGyroJerk-max()-X
    ## 171                tBodyGyroJerk-max()-Y
    ## 172                tBodyGyroJerk-max()-Z
    ## 173                tBodyGyroJerk-min()-X
    ## 174                tBodyGyroJerk-min()-Y
    ## 175                tBodyGyroJerk-min()-Z
    ## 176                  tBodyGyroJerk-sma()
    ## 177             tBodyGyroJerk-energy()-X
    ## 178             tBodyGyroJerk-energy()-Y
    ## 179             tBodyGyroJerk-energy()-Z
    ## 180                tBodyGyroJerk-iqr()-X
    ## 181                tBodyGyroJerk-iqr()-Y
    ## 182                tBodyGyroJerk-iqr()-Z
    ## 183            tBodyGyroJerk-entropy()-X
    ## 184            tBodyGyroJerk-entropy()-Y
    ## 185            tBodyGyroJerk-entropy()-Z
    ## 186          tBodyGyroJerk-arCoeff()-X,1
    ## 187          tBodyGyroJerk-arCoeff()-X,2
    ## 188          tBodyGyroJerk-arCoeff()-X,3
    ## 189          tBodyGyroJerk-arCoeff()-X,4
    ## 190          tBodyGyroJerk-arCoeff()-Y,1
    ## 191          tBodyGyroJerk-arCoeff()-Y,2
    ## 192          tBodyGyroJerk-arCoeff()-Y,3
    ## 193          tBodyGyroJerk-arCoeff()-Y,4
    ## 194          tBodyGyroJerk-arCoeff()-Z,1
    ## 195          tBodyGyroJerk-arCoeff()-Z,2
    ## 196          tBodyGyroJerk-arCoeff()-Z,3
    ## 197          tBodyGyroJerk-arCoeff()-Z,4
    ## 198      tBodyGyroJerk-correlation()-X,Y
    ## 199      tBodyGyroJerk-correlation()-X,Z
    ## 200      tBodyGyroJerk-correlation()-Y,Z
    ## 201                   tBodyAccMag-mean()
    ## 202                    tBodyAccMag-std()
    ## 203                    tBodyAccMag-mad()
    ## 204                    tBodyAccMag-max()
    ## 205                    tBodyAccMag-min()
    ## 206                    tBodyAccMag-sma()
    ## 207                 tBodyAccMag-energy()
    ## 208                    tBodyAccMag-iqr()
    ## 209                tBodyAccMag-entropy()
    ## 210               tBodyAccMag-arCoeff()1
    ## 211               tBodyAccMag-arCoeff()2
    ## 212               tBodyAccMag-arCoeff()3
    ## 213               tBodyAccMag-arCoeff()4
    ## 214                tGravityAccMag-mean()
    ## 215                 tGravityAccMag-std()
    ## 216                 tGravityAccMag-mad()
    ## 217                 tGravityAccMag-max()
    ## 218                 tGravityAccMag-min()
    ## 219                 tGravityAccMag-sma()
    ## 220              tGravityAccMag-energy()
    ## 221                 tGravityAccMag-iqr()
    ## 222             tGravityAccMag-entropy()
    ## 223            tGravityAccMag-arCoeff()1
    ## 224            tGravityAccMag-arCoeff()2
    ## 225            tGravityAccMag-arCoeff()3
    ## 226            tGravityAccMag-arCoeff()4
    ## 227               tBodyAccJerkMag-mean()
    ## 228                tBodyAccJerkMag-std()
    ## 229                tBodyAccJerkMag-mad()
    ## 230                tBodyAccJerkMag-max()
    ## 231                tBodyAccJerkMag-min()
    ## 232                tBodyAccJerkMag-sma()
    ## 233             tBodyAccJerkMag-energy()
    ## 234                tBodyAccJerkMag-iqr()
    ## 235            tBodyAccJerkMag-entropy()
    ## 236           tBodyAccJerkMag-arCoeff()1
    ## 237           tBodyAccJerkMag-arCoeff()2
    ## 238           tBodyAccJerkMag-arCoeff()3
    ## 239           tBodyAccJerkMag-arCoeff()4
    ## 240                  tBodyGyroMag-mean()
    ## 241                   tBodyGyroMag-std()
    ## 242                   tBodyGyroMag-mad()
    ## 243                   tBodyGyroMag-max()
    ## 244                   tBodyGyroMag-min()
    ## 245                   tBodyGyroMag-sma()
    ## 246                tBodyGyroMag-energy()
    ## 247                   tBodyGyroMag-iqr()
    ## 248               tBodyGyroMag-entropy()
    ## 249              tBodyGyroMag-arCoeff()1
    ## 250              tBodyGyroMag-arCoeff()2
    ## 251              tBodyGyroMag-arCoeff()3
    ## 252              tBodyGyroMag-arCoeff()4
    ## 253              tBodyGyroJerkMag-mean()
    ## 254               tBodyGyroJerkMag-std()
    ## 255               tBodyGyroJerkMag-mad()
    ## 256               tBodyGyroJerkMag-max()
    ## 257               tBodyGyroJerkMag-min()
    ## 258               tBodyGyroJerkMag-sma()
    ## 259            tBodyGyroJerkMag-energy()
    ## 260               tBodyGyroJerkMag-iqr()
    ## 261           tBodyGyroJerkMag-entropy()
    ## 262          tBodyGyroJerkMag-arCoeff()1
    ## 263          tBodyGyroJerkMag-arCoeff()2
    ## 264          tBodyGyroJerkMag-arCoeff()3
    ## 265          tBodyGyroJerkMag-arCoeff()4
    ## 266                    fBodyAcc-mean()-X
    ## 267                    fBodyAcc-mean()-Y
    ## 268                    fBodyAcc-mean()-Z
    ## 269                     fBodyAcc-std()-X
    ## 270                     fBodyAcc-std()-Y
    ## 271                     fBodyAcc-std()-Z
    ## 272                     fBodyAcc-mad()-X
    ## 273                     fBodyAcc-mad()-Y
    ## 274                     fBodyAcc-mad()-Z
    ## 275                     fBodyAcc-max()-X
    ## 276                     fBodyAcc-max()-Y
    ## 277                     fBodyAcc-max()-Z
    ## 278                     fBodyAcc-min()-X
    ## 279                     fBodyAcc-min()-Y
    ## 280                     fBodyAcc-min()-Z
    ## 281                       fBodyAcc-sma()
    ## 282                  fBodyAcc-energy()-X
    ## 283                  fBodyAcc-energy()-Y
    ## 284                  fBodyAcc-energy()-Z
    ## 285                     fBodyAcc-iqr()-X
    ## 286                     fBodyAcc-iqr()-Y
    ## 287                     fBodyAcc-iqr()-Z
    ## 288                 fBodyAcc-entropy()-X
    ## 289                 fBodyAcc-entropy()-Y
    ## 290                 fBodyAcc-entropy()-Z
    ## 291                 fBodyAcc-maxInds()-X
    ## 292                 fBodyAcc-maxInds()-Y
    ## 293                 fBodyAcc-maxInds()-Z
    ## 294                fBodyAcc-meanFreq()-X
    ## 295                fBodyAcc-meanFreq()-Y
    ## 296                fBodyAcc-meanFreq()-Z
    ## 297                fBodyAcc-skewness()-X
    ## 298                fBodyAcc-kurtosis()-X
    ## 299                fBodyAcc-skewness()-Y
    ## 300                fBodyAcc-kurtosis()-Y
    ## 301                fBodyAcc-skewness()-Z
    ## 302                fBodyAcc-kurtosis()-Z
    ## 303           fBodyAcc-bandsEnergy()-1,8
    ## 304          fBodyAcc-bandsEnergy()-9,16
    ## 305         fBodyAcc-bandsEnergy()-17,24
    ## 306         fBodyAcc-bandsEnergy()-25,32
    ## 307         fBodyAcc-bandsEnergy()-33,40
    ## 308         fBodyAcc-bandsEnergy()-41,48
    ## 309         fBodyAcc-bandsEnergy()-49,56
    ## 310         fBodyAcc-bandsEnergy()-57,64
    ## 311          fBodyAcc-bandsEnergy()-1,16
    ## 312         fBodyAcc-bandsEnergy()-17,32
    ## 313         fBodyAcc-bandsEnergy()-33,48
    ## 314         fBodyAcc-bandsEnergy()-49,64
    ## 315          fBodyAcc-bandsEnergy()-1,24
    ## 316         fBodyAcc-bandsEnergy()-25,48
    ## 317           fBodyAcc-bandsEnergy()-1,8
    ## 318          fBodyAcc-bandsEnergy()-9,16
    ## 319         fBodyAcc-bandsEnergy()-17,24
    ## 320         fBodyAcc-bandsEnergy()-25,32
    ## 321         fBodyAcc-bandsEnergy()-33,40
    ## 322         fBodyAcc-bandsEnergy()-41,48
    ## 323         fBodyAcc-bandsEnergy()-49,56
    ## 324         fBodyAcc-bandsEnergy()-57,64
    ## 325          fBodyAcc-bandsEnergy()-1,16
    ## 326         fBodyAcc-bandsEnergy()-17,32
    ## 327         fBodyAcc-bandsEnergy()-33,48
    ## 328         fBodyAcc-bandsEnergy()-49,64
    ## 329          fBodyAcc-bandsEnergy()-1,24
    ## 330         fBodyAcc-bandsEnergy()-25,48
    ## 331           fBodyAcc-bandsEnergy()-1,8
    ## 332          fBodyAcc-bandsEnergy()-9,16
    ## 333         fBodyAcc-bandsEnergy()-17,24
    ## 334         fBodyAcc-bandsEnergy()-25,32
    ## 335         fBodyAcc-bandsEnergy()-33,40
    ## 336         fBodyAcc-bandsEnergy()-41,48
    ## 337         fBodyAcc-bandsEnergy()-49,56
    ## 338         fBodyAcc-bandsEnergy()-57,64
    ## 339          fBodyAcc-bandsEnergy()-1,16
    ## 340         fBodyAcc-bandsEnergy()-17,32
    ## 341         fBodyAcc-bandsEnergy()-33,48
    ## 342         fBodyAcc-bandsEnergy()-49,64
    ## 343          fBodyAcc-bandsEnergy()-1,24
    ## 344         fBodyAcc-bandsEnergy()-25,48
    ## 345                fBodyAccJerk-mean()-X
    ## 346                fBodyAccJerk-mean()-Y
    ## 347                fBodyAccJerk-mean()-Z
    ## 348                 fBodyAccJerk-std()-X
    ## 349                 fBodyAccJerk-std()-Y
    ## 350                 fBodyAccJerk-std()-Z
    ## 351                 fBodyAccJerk-mad()-X
    ## 352                 fBodyAccJerk-mad()-Y
    ## 353                 fBodyAccJerk-mad()-Z
    ## 354                 fBodyAccJerk-max()-X
    ## 355                 fBodyAccJerk-max()-Y
    ## 356                 fBodyAccJerk-max()-Z
    ## 357                 fBodyAccJerk-min()-X
    ## 358                 fBodyAccJerk-min()-Y
    ## 359                 fBodyAccJerk-min()-Z
    ## 360                   fBodyAccJerk-sma()
    ## 361              fBodyAccJerk-energy()-X
    ## 362              fBodyAccJerk-energy()-Y
    ## 363              fBodyAccJerk-energy()-Z
    ## 364                 fBodyAccJerk-iqr()-X
    ## 365                 fBodyAccJerk-iqr()-Y
    ## 366                 fBodyAccJerk-iqr()-Z
    ## 367             fBodyAccJerk-entropy()-X
    ## 368             fBodyAccJerk-entropy()-Y
    ## 369             fBodyAccJerk-entropy()-Z
    ## 370             fBodyAccJerk-maxInds()-X
    ## 371             fBodyAccJerk-maxInds()-Y
    ## 372             fBodyAccJerk-maxInds()-Z
    ## 373            fBodyAccJerk-meanFreq()-X
    ## 374            fBodyAccJerk-meanFreq()-Y
    ## 375            fBodyAccJerk-meanFreq()-Z
    ## 376            fBodyAccJerk-skewness()-X
    ## 377            fBodyAccJerk-kurtosis()-X
    ## 378            fBodyAccJerk-skewness()-Y
    ## 379            fBodyAccJerk-kurtosis()-Y
    ## 380            fBodyAccJerk-skewness()-Z
    ## 381            fBodyAccJerk-kurtosis()-Z
    ## 382       fBodyAccJerk-bandsEnergy()-1,8
    ## 383      fBodyAccJerk-bandsEnergy()-9,16
    ## 384     fBodyAccJerk-bandsEnergy()-17,24
    ## 385     fBodyAccJerk-bandsEnergy()-25,32
    ## 386     fBodyAccJerk-bandsEnergy()-33,40
    ## 387     fBodyAccJerk-bandsEnergy()-41,48
    ## 388     fBodyAccJerk-bandsEnergy()-49,56
    ## 389     fBodyAccJerk-bandsEnergy()-57,64
    ## 390      fBodyAccJerk-bandsEnergy()-1,16
    ## 391     fBodyAccJerk-bandsEnergy()-17,32
    ## 392     fBodyAccJerk-bandsEnergy()-33,48
    ## 393     fBodyAccJerk-bandsEnergy()-49,64
    ## 394      fBodyAccJerk-bandsEnergy()-1,24
    ## 395     fBodyAccJerk-bandsEnergy()-25,48
    ## 396       fBodyAccJerk-bandsEnergy()-1,8
    ## 397      fBodyAccJerk-bandsEnergy()-9,16
    ## 398     fBodyAccJerk-bandsEnergy()-17,24
    ## 399     fBodyAccJerk-bandsEnergy()-25,32
    ## 400     fBodyAccJerk-bandsEnergy()-33,40
    ## 401     fBodyAccJerk-bandsEnergy()-41,48
    ## 402     fBodyAccJerk-bandsEnergy()-49,56
    ## 403     fBodyAccJerk-bandsEnergy()-57,64
    ## 404      fBodyAccJerk-bandsEnergy()-1,16
    ## 405     fBodyAccJerk-bandsEnergy()-17,32
    ## 406     fBodyAccJerk-bandsEnergy()-33,48
    ## 407     fBodyAccJerk-bandsEnergy()-49,64
    ## 408      fBodyAccJerk-bandsEnergy()-1,24
    ## 409     fBodyAccJerk-bandsEnergy()-25,48
    ## 410       fBodyAccJerk-bandsEnergy()-1,8
    ## 411      fBodyAccJerk-bandsEnergy()-9,16
    ## 412     fBodyAccJerk-bandsEnergy()-17,24
    ## 413     fBodyAccJerk-bandsEnergy()-25,32
    ## 414     fBodyAccJerk-bandsEnergy()-33,40
    ## 415     fBodyAccJerk-bandsEnergy()-41,48
    ## 416     fBodyAccJerk-bandsEnergy()-49,56
    ## 417     fBodyAccJerk-bandsEnergy()-57,64
    ## 418      fBodyAccJerk-bandsEnergy()-1,16
    ## 419     fBodyAccJerk-bandsEnergy()-17,32
    ## 420     fBodyAccJerk-bandsEnergy()-33,48
    ## 421     fBodyAccJerk-bandsEnergy()-49,64
    ## 422      fBodyAccJerk-bandsEnergy()-1,24
    ## 423     fBodyAccJerk-bandsEnergy()-25,48
    ## 424                   fBodyGyro-mean()-X
    ## 425                   fBodyGyro-mean()-Y
    ## 426                   fBodyGyro-mean()-Z
    ## 427                    fBodyGyro-std()-X
    ## 428                    fBodyGyro-std()-Y
    ## 429                    fBodyGyro-std()-Z
    ## 430                    fBodyGyro-mad()-X
    ## 431                    fBodyGyro-mad()-Y
    ## 432                    fBodyGyro-mad()-Z
    ## 433                    fBodyGyro-max()-X
    ## 434                    fBodyGyro-max()-Y
    ## 435                    fBodyGyro-max()-Z
    ## 436                    fBodyGyro-min()-X
    ## 437                    fBodyGyro-min()-Y
    ## 438                    fBodyGyro-min()-Z
    ## 439                      fBodyGyro-sma()
    ## 440                 fBodyGyro-energy()-X
    ## 441                 fBodyGyro-energy()-Y
    ## 442                 fBodyGyro-energy()-Z
    ## 443                    fBodyGyro-iqr()-X
    ## 444                    fBodyGyro-iqr()-Y
    ## 445                    fBodyGyro-iqr()-Z
    ## 446                fBodyGyro-entropy()-X
    ## 447                fBodyGyro-entropy()-Y
    ## 448                fBodyGyro-entropy()-Z
    ## 449                fBodyGyro-maxInds()-X
    ## 450                fBodyGyro-maxInds()-Y
    ## 451                fBodyGyro-maxInds()-Z
    ## 452               fBodyGyro-meanFreq()-X
    ## 453               fBodyGyro-meanFreq()-Y
    ## 454               fBodyGyro-meanFreq()-Z
    ## 455               fBodyGyro-skewness()-X
    ## 456               fBodyGyro-kurtosis()-X
    ## 457               fBodyGyro-skewness()-Y
    ## 458               fBodyGyro-kurtosis()-Y
    ## 459               fBodyGyro-skewness()-Z
    ## 460               fBodyGyro-kurtosis()-Z
    ## 461          fBodyGyro-bandsEnergy()-1,8
    ## 462         fBodyGyro-bandsEnergy()-9,16
    ## 463        fBodyGyro-bandsEnergy()-17,24
    ## 464        fBodyGyro-bandsEnergy()-25,32
    ## 465        fBodyGyro-bandsEnergy()-33,40
    ## 466        fBodyGyro-bandsEnergy()-41,48
    ## 467        fBodyGyro-bandsEnergy()-49,56
    ## 468        fBodyGyro-bandsEnergy()-57,64
    ## 469         fBodyGyro-bandsEnergy()-1,16
    ## 470        fBodyGyro-bandsEnergy()-17,32
    ## 471        fBodyGyro-bandsEnergy()-33,48
    ## 472        fBodyGyro-bandsEnergy()-49,64
    ## 473         fBodyGyro-bandsEnergy()-1,24
    ## 474        fBodyGyro-bandsEnergy()-25,48
    ## 475          fBodyGyro-bandsEnergy()-1,8
    ## 476         fBodyGyro-bandsEnergy()-9,16
    ## 477        fBodyGyro-bandsEnergy()-17,24
    ## 478        fBodyGyro-bandsEnergy()-25,32
    ## 479        fBodyGyro-bandsEnergy()-33,40
    ## 480        fBodyGyro-bandsEnergy()-41,48
    ## 481        fBodyGyro-bandsEnergy()-49,56
    ## 482        fBodyGyro-bandsEnergy()-57,64
    ## 483         fBodyGyro-bandsEnergy()-1,16
    ## 484        fBodyGyro-bandsEnergy()-17,32
    ## 485        fBodyGyro-bandsEnergy()-33,48
    ## 486        fBodyGyro-bandsEnergy()-49,64
    ## 487         fBodyGyro-bandsEnergy()-1,24
    ## 488        fBodyGyro-bandsEnergy()-25,48
    ## 489          fBodyGyro-bandsEnergy()-1,8
    ## 490         fBodyGyro-bandsEnergy()-9,16
    ## 491        fBodyGyro-bandsEnergy()-17,24
    ## 492        fBodyGyro-bandsEnergy()-25,32
    ## 493        fBodyGyro-bandsEnergy()-33,40
    ## 494        fBodyGyro-bandsEnergy()-41,48
    ## 495        fBodyGyro-bandsEnergy()-49,56
    ## 496        fBodyGyro-bandsEnergy()-57,64
    ## 497         fBodyGyro-bandsEnergy()-1,16
    ## 498        fBodyGyro-bandsEnergy()-17,32
    ## 499        fBodyGyro-bandsEnergy()-33,48
    ## 500        fBodyGyro-bandsEnergy()-49,64
    ## 501         fBodyGyro-bandsEnergy()-1,24
    ## 502        fBodyGyro-bandsEnergy()-25,48
    ## 503                   fBodyAccMag-mean()
    ## 504                    fBodyAccMag-std()
    ## 505                    fBodyAccMag-mad()
    ## 506                    fBodyAccMag-max()
    ## 507                    fBodyAccMag-min()
    ## 508                    fBodyAccMag-sma()
    ## 509                 fBodyAccMag-energy()
    ## 510                    fBodyAccMag-iqr()
    ## 511                fBodyAccMag-entropy()
    ## 512                fBodyAccMag-maxInds()
    ## 513               fBodyAccMag-meanFreq()
    ## 514               fBodyAccMag-skewness()
    ## 515               fBodyAccMag-kurtosis()
    ## 516               fBodyAccJerkMag-mean()
    ## 517                fBodyAccJerkMag-std()
    ## 518                fBodyAccJerkMag-mad()
    ## 519                fBodyAccJerkMag-max()
    ## 520                fBodyAccJerkMag-min()
    ## 521                fBodyAccJerkMag-sma()
    ## 522             fBodyAccJerkMag-energy()
    ## 523                fBodyAccJerkMag-iqr()
    ## 524            fBodyAccJerkMag-entropy()
    ## 525            fBodyAccJerkMag-maxInds()
    ## 526           fBodyAccJerkMag-meanFreq()
    ## 527           fBodyAccJerkMag-skewness()
    ## 528           fBodyAccJerkMag-kurtosis()
    ## 529                  fBodyGyroMag-mean()
    ## 530                   fBodyGyroMag-std()
    ## 531                   fBodyGyroMag-mad()
    ## 532                   fBodyGyroMag-max()
    ## 533                   fBodyGyroMag-min()
    ## 534                   fBodyGyroMag-sma()
    ## 535                fBodyGyroMag-energy()
    ## 536                   fBodyGyroMag-iqr()
    ## 537               fBodyGyroMag-entropy()
    ## 538               fBodyGyroMag-maxInds()
    ## 539              fBodyGyroMag-meanFreq()
    ## 540              fBodyGyroMag-skewness()
    ## 541              fBodyGyroMag-kurtosis()
    ## 542              fBodyGyroJerkMag-mean()
    ## 543               fBodyGyroJerkMag-std()
    ## 544               fBodyGyroJerkMag-mad()
    ## 545               fBodyGyroJerkMag-max()
    ## 546               fBodyGyroJerkMag-min()
    ## 547               fBodyGyroJerkMag-sma()
    ## 548            fBodyGyroJerkMag-energy()
    ## 549               fBodyGyroJerkMag-iqr()
    ## 550           fBodyGyroJerkMag-entropy()
    ## 551           fBodyGyroJerkMag-maxInds()
    ## 552          fBodyGyroJerkMag-meanFreq()
    ## 553          fBodyGyroJerkMag-skewness()
    ## 554          fBodyGyroJerkMag-kurtosis()
    ## 555          angle(tBodyAccMean,gravity)
    ## 556  angle(tBodyAccJerkMean,gravityMean)
    ## 557     angle(tBodyGyroMean,gravityMean)
    ## 558 angle(tBodyGyroJerkMean,gravityMean)
    ## 559                 angle(X,gravityMean)
    ## 560                 angle(Y,gravityMean)
    ## 561                 angle(Z,gravityMean)
    ##                            recomposition
    ## 1                      tBodyAcc-mean()-X
    ## 2                      tBodyAcc-mean()-Y
    ## 3                      tBodyAcc-mean()-Z
    ## 4                       tBodyAcc-std()-X
    ## 5                       tBodyAcc-std()-Y
    ## 6                       tBodyAcc-std()-Z
    ## 7                       tBodyAcc-mad()-X
    ## 8                       tBodyAcc-mad()-Y
    ## 9                       tBodyAcc-mad()-Z
    ## 10                      tBodyAcc-max()-X
    ## 11                      tBodyAcc-max()-Y
    ## 12                      tBodyAcc-max()-Z
    ## 13                      tBodyAcc-min()-X
    ## 14                      tBodyAcc-min()-Y
    ## 15                      tBodyAcc-min()-Z
    ## 16                        tBodyAcc-sma()
    ## 17                   tBodyAcc-energy()-X
    ## 18                   tBodyAcc-energy()-Y
    ## 19                   tBodyAcc-energy()-Z
    ## 20                      tBodyAcc-iqr()-X
    ## 21                      tBodyAcc-iqr()-Y
    ## 22                      tBodyAcc-iqr()-Z
    ## 23                  tBodyAcc-entropy()-X
    ## 24                  tBodyAcc-entropy()-Y
    ## 25                  tBodyAcc-entropy()-Z
    ## 26                tBodyAcc-arCoeff()-X,1
    ## 27                tBodyAcc-arCoeff()-X,2
    ## 28                tBodyAcc-arCoeff()-X,3
    ## 29                tBodyAcc-arCoeff()-X,4
    ## 30                tBodyAcc-arCoeff()-Y,1
    ## 31                tBodyAcc-arCoeff()-Y,2
    ## 32                tBodyAcc-arCoeff()-Y,3
    ## 33                tBodyAcc-arCoeff()-Y,4
    ## 34                tBodyAcc-arCoeff()-Z,1
    ## 35                tBodyAcc-arCoeff()-Z,2
    ## 36                tBodyAcc-arCoeff()-Z,3
    ## 37                tBodyAcc-arCoeff()-Z,4
    ## 38            tBodyAcc-correlation()-X,Y
    ## 39            tBodyAcc-correlation()-X,Z
    ## 40            tBodyAcc-correlation()-Y,Z
    ## 41                  tGravityAcc-mean()-X
    ## 42                  tGravityAcc-mean()-Y
    ## 43                  tGravityAcc-mean()-Z
    ## 44                   tGravityAcc-std()-X
    ## 45                   tGravityAcc-std()-Y
    ## 46                   tGravityAcc-std()-Z
    ## 47                   tGravityAcc-mad()-X
    ## 48                   tGravityAcc-mad()-Y
    ## 49                   tGravityAcc-mad()-Z
    ## 50                   tGravityAcc-max()-X
    ## 51                   tGravityAcc-max()-Y
    ## 52                   tGravityAcc-max()-Z
    ## 53                   tGravityAcc-min()-X
    ## 54                   tGravityAcc-min()-Y
    ## 55                   tGravityAcc-min()-Z
    ## 56                     tGravityAcc-sma()
    ## 57                tGravityAcc-energy()-X
    ## 58                tGravityAcc-energy()-Y
    ## 59                tGravityAcc-energy()-Z
    ## 60                   tGravityAcc-iqr()-X
    ## 61                   tGravityAcc-iqr()-Y
    ## 62                   tGravityAcc-iqr()-Z
    ## 63               tGravityAcc-entropy()-X
    ## 64               tGravityAcc-entropy()-Y
    ## 65               tGravityAcc-entropy()-Z
    ## 66             tGravityAcc-arCoeff()-X,1
    ## 67             tGravityAcc-arCoeff()-X,2
    ## 68             tGravityAcc-arCoeff()-X,3
    ## 69             tGravityAcc-arCoeff()-X,4
    ## 70             tGravityAcc-arCoeff()-Y,1
    ## 71             tGravityAcc-arCoeff()-Y,2
    ## 72             tGravityAcc-arCoeff()-Y,3
    ## 73             tGravityAcc-arCoeff()-Y,4
    ## 74             tGravityAcc-arCoeff()-Z,1
    ## 75             tGravityAcc-arCoeff()-Z,2
    ## 76             tGravityAcc-arCoeff()-Z,3
    ## 77             tGravityAcc-arCoeff()-Z,4
    ## 78         tGravityAcc-correlation()-X,Y
    ## 79         tGravityAcc-correlation()-X,Z
    ## 80         tGravityAcc-correlation()-Y,Z
    ## 81                 tBodyAccJerk-mean()-X
    ## 82                 tBodyAccJerk-mean()-Y
    ## 83                 tBodyAccJerk-mean()-Z
    ## 84                  tBodyAccJerk-std()-X
    ## 85                  tBodyAccJerk-std()-Y
    ## 86                  tBodyAccJerk-std()-Z
    ## 87                  tBodyAccJerk-mad()-X
    ## 88                  tBodyAccJerk-mad()-Y
    ## 89                  tBodyAccJerk-mad()-Z
    ## 90                  tBodyAccJerk-max()-X
    ## 91                  tBodyAccJerk-max()-Y
    ## 92                  tBodyAccJerk-max()-Z
    ## 93                  tBodyAccJerk-min()-X
    ## 94                  tBodyAccJerk-min()-Y
    ## 95                  tBodyAccJerk-min()-Z
    ## 96                    tBodyAccJerk-sma()
    ## 97               tBodyAccJerk-energy()-X
    ## 98               tBodyAccJerk-energy()-Y
    ## 99               tBodyAccJerk-energy()-Z
    ## 100                 tBodyAccJerk-iqr()-X
    ## 101                 tBodyAccJerk-iqr()-Y
    ## 102                 tBodyAccJerk-iqr()-Z
    ## 103             tBodyAccJerk-entropy()-X
    ## 104             tBodyAccJerk-entropy()-Y
    ## 105             tBodyAccJerk-entropy()-Z
    ## 106           tBodyAccJerk-arCoeff()-X,1
    ## 107           tBodyAccJerk-arCoeff()-X,2
    ## 108           tBodyAccJerk-arCoeff()-X,3
    ## 109           tBodyAccJerk-arCoeff()-X,4
    ## 110           tBodyAccJerk-arCoeff()-Y,1
    ## 111           tBodyAccJerk-arCoeff()-Y,2
    ## 112           tBodyAccJerk-arCoeff()-Y,3
    ## 113           tBodyAccJerk-arCoeff()-Y,4
    ## 114           tBodyAccJerk-arCoeff()-Z,1
    ## 115           tBodyAccJerk-arCoeff()-Z,2
    ## 116           tBodyAccJerk-arCoeff()-Z,3
    ## 117           tBodyAccJerk-arCoeff()-Z,4
    ## 118       tBodyAccJerk-correlation()-X,Y
    ## 119       tBodyAccJerk-correlation()-X,Z
    ## 120       tBodyAccJerk-correlation()-Y,Z
    ## 121                   tBodyGyro-mean()-X
    ## 122                   tBodyGyro-mean()-Y
    ## 123                   tBodyGyro-mean()-Z
    ## 124                    tBodyGyro-std()-X
    ## 125                    tBodyGyro-std()-Y
    ## 126                    tBodyGyro-std()-Z
    ## 127                    tBodyGyro-mad()-X
    ## 128                    tBodyGyro-mad()-Y
    ## 129                    tBodyGyro-mad()-Z
    ## 130                    tBodyGyro-max()-X
    ## 131                    tBodyGyro-max()-Y
    ## 132                    tBodyGyro-max()-Z
    ## 133                    tBodyGyro-min()-X
    ## 134                    tBodyGyro-min()-Y
    ## 135                    tBodyGyro-min()-Z
    ## 136                      tBodyGyro-sma()
    ## 137                 tBodyGyro-energy()-X
    ## 138                 tBodyGyro-energy()-Y
    ## 139                 tBodyGyro-energy()-Z
    ## 140                    tBodyGyro-iqr()-X
    ## 141                    tBodyGyro-iqr()-Y
    ## 142                    tBodyGyro-iqr()-Z
    ## 143                tBodyGyro-entropy()-X
    ## 144                tBodyGyro-entropy()-Y
    ## 145                tBodyGyro-entropy()-Z
    ## 146              tBodyGyro-arCoeff()-X,1
    ## 147              tBodyGyro-arCoeff()-X,2
    ## 148              tBodyGyro-arCoeff()-X,3
    ## 149              tBodyGyro-arCoeff()-X,4
    ## 150              tBodyGyro-arCoeff()-Y,1
    ## 151              tBodyGyro-arCoeff()-Y,2
    ## 152              tBodyGyro-arCoeff()-Y,3
    ## 153              tBodyGyro-arCoeff()-Y,4
    ## 154              tBodyGyro-arCoeff()-Z,1
    ## 155              tBodyGyro-arCoeff()-Z,2
    ## 156              tBodyGyro-arCoeff()-Z,3
    ## 157              tBodyGyro-arCoeff()-Z,4
    ## 158          tBodyGyro-correlation()-X,Y
    ## 159          tBodyGyro-correlation()-X,Z
    ## 160          tBodyGyro-correlation()-Y,Z
    ## 161               tBodyGyroJerk-mean()-X
    ## 162               tBodyGyroJerk-mean()-Y
    ## 163               tBodyGyroJerk-mean()-Z
    ## 164                tBodyGyroJerk-std()-X
    ## 165                tBodyGyroJerk-std()-Y
    ## 166                tBodyGyroJerk-std()-Z
    ## 167                tBodyGyroJerk-mad()-X
    ## 168                tBodyGyroJerk-mad()-Y
    ## 169                tBodyGyroJerk-mad()-Z
    ## 170                tBodyGyroJerk-max()-X
    ## 171                tBodyGyroJerk-max()-Y
    ## 172                tBodyGyroJerk-max()-Z
    ## 173                tBodyGyroJerk-min()-X
    ## 174                tBodyGyroJerk-min()-Y
    ## 175                tBodyGyroJerk-min()-Z
    ## 176                  tBodyGyroJerk-sma()
    ## 177             tBodyGyroJerk-energy()-X
    ## 178             tBodyGyroJerk-energy()-Y
    ## 179             tBodyGyroJerk-energy()-Z
    ## 180                tBodyGyroJerk-iqr()-X
    ## 181                tBodyGyroJerk-iqr()-Y
    ## 182                tBodyGyroJerk-iqr()-Z
    ## 183            tBodyGyroJerk-entropy()-X
    ## 184            tBodyGyroJerk-entropy()-Y
    ## 185            tBodyGyroJerk-entropy()-Z
    ## 186          tBodyGyroJerk-arCoeff()-X,1
    ## 187          tBodyGyroJerk-arCoeff()-X,2
    ## 188          tBodyGyroJerk-arCoeff()-X,3
    ## 189          tBodyGyroJerk-arCoeff()-X,4
    ## 190          tBodyGyroJerk-arCoeff()-Y,1
    ## 191          tBodyGyroJerk-arCoeff()-Y,2
    ## 192          tBodyGyroJerk-arCoeff()-Y,3
    ## 193          tBodyGyroJerk-arCoeff()-Y,4
    ## 194          tBodyGyroJerk-arCoeff()-Z,1
    ## 195          tBodyGyroJerk-arCoeff()-Z,2
    ## 196          tBodyGyroJerk-arCoeff()-Z,3
    ## 197          tBodyGyroJerk-arCoeff()-Z,4
    ## 198      tBodyGyroJerk-correlation()-X,Y
    ## 199      tBodyGyroJerk-correlation()-X,Z
    ## 200      tBodyGyroJerk-correlation()-Y,Z
    ## 201                   tBodyAccMag-mean()
    ## 202                    tBodyAccMag-std()
    ## 203                    tBodyAccMag-mad()
    ## 204                    tBodyAccMag-max()
    ## 205                    tBodyAccMag-min()
    ## 206                    tBodyAccMag-sma()
    ## 207                 tBodyAccMag-energy()
    ## 208                    tBodyAccMag-iqr()
    ## 209                tBodyAccMag-entropy()
    ## 210               tBodyAccMag-arCoeff()1
    ## 211               tBodyAccMag-arCoeff()2
    ## 212               tBodyAccMag-arCoeff()3
    ## 213               tBodyAccMag-arCoeff()4
    ## 214                tGravityAccMag-mean()
    ## 215                 tGravityAccMag-std()
    ## 216                 tGravityAccMag-mad()
    ## 217                 tGravityAccMag-max()
    ## 218                 tGravityAccMag-min()
    ## 219                 tGravityAccMag-sma()
    ## 220              tGravityAccMag-energy()
    ## 221                 tGravityAccMag-iqr()
    ## 222             tGravityAccMag-entropy()
    ## 223            tGravityAccMag-arCoeff()1
    ## 224            tGravityAccMag-arCoeff()2
    ## 225            tGravityAccMag-arCoeff()3
    ## 226            tGravityAccMag-arCoeff()4
    ## 227               tBodyAccJerkMag-mean()
    ## 228                tBodyAccJerkMag-std()
    ## 229                tBodyAccJerkMag-mad()
    ## 230                tBodyAccJerkMag-max()
    ## 231                tBodyAccJerkMag-min()
    ## 232                tBodyAccJerkMag-sma()
    ## 233             tBodyAccJerkMag-energy()
    ## 234                tBodyAccJerkMag-iqr()
    ## 235            tBodyAccJerkMag-entropy()
    ## 236           tBodyAccJerkMag-arCoeff()1
    ## 237           tBodyAccJerkMag-arCoeff()2
    ## 238           tBodyAccJerkMag-arCoeff()3
    ## 239           tBodyAccJerkMag-arCoeff()4
    ## 240                  tBodyGyroMag-mean()
    ## 241                   tBodyGyroMag-std()
    ## 242                   tBodyGyroMag-mad()
    ## 243                   tBodyGyroMag-max()
    ## 244                   tBodyGyroMag-min()
    ## 245                   tBodyGyroMag-sma()
    ## 246                tBodyGyroMag-energy()
    ## 247                   tBodyGyroMag-iqr()
    ## 248               tBodyGyroMag-entropy()
    ## 249              tBodyGyroMag-arCoeff()1
    ## 250              tBodyGyroMag-arCoeff()2
    ## 251              tBodyGyroMag-arCoeff()3
    ## 252              tBodyGyroMag-arCoeff()4
    ## 253              tBodyGyroJerkMag-mean()
    ## 254               tBodyGyroJerkMag-std()
    ## 255               tBodyGyroJerkMag-mad()
    ## 256               tBodyGyroJerkMag-max()
    ## 257               tBodyGyroJerkMag-min()
    ## 258               tBodyGyroJerkMag-sma()
    ## 259            tBodyGyroJerkMag-energy()
    ## 260               tBodyGyroJerkMag-iqr()
    ## 261           tBodyGyroJerkMag-entropy()
    ## 262          tBodyGyroJerkMag-arCoeff()1
    ## 263          tBodyGyroJerkMag-arCoeff()2
    ## 264          tBodyGyroJerkMag-arCoeff()3
    ## 265          tBodyGyroJerkMag-arCoeff()4
    ## 266                    fBodyAcc-mean()-X
    ## 267                    fBodyAcc-mean()-Y
    ## 268                    fBodyAcc-mean()-Z
    ## 269                     fBodyAcc-std()-X
    ## 270                     fBodyAcc-std()-Y
    ## 271                     fBodyAcc-std()-Z
    ## 272                     fBodyAcc-mad()-X
    ## 273                     fBodyAcc-mad()-Y
    ## 274                     fBodyAcc-mad()-Z
    ## 275                     fBodyAcc-max()-X
    ## 276                     fBodyAcc-max()-Y
    ## 277                     fBodyAcc-max()-Z
    ## 278                     fBodyAcc-min()-X
    ## 279                     fBodyAcc-min()-Y
    ## 280                     fBodyAcc-min()-Z
    ## 281                       fBodyAcc-sma()
    ## 282                  fBodyAcc-energy()-X
    ## 283                  fBodyAcc-energy()-Y
    ## 284                  fBodyAcc-energy()-Z
    ## 285                     fBodyAcc-iqr()-X
    ## 286                     fBodyAcc-iqr()-Y
    ## 287                     fBodyAcc-iqr()-Z
    ## 288                 fBodyAcc-entropy()-X
    ## 289                 fBodyAcc-entropy()-Y
    ## 290                 fBodyAcc-entropy()-Z
    ## 291                 fBodyAcc-maxInds()-X
    ## 292                 fBodyAcc-maxInds()-Y
    ## 293                 fBodyAcc-maxInds()-Z
    ## 294                fBodyAcc-meanFreq()-X
    ## 295                fBodyAcc-meanFreq()-Y
    ## 296                fBodyAcc-meanFreq()-Z
    ## 297                fBodyAcc-skewness()-X
    ## 298                fBodyAcc-kurtosis()-X
    ## 299                fBodyAcc-skewness()-Y
    ## 300                fBodyAcc-kurtosis()-Y
    ## 301                fBodyAcc-skewness()-Z
    ## 302                fBodyAcc-kurtosis()-Z
    ## 303           fBodyAcc-bandsEnergy()-1,8
    ## 304          fBodyAcc-bandsEnergy()-9,16
    ## 305         fBodyAcc-bandsEnergy()-17,24
    ## 306         fBodyAcc-bandsEnergy()-25,32
    ## 307         fBodyAcc-bandsEnergy()-33,40
    ## 308         fBodyAcc-bandsEnergy()-41,48
    ## 309         fBodyAcc-bandsEnergy()-49,56
    ## 310         fBodyAcc-bandsEnergy()-57,64
    ## 311          fBodyAcc-bandsEnergy()-1,16
    ## 312         fBodyAcc-bandsEnergy()-17,32
    ## 313         fBodyAcc-bandsEnergy()-33,48
    ## 314         fBodyAcc-bandsEnergy()-49,64
    ## 315          fBodyAcc-bandsEnergy()-1,24
    ## 316         fBodyAcc-bandsEnergy()-25,48
    ## 317           fBodyAcc-bandsEnergy()-1,8
    ## 318          fBodyAcc-bandsEnergy()-9,16
    ## 319         fBodyAcc-bandsEnergy()-17,24
    ## 320         fBodyAcc-bandsEnergy()-25,32
    ## 321         fBodyAcc-bandsEnergy()-33,40
    ## 322         fBodyAcc-bandsEnergy()-41,48
    ## 323         fBodyAcc-bandsEnergy()-49,56
    ## 324         fBodyAcc-bandsEnergy()-57,64
    ## 325          fBodyAcc-bandsEnergy()-1,16
    ## 326         fBodyAcc-bandsEnergy()-17,32
    ## 327         fBodyAcc-bandsEnergy()-33,48
    ## 328         fBodyAcc-bandsEnergy()-49,64
    ## 329          fBodyAcc-bandsEnergy()-1,24
    ## 330         fBodyAcc-bandsEnergy()-25,48
    ## 331           fBodyAcc-bandsEnergy()-1,8
    ## 332          fBodyAcc-bandsEnergy()-9,16
    ## 333         fBodyAcc-bandsEnergy()-17,24
    ## 334         fBodyAcc-bandsEnergy()-25,32
    ## 335         fBodyAcc-bandsEnergy()-33,40
    ## 336         fBodyAcc-bandsEnergy()-41,48
    ## 337         fBodyAcc-bandsEnergy()-49,56
    ## 338         fBodyAcc-bandsEnergy()-57,64
    ## 339          fBodyAcc-bandsEnergy()-1,16
    ## 340         fBodyAcc-bandsEnergy()-17,32
    ## 341         fBodyAcc-bandsEnergy()-33,48
    ## 342         fBodyAcc-bandsEnergy()-49,64
    ## 343          fBodyAcc-bandsEnergy()-1,24
    ## 344         fBodyAcc-bandsEnergy()-25,48
    ## 345                fBodyAccJerk-mean()-X
    ## 346                fBodyAccJerk-mean()-Y
    ## 347                fBodyAccJerk-mean()-Z
    ## 348                 fBodyAccJerk-std()-X
    ## 349                 fBodyAccJerk-std()-Y
    ## 350                 fBodyAccJerk-std()-Z
    ## 351                 fBodyAccJerk-mad()-X
    ## 352                 fBodyAccJerk-mad()-Y
    ## 353                 fBodyAccJerk-mad()-Z
    ## 354                 fBodyAccJerk-max()-X
    ## 355                 fBodyAccJerk-max()-Y
    ## 356                 fBodyAccJerk-max()-Z
    ## 357                 fBodyAccJerk-min()-X
    ## 358                 fBodyAccJerk-min()-Y
    ## 359                 fBodyAccJerk-min()-Z
    ## 360                   fBodyAccJerk-sma()
    ## 361              fBodyAccJerk-energy()-X
    ## 362              fBodyAccJerk-energy()-Y
    ## 363              fBodyAccJerk-energy()-Z
    ## 364                 fBodyAccJerk-iqr()-X
    ## 365                 fBodyAccJerk-iqr()-Y
    ## 366                 fBodyAccJerk-iqr()-Z
    ## 367             fBodyAccJerk-entropy()-X
    ## 368             fBodyAccJerk-entropy()-Y
    ## 369             fBodyAccJerk-entropy()-Z
    ## 370             fBodyAccJerk-maxInds()-X
    ## 371             fBodyAccJerk-maxInds()-Y
    ## 372             fBodyAccJerk-maxInds()-Z
    ## 373            fBodyAccJerk-meanFreq()-X
    ## 374            fBodyAccJerk-meanFreq()-Y
    ## 375            fBodyAccJerk-meanFreq()-Z
    ## 376            fBodyAccJerk-skewness()-X
    ## 377            fBodyAccJerk-kurtosis()-X
    ## 378            fBodyAccJerk-skewness()-Y
    ## 379            fBodyAccJerk-kurtosis()-Y
    ## 380            fBodyAccJerk-skewness()-Z
    ## 381            fBodyAccJerk-kurtosis()-Z
    ## 382       fBodyAccJerk-bandsEnergy()-1,8
    ## 383      fBodyAccJerk-bandsEnergy()-9,16
    ## 384     fBodyAccJerk-bandsEnergy()-17,24
    ## 385     fBodyAccJerk-bandsEnergy()-25,32
    ## 386     fBodyAccJerk-bandsEnergy()-33,40
    ## 387     fBodyAccJerk-bandsEnergy()-41,48
    ## 388     fBodyAccJerk-bandsEnergy()-49,56
    ## 389     fBodyAccJerk-bandsEnergy()-57,64
    ## 390      fBodyAccJerk-bandsEnergy()-1,16
    ## 391     fBodyAccJerk-bandsEnergy()-17,32
    ## 392     fBodyAccJerk-bandsEnergy()-33,48
    ## 393     fBodyAccJerk-bandsEnergy()-49,64
    ## 394      fBodyAccJerk-bandsEnergy()-1,24
    ## 395     fBodyAccJerk-bandsEnergy()-25,48
    ## 396       fBodyAccJerk-bandsEnergy()-1,8
    ## 397      fBodyAccJerk-bandsEnergy()-9,16
    ## 398     fBodyAccJerk-bandsEnergy()-17,24
    ## 399     fBodyAccJerk-bandsEnergy()-25,32
    ## 400     fBodyAccJerk-bandsEnergy()-33,40
    ## 401     fBodyAccJerk-bandsEnergy()-41,48
    ## 402     fBodyAccJerk-bandsEnergy()-49,56
    ## 403     fBodyAccJerk-bandsEnergy()-57,64
    ## 404      fBodyAccJerk-bandsEnergy()-1,16
    ## 405     fBodyAccJerk-bandsEnergy()-17,32
    ## 406     fBodyAccJerk-bandsEnergy()-33,48
    ## 407     fBodyAccJerk-bandsEnergy()-49,64
    ## 408      fBodyAccJerk-bandsEnergy()-1,24
    ## 409     fBodyAccJerk-bandsEnergy()-25,48
    ## 410       fBodyAccJerk-bandsEnergy()-1,8
    ## 411      fBodyAccJerk-bandsEnergy()-9,16
    ## 412     fBodyAccJerk-bandsEnergy()-17,24
    ## 413     fBodyAccJerk-bandsEnergy()-25,32
    ## 414     fBodyAccJerk-bandsEnergy()-33,40
    ## 415     fBodyAccJerk-bandsEnergy()-41,48
    ## 416     fBodyAccJerk-bandsEnergy()-49,56
    ## 417     fBodyAccJerk-bandsEnergy()-57,64
    ## 418      fBodyAccJerk-bandsEnergy()-1,16
    ## 419     fBodyAccJerk-bandsEnergy()-17,32
    ## 420     fBodyAccJerk-bandsEnergy()-33,48
    ## 421     fBodyAccJerk-bandsEnergy()-49,64
    ## 422      fBodyAccJerk-bandsEnergy()-1,24
    ## 423     fBodyAccJerk-bandsEnergy()-25,48
    ## 424                   fBodyGyro-mean()-X
    ## 425                   fBodyGyro-mean()-Y
    ## 426                   fBodyGyro-mean()-Z
    ## 427                    fBodyGyro-std()-X
    ## 428                    fBodyGyro-std()-Y
    ## 429                    fBodyGyro-std()-Z
    ## 430                    fBodyGyro-mad()-X
    ## 431                    fBodyGyro-mad()-Y
    ## 432                    fBodyGyro-mad()-Z
    ## 433                    fBodyGyro-max()-X
    ## 434                    fBodyGyro-max()-Y
    ## 435                    fBodyGyro-max()-Z
    ## 436                    fBodyGyro-min()-X
    ## 437                    fBodyGyro-min()-Y
    ## 438                    fBodyGyro-min()-Z
    ## 439                      fBodyGyro-sma()
    ## 440                 fBodyGyro-energy()-X
    ## 441                 fBodyGyro-energy()-Y
    ## 442                 fBodyGyro-energy()-Z
    ## 443                    fBodyGyro-iqr()-X
    ## 444                    fBodyGyro-iqr()-Y
    ## 445                    fBodyGyro-iqr()-Z
    ## 446                fBodyGyro-entropy()-X
    ## 447                fBodyGyro-entropy()-Y
    ## 448                fBodyGyro-entropy()-Z
    ## 449                fBodyGyro-maxInds()-X
    ## 450                fBodyGyro-maxInds()-Y
    ## 451                fBodyGyro-maxInds()-Z
    ## 452               fBodyGyro-meanFreq()-X
    ## 453               fBodyGyro-meanFreq()-Y
    ## 454               fBodyGyro-meanFreq()-Z
    ## 455               fBodyGyro-skewness()-X
    ## 456               fBodyGyro-kurtosis()-X
    ## 457               fBodyGyro-skewness()-Y
    ## 458               fBodyGyro-kurtosis()-Y
    ## 459               fBodyGyro-skewness()-Z
    ## 460               fBodyGyro-kurtosis()-Z
    ## 461          fBodyGyro-bandsEnergy()-1,8
    ## 462         fBodyGyro-bandsEnergy()-9,16
    ## 463        fBodyGyro-bandsEnergy()-17,24
    ## 464        fBodyGyro-bandsEnergy()-25,32
    ## 465        fBodyGyro-bandsEnergy()-33,40
    ## 466        fBodyGyro-bandsEnergy()-41,48
    ## 467        fBodyGyro-bandsEnergy()-49,56
    ## 468        fBodyGyro-bandsEnergy()-57,64
    ## 469         fBodyGyro-bandsEnergy()-1,16
    ## 470        fBodyGyro-bandsEnergy()-17,32
    ## 471        fBodyGyro-bandsEnergy()-33,48
    ## 472        fBodyGyro-bandsEnergy()-49,64
    ## 473         fBodyGyro-bandsEnergy()-1,24
    ## 474        fBodyGyro-bandsEnergy()-25,48
    ## 475          fBodyGyro-bandsEnergy()-1,8
    ## 476         fBodyGyro-bandsEnergy()-9,16
    ## 477        fBodyGyro-bandsEnergy()-17,24
    ## 478        fBodyGyro-bandsEnergy()-25,32
    ## 479        fBodyGyro-bandsEnergy()-33,40
    ## 480        fBodyGyro-bandsEnergy()-41,48
    ## 481        fBodyGyro-bandsEnergy()-49,56
    ## 482        fBodyGyro-bandsEnergy()-57,64
    ## 483         fBodyGyro-bandsEnergy()-1,16
    ## 484        fBodyGyro-bandsEnergy()-17,32
    ## 485        fBodyGyro-bandsEnergy()-33,48
    ## 486        fBodyGyro-bandsEnergy()-49,64
    ## 487         fBodyGyro-bandsEnergy()-1,24
    ## 488        fBodyGyro-bandsEnergy()-25,48
    ## 489          fBodyGyro-bandsEnergy()-1,8
    ## 490         fBodyGyro-bandsEnergy()-9,16
    ## 491        fBodyGyro-bandsEnergy()-17,24
    ## 492        fBodyGyro-bandsEnergy()-25,32
    ## 493        fBodyGyro-bandsEnergy()-33,40
    ## 494        fBodyGyro-bandsEnergy()-41,48
    ## 495        fBodyGyro-bandsEnergy()-49,56
    ## 496        fBodyGyro-bandsEnergy()-57,64
    ## 497         fBodyGyro-bandsEnergy()-1,16
    ## 498        fBodyGyro-bandsEnergy()-17,32
    ## 499        fBodyGyro-bandsEnergy()-33,48
    ## 500        fBodyGyro-bandsEnergy()-49,64
    ## 501         fBodyGyro-bandsEnergy()-1,24
    ## 502        fBodyGyro-bandsEnergy()-25,48
    ## 503                   fBodyAccMag-mean()
    ## 504                    fBodyAccMag-std()
    ## 505                    fBodyAccMag-mad()
    ## 506                    fBodyAccMag-max()
    ## 507                    fBodyAccMag-min()
    ## 508                    fBodyAccMag-sma()
    ## 509                 fBodyAccMag-energy()
    ## 510                    fBodyAccMag-iqr()
    ## 511                fBodyAccMag-entropy()
    ## 512                fBodyAccMag-maxInds()
    ## 513               fBodyAccMag-meanFreq()
    ## 514               fBodyAccMag-skewness()
    ## 515               fBodyAccMag-kurtosis()
    ## 516               fBodyAccJerkMag-mean()
    ## 517                fBodyAccJerkMag-std()
    ## 518                fBodyAccJerkMag-mad()
    ## 519                fBodyAccJerkMag-max()
    ## 520                fBodyAccJerkMag-min()
    ## 521                fBodyAccJerkMag-sma()
    ## 522             fBodyAccJerkMag-energy()
    ## 523                fBodyAccJerkMag-iqr()
    ## 524            fBodyAccJerkMag-entropy()
    ## 525            fBodyAccJerkMag-maxInds()
    ## 526           fBodyAccJerkMag-meanFreq()
    ## 527           fBodyAccJerkMag-skewness()
    ## 528           fBodyAccJerkMag-kurtosis()
    ## 529                  fBodyGyroMag-mean()
    ## 530                   fBodyGyroMag-std()
    ## 531                   fBodyGyroMag-mad()
    ## 532                   fBodyGyroMag-max()
    ## 533                   fBodyGyroMag-min()
    ## 534                   fBodyGyroMag-sma()
    ## 535                fBodyGyroMag-energy()
    ## 536                   fBodyGyroMag-iqr()
    ## 537               fBodyGyroMag-entropy()
    ## 538               fBodyGyroMag-maxInds()
    ## 539              fBodyGyroMag-meanFreq()
    ## 540              fBodyGyroMag-skewness()
    ## 541              fBodyGyroMag-kurtosis()
    ## 542              fBodyGyroJerkMag-mean()
    ## 543               fBodyGyroJerkMag-std()
    ## 544               fBodyGyroJerkMag-mad()
    ## 545               fBodyGyroJerkMag-max()
    ## 546               fBodyGyroJerkMag-min()
    ## 547               fBodyGyroJerkMag-sma()
    ## 548            fBodyGyroJerkMag-energy()
    ## 549               fBodyGyroJerkMag-iqr()
    ## 550           fBodyGyroJerkMag-entropy()
    ## 551           fBodyGyroJerkMag-maxInds()
    ## 552          fBodyGyroJerkMag-meanFreq()
    ## 553          fBodyGyroJerkMag-skewness()
    ## 554          fBodyGyroJerkMag-kurtosis()
    ## 555          angle(tBodyAccMean,gravity)
    ## 556  angle(tBodyAccJerkMean,gravityMean)
    ## 557     angle(tBodyGyroMean,gravityMean)
    ## 558 angle(tBodyGyroJerkMean,gravityMean)
    ## 559                 angle(X,gravityMean)
    ## 560                 angle(Y,gravityMean)
    ## 561                 angle(Z,gravityMean)

Features recomposition validation
---------------------------------

``` r
features %>%
    unite(recomposition, sep = "", everything(), -id, -name, -axesSep, -axes) %>%
    select(name,recomposition) %>%
    filter(name != recomposition)
```

    ## [1] name          recomposition
    ## <0 rows> (or 0-length row.names)

Join features to statistics to get the description
--------------------------------------------------

``` r
features %>%
    select(id, name, statistic) %>%
    mutate(statistic = paste0(statistic,"()")) %>%
    #distinct() %>%
    left_join(statistics, by = c("statistic"="name"))
```

    ##      id                                 name     statistic
    ## 1     1                    tBodyAcc-mean()-X        mean()
    ## 2     2                    tBodyAcc-mean()-Y        mean()
    ## 3     3                    tBodyAcc-mean()-Z        mean()
    ## 4     4                     tBodyAcc-std()-X         std()
    ## 5     5                     tBodyAcc-std()-Y         std()
    ## 6     6                     tBodyAcc-std()-Z         std()
    ## 7     7                     tBodyAcc-mad()-X         mad()
    ## 8     8                     tBodyAcc-mad()-Y         mad()
    ## 9     9                     tBodyAcc-mad()-Z         mad()
    ## 10   10                     tBodyAcc-max()-X         max()
    ## 11   11                     tBodyAcc-max()-Y         max()
    ## 12   12                     tBodyAcc-max()-Z         max()
    ## 13   13                     tBodyAcc-min()-X         min()
    ## 14   14                     tBodyAcc-min()-Y         min()
    ## 15   15                     tBodyAcc-min()-Z         min()
    ## 16   16                       tBodyAcc-sma()         sma()
    ## 17   17                  tBodyAcc-energy()-X      energy()
    ## 18   18                  tBodyAcc-energy()-Y      energy()
    ## 19   19                  tBodyAcc-energy()-Z      energy()
    ## 20   20                     tBodyAcc-iqr()-X         iqr()
    ## 21   21                     tBodyAcc-iqr()-Y         iqr()
    ## 22   22                     tBodyAcc-iqr()-Z         iqr()
    ## 23   23                 tBodyAcc-entropy()-X     entropy()
    ## 24   24                 tBodyAcc-entropy()-Y     entropy()
    ## 25   25                 tBodyAcc-entropy()-Z     entropy()
    ## 26   26               tBodyAcc-arCoeff()-X,1     arCoeff()
    ## 27   27               tBodyAcc-arCoeff()-X,2     arCoeff()
    ## 28   28               tBodyAcc-arCoeff()-X,3     arCoeff()
    ## 29   29               tBodyAcc-arCoeff()-X,4     arCoeff()
    ## 30   30               tBodyAcc-arCoeff()-Y,1     arCoeff()
    ## 31   31               tBodyAcc-arCoeff()-Y,2     arCoeff()
    ## 32   32               tBodyAcc-arCoeff()-Y,3     arCoeff()
    ## 33   33               tBodyAcc-arCoeff()-Y,4     arCoeff()
    ## 34   34               tBodyAcc-arCoeff()-Z,1     arCoeff()
    ## 35   35               tBodyAcc-arCoeff()-Z,2     arCoeff()
    ## 36   36               tBodyAcc-arCoeff()-Z,3     arCoeff()
    ## 37   37               tBodyAcc-arCoeff()-Z,4     arCoeff()
    ## 38   38           tBodyAcc-correlation()-X,Y correlation()
    ## 39   39           tBodyAcc-correlation()-X,Z correlation()
    ## 40   40           tBodyAcc-correlation()-Y,Z correlation()
    ## 41   41                 tGravityAcc-mean()-X        mean()
    ## 42   42                 tGravityAcc-mean()-Y        mean()
    ## 43   43                 tGravityAcc-mean()-Z        mean()
    ## 44   44                  tGravityAcc-std()-X         std()
    ## 45   45                  tGravityAcc-std()-Y         std()
    ## 46   46                  tGravityAcc-std()-Z         std()
    ## 47   47                  tGravityAcc-mad()-X         mad()
    ## 48   48                  tGravityAcc-mad()-Y         mad()
    ## 49   49                  tGravityAcc-mad()-Z         mad()
    ## 50   50                  tGravityAcc-max()-X         max()
    ## 51   51                  tGravityAcc-max()-Y         max()
    ## 52   52                  tGravityAcc-max()-Z         max()
    ## 53   53                  tGravityAcc-min()-X         min()
    ## 54   54                  tGravityAcc-min()-Y         min()
    ## 55   55                  tGravityAcc-min()-Z         min()
    ## 56   56                    tGravityAcc-sma()         sma()
    ## 57   57               tGravityAcc-energy()-X      energy()
    ## 58   58               tGravityAcc-energy()-Y      energy()
    ## 59   59               tGravityAcc-energy()-Z      energy()
    ## 60   60                  tGravityAcc-iqr()-X         iqr()
    ## 61   61                  tGravityAcc-iqr()-Y         iqr()
    ## 62   62                  tGravityAcc-iqr()-Z         iqr()
    ## 63   63              tGravityAcc-entropy()-X     entropy()
    ## 64   64              tGravityAcc-entropy()-Y     entropy()
    ## 65   65              tGravityAcc-entropy()-Z     entropy()
    ## 66   66            tGravityAcc-arCoeff()-X,1     arCoeff()
    ## 67   67            tGravityAcc-arCoeff()-X,2     arCoeff()
    ## 68   68            tGravityAcc-arCoeff()-X,3     arCoeff()
    ## 69   69            tGravityAcc-arCoeff()-X,4     arCoeff()
    ## 70   70            tGravityAcc-arCoeff()-Y,1     arCoeff()
    ## 71   71            tGravityAcc-arCoeff()-Y,2     arCoeff()
    ## 72   72            tGravityAcc-arCoeff()-Y,3     arCoeff()
    ## 73   73            tGravityAcc-arCoeff()-Y,4     arCoeff()
    ## 74   74            tGravityAcc-arCoeff()-Z,1     arCoeff()
    ## 75   75            tGravityAcc-arCoeff()-Z,2     arCoeff()
    ## 76   76            tGravityAcc-arCoeff()-Z,3     arCoeff()
    ## 77   77            tGravityAcc-arCoeff()-Z,4     arCoeff()
    ## 78   78        tGravityAcc-correlation()-X,Y correlation()
    ## 79   79        tGravityAcc-correlation()-X,Z correlation()
    ## 80   80        tGravityAcc-correlation()-Y,Z correlation()
    ## 81   81                tBodyAccJerk-mean()-X        mean()
    ## 82   82                tBodyAccJerk-mean()-Y        mean()
    ## 83   83                tBodyAccJerk-mean()-Z        mean()
    ## 84   84                 tBodyAccJerk-std()-X         std()
    ## 85   85                 tBodyAccJerk-std()-Y         std()
    ## 86   86                 tBodyAccJerk-std()-Z         std()
    ## 87   87                 tBodyAccJerk-mad()-X         mad()
    ## 88   88                 tBodyAccJerk-mad()-Y         mad()
    ## 89   89                 tBodyAccJerk-mad()-Z         mad()
    ## 90   90                 tBodyAccJerk-max()-X         max()
    ## 91   91                 tBodyAccJerk-max()-Y         max()
    ## 92   92                 tBodyAccJerk-max()-Z         max()
    ## 93   93                 tBodyAccJerk-min()-X         min()
    ## 94   94                 tBodyAccJerk-min()-Y         min()
    ## 95   95                 tBodyAccJerk-min()-Z         min()
    ## 96   96                   tBodyAccJerk-sma()         sma()
    ## 97   97              tBodyAccJerk-energy()-X      energy()
    ## 98   98              tBodyAccJerk-energy()-Y      energy()
    ## 99   99              tBodyAccJerk-energy()-Z      energy()
    ## 100 100                 tBodyAccJerk-iqr()-X         iqr()
    ## 101 101                 tBodyAccJerk-iqr()-Y         iqr()
    ## 102 102                 tBodyAccJerk-iqr()-Z         iqr()
    ## 103 103             tBodyAccJerk-entropy()-X     entropy()
    ## 104 104             tBodyAccJerk-entropy()-Y     entropy()
    ## 105 105             tBodyAccJerk-entropy()-Z     entropy()
    ## 106 106           tBodyAccJerk-arCoeff()-X,1     arCoeff()
    ## 107 107           tBodyAccJerk-arCoeff()-X,2     arCoeff()
    ## 108 108           tBodyAccJerk-arCoeff()-X,3     arCoeff()
    ## 109 109           tBodyAccJerk-arCoeff()-X,4     arCoeff()
    ## 110 110           tBodyAccJerk-arCoeff()-Y,1     arCoeff()
    ## 111 111           tBodyAccJerk-arCoeff()-Y,2     arCoeff()
    ## 112 112           tBodyAccJerk-arCoeff()-Y,3     arCoeff()
    ## 113 113           tBodyAccJerk-arCoeff()-Y,4     arCoeff()
    ## 114 114           tBodyAccJerk-arCoeff()-Z,1     arCoeff()
    ## 115 115           tBodyAccJerk-arCoeff()-Z,2     arCoeff()
    ## 116 116           tBodyAccJerk-arCoeff()-Z,3     arCoeff()
    ## 117 117           tBodyAccJerk-arCoeff()-Z,4     arCoeff()
    ## 118 118       tBodyAccJerk-correlation()-X,Y correlation()
    ## 119 119       tBodyAccJerk-correlation()-X,Z correlation()
    ## 120 120       tBodyAccJerk-correlation()-Y,Z correlation()
    ## 121 121                   tBodyGyro-mean()-X        mean()
    ## 122 122                   tBodyGyro-mean()-Y        mean()
    ## 123 123                   tBodyGyro-mean()-Z        mean()
    ## 124 124                    tBodyGyro-std()-X         std()
    ## 125 125                    tBodyGyro-std()-Y         std()
    ## 126 126                    tBodyGyro-std()-Z         std()
    ## 127 127                    tBodyGyro-mad()-X         mad()
    ## 128 128                    tBodyGyro-mad()-Y         mad()
    ## 129 129                    tBodyGyro-mad()-Z         mad()
    ## 130 130                    tBodyGyro-max()-X         max()
    ## 131 131                    tBodyGyro-max()-Y         max()
    ## 132 132                    tBodyGyro-max()-Z         max()
    ## 133 133                    tBodyGyro-min()-X         min()
    ## 134 134                    tBodyGyro-min()-Y         min()
    ## 135 135                    tBodyGyro-min()-Z         min()
    ## 136 136                      tBodyGyro-sma()         sma()
    ## 137 137                 tBodyGyro-energy()-X      energy()
    ## 138 138                 tBodyGyro-energy()-Y      energy()
    ## 139 139                 tBodyGyro-energy()-Z      energy()
    ## 140 140                    tBodyGyro-iqr()-X         iqr()
    ## 141 141                    tBodyGyro-iqr()-Y         iqr()
    ## 142 142                    tBodyGyro-iqr()-Z         iqr()
    ## 143 143                tBodyGyro-entropy()-X     entropy()
    ## 144 144                tBodyGyro-entropy()-Y     entropy()
    ## 145 145                tBodyGyro-entropy()-Z     entropy()
    ## 146 146              tBodyGyro-arCoeff()-X,1     arCoeff()
    ## 147 147              tBodyGyro-arCoeff()-X,2     arCoeff()
    ## 148 148              tBodyGyro-arCoeff()-X,3     arCoeff()
    ## 149 149              tBodyGyro-arCoeff()-X,4     arCoeff()
    ## 150 150              tBodyGyro-arCoeff()-Y,1     arCoeff()
    ## 151 151              tBodyGyro-arCoeff()-Y,2     arCoeff()
    ## 152 152              tBodyGyro-arCoeff()-Y,3     arCoeff()
    ## 153 153              tBodyGyro-arCoeff()-Y,4     arCoeff()
    ## 154 154              tBodyGyro-arCoeff()-Z,1     arCoeff()
    ## 155 155              tBodyGyro-arCoeff()-Z,2     arCoeff()
    ## 156 156              tBodyGyro-arCoeff()-Z,3     arCoeff()
    ## 157 157              tBodyGyro-arCoeff()-Z,4     arCoeff()
    ## 158 158          tBodyGyro-correlation()-X,Y correlation()
    ## 159 159          tBodyGyro-correlation()-X,Z correlation()
    ## 160 160          tBodyGyro-correlation()-Y,Z correlation()
    ## 161 161               tBodyGyroJerk-mean()-X        mean()
    ## 162 162               tBodyGyroJerk-mean()-Y        mean()
    ## 163 163               tBodyGyroJerk-mean()-Z        mean()
    ## 164 164                tBodyGyroJerk-std()-X         std()
    ## 165 165                tBodyGyroJerk-std()-Y         std()
    ## 166 166                tBodyGyroJerk-std()-Z         std()
    ## 167 167                tBodyGyroJerk-mad()-X         mad()
    ## 168 168                tBodyGyroJerk-mad()-Y         mad()
    ## 169 169                tBodyGyroJerk-mad()-Z         mad()
    ## 170 170                tBodyGyroJerk-max()-X         max()
    ## 171 171                tBodyGyroJerk-max()-Y         max()
    ## 172 172                tBodyGyroJerk-max()-Z         max()
    ## 173 173                tBodyGyroJerk-min()-X         min()
    ## 174 174                tBodyGyroJerk-min()-Y         min()
    ## 175 175                tBodyGyroJerk-min()-Z         min()
    ## 176 176                  tBodyGyroJerk-sma()         sma()
    ## 177 177             tBodyGyroJerk-energy()-X      energy()
    ## 178 178             tBodyGyroJerk-energy()-Y      energy()
    ## 179 179             tBodyGyroJerk-energy()-Z      energy()
    ## 180 180                tBodyGyroJerk-iqr()-X         iqr()
    ## 181 181                tBodyGyroJerk-iqr()-Y         iqr()
    ## 182 182                tBodyGyroJerk-iqr()-Z         iqr()
    ## 183 183            tBodyGyroJerk-entropy()-X     entropy()
    ## 184 184            tBodyGyroJerk-entropy()-Y     entropy()
    ## 185 185            tBodyGyroJerk-entropy()-Z     entropy()
    ## 186 186          tBodyGyroJerk-arCoeff()-X,1     arCoeff()
    ## 187 187          tBodyGyroJerk-arCoeff()-X,2     arCoeff()
    ## 188 188          tBodyGyroJerk-arCoeff()-X,3     arCoeff()
    ## 189 189          tBodyGyroJerk-arCoeff()-X,4     arCoeff()
    ## 190 190          tBodyGyroJerk-arCoeff()-Y,1     arCoeff()
    ## 191 191          tBodyGyroJerk-arCoeff()-Y,2     arCoeff()
    ## 192 192          tBodyGyroJerk-arCoeff()-Y,3     arCoeff()
    ## 193 193          tBodyGyroJerk-arCoeff()-Y,4     arCoeff()
    ## 194 194          tBodyGyroJerk-arCoeff()-Z,1     arCoeff()
    ## 195 195          tBodyGyroJerk-arCoeff()-Z,2     arCoeff()
    ## 196 196          tBodyGyroJerk-arCoeff()-Z,3     arCoeff()
    ## 197 197          tBodyGyroJerk-arCoeff()-Z,4     arCoeff()
    ## 198 198      tBodyGyroJerk-correlation()-X,Y correlation()
    ## 199 199      tBodyGyroJerk-correlation()-X,Z correlation()
    ## 200 200      tBodyGyroJerk-correlation()-Y,Z correlation()
    ## 201 201                   tBodyAccMag-mean()        mean()
    ## 202 202                    tBodyAccMag-std()         std()
    ## 203 203                    tBodyAccMag-mad()         mad()
    ## 204 204                    tBodyAccMag-max()         max()
    ## 205 205                    tBodyAccMag-min()         min()
    ## 206 206                    tBodyAccMag-sma()         sma()
    ## 207 207                 tBodyAccMag-energy()      energy()
    ## 208 208                    tBodyAccMag-iqr()         iqr()
    ## 209 209                tBodyAccMag-entropy()     entropy()
    ## 210 210               tBodyAccMag-arCoeff()1     arCoeff()
    ## 211 211               tBodyAccMag-arCoeff()2     arCoeff()
    ## 212 212               tBodyAccMag-arCoeff()3     arCoeff()
    ## 213 213               tBodyAccMag-arCoeff()4     arCoeff()
    ## 214 214                tGravityAccMag-mean()        mean()
    ## 215 215                 tGravityAccMag-std()         std()
    ## 216 216                 tGravityAccMag-mad()         mad()
    ## 217 217                 tGravityAccMag-max()         max()
    ## 218 218                 tGravityAccMag-min()         min()
    ## 219 219                 tGravityAccMag-sma()         sma()
    ## 220 220              tGravityAccMag-energy()      energy()
    ## 221 221                 tGravityAccMag-iqr()         iqr()
    ## 222 222             tGravityAccMag-entropy()     entropy()
    ## 223 223            tGravityAccMag-arCoeff()1     arCoeff()
    ## 224 224            tGravityAccMag-arCoeff()2     arCoeff()
    ## 225 225            tGravityAccMag-arCoeff()3     arCoeff()
    ## 226 226            tGravityAccMag-arCoeff()4     arCoeff()
    ## 227 227               tBodyAccJerkMag-mean()        mean()
    ## 228 228                tBodyAccJerkMag-std()         std()
    ## 229 229                tBodyAccJerkMag-mad()         mad()
    ## 230 230                tBodyAccJerkMag-max()         max()
    ## 231 231                tBodyAccJerkMag-min()         min()
    ## 232 232                tBodyAccJerkMag-sma()         sma()
    ## 233 233             tBodyAccJerkMag-energy()      energy()
    ## 234 234                tBodyAccJerkMag-iqr()         iqr()
    ## 235 235            tBodyAccJerkMag-entropy()     entropy()
    ## 236 236           tBodyAccJerkMag-arCoeff()1     arCoeff()
    ## 237 237           tBodyAccJerkMag-arCoeff()2     arCoeff()
    ## 238 238           tBodyAccJerkMag-arCoeff()3     arCoeff()
    ## 239 239           tBodyAccJerkMag-arCoeff()4     arCoeff()
    ## 240 240                  tBodyGyroMag-mean()        mean()
    ## 241 241                   tBodyGyroMag-std()         std()
    ## 242 242                   tBodyGyroMag-mad()         mad()
    ## 243 243                   tBodyGyroMag-max()         max()
    ## 244 244                   tBodyGyroMag-min()         min()
    ## 245 245                   tBodyGyroMag-sma()         sma()
    ## 246 246                tBodyGyroMag-energy()      energy()
    ## 247 247                   tBodyGyroMag-iqr()         iqr()
    ## 248 248               tBodyGyroMag-entropy()     entropy()
    ## 249 249              tBodyGyroMag-arCoeff()1     arCoeff()
    ## 250 250              tBodyGyroMag-arCoeff()2     arCoeff()
    ## 251 251              tBodyGyroMag-arCoeff()3     arCoeff()
    ## 252 252              tBodyGyroMag-arCoeff()4     arCoeff()
    ## 253 253              tBodyGyroJerkMag-mean()        mean()
    ## 254 254               tBodyGyroJerkMag-std()         std()
    ## 255 255               tBodyGyroJerkMag-mad()         mad()
    ## 256 256               tBodyGyroJerkMag-max()         max()
    ## 257 257               tBodyGyroJerkMag-min()         min()
    ## 258 258               tBodyGyroJerkMag-sma()         sma()
    ## 259 259            tBodyGyroJerkMag-energy()      energy()
    ## 260 260               tBodyGyroJerkMag-iqr()         iqr()
    ## 261 261           tBodyGyroJerkMag-entropy()     entropy()
    ## 262 262          tBodyGyroJerkMag-arCoeff()1     arCoeff()
    ## 263 263          tBodyGyroJerkMag-arCoeff()2     arCoeff()
    ## 264 264          tBodyGyroJerkMag-arCoeff()3     arCoeff()
    ## 265 265          tBodyGyroJerkMag-arCoeff()4     arCoeff()
    ## 266 266                    fBodyAcc-mean()-X        mean()
    ## 267 267                    fBodyAcc-mean()-Y        mean()
    ## 268 268                    fBodyAcc-mean()-Z        mean()
    ## 269 269                     fBodyAcc-std()-X         std()
    ## 270 270                     fBodyAcc-std()-Y         std()
    ## 271 271                     fBodyAcc-std()-Z         std()
    ## 272 272                     fBodyAcc-mad()-X         mad()
    ## 273 273                     fBodyAcc-mad()-Y         mad()
    ## 274 274                     fBodyAcc-mad()-Z         mad()
    ## 275 275                     fBodyAcc-max()-X         max()
    ## 276 276                     fBodyAcc-max()-Y         max()
    ## 277 277                     fBodyAcc-max()-Z         max()
    ## 278 278                     fBodyAcc-min()-X         min()
    ## 279 279                     fBodyAcc-min()-Y         min()
    ## 280 280                     fBodyAcc-min()-Z         min()
    ## 281 281                       fBodyAcc-sma()         sma()
    ## 282 282                  fBodyAcc-energy()-X      energy()
    ## 283 283                  fBodyAcc-energy()-Y      energy()
    ## 284 284                  fBodyAcc-energy()-Z      energy()
    ## 285 285                     fBodyAcc-iqr()-X         iqr()
    ## 286 286                     fBodyAcc-iqr()-Y         iqr()
    ## 287 287                     fBodyAcc-iqr()-Z         iqr()
    ## 288 288                 fBodyAcc-entropy()-X     entropy()
    ## 289 289                 fBodyAcc-entropy()-Y     entropy()
    ## 290 290                 fBodyAcc-entropy()-Z     entropy()
    ## 291 291                 fBodyAcc-maxInds()-X     maxInds()
    ## 292 292                 fBodyAcc-maxInds()-Y     maxInds()
    ## 293 293                 fBodyAcc-maxInds()-Z     maxInds()
    ## 294 294                fBodyAcc-meanFreq()-X    meanFreq()
    ## 295 295                fBodyAcc-meanFreq()-Y    meanFreq()
    ## 296 296                fBodyAcc-meanFreq()-Z    meanFreq()
    ## 297 297                fBodyAcc-skewness()-X    skewness()
    ## 298 298                fBodyAcc-kurtosis()-X    kurtosis()
    ## 299 299                fBodyAcc-skewness()-Y    skewness()
    ## 300 300                fBodyAcc-kurtosis()-Y    kurtosis()
    ## 301 301                fBodyAcc-skewness()-Z    skewness()
    ## 302 302                fBodyAcc-kurtosis()-Z    kurtosis()
    ## 303 303           fBodyAcc-bandsEnergy()-1,8 bandsEnergy()
    ## 304 304          fBodyAcc-bandsEnergy()-9,16 bandsEnergy()
    ## 305 305         fBodyAcc-bandsEnergy()-17,24 bandsEnergy()
    ## 306 306         fBodyAcc-bandsEnergy()-25,32 bandsEnergy()
    ## 307 307         fBodyAcc-bandsEnergy()-33,40 bandsEnergy()
    ## 308 308         fBodyAcc-bandsEnergy()-41,48 bandsEnergy()
    ## 309 309         fBodyAcc-bandsEnergy()-49,56 bandsEnergy()
    ## 310 310         fBodyAcc-bandsEnergy()-57,64 bandsEnergy()
    ## 311 311          fBodyAcc-bandsEnergy()-1,16 bandsEnergy()
    ## 312 312         fBodyAcc-bandsEnergy()-17,32 bandsEnergy()
    ## 313 313         fBodyAcc-bandsEnergy()-33,48 bandsEnergy()
    ## 314 314         fBodyAcc-bandsEnergy()-49,64 bandsEnergy()
    ## 315 315          fBodyAcc-bandsEnergy()-1,24 bandsEnergy()
    ## 316 316         fBodyAcc-bandsEnergy()-25,48 bandsEnergy()
    ## 317 317           fBodyAcc-bandsEnergy()-1,8 bandsEnergy()
    ## 318 318          fBodyAcc-bandsEnergy()-9,16 bandsEnergy()
    ## 319 319         fBodyAcc-bandsEnergy()-17,24 bandsEnergy()
    ## 320 320         fBodyAcc-bandsEnergy()-25,32 bandsEnergy()
    ## 321 321         fBodyAcc-bandsEnergy()-33,40 bandsEnergy()
    ## 322 322         fBodyAcc-bandsEnergy()-41,48 bandsEnergy()
    ## 323 323         fBodyAcc-bandsEnergy()-49,56 bandsEnergy()
    ## 324 324         fBodyAcc-bandsEnergy()-57,64 bandsEnergy()
    ## 325 325          fBodyAcc-bandsEnergy()-1,16 bandsEnergy()
    ## 326 326         fBodyAcc-bandsEnergy()-17,32 bandsEnergy()
    ## 327 327         fBodyAcc-bandsEnergy()-33,48 bandsEnergy()
    ## 328 328         fBodyAcc-bandsEnergy()-49,64 bandsEnergy()
    ## 329 329          fBodyAcc-bandsEnergy()-1,24 bandsEnergy()
    ## 330 330         fBodyAcc-bandsEnergy()-25,48 bandsEnergy()
    ## 331 331           fBodyAcc-bandsEnergy()-1,8 bandsEnergy()
    ## 332 332          fBodyAcc-bandsEnergy()-9,16 bandsEnergy()
    ## 333 333         fBodyAcc-bandsEnergy()-17,24 bandsEnergy()
    ## 334 334         fBodyAcc-bandsEnergy()-25,32 bandsEnergy()
    ## 335 335         fBodyAcc-bandsEnergy()-33,40 bandsEnergy()
    ## 336 336         fBodyAcc-bandsEnergy()-41,48 bandsEnergy()
    ## 337 337         fBodyAcc-bandsEnergy()-49,56 bandsEnergy()
    ## 338 338         fBodyAcc-bandsEnergy()-57,64 bandsEnergy()
    ## 339 339          fBodyAcc-bandsEnergy()-1,16 bandsEnergy()
    ## 340 340         fBodyAcc-bandsEnergy()-17,32 bandsEnergy()
    ## 341 341         fBodyAcc-bandsEnergy()-33,48 bandsEnergy()
    ## 342 342         fBodyAcc-bandsEnergy()-49,64 bandsEnergy()
    ## 343 343          fBodyAcc-bandsEnergy()-1,24 bandsEnergy()
    ## 344 344         fBodyAcc-bandsEnergy()-25,48 bandsEnergy()
    ## 345 345                fBodyAccJerk-mean()-X        mean()
    ## 346 346                fBodyAccJerk-mean()-Y        mean()
    ## 347 347                fBodyAccJerk-mean()-Z        mean()
    ## 348 348                 fBodyAccJerk-std()-X         std()
    ## 349 349                 fBodyAccJerk-std()-Y         std()
    ## 350 350                 fBodyAccJerk-std()-Z         std()
    ## 351 351                 fBodyAccJerk-mad()-X         mad()
    ## 352 352                 fBodyAccJerk-mad()-Y         mad()
    ## 353 353                 fBodyAccJerk-mad()-Z         mad()
    ## 354 354                 fBodyAccJerk-max()-X         max()
    ## 355 355                 fBodyAccJerk-max()-Y         max()
    ## 356 356                 fBodyAccJerk-max()-Z         max()
    ## 357 357                 fBodyAccJerk-min()-X         min()
    ## 358 358                 fBodyAccJerk-min()-Y         min()
    ## 359 359                 fBodyAccJerk-min()-Z         min()
    ## 360 360                   fBodyAccJerk-sma()         sma()
    ## 361 361              fBodyAccJerk-energy()-X      energy()
    ## 362 362              fBodyAccJerk-energy()-Y      energy()
    ## 363 363              fBodyAccJerk-energy()-Z      energy()
    ## 364 364                 fBodyAccJerk-iqr()-X         iqr()
    ## 365 365                 fBodyAccJerk-iqr()-Y         iqr()
    ## 366 366                 fBodyAccJerk-iqr()-Z         iqr()
    ## 367 367             fBodyAccJerk-entropy()-X     entropy()
    ## 368 368             fBodyAccJerk-entropy()-Y     entropy()
    ## 369 369             fBodyAccJerk-entropy()-Z     entropy()
    ## 370 370             fBodyAccJerk-maxInds()-X     maxInds()
    ## 371 371             fBodyAccJerk-maxInds()-Y     maxInds()
    ## 372 372             fBodyAccJerk-maxInds()-Z     maxInds()
    ## 373 373            fBodyAccJerk-meanFreq()-X    meanFreq()
    ## 374 374            fBodyAccJerk-meanFreq()-Y    meanFreq()
    ## 375 375            fBodyAccJerk-meanFreq()-Z    meanFreq()
    ## 376 376            fBodyAccJerk-skewness()-X    skewness()
    ## 377 377            fBodyAccJerk-kurtosis()-X    kurtosis()
    ## 378 378            fBodyAccJerk-skewness()-Y    skewness()
    ## 379 379            fBodyAccJerk-kurtosis()-Y    kurtosis()
    ## 380 380            fBodyAccJerk-skewness()-Z    skewness()
    ## 381 381            fBodyAccJerk-kurtosis()-Z    kurtosis()
    ## 382 382       fBodyAccJerk-bandsEnergy()-1,8 bandsEnergy()
    ## 383 383      fBodyAccJerk-bandsEnergy()-9,16 bandsEnergy()
    ## 384 384     fBodyAccJerk-bandsEnergy()-17,24 bandsEnergy()
    ## 385 385     fBodyAccJerk-bandsEnergy()-25,32 bandsEnergy()
    ## 386 386     fBodyAccJerk-bandsEnergy()-33,40 bandsEnergy()
    ## 387 387     fBodyAccJerk-bandsEnergy()-41,48 bandsEnergy()
    ## 388 388     fBodyAccJerk-bandsEnergy()-49,56 bandsEnergy()
    ## 389 389     fBodyAccJerk-bandsEnergy()-57,64 bandsEnergy()
    ## 390 390      fBodyAccJerk-bandsEnergy()-1,16 bandsEnergy()
    ## 391 391     fBodyAccJerk-bandsEnergy()-17,32 bandsEnergy()
    ## 392 392     fBodyAccJerk-bandsEnergy()-33,48 bandsEnergy()
    ## 393 393     fBodyAccJerk-bandsEnergy()-49,64 bandsEnergy()
    ## 394 394      fBodyAccJerk-bandsEnergy()-1,24 bandsEnergy()
    ## 395 395     fBodyAccJerk-bandsEnergy()-25,48 bandsEnergy()
    ## 396 396       fBodyAccJerk-bandsEnergy()-1,8 bandsEnergy()
    ## 397 397      fBodyAccJerk-bandsEnergy()-9,16 bandsEnergy()
    ## 398 398     fBodyAccJerk-bandsEnergy()-17,24 bandsEnergy()
    ## 399 399     fBodyAccJerk-bandsEnergy()-25,32 bandsEnergy()
    ## 400 400     fBodyAccJerk-bandsEnergy()-33,40 bandsEnergy()
    ## 401 401     fBodyAccJerk-bandsEnergy()-41,48 bandsEnergy()
    ## 402 402     fBodyAccJerk-bandsEnergy()-49,56 bandsEnergy()
    ## 403 403     fBodyAccJerk-bandsEnergy()-57,64 bandsEnergy()
    ## 404 404      fBodyAccJerk-bandsEnergy()-1,16 bandsEnergy()
    ## 405 405     fBodyAccJerk-bandsEnergy()-17,32 bandsEnergy()
    ## 406 406     fBodyAccJerk-bandsEnergy()-33,48 bandsEnergy()
    ## 407 407     fBodyAccJerk-bandsEnergy()-49,64 bandsEnergy()
    ## 408 408      fBodyAccJerk-bandsEnergy()-1,24 bandsEnergy()
    ## 409 409     fBodyAccJerk-bandsEnergy()-25,48 bandsEnergy()
    ## 410 410       fBodyAccJerk-bandsEnergy()-1,8 bandsEnergy()
    ## 411 411      fBodyAccJerk-bandsEnergy()-9,16 bandsEnergy()
    ## 412 412     fBodyAccJerk-bandsEnergy()-17,24 bandsEnergy()
    ## 413 413     fBodyAccJerk-bandsEnergy()-25,32 bandsEnergy()
    ## 414 414     fBodyAccJerk-bandsEnergy()-33,40 bandsEnergy()
    ## 415 415     fBodyAccJerk-bandsEnergy()-41,48 bandsEnergy()
    ## 416 416     fBodyAccJerk-bandsEnergy()-49,56 bandsEnergy()
    ## 417 417     fBodyAccJerk-bandsEnergy()-57,64 bandsEnergy()
    ## 418 418      fBodyAccJerk-bandsEnergy()-1,16 bandsEnergy()
    ## 419 419     fBodyAccJerk-bandsEnergy()-17,32 bandsEnergy()
    ## 420 420     fBodyAccJerk-bandsEnergy()-33,48 bandsEnergy()
    ## 421 421     fBodyAccJerk-bandsEnergy()-49,64 bandsEnergy()
    ## 422 422      fBodyAccJerk-bandsEnergy()-1,24 bandsEnergy()
    ## 423 423     fBodyAccJerk-bandsEnergy()-25,48 bandsEnergy()
    ## 424 424                   fBodyGyro-mean()-X        mean()
    ## 425 425                   fBodyGyro-mean()-Y        mean()
    ## 426 426                   fBodyGyro-mean()-Z        mean()
    ## 427 427                    fBodyGyro-std()-X         std()
    ## 428 428                    fBodyGyro-std()-Y         std()
    ## 429 429                    fBodyGyro-std()-Z         std()
    ## 430 430                    fBodyGyro-mad()-X         mad()
    ## 431 431                    fBodyGyro-mad()-Y         mad()
    ## 432 432                    fBodyGyro-mad()-Z         mad()
    ## 433 433                    fBodyGyro-max()-X         max()
    ## 434 434                    fBodyGyro-max()-Y         max()
    ## 435 435                    fBodyGyro-max()-Z         max()
    ## 436 436                    fBodyGyro-min()-X         min()
    ## 437 437                    fBodyGyro-min()-Y         min()
    ## 438 438                    fBodyGyro-min()-Z         min()
    ## 439 439                      fBodyGyro-sma()         sma()
    ## 440 440                 fBodyGyro-energy()-X      energy()
    ## 441 441                 fBodyGyro-energy()-Y      energy()
    ## 442 442                 fBodyGyro-energy()-Z      energy()
    ## 443 443                    fBodyGyro-iqr()-X         iqr()
    ## 444 444                    fBodyGyro-iqr()-Y         iqr()
    ## 445 445                    fBodyGyro-iqr()-Z         iqr()
    ## 446 446                fBodyGyro-entropy()-X     entropy()
    ## 447 447                fBodyGyro-entropy()-Y     entropy()
    ## 448 448                fBodyGyro-entropy()-Z     entropy()
    ## 449 449                fBodyGyro-maxInds()-X     maxInds()
    ## 450 450                fBodyGyro-maxInds()-Y     maxInds()
    ## 451 451                fBodyGyro-maxInds()-Z     maxInds()
    ## 452 452               fBodyGyro-meanFreq()-X    meanFreq()
    ## 453 453               fBodyGyro-meanFreq()-Y    meanFreq()
    ## 454 454               fBodyGyro-meanFreq()-Z    meanFreq()
    ## 455 455               fBodyGyro-skewness()-X    skewness()
    ## 456 456               fBodyGyro-kurtosis()-X    kurtosis()
    ## 457 457               fBodyGyro-skewness()-Y    skewness()
    ## 458 458               fBodyGyro-kurtosis()-Y    kurtosis()
    ## 459 459               fBodyGyro-skewness()-Z    skewness()
    ## 460 460               fBodyGyro-kurtosis()-Z    kurtosis()
    ## 461 461          fBodyGyro-bandsEnergy()-1,8 bandsEnergy()
    ## 462 462         fBodyGyro-bandsEnergy()-9,16 bandsEnergy()
    ## 463 463        fBodyGyro-bandsEnergy()-17,24 bandsEnergy()
    ## 464 464        fBodyGyro-bandsEnergy()-25,32 bandsEnergy()
    ## 465 465        fBodyGyro-bandsEnergy()-33,40 bandsEnergy()
    ## 466 466        fBodyGyro-bandsEnergy()-41,48 bandsEnergy()
    ## 467 467        fBodyGyro-bandsEnergy()-49,56 bandsEnergy()
    ## 468 468        fBodyGyro-bandsEnergy()-57,64 bandsEnergy()
    ## 469 469         fBodyGyro-bandsEnergy()-1,16 bandsEnergy()
    ## 470 470        fBodyGyro-bandsEnergy()-17,32 bandsEnergy()
    ## 471 471        fBodyGyro-bandsEnergy()-33,48 bandsEnergy()
    ## 472 472        fBodyGyro-bandsEnergy()-49,64 bandsEnergy()
    ## 473 473         fBodyGyro-bandsEnergy()-1,24 bandsEnergy()
    ## 474 474        fBodyGyro-bandsEnergy()-25,48 bandsEnergy()
    ## 475 475          fBodyGyro-bandsEnergy()-1,8 bandsEnergy()
    ## 476 476         fBodyGyro-bandsEnergy()-9,16 bandsEnergy()
    ## 477 477        fBodyGyro-bandsEnergy()-17,24 bandsEnergy()
    ## 478 478        fBodyGyro-bandsEnergy()-25,32 bandsEnergy()
    ## 479 479        fBodyGyro-bandsEnergy()-33,40 bandsEnergy()
    ## 480 480        fBodyGyro-bandsEnergy()-41,48 bandsEnergy()
    ## 481 481        fBodyGyro-bandsEnergy()-49,56 bandsEnergy()
    ## 482 482        fBodyGyro-bandsEnergy()-57,64 bandsEnergy()
    ## 483 483         fBodyGyro-bandsEnergy()-1,16 bandsEnergy()
    ## 484 484        fBodyGyro-bandsEnergy()-17,32 bandsEnergy()
    ## 485 485        fBodyGyro-bandsEnergy()-33,48 bandsEnergy()
    ## 486 486        fBodyGyro-bandsEnergy()-49,64 bandsEnergy()
    ## 487 487         fBodyGyro-bandsEnergy()-1,24 bandsEnergy()
    ## 488 488        fBodyGyro-bandsEnergy()-25,48 bandsEnergy()
    ## 489 489          fBodyGyro-bandsEnergy()-1,8 bandsEnergy()
    ## 490 490         fBodyGyro-bandsEnergy()-9,16 bandsEnergy()
    ## 491 491        fBodyGyro-bandsEnergy()-17,24 bandsEnergy()
    ## 492 492        fBodyGyro-bandsEnergy()-25,32 bandsEnergy()
    ## 493 493        fBodyGyro-bandsEnergy()-33,40 bandsEnergy()
    ## 494 494        fBodyGyro-bandsEnergy()-41,48 bandsEnergy()
    ## 495 495        fBodyGyro-bandsEnergy()-49,56 bandsEnergy()
    ## 496 496        fBodyGyro-bandsEnergy()-57,64 bandsEnergy()
    ## 497 497         fBodyGyro-bandsEnergy()-1,16 bandsEnergy()
    ## 498 498        fBodyGyro-bandsEnergy()-17,32 bandsEnergy()
    ## 499 499        fBodyGyro-bandsEnergy()-33,48 bandsEnergy()
    ## 500 500        fBodyGyro-bandsEnergy()-49,64 bandsEnergy()
    ## 501 501         fBodyGyro-bandsEnergy()-1,24 bandsEnergy()
    ## 502 502        fBodyGyro-bandsEnergy()-25,48 bandsEnergy()
    ## 503 503                   fBodyAccMag-mean()        mean()
    ## 504 504                    fBodyAccMag-std()         std()
    ## 505 505                    fBodyAccMag-mad()         mad()
    ## 506 506                    fBodyAccMag-max()         max()
    ## 507 507                    fBodyAccMag-min()         min()
    ## 508 508                    fBodyAccMag-sma()         sma()
    ## 509 509                 fBodyAccMag-energy()      energy()
    ## 510 510                    fBodyAccMag-iqr()         iqr()
    ## 511 511                fBodyAccMag-entropy()     entropy()
    ## 512 512                fBodyAccMag-maxInds()     maxInds()
    ## 513 513               fBodyAccMag-meanFreq()    meanFreq()
    ## 514 514               fBodyAccMag-skewness()    skewness()
    ## 515 515               fBodyAccMag-kurtosis()    kurtosis()
    ## 516 516               fBodyAccJerkMag-mean()        mean()
    ## 517 517                fBodyAccJerkMag-std()         std()
    ## 518 518                fBodyAccJerkMag-mad()         mad()
    ## 519 519                fBodyAccJerkMag-max()         max()
    ## 520 520                fBodyAccJerkMag-min()         min()
    ## 521 521                fBodyAccJerkMag-sma()         sma()
    ## 522 522             fBodyAccJerkMag-energy()      energy()
    ## 523 523                fBodyAccJerkMag-iqr()         iqr()
    ## 524 524            fBodyAccJerkMag-entropy()     entropy()
    ## 525 525            fBodyAccJerkMag-maxInds()     maxInds()
    ## 526 526           fBodyAccJerkMag-meanFreq()    meanFreq()
    ## 527 527           fBodyAccJerkMag-skewness()    skewness()
    ## 528 528           fBodyAccJerkMag-kurtosis()    kurtosis()
    ## 529 529                  fBodyGyroMag-mean()        mean()
    ## 530 530                   fBodyGyroMag-std()         std()
    ## 531 531                   fBodyGyroMag-mad()         mad()
    ## 532 532                   fBodyGyroMag-max()         max()
    ## 533 533                   fBodyGyroMag-min()         min()
    ## 534 534                   fBodyGyroMag-sma()         sma()
    ## 535 535                fBodyGyroMag-energy()      energy()
    ## 536 536                   fBodyGyroMag-iqr()         iqr()
    ## 537 537               fBodyGyroMag-entropy()     entropy()
    ## 538 538               fBodyGyroMag-maxInds()     maxInds()
    ## 539 539              fBodyGyroMag-meanFreq()    meanFreq()
    ## 540 540              fBodyGyroMag-skewness()    skewness()
    ## 541 541              fBodyGyroMag-kurtosis()    kurtosis()
    ## 542 542              fBodyGyroJerkMag-mean()        mean()
    ## 543 543               fBodyGyroJerkMag-std()         std()
    ## 544 544               fBodyGyroJerkMag-mad()         mad()
    ## 545 545               fBodyGyroJerkMag-max()         max()
    ## 546 546               fBodyGyroJerkMag-min()         min()
    ## 547 547               fBodyGyroJerkMag-sma()         sma()
    ## 548 548            fBodyGyroJerkMag-energy()      energy()
    ## 549 549               fBodyGyroJerkMag-iqr()         iqr()
    ## 550 550           fBodyGyroJerkMag-entropy()     entropy()
    ## 551 551           fBodyGyroJerkMag-maxInds()     maxInds()
    ## 552 552          fBodyGyroJerkMag-meanFreq()    meanFreq()
    ## 553 553          fBodyGyroJerkMag-skewness()    skewness()
    ## 554 554          fBodyGyroJerkMag-kurtosis()    kurtosis()
    ## 555 555          angle(tBodyAccMean,gravity)       angle()
    ## 556 556  angle(tBodyAccJerkMean,gravityMean)       angle()
    ## 557 557     angle(tBodyGyroMean,gravityMean)       angle()
    ## 558 558 angle(tBodyGyroJerkMean,gravityMean)       angle()
    ## 559 559                 angle(X,gravityMean)       angle()
    ## 560 560                 angle(Y,gravityMean)       angle()
    ## 561 561                 angle(Z,gravityMean)       angle()
    ##                                                                      description
    ## 1                                                                     Mean value
    ## 2                                                                     Mean value
    ## 3                                                                     Mean value
    ## 4                                                             Standard deviation
    ## 5                                                             Standard deviation
    ## 6                                                             Standard deviation
    ## 7                                                      Median absolute deviation
    ## 8                                                      Median absolute deviation
    ## 9                                                      Median absolute deviation
    ## 10                                                        Largest value in array
    ## 11                                                        Largest value in array
    ## 12                                                        Largest value in array
    ## 13                                                       Smallest value in array
    ## 14                                                       Smallest value in array
    ## 15                                                       Smallest value in array
    ## 16                                                         Signal magnitude area
    ## 17           Energy measure. Sum of the squares divided by the number of values.
    ## 18           Energy measure. Sum of the squares divided by the number of values.
    ## 19           Energy measure. Sum of the squares divided by the number of values.
    ## 20                                                           Interquartile range
    ## 21                                                           Interquartile range
    ## 22                                                           Interquartile range
    ## 23                                                                Signal entropy
    ## 24                                                                Signal entropy
    ## 25                                                                Signal entropy
    ## 26                        Autorregresion coefficients with Burg order equal to 4
    ## 27                        Autorregresion coefficients with Burg order equal to 4
    ## 28                        Autorregresion coefficients with Burg order equal to 4
    ## 29                        Autorregresion coefficients with Burg order equal to 4
    ## 30                        Autorregresion coefficients with Burg order equal to 4
    ## 31                        Autorregresion coefficients with Burg order equal to 4
    ## 32                        Autorregresion coefficients with Burg order equal to 4
    ## 33                        Autorregresion coefficients with Burg order equal to 4
    ## 34                        Autorregresion coefficients with Burg order equal to 4
    ## 35                        Autorregresion coefficients with Burg order equal to 4
    ## 36                        Autorregresion coefficients with Burg order equal to 4
    ## 37                        Autorregresion coefficients with Burg order equal to 4
    ## 38                                   correlation coefficient between two signals
    ## 39                                   correlation coefficient between two signals
    ## 40                                   correlation coefficient between two signals
    ## 41                                                                    Mean value
    ## 42                                                                    Mean value
    ## 43                                                                    Mean value
    ## 44                                                            Standard deviation
    ## 45                                                            Standard deviation
    ## 46                                                            Standard deviation
    ## 47                                                     Median absolute deviation
    ## 48                                                     Median absolute deviation
    ## 49                                                     Median absolute deviation
    ## 50                                                        Largest value in array
    ## 51                                                        Largest value in array
    ## 52                                                        Largest value in array
    ## 53                                                       Smallest value in array
    ## 54                                                       Smallest value in array
    ## 55                                                       Smallest value in array
    ## 56                                                         Signal magnitude area
    ## 57           Energy measure. Sum of the squares divided by the number of values.
    ## 58           Energy measure. Sum of the squares divided by the number of values.
    ## 59           Energy measure. Sum of the squares divided by the number of values.
    ## 60                                                           Interquartile range
    ## 61                                                           Interquartile range
    ## 62                                                           Interquartile range
    ## 63                                                                Signal entropy
    ## 64                                                                Signal entropy
    ## 65                                                                Signal entropy
    ## 66                        Autorregresion coefficients with Burg order equal to 4
    ## 67                        Autorregresion coefficients with Burg order equal to 4
    ## 68                        Autorregresion coefficients with Burg order equal to 4
    ## 69                        Autorregresion coefficients with Burg order equal to 4
    ## 70                        Autorregresion coefficients with Burg order equal to 4
    ## 71                        Autorregresion coefficients with Burg order equal to 4
    ## 72                        Autorregresion coefficients with Burg order equal to 4
    ## 73                        Autorregresion coefficients with Burg order equal to 4
    ## 74                        Autorregresion coefficients with Burg order equal to 4
    ## 75                        Autorregresion coefficients with Burg order equal to 4
    ## 76                        Autorregresion coefficients with Burg order equal to 4
    ## 77                        Autorregresion coefficients with Burg order equal to 4
    ## 78                                   correlation coefficient between two signals
    ## 79                                   correlation coefficient between two signals
    ## 80                                   correlation coefficient between two signals
    ## 81                                                                    Mean value
    ## 82                                                                    Mean value
    ## 83                                                                    Mean value
    ## 84                                                            Standard deviation
    ## 85                                                            Standard deviation
    ## 86                                                            Standard deviation
    ## 87                                                     Median absolute deviation
    ## 88                                                     Median absolute deviation
    ## 89                                                     Median absolute deviation
    ## 90                                                        Largest value in array
    ## 91                                                        Largest value in array
    ## 92                                                        Largest value in array
    ## 93                                                       Smallest value in array
    ## 94                                                       Smallest value in array
    ## 95                                                       Smallest value in array
    ## 96                                                         Signal magnitude area
    ## 97           Energy measure. Sum of the squares divided by the number of values.
    ## 98           Energy measure. Sum of the squares divided by the number of values.
    ## 99           Energy measure. Sum of the squares divided by the number of values.
    ## 100                                                          Interquartile range
    ## 101                                                          Interquartile range
    ## 102                                                          Interquartile range
    ## 103                                                               Signal entropy
    ## 104                                                               Signal entropy
    ## 105                                                               Signal entropy
    ## 106                       Autorregresion coefficients with Burg order equal to 4
    ## 107                       Autorregresion coefficients with Burg order equal to 4
    ## 108                       Autorregresion coefficients with Burg order equal to 4
    ## 109                       Autorregresion coefficients with Burg order equal to 4
    ## 110                       Autorregresion coefficients with Burg order equal to 4
    ## 111                       Autorregresion coefficients with Burg order equal to 4
    ## 112                       Autorregresion coefficients with Burg order equal to 4
    ## 113                       Autorregresion coefficients with Burg order equal to 4
    ## 114                       Autorregresion coefficients with Burg order equal to 4
    ## 115                       Autorregresion coefficients with Burg order equal to 4
    ## 116                       Autorregresion coefficients with Burg order equal to 4
    ## 117                       Autorregresion coefficients with Burg order equal to 4
    ## 118                                  correlation coefficient between two signals
    ## 119                                  correlation coefficient between two signals
    ## 120                                  correlation coefficient between two signals
    ## 121                                                                   Mean value
    ## 122                                                                   Mean value
    ## 123                                                                   Mean value
    ## 124                                                           Standard deviation
    ## 125                                                           Standard deviation
    ## 126                                                           Standard deviation
    ## 127                                                    Median absolute deviation
    ## 128                                                    Median absolute deviation
    ## 129                                                    Median absolute deviation
    ## 130                                                       Largest value in array
    ## 131                                                       Largest value in array
    ## 132                                                       Largest value in array
    ## 133                                                      Smallest value in array
    ## 134                                                      Smallest value in array
    ## 135                                                      Smallest value in array
    ## 136                                                        Signal magnitude area
    ## 137          Energy measure. Sum of the squares divided by the number of values.
    ## 138          Energy measure. Sum of the squares divided by the number of values.
    ## 139          Energy measure. Sum of the squares divided by the number of values.
    ## 140                                                          Interquartile range
    ## 141                                                          Interquartile range
    ## 142                                                          Interquartile range
    ## 143                                                               Signal entropy
    ## 144                                                               Signal entropy
    ## 145                                                               Signal entropy
    ## 146                       Autorregresion coefficients with Burg order equal to 4
    ## 147                       Autorregresion coefficients with Burg order equal to 4
    ## 148                       Autorregresion coefficients with Burg order equal to 4
    ## 149                       Autorregresion coefficients with Burg order equal to 4
    ## 150                       Autorregresion coefficients with Burg order equal to 4
    ## 151                       Autorregresion coefficients with Burg order equal to 4
    ## 152                       Autorregresion coefficients with Burg order equal to 4
    ## 153                       Autorregresion coefficients with Burg order equal to 4
    ## 154                       Autorregresion coefficients with Burg order equal to 4
    ## 155                       Autorregresion coefficients with Burg order equal to 4
    ## 156                       Autorregresion coefficients with Burg order equal to 4
    ## 157                       Autorregresion coefficients with Burg order equal to 4
    ## 158                                  correlation coefficient between two signals
    ## 159                                  correlation coefficient between two signals
    ## 160                                  correlation coefficient between two signals
    ## 161                                                                   Mean value
    ## 162                                                                   Mean value
    ## 163                                                                   Mean value
    ## 164                                                           Standard deviation
    ## 165                                                           Standard deviation
    ## 166                                                           Standard deviation
    ## 167                                                    Median absolute deviation
    ## 168                                                    Median absolute deviation
    ## 169                                                    Median absolute deviation
    ## 170                                                       Largest value in array
    ## 171                                                       Largest value in array
    ## 172                                                       Largest value in array
    ## 173                                                      Smallest value in array
    ## 174                                                      Smallest value in array
    ## 175                                                      Smallest value in array
    ## 176                                                        Signal magnitude area
    ## 177          Energy measure. Sum of the squares divided by the number of values.
    ## 178          Energy measure. Sum of the squares divided by the number of values.
    ## 179          Energy measure. Sum of the squares divided by the number of values.
    ## 180                                                          Interquartile range
    ## 181                                                          Interquartile range
    ## 182                                                          Interquartile range
    ## 183                                                               Signal entropy
    ## 184                                                               Signal entropy
    ## 185                                                               Signal entropy
    ## 186                       Autorregresion coefficients with Burg order equal to 4
    ## 187                       Autorregresion coefficients with Burg order equal to 4
    ## 188                       Autorregresion coefficients with Burg order equal to 4
    ## 189                       Autorregresion coefficients with Burg order equal to 4
    ## 190                       Autorregresion coefficients with Burg order equal to 4
    ## 191                       Autorregresion coefficients with Burg order equal to 4
    ## 192                       Autorregresion coefficients with Burg order equal to 4
    ## 193                       Autorregresion coefficients with Burg order equal to 4
    ## 194                       Autorregresion coefficients with Burg order equal to 4
    ## 195                       Autorregresion coefficients with Burg order equal to 4
    ## 196                       Autorregresion coefficients with Burg order equal to 4
    ## 197                       Autorregresion coefficients with Burg order equal to 4
    ## 198                                  correlation coefficient between two signals
    ## 199                                  correlation coefficient between two signals
    ## 200                                  correlation coefficient between two signals
    ## 201                                                                   Mean value
    ## 202                                                           Standard deviation
    ## 203                                                    Median absolute deviation
    ## 204                                                       Largest value in array
    ## 205                                                      Smallest value in array
    ## 206                                                        Signal magnitude area
    ## 207          Energy measure. Sum of the squares divided by the number of values.
    ## 208                                                          Interquartile range
    ## 209                                                               Signal entropy
    ## 210                       Autorregresion coefficients with Burg order equal to 4
    ## 211                       Autorregresion coefficients with Burg order equal to 4
    ## 212                       Autorregresion coefficients with Burg order equal to 4
    ## 213                       Autorregresion coefficients with Burg order equal to 4
    ## 214                                                                   Mean value
    ## 215                                                           Standard deviation
    ## 216                                                    Median absolute deviation
    ## 217                                                       Largest value in array
    ## 218                                                      Smallest value in array
    ## 219                                                        Signal magnitude area
    ## 220          Energy measure. Sum of the squares divided by the number of values.
    ## 221                                                          Interquartile range
    ## 222                                                               Signal entropy
    ## 223                       Autorregresion coefficients with Burg order equal to 4
    ## 224                       Autorregresion coefficients with Burg order equal to 4
    ## 225                       Autorregresion coefficients with Burg order equal to 4
    ## 226                       Autorregresion coefficients with Burg order equal to 4
    ## 227                                                                   Mean value
    ## 228                                                           Standard deviation
    ## 229                                                    Median absolute deviation
    ## 230                                                       Largest value in array
    ## 231                                                      Smallest value in array
    ## 232                                                        Signal magnitude area
    ## 233          Energy measure. Sum of the squares divided by the number of values.
    ## 234                                                          Interquartile range
    ## 235                                                               Signal entropy
    ## 236                       Autorregresion coefficients with Burg order equal to 4
    ## 237                       Autorregresion coefficients with Burg order equal to 4
    ## 238                       Autorregresion coefficients with Burg order equal to 4
    ## 239                       Autorregresion coefficients with Burg order equal to 4
    ## 240                                                                   Mean value
    ## 241                                                           Standard deviation
    ## 242                                                    Median absolute deviation
    ## 243                                                       Largest value in array
    ## 244                                                      Smallest value in array
    ## 245                                                        Signal magnitude area
    ## 246          Energy measure. Sum of the squares divided by the number of values.
    ## 247                                                          Interquartile range
    ## 248                                                               Signal entropy
    ## 249                       Autorregresion coefficients with Burg order equal to 4
    ## 250                       Autorregresion coefficients with Burg order equal to 4
    ## 251                       Autorregresion coefficients with Burg order equal to 4
    ## 252                       Autorregresion coefficients with Burg order equal to 4
    ## 253                                                                   Mean value
    ## 254                                                           Standard deviation
    ## 255                                                    Median absolute deviation
    ## 256                                                       Largest value in array
    ## 257                                                      Smallest value in array
    ## 258                                                        Signal magnitude area
    ## 259          Energy measure. Sum of the squares divided by the number of values.
    ## 260                                                          Interquartile range
    ## 261                                                               Signal entropy
    ## 262                       Autorregresion coefficients with Burg order equal to 4
    ## 263                       Autorregresion coefficients with Burg order equal to 4
    ## 264                       Autorregresion coefficients with Burg order equal to 4
    ## 265                       Autorregresion coefficients with Burg order equal to 4
    ## 266                                                                   Mean value
    ## 267                                                                   Mean value
    ## 268                                                                   Mean value
    ## 269                                                           Standard deviation
    ## 270                                                           Standard deviation
    ## 271                                                           Standard deviation
    ## 272                                                    Median absolute deviation
    ## 273                                                    Median absolute deviation
    ## 274                                                    Median absolute deviation
    ## 275                                                       Largest value in array
    ## 276                                                       Largest value in array
    ## 277                                                       Largest value in array
    ## 278                                                      Smallest value in array
    ## 279                                                      Smallest value in array
    ## 280                                                      Smallest value in array
    ## 281                                                        Signal magnitude area
    ## 282          Energy measure. Sum of the squares divided by the number of values.
    ## 283          Energy measure. Sum of the squares divided by the number of values.
    ## 284          Energy measure. Sum of the squares divided by the number of values.
    ## 285                                                          Interquartile range
    ## 286                                                          Interquartile range
    ## 287                                                          Interquartile range
    ## 288                                                               Signal entropy
    ## 289                                                               Signal entropy
    ## 290                                                               Signal entropy
    ## 291                      index of the frequency component with largest magnitude
    ## 292                      index of the frequency component with largest magnitude
    ## 293                      index of the frequency component with largest magnitude
    ## 294      Weighted average of the frequency components to obtain a mean frequency
    ## 295      Weighted average of the frequency components to obtain a mean frequency
    ## 296      Weighted average of the frequency components to obtain a mean frequency
    ## 297                                      skewness of the frequency domain signal
    ## 298                                      kurtosis of the frequency domain signal
    ## 299                                      skewness of the frequency domain signal
    ## 300                                      kurtosis of the frequency domain signal
    ## 301                                      skewness of the frequency domain signal
    ## 302                                      kurtosis of the frequency domain signal
    ## 303 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 304 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 305 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 306 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 307 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 308 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 309 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 310 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 311 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 312 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 313 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 314 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 315 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 316 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 317 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 318 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 319 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 320 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 321 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 322 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 323 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 324 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 325 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 326 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 327 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 328 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 329 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 330 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 331 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 332 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 333 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 334 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 335 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 336 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 337 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 338 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 339 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 340 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 341 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 342 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 343 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 344 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 345                                                                   Mean value
    ## 346                                                                   Mean value
    ## 347                                                                   Mean value
    ## 348                                                           Standard deviation
    ## 349                                                           Standard deviation
    ## 350                                                           Standard deviation
    ## 351                                                    Median absolute deviation
    ## 352                                                    Median absolute deviation
    ## 353                                                    Median absolute deviation
    ## 354                                                       Largest value in array
    ## 355                                                       Largest value in array
    ## 356                                                       Largest value in array
    ## 357                                                      Smallest value in array
    ## 358                                                      Smallest value in array
    ## 359                                                      Smallest value in array
    ## 360                                                        Signal magnitude area
    ## 361          Energy measure. Sum of the squares divided by the number of values.
    ## 362          Energy measure. Sum of the squares divided by the number of values.
    ## 363          Energy measure. Sum of the squares divided by the number of values.
    ## 364                                                          Interquartile range
    ## 365                                                          Interquartile range
    ## 366                                                          Interquartile range
    ## 367                                                               Signal entropy
    ## 368                                                               Signal entropy
    ## 369                                                               Signal entropy
    ## 370                      index of the frequency component with largest magnitude
    ## 371                      index of the frequency component with largest magnitude
    ## 372                      index of the frequency component with largest magnitude
    ## 373      Weighted average of the frequency components to obtain a mean frequency
    ## 374      Weighted average of the frequency components to obtain a mean frequency
    ## 375      Weighted average of the frequency components to obtain a mean frequency
    ## 376                                      skewness of the frequency domain signal
    ## 377                                      kurtosis of the frequency domain signal
    ## 378                                      skewness of the frequency domain signal
    ## 379                                      kurtosis of the frequency domain signal
    ## 380                                      skewness of the frequency domain signal
    ## 381                                      kurtosis of the frequency domain signal
    ## 382 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 383 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 384 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 385 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 386 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 387 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 388 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 389 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 390 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 391 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 392 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 393 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 394 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 395 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 396 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 397 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 398 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 399 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 400 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 401 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 402 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 403 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 404 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 405 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 406 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 407 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 408 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 409 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 410 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 411 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 412 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 413 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 414 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 415 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 416 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 417 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 418 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 419 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 420 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 421 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 422 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 423 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 424                                                                   Mean value
    ## 425                                                                   Mean value
    ## 426                                                                   Mean value
    ## 427                                                           Standard deviation
    ## 428                                                           Standard deviation
    ## 429                                                           Standard deviation
    ## 430                                                    Median absolute deviation
    ## 431                                                    Median absolute deviation
    ## 432                                                    Median absolute deviation
    ## 433                                                       Largest value in array
    ## 434                                                       Largest value in array
    ## 435                                                       Largest value in array
    ## 436                                                      Smallest value in array
    ## 437                                                      Smallest value in array
    ## 438                                                      Smallest value in array
    ## 439                                                        Signal magnitude area
    ## 440          Energy measure. Sum of the squares divided by the number of values.
    ## 441          Energy measure. Sum of the squares divided by the number of values.
    ## 442          Energy measure. Sum of the squares divided by the number of values.
    ## 443                                                          Interquartile range
    ## 444                                                          Interquartile range
    ## 445                                                          Interquartile range
    ## 446                                                               Signal entropy
    ## 447                                                               Signal entropy
    ## 448                                                               Signal entropy
    ## 449                      index of the frequency component with largest magnitude
    ## 450                      index of the frequency component with largest magnitude
    ## 451                      index of the frequency component with largest magnitude
    ## 452      Weighted average of the frequency components to obtain a mean frequency
    ## 453      Weighted average of the frequency components to obtain a mean frequency
    ## 454      Weighted average of the frequency components to obtain a mean frequency
    ## 455                                      skewness of the frequency domain signal
    ## 456                                      kurtosis of the frequency domain signal
    ## 457                                      skewness of the frequency domain signal
    ## 458                                      kurtosis of the frequency domain signal
    ## 459                                      skewness of the frequency domain signal
    ## 460                                      kurtosis of the frequency domain signal
    ## 461 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 462 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 463 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 464 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 465 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 466 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 467 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 468 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 469 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 470 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 471 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 472 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 473 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 474 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 475 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 476 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 477 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 478 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 479 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 480 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 481 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 482 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 483 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 484 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 485 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 486 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 487 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 488 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 489 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 490 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 491 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 492 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 493 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 494 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 495 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 496 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 497 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 498 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 499 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 500 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 501 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 502 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 503                                                                   Mean value
    ## 504                                                           Standard deviation
    ## 505                                                    Median absolute deviation
    ## 506                                                       Largest value in array
    ## 507                                                      Smallest value in array
    ## 508                                                        Signal magnitude area
    ## 509          Energy measure. Sum of the squares divided by the number of values.
    ## 510                                                          Interquartile range
    ## 511                                                               Signal entropy
    ## 512                      index of the frequency component with largest magnitude
    ## 513      Weighted average of the frequency components to obtain a mean frequency
    ## 514                                      skewness of the frequency domain signal
    ## 515                                      kurtosis of the frequency domain signal
    ## 516                                                                   Mean value
    ## 517                                                           Standard deviation
    ## 518                                                    Median absolute deviation
    ## 519                                                       Largest value in array
    ## 520                                                      Smallest value in array
    ## 521                                                        Signal magnitude area
    ## 522          Energy measure. Sum of the squares divided by the number of values.
    ## 523                                                          Interquartile range
    ## 524                                                               Signal entropy
    ## 525                      index of the frequency component with largest magnitude
    ## 526      Weighted average of the frequency components to obtain a mean frequency
    ## 527                                      skewness of the frequency domain signal
    ## 528                                      kurtosis of the frequency domain signal
    ## 529                                                                   Mean value
    ## 530                                                           Standard deviation
    ## 531                                                    Median absolute deviation
    ## 532                                                       Largest value in array
    ## 533                                                      Smallest value in array
    ## 534                                                        Signal magnitude area
    ## 535          Energy measure. Sum of the squares divided by the number of values.
    ## 536                                                          Interquartile range
    ## 537                                                               Signal entropy
    ## 538                      index of the frequency component with largest magnitude
    ## 539      Weighted average of the frequency components to obtain a mean frequency
    ## 540                                      skewness of the frequency domain signal
    ## 541                                      kurtosis of the frequency domain signal
    ## 542                                                                   Mean value
    ## 543                                                           Standard deviation
    ## 544                                                    Median absolute deviation
    ## 545                                                       Largest value in array
    ## 546                                                      Smallest value in array
    ## 547                                                        Signal magnitude area
    ## 548          Energy measure. Sum of the squares divided by the number of values.
    ## 549                                                          Interquartile range
    ## 550                                                               Signal entropy
    ## 551                      index of the frequency component with largest magnitude
    ## 552      Weighted average of the frequency components to obtain a mean frequency
    ## 553                                      skewness of the frequency domain signal
    ## 554                                      kurtosis of the frequency domain signal
    ## 555                                                    Angle between to vectors.
    ## 556                                                    Angle between to vectors.
    ## 557                                                    Angle between to vectors.
    ## 558                                                    Angle between to vectors.
    ## 559                                                    Angle between to vectors.
    ## 560                                                    Angle between to vectors.
    ## 561                                                    Angle between to vectors.

Is there a better way to extract features signals before the feature decomposition?
-----------------------------------------------------------------------------------

``` r
featuresSignals <- read_features() %>%
    print
```

    ##      id                                 name
    ## 1     1                    tBodyAcc-mean()-X
    ## 2     2                    tBodyAcc-mean()-Y
    ## 3     3                    tBodyAcc-mean()-Z
    ## 4     4                     tBodyAcc-std()-X
    ## 5     5                     tBodyAcc-std()-Y
    ## 6     6                     tBodyAcc-std()-Z
    ## 7     7                     tBodyAcc-mad()-X
    ## 8     8                     tBodyAcc-mad()-Y
    ## 9     9                     tBodyAcc-mad()-Z
    ## 10   10                     tBodyAcc-max()-X
    ## 11   11                     tBodyAcc-max()-Y
    ## 12   12                     tBodyAcc-max()-Z
    ## 13   13                     tBodyAcc-min()-X
    ## 14   14                     tBodyAcc-min()-Y
    ## 15   15                     tBodyAcc-min()-Z
    ## 16   16                       tBodyAcc-sma()
    ## 17   17                  tBodyAcc-energy()-X
    ## 18   18                  tBodyAcc-energy()-Y
    ## 19   19                  tBodyAcc-energy()-Z
    ## 20   20                     tBodyAcc-iqr()-X
    ## 21   21                     tBodyAcc-iqr()-Y
    ## 22   22                     tBodyAcc-iqr()-Z
    ## 23   23                 tBodyAcc-entropy()-X
    ## 24   24                 tBodyAcc-entropy()-Y
    ## 25   25                 tBodyAcc-entropy()-Z
    ## 26   26               tBodyAcc-arCoeff()-X,1
    ## 27   27               tBodyAcc-arCoeff()-X,2
    ## 28   28               tBodyAcc-arCoeff()-X,3
    ## 29   29               tBodyAcc-arCoeff()-X,4
    ## 30   30               tBodyAcc-arCoeff()-Y,1
    ## 31   31               tBodyAcc-arCoeff()-Y,2
    ## 32   32               tBodyAcc-arCoeff()-Y,3
    ## 33   33               tBodyAcc-arCoeff()-Y,4
    ## 34   34               tBodyAcc-arCoeff()-Z,1
    ## 35   35               tBodyAcc-arCoeff()-Z,2
    ## 36   36               tBodyAcc-arCoeff()-Z,3
    ## 37   37               tBodyAcc-arCoeff()-Z,4
    ## 38   38           tBodyAcc-correlation()-X,Y
    ## 39   39           tBodyAcc-correlation()-X,Z
    ## 40   40           tBodyAcc-correlation()-Y,Z
    ## 41   41                 tGravityAcc-mean()-X
    ## 42   42                 tGravityAcc-mean()-Y
    ## 43   43                 tGravityAcc-mean()-Z
    ## 44   44                  tGravityAcc-std()-X
    ## 45   45                  tGravityAcc-std()-Y
    ## 46   46                  tGravityAcc-std()-Z
    ## 47   47                  tGravityAcc-mad()-X
    ## 48   48                  tGravityAcc-mad()-Y
    ## 49   49                  tGravityAcc-mad()-Z
    ## 50   50                  tGravityAcc-max()-X
    ## 51   51                  tGravityAcc-max()-Y
    ## 52   52                  tGravityAcc-max()-Z
    ## 53   53                  tGravityAcc-min()-X
    ## 54   54                  tGravityAcc-min()-Y
    ## 55   55                  tGravityAcc-min()-Z
    ## 56   56                    tGravityAcc-sma()
    ## 57   57               tGravityAcc-energy()-X
    ## 58   58               tGravityAcc-energy()-Y
    ## 59   59               tGravityAcc-energy()-Z
    ## 60   60                  tGravityAcc-iqr()-X
    ## 61   61                  tGravityAcc-iqr()-Y
    ## 62   62                  tGravityAcc-iqr()-Z
    ## 63   63              tGravityAcc-entropy()-X
    ## 64   64              tGravityAcc-entropy()-Y
    ## 65   65              tGravityAcc-entropy()-Z
    ## 66   66            tGravityAcc-arCoeff()-X,1
    ## 67   67            tGravityAcc-arCoeff()-X,2
    ## 68   68            tGravityAcc-arCoeff()-X,3
    ## 69   69            tGravityAcc-arCoeff()-X,4
    ## 70   70            tGravityAcc-arCoeff()-Y,1
    ## 71   71            tGravityAcc-arCoeff()-Y,2
    ## 72   72            tGravityAcc-arCoeff()-Y,3
    ## 73   73            tGravityAcc-arCoeff()-Y,4
    ## 74   74            tGravityAcc-arCoeff()-Z,1
    ## 75   75            tGravityAcc-arCoeff()-Z,2
    ## 76   76            tGravityAcc-arCoeff()-Z,3
    ## 77   77            tGravityAcc-arCoeff()-Z,4
    ## 78   78        tGravityAcc-correlation()-X,Y
    ## 79   79        tGravityAcc-correlation()-X,Z
    ## 80   80        tGravityAcc-correlation()-Y,Z
    ## 81   81                tBodyAccJerk-mean()-X
    ## 82   82                tBodyAccJerk-mean()-Y
    ## 83   83                tBodyAccJerk-mean()-Z
    ## 84   84                 tBodyAccJerk-std()-X
    ## 85   85                 tBodyAccJerk-std()-Y
    ## 86   86                 tBodyAccJerk-std()-Z
    ## 87   87                 tBodyAccJerk-mad()-X
    ## 88   88                 tBodyAccJerk-mad()-Y
    ## 89   89                 tBodyAccJerk-mad()-Z
    ## 90   90                 tBodyAccJerk-max()-X
    ## 91   91                 tBodyAccJerk-max()-Y
    ## 92   92                 tBodyAccJerk-max()-Z
    ## 93   93                 tBodyAccJerk-min()-X
    ## 94   94                 tBodyAccJerk-min()-Y
    ## 95   95                 tBodyAccJerk-min()-Z
    ## 96   96                   tBodyAccJerk-sma()
    ## 97   97              tBodyAccJerk-energy()-X
    ## 98   98              tBodyAccJerk-energy()-Y
    ## 99   99              tBodyAccJerk-energy()-Z
    ## 100 100                 tBodyAccJerk-iqr()-X
    ## 101 101                 tBodyAccJerk-iqr()-Y
    ## 102 102                 tBodyAccJerk-iqr()-Z
    ## 103 103             tBodyAccJerk-entropy()-X
    ## 104 104             tBodyAccJerk-entropy()-Y
    ## 105 105             tBodyAccJerk-entropy()-Z
    ## 106 106           tBodyAccJerk-arCoeff()-X,1
    ## 107 107           tBodyAccJerk-arCoeff()-X,2
    ## 108 108           tBodyAccJerk-arCoeff()-X,3
    ## 109 109           tBodyAccJerk-arCoeff()-X,4
    ## 110 110           tBodyAccJerk-arCoeff()-Y,1
    ## 111 111           tBodyAccJerk-arCoeff()-Y,2
    ## 112 112           tBodyAccJerk-arCoeff()-Y,3
    ## 113 113           tBodyAccJerk-arCoeff()-Y,4
    ## 114 114           tBodyAccJerk-arCoeff()-Z,1
    ## 115 115           tBodyAccJerk-arCoeff()-Z,2
    ## 116 116           tBodyAccJerk-arCoeff()-Z,3
    ## 117 117           tBodyAccJerk-arCoeff()-Z,4
    ## 118 118       tBodyAccJerk-correlation()-X,Y
    ## 119 119       tBodyAccJerk-correlation()-X,Z
    ## 120 120       tBodyAccJerk-correlation()-Y,Z
    ## 121 121                   tBodyGyro-mean()-X
    ## 122 122                   tBodyGyro-mean()-Y
    ## 123 123                   tBodyGyro-mean()-Z
    ## 124 124                    tBodyGyro-std()-X
    ## 125 125                    tBodyGyro-std()-Y
    ## 126 126                    tBodyGyro-std()-Z
    ## 127 127                    tBodyGyro-mad()-X
    ## 128 128                    tBodyGyro-mad()-Y
    ## 129 129                    tBodyGyro-mad()-Z
    ## 130 130                    tBodyGyro-max()-X
    ## 131 131                    tBodyGyro-max()-Y
    ## 132 132                    tBodyGyro-max()-Z
    ## 133 133                    tBodyGyro-min()-X
    ## 134 134                    tBodyGyro-min()-Y
    ## 135 135                    tBodyGyro-min()-Z
    ## 136 136                      tBodyGyro-sma()
    ## 137 137                 tBodyGyro-energy()-X
    ## 138 138                 tBodyGyro-energy()-Y
    ## 139 139                 tBodyGyro-energy()-Z
    ## 140 140                    tBodyGyro-iqr()-X
    ## 141 141                    tBodyGyro-iqr()-Y
    ## 142 142                    tBodyGyro-iqr()-Z
    ## 143 143                tBodyGyro-entropy()-X
    ## 144 144                tBodyGyro-entropy()-Y
    ## 145 145                tBodyGyro-entropy()-Z
    ## 146 146              tBodyGyro-arCoeff()-X,1
    ## 147 147              tBodyGyro-arCoeff()-X,2
    ## 148 148              tBodyGyro-arCoeff()-X,3
    ## 149 149              tBodyGyro-arCoeff()-X,4
    ## 150 150              tBodyGyro-arCoeff()-Y,1
    ## 151 151              tBodyGyro-arCoeff()-Y,2
    ## 152 152              tBodyGyro-arCoeff()-Y,3
    ## 153 153              tBodyGyro-arCoeff()-Y,4
    ## 154 154              tBodyGyro-arCoeff()-Z,1
    ## 155 155              tBodyGyro-arCoeff()-Z,2
    ## 156 156              tBodyGyro-arCoeff()-Z,3
    ## 157 157              tBodyGyro-arCoeff()-Z,4
    ## 158 158          tBodyGyro-correlation()-X,Y
    ## 159 159          tBodyGyro-correlation()-X,Z
    ## 160 160          tBodyGyro-correlation()-Y,Z
    ## 161 161               tBodyGyroJerk-mean()-X
    ## 162 162               tBodyGyroJerk-mean()-Y
    ## 163 163               tBodyGyroJerk-mean()-Z
    ## 164 164                tBodyGyroJerk-std()-X
    ## 165 165                tBodyGyroJerk-std()-Y
    ## 166 166                tBodyGyroJerk-std()-Z
    ## 167 167                tBodyGyroJerk-mad()-X
    ## 168 168                tBodyGyroJerk-mad()-Y
    ## 169 169                tBodyGyroJerk-mad()-Z
    ## 170 170                tBodyGyroJerk-max()-X
    ## 171 171                tBodyGyroJerk-max()-Y
    ## 172 172                tBodyGyroJerk-max()-Z
    ## 173 173                tBodyGyroJerk-min()-X
    ## 174 174                tBodyGyroJerk-min()-Y
    ## 175 175                tBodyGyroJerk-min()-Z
    ## 176 176                  tBodyGyroJerk-sma()
    ## 177 177             tBodyGyroJerk-energy()-X
    ## 178 178             tBodyGyroJerk-energy()-Y
    ## 179 179             tBodyGyroJerk-energy()-Z
    ## 180 180                tBodyGyroJerk-iqr()-X
    ## 181 181                tBodyGyroJerk-iqr()-Y
    ## 182 182                tBodyGyroJerk-iqr()-Z
    ## 183 183            tBodyGyroJerk-entropy()-X
    ## 184 184            tBodyGyroJerk-entropy()-Y
    ## 185 185            tBodyGyroJerk-entropy()-Z
    ## 186 186          tBodyGyroJerk-arCoeff()-X,1
    ## 187 187          tBodyGyroJerk-arCoeff()-X,2
    ## 188 188          tBodyGyroJerk-arCoeff()-X,3
    ## 189 189          tBodyGyroJerk-arCoeff()-X,4
    ## 190 190          tBodyGyroJerk-arCoeff()-Y,1
    ## 191 191          tBodyGyroJerk-arCoeff()-Y,2
    ## 192 192          tBodyGyroJerk-arCoeff()-Y,3
    ## 193 193          tBodyGyroJerk-arCoeff()-Y,4
    ## 194 194          tBodyGyroJerk-arCoeff()-Z,1
    ## 195 195          tBodyGyroJerk-arCoeff()-Z,2
    ## 196 196          tBodyGyroJerk-arCoeff()-Z,3
    ## 197 197          tBodyGyroJerk-arCoeff()-Z,4
    ## 198 198      tBodyGyroJerk-correlation()-X,Y
    ## 199 199      tBodyGyroJerk-correlation()-X,Z
    ## 200 200      tBodyGyroJerk-correlation()-Y,Z
    ## 201 201                   tBodyAccMag-mean()
    ## 202 202                    tBodyAccMag-std()
    ## 203 203                    tBodyAccMag-mad()
    ## 204 204                    tBodyAccMag-max()
    ## 205 205                    tBodyAccMag-min()
    ## 206 206                    tBodyAccMag-sma()
    ## 207 207                 tBodyAccMag-energy()
    ## 208 208                    tBodyAccMag-iqr()
    ## 209 209                tBodyAccMag-entropy()
    ## 210 210               tBodyAccMag-arCoeff()1
    ## 211 211               tBodyAccMag-arCoeff()2
    ## 212 212               tBodyAccMag-arCoeff()3
    ## 213 213               tBodyAccMag-arCoeff()4
    ## 214 214                tGravityAccMag-mean()
    ## 215 215                 tGravityAccMag-std()
    ## 216 216                 tGravityAccMag-mad()
    ## 217 217                 tGravityAccMag-max()
    ## 218 218                 tGravityAccMag-min()
    ## 219 219                 tGravityAccMag-sma()
    ## 220 220              tGravityAccMag-energy()
    ## 221 221                 tGravityAccMag-iqr()
    ## 222 222             tGravityAccMag-entropy()
    ## 223 223            tGravityAccMag-arCoeff()1
    ## 224 224            tGravityAccMag-arCoeff()2
    ## 225 225            tGravityAccMag-arCoeff()3
    ## 226 226            tGravityAccMag-arCoeff()4
    ## 227 227               tBodyAccJerkMag-mean()
    ## 228 228                tBodyAccJerkMag-std()
    ## 229 229                tBodyAccJerkMag-mad()
    ## 230 230                tBodyAccJerkMag-max()
    ## 231 231                tBodyAccJerkMag-min()
    ## 232 232                tBodyAccJerkMag-sma()
    ## 233 233             tBodyAccJerkMag-energy()
    ## 234 234                tBodyAccJerkMag-iqr()
    ## 235 235            tBodyAccJerkMag-entropy()
    ## 236 236           tBodyAccJerkMag-arCoeff()1
    ## 237 237           tBodyAccJerkMag-arCoeff()2
    ## 238 238           tBodyAccJerkMag-arCoeff()3
    ## 239 239           tBodyAccJerkMag-arCoeff()4
    ## 240 240                  tBodyGyroMag-mean()
    ## 241 241                   tBodyGyroMag-std()
    ## 242 242                   tBodyGyroMag-mad()
    ## 243 243                   tBodyGyroMag-max()
    ## 244 244                   tBodyGyroMag-min()
    ## 245 245                   tBodyGyroMag-sma()
    ## 246 246                tBodyGyroMag-energy()
    ## 247 247                   tBodyGyroMag-iqr()
    ## 248 248               tBodyGyroMag-entropy()
    ## 249 249              tBodyGyroMag-arCoeff()1
    ## 250 250              tBodyGyroMag-arCoeff()2
    ## 251 251              tBodyGyroMag-arCoeff()3
    ## 252 252              tBodyGyroMag-arCoeff()4
    ## 253 253              tBodyGyroJerkMag-mean()
    ## 254 254               tBodyGyroJerkMag-std()
    ## 255 255               tBodyGyroJerkMag-mad()
    ## 256 256               tBodyGyroJerkMag-max()
    ## 257 257               tBodyGyroJerkMag-min()
    ## 258 258               tBodyGyroJerkMag-sma()
    ## 259 259            tBodyGyroJerkMag-energy()
    ## 260 260               tBodyGyroJerkMag-iqr()
    ## 261 261           tBodyGyroJerkMag-entropy()
    ## 262 262          tBodyGyroJerkMag-arCoeff()1
    ## 263 263          tBodyGyroJerkMag-arCoeff()2
    ## 264 264          tBodyGyroJerkMag-arCoeff()3
    ## 265 265          tBodyGyroJerkMag-arCoeff()4
    ## 266 266                    fBodyAcc-mean()-X
    ## 267 267                    fBodyAcc-mean()-Y
    ## 268 268                    fBodyAcc-mean()-Z
    ## 269 269                     fBodyAcc-std()-X
    ## 270 270                     fBodyAcc-std()-Y
    ## 271 271                     fBodyAcc-std()-Z
    ## 272 272                     fBodyAcc-mad()-X
    ## 273 273                     fBodyAcc-mad()-Y
    ## 274 274                     fBodyAcc-mad()-Z
    ## 275 275                     fBodyAcc-max()-X
    ## 276 276                     fBodyAcc-max()-Y
    ## 277 277                     fBodyAcc-max()-Z
    ## 278 278                     fBodyAcc-min()-X
    ## 279 279                     fBodyAcc-min()-Y
    ## 280 280                     fBodyAcc-min()-Z
    ## 281 281                       fBodyAcc-sma()
    ## 282 282                  fBodyAcc-energy()-X
    ## 283 283                  fBodyAcc-energy()-Y
    ## 284 284                  fBodyAcc-energy()-Z
    ## 285 285                     fBodyAcc-iqr()-X
    ## 286 286                     fBodyAcc-iqr()-Y
    ## 287 287                     fBodyAcc-iqr()-Z
    ## 288 288                 fBodyAcc-entropy()-X
    ## 289 289                 fBodyAcc-entropy()-Y
    ## 290 290                 fBodyAcc-entropy()-Z
    ## 291 291                   fBodyAcc-maxInds-X
    ## 292 292                   fBodyAcc-maxInds-Y
    ## 293 293                   fBodyAcc-maxInds-Z
    ## 294 294                fBodyAcc-meanFreq()-X
    ## 295 295                fBodyAcc-meanFreq()-Y
    ## 296 296                fBodyAcc-meanFreq()-Z
    ## 297 297                fBodyAcc-skewness()-X
    ## 298 298                fBodyAcc-kurtosis()-X
    ## 299 299                fBodyAcc-skewness()-Y
    ## 300 300                fBodyAcc-kurtosis()-Y
    ## 301 301                fBodyAcc-skewness()-Z
    ## 302 302                fBodyAcc-kurtosis()-Z
    ## 303 303           fBodyAcc-bandsEnergy()-1,8
    ## 304 304          fBodyAcc-bandsEnergy()-9,16
    ## 305 305         fBodyAcc-bandsEnergy()-17,24
    ## 306 306         fBodyAcc-bandsEnergy()-25,32
    ## 307 307         fBodyAcc-bandsEnergy()-33,40
    ## 308 308         fBodyAcc-bandsEnergy()-41,48
    ## 309 309         fBodyAcc-bandsEnergy()-49,56
    ## 310 310         fBodyAcc-bandsEnergy()-57,64
    ## 311 311          fBodyAcc-bandsEnergy()-1,16
    ## 312 312         fBodyAcc-bandsEnergy()-17,32
    ## 313 313         fBodyAcc-bandsEnergy()-33,48
    ## 314 314         fBodyAcc-bandsEnergy()-49,64
    ## 315 315          fBodyAcc-bandsEnergy()-1,24
    ## 316 316         fBodyAcc-bandsEnergy()-25,48
    ## 317 317           fBodyAcc-bandsEnergy()-1,8
    ## 318 318          fBodyAcc-bandsEnergy()-9,16
    ## 319 319         fBodyAcc-bandsEnergy()-17,24
    ## 320 320         fBodyAcc-bandsEnergy()-25,32
    ## 321 321         fBodyAcc-bandsEnergy()-33,40
    ## 322 322         fBodyAcc-bandsEnergy()-41,48
    ## 323 323         fBodyAcc-bandsEnergy()-49,56
    ## 324 324         fBodyAcc-bandsEnergy()-57,64
    ## 325 325          fBodyAcc-bandsEnergy()-1,16
    ## 326 326         fBodyAcc-bandsEnergy()-17,32
    ## 327 327         fBodyAcc-bandsEnergy()-33,48
    ## 328 328         fBodyAcc-bandsEnergy()-49,64
    ## 329 329          fBodyAcc-bandsEnergy()-1,24
    ## 330 330         fBodyAcc-bandsEnergy()-25,48
    ## 331 331           fBodyAcc-bandsEnergy()-1,8
    ## 332 332          fBodyAcc-bandsEnergy()-9,16
    ## 333 333         fBodyAcc-bandsEnergy()-17,24
    ## 334 334         fBodyAcc-bandsEnergy()-25,32
    ## 335 335         fBodyAcc-bandsEnergy()-33,40
    ## 336 336         fBodyAcc-bandsEnergy()-41,48
    ## 337 337         fBodyAcc-bandsEnergy()-49,56
    ## 338 338         fBodyAcc-bandsEnergy()-57,64
    ## 339 339          fBodyAcc-bandsEnergy()-1,16
    ## 340 340         fBodyAcc-bandsEnergy()-17,32
    ## 341 341         fBodyAcc-bandsEnergy()-33,48
    ## 342 342         fBodyAcc-bandsEnergy()-49,64
    ## 343 343          fBodyAcc-bandsEnergy()-1,24
    ## 344 344         fBodyAcc-bandsEnergy()-25,48
    ## 345 345                fBodyAccJerk-mean()-X
    ## 346 346                fBodyAccJerk-mean()-Y
    ## 347 347                fBodyAccJerk-mean()-Z
    ## 348 348                 fBodyAccJerk-std()-X
    ## 349 349                 fBodyAccJerk-std()-Y
    ## 350 350                 fBodyAccJerk-std()-Z
    ## 351 351                 fBodyAccJerk-mad()-X
    ## 352 352                 fBodyAccJerk-mad()-Y
    ## 353 353                 fBodyAccJerk-mad()-Z
    ## 354 354                 fBodyAccJerk-max()-X
    ## 355 355                 fBodyAccJerk-max()-Y
    ## 356 356                 fBodyAccJerk-max()-Z
    ## 357 357                 fBodyAccJerk-min()-X
    ## 358 358                 fBodyAccJerk-min()-Y
    ## 359 359                 fBodyAccJerk-min()-Z
    ## 360 360                   fBodyAccJerk-sma()
    ## 361 361              fBodyAccJerk-energy()-X
    ## 362 362              fBodyAccJerk-energy()-Y
    ## 363 363              fBodyAccJerk-energy()-Z
    ## 364 364                 fBodyAccJerk-iqr()-X
    ## 365 365                 fBodyAccJerk-iqr()-Y
    ## 366 366                 fBodyAccJerk-iqr()-Z
    ## 367 367             fBodyAccJerk-entropy()-X
    ## 368 368             fBodyAccJerk-entropy()-Y
    ## 369 369             fBodyAccJerk-entropy()-Z
    ## 370 370               fBodyAccJerk-maxInds-X
    ## 371 371               fBodyAccJerk-maxInds-Y
    ## 372 372               fBodyAccJerk-maxInds-Z
    ## 373 373            fBodyAccJerk-meanFreq()-X
    ## 374 374            fBodyAccJerk-meanFreq()-Y
    ## 375 375            fBodyAccJerk-meanFreq()-Z
    ## 376 376            fBodyAccJerk-skewness()-X
    ## 377 377            fBodyAccJerk-kurtosis()-X
    ## 378 378            fBodyAccJerk-skewness()-Y
    ## 379 379            fBodyAccJerk-kurtosis()-Y
    ## 380 380            fBodyAccJerk-skewness()-Z
    ## 381 381            fBodyAccJerk-kurtosis()-Z
    ## 382 382       fBodyAccJerk-bandsEnergy()-1,8
    ## 383 383      fBodyAccJerk-bandsEnergy()-9,16
    ## 384 384     fBodyAccJerk-bandsEnergy()-17,24
    ## 385 385     fBodyAccJerk-bandsEnergy()-25,32
    ## 386 386     fBodyAccJerk-bandsEnergy()-33,40
    ## 387 387     fBodyAccJerk-bandsEnergy()-41,48
    ## 388 388     fBodyAccJerk-bandsEnergy()-49,56
    ## 389 389     fBodyAccJerk-bandsEnergy()-57,64
    ## 390 390      fBodyAccJerk-bandsEnergy()-1,16
    ## 391 391     fBodyAccJerk-bandsEnergy()-17,32
    ## 392 392     fBodyAccJerk-bandsEnergy()-33,48
    ## 393 393     fBodyAccJerk-bandsEnergy()-49,64
    ## 394 394      fBodyAccJerk-bandsEnergy()-1,24
    ## 395 395     fBodyAccJerk-bandsEnergy()-25,48
    ## 396 396       fBodyAccJerk-bandsEnergy()-1,8
    ## 397 397      fBodyAccJerk-bandsEnergy()-9,16
    ## 398 398     fBodyAccJerk-bandsEnergy()-17,24
    ## 399 399     fBodyAccJerk-bandsEnergy()-25,32
    ## 400 400     fBodyAccJerk-bandsEnergy()-33,40
    ## 401 401     fBodyAccJerk-bandsEnergy()-41,48
    ## 402 402     fBodyAccJerk-bandsEnergy()-49,56
    ## 403 403     fBodyAccJerk-bandsEnergy()-57,64
    ## 404 404      fBodyAccJerk-bandsEnergy()-1,16
    ## 405 405     fBodyAccJerk-bandsEnergy()-17,32
    ## 406 406     fBodyAccJerk-bandsEnergy()-33,48
    ## 407 407     fBodyAccJerk-bandsEnergy()-49,64
    ## 408 408      fBodyAccJerk-bandsEnergy()-1,24
    ## 409 409     fBodyAccJerk-bandsEnergy()-25,48
    ## 410 410       fBodyAccJerk-bandsEnergy()-1,8
    ## 411 411      fBodyAccJerk-bandsEnergy()-9,16
    ## 412 412     fBodyAccJerk-bandsEnergy()-17,24
    ## 413 413     fBodyAccJerk-bandsEnergy()-25,32
    ## 414 414     fBodyAccJerk-bandsEnergy()-33,40
    ## 415 415     fBodyAccJerk-bandsEnergy()-41,48
    ## 416 416     fBodyAccJerk-bandsEnergy()-49,56
    ## 417 417     fBodyAccJerk-bandsEnergy()-57,64
    ## 418 418      fBodyAccJerk-bandsEnergy()-1,16
    ## 419 419     fBodyAccJerk-bandsEnergy()-17,32
    ## 420 420     fBodyAccJerk-bandsEnergy()-33,48
    ## 421 421     fBodyAccJerk-bandsEnergy()-49,64
    ## 422 422      fBodyAccJerk-bandsEnergy()-1,24
    ## 423 423     fBodyAccJerk-bandsEnergy()-25,48
    ## 424 424                   fBodyGyro-mean()-X
    ## 425 425                   fBodyGyro-mean()-Y
    ## 426 426                   fBodyGyro-mean()-Z
    ## 427 427                    fBodyGyro-std()-X
    ## 428 428                    fBodyGyro-std()-Y
    ## 429 429                    fBodyGyro-std()-Z
    ## 430 430                    fBodyGyro-mad()-X
    ## 431 431                    fBodyGyro-mad()-Y
    ## 432 432                    fBodyGyro-mad()-Z
    ## 433 433                    fBodyGyro-max()-X
    ## 434 434                    fBodyGyro-max()-Y
    ## 435 435                    fBodyGyro-max()-Z
    ## 436 436                    fBodyGyro-min()-X
    ## 437 437                    fBodyGyro-min()-Y
    ## 438 438                    fBodyGyro-min()-Z
    ## 439 439                      fBodyGyro-sma()
    ## 440 440                 fBodyGyro-energy()-X
    ## 441 441                 fBodyGyro-energy()-Y
    ## 442 442                 fBodyGyro-energy()-Z
    ## 443 443                    fBodyGyro-iqr()-X
    ## 444 444                    fBodyGyro-iqr()-Y
    ## 445 445                    fBodyGyro-iqr()-Z
    ## 446 446                fBodyGyro-entropy()-X
    ## 447 447                fBodyGyro-entropy()-Y
    ## 448 448                fBodyGyro-entropy()-Z
    ## 449 449                  fBodyGyro-maxInds-X
    ## 450 450                  fBodyGyro-maxInds-Y
    ## 451 451                  fBodyGyro-maxInds-Z
    ## 452 452               fBodyGyro-meanFreq()-X
    ## 453 453               fBodyGyro-meanFreq()-Y
    ## 454 454               fBodyGyro-meanFreq()-Z
    ## 455 455               fBodyGyro-skewness()-X
    ## 456 456               fBodyGyro-kurtosis()-X
    ## 457 457               fBodyGyro-skewness()-Y
    ## 458 458               fBodyGyro-kurtosis()-Y
    ## 459 459               fBodyGyro-skewness()-Z
    ## 460 460               fBodyGyro-kurtosis()-Z
    ## 461 461          fBodyGyro-bandsEnergy()-1,8
    ## 462 462         fBodyGyro-bandsEnergy()-9,16
    ## 463 463        fBodyGyro-bandsEnergy()-17,24
    ## 464 464        fBodyGyro-bandsEnergy()-25,32
    ## 465 465        fBodyGyro-bandsEnergy()-33,40
    ## 466 466        fBodyGyro-bandsEnergy()-41,48
    ## 467 467        fBodyGyro-bandsEnergy()-49,56
    ## 468 468        fBodyGyro-bandsEnergy()-57,64
    ## 469 469         fBodyGyro-bandsEnergy()-1,16
    ## 470 470        fBodyGyro-bandsEnergy()-17,32
    ## 471 471        fBodyGyro-bandsEnergy()-33,48
    ## 472 472        fBodyGyro-bandsEnergy()-49,64
    ## 473 473         fBodyGyro-bandsEnergy()-1,24
    ## 474 474        fBodyGyro-bandsEnergy()-25,48
    ## 475 475          fBodyGyro-bandsEnergy()-1,8
    ## 476 476         fBodyGyro-bandsEnergy()-9,16
    ## 477 477        fBodyGyro-bandsEnergy()-17,24
    ## 478 478        fBodyGyro-bandsEnergy()-25,32
    ## 479 479        fBodyGyro-bandsEnergy()-33,40
    ## 480 480        fBodyGyro-bandsEnergy()-41,48
    ## 481 481        fBodyGyro-bandsEnergy()-49,56
    ## 482 482        fBodyGyro-bandsEnergy()-57,64
    ## 483 483         fBodyGyro-bandsEnergy()-1,16
    ## 484 484        fBodyGyro-bandsEnergy()-17,32
    ## 485 485        fBodyGyro-bandsEnergy()-33,48
    ## 486 486        fBodyGyro-bandsEnergy()-49,64
    ## 487 487         fBodyGyro-bandsEnergy()-1,24
    ## 488 488        fBodyGyro-bandsEnergy()-25,48
    ## 489 489          fBodyGyro-bandsEnergy()-1,8
    ## 490 490         fBodyGyro-bandsEnergy()-9,16
    ## 491 491        fBodyGyro-bandsEnergy()-17,24
    ## 492 492        fBodyGyro-bandsEnergy()-25,32
    ## 493 493        fBodyGyro-bandsEnergy()-33,40
    ## 494 494        fBodyGyro-bandsEnergy()-41,48
    ## 495 495        fBodyGyro-bandsEnergy()-49,56
    ## 496 496        fBodyGyro-bandsEnergy()-57,64
    ## 497 497         fBodyGyro-bandsEnergy()-1,16
    ## 498 498        fBodyGyro-bandsEnergy()-17,32
    ## 499 499        fBodyGyro-bandsEnergy()-33,48
    ## 500 500        fBodyGyro-bandsEnergy()-49,64
    ## 501 501         fBodyGyro-bandsEnergy()-1,24
    ## 502 502        fBodyGyro-bandsEnergy()-25,48
    ## 503 503                   fBodyAccMag-mean()
    ## 504 504                    fBodyAccMag-std()
    ## 505 505                    fBodyAccMag-mad()
    ## 506 506                    fBodyAccMag-max()
    ## 507 507                    fBodyAccMag-min()
    ## 508 508                    fBodyAccMag-sma()
    ## 509 509                 fBodyAccMag-energy()
    ## 510 510                    fBodyAccMag-iqr()
    ## 511 511                fBodyAccMag-entropy()
    ## 512 512                  fBodyAccMag-maxInds
    ## 513 513               fBodyAccMag-meanFreq()
    ## 514 514               fBodyAccMag-skewness()
    ## 515 515               fBodyAccMag-kurtosis()
    ## 516 516           fBodyBodyAccJerkMag-mean()
    ## 517 517            fBodyBodyAccJerkMag-std()
    ## 518 518            fBodyBodyAccJerkMag-mad()
    ## 519 519            fBodyBodyAccJerkMag-max()
    ## 520 520            fBodyBodyAccJerkMag-min()
    ## 521 521            fBodyBodyAccJerkMag-sma()
    ## 522 522         fBodyBodyAccJerkMag-energy()
    ## 523 523            fBodyBodyAccJerkMag-iqr()
    ## 524 524        fBodyBodyAccJerkMag-entropy()
    ## 525 525          fBodyBodyAccJerkMag-maxInds
    ## 526 526       fBodyBodyAccJerkMag-meanFreq()
    ## 527 527       fBodyBodyAccJerkMag-skewness()
    ## 528 528       fBodyBodyAccJerkMag-kurtosis()
    ## 529 529              fBodyBodyGyroMag-mean()
    ## 530 530               fBodyBodyGyroMag-std()
    ## 531 531               fBodyBodyGyroMag-mad()
    ## 532 532               fBodyBodyGyroMag-max()
    ## 533 533               fBodyBodyGyroMag-min()
    ## 534 534               fBodyBodyGyroMag-sma()
    ## 535 535            fBodyBodyGyroMag-energy()
    ## 536 536               fBodyBodyGyroMag-iqr()
    ## 537 537           fBodyBodyGyroMag-entropy()
    ## 538 538             fBodyBodyGyroMag-maxInds
    ## 539 539          fBodyBodyGyroMag-meanFreq()
    ## 540 540          fBodyBodyGyroMag-skewness()
    ## 541 541          fBodyBodyGyroMag-kurtosis()
    ## 542 542          fBodyBodyGyroJerkMag-mean()
    ## 543 543           fBodyBodyGyroJerkMag-std()
    ## 544 544           fBodyBodyGyroJerkMag-mad()
    ## 545 545           fBodyBodyGyroJerkMag-max()
    ## 546 546           fBodyBodyGyroJerkMag-min()
    ## 547 547           fBodyBodyGyroJerkMag-sma()
    ## 548 548        fBodyBodyGyroJerkMag-energy()
    ## 549 549           fBodyBodyGyroJerkMag-iqr()
    ## 550 550       fBodyBodyGyroJerkMag-entropy()
    ## 551 551         fBodyBodyGyroJerkMag-maxInds
    ## 552 552      fBodyBodyGyroJerkMag-meanFreq()
    ## 553 553      fBodyBodyGyroJerkMag-skewness()
    ## 554 554      fBodyBodyGyroJerkMag-kurtosis()
    ## 555 555          angle(tBodyAccMean,gravity)
    ## 556 556 angle(tBodyAccJerkMean),gravityMean)
    ## 557 557     angle(tBodyGyroMean,gravityMean)
    ## 558 558 angle(tBodyGyroJerkMean,gravityMean)
    ## 559 559                 angle(X,gravityMean)
    ## 560 560                 angle(Y,gravityMean)
    ## 561 561                 angle(Z,gravityMean)

Extract feature signals
-----------------------

``` r
featureSignals <- features %>%
    select(id, domain:axes, -starts_with("stat")) %>%
    mutate(axisSep = paste0(axisSep, axesSep),
           axesSep = NULL,
           axis1 = sub("(X)?Y?Z?","\\1",paste0(axis,axes)),
           axis2 = sub("X?(Y)?Z?","\\1",paste0(axis,axes)),
           axis3 = sub("X?Y?(Z)?","\\1",paste0(axis,axes)),
           axis = NULL,
           axes = NULL) %>%
    gather(seq, axis, axis1:axis3) %>%
    #mutate(seq = NULL) %>%
    mutate(seq = as.integer(sub("axis","",seq))) %>%
    filter(axis != "" | (axisSep == "" & magSuffix == "Mag")) %>%
    unite(signal, domain:axis, -seq, sep = "") %>%
    arrange(id) %>%
    distinct(id, signal, .keep_all = TRUE) %>%
    #left_join(signals, by = c("name"="name")) %>%
    print
```

    ##      id           signal seq
    ## 1     1       tBodyAcc-X   1
    ## 2     2       tBodyAcc-Y   2
    ## 3     3       tBodyAcc-Z   3
    ## 4     4       tBodyAcc-X   1
    ## 5     5       tBodyAcc-Y   2
    ## 6     6       tBodyAcc-Z   3
    ## 7     7       tBodyAcc-X   1
    ## 8     8       tBodyAcc-Y   2
    ## 9     9       tBodyAcc-Z   3
    ## 10   10       tBodyAcc-X   1
    ## 11   11       tBodyAcc-Y   2
    ## 12   12       tBodyAcc-Z   3
    ## 13   13       tBodyAcc-X   1
    ## 14   14       tBodyAcc-Y   2
    ## 15   15       tBodyAcc-Z   3
    ## 16   16       tBodyAcc-X   1
    ## 17   16       tBodyAcc-Y   2
    ## 18   16       tBodyAcc-Z   3
    ## 19   17       tBodyAcc-X   1
    ## 20   18       tBodyAcc-Y   2
    ## 21   19       tBodyAcc-Z   3
    ## 22   20       tBodyAcc-X   1
    ## 23   21       tBodyAcc-Y   2
    ## 24   22       tBodyAcc-Z   3
    ## 25   23       tBodyAcc-X   1
    ## 26   24       tBodyAcc-Y   2
    ## 27   25       tBodyAcc-Z   3
    ## 28   26       tBodyAcc-X   1
    ## 29   27       tBodyAcc-X   1
    ## 30   28       tBodyAcc-X   1
    ## 31   29       tBodyAcc-X   1
    ## 32   30       tBodyAcc-Y   2
    ## 33   31       tBodyAcc-Y   2
    ## 34   32       tBodyAcc-Y   2
    ## 35   33       tBodyAcc-Y   2
    ## 36   34       tBodyAcc-Z   3
    ## 37   35       tBodyAcc-Z   3
    ## 38   36       tBodyAcc-Z   3
    ## 39   37       tBodyAcc-Z   3
    ## 40   38       tBodyAcc-X   1
    ## 41   38       tBodyAcc-Y   2
    ## 42   39       tBodyAcc-X   1
    ## 43   39       tBodyAcc-Z   3
    ## 44   40       tBodyAcc-Y   2
    ## 45   40       tBodyAcc-Z   3
    ## 46   41    tGravityAcc-X   1
    ## 47   42    tGravityAcc-Y   2
    ## 48   43    tGravityAcc-Z   3
    ## 49   44    tGravityAcc-X   1
    ## 50   45    tGravityAcc-Y   2
    ## 51   46    tGravityAcc-Z   3
    ## 52   47    tGravityAcc-X   1
    ## 53   48    tGravityAcc-Y   2
    ## 54   49    tGravityAcc-Z   3
    ## 55   50    tGravityAcc-X   1
    ## 56   51    tGravityAcc-Y   2
    ## 57   52    tGravityAcc-Z   3
    ## 58   53    tGravityAcc-X   1
    ## 59   54    tGravityAcc-Y   2
    ## 60   55    tGravityAcc-Z   3
    ## 61   56    tGravityAcc-X   1
    ## 62   56    tGravityAcc-Y   2
    ## 63   56    tGravityAcc-Z   3
    ## 64   57    tGravityAcc-X   1
    ## 65   58    tGravityAcc-Y   2
    ## 66   59    tGravityAcc-Z   3
    ## 67   60    tGravityAcc-X   1
    ## 68   61    tGravityAcc-Y   2
    ## 69   62    tGravityAcc-Z   3
    ## 70   63    tGravityAcc-X   1
    ## 71   64    tGravityAcc-Y   2
    ## 72   65    tGravityAcc-Z   3
    ## 73   66    tGravityAcc-X   1
    ## 74   67    tGravityAcc-X   1
    ## 75   68    tGravityAcc-X   1
    ## 76   69    tGravityAcc-X   1
    ## 77   70    tGravityAcc-Y   2
    ## 78   71    tGravityAcc-Y   2
    ## 79   72    tGravityAcc-Y   2
    ## 80   73    tGravityAcc-Y   2
    ## 81   74    tGravityAcc-Z   3
    ## 82   75    tGravityAcc-Z   3
    ## 83   76    tGravityAcc-Z   3
    ## 84   77    tGravityAcc-Z   3
    ## 85   78    tGravityAcc-X   1
    ## 86   78    tGravityAcc-Y   2
    ## 87   79    tGravityAcc-X   1
    ## 88   79    tGravityAcc-Z   3
    ## 89   80    tGravityAcc-Y   2
    ## 90   80    tGravityAcc-Z   3
    ## 91   81   tBodyAccJerk-X   1
    ## 92   82   tBodyAccJerk-Y   2
    ## 93   83   tBodyAccJerk-Z   3
    ## 94   84   tBodyAccJerk-X   1
    ## 95   85   tBodyAccJerk-Y   2
    ## 96   86   tBodyAccJerk-Z   3
    ## 97   87   tBodyAccJerk-X   1
    ## 98   88   tBodyAccJerk-Y   2
    ## 99   89   tBodyAccJerk-Z   3
    ## 100  90   tBodyAccJerk-X   1
    ## 101  91   tBodyAccJerk-Y   2
    ## 102  92   tBodyAccJerk-Z   3
    ## 103  93   tBodyAccJerk-X   1
    ## 104  94   tBodyAccJerk-Y   2
    ## 105  95   tBodyAccJerk-Z   3
    ## 106  96   tBodyAccJerk-X   1
    ## 107  96   tBodyAccJerk-Y   2
    ## 108  96   tBodyAccJerk-Z   3
    ## 109  97   tBodyAccJerk-X   1
    ## 110  98   tBodyAccJerk-Y   2
    ## 111  99   tBodyAccJerk-Z   3
    ## 112 100   tBodyAccJerk-X   1
    ## 113 101   tBodyAccJerk-Y   2
    ## 114 102   tBodyAccJerk-Z   3
    ## 115 103   tBodyAccJerk-X   1
    ## 116 104   tBodyAccJerk-Y   2
    ## 117 105   tBodyAccJerk-Z   3
    ## 118 106   tBodyAccJerk-X   1
    ## 119 107   tBodyAccJerk-X   1
    ## 120 108   tBodyAccJerk-X   1
    ## 121 109   tBodyAccJerk-X   1
    ## 122 110   tBodyAccJerk-Y   2
    ## 123 111   tBodyAccJerk-Y   2
    ## 124 112   tBodyAccJerk-Y   2
    ## 125 113   tBodyAccJerk-Y   2
    ## 126 114   tBodyAccJerk-Z   3
    ## 127 115   tBodyAccJerk-Z   3
    ## 128 116   tBodyAccJerk-Z   3
    ## 129 117   tBodyAccJerk-Z   3
    ## 130 118   tBodyAccJerk-X   1
    ## 131 118   tBodyAccJerk-Y   2
    ## 132 119   tBodyAccJerk-X   1
    ## 133 119   tBodyAccJerk-Z   3
    ## 134 120   tBodyAccJerk-Y   2
    ## 135 120   tBodyAccJerk-Z   3
    ## 136 121      tBodyGyro-X   1
    ## 137 122      tBodyGyro-Y   2
    ## 138 123      tBodyGyro-Z   3
    ## 139 124      tBodyGyro-X   1
    ## 140 125      tBodyGyro-Y   2
    ## 141 126      tBodyGyro-Z   3
    ## 142 127      tBodyGyro-X   1
    ## 143 128      tBodyGyro-Y   2
    ## 144 129      tBodyGyro-Z   3
    ## 145 130      tBodyGyro-X   1
    ## 146 131      tBodyGyro-Y   2
    ## 147 132      tBodyGyro-Z   3
    ## 148 133      tBodyGyro-X   1
    ## 149 134      tBodyGyro-Y   2
    ## 150 135      tBodyGyro-Z   3
    ## 151 136      tBodyGyro-X   1
    ## 152 136      tBodyGyro-Y   2
    ## 153 136      tBodyGyro-Z   3
    ## 154 137      tBodyGyro-X   1
    ## 155 138      tBodyGyro-Y   2
    ## 156 139      tBodyGyro-Z   3
    ## 157 140      tBodyGyro-X   1
    ## 158 141      tBodyGyro-Y   2
    ## 159 142      tBodyGyro-Z   3
    ## 160 143      tBodyGyro-X   1
    ## 161 144      tBodyGyro-Y   2
    ## 162 145      tBodyGyro-Z   3
    ## 163 146      tBodyGyro-X   1
    ## 164 147      tBodyGyro-X   1
    ## 165 148      tBodyGyro-X   1
    ## 166 149      tBodyGyro-X   1
    ## 167 150      tBodyGyro-Y   2
    ## 168 151      tBodyGyro-Y   2
    ## 169 152      tBodyGyro-Y   2
    ## 170 153      tBodyGyro-Y   2
    ## 171 154      tBodyGyro-Z   3
    ## 172 155      tBodyGyro-Z   3
    ## 173 156      tBodyGyro-Z   3
    ## 174 157      tBodyGyro-Z   3
    ## 175 158      tBodyGyro-X   1
    ## 176 158      tBodyGyro-Y   2
    ## 177 159      tBodyGyro-X   1
    ## 178 159      tBodyGyro-Z   3
    ## 179 160      tBodyGyro-Y   2
    ## 180 160      tBodyGyro-Z   3
    ## 181 161  tBodyGyroJerk-X   1
    ## 182 162  tBodyGyroJerk-Y   2
    ## 183 163  tBodyGyroJerk-Z   3
    ## 184 164  tBodyGyroJerk-X   1
    ## 185 165  tBodyGyroJerk-Y   2
    ## 186 166  tBodyGyroJerk-Z   3
    ## 187 167  tBodyGyroJerk-X   1
    ## 188 168  tBodyGyroJerk-Y   2
    ## 189 169  tBodyGyroJerk-Z   3
    ## 190 170  tBodyGyroJerk-X   1
    ## 191 171  tBodyGyroJerk-Y   2
    ## 192 172  tBodyGyroJerk-Z   3
    ## 193 173  tBodyGyroJerk-X   1
    ## 194 174  tBodyGyroJerk-Y   2
    ## 195 175  tBodyGyroJerk-Z   3
    ## 196 176  tBodyGyroJerk-X   1
    ## 197 176  tBodyGyroJerk-Y   2
    ## 198 176  tBodyGyroJerk-Z   3
    ## 199 177  tBodyGyroJerk-X   1
    ## 200 178  tBodyGyroJerk-Y   2
    ## 201 179  tBodyGyroJerk-Z   3
    ## 202 180  tBodyGyroJerk-X   1
    ## 203 181  tBodyGyroJerk-Y   2
    ## 204 182  tBodyGyroJerk-Z   3
    ## 205 183  tBodyGyroJerk-X   1
    ## 206 184  tBodyGyroJerk-Y   2
    ## 207 185  tBodyGyroJerk-Z   3
    ## 208 186  tBodyGyroJerk-X   1
    ## 209 187  tBodyGyroJerk-X   1
    ## 210 188  tBodyGyroJerk-X   1
    ## 211 189  tBodyGyroJerk-X   1
    ## 212 190  tBodyGyroJerk-Y   2
    ## 213 191  tBodyGyroJerk-Y   2
    ## 214 192  tBodyGyroJerk-Y   2
    ## 215 193  tBodyGyroJerk-Y   2
    ## 216 194  tBodyGyroJerk-Z   3
    ## 217 195  tBodyGyroJerk-Z   3
    ## 218 196  tBodyGyroJerk-Z   3
    ## 219 197  tBodyGyroJerk-Z   3
    ## 220 198  tBodyGyroJerk-X   1
    ## 221 198  tBodyGyroJerk-Y   2
    ## 222 199  tBodyGyroJerk-X   1
    ## 223 199  tBodyGyroJerk-Z   3
    ## 224 200  tBodyGyroJerk-Y   2
    ## 225 200  tBodyGyroJerk-Z   3
    ## 226 201      tBodyAccMag   1
    ## 227 202      tBodyAccMag   1
    ## 228 203      tBodyAccMag   1
    ## 229 204      tBodyAccMag   1
    ## 230 205      tBodyAccMag   1
    ## 231 206      tBodyAccMag   1
    ## 232 207      tBodyAccMag   1
    ## 233 208      tBodyAccMag   1
    ## 234 209      tBodyAccMag   1
    ## 235 210      tBodyAccMag   1
    ## 236 211      tBodyAccMag   1
    ## 237 212      tBodyAccMag   1
    ## 238 213      tBodyAccMag   1
    ## 239 214   tGravityAccMag   1
    ## 240 215   tGravityAccMag   1
    ## 241 216   tGravityAccMag   1
    ## 242 217   tGravityAccMag   1
    ## 243 218   tGravityAccMag   1
    ## 244 219   tGravityAccMag   1
    ## 245 220   tGravityAccMag   1
    ## 246 221   tGravityAccMag   1
    ## 247 222   tGravityAccMag   1
    ## 248 223   tGravityAccMag   1
    ## 249 224   tGravityAccMag   1
    ## 250 225   tGravityAccMag   1
    ## 251 226   tGravityAccMag   1
    ## 252 227  tBodyAccJerkMag   1
    ## 253 228  tBodyAccJerkMag   1
    ## 254 229  tBodyAccJerkMag   1
    ## 255 230  tBodyAccJerkMag   1
    ## 256 231  tBodyAccJerkMag   1
    ## 257 232  tBodyAccJerkMag   1
    ## 258 233  tBodyAccJerkMag   1
    ## 259 234  tBodyAccJerkMag   1
    ## 260 235  tBodyAccJerkMag   1
    ## 261 236  tBodyAccJerkMag   1
    ## 262 237  tBodyAccJerkMag   1
    ## 263 238  tBodyAccJerkMag   1
    ## 264 239  tBodyAccJerkMag   1
    ## 265 240     tBodyGyroMag   1
    ## 266 241     tBodyGyroMag   1
    ## 267 242     tBodyGyroMag   1
    ## 268 243     tBodyGyroMag   1
    ## 269 244     tBodyGyroMag   1
    ## 270 245     tBodyGyroMag   1
    ## 271 246     tBodyGyroMag   1
    ## 272 247     tBodyGyroMag   1
    ## 273 248     tBodyGyroMag   1
    ## 274 249     tBodyGyroMag   1
    ## 275 250     tBodyGyroMag   1
    ## 276 251     tBodyGyroMag   1
    ## 277 252     tBodyGyroMag   1
    ## 278 253 tBodyGyroJerkMag   1
    ## 279 254 tBodyGyroJerkMag   1
    ## 280 255 tBodyGyroJerkMag   1
    ## 281 256 tBodyGyroJerkMag   1
    ## 282 257 tBodyGyroJerkMag   1
    ## 283 258 tBodyGyroJerkMag   1
    ## 284 259 tBodyGyroJerkMag   1
    ## 285 260 tBodyGyroJerkMag   1
    ## 286 261 tBodyGyroJerkMag   1
    ## 287 262 tBodyGyroJerkMag   1
    ## 288 263 tBodyGyroJerkMag   1
    ## 289 264 tBodyGyroJerkMag   1
    ## 290 265 tBodyGyroJerkMag   1
    ## 291 266       fBodyAcc-X   1
    ## 292 267       fBodyAcc-Y   2
    ## 293 268       fBodyAcc-Z   3
    ## 294 269       fBodyAcc-X   1
    ## 295 270       fBodyAcc-Y   2
    ## 296 271       fBodyAcc-Z   3
    ## 297 272       fBodyAcc-X   1
    ## 298 273       fBodyAcc-Y   2
    ## 299 274       fBodyAcc-Z   3
    ## 300 275       fBodyAcc-X   1
    ## 301 276       fBodyAcc-Y   2
    ## 302 277       fBodyAcc-Z   3
    ## 303 278       fBodyAcc-X   1
    ## 304 279       fBodyAcc-Y   2
    ## 305 280       fBodyAcc-Z   3
    ## 306 281       fBodyAcc-X   1
    ## 307 281       fBodyAcc-Y   2
    ## 308 281       fBodyAcc-Z   3
    ## 309 282       fBodyAcc-X   1
    ## 310 283       fBodyAcc-Y   2
    ## 311 284       fBodyAcc-Z   3
    ## 312 285       fBodyAcc-X   1
    ## 313 286       fBodyAcc-Y   2
    ## 314 287       fBodyAcc-Z   3
    ## 315 288       fBodyAcc-X   1
    ## 316 289       fBodyAcc-Y   2
    ## 317 290       fBodyAcc-Z   3
    ## 318 291       fBodyAcc-X   1
    ## 319 292       fBodyAcc-Y   2
    ## 320 293       fBodyAcc-Z   3
    ## 321 294       fBodyAcc-X   1
    ## 322 295       fBodyAcc-Y   2
    ## 323 296       fBodyAcc-Z   3
    ## 324 297       fBodyAcc-X   1
    ## 325 298       fBodyAcc-X   1
    ## 326 299       fBodyAcc-Y   2
    ## 327 300       fBodyAcc-Y   2
    ## 328 301       fBodyAcc-Z   3
    ## 329 302       fBodyAcc-Z   3
    ## 330 303       fBodyAcc-X   1
    ## 331 303       fBodyAcc-Y   2
    ## 332 303       fBodyAcc-Z   3
    ## 333 304       fBodyAcc-X   1
    ## 334 304       fBodyAcc-Y   2
    ## 335 304       fBodyAcc-Z   3
    ## 336 305       fBodyAcc-X   1
    ## 337 305       fBodyAcc-Y   2
    ## 338 305       fBodyAcc-Z   3
    ## 339 306       fBodyAcc-X   1
    ## 340 306       fBodyAcc-Y   2
    ## 341 306       fBodyAcc-Z   3
    ## 342 307       fBodyAcc-X   1
    ## 343 307       fBodyAcc-Y   2
    ## 344 307       fBodyAcc-Z   3
    ## 345 308       fBodyAcc-X   1
    ## 346 308       fBodyAcc-Y   2
    ## 347 308       fBodyAcc-Z   3
    ## 348 309       fBodyAcc-X   1
    ## 349 309       fBodyAcc-Y   2
    ## 350 309       fBodyAcc-Z   3
    ## 351 310       fBodyAcc-X   1
    ## 352 310       fBodyAcc-Y   2
    ## 353 310       fBodyAcc-Z   3
    ## 354 311       fBodyAcc-X   1
    ## 355 311       fBodyAcc-Y   2
    ## 356 311       fBodyAcc-Z   3
    ## 357 312       fBodyAcc-X   1
    ## 358 312       fBodyAcc-Y   2
    ## 359 312       fBodyAcc-Z   3
    ## 360 313       fBodyAcc-X   1
    ## 361 313       fBodyAcc-Y   2
    ## 362 313       fBodyAcc-Z   3
    ## 363 314       fBodyAcc-X   1
    ## 364 314       fBodyAcc-Y   2
    ## 365 314       fBodyAcc-Z   3
    ## 366 315       fBodyAcc-X   1
    ## 367 315       fBodyAcc-Y   2
    ## 368 315       fBodyAcc-Z   3
    ## 369 316       fBodyAcc-X   1
    ## 370 316       fBodyAcc-Y   2
    ## 371 316       fBodyAcc-Z   3
    ## 372 317       fBodyAcc-X   1
    ## 373 317       fBodyAcc-Y   2
    ## 374 317       fBodyAcc-Z   3
    ## 375 318       fBodyAcc-X   1
    ## 376 318       fBodyAcc-Y   2
    ## 377 318       fBodyAcc-Z   3
    ## 378 319       fBodyAcc-X   1
    ## 379 319       fBodyAcc-Y   2
    ## 380 319       fBodyAcc-Z   3
    ## 381 320       fBodyAcc-X   1
    ## 382 320       fBodyAcc-Y   2
    ## 383 320       fBodyAcc-Z   3
    ## 384 321       fBodyAcc-X   1
    ## 385 321       fBodyAcc-Y   2
    ## 386 321       fBodyAcc-Z   3
    ## 387 322       fBodyAcc-X   1
    ## 388 322       fBodyAcc-Y   2
    ## 389 322       fBodyAcc-Z   3
    ## 390 323       fBodyAcc-X   1
    ## 391 323       fBodyAcc-Y   2
    ## 392 323       fBodyAcc-Z   3
    ## 393 324       fBodyAcc-X   1
    ## 394 324       fBodyAcc-Y   2
    ## 395 324       fBodyAcc-Z   3
    ## 396 325       fBodyAcc-X   1
    ## 397 325       fBodyAcc-Y   2
    ## 398 325       fBodyAcc-Z   3
    ## 399 326       fBodyAcc-X   1
    ## 400 326       fBodyAcc-Y   2
    ## 401 326       fBodyAcc-Z   3
    ## 402 327       fBodyAcc-X   1
    ## 403 327       fBodyAcc-Y   2
    ## 404 327       fBodyAcc-Z   3
    ## 405 328       fBodyAcc-X   1
    ## 406 328       fBodyAcc-Y   2
    ## 407 328       fBodyAcc-Z   3
    ## 408 329       fBodyAcc-X   1
    ## 409 329       fBodyAcc-Y   2
    ## 410 329       fBodyAcc-Z   3
    ## 411 330       fBodyAcc-X   1
    ## 412 330       fBodyAcc-Y   2
    ## 413 330       fBodyAcc-Z   3
    ## 414 331       fBodyAcc-X   1
    ## 415 331       fBodyAcc-Y   2
    ## 416 331       fBodyAcc-Z   3
    ## 417 332       fBodyAcc-X   1
    ## 418 332       fBodyAcc-Y   2
    ## 419 332       fBodyAcc-Z   3
    ## 420 333       fBodyAcc-X   1
    ## 421 333       fBodyAcc-Y   2
    ## 422 333       fBodyAcc-Z   3
    ## 423 334       fBodyAcc-X   1
    ## 424 334       fBodyAcc-Y   2
    ## 425 334       fBodyAcc-Z   3
    ## 426 335       fBodyAcc-X   1
    ## 427 335       fBodyAcc-Y   2
    ## 428 335       fBodyAcc-Z   3
    ## 429 336       fBodyAcc-X   1
    ## 430 336       fBodyAcc-Y   2
    ## 431 336       fBodyAcc-Z   3
    ## 432 337       fBodyAcc-X   1
    ## 433 337       fBodyAcc-Y   2
    ## 434 337       fBodyAcc-Z   3
    ## 435 338       fBodyAcc-X   1
    ## 436 338       fBodyAcc-Y   2
    ## 437 338       fBodyAcc-Z   3
    ## 438 339       fBodyAcc-X   1
    ## 439 339       fBodyAcc-Y   2
    ## 440 339       fBodyAcc-Z   3
    ## 441 340       fBodyAcc-X   1
    ## 442 340       fBodyAcc-Y   2
    ## 443 340       fBodyAcc-Z   3
    ## 444 341       fBodyAcc-X   1
    ## 445 341       fBodyAcc-Y   2
    ## 446 341       fBodyAcc-Z   3
    ## 447 342       fBodyAcc-X   1
    ## 448 342       fBodyAcc-Y   2
    ## 449 342       fBodyAcc-Z   3
    ## 450 343       fBodyAcc-X   1
    ## 451 343       fBodyAcc-Y   2
    ## 452 343       fBodyAcc-Z   3
    ## 453 344       fBodyAcc-X   1
    ## 454 344       fBodyAcc-Y   2
    ## 455 344       fBodyAcc-Z   3
    ## 456 345   fBodyAccJerk-X   1
    ## 457 346   fBodyAccJerk-Y   2
    ## 458 347   fBodyAccJerk-Z   3
    ## 459 348   fBodyAccJerk-X   1
    ## 460 349   fBodyAccJerk-Y   2
    ## 461 350   fBodyAccJerk-Z   3
    ## 462 351   fBodyAccJerk-X   1
    ## 463 352   fBodyAccJerk-Y   2
    ## 464 353   fBodyAccJerk-Z   3
    ## 465 354   fBodyAccJerk-X   1
    ## 466 355   fBodyAccJerk-Y   2
    ## 467 356   fBodyAccJerk-Z   3
    ## 468 357   fBodyAccJerk-X   1
    ## 469 358   fBodyAccJerk-Y   2
    ## 470 359   fBodyAccJerk-Z   3
    ## 471 360   fBodyAccJerk-X   1
    ## 472 360   fBodyAccJerk-Y   2
    ## 473 360   fBodyAccJerk-Z   3
    ## 474 361   fBodyAccJerk-X   1
    ## 475 362   fBodyAccJerk-Y   2
    ## 476 363   fBodyAccJerk-Z   3
    ## 477 364   fBodyAccJerk-X   1
    ## 478 365   fBodyAccJerk-Y   2
    ## 479 366   fBodyAccJerk-Z   3
    ## 480 367   fBodyAccJerk-X   1
    ## 481 368   fBodyAccJerk-Y   2
    ## 482 369   fBodyAccJerk-Z   3
    ## 483 370   fBodyAccJerk-X   1
    ## 484 371   fBodyAccJerk-Y   2
    ## 485 372   fBodyAccJerk-Z   3
    ## 486 373   fBodyAccJerk-X   1
    ## 487 374   fBodyAccJerk-Y   2
    ## 488 375   fBodyAccJerk-Z   3
    ## 489 376   fBodyAccJerk-X   1
    ## 490 377   fBodyAccJerk-X   1
    ## 491 378   fBodyAccJerk-Y   2
    ## 492 379   fBodyAccJerk-Y   2
    ## 493 380   fBodyAccJerk-Z   3
    ## 494 381   fBodyAccJerk-Z   3
    ## 495 382   fBodyAccJerk-X   1
    ## 496 382   fBodyAccJerk-Y   2
    ## 497 382   fBodyAccJerk-Z   3
    ## 498 383   fBodyAccJerk-X   1
    ## 499 383   fBodyAccJerk-Y   2
    ## 500 383   fBodyAccJerk-Z   3
    ## 501 384   fBodyAccJerk-X   1
    ## 502 384   fBodyAccJerk-Y   2
    ## 503 384   fBodyAccJerk-Z   3
    ## 504 385   fBodyAccJerk-X   1
    ## 505 385   fBodyAccJerk-Y   2
    ## 506 385   fBodyAccJerk-Z   3
    ## 507 386   fBodyAccJerk-X   1
    ## 508 386   fBodyAccJerk-Y   2
    ## 509 386   fBodyAccJerk-Z   3
    ## 510 387   fBodyAccJerk-X   1
    ## 511 387   fBodyAccJerk-Y   2
    ## 512 387   fBodyAccJerk-Z   3
    ## 513 388   fBodyAccJerk-X   1
    ## 514 388   fBodyAccJerk-Y   2
    ## 515 388   fBodyAccJerk-Z   3
    ## 516 389   fBodyAccJerk-X   1
    ## 517 389   fBodyAccJerk-Y   2
    ## 518 389   fBodyAccJerk-Z   3
    ## 519 390   fBodyAccJerk-X   1
    ## 520 390   fBodyAccJerk-Y   2
    ## 521 390   fBodyAccJerk-Z   3
    ## 522 391   fBodyAccJerk-X   1
    ## 523 391   fBodyAccJerk-Y   2
    ## 524 391   fBodyAccJerk-Z   3
    ## 525 392   fBodyAccJerk-X   1
    ## 526 392   fBodyAccJerk-Y   2
    ## 527 392   fBodyAccJerk-Z   3
    ## 528 393   fBodyAccJerk-X   1
    ## 529 393   fBodyAccJerk-Y   2
    ## 530 393   fBodyAccJerk-Z   3
    ## 531 394   fBodyAccJerk-X   1
    ## 532 394   fBodyAccJerk-Y   2
    ## 533 394   fBodyAccJerk-Z   3
    ## 534 395   fBodyAccJerk-X   1
    ## 535 395   fBodyAccJerk-Y   2
    ## 536 395   fBodyAccJerk-Z   3
    ## 537 396   fBodyAccJerk-X   1
    ## 538 396   fBodyAccJerk-Y   2
    ## 539 396   fBodyAccJerk-Z   3
    ## 540 397   fBodyAccJerk-X   1
    ## 541 397   fBodyAccJerk-Y   2
    ## 542 397   fBodyAccJerk-Z   3
    ## 543 398   fBodyAccJerk-X   1
    ## 544 398   fBodyAccJerk-Y   2
    ## 545 398   fBodyAccJerk-Z   3
    ## 546 399   fBodyAccJerk-X   1
    ## 547 399   fBodyAccJerk-Y   2
    ## 548 399   fBodyAccJerk-Z   3
    ## 549 400   fBodyAccJerk-X   1
    ## 550 400   fBodyAccJerk-Y   2
    ## 551 400   fBodyAccJerk-Z   3
    ## 552 401   fBodyAccJerk-X   1
    ## 553 401   fBodyAccJerk-Y   2
    ## 554 401   fBodyAccJerk-Z   3
    ## 555 402   fBodyAccJerk-X   1
    ## 556 402   fBodyAccJerk-Y   2
    ## 557 402   fBodyAccJerk-Z   3
    ## 558 403   fBodyAccJerk-X   1
    ## 559 403   fBodyAccJerk-Y   2
    ## 560 403   fBodyAccJerk-Z   3
    ## 561 404   fBodyAccJerk-X   1
    ## 562 404   fBodyAccJerk-Y   2
    ## 563 404   fBodyAccJerk-Z   3
    ## 564 405   fBodyAccJerk-X   1
    ## 565 405   fBodyAccJerk-Y   2
    ## 566 405   fBodyAccJerk-Z   3
    ## 567 406   fBodyAccJerk-X   1
    ## 568 406   fBodyAccJerk-Y   2
    ## 569 406   fBodyAccJerk-Z   3
    ## 570 407   fBodyAccJerk-X   1
    ## 571 407   fBodyAccJerk-Y   2
    ## 572 407   fBodyAccJerk-Z   3
    ## 573 408   fBodyAccJerk-X   1
    ## 574 408   fBodyAccJerk-Y   2
    ## 575 408   fBodyAccJerk-Z   3
    ## 576 409   fBodyAccJerk-X   1
    ## 577 409   fBodyAccJerk-Y   2
    ## 578 409   fBodyAccJerk-Z   3
    ## 579 410   fBodyAccJerk-X   1
    ## 580 410   fBodyAccJerk-Y   2
    ## 581 410   fBodyAccJerk-Z   3
    ## 582 411   fBodyAccJerk-X   1
    ## 583 411   fBodyAccJerk-Y   2
    ## 584 411   fBodyAccJerk-Z   3
    ## 585 412   fBodyAccJerk-X   1
    ## 586 412   fBodyAccJerk-Y   2
    ## 587 412   fBodyAccJerk-Z   3
    ## 588 413   fBodyAccJerk-X   1
    ## 589 413   fBodyAccJerk-Y   2
    ## 590 413   fBodyAccJerk-Z   3
    ## 591 414   fBodyAccJerk-X   1
    ## 592 414   fBodyAccJerk-Y   2
    ## 593 414   fBodyAccJerk-Z   3
    ## 594 415   fBodyAccJerk-X   1
    ## 595 415   fBodyAccJerk-Y   2
    ## 596 415   fBodyAccJerk-Z   3
    ## 597 416   fBodyAccJerk-X   1
    ## 598 416   fBodyAccJerk-Y   2
    ## 599 416   fBodyAccJerk-Z   3
    ## 600 417   fBodyAccJerk-X   1
    ## 601 417   fBodyAccJerk-Y   2
    ## 602 417   fBodyAccJerk-Z   3
    ## 603 418   fBodyAccJerk-X   1
    ## 604 418   fBodyAccJerk-Y   2
    ## 605 418   fBodyAccJerk-Z   3
    ## 606 419   fBodyAccJerk-X   1
    ## 607 419   fBodyAccJerk-Y   2
    ## 608 419   fBodyAccJerk-Z   3
    ## 609 420   fBodyAccJerk-X   1
    ## 610 420   fBodyAccJerk-Y   2
    ## 611 420   fBodyAccJerk-Z   3
    ## 612 421   fBodyAccJerk-X   1
    ## 613 421   fBodyAccJerk-Y   2
    ## 614 421   fBodyAccJerk-Z   3
    ## 615 422   fBodyAccJerk-X   1
    ## 616 422   fBodyAccJerk-Y   2
    ## 617 422   fBodyAccJerk-Z   3
    ## 618 423   fBodyAccJerk-X   1
    ## 619 423   fBodyAccJerk-Y   2
    ## 620 423   fBodyAccJerk-Z   3
    ## 621 424      fBodyGyro-X   1
    ## 622 425      fBodyGyro-Y   2
    ## 623 426      fBodyGyro-Z   3
    ## 624 427      fBodyGyro-X   1
    ## 625 428      fBodyGyro-Y   2
    ## 626 429      fBodyGyro-Z   3
    ## 627 430      fBodyGyro-X   1
    ## 628 431      fBodyGyro-Y   2
    ## 629 432      fBodyGyro-Z   3
    ## 630 433      fBodyGyro-X   1
    ## 631 434      fBodyGyro-Y   2
    ## 632 435      fBodyGyro-Z   3
    ## 633 436      fBodyGyro-X   1
    ## 634 437      fBodyGyro-Y   2
    ## 635 438      fBodyGyro-Z   3
    ## 636 439      fBodyGyro-X   1
    ## 637 439      fBodyGyro-Y   2
    ## 638 439      fBodyGyro-Z   3
    ## 639 440      fBodyGyro-X   1
    ## 640 441      fBodyGyro-Y   2
    ## 641 442      fBodyGyro-Z   3
    ## 642 443      fBodyGyro-X   1
    ## 643 444      fBodyGyro-Y   2
    ## 644 445      fBodyGyro-Z   3
    ## 645 446      fBodyGyro-X   1
    ## 646 447      fBodyGyro-Y   2
    ## 647 448      fBodyGyro-Z   3
    ## 648 449      fBodyGyro-X   1
    ## 649 450      fBodyGyro-Y   2
    ## 650 451      fBodyGyro-Z   3
    ## 651 452      fBodyGyro-X   1
    ## 652 453      fBodyGyro-Y   2
    ## 653 454      fBodyGyro-Z   3
    ## 654 455      fBodyGyro-X   1
    ## 655 456      fBodyGyro-X   1
    ## 656 457      fBodyGyro-Y   2
    ## 657 458      fBodyGyro-Y   2
    ## 658 459      fBodyGyro-Z   3
    ## 659 460      fBodyGyro-Z   3
    ## 660 461      fBodyGyro-X   1
    ## 661 461      fBodyGyro-Y   2
    ## 662 461      fBodyGyro-Z   3
    ## 663 462      fBodyGyro-X   1
    ## 664 462      fBodyGyro-Y   2
    ## 665 462      fBodyGyro-Z   3
    ## 666 463      fBodyGyro-X   1
    ## 667 463      fBodyGyro-Y   2
    ## 668 463      fBodyGyro-Z   3
    ## 669 464      fBodyGyro-X   1
    ## 670 464      fBodyGyro-Y   2
    ## 671 464      fBodyGyro-Z   3
    ## 672 465      fBodyGyro-X   1
    ## 673 465      fBodyGyro-Y   2
    ## 674 465      fBodyGyro-Z   3
    ## 675 466      fBodyGyro-X   1
    ## 676 466      fBodyGyro-Y   2
    ## 677 466      fBodyGyro-Z   3
    ## 678 467      fBodyGyro-X   1
    ## 679 467      fBodyGyro-Y   2
    ## 680 467      fBodyGyro-Z   3
    ## 681 468      fBodyGyro-X   1
    ## 682 468      fBodyGyro-Y   2
    ## 683 468      fBodyGyro-Z   3
    ## 684 469      fBodyGyro-X   1
    ## 685 469      fBodyGyro-Y   2
    ## 686 469      fBodyGyro-Z   3
    ## 687 470      fBodyGyro-X   1
    ## 688 470      fBodyGyro-Y   2
    ## 689 470      fBodyGyro-Z   3
    ## 690 471      fBodyGyro-X   1
    ## 691 471      fBodyGyro-Y   2
    ## 692 471      fBodyGyro-Z   3
    ## 693 472      fBodyGyro-X   1
    ## 694 472      fBodyGyro-Y   2
    ## 695 472      fBodyGyro-Z   3
    ## 696 473      fBodyGyro-X   1
    ## 697 473      fBodyGyro-Y   2
    ## 698 473      fBodyGyro-Z   3
    ## 699 474      fBodyGyro-X   1
    ## 700 474      fBodyGyro-Y   2
    ## 701 474      fBodyGyro-Z   3
    ## 702 475      fBodyGyro-X   1
    ## 703 475      fBodyGyro-Y   2
    ## 704 475      fBodyGyro-Z   3
    ## 705 476      fBodyGyro-X   1
    ## 706 476      fBodyGyro-Y   2
    ## 707 476      fBodyGyro-Z   3
    ## 708 477      fBodyGyro-X   1
    ## 709 477      fBodyGyro-Y   2
    ## 710 477      fBodyGyro-Z   3
    ## 711 478      fBodyGyro-X   1
    ## 712 478      fBodyGyro-Y   2
    ## 713 478      fBodyGyro-Z   3
    ## 714 479      fBodyGyro-X   1
    ## 715 479      fBodyGyro-Y   2
    ## 716 479      fBodyGyro-Z   3
    ## 717 480      fBodyGyro-X   1
    ## 718 480      fBodyGyro-Y   2
    ## 719 480      fBodyGyro-Z   3
    ## 720 481      fBodyGyro-X   1
    ## 721 481      fBodyGyro-Y   2
    ## 722 481      fBodyGyro-Z   3
    ## 723 482      fBodyGyro-X   1
    ## 724 482      fBodyGyro-Y   2
    ## 725 482      fBodyGyro-Z   3
    ## 726 483      fBodyGyro-X   1
    ## 727 483      fBodyGyro-Y   2
    ## 728 483      fBodyGyro-Z   3
    ## 729 484      fBodyGyro-X   1
    ## 730 484      fBodyGyro-Y   2
    ## 731 484      fBodyGyro-Z   3
    ## 732 485      fBodyGyro-X   1
    ## 733 485      fBodyGyro-Y   2
    ## 734 485      fBodyGyro-Z   3
    ## 735 486      fBodyGyro-X   1
    ## 736 486      fBodyGyro-Y   2
    ## 737 486      fBodyGyro-Z   3
    ## 738 487      fBodyGyro-X   1
    ## 739 487      fBodyGyro-Y   2
    ## 740 487      fBodyGyro-Z   3
    ## 741 488      fBodyGyro-X   1
    ## 742 488      fBodyGyro-Y   2
    ## 743 488      fBodyGyro-Z   3
    ## 744 489      fBodyGyro-X   1
    ## 745 489      fBodyGyro-Y   2
    ## 746 489      fBodyGyro-Z   3
    ## 747 490      fBodyGyro-X   1
    ## 748 490      fBodyGyro-Y   2
    ## 749 490      fBodyGyro-Z   3
    ## 750 491      fBodyGyro-X   1
    ## 751 491      fBodyGyro-Y   2
    ## 752 491      fBodyGyro-Z   3
    ## 753 492      fBodyGyro-X   1
    ## 754 492      fBodyGyro-Y   2
    ## 755 492      fBodyGyro-Z   3
    ## 756 493      fBodyGyro-X   1
    ## 757 493      fBodyGyro-Y   2
    ## 758 493      fBodyGyro-Z   3
    ## 759 494      fBodyGyro-X   1
    ## 760 494      fBodyGyro-Y   2
    ## 761 494      fBodyGyro-Z   3
    ## 762 495      fBodyGyro-X   1
    ## 763 495      fBodyGyro-Y   2
    ## 764 495      fBodyGyro-Z   3
    ## 765 496      fBodyGyro-X   1
    ## 766 496      fBodyGyro-Y   2
    ## 767 496      fBodyGyro-Z   3
    ## 768 497      fBodyGyro-X   1
    ## 769 497      fBodyGyro-Y   2
    ## 770 497      fBodyGyro-Z   3
    ## 771 498      fBodyGyro-X   1
    ## 772 498      fBodyGyro-Y   2
    ## 773 498      fBodyGyro-Z   3
    ## 774 499      fBodyGyro-X   1
    ## 775 499      fBodyGyro-Y   2
    ## 776 499      fBodyGyro-Z   3
    ## 777 500      fBodyGyro-X   1
    ## 778 500      fBodyGyro-Y   2
    ## 779 500      fBodyGyro-Z   3
    ## 780 501      fBodyGyro-X   1
    ## 781 501      fBodyGyro-Y   2
    ## 782 501      fBodyGyro-Z   3
    ## 783 502      fBodyGyro-X   1
    ## 784 502      fBodyGyro-Y   2
    ## 785 502      fBodyGyro-Z   3
    ## 786 503      fBodyAccMag   1
    ## 787 504      fBodyAccMag   1
    ## 788 505      fBodyAccMag   1
    ## 789 506      fBodyAccMag   1
    ## 790 507      fBodyAccMag   1
    ## 791 508      fBodyAccMag   1
    ## 792 509      fBodyAccMag   1
    ## 793 510      fBodyAccMag   1
    ## 794 511      fBodyAccMag   1
    ## 795 512      fBodyAccMag   1
    ## 796 513      fBodyAccMag   1
    ## 797 514      fBodyAccMag   1
    ## 798 515      fBodyAccMag   1
    ## 799 516  fBodyAccJerkMag   1
    ## 800 517  fBodyAccJerkMag   1
    ## 801 518  fBodyAccJerkMag   1
    ## 802 519  fBodyAccJerkMag   1
    ## 803 520  fBodyAccJerkMag   1
    ## 804 521  fBodyAccJerkMag   1
    ## 805 522  fBodyAccJerkMag   1
    ## 806 523  fBodyAccJerkMag   1
    ## 807 524  fBodyAccJerkMag   1
    ## 808 525  fBodyAccJerkMag   1
    ## 809 526  fBodyAccJerkMag   1
    ## 810 527  fBodyAccJerkMag   1
    ## 811 528  fBodyAccJerkMag   1
    ## 812 529     fBodyGyroMag   1
    ## 813 530     fBodyGyroMag   1
    ## 814 531     fBodyGyroMag   1
    ## 815 532     fBodyGyroMag   1
    ## 816 533     fBodyGyroMag   1
    ## 817 534     fBodyGyroMag   1
    ## 818 535     fBodyGyroMag   1
    ## 819 536     fBodyGyroMag   1
    ## 820 537     fBodyGyroMag   1
    ## 821 538     fBodyGyroMag   1
    ## 822 539     fBodyGyroMag   1
    ## 823 540     fBodyGyroMag   1
    ## 824 541     fBodyGyroMag   1
    ## 825 542 fBodyGyroJerkMag   1
    ## 826 543 fBodyGyroJerkMag   1
    ## 827 544 fBodyGyroJerkMag   1
    ## 828 545 fBodyGyroJerkMag   1
    ## 829 546 fBodyGyroJerkMag   1
    ## 830 547 fBodyGyroJerkMag   1
    ## 831 548 fBodyGyroJerkMag   1
    ## 832 549 fBodyGyroJerkMag   1
    ## 833 550 fBodyGyroJerkMag   1
    ## 834 551 fBodyGyroJerkMag   1
    ## 835 552 fBodyGyroJerkMag   1
    ## 836 553 fBodyGyroJerkMag   1
    ## 837 554 fBodyGyroJerkMag   1

Test: Feature name pattern identification regular expressions
-------------------------------------------------------------

``` r
features %>%
    slice(grep("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?(-)",name)) %>%
    print
```

    ##      id                             name domain  prefix rawSignal
    ## 1     1                tBodyAcc-mean()-X      t    Body       Acc
    ## 2     2                tBodyAcc-mean()-Y      t    Body       Acc
    ## 3     3                tBodyAcc-mean()-Z      t    Body       Acc
    ## 4     4                 tBodyAcc-std()-X      t    Body       Acc
    ## 5     5                 tBodyAcc-std()-Y      t    Body       Acc
    ## 6     6                 tBodyAcc-std()-Z      t    Body       Acc
    ## 7     7                 tBodyAcc-mad()-X      t    Body       Acc
    ## 8     8                 tBodyAcc-mad()-Y      t    Body       Acc
    ## 9     9                 tBodyAcc-mad()-Z      t    Body       Acc
    ## 10   10                 tBodyAcc-max()-X      t    Body       Acc
    ## 11   11                 tBodyAcc-max()-Y      t    Body       Acc
    ## 12   12                 tBodyAcc-max()-Z      t    Body       Acc
    ## 13   13                 tBodyAcc-min()-X      t    Body       Acc
    ## 14   14                 tBodyAcc-min()-Y      t    Body       Acc
    ## 15   15                 tBodyAcc-min()-Z      t    Body       Acc
    ## 16   16                   tBodyAcc-sma()      t    Body       Acc
    ## 17   17              tBodyAcc-energy()-X      t    Body       Acc
    ## 18   18              tBodyAcc-energy()-Y      t    Body       Acc
    ## 19   19              tBodyAcc-energy()-Z      t    Body       Acc
    ## 20   20                 tBodyAcc-iqr()-X      t    Body       Acc
    ## 21   21                 tBodyAcc-iqr()-Y      t    Body       Acc
    ## 22   22                 tBodyAcc-iqr()-Z      t    Body       Acc
    ## 23   23             tBodyAcc-entropy()-X      t    Body       Acc
    ## 24   24             tBodyAcc-entropy()-Y      t    Body       Acc
    ## 25   25             tBodyAcc-entropy()-Z      t    Body       Acc
    ## 26   26           tBodyAcc-arCoeff()-X,1      t    Body       Acc
    ## 27   27           tBodyAcc-arCoeff()-X,2      t    Body       Acc
    ## 28   28           tBodyAcc-arCoeff()-X,3      t    Body       Acc
    ## 29   29           tBodyAcc-arCoeff()-X,4      t    Body       Acc
    ## 30   30           tBodyAcc-arCoeff()-Y,1      t    Body       Acc
    ## 31   31           tBodyAcc-arCoeff()-Y,2      t    Body       Acc
    ## 32   32           tBodyAcc-arCoeff()-Y,3      t    Body       Acc
    ## 33   33           tBodyAcc-arCoeff()-Y,4      t    Body       Acc
    ## 34   34           tBodyAcc-arCoeff()-Z,1      t    Body       Acc
    ## 35   35           tBodyAcc-arCoeff()-Z,2      t    Body       Acc
    ## 36   36           tBodyAcc-arCoeff()-Z,3      t    Body       Acc
    ## 37   37           tBodyAcc-arCoeff()-Z,4      t    Body       Acc
    ## 38   38       tBodyAcc-correlation()-X,Y      t    Body       Acc
    ## 39   39       tBodyAcc-correlation()-X,Z      t    Body       Acc
    ## 40   40       tBodyAcc-correlation()-Y,Z      t    Body       Acc
    ## 41   41             tGravityAcc-mean()-X      t Gravity       Acc
    ## 42   42             tGravityAcc-mean()-Y      t Gravity       Acc
    ## 43   43             tGravityAcc-mean()-Z      t Gravity       Acc
    ## 44   44              tGravityAcc-std()-X      t Gravity       Acc
    ## 45   45              tGravityAcc-std()-Y      t Gravity       Acc
    ## 46   46              tGravityAcc-std()-Z      t Gravity       Acc
    ## 47   47              tGravityAcc-mad()-X      t Gravity       Acc
    ## 48   48              tGravityAcc-mad()-Y      t Gravity       Acc
    ## 49   49              tGravityAcc-mad()-Z      t Gravity       Acc
    ## 50   50              tGravityAcc-max()-X      t Gravity       Acc
    ## 51   51              tGravityAcc-max()-Y      t Gravity       Acc
    ## 52   52              tGravityAcc-max()-Z      t Gravity       Acc
    ## 53   53              tGravityAcc-min()-X      t Gravity       Acc
    ## 54   54              tGravityAcc-min()-Y      t Gravity       Acc
    ## 55   55              tGravityAcc-min()-Z      t Gravity       Acc
    ## 56   56                tGravityAcc-sma()      t Gravity       Acc
    ## 57   57           tGravityAcc-energy()-X      t Gravity       Acc
    ## 58   58           tGravityAcc-energy()-Y      t Gravity       Acc
    ## 59   59           tGravityAcc-energy()-Z      t Gravity       Acc
    ## 60   60              tGravityAcc-iqr()-X      t Gravity       Acc
    ## 61   61              tGravityAcc-iqr()-Y      t Gravity       Acc
    ## 62   62              tGravityAcc-iqr()-Z      t Gravity       Acc
    ## 63   63          tGravityAcc-entropy()-X      t Gravity       Acc
    ## 64   64          tGravityAcc-entropy()-Y      t Gravity       Acc
    ## 65   65          tGravityAcc-entropy()-Z      t Gravity       Acc
    ## 66   66        tGravityAcc-arCoeff()-X,1      t Gravity       Acc
    ## 67   67        tGravityAcc-arCoeff()-X,2      t Gravity       Acc
    ## 68   68        tGravityAcc-arCoeff()-X,3      t Gravity       Acc
    ## 69   69        tGravityAcc-arCoeff()-X,4      t Gravity       Acc
    ## 70   70        tGravityAcc-arCoeff()-Y,1      t Gravity       Acc
    ## 71   71        tGravityAcc-arCoeff()-Y,2      t Gravity       Acc
    ## 72   72        tGravityAcc-arCoeff()-Y,3      t Gravity       Acc
    ## 73   73        tGravityAcc-arCoeff()-Y,4      t Gravity       Acc
    ## 74   74        tGravityAcc-arCoeff()-Z,1      t Gravity       Acc
    ## 75   75        tGravityAcc-arCoeff()-Z,2      t Gravity       Acc
    ## 76   76        tGravityAcc-arCoeff()-Z,3      t Gravity       Acc
    ## 77   77        tGravityAcc-arCoeff()-Z,4      t Gravity       Acc
    ## 78   78    tGravityAcc-correlation()-X,Y      t Gravity       Acc
    ## 79   79    tGravityAcc-correlation()-X,Z      t Gravity       Acc
    ## 80   80    tGravityAcc-correlation()-Y,Z      t Gravity       Acc
    ## 81   81            tBodyAccJerk-mean()-X      t    Body       Acc
    ## 82   82            tBodyAccJerk-mean()-Y      t    Body       Acc
    ## 83   83            tBodyAccJerk-mean()-Z      t    Body       Acc
    ## 84   84             tBodyAccJerk-std()-X      t    Body       Acc
    ## 85   85             tBodyAccJerk-std()-Y      t    Body       Acc
    ## 86   86             tBodyAccJerk-std()-Z      t    Body       Acc
    ## 87   87             tBodyAccJerk-mad()-X      t    Body       Acc
    ## 88   88             tBodyAccJerk-mad()-Y      t    Body       Acc
    ## 89   89             tBodyAccJerk-mad()-Z      t    Body       Acc
    ## 90   90             tBodyAccJerk-max()-X      t    Body       Acc
    ## 91   91             tBodyAccJerk-max()-Y      t    Body       Acc
    ## 92   92             tBodyAccJerk-max()-Z      t    Body       Acc
    ## 93   93             tBodyAccJerk-min()-X      t    Body       Acc
    ## 94   94             tBodyAccJerk-min()-Y      t    Body       Acc
    ## 95   95             tBodyAccJerk-min()-Z      t    Body       Acc
    ## 96   96               tBodyAccJerk-sma()      t    Body       Acc
    ## 97   97          tBodyAccJerk-energy()-X      t    Body       Acc
    ## 98   98          tBodyAccJerk-energy()-Y      t    Body       Acc
    ## 99   99          tBodyAccJerk-energy()-Z      t    Body       Acc
    ## 100 100             tBodyAccJerk-iqr()-X      t    Body       Acc
    ## 101 101             tBodyAccJerk-iqr()-Y      t    Body       Acc
    ## 102 102             tBodyAccJerk-iqr()-Z      t    Body       Acc
    ## 103 103         tBodyAccJerk-entropy()-X      t    Body       Acc
    ## 104 104         tBodyAccJerk-entropy()-Y      t    Body       Acc
    ## 105 105         tBodyAccJerk-entropy()-Z      t    Body       Acc
    ## 106 106       tBodyAccJerk-arCoeff()-X,1      t    Body       Acc
    ## 107 107       tBodyAccJerk-arCoeff()-X,2      t    Body       Acc
    ## 108 108       tBodyAccJerk-arCoeff()-X,3      t    Body       Acc
    ## 109 109       tBodyAccJerk-arCoeff()-X,4      t    Body       Acc
    ## 110 110       tBodyAccJerk-arCoeff()-Y,1      t    Body       Acc
    ## 111 111       tBodyAccJerk-arCoeff()-Y,2      t    Body       Acc
    ## 112 112       tBodyAccJerk-arCoeff()-Y,3      t    Body       Acc
    ## 113 113       tBodyAccJerk-arCoeff()-Y,4      t    Body       Acc
    ## 114 114       tBodyAccJerk-arCoeff()-Z,1      t    Body       Acc
    ## 115 115       tBodyAccJerk-arCoeff()-Z,2      t    Body       Acc
    ## 116 116       tBodyAccJerk-arCoeff()-Z,3      t    Body       Acc
    ## 117 117       tBodyAccJerk-arCoeff()-Z,4      t    Body       Acc
    ## 118 118   tBodyAccJerk-correlation()-X,Y      t    Body       Acc
    ## 119 119   tBodyAccJerk-correlation()-X,Z      t    Body       Acc
    ## 120 120   tBodyAccJerk-correlation()-Y,Z      t    Body       Acc
    ## 121 121               tBodyGyro-mean()-X      t    Body      Gyro
    ## 122 122               tBodyGyro-mean()-Y      t    Body      Gyro
    ## 123 123               tBodyGyro-mean()-Z      t    Body      Gyro
    ## 124 124                tBodyGyro-std()-X      t    Body      Gyro
    ## 125 125                tBodyGyro-std()-Y      t    Body      Gyro
    ## 126 126                tBodyGyro-std()-Z      t    Body      Gyro
    ## 127 127                tBodyGyro-mad()-X      t    Body      Gyro
    ## 128 128                tBodyGyro-mad()-Y      t    Body      Gyro
    ## 129 129                tBodyGyro-mad()-Z      t    Body      Gyro
    ## 130 130                tBodyGyro-max()-X      t    Body      Gyro
    ## 131 131                tBodyGyro-max()-Y      t    Body      Gyro
    ## 132 132                tBodyGyro-max()-Z      t    Body      Gyro
    ## 133 133                tBodyGyro-min()-X      t    Body      Gyro
    ## 134 134                tBodyGyro-min()-Y      t    Body      Gyro
    ## 135 135                tBodyGyro-min()-Z      t    Body      Gyro
    ## 136 136                  tBodyGyro-sma()      t    Body      Gyro
    ## 137 137             tBodyGyro-energy()-X      t    Body      Gyro
    ## 138 138             tBodyGyro-energy()-Y      t    Body      Gyro
    ## 139 139             tBodyGyro-energy()-Z      t    Body      Gyro
    ## 140 140                tBodyGyro-iqr()-X      t    Body      Gyro
    ## 141 141                tBodyGyro-iqr()-Y      t    Body      Gyro
    ## 142 142                tBodyGyro-iqr()-Z      t    Body      Gyro
    ## 143 143            tBodyGyro-entropy()-X      t    Body      Gyro
    ## 144 144            tBodyGyro-entropy()-Y      t    Body      Gyro
    ## 145 145            tBodyGyro-entropy()-Z      t    Body      Gyro
    ## 146 146          tBodyGyro-arCoeff()-X,1      t    Body      Gyro
    ## 147 147          tBodyGyro-arCoeff()-X,2      t    Body      Gyro
    ## 148 148          tBodyGyro-arCoeff()-X,3      t    Body      Gyro
    ## 149 149          tBodyGyro-arCoeff()-X,4      t    Body      Gyro
    ## 150 150          tBodyGyro-arCoeff()-Y,1      t    Body      Gyro
    ## 151 151          tBodyGyro-arCoeff()-Y,2      t    Body      Gyro
    ## 152 152          tBodyGyro-arCoeff()-Y,3      t    Body      Gyro
    ## 153 153          tBodyGyro-arCoeff()-Y,4      t    Body      Gyro
    ## 154 154          tBodyGyro-arCoeff()-Z,1      t    Body      Gyro
    ## 155 155          tBodyGyro-arCoeff()-Z,2      t    Body      Gyro
    ## 156 156          tBodyGyro-arCoeff()-Z,3      t    Body      Gyro
    ## 157 157          tBodyGyro-arCoeff()-Z,4      t    Body      Gyro
    ## 158 158      tBodyGyro-correlation()-X,Y      t    Body      Gyro
    ## 159 159      tBodyGyro-correlation()-X,Z      t    Body      Gyro
    ## 160 160      tBodyGyro-correlation()-Y,Z      t    Body      Gyro
    ## 161 161           tBodyGyroJerk-mean()-X      t    Body      Gyro
    ## 162 162           tBodyGyroJerk-mean()-Y      t    Body      Gyro
    ## 163 163           tBodyGyroJerk-mean()-Z      t    Body      Gyro
    ## 164 164            tBodyGyroJerk-std()-X      t    Body      Gyro
    ## 165 165            tBodyGyroJerk-std()-Y      t    Body      Gyro
    ## 166 166            tBodyGyroJerk-std()-Z      t    Body      Gyro
    ## 167 167            tBodyGyroJerk-mad()-X      t    Body      Gyro
    ## 168 168            tBodyGyroJerk-mad()-Y      t    Body      Gyro
    ## 169 169            tBodyGyroJerk-mad()-Z      t    Body      Gyro
    ## 170 170            tBodyGyroJerk-max()-X      t    Body      Gyro
    ## 171 171            tBodyGyroJerk-max()-Y      t    Body      Gyro
    ## 172 172            tBodyGyroJerk-max()-Z      t    Body      Gyro
    ## 173 173            tBodyGyroJerk-min()-X      t    Body      Gyro
    ## 174 174            tBodyGyroJerk-min()-Y      t    Body      Gyro
    ## 175 175            tBodyGyroJerk-min()-Z      t    Body      Gyro
    ## 176 176              tBodyGyroJerk-sma()      t    Body      Gyro
    ## 177 177         tBodyGyroJerk-energy()-X      t    Body      Gyro
    ## 178 178         tBodyGyroJerk-energy()-Y      t    Body      Gyro
    ## 179 179         tBodyGyroJerk-energy()-Z      t    Body      Gyro
    ## 180 180            tBodyGyroJerk-iqr()-X      t    Body      Gyro
    ## 181 181            tBodyGyroJerk-iqr()-Y      t    Body      Gyro
    ## 182 182            tBodyGyroJerk-iqr()-Z      t    Body      Gyro
    ## 183 183        tBodyGyroJerk-entropy()-X      t    Body      Gyro
    ## 184 184        tBodyGyroJerk-entropy()-Y      t    Body      Gyro
    ## 185 185        tBodyGyroJerk-entropy()-Z      t    Body      Gyro
    ## 186 186      tBodyGyroJerk-arCoeff()-X,1      t    Body      Gyro
    ## 187 187      tBodyGyroJerk-arCoeff()-X,2      t    Body      Gyro
    ## 188 188      tBodyGyroJerk-arCoeff()-X,3      t    Body      Gyro
    ## 189 189      tBodyGyroJerk-arCoeff()-X,4      t    Body      Gyro
    ## 190 190      tBodyGyroJerk-arCoeff()-Y,1      t    Body      Gyro
    ## 191 191      tBodyGyroJerk-arCoeff()-Y,2      t    Body      Gyro
    ## 192 192      tBodyGyroJerk-arCoeff()-Y,3      t    Body      Gyro
    ## 193 193      tBodyGyroJerk-arCoeff()-Y,4      t    Body      Gyro
    ## 194 194      tBodyGyroJerk-arCoeff()-Z,1      t    Body      Gyro
    ## 195 195      tBodyGyroJerk-arCoeff()-Z,2      t    Body      Gyro
    ## 196 196      tBodyGyroJerk-arCoeff()-Z,3      t    Body      Gyro
    ## 197 197      tBodyGyroJerk-arCoeff()-Z,4      t    Body      Gyro
    ## 198 198  tBodyGyroJerk-correlation()-X,Y      t    Body      Gyro
    ## 199 199  tBodyGyroJerk-correlation()-X,Z      t    Body      Gyro
    ## 200 200  tBodyGyroJerk-correlation()-Y,Z      t    Body      Gyro
    ## 201 266                fBodyAcc-mean()-X      f    Body       Acc
    ## 202 267                fBodyAcc-mean()-Y      f    Body       Acc
    ## 203 268                fBodyAcc-mean()-Z      f    Body       Acc
    ## 204 269                 fBodyAcc-std()-X      f    Body       Acc
    ## 205 270                 fBodyAcc-std()-Y      f    Body       Acc
    ## 206 271                 fBodyAcc-std()-Z      f    Body       Acc
    ## 207 272                 fBodyAcc-mad()-X      f    Body       Acc
    ## 208 273                 fBodyAcc-mad()-Y      f    Body       Acc
    ## 209 274                 fBodyAcc-mad()-Z      f    Body       Acc
    ## 210 275                 fBodyAcc-max()-X      f    Body       Acc
    ## 211 276                 fBodyAcc-max()-Y      f    Body       Acc
    ## 212 277                 fBodyAcc-max()-Z      f    Body       Acc
    ## 213 278                 fBodyAcc-min()-X      f    Body       Acc
    ## 214 279                 fBodyAcc-min()-Y      f    Body       Acc
    ## 215 280                 fBodyAcc-min()-Z      f    Body       Acc
    ## 216 281                   fBodyAcc-sma()      f    Body       Acc
    ## 217 282              fBodyAcc-energy()-X      f    Body       Acc
    ## 218 283              fBodyAcc-energy()-Y      f    Body       Acc
    ## 219 284              fBodyAcc-energy()-Z      f    Body       Acc
    ## 220 285                 fBodyAcc-iqr()-X      f    Body       Acc
    ## 221 286                 fBodyAcc-iqr()-Y      f    Body       Acc
    ## 222 287                 fBodyAcc-iqr()-Z      f    Body       Acc
    ## 223 288             fBodyAcc-entropy()-X      f    Body       Acc
    ## 224 289             fBodyAcc-entropy()-Y      f    Body       Acc
    ## 225 290             fBodyAcc-entropy()-Z      f    Body       Acc
    ## 226 291             fBodyAcc-maxInds()-X      f    Body       Acc
    ## 227 292             fBodyAcc-maxInds()-Y      f    Body       Acc
    ## 228 293             fBodyAcc-maxInds()-Z      f    Body       Acc
    ## 229 294            fBodyAcc-meanFreq()-X      f    Body       Acc
    ## 230 295            fBodyAcc-meanFreq()-Y      f    Body       Acc
    ## 231 296            fBodyAcc-meanFreq()-Z      f    Body       Acc
    ## 232 297            fBodyAcc-skewness()-X      f    Body       Acc
    ## 233 298            fBodyAcc-kurtosis()-X      f    Body       Acc
    ## 234 299            fBodyAcc-skewness()-Y      f    Body       Acc
    ## 235 300            fBodyAcc-kurtosis()-Y      f    Body       Acc
    ## 236 301            fBodyAcc-skewness()-Z      f    Body       Acc
    ## 237 302            fBodyAcc-kurtosis()-Z      f    Body       Acc
    ## 238 303       fBodyAcc-bandsEnergy()-1,8      f    Body       Acc
    ## 239 304      fBodyAcc-bandsEnergy()-9,16      f    Body       Acc
    ## 240 305     fBodyAcc-bandsEnergy()-17,24      f    Body       Acc
    ## 241 306     fBodyAcc-bandsEnergy()-25,32      f    Body       Acc
    ## 242 307     fBodyAcc-bandsEnergy()-33,40      f    Body       Acc
    ## 243 308     fBodyAcc-bandsEnergy()-41,48      f    Body       Acc
    ## 244 309     fBodyAcc-bandsEnergy()-49,56      f    Body       Acc
    ## 245 310     fBodyAcc-bandsEnergy()-57,64      f    Body       Acc
    ## 246 311      fBodyAcc-bandsEnergy()-1,16      f    Body       Acc
    ## 247 312     fBodyAcc-bandsEnergy()-17,32      f    Body       Acc
    ## 248 313     fBodyAcc-bandsEnergy()-33,48      f    Body       Acc
    ## 249 314     fBodyAcc-bandsEnergy()-49,64      f    Body       Acc
    ## 250 315      fBodyAcc-bandsEnergy()-1,24      f    Body       Acc
    ## 251 316     fBodyAcc-bandsEnergy()-25,48      f    Body       Acc
    ## 252 317       fBodyAcc-bandsEnergy()-1,8      f    Body       Acc
    ## 253 318      fBodyAcc-bandsEnergy()-9,16      f    Body       Acc
    ## 254 319     fBodyAcc-bandsEnergy()-17,24      f    Body       Acc
    ## 255 320     fBodyAcc-bandsEnergy()-25,32      f    Body       Acc
    ## 256 321     fBodyAcc-bandsEnergy()-33,40      f    Body       Acc
    ## 257 322     fBodyAcc-bandsEnergy()-41,48      f    Body       Acc
    ## 258 323     fBodyAcc-bandsEnergy()-49,56      f    Body       Acc
    ## 259 324     fBodyAcc-bandsEnergy()-57,64      f    Body       Acc
    ## 260 325      fBodyAcc-bandsEnergy()-1,16      f    Body       Acc
    ## 261 326     fBodyAcc-bandsEnergy()-17,32      f    Body       Acc
    ## 262 327     fBodyAcc-bandsEnergy()-33,48      f    Body       Acc
    ## 263 328     fBodyAcc-bandsEnergy()-49,64      f    Body       Acc
    ## 264 329      fBodyAcc-bandsEnergy()-1,24      f    Body       Acc
    ## 265 330     fBodyAcc-bandsEnergy()-25,48      f    Body       Acc
    ## 266 331       fBodyAcc-bandsEnergy()-1,8      f    Body       Acc
    ## 267 332      fBodyAcc-bandsEnergy()-9,16      f    Body       Acc
    ## 268 333     fBodyAcc-bandsEnergy()-17,24      f    Body       Acc
    ## 269 334     fBodyAcc-bandsEnergy()-25,32      f    Body       Acc
    ## 270 335     fBodyAcc-bandsEnergy()-33,40      f    Body       Acc
    ## 271 336     fBodyAcc-bandsEnergy()-41,48      f    Body       Acc
    ## 272 337     fBodyAcc-bandsEnergy()-49,56      f    Body       Acc
    ## 273 338     fBodyAcc-bandsEnergy()-57,64      f    Body       Acc
    ## 274 339      fBodyAcc-bandsEnergy()-1,16      f    Body       Acc
    ## 275 340     fBodyAcc-bandsEnergy()-17,32      f    Body       Acc
    ## 276 341     fBodyAcc-bandsEnergy()-33,48      f    Body       Acc
    ## 277 342     fBodyAcc-bandsEnergy()-49,64      f    Body       Acc
    ## 278 343      fBodyAcc-bandsEnergy()-1,24      f    Body       Acc
    ## 279 344     fBodyAcc-bandsEnergy()-25,48      f    Body       Acc
    ## 280 345            fBodyAccJerk-mean()-X      f    Body       Acc
    ## 281 346            fBodyAccJerk-mean()-Y      f    Body       Acc
    ## 282 347            fBodyAccJerk-mean()-Z      f    Body       Acc
    ## 283 348             fBodyAccJerk-std()-X      f    Body       Acc
    ## 284 349             fBodyAccJerk-std()-Y      f    Body       Acc
    ## 285 350             fBodyAccJerk-std()-Z      f    Body       Acc
    ## 286 351             fBodyAccJerk-mad()-X      f    Body       Acc
    ## 287 352             fBodyAccJerk-mad()-Y      f    Body       Acc
    ## 288 353             fBodyAccJerk-mad()-Z      f    Body       Acc
    ## 289 354             fBodyAccJerk-max()-X      f    Body       Acc
    ## 290 355             fBodyAccJerk-max()-Y      f    Body       Acc
    ## 291 356             fBodyAccJerk-max()-Z      f    Body       Acc
    ## 292 357             fBodyAccJerk-min()-X      f    Body       Acc
    ## 293 358             fBodyAccJerk-min()-Y      f    Body       Acc
    ## 294 359             fBodyAccJerk-min()-Z      f    Body       Acc
    ## 295 360               fBodyAccJerk-sma()      f    Body       Acc
    ## 296 361          fBodyAccJerk-energy()-X      f    Body       Acc
    ## 297 362          fBodyAccJerk-energy()-Y      f    Body       Acc
    ## 298 363          fBodyAccJerk-energy()-Z      f    Body       Acc
    ## 299 364             fBodyAccJerk-iqr()-X      f    Body       Acc
    ## 300 365             fBodyAccJerk-iqr()-Y      f    Body       Acc
    ## 301 366             fBodyAccJerk-iqr()-Z      f    Body       Acc
    ## 302 367         fBodyAccJerk-entropy()-X      f    Body       Acc
    ## 303 368         fBodyAccJerk-entropy()-Y      f    Body       Acc
    ## 304 369         fBodyAccJerk-entropy()-Z      f    Body       Acc
    ## 305 370         fBodyAccJerk-maxInds()-X      f    Body       Acc
    ## 306 371         fBodyAccJerk-maxInds()-Y      f    Body       Acc
    ## 307 372         fBodyAccJerk-maxInds()-Z      f    Body       Acc
    ## 308 373        fBodyAccJerk-meanFreq()-X      f    Body       Acc
    ## 309 374        fBodyAccJerk-meanFreq()-Y      f    Body       Acc
    ## 310 375        fBodyAccJerk-meanFreq()-Z      f    Body       Acc
    ## 311 376        fBodyAccJerk-skewness()-X      f    Body       Acc
    ## 312 377        fBodyAccJerk-kurtosis()-X      f    Body       Acc
    ## 313 378        fBodyAccJerk-skewness()-Y      f    Body       Acc
    ## 314 379        fBodyAccJerk-kurtosis()-Y      f    Body       Acc
    ## 315 380        fBodyAccJerk-skewness()-Z      f    Body       Acc
    ## 316 381        fBodyAccJerk-kurtosis()-Z      f    Body       Acc
    ## 317 382   fBodyAccJerk-bandsEnergy()-1,8      f    Body       Acc
    ## 318 383  fBodyAccJerk-bandsEnergy()-9,16      f    Body       Acc
    ## 319 384 fBodyAccJerk-bandsEnergy()-17,24      f    Body       Acc
    ## 320 385 fBodyAccJerk-bandsEnergy()-25,32      f    Body       Acc
    ## 321 386 fBodyAccJerk-bandsEnergy()-33,40      f    Body       Acc
    ## 322 387 fBodyAccJerk-bandsEnergy()-41,48      f    Body       Acc
    ## 323 388 fBodyAccJerk-bandsEnergy()-49,56      f    Body       Acc
    ## 324 389 fBodyAccJerk-bandsEnergy()-57,64      f    Body       Acc
    ## 325 390  fBodyAccJerk-bandsEnergy()-1,16      f    Body       Acc
    ## 326 391 fBodyAccJerk-bandsEnergy()-17,32      f    Body       Acc
    ## 327 392 fBodyAccJerk-bandsEnergy()-33,48      f    Body       Acc
    ## 328 393 fBodyAccJerk-bandsEnergy()-49,64      f    Body       Acc
    ## 329 394  fBodyAccJerk-bandsEnergy()-1,24      f    Body       Acc
    ## 330 395 fBodyAccJerk-bandsEnergy()-25,48      f    Body       Acc
    ## 331 396   fBodyAccJerk-bandsEnergy()-1,8      f    Body       Acc
    ## 332 397  fBodyAccJerk-bandsEnergy()-9,16      f    Body       Acc
    ## 333 398 fBodyAccJerk-bandsEnergy()-17,24      f    Body       Acc
    ## 334 399 fBodyAccJerk-bandsEnergy()-25,32      f    Body       Acc
    ## 335 400 fBodyAccJerk-bandsEnergy()-33,40      f    Body       Acc
    ## 336 401 fBodyAccJerk-bandsEnergy()-41,48      f    Body       Acc
    ## 337 402 fBodyAccJerk-bandsEnergy()-49,56      f    Body       Acc
    ## 338 403 fBodyAccJerk-bandsEnergy()-57,64      f    Body       Acc
    ## 339 404  fBodyAccJerk-bandsEnergy()-1,16      f    Body       Acc
    ## 340 405 fBodyAccJerk-bandsEnergy()-17,32      f    Body       Acc
    ## 341 406 fBodyAccJerk-bandsEnergy()-33,48      f    Body       Acc
    ## 342 407 fBodyAccJerk-bandsEnergy()-49,64      f    Body       Acc
    ## 343 408  fBodyAccJerk-bandsEnergy()-1,24      f    Body       Acc
    ## 344 409 fBodyAccJerk-bandsEnergy()-25,48      f    Body       Acc
    ## 345 410   fBodyAccJerk-bandsEnergy()-1,8      f    Body       Acc
    ## 346 411  fBodyAccJerk-bandsEnergy()-9,16      f    Body       Acc
    ## 347 412 fBodyAccJerk-bandsEnergy()-17,24      f    Body       Acc
    ## 348 413 fBodyAccJerk-bandsEnergy()-25,32      f    Body       Acc
    ## 349 414 fBodyAccJerk-bandsEnergy()-33,40      f    Body       Acc
    ## 350 415 fBodyAccJerk-bandsEnergy()-41,48      f    Body       Acc
    ## 351 416 fBodyAccJerk-bandsEnergy()-49,56      f    Body       Acc
    ## 352 417 fBodyAccJerk-bandsEnergy()-57,64      f    Body       Acc
    ## 353 418  fBodyAccJerk-bandsEnergy()-1,16      f    Body       Acc
    ## 354 419 fBodyAccJerk-bandsEnergy()-17,32      f    Body       Acc
    ## 355 420 fBodyAccJerk-bandsEnergy()-33,48      f    Body       Acc
    ## 356 421 fBodyAccJerk-bandsEnergy()-49,64      f    Body       Acc
    ## 357 422  fBodyAccJerk-bandsEnergy()-1,24      f    Body       Acc
    ## 358 423 fBodyAccJerk-bandsEnergy()-25,48      f    Body       Acc
    ## 359 424               fBodyGyro-mean()-X      f    Body      Gyro
    ## 360 425               fBodyGyro-mean()-Y      f    Body      Gyro
    ## 361 426               fBodyGyro-mean()-Z      f    Body      Gyro
    ## 362 427                fBodyGyro-std()-X      f    Body      Gyro
    ## 363 428                fBodyGyro-std()-Y      f    Body      Gyro
    ## 364 429                fBodyGyro-std()-Z      f    Body      Gyro
    ## 365 430                fBodyGyro-mad()-X      f    Body      Gyro
    ## 366 431                fBodyGyro-mad()-Y      f    Body      Gyro
    ## 367 432                fBodyGyro-mad()-Z      f    Body      Gyro
    ## 368 433                fBodyGyro-max()-X      f    Body      Gyro
    ## 369 434                fBodyGyro-max()-Y      f    Body      Gyro
    ## 370 435                fBodyGyro-max()-Z      f    Body      Gyro
    ## 371 436                fBodyGyro-min()-X      f    Body      Gyro
    ## 372 437                fBodyGyro-min()-Y      f    Body      Gyro
    ## 373 438                fBodyGyro-min()-Z      f    Body      Gyro
    ## 374 439                  fBodyGyro-sma()      f    Body      Gyro
    ## 375 440             fBodyGyro-energy()-X      f    Body      Gyro
    ## 376 441             fBodyGyro-energy()-Y      f    Body      Gyro
    ## 377 442             fBodyGyro-energy()-Z      f    Body      Gyro
    ## 378 443                fBodyGyro-iqr()-X      f    Body      Gyro
    ## 379 444                fBodyGyro-iqr()-Y      f    Body      Gyro
    ## 380 445                fBodyGyro-iqr()-Z      f    Body      Gyro
    ## 381 446            fBodyGyro-entropy()-X      f    Body      Gyro
    ## 382 447            fBodyGyro-entropy()-Y      f    Body      Gyro
    ## 383 448            fBodyGyro-entropy()-Z      f    Body      Gyro
    ## 384 449            fBodyGyro-maxInds()-X      f    Body      Gyro
    ## 385 450            fBodyGyro-maxInds()-Y      f    Body      Gyro
    ## 386 451            fBodyGyro-maxInds()-Z      f    Body      Gyro
    ## 387 452           fBodyGyro-meanFreq()-X      f    Body      Gyro
    ## 388 453           fBodyGyro-meanFreq()-Y      f    Body      Gyro
    ## 389 454           fBodyGyro-meanFreq()-Z      f    Body      Gyro
    ## 390 455           fBodyGyro-skewness()-X      f    Body      Gyro
    ## 391 456           fBodyGyro-kurtosis()-X      f    Body      Gyro
    ## 392 457           fBodyGyro-skewness()-Y      f    Body      Gyro
    ## 393 458           fBodyGyro-kurtosis()-Y      f    Body      Gyro
    ## 394 459           fBodyGyro-skewness()-Z      f    Body      Gyro
    ## 395 460           fBodyGyro-kurtosis()-Z      f    Body      Gyro
    ## 396 461      fBodyGyro-bandsEnergy()-1,8      f    Body      Gyro
    ## 397 462     fBodyGyro-bandsEnergy()-9,16      f    Body      Gyro
    ## 398 463    fBodyGyro-bandsEnergy()-17,24      f    Body      Gyro
    ## 399 464    fBodyGyro-bandsEnergy()-25,32      f    Body      Gyro
    ## 400 465    fBodyGyro-bandsEnergy()-33,40      f    Body      Gyro
    ## 401 466    fBodyGyro-bandsEnergy()-41,48      f    Body      Gyro
    ## 402 467    fBodyGyro-bandsEnergy()-49,56      f    Body      Gyro
    ## 403 468    fBodyGyro-bandsEnergy()-57,64      f    Body      Gyro
    ## 404 469     fBodyGyro-bandsEnergy()-1,16      f    Body      Gyro
    ## 405 470    fBodyGyro-bandsEnergy()-17,32      f    Body      Gyro
    ## 406 471    fBodyGyro-bandsEnergy()-33,48      f    Body      Gyro
    ## 407 472    fBodyGyro-bandsEnergy()-49,64      f    Body      Gyro
    ## 408 473     fBodyGyro-bandsEnergy()-1,24      f    Body      Gyro
    ## 409 474    fBodyGyro-bandsEnergy()-25,48      f    Body      Gyro
    ## 410 475      fBodyGyro-bandsEnergy()-1,8      f    Body      Gyro
    ## 411 476     fBodyGyro-bandsEnergy()-9,16      f    Body      Gyro
    ## 412 477    fBodyGyro-bandsEnergy()-17,24      f    Body      Gyro
    ## 413 478    fBodyGyro-bandsEnergy()-25,32      f    Body      Gyro
    ## 414 479    fBodyGyro-bandsEnergy()-33,40      f    Body      Gyro
    ## 415 480    fBodyGyro-bandsEnergy()-41,48      f    Body      Gyro
    ## 416 481    fBodyGyro-bandsEnergy()-49,56      f    Body      Gyro
    ## 417 482    fBodyGyro-bandsEnergy()-57,64      f    Body      Gyro
    ## 418 483     fBodyGyro-bandsEnergy()-1,16      f    Body      Gyro
    ## 419 484    fBodyGyro-bandsEnergy()-17,32      f    Body      Gyro
    ## 420 485    fBodyGyro-bandsEnergy()-33,48      f    Body      Gyro
    ## 421 486    fBodyGyro-bandsEnergy()-49,64      f    Body      Gyro
    ## 422 487     fBodyGyro-bandsEnergy()-1,24      f    Body      Gyro
    ## 423 488    fBodyGyro-bandsEnergy()-25,48      f    Body      Gyro
    ## 424 489      fBodyGyro-bandsEnergy()-1,8      f    Body      Gyro
    ## 425 490     fBodyGyro-bandsEnergy()-9,16      f    Body      Gyro
    ## 426 491    fBodyGyro-bandsEnergy()-17,24      f    Body      Gyro
    ## 427 492    fBodyGyro-bandsEnergy()-25,32      f    Body      Gyro
    ## 428 493    fBodyGyro-bandsEnergy()-33,40      f    Body      Gyro
    ## 429 494    fBodyGyro-bandsEnergy()-41,48      f    Body      Gyro
    ## 430 495    fBodyGyro-bandsEnergy()-49,56      f    Body      Gyro
    ## 431 496    fBodyGyro-bandsEnergy()-57,64      f    Body      Gyro
    ## 432 497     fBodyGyro-bandsEnergy()-1,16      f    Body      Gyro
    ## 433 498    fBodyGyro-bandsEnergy()-17,32      f    Body      Gyro
    ## 434 499    fBodyGyro-bandsEnergy()-33,48      f    Body      Gyro
    ## 435 500    fBodyGyro-bandsEnergy()-49,64      f    Body      Gyro
    ## 436 501     fBodyGyro-bandsEnergy()-1,24      f    Body      Gyro
    ## 437 502    fBodyGyro-bandsEnergy()-25,48      f    Body      Gyro
    ##     jerkSuffix magSuffix statSep1   statistic statSep2 statSep3 axisSep
    ## 1                               -        mean        (        )       -
    ## 2                               -        mean        (        )       -
    ## 3                               -        mean        (        )       -
    ## 4                               -         std        (        )       -
    ## 5                               -         std        (        )       -
    ## 6                               -         std        (        )       -
    ## 7                               -         mad        (        )       -
    ## 8                               -         mad        (        )       -
    ## 9                               -         mad        (        )       -
    ## 10                              -         max        (        )       -
    ## 11                              -         max        (        )       -
    ## 12                              -         max        (        )       -
    ## 13                              -         min        (        )       -
    ## 14                              -         min        (        )       -
    ## 15                              -         min        (        )       -
    ## 16                              -         sma        (        )        
    ## 17                              -      energy        (        )       -
    ## 18                              -      energy        (        )       -
    ## 19                              -      energy        (        )       -
    ## 20                              -         iqr        (        )       -
    ## 21                              -         iqr        (        )       -
    ## 22                              -         iqr        (        )       -
    ## 23                              -     entropy        (        )       -
    ## 24                              -     entropy        (        )       -
    ## 25                              -     entropy        (        )       -
    ## 26                              -     arCoeff        (        )       -
    ## 27                              -     arCoeff        (        )       -
    ## 28                              -     arCoeff        (        )       -
    ## 29                              -     arCoeff        (        )       -
    ## 30                              -     arCoeff        (        )       -
    ## 31                              -     arCoeff        (        )       -
    ## 32                              -     arCoeff        (        )       -
    ## 33                              -     arCoeff        (        )       -
    ## 34                              -     arCoeff        (        )       -
    ## 35                              -     arCoeff        (        )       -
    ## 36                              -     arCoeff        (        )       -
    ## 37                              -     arCoeff        (        )       -
    ## 38                              - correlation        (        )        
    ## 39                              - correlation        (        )        
    ## 40                              - correlation        (        )        
    ## 41                              -        mean        (        )       -
    ## 42                              -        mean        (        )       -
    ## 43                              -        mean        (        )       -
    ## 44                              -         std        (        )       -
    ## 45                              -         std        (        )       -
    ## 46                              -         std        (        )       -
    ## 47                              -         mad        (        )       -
    ## 48                              -         mad        (        )       -
    ## 49                              -         mad        (        )       -
    ## 50                              -         max        (        )       -
    ## 51                              -         max        (        )       -
    ## 52                              -         max        (        )       -
    ## 53                              -         min        (        )       -
    ## 54                              -         min        (        )       -
    ## 55                              -         min        (        )       -
    ## 56                              -         sma        (        )        
    ## 57                              -      energy        (        )       -
    ## 58                              -      energy        (        )       -
    ## 59                              -      energy        (        )       -
    ## 60                              -         iqr        (        )       -
    ## 61                              -         iqr        (        )       -
    ## 62                              -         iqr        (        )       -
    ## 63                              -     entropy        (        )       -
    ## 64                              -     entropy        (        )       -
    ## 65                              -     entropy        (        )       -
    ## 66                              -     arCoeff        (        )       -
    ## 67                              -     arCoeff        (        )       -
    ## 68                              -     arCoeff        (        )       -
    ## 69                              -     arCoeff        (        )       -
    ## 70                              -     arCoeff        (        )       -
    ## 71                              -     arCoeff        (        )       -
    ## 72                              -     arCoeff        (        )       -
    ## 73                              -     arCoeff        (        )       -
    ## 74                              -     arCoeff        (        )       -
    ## 75                              -     arCoeff        (        )       -
    ## 76                              -     arCoeff        (        )       -
    ## 77                              -     arCoeff        (        )       -
    ## 78                              - correlation        (        )        
    ## 79                              - correlation        (        )        
    ## 80                              - correlation        (        )        
    ## 81        Jerk                  -        mean        (        )       -
    ## 82        Jerk                  -        mean        (        )       -
    ## 83        Jerk                  -        mean        (        )       -
    ## 84        Jerk                  -         std        (        )       -
    ## 85        Jerk                  -         std        (        )       -
    ## 86        Jerk                  -         std        (        )       -
    ## 87        Jerk                  -         mad        (        )       -
    ## 88        Jerk                  -         mad        (        )       -
    ## 89        Jerk                  -         mad        (        )       -
    ## 90        Jerk                  -         max        (        )       -
    ## 91        Jerk                  -         max        (        )       -
    ## 92        Jerk                  -         max        (        )       -
    ## 93        Jerk                  -         min        (        )       -
    ## 94        Jerk                  -         min        (        )       -
    ## 95        Jerk                  -         min        (        )       -
    ## 96        Jerk                  -         sma        (        )        
    ## 97        Jerk                  -      energy        (        )       -
    ## 98        Jerk                  -      energy        (        )       -
    ## 99        Jerk                  -      energy        (        )       -
    ## 100       Jerk                  -         iqr        (        )       -
    ## 101       Jerk                  -         iqr        (        )       -
    ## 102       Jerk                  -         iqr        (        )       -
    ## 103       Jerk                  -     entropy        (        )       -
    ## 104       Jerk                  -     entropy        (        )       -
    ## 105       Jerk                  -     entropy        (        )       -
    ## 106       Jerk                  -     arCoeff        (        )       -
    ## 107       Jerk                  -     arCoeff        (        )       -
    ## 108       Jerk                  -     arCoeff        (        )       -
    ## 109       Jerk                  -     arCoeff        (        )       -
    ## 110       Jerk                  -     arCoeff        (        )       -
    ## 111       Jerk                  -     arCoeff        (        )       -
    ## 112       Jerk                  -     arCoeff        (        )       -
    ## 113       Jerk                  -     arCoeff        (        )       -
    ## 114       Jerk                  -     arCoeff        (        )       -
    ## 115       Jerk                  -     arCoeff        (        )       -
    ## 116       Jerk                  -     arCoeff        (        )       -
    ## 117       Jerk                  -     arCoeff        (        )       -
    ## 118       Jerk                  - correlation        (        )        
    ## 119       Jerk                  - correlation        (        )        
    ## 120       Jerk                  - correlation        (        )        
    ## 121                             -        mean        (        )       -
    ## 122                             -        mean        (        )       -
    ## 123                             -        mean        (        )       -
    ## 124                             -         std        (        )       -
    ## 125                             -         std        (        )       -
    ## 126                             -         std        (        )       -
    ## 127                             -         mad        (        )       -
    ## 128                             -         mad        (        )       -
    ## 129                             -         mad        (        )       -
    ## 130                             -         max        (        )       -
    ## 131                             -         max        (        )       -
    ## 132                             -         max        (        )       -
    ## 133                             -         min        (        )       -
    ## 134                             -         min        (        )       -
    ## 135                             -         min        (        )       -
    ## 136                             -         sma        (        )        
    ## 137                             -      energy        (        )       -
    ## 138                             -      energy        (        )       -
    ## 139                             -      energy        (        )       -
    ## 140                             -         iqr        (        )       -
    ## 141                             -         iqr        (        )       -
    ## 142                             -         iqr        (        )       -
    ## 143                             -     entropy        (        )       -
    ## 144                             -     entropy        (        )       -
    ## 145                             -     entropy        (        )       -
    ## 146                             -     arCoeff        (        )       -
    ## 147                             -     arCoeff        (        )       -
    ## 148                             -     arCoeff        (        )       -
    ## 149                             -     arCoeff        (        )       -
    ## 150                             -     arCoeff        (        )       -
    ## 151                             -     arCoeff        (        )       -
    ## 152                             -     arCoeff        (        )       -
    ## 153                             -     arCoeff        (        )       -
    ## 154                             -     arCoeff        (        )       -
    ## 155                             -     arCoeff        (        )       -
    ## 156                             -     arCoeff        (        )       -
    ## 157                             -     arCoeff        (        )       -
    ## 158                             - correlation        (        )        
    ## 159                             - correlation        (        )        
    ## 160                             - correlation        (        )        
    ## 161       Jerk                  -        mean        (        )       -
    ## 162       Jerk                  -        mean        (        )       -
    ## 163       Jerk                  -        mean        (        )       -
    ## 164       Jerk                  -         std        (        )       -
    ## 165       Jerk                  -         std        (        )       -
    ## 166       Jerk                  -         std        (        )       -
    ## 167       Jerk                  -         mad        (        )       -
    ## 168       Jerk                  -         mad        (        )       -
    ## 169       Jerk                  -         mad        (        )       -
    ## 170       Jerk                  -         max        (        )       -
    ## 171       Jerk                  -         max        (        )       -
    ## 172       Jerk                  -         max        (        )       -
    ## 173       Jerk                  -         min        (        )       -
    ## 174       Jerk                  -         min        (        )       -
    ## 175       Jerk                  -         min        (        )       -
    ## 176       Jerk                  -         sma        (        )        
    ## 177       Jerk                  -      energy        (        )       -
    ## 178       Jerk                  -      energy        (        )       -
    ## 179       Jerk                  -      energy        (        )       -
    ## 180       Jerk                  -         iqr        (        )       -
    ## 181       Jerk                  -         iqr        (        )       -
    ## 182       Jerk                  -         iqr        (        )       -
    ## 183       Jerk                  -     entropy        (        )       -
    ## 184       Jerk                  -     entropy        (        )       -
    ## 185       Jerk                  -     entropy        (        )       -
    ## 186       Jerk                  -     arCoeff        (        )       -
    ## 187       Jerk                  -     arCoeff        (        )       -
    ## 188       Jerk                  -     arCoeff        (        )       -
    ## 189       Jerk                  -     arCoeff        (        )       -
    ## 190       Jerk                  -     arCoeff        (        )       -
    ## 191       Jerk                  -     arCoeff        (        )       -
    ## 192       Jerk                  -     arCoeff        (        )       -
    ## 193       Jerk                  -     arCoeff        (        )       -
    ## 194       Jerk                  -     arCoeff        (        )       -
    ## 195       Jerk                  -     arCoeff        (        )       -
    ## 196       Jerk                  -     arCoeff        (        )       -
    ## 197       Jerk                  -     arCoeff        (        )       -
    ## 198       Jerk                  - correlation        (        )        
    ## 199       Jerk                  - correlation        (        )        
    ## 200       Jerk                  - correlation        (        )        
    ## 201                             -        mean        (        )       -
    ## 202                             -        mean        (        )       -
    ## 203                             -        mean        (        )       -
    ## 204                             -         std        (        )       -
    ## 205                             -         std        (        )       -
    ## 206                             -         std        (        )       -
    ## 207                             -         mad        (        )       -
    ## 208                             -         mad        (        )       -
    ## 209                             -         mad        (        )       -
    ## 210                             -         max        (        )       -
    ## 211                             -         max        (        )       -
    ## 212                             -         max        (        )       -
    ## 213                             -         min        (        )       -
    ## 214                             -         min        (        )       -
    ## 215                             -         min        (        )       -
    ## 216                             -         sma        (        )        
    ## 217                             -      energy        (        )       -
    ## 218                             -      energy        (        )       -
    ## 219                             -      energy        (        )       -
    ## 220                             -         iqr        (        )       -
    ## 221                             -         iqr        (        )       -
    ## 222                             -         iqr        (        )       -
    ## 223                             -     entropy        (        )       -
    ## 224                             -     entropy        (        )       -
    ## 225                             -     entropy        (        )       -
    ## 226                             -     maxInds        (        )       -
    ## 227                             -     maxInds        (        )       -
    ## 228                             -     maxInds        (        )       -
    ## 229                             -    meanFreq        (        )       -
    ## 230                             -    meanFreq        (        )       -
    ## 231                             -    meanFreq        (        )       -
    ## 232                             -    skewness        (        )       -
    ## 233                             -    kurtosis        (        )       -
    ## 234                             -    skewness        (        )       -
    ## 235                             -    kurtosis        (        )       -
    ## 236                             -    skewness        (        )       -
    ## 237                             -    kurtosis        (        )       -
    ## 238                             - bandsEnergy        (        )        
    ## 239                             - bandsEnergy        (        )        
    ## 240                             - bandsEnergy        (        )        
    ## 241                             - bandsEnergy        (        )        
    ## 242                             - bandsEnergy        (        )        
    ## 243                             - bandsEnergy        (        )        
    ## 244                             - bandsEnergy        (        )        
    ## 245                             - bandsEnergy        (        )        
    ## 246                             - bandsEnergy        (        )        
    ## 247                             - bandsEnergy        (        )        
    ## 248                             - bandsEnergy        (        )        
    ## 249                             - bandsEnergy        (        )        
    ## 250                             - bandsEnergy        (        )        
    ## 251                             - bandsEnergy        (        )        
    ## 252                             - bandsEnergy        (        )        
    ## 253                             - bandsEnergy        (        )        
    ## 254                             - bandsEnergy        (        )        
    ## 255                             - bandsEnergy        (        )        
    ## 256                             - bandsEnergy        (        )        
    ## 257                             - bandsEnergy        (        )        
    ## 258                             - bandsEnergy        (        )        
    ## 259                             - bandsEnergy        (        )        
    ## 260                             - bandsEnergy        (        )        
    ## 261                             - bandsEnergy        (        )        
    ## 262                             - bandsEnergy        (        )        
    ## 263                             - bandsEnergy        (        )        
    ## 264                             - bandsEnergy        (        )        
    ## 265                             - bandsEnergy        (        )        
    ## 266                             - bandsEnergy        (        )        
    ## 267                             - bandsEnergy        (        )        
    ## 268                             - bandsEnergy        (        )        
    ## 269                             - bandsEnergy        (        )        
    ## 270                             - bandsEnergy        (        )        
    ## 271                             - bandsEnergy        (        )        
    ## 272                             - bandsEnergy        (        )        
    ## 273                             - bandsEnergy        (        )        
    ## 274                             - bandsEnergy        (        )        
    ## 275                             - bandsEnergy        (        )        
    ## 276                             - bandsEnergy        (        )        
    ## 277                             - bandsEnergy        (        )        
    ## 278                             - bandsEnergy        (        )        
    ## 279                             - bandsEnergy        (        )        
    ## 280       Jerk                  -        mean        (        )       -
    ## 281       Jerk                  -        mean        (        )       -
    ## 282       Jerk                  -        mean        (        )       -
    ## 283       Jerk                  -         std        (        )       -
    ## 284       Jerk                  -         std        (        )       -
    ## 285       Jerk                  -         std        (        )       -
    ## 286       Jerk                  -         mad        (        )       -
    ## 287       Jerk                  -         mad        (        )       -
    ## 288       Jerk                  -         mad        (        )       -
    ## 289       Jerk                  -         max        (        )       -
    ## 290       Jerk                  -         max        (        )       -
    ## 291       Jerk                  -         max        (        )       -
    ## 292       Jerk                  -         min        (        )       -
    ## 293       Jerk                  -         min        (        )       -
    ## 294       Jerk                  -         min        (        )       -
    ## 295       Jerk                  -         sma        (        )        
    ## 296       Jerk                  -      energy        (        )       -
    ## 297       Jerk                  -      energy        (        )       -
    ## 298       Jerk                  -      energy        (        )       -
    ## 299       Jerk                  -         iqr        (        )       -
    ## 300       Jerk                  -         iqr        (        )       -
    ## 301       Jerk                  -         iqr        (        )       -
    ## 302       Jerk                  -     entropy        (        )       -
    ## 303       Jerk                  -     entropy        (        )       -
    ## 304       Jerk                  -     entropy        (        )       -
    ## 305       Jerk                  -     maxInds        (        )       -
    ## 306       Jerk                  -     maxInds        (        )       -
    ## 307       Jerk                  -     maxInds        (        )       -
    ## 308       Jerk                  -    meanFreq        (        )       -
    ## 309       Jerk                  -    meanFreq        (        )       -
    ## 310       Jerk                  -    meanFreq        (        )       -
    ## 311       Jerk                  -    skewness        (        )       -
    ## 312       Jerk                  -    kurtosis        (        )       -
    ## 313       Jerk                  -    skewness        (        )       -
    ## 314       Jerk                  -    kurtosis        (        )       -
    ## 315       Jerk                  -    skewness        (        )       -
    ## 316       Jerk                  -    kurtosis        (        )       -
    ## 317       Jerk                  - bandsEnergy        (        )        
    ## 318       Jerk                  - bandsEnergy        (        )        
    ## 319       Jerk                  - bandsEnergy        (        )        
    ## 320       Jerk                  - bandsEnergy        (        )        
    ## 321       Jerk                  - bandsEnergy        (        )        
    ## 322       Jerk                  - bandsEnergy        (        )        
    ## 323       Jerk                  - bandsEnergy        (        )        
    ## 324       Jerk                  - bandsEnergy        (        )        
    ## 325       Jerk                  - bandsEnergy        (        )        
    ## 326       Jerk                  - bandsEnergy        (        )        
    ## 327       Jerk                  - bandsEnergy        (        )        
    ## 328       Jerk                  - bandsEnergy        (        )        
    ## 329       Jerk                  - bandsEnergy        (        )        
    ## 330       Jerk                  - bandsEnergy        (        )        
    ## 331       Jerk                  - bandsEnergy        (        )        
    ## 332       Jerk                  - bandsEnergy        (        )        
    ## 333       Jerk                  - bandsEnergy        (        )        
    ## 334       Jerk                  - bandsEnergy        (        )        
    ## 335       Jerk                  - bandsEnergy        (        )        
    ## 336       Jerk                  - bandsEnergy        (        )        
    ## 337       Jerk                  - bandsEnergy        (        )        
    ## 338       Jerk                  - bandsEnergy        (        )        
    ## 339       Jerk                  - bandsEnergy        (        )        
    ## 340       Jerk                  - bandsEnergy        (        )        
    ## 341       Jerk                  - bandsEnergy        (        )        
    ## 342       Jerk                  - bandsEnergy        (        )        
    ## 343       Jerk                  - bandsEnergy        (        )        
    ## 344       Jerk                  - bandsEnergy        (        )        
    ## 345       Jerk                  - bandsEnergy        (        )        
    ## 346       Jerk                  - bandsEnergy        (        )        
    ## 347       Jerk                  - bandsEnergy        (        )        
    ## 348       Jerk                  - bandsEnergy        (        )        
    ## 349       Jerk                  - bandsEnergy        (        )        
    ## 350       Jerk                  - bandsEnergy        (        )        
    ## 351       Jerk                  - bandsEnergy        (        )        
    ## 352       Jerk                  - bandsEnergy        (        )        
    ## 353       Jerk                  - bandsEnergy        (        )        
    ## 354       Jerk                  - bandsEnergy        (        )        
    ## 355       Jerk                  - bandsEnergy        (        )        
    ## 356       Jerk                  - bandsEnergy        (        )        
    ## 357       Jerk                  - bandsEnergy        (        )        
    ## 358       Jerk                  - bandsEnergy        (        )        
    ## 359                             -        mean        (        )       -
    ## 360                             -        mean        (        )       -
    ## 361                             -        mean        (        )       -
    ## 362                             -         std        (        )       -
    ## 363                             -         std        (        )       -
    ## 364                             -         std        (        )       -
    ## 365                             -         mad        (        )       -
    ## 366                             -         mad        (        )       -
    ## 367                             -         mad        (        )       -
    ## 368                             -         max        (        )       -
    ## 369                             -         max        (        )       -
    ## 370                             -         max        (        )       -
    ## 371                             -         min        (        )       -
    ## 372                             -         min        (        )       -
    ## 373                             -         min        (        )       -
    ## 374                             -         sma        (        )        
    ## 375                             -      energy        (        )       -
    ## 376                             -      energy        (        )       -
    ## 377                             -      energy        (        )       -
    ## 378                             -         iqr        (        )       -
    ## 379                             -         iqr        (        )       -
    ## 380                             -         iqr        (        )       -
    ## 381                             -     entropy        (        )       -
    ## 382                             -     entropy        (        )       -
    ## 383                             -     entropy        (        )       -
    ## 384                             -     maxInds        (        )       -
    ## 385                             -     maxInds        (        )       -
    ## 386                             -     maxInds        (        )       -
    ## 387                             -    meanFreq        (        )       -
    ## 388                             -    meanFreq        (        )       -
    ## 389                             -    meanFreq        (        )       -
    ## 390                             -    skewness        (        )       -
    ## 391                             -    kurtosis        (        )       -
    ## 392                             -    skewness        (        )       -
    ## 393                             -    kurtosis        (        )       -
    ## 394                             -    skewness        (        )       -
    ## 395                             -    kurtosis        (        )       -
    ## 396                             - bandsEnergy        (        )        
    ## 397                             - bandsEnergy        (        )        
    ## 398                             - bandsEnergy        (        )        
    ## 399                             - bandsEnergy        (        )        
    ## 400                             - bandsEnergy        (        )        
    ## 401                             - bandsEnergy        (        )        
    ## 402                             - bandsEnergy        (        )        
    ## 403                             - bandsEnergy        (        )        
    ## 404                             - bandsEnergy        (        )        
    ## 405                             - bandsEnergy        (        )        
    ## 406                             - bandsEnergy        (        )        
    ## 407                             - bandsEnergy        (        )        
    ## 408                             - bandsEnergy        (        )        
    ## 409                             - bandsEnergy        (        )        
    ## 410                             - bandsEnergy        (        )        
    ## 411                             - bandsEnergy        (        )        
    ## 412                             - bandsEnergy        (        )        
    ## 413                             - bandsEnergy        (        )        
    ## 414                             - bandsEnergy        (        )        
    ## 415                             - bandsEnergy        (        )        
    ## 416                             - bandsEnergy        (        )        
    ## 417                             - bandsEnergy        (        )        
    ## 418                             - bandsEnergy        (        )        
    ## 419                             - bandsEnergy        (        )        
    ## 420                             - bandsEnergy        (        )        
    ## 421                             - bandsEnergy        (        )        
    ## 422                             - bandsEnergy        (        )        
    ## 423                             - bandsEnergy        (        )        
    ## 424                             - bandsEnergy        (        )        
    ## 425                             - bandsEnergy        (        )        
    ## 426                             - bandsEnergy        (        )        
    ## 427                             - bandsEnergy        (        )        
    ## 428                             - bandsEnergy        (        )        
    ## 429                             - bandsEnergy        (        )        
    ## 430                             - bandsEnergy        (        )        
    ## 431                             - bandsEnergy        (        )        
    ## 432                             - bandsEnergy        (        )        
    ## 433                             - bandsEnergy        (        )        
    ## 434                             - bandsEnergy        (        )        
    ## 435                             - bandsEnergy        (        )        
    ## 436                             - bandsEnergy        (        )        
    ## 437                             - bandsEnergy        (        )        
    ##     axis axesSep axes arCoeffSep arCoeffLevel correlationSep1
    ## 1      X                                                     
    ## 2      Y                                                     
    ## 3      Z                                                     
    ## 4      X                                                     
    ## 5      Y                                                     
    ## 6      Z                                                     
    ## 7      X                                                     
    ## 8      Y                                                     
    ## 9      Z                                                     
    ## 10     X                                                     
    ## 11     Y                                                     
    ## 12     Z                                                     
    ## 13     X                                                     
    ## 14     Y                                                     
    ## 15     Z                                                     
    ## 16             -  XYZ                                        
    ## 17     X                                                     
    ## 18     Y                                                     
    ## 19     Z                                                     
    ## 20     X                                                     
    ## 21     Y                                                     
    ## 22     Z                                                     
    ## 23     X                                                     
    ## 24     Y                                                     
    ## 25     Z                                                     
    ## 26     X                       ,            1                
    ## 27     X                       ,            2                
    ## 28     X                       ,            3                
    ## 29     X                       ,            4                
    ## 30     Y                       ,            1                
    ## 31     Y                       ,            2                
    ## 32     Y                       ,            3                
    ## 33     Y                       ,            4                
    ## 34     Z                       ,            1                
    ## 35     Z                       ,            2                
    ## 36     Z                       ,            3                
    ## 37     Z                       ,            4                
    ## 38             -   XY                                       -
    ## 39             -   XZ                                       -
    ## 40             -   YZ                                       -
    ## 41     X                                                     
    ## 42     Y                                                     
    ## 43     Z                                                     
    ## 44     X                                                     
    ## 45     Y                                                     
    ## 46     Z                                                     
    ## 47     X                                                     
    ## 48     Y                                                     
    ## 49     Z                                                     
    ## 50     X                                                     
    ## 51     Y                                                     
    ## 52     Z                                                     
    ## 53     X                                                     
    ## 54     Y                                                     
    ## 55     Z                                                     
    ## 56             -  XYZ                                        
    ## 57     X                                                     
    ## 58     Y                                                     
    ## 59     Z                                                     
    ## 60     X                                                     
    ## 61     Y                                                     
    ## 62     Z                                                     
    ## 63     X                                                     
    ## 64     Y                                                     
    ## 65     Z                                                     
    ## 66     X                       ,            1                
    ## 67     X                       ,            2                
    ## 68     X                       ,            3                
    ## 69     X                       ,            4                
    ## 70     Y                       ,            1                
    ## 71     Y                       ,            2                
    ## 72     Y                       ,            3                
    ## 73     Y                       ,            4                
    ## 74     Z                       ,            1                
    ## 75     Z                       ,            2                
    ## 76     Z                       ,            3                
    ## 77     Z                       ,            4                
    ## 78             -   XY                                       -
    ## 79             -   XZ                                       -
    ## 80             -   YZ                                       -
    ## 81     X                                                     
    ## 82     Y                                                     
    ## 83     Z                                                     
    ## 84     X                                                     
    ## 85     Y                                                     
    ## 86     Z                                                     
    ## 87     X                                                     
    ## 88     Y                                                     
    ## 89     Z                                                     
    ## 90     X                                                     
    ## 91     Y                                                     
    ## 92     Z                                                     
    ## 93     X                                                     
    ## 94     Y                                                     
    ## 95     Z                                                     
    ## 96             -  XYZ                                        
    ## 97     X                                                     
    ## 98     Y                                                     
    ## 99     Z                                                     
    ## 100    X                                                     
    ## 101    Y                                                     
    ## 102    Z                                                     
    ## 103    X                                                     
    ## 104    Y                                                     
    ## 105    Z                                                     
    ## 106    X                       ,            1                
    ## 107    X                       ,            2                
    ## 108    X                       ,            3                
    ## 109    X                       ,            4                
    ## 110    Y                       ,            1                
    ## 111    Y                       ,            2                
    ## 112    Y                       ,            3                
    ## 113    Y                       ,            4                
    ## 114    Z                       ,            1                
    ## 115    Z                       ,            2                
    ## 116    Z                       ,            3                
    ## 117    Z                       ,            4                
    ## 118            -   XY                                       -
    ## 119            -   XZ                                       -
    ## 120            -   YZ                                       -
    ## 121    X                                                     
    ## 122    Y                                                     
    ## 123    Z                                                     
    ## 124    X                                                     
    ## 125    Y                                                     
    ## 126    Z                                                     
    ## 127    X                                                     
    ## 128    Y                                                     
    ## 129    Z                                                     
    ## 130    X                                                     
    ## 131    Y                                                     
    ## 132    Z                                                     
    ## 133    X                                                     
    ## 134    Y                                                     
    ## 135    Z                                                     
    ## 136            -  XYZ                                        
    ## 137    X                                                     
    ## 138    Y                                                     
    ## 139    Z                                                     
    ## 140    X                                                     
    ## 141    Y                                                     
    ## 142    Z                                                     
    ## 143    X                                                     
    ## 144    Y                                                     
    ## 145    Z                                                     
    ## 146    X                       ,            1                
    ## 147    X                       ,            2                
    ## 148    X                       ,            3                
    ## 149    X                       ,            4                
    ## 150    Y                       ,            1                
    ## 151    Y                       ,            2                
    ## 152    Y                       ,            3                
    ## 153    Y                       ,            4                
    ## 154    Z                       ,            1                
    ## 155    Z                       ,            2                
    ## 156    Z                       ,            3                
    ## 157    Z                       ,            4                
    ## 158            -   XY                                       -
    ## 159            -   XZ                                       -
    ## 160            -   YZ                                       -
    ## 161    X                                                     
    ## 162    Y                                                     
    ## 163    Z                                                     
    ## 164    X                                                     
    ## 165    Y                                                     
    ## 166    Z                                                     
    ## 167    X                                                     
    ## 168    Y                                                     
    ## 169    Z                                                     
    ## 170    X                                                     
    ## 171    Y                                                     
    ## 172    Z                                                     
    ## 173    X                                                     
    ## 174    Y                                                     
    ## 175    Z                                                     
    ## 176            -  XYZ                                        
    ## 177    X                                                     
    ## 178    Y                                                     
    ## 179    Z                                                     
    ## 180    X                                                     
    ## 181    Y                                                     
    ## 182    Z                                                     
    ## 183    X                                                     
    ## 184    Y                                                     
    ## 185    Z                                                     
    ## 186    X                       ,            1                
    ## 187    X                       ,            2                
    ## 188    X                       ,            3                
    ## 189    X                       ,            4                
    ## 190    Y                       ,            1                
    ## 191    Y                       ,            2                
    ## 192    Y                       ,            3                
    ## 193    Y                       ,            4                
    ## 194    Z                       ,            1                
    ## 195    Z                       ,            2                
    ## 196    Z                       ,            3                
    ## 197    Z                       ,            4                
    ## 198            -   XY                                       -
    ## 199            -   XZ                                       -
    ## 200            -   YZ                                       -
    ## 201    X                                                     
    ## 202    Y                                                     
    ## 203    Z                                                     
    ## 204    X                                                     
    ## 205    Y                                                     
    ## 206    Z                                                     
    ## 207    X                                                     
    ## 208    Y                                                     
    ## 209    Z                                                     
    ## 210    X                                                     
    ## 211    Y                                                     
    ## 212    Z                                                     
    ## 213    X                                                     
    ## 214    Y                                                     
    ## 215    Z                                                     
    ## 216            -  XYZ                                        
    ## 217    X                                                     
    ## 218    Y                                                     
    ## 219    Z                                                     
    ## 220    X                                                     
    ## 221    Y                                                     
    ## 222    Z                                                     
    ## 223    X                                                     
    ## 224    Y                                                     
    ## 225    Z                                                     
    ## 226    X                                                     
    ## 227    Y                                                     
    ## 228    Z                                                     
    ## 229    X                                                     
    ## 230    Y                                                     
    ## 231    Z                                                     
    ## 232    X                                                     
    ## 233    X                                                     
    ## 234    Y                                                     
    ## 235    Y                                                     
    ## 236    Z                                                     
    ## 237    Z                                                     
    ## 238            -  XYZ                                        
    ## 239            -  XYZ                                        
    ## 240            -  XYZ                                        
    ## 241            -  XYZ                                        
    ## 242            -  XYZ                                        
    ## 243            -  XYZ                                        
    ## 244            -  XYZ                                        
    ## 245            -  XYZ                                        
    ## 246            -  XYZ                                        
    ## 247            -  XYZ                                        
    ## 248            -  XYZ                                        
    ## 249            -  XYZ                                        
    ## 250            -  XYZ                                        
    ## 251            -  XYZ                                        
    ## 252            -  XYZ                                        
    ## 253            -  XYZ                                        
    ## 254            -  XYZ                                        
    ## 255            -  XYZ                                        
    ## 256            -  XYZ                                        
    ## 257            -  XYZ                                        
    ## 258            -  XYZ                                        
    ## 259            -  XYZ                                        
    ## 260            -  XYZ                                        
    ## 261            -  XYZ                                        
    ## 262            -  XYZ                                        
    ## 263            -  XYZ                                        
    ## 264            -  XYZ                                        
    ## 265            -  XYZ                                        
    ## 266            -  XYZ                                        
    ## 267            -  XYZ                                        
    ## 268            -  XYZ                                        
    ## 269            -  XYZ                                        
    ## 270            -  XYZ                                        
    ## 271            -  XYZ                                        
    ## 272            -  XYZ                                        
    ## 273            -  XYZ                                        
    ## 274            -  XYZ                                        
    ## 275            -  XYZ                                        
    ## 276            -  XYZ                                        
    ## 277            -  XYZ                                        
    ## 278            -  XYZ                                        
    ## 279            -  XYZ                                        
    ## 280    X                                                     
    ## 281    Y                                                     
    ## 282    Z                                                     
    ## 283    X                                                     
    ## 284    Y                                                     
    ## 285    Z                                                     
    ## 286    X                                                     
    ## 287    Y                                                     
    ## 288    Z                                                     
    ## 289    X                                                     
    ## 290    Y                                                     
    ## 291    Z                                                     
    ## 292    X                                                     
    ## 293    Y                                                     
    ## 294    Z                                                     
    ## 295            -  XYZ                                        
    ## 296    X                                                     
    ## 297    Y                                                     
    ## 298    Z                                                     
    ## 299    X                                                     
    ## 300    Y                                                     
    ## 301    Z                                                     
    ## 302    X                                                     
    ## 303    Y                                                     
    ## 304    Z                                                     
    ## 305    X                                                     
    ## 306    Y                                                     
    ## 307    Z                                                     
    ## 308    X                                                     
    ## 309    Y                                                     
    ## 310    Z                                                     
    ## 311    X                                                     
    ## 312    X                                                     
    ## 313    Y                                                     
    ## 314    Y                                                     
    ## 315    Z                                                     
    ## 316    Z                                                     
    ## 317            -  XYZ                                        
    ## 318            -  XYZ                                        
    ## 319            -  XYZ                                        
    ## 320            -  XYZ                                        
    ## 321            -  XYZ                                        
    ## 322            -  XYZ                                        
    ## 323            -  XYZ                                        
    ## 324            -  XYZ                                        
    ## 325            -  XYZ                                        
    ## 326            -  XYZ                                        
    ## 327            -  XYZ                                        
    ## 328            -  XYZ                                        
    ## 329            -  XYZ                                        
    ## 330            -  XYZ                                        
    ## 331            -  XYZ                                        
    ## 332            -  XYZ                                        
    ## 333            -  XYZ                                        
    ## 334            -  XYZ                                        
    ## 335            -  XYZ                                        
    ## 336            -  XYZ                                        
    ## 337            -  XYZ                                        
    ## 338            -  XYZ                                        
    ## 339            -  XYZ                                        
    ## 340            -  XYZ                                        
    ## 341            -  XYZ                                        
    ## 342            -  XYZ                                        
    ## 343            -  XYZ                                        
    ## 344            -  XYZ                                        
    ## 345            -  XYZ                                        
    ## 346            -  XYZ                                        
    ## 347            -  XYZ                                        
    ## 348            -  XYZ                                        
    ## 349            -  XYZ                                        
    ## 350            -  XYZ                                        
    ## 351            -  XYZ                                        
    ## 352            -  XYZ                                        
    ## 353            -  XYZ                                        
    ## 354            -  XYZ                                        
    ## 355            -  XYZ                                        
    ## 356            -  XYZ                                        
    ## 357            -  XYZ                                        
    ## 358            -  XYZ                                        
    ## 359    X                                                     
    ## 360    Y                                                     
    ## 361    Z                                                     
    ## 362    X                                                     
    ## 363    Y                                                     
    ## 364    Z                                                     
    ## 365    X                                                     
    ## 366    Y                                                     
    ## 367    Z                                                     
    ## 368    X                                                     
    ## 369    Y                                                     
    ## 370    Z                                                     
    ## 371    X                                                     
    ## 372    Y                                                     
    ## 373    Z                                                     
    ## 374            -  XYZ                                        
    ## 375    X                                                     
    ## 376    Y                                                     
    ## 377    Z                                                     
    ## 378    X                                                     
    ## 379    Y                                                     
    ## 380    Z                                                     
    ## 381    X                                                     
    ## 382    Y                                                     
    ## 383    Z                                                     
    ## 384    X                                                     
    ## 385    Y                                                     
    ## 386    Z                                                     
    ## 387    X                                                     
    ## 388    Y                                                     
    ## 389    Z                                                     
    ## 390    X                                                     
    ## 391    X                                                     
    ## 392    Y                                                     
    ## 393    Y                                                     
    ## 394    Z                                                     
    ## 395    Z                                                     
    ## 396            -  XYZ                                        
    ## 397            -  XYZ                                        
    ## 398            -  XYZ                                        
    ## 399            -  XYZ                                        
    ## 400            -  XYZ                                        
    ## 401            -  XYZ                                        
    ## 402            -  XYZ                                        
    ## 403            -  XYZ                                        
    ## 404            -  XYZ                                        
    ## 405            -  XYZ                                        
    ## 406            -  XYZ                                        
    ## 407            -  XYZ                                        
    ## 408            -  XYZ                                        
    ## 409            -  XYZ                                        
    ## 410            -  XYZ                                        
    ## 411            -  XYZ                                        
    ## 412            -  XYZ                                        
    ## 413            -  XYZ                                        
    ## 414            -  XYZ                                        
    ## 415            -  XYZ                                        
    ## 416            -  XYZ                                        
    ## 417            -  XYZ                                        
    ## 418            -  XYZ                                        
    ## 419            -  XYZ                                        
    ## 420            -  XYZ                                        
    ## 421            -  XYZ                                        
    ## 422            -  XYZ                                        
    ## 423            -  XYZ                                        
    ## 424            -  XYZ                                        
    ## 425            -  XYZ                                        
    ## 426            -  XYZ                                        
    ## 427            -  XYZ                                        
    ## 428            -  XYZ                                        
    ## 429            -  XYZ                                        
    ## 430            -  XYZ                                        
    ## 431            -  XYZ                                        
    ## 432            -  XYZ                                        
    ## 433            -  XYZ                                        
    ## 434            -  XYZ                                        
    ## 435            -  XYZ                                        
    ## 436            -  XYZ                                        
    ## 437            -  XYZ                                        
    ##     correlationAxis1 correlationSep2 correlationAxis2 bandsEnergySep1
    ## 1                                                                    
    ## 2                                                                    
    ## 3                                                                    
    ## 4                                                                    
    ## 5                                                                    
    ## 6                                                                    
    ## 7                                                                    
    ## 8                                                                    
    ## 9                                                                    
    ## 10                                                                   
    ## 11                                                                   
    ## 12                                                                   
    ## 13                                                                   
    ## 14                                                                   
    ## 15                                                                   
    ## 16                                                                   
    ## 17                                                                   
    ## 18                                                                   
    ## 19                                                                   
    ## 20                                                                   
    ## 21                                                                   
    ## 22                                                                   
    ## 23                                                                   
    ## 24                                                                   
    ## 25                                                                   
    ## 26                                                                   
    ## 27                                                                   
    ## 28                                                                   
    ## 29                                                                   
    ## 30                                                                   
    ## 31                                                                   
    ## 32                                                                   
    ## 33                                                                   
    ## 34                                                                   
    ## 35                                                                   
    ## 36                                                                   
    ## 37                                                                   
    ## 38                 X               ,                Y                
    ## 39                 X               ,                Z                
    ## 40                 Y               ,                Z                
    ## 41                                                                   
    ## 42                                                                   
    ## 43                                                                   
    ## 44                                                                   
    ## 45                                                                   
    ## 46                                                                   
    ## 47                                                                   
    ## 48                                                                   
    ## 49                                                                   
    ## 50                                                                   
    ## 51                                                                   
    ## 52                                                                   
    ## 53                                                                   
    ## 54                                                                   
    ## 55                                                                   
    ## 56                                                                   
    ## 57                                                                   
    ## 58                                                                   
    ## 59                                                                   
    ## 60                                                                   
    ## 61                                                                   
    ## 62                                                                   
    ## 63                                                                   
    ## 64                                                                   
    ## 65                                                                   
    ## 66                                                                   
    ## 67                                                                   
    ## 68                                                                   
    ## 69                                                                   
    ## 70                                                                   
    ## 71                                                                   
    ## 72                                                                   
    ## 73                                                                   
    ## 74                                                                   
    ## 75                                                                   
    ## 76                                                                   
    ## 77                                                                   
    ## 78                 X               ,                Y                
    ## 79                 X               ,                Z                
    ## 80                 Y               ,                Z                
    ## 81                                                                   
    ## 82                                                                   
    ## 83                                                                   
    ## 84                                                                   
    ## 85                                                                   
    ## 86                                                                   
    ## 87                                                                   
    ## 88                                                                   
    ## 89                                                                   
    ## 90                                                                   
    ## 91                                                                   
    ## 92                                                                   
    ## 93                                                                   
    ## 94                                                                   
    ## 95                                                                   
    ## 96                                                                   
    ## 97                                                                   
    ## 98                                                                   
    ## 99                                                                   
    ## 100                                                                  
    ## 101                                                                  
    ## 102                                                                  
    ## 103                                                                  
    ## 104                                                                  
    ## 105                                                                  
    ## 106                                                                  
    ## 107                                                                  
    ## 108                                                                  
    ## 109                                                                  
    ## 110                                                                  
    ## 111                                                                  
    ## 112                                                                  
    ## 113                                                                  
    ## 114                                                                  
    ## 115                                                                  
    ## 116                                                                  
    ## 117                                                                  
    ## 118                X               ,                Y                
    ## 119                X               ,                Z                
    ## 120                Y               ,                Z                
    ## 121                                                                  
    ## 122                                                                  
    ## 123                                                                  
    ## 124                                                                  
    ## 125                                                                  
    ## 126                                                                  
    ## 127                                                                  
    ## 128                                                                  
    ## 129                                                                  
    ## 130                                                                  
    ## 131                                                                  
    ## 132                                                                  
    ## 133                                                                  
    ## 134                                                                  
    ## 135                                                                  
    ## 136                                                                  
    ## 137                                                                  
    ## 138                                                                  
    ## 139                                                                  
    ## 140                                                                  
    ## 141                                                                  
    ## 142                                                                  
    ## 143                                                                  
    ## 144                                                                  
    ## 145                                                                  
    ## 146                                                                  
    ## 147                                                                  
    ## 148                                                                  
    ## 149                                                                  
    ## 150                                                                  
    ## 151                                                                  
    ## 152                                                                  
    ## 153                                                                  
    ## 154                                                                  
    ## 155                                                                  
    ## 156                                                                  
    ## 157                                                                  
    ## 158                X               ,                Y                
    ## 159                X               ,                Z                
    ## 160                Y               ,                Z                
    ## 161                                                                  
    ## 162                                                                  
    ## 163                                                                  
    ## 164                                                                  
    ## 165                                                                  
    ## 166                                                                  
    ## 167                                                                  
    ## 168                                                                  
    ## 169                                                                  
    ## 170                                                                  
    ## 171                                                                  
    ## 172                                                                  
    ## 173                                                                  
    ## 174                                                                  
    ## 175                                                                  
    ## 176                                                                  
    ## 177                                                                  
    ## 178                                                                  
    ## 179                                                                  
    ## 180                                                                  
    ## 181                                                                  
    ## 182                                                                  
    ## 183                                                                  
    ## 184                                                                  
    ## 185                                                                  
    ## 186                                                                  
    ## 187                                                                  
    ## 188                                                                  
    ## 189                                                                  
    ## 190                                                                  
    ## 191                                                                  
    ## 192                                                                  
    ## 193                                                                  
    ## 194                                                                  
    ## 195                                                                  
    ## 196                                                                  
    ## 197                                                                  
    ## 198                X               ,                Y                
    ## 199                X               ,                Z                
    ## 200                Y               ,                Z                
    ## 201                                                                  
    ## 202                                                                  
    ## 203                                                                  
    ## 204                                                                  
    ## 205                                                                  
    ## 206                                                                  
    ## 207                                                                  
    ## 208                                                                  
    ## 209                                                                  
    ## 210                                                                  
    ## 211                                                                  
    ## 212                                                                  
    ## 213                                                                  
    ## 214                                                                  
    ## 215                                                                  
    ## 216                                                                  
    ## 217                                                                  
    ## 218                                                                  
    ## 219                                                                  
    ## 220                                                                  
    ## 221                                                                  
    ## 222                                                                  
    ## 223                                                                  
    ## 224                                                                  
    ## 225                                                                  
    ## 226                                                                  
    ## 227                                                                  
    ## 228                                                                  
    ## 229                                                                  
    ## 230                                                                  
    ## 231                                                                  
    ## 232                                                                  
    ## 233                                                                  
    ## 234                                                                  
    ## 235                                                                  
    ## 236                                                                  
    ## 237                                                                  
    ## 238                                                                 -
    ## 239                                                                 -
    ## 240                                                                 -
    ## 241                                                                 -
    ## 242                                                                 -
    ## 243                                                                 -
    ## 244                                                                 -
    ## 245                                                                 -
    ## 246                                                                 -
    ## 247                                                                 -
    ## 248                                                                 -
    ## 249                                                                 -
    ## 250                                                                 -
    ## 251                                                                 -
    ## 252                                                                 -
    ## 253                                                                 -
    ## 254                                                                 -
    ## 255                                                                 -
    ## 256                                                                 -
    ## 257                                                                 -
    ## 258                                                                 -
    ## 259                                                                 -
    ## 260                                                                 -
    ## 261                                                                 -
    ## 262                                                                 -
    ## 263                                                                 -
    ## 264                                                                 -
    ## 265                                                                 -
    ## 266                                                                 -
    ## 267                                                                 -
    ## 268                                                                 -
    ## 269                                                                 -
    ## 270                                                                 -
    ## 271                                                                 -
    ## 272                                                                 -
    ## 273                                                                 -
    ## 274                                                                 -
    ## 275                                                                 -
    ## 276                                                                 -
    ## 277                                                                 -
    ## 278                                                                 -
    ## 279                                                                 -
    ## 280                                                                  
    ## 281                                                                  
    ## 282                                                                  
    ## 283                                                                  
    ## 284                                                                  
    ## 285                                                                  
    ## 286                                                                  
    ## 287                                                                  
    ## 288                                                                  
    ## 289                                                                  
    ## 290                                                                  
    ## 291                                                                  
    ## 292                                                                  
    ## 293                                                                  
    ## 294                                                                  
    ## 295                                                                  
    ## 296                                                                  
    ## 297                                                                  
    ## 298                                                                  
    ## 299                                                                  
    ## 300                                                                  
    ## 301                                                                  
    ## 302                                                                  
    ## 303                                                                  
    ## 304                                                                  
    ## 305                                                                  
    ## 306                                                                  
    ## 307                                                                  
    ## 308                                                                  
    ## 309                                                                  
    ## 310                                                                  
    ## 311                                                                  
    ## 312                                                                  
    ## 313                                                                  
    ## 314                                                                  
    ## 315                                                                  
    ## 316                                                                  
    ## 317                                                                 -
    ## 318                                                                 -
    ## 319                                                                 -
    ## 320                                                                 -
    ## 321                                                                 -
    ## 322                                                                 -
    ## 323                                                                 -
    ## 324                                                                 -
    ## 325                                                                 -
    ## 326                                                                 -
    ## 327                                                                 -
    ## 328                                                                 -
    ## 329                                                                 -
    ## 330                                                                 -
    ## 331                                                                 -
    ## 332                                                                 -
    ## 333                                                                 -
    ## 334                                                                 -
    ## 335                                                                 -
    ## 336                                                                 -
    ## 337                                                                 -
    ## 338                                                                 -
    ## 339                                                                 -
    ## 340                                                                 -
    ## 341                                                                 -
    ## 342                                                                 -
    ## 343                                                                 -
    ## 344                                                                 -
    ## 345                                                                 -
    ## 346                                                                 -
    ## 347                                                                 -
    ## 348                                                                 -
    ## 349                                                                 -
    ## 350                                                                 -
    ## 351                                                                 -
    ## 352                                                                 -
    ## 353                                                                 -
    ## 354                                                                 -
    ## 355                                                                 -
    ## 356                                                                 -
    ## 357                                                                 -
    ## 358                                                                 -
    ## 359                                                                  
    ## 360                                                                  
    ## 361                                                                  
    ## 362                                                                  
    ## 363                                                                  
    ## 364                                                                  
    ## 365                                                                  
    ## 366                                                                  
    ## 367                                                                  
    ## 368                                                                  
    ## 369                                                                  
    ## 370                                                                  
    ## 371                                                                  
    ## 372                                                                  
    ## 373                                                                  
    ## 374                                                                  
    ## 375                                                                  
    ## 376                                                                  
    ## 377                                                                  
    ## 378                                                                  
    ## 379                                                                  
    ## 380                                                                  
    ## 381                                                                  
    ## 382                                                                  
    ## 383                                                                  
    ## 384                                                                  
    ## 385                                                                  
    ## 386                                                                  
    ## 387                                                                  
    ## 388                                                                  
    ## 389                                                                  
    ## 390                                                                  
    ## 391                                                                  
    ## 392                                                                  
    ## 393                                                                  
    ## 394                                                                  
    ## 395                                                                  
    ## 396                                                                 -
    ## 397                                                                 -
    ## 398                                                                 -
    ## 399                                                                 -
    ## 400                                                                 -
    ## 401                                                                 -
    ## 402                                                                 -
    ## 403                                                                 -
    ## 404                                                                 -
    ## 405                                                                 -
    ## 406                                                                 -
    ## 407                                                                 -
    ## 408                                                                 -
    ## 409                                                                 -
    ## 410                                                                 -
    ## 411                                                                 -
    ## 412                                                                 -
    ## 413                                                                 -
    ## 414                                                                 -
    ## 415                                                                 -
    ## 416                                                                 -
    ## 417                                                                 -
    ## 418                                                                 -
    ## 419                                                                 -
    ## 420                                                                 -
    ## 421                                                                 -
    ## 422                                                                 -
    ## 423                                                                 -
    ## 424                                                                 -
    ## 425                                                                 -
    ## 426                                                                 -
    ## 427                                                                 -
    ## 428                                                                 -
    ## 429                                                                 -
    ## 430                                                                 -
    ## 431                                                                 -
    ## 432                                                                 -
    ## 433                                                                 -
    ## 434                                                                 -
    ## 435                                                                 -
    ## 436                                                                 -
    ## 437                                                                 -
    ##     bandsEnergyLower bandsEnergySep2 bandsEnergyUpper angleSep1 angleArg1
    ## 1                                                                        
    ## 2                                                                        
    ## 3                                                                        
    ## 4                                                                        
    ## 5                                                                        
    ## 6                                                                        
    ## 7                                                                        
    ## 8                                                                        
    ## 9                                                                        
    ## 10                                                                       
    ## 11                                                                       
    ## 12                                                                       
    ## 13                                                                       
    ## 14                                                                       
    ## 15                                                                       
    ## 16                                                                       
    ## 17                                                                       
    ## 18                                                                       
    ## 19                                                                       
    ## 20                                                                       
    ## 21                                                                       
    ## 22                                                                       
    ## 23                                                                       
    ## 24                                                                       
    ## 25                                                                       
    ## 26                                                                       
    ## 27                                                                       
    ## 28                                                                       
    ## 29                                                                       
    ## 30                                                                       
    ## 31                                                                       
    ## 32                                                                       
    ## 33                                                                       
    ## 34                                                                       
    ## 35                                                                       
    ## 36                                                                       
    ## 37                                                                       
    ## 38                                                                       
    ## 39                                                                       
    ## 40                                                                       
    ## 41                                                                       
    ## 42                                                                       
    ## 43                                                                       
    ## 44                                                                       
    ## 45                                                                       
    ## 46                                                                       
    ## 47                                                                       
    ## 48                                                                       
    ## 49                                                                       
    ## 50                                                                       
    ## 51                                                                       
    ## 52                                                                       
    ## 53                                                                       
    ## 54                                                                       
    ## 55                                                                       
    ## 56                                                                       
    ## 57                                                                       
    ## 58                                                                       
    ## 59                                                                       
    ## 60                                                                       
    ## 61                                                                       
    ## 62                                                                       
    ## 63                                                                       
    ## 64                                                                       
    ## 65                                                                       
    ## 66                                                                       
    ## 67                                                                       
    ## 68                                                                       
    ## 69                                                                       
    ## 70                                                                       
    ## 71                                                                       
    ## 72                                                                       
    ## 73                                                                       
    ## 74                                                                       
    ## 75                                                                       
    ## 76                                                                       
    ## 77                                                                       
    ## 78                                                                       
    ## 79                                                                       
    ## 80                                                                       
    ## 81                                                                       
    ## 82                                                                       
    ## 83                                                                       
    ## 84                                                                       
    ## 85                                                                       
    ## 86                                                                       
    ## 87                                                                       
    ## 88                                                                       
    ## 89                                                                       
    ## 90                                                                       
    ## 91                                                                       
    ## 92                                                                       
    ## 93                                                                       
    ## 94                                                                       
    ## 95                                                                       
    ## 96                                                                       
    ## 97                                                                       
    ## 98                                                                       
    ## 99                                                                       
    ## 100                                                                      
    ## 101                                                                      
    ## 102                                                                      
    ## 103                                                                      
    ## 104                                                                      
    ## 105                                                                      
    ## 106                                                                      
    ## 107                                                                      
    ## 108                                                                      
    ## 109                                                                      
    ## 110                                                                      
    ## 111                                                                      
    ## 112                                                                      
    ## 113                                                                      
    ## 114                                                                      
    ## 115                                                                      
    ## 116                                                                      
    ## 117                                                                      
    ## 118                                                                      
    ## 119                                                                      
    ## 120                                                                      
    ## 121                                                                      
    ## 122                                                                      
    ## 123                                                                      
    ## 124                                                                      
    ## 125                                                                      
    ## 126                                                                      
    ## 127                                                                      
    ## 128                                                                      
    ## 129                                                                      
    ## 130                                                                      
    ## 131                                                                      
    ## 132                                                                      
    ## 133                                                                      
    ## 134                                                                      
    ## 135                                                                      
    ## 136                                                                      
    ## 137                                                                      
    ## 138                                                                      
    ## 139                                                                      
    ## 140                                                                      
    ## 141                                                                      
    ## 142                                                                      
    ## 143                                                                      
    ## 144                                                                      
    ## 145                                                                      
    ## 146                                                                      
    ## 147                                                                      
    ## 148                                                                      
    ## 149                                                                      
    ## 150                                                                      
    ## 151                                                                      
    ## 152                                                                      
    ## 153                                                                      
    ## 154                                                                      
    ## 155                                                                      
    ## 156                                                                      
    ## 157                                                                      
    ## 158                                                                      
    ## 159                                                                      
    ## 160                                                                      
    ## 161                                                                      
    ## 162                                                                      
    ## 163                                                                      
    ## 164                                                                      
    ## 165                                                                      
    ## 166                                                                      
    ## 167                                                                      
    ## 168                                                                      
    ## 169                                                                      
    ## 170                                                                      
    ## 171                                                                      
    ## 172                                                                      
    ## 173                                                                      
    ## 174                                                                      
    ## 175                                                                      
    ## 176                                                                      
    ## 177                                                                      
    ## 178                                                                      
    ## 179                                                                      
    ## 180                                                                      
    ## 181                                                                      
    ## 182                                                                      
    ## 183                                                                      
    ## 184                                                                      
    ## 185                                                                      
    ## 186                                                                      
    ## 187                                                                      
    ## 188                                                                      
    ## 189                                                                      
    ## 190                                                                      
    ## 191                                                                      
    ## 192                                                                      
    ## 193                                                                      
    ## 194                                                                      
    ## 195                                                                      
    ## 196                                                                      
    ## 197                                                                      
    ## 198                                                                      
    ## 199                                                                      
    ## 200                                                                      
    ## 201                                                                      
    ## 202                                                                      
    ## 203                                                                      
    ## 204                                                                      
    ## 205                                                                      
    ## 206                                                                      
    ## 207                                                                      
    ## 208                                                                      
    ## 209                                                                      
    ## 210                                                                      
    ## 211                                                                      
    ## 212                                                                      
    ## 213                                                                      
    ## 214                                                                      
    ## 215                                                                      
    ## 216                                                                      
    ## 217                                                                      
    ## 218                                                                      
    ## 219                                                                      
    ## 220                                                                      
    ## 221                                                                      
    ## 222                                                                      
    ## 223                                                                      
    ## 224                                                                      
    ## 225                                                                      
    ## 226                                                                      
    ## 227                                                                      
    ## 228                                                                      
    ## 229                                                                      
    ## 230                                                                      
    ## 231                                                                      
    ## 232                                                                      
    ## 233                                                                      
    ## 234                                                                      
    ## 235                                                                      
    ## 236                                                                      
    ## 237                                                                      
    ## 238                1               ,                8                    
    ## 239                9               ,               16                    
    ## 240               17               ,               24                    
    ## 241               25               ,               32                    
    ## 242               33               ,               40                    
    ## 243               41               ,               48                    
    ## 244               49               ,               56                    
    ## 245               57               ,               64                    
    ## 246                1               ,               16                    
    ## 247               17               ,               32                    
    ## 248               33               ,               48                    
    ## 249               49               ,               64                    
    ## 250                1               ,               24                    
    ## 251               25               ,               48                    
    ## 252                1               ,                8                    
    ## 253                9               ,               16                    
    ## 254               17               ,               24                    
    ## 255               25               ,               32                    
    ## 256               33               ,               40                    
    ## 257               41               ,               48                    
    ## 258               49               ,               56                    
    ## 259               57               ,               64                    
    ## 260                1               ,               16                    
    ## 261               17               ,               32                    
    ## 262               33               ,               48                    
    ## 263               49               ,               64                    
    ## 264                1               ,               24                    
    ## 265               25               ,               48                    
    ## 266                1               ,                8                    
    ## 267                9               ,               16                    
    ## 268               17               ,               24                    
    ## 269               25               ,               32                    
    ## 270               33               ,               40                    
    ## 271               41               ,               48                    
    ## 272               49               ,               56                    
    ## 273               57               ,               64                    
    ## 274                1               ,               16                    
    ## 275               17               ,               32                    
    ## 276               33               ,               48                    
    ## 277               49               ,               64                    
    ## 278                1               ,               24                    
    ## 279               25               ,               48                    
    ## 280                                                                      
    ## 281                                                                      
    ## 282                                                                      
    ## 283                                                                      
    ## 284                                                                      
    ## 285                                                                      
    ## 286                                                                      
    ## 287                                                                      
    ## 288                                                                      
    ## 289                                                                      
    ## 290                                                                      
    ## 291                                                                      
    ## 292                                                                      
    ## 293                                                                      
    ## 294                                                                      
    ## 295                                                                      
    ## 296                                                                      
    ## 297                                                                      
    ## 298                                                                      
    ## 299                                                                      
    ## 300                                                                      
    ## 301                                                                      
    ## 302                                                                      
    ## 303                                                                      
    ## 304                                                                      
    ## 305                                                                      
    ## 306                                                                      
    ## 307                                                                      
    ## 308                                                                      
    ## 309                                                                      
    ## 310                                                                      
    ## 311                                                                      
    ## 312                                                                      
    ## 313                                                                      
    ## 314                                                                      
    ## 315                                                                      
    ## 316                                                                      
    ## 317                1               ,                8                    
    ## 318                9               ,               16                    
    ## 319               17               ,               24                    
    ## 320               25               ,               32                    
    ## 321               33               ,               40                    
    ## 322               41               ,               48                    
    ## 323               49               ,               56                    
    ## 324               57               ,               64                    
    ## 325                1               ,               16                    
    ## 326               17               ,               32                    
    ## 327               33               ,               48                    
    ## 328               49               ,               64                    
    ## 329                1               ,               24                    
    ## 330               25               ,               48                    
    ## 331                1               ,                8                    
    ## 332                9               ,               16                    
    ## 333               17               ,               24                    
    ## 334               25               ,               32                    
    ## 335               33               ,               40                    
    ## 336               41               ,               48                    
    ## 337               49               ,               56                    
    ## 338               57               ,               64                    
    ## 339                1               ,               16                    
    ## 340               17               ,               32                    
    ## 341               33               ,               48                    
    ## 342               49               ,               64                    
    ## 343                1               ,               24                    
    ## 344               25               ,               48                    
    ## 345                1               ,                8                    
    ## 346                9               ,               16                    
    ## 347               17               ,               24                    
    ## 348               25               ,               32                    
    ## 349               33               ,               40                    
    ## 350               41               ,               48                    
    ## 351               49               ,               56                    
    ## 352               57               ,               64                    
    ## 353                1               ,               16                    
    ## 354               17               ,               32                    
    ## 355               33               ,               48                    
    ## 356               49               ,               64                    
    ## 357                1               ,               24                    
    ## 358               25               ,               48                    
    ## 359                                                                      
    ## 360                                                                      
    ## 361                                                                      
    ## 362                                                                      
    ## 363                                                                      
    ## 364                                                                      
    ## 365                                                                      
    ## 366                                                                      
    ## 367                                                                      
    ## 368                                                                      
    ## 369                                                                      
    ## 370                                                                      
    ## 371                                                                      
    ## 372                                                                      
    ## 373                                                                      
    ## 374                                                                      
    ## 375                                                                      
    ## 376                                                                      
    ## 377                                                                      
    ## 378                                                                      
    ## 379                                                                      
    ## 380                                                                      
    ## 381                                                                      
    ## 382                                                                      
    ## 383                                                                      
    ## 384                                                                      
    ## 385                                                                      
    ## 386                                                                      
    ## 387                                                                      
    ## 388                                                                      
    ## 389                                                                      
    ## 390                                                                      
    ## 391                                                                      
    ## 392                                                                      
    ## 393                                                                      
    ## 394                                                                      
    ## 395                                                                      
    ## 396                1               ,                8                    
    ## 397                9               ,               16                    
    ## 398               17               ,               24                    
    ## 399               25               ,               32                    
    ## 400               33               ,               40                    
    ## 401               41               ,               48                    
    ## 402               49               ,               56                    
    ## 403               57               ,               64                    
    ## 404                1               ,               16                    
    ## 405               17               ,               32                    
    ## 406               33               ,               48                    
    ## 407               49               ,               64                    
    ## 408                1               ,               24                    
    ## 409               25               ,               48                    
    ## 410                1               ,                8                    
    ## 411                9               ,               16                    
    ## 412               17               ,               24                    
    ## 413               25               ,               32                    
    ## 414               33               ,               40                    
    ## 415               41               ,               48                    
    ## 416               49               ,               56                    
    ## 417               57               ,               64                    
    ## 418                1               ,               16                    
    ## 419               17               ,               32                    
    ## 420               33               ,               48                    
    ## 421               49               ,               64                    
    ## 422                1               ,               24                    
    ## 423               25               ,               48                    
    ## 424                1               ,                8                    
    ## 425                9               ,               16                    
    ## 426               17               ,               24                    
    ## 427               25               ,               32                    
    ## 428               33               ,               40                    
    ## 429               41               ,               48                    
    ## 430               49               ,               56                    
    ## 431               57               ,               64                    
    ## 432                1               ,               16                    
    ## 433               17               ,               32                    
    ## 434               33               ,               48                    
    ## 435               49               ,               64                    
    ## 436                1               ,               24                    
    ## 437               25               ,               48                    
    ##     angleSep2 angleArg2 angleSep3
    ## 1                                
    ## 2                                
    ## 3                                
    ## 4                                
    ## 5                                
    ## 6                                
    ## 7                                
    ## 8                                
    ## 9                                
    ## 10                               
    ## 11                               
    ## 12                               
    ## 13                               
    ## 14                               
    ## 15                               
    ## 16                               
    ## 17                               
    ## 18                               
    ## 19                               
    ## 20                               
    ## 21                               
    ## 22                               
    ## 23                               
    ## 24                               
    ## 25                               
    ## 26                               
    ## 27                               
    ## 28                               
    ## 29                               
    ## 30                               
    ## 31                               
    ## 32                               
    ## 33                               
    ## 34                               
    ## 35                               
    ## 36                               
    ## 37                               
    ## 38                               
    ## 39                               
    ## 40                               
    ## 41                               
    ## 42                               
    ## 43                               
    ## 44                               
    ## 45                               
    ## 46                               
    ## 47                               
    ## 48                               
    ## 49                               
    ## 50                               
    ## 51                               
    ## 52                               
    ## 53                               
    ## 54                               
    ## 55                               
    ## 56                               
    ## 57                               
    ## 58                               
    ## 59                               
    ## 60                               
    ## 61                               
    ## 62                               
    ## 63                               
    ## 64                               
    ## 65                               
    ## 66                               
    ## 67                               
    ## 68                               
    ## 69                               
    ## 70                               
    ## 71                               
    ## 72                               
    ## 73                               
    ## 74                               
    ## 75                               
    ## 76                               
    ## 77                               
    ## 78                               
    ## 79                               
    ## 80                               
    ## 81                               
    ## 82                               
    ## 83                               
    ## 84                               
    ## 85                               
    ## 86                               
    ## 87                               
    ## 88                               
    ## 89                               
    ## 90                               
    ## 91                               
    ## 92                               
    ## 93                               
    ## 94                               
    ## 95                               
    ## 96                               
    ## 97                               
    ## 98                               
    ## 99                               
    ## 100                              
    ## 101                              
    ## 102                              
    ## 103                              
    ## 104                              
    ## 105                              
    ## 106                              
    ## 107                              
    ## 108                              
    ## 109                              
    ## 110                              
    ## 111                              
    ## 112                              
    ## 113                              
    ## 114                              
    ## 115                              
    ## 116                              
    ## 117                              
    ## 118                              
    ## 119                              
    ## 120                              
    ## 121                              
    ## 122                              
    ## 123                              
    ## 124                              
    ## 125                              
    ## 126                              
    ## 127                              
    ## 128                              
    ## 129                              
    ## 130                              
    ## 131                              
    ## 132                              
    ## 133                              
    ## 134                              
    ## 135                              
    ## 136                              
    ## 137                              
    ## 138                              
    ## 139                              
    ## 140                              
    ## 141                              
    ## 142                              
    ## 143                              
    ## 144                              
    ## 145                              
    ## 146                              
    ## 147                              
    ## 148                              
    ## 149                              
    ## 150                              
    ## 151                              
    ## 152                              
    ## 153                              
    ## 154                              
    ## 155                              
    ## 156                              
    ## 157                              
    ## 158                              
    ## 159                              
    ## 160                              
    ## 161                              
    ## 162                              
    ## 163                              
    ## 164                              
    ## 165                              
    ## 166                              
    ## 167                              
    ## 168                              
    ## 169                              
    ## 170                              
    ## 171                              
    ## 172                              
    ## 173                              
    ## 174                              
    ## 175                              
    ## 176                              
    ## 177                              
    ## 178                              
    ## 179                              
    ## 180                              
    ## 181                              
    ## 182                              
    ## 183                              
    ## 184                              
    ## 185                              
    ## 186                              
    ## 187                              
    ## 188                              
    ## 189                              
    ## 190                              
    ## 191                              
    ## 192                              
    ## 193                              
    ## 194                              
    ## 195                              
    ## 196                              
    ## 197                              
    ## 198                              
    ## 199                              
    ## 200                              
    ## 201                              
    ## 202                              
    ## 203                              
    ## 204                              
    ## 205                              
    ## 206                              
    ## 207                              
    ## 208                              
    ## 209                              
    ## 210                              
    ## 211                              
    ## 212                              
    ## 213                              
    ## 214                              
    ## 215                              
    ## 216                              
    ## 217                              
    ## 218                              
    ## 219                              
    ## 220                              
    ## 221                              
    ## 222                              
    ## 223                              
    ## 224                              
    ## 225                              
    ## 226                              
    ## 227                              
    ## 228                              
    ## 229                              
    ## 230                              
    ## 231                              
    ## 232                              
    ## 233                              
    ## 234                              
    ## 235                              
    ## 236                              
    ## 237                              
    ## 238                              
    ## 239                              
    ## 240                              
    ## 241                              
    ## 242                              
    ## 243                              
    ## 244                              
    ## 245                              
    ## 246                              
    ## 247                              
    ## 248                              
    ## 249                              
    ## 250                              
    ## 251                              
    ## 252                              
    ## 253                              
    ## 254                              
    ## 255                              
    ## 256                              
    ## 257                              
    ## 258                              
    ## 259                              
    ## 260                              
    ## 261                              
    ## 262                              
    ## 263                              
    ## 264                              
    ## 265                              
    ## 266                              
    ## 267                              
    ## 268                              
    ## 269                              
    ## 270                              
    ## 271                              
    ## 272                              
    ## 273                              
    ## 274                              
    ## 275                              
    ## 276                              
    ## 277                              
    ## 278                              
    ## 279                              
    ## 280                              
    ## 281                              
    ## 282                              
    ## 283                              
    ## 284                              
    ## 285                              
    ## 286                              
    ## 287                              
    ## 288                              
    ## 289                              
    ## 290                              
    ## 291                              
    ## 292                              
    ## 293                              
    ## 294                              
    ## 295                              
    ## 296                              
    ## 297                              
    ## 298                              
    ## 299                              
    ## 300                              
    ## 301                              
    ## 302                              
    ## 303                              
    ## 304                              
    ## 305                              
    ## 306                              
    ## 307                              
    ## 308                              
    ## 309                              
    ## 310                              
    ## 311                              
    ## 312                              
    ## 313                              
    ## 314                              
    ## 315                              
    ## 316                              
    ## 317                              
    ## 318                              
    ## 319                              
    ## 320                              
    ## 321                              
    ## 322                              
    ## 323                              
    ## 324                              
    ## 325                              
    ## 326                              
    ## 327                              
    ## 328                              
    ## 329                              
    ## 330                              
    ## 331                              
    ## 332                              
    ## 333                              
    ## 334                              
    ## 335                              
    ## 336                              
    ## 337                              
    ## 338                              
    ## 339                              
    ## 340                              
    ## 341                              
    ## 342                              
    ## 343                              
    ## 344                              
    ## 345                              
    ## 346                              
    ## 347                              
    ## 348                              
    ## 349                              
    ## 350                              
    ## 351                              
    ## 352                              
    ## 353                              
    ## 354                              
    ## 355                              
    ## 356                              
    ## 357                              
    ## 358                              
    ## 359                              
    ## 360                              
    ## 361                              
    ## 362                              
    ## 363                              
    ## 364                              
    ## 365                              
    ## 366                              
    ## 367                              
    ## 368                              
    ## 369                              
    ## 370                              
    ## 371                              
    ## 372                              
    ## 373                              
    ## 374                              
    ## 375                              
    ## 376                              
    ## 377                              
    ## 378                              
    ## 379                              
    ## 380                              
    ## 381                              
    ## 382                              
    ## 383                              
    ## 384                              
    ## 385                              
    ## 386                              
    ## 387                              
    ## 388                              
    ## 389                              
    ## 390                              
    ## 391                              
    ## 392                              
    ## 393                              
    ## 394                              
    ## 395                              
    ## 396                              
    ## 397                              
    ## 398                              
    ## 399                              
    ## 400                              
    ## 401                              
    ## 402                              
    ## 403                              
    ## 404                              
    ## 405                              
    ## 406                              
    ## 407                              
    ## 408                              
    ## 409                              
    ## 410                              
    ## 411                              
    ## 412                              
    ## 413                              
    ## 414                              
    ## 415                              
    ## 416                              
    ## 417                              
    ## 418                              
    ## 419                              
    ## 420                              
    ## 421                              
    ## 422                              
    ## 423                              
    ## 424                              
    ## 425                              
    ## 426                              
    ## 427                              
    ## 428                              
    ## 429                              
    ## 430                              
    ## 431                              
    ## 432                              
    ## 433                              
    ## 434                              
    ## 435                              
    ## 436                              
    ## 437

Join features with statistics and featureSignals and build a feature formula
----------------------------------------------------------------------------

``` r
features %>%
    select(id,name,statistic,arCoeffSep,arCoeffLevel,bandsEnergyLower,bandsEnergySep2,bandsEnergyUpper,angleArg1,angleSep2,angleArg2) %>% # matches("^.*Sep[1-3]")
    mutate(formula = statistic, statistic = paste0(statistic,"()")) %>%
    left_join(statistics, by = c("statistic"="name")) %>%
    
    left_join(featureSignals, by = c("id"="id")) %>%
    spread(seq, signal, sep="", fill="") %>% #, fill= ""
    mutate(seqNA = NULL) %>%

        
    #TODO: Parece que o approach de unir os Seps não é bom para os sinais derivados da feature
    mutate(formula = paste0(formula,"(",
                            
                            paste(seq1,angleArg1,angleSep2,                # possible 1st args
                                  seq2,angleArg2,arCoeffSep,arCoeffLevel,  # possible 2nd args
                                  seq3,                                    # possible 3rd args
                                  bandsEnergyLower,   bandsEnergySep2,     # possible 4th args
                                  bandsEnergyUpper,                        # possible 5th args
                                  sep="")
                            
                            ,")")) %>%
    
    mutate(seq1 = NULL, seq2 = NULL, seq3 = NULL, arCoeffLevel = NULL, bandsEnergyLower=NULL, bandsEnergyUpper=NULL, angleArg1=NULL, angleArg2=NULL) %>%

    
    arrange(id) %>%
    print
```

    ##      id                                 name     statistic arCoeffSep
    ## 1     1                    tBodyAcc-mean()-X        mean()           
    ## 2     2                    tBodyAcc-mean()-Y        mean()           
    ## 3     3                    tBodyAcc-mean()-Z        mean()           
    ## 4     4                     tBodyAcc-std()-X         std()           
    ## 5     5                     tBodyAcc-std()-Y         std()           
    ## 6     6                     tBodyAcc-std()-Z         std()           
    ## 7     7                     tBodyAcc-mad()-X         mad()           
    ## 8     8                     tBodyAcc-mad()-Y         mad()           
    ## 9     9                     tBodyAcc-mad()-Z         mad()           
    ## 10   10                     tBodyAcc-max()-X         max()           
    ## 11   11                     tBodyAcc-max()-Y         max()           
    ## 12   12                     tBodyAcc-max()-Z         max()           
    ## 13   13                     tBodyAcc-min()-X         min()           
    ## 14   14                     tBodyAcc-min()-Y         min()           
    ## 15   15                     tBodyAcc-min()-Z         min()           
    ## 16   16                       tBodyAcc-sma()         sma()           
    ## 17   17                  tBodyAcc-energy()-X      energy()           
    ## 18   18                  tBodyAcc-energy()-Y      energy()           
    ## 19   19                  tBodyAcc-energy()-Z      energy()           
    ## 20   20                     tBodyAcc-iqr()-X         iqr()           
    ## 21   21                     tBodyAcc-iqr()-Y         iqr()           
    ## 22   22                     tBodyAcc-iqr()-Z         iqr()           
    ## 23   23                 tBodyAcc-entropy()-X     entropy()           
    ## 24   24                 tBodyAcc-entropy()-Y     entropy()           
    ## 25   25                 tBodyAcc-entropy()-Z     entropy()           
    ## 26   26               tBodyAcc-arCoeff()-X,1     arCoeff()          ,
    ## 27   27               tBodyAcc-arCoeff()-X,2     arCoeff()          ,
    ## 28   28               tBodyAcc-arCoeff()-X,3     arCoeff()          ,
    ## 29   29               tBodyAcc-arCoeff()-X,4     arCoeff()          ,
    ## 30   30               tBodyAcc-arCoeff()-Y,1     arCoeff()          ,
    ## 31   31               tBodyAcc-arCoeff()-Y,2     arCoeff()          ,
    ## 32   32               tBodyAcc-arCoeff()-Y,3     arCoeff()          ,
    ## 33   33               tBodyAcc-arCoeff()-Y,4     arCoeff()          ,
    ## 34   34               tBodyAcc-arCoeff()-Z,1     arCoeff()          ,
    ## 35   35               tBodyAcc-arCoeff()-Z,2     arCoeff()          ,
    ## 36   36               tBodyAcc-arCoeff()-Z,3     arCoeff()          ,
    ## 37   37               tBodyAcc-arCoeff()-Z,4     arCoeff()          ,
    ## 38   38           tBodyAcc-correlation()-X,Y correlation()           
    ## 39   39           tBodyAcc-correlation()-X,Z correlation()           
    ## 40   40           tBodyAcc-correlation()-Y,Z correlation()           
    ## 41   41                 tGravityAcc-mean()-X        mean()           
    ## 42   42                 tGravityAcc-mean()-Y        mean()           
    ## 43   43                 tGravityAcc-mean()-Z        mean()           
    ## 44   44                  tGravityAcc-std()-X         std()           
    ## 45   45                  tGravityAcc-std()-Y         std()           
    ## 46   46                  tGravityAcc-std()-Z         std()           
    ## 47   47                  tGravityAcc-mad()-X         mad()           
    ## 48   48                  tGravityAcc-mad()-Y         mad()           
    ## 49   49                  tGravityAcc-mad()-Z         mad()           
    ## 50   50                  tGravityAcc-max()-X         max()           
    ## 51   51                  tGravityAcc-max()-Y         max()           
    ## 52   52                  tGravityAcc-max()-Z         max()           
    ## 53   53                  tGravityAcc-min()-X         min()           
    ## 54   54                  tGravityAcc-min()-Y         min()           
    ## 55   55                  tGravityAcc-min()-Z         min()           
    ## 56   56                    tGravityAcc-sma()         sma()           
    ## 57   57               tGravityAcc-energy()-X      energy()           
    ## 58   58               tGravityAcc-energy()-Y      energy()           
    ## 59   59               tGravityAcc-energy()-Z      energy()           
    ## 60   60                  tGravityAcc-iqr()-X         iqr()           
    ## 61   61                  tGravityAcc-iqr()-Y         iqr()           
    ## 62   62                  tGravityAcc-iqr()-Z         iqr()           
    ## 63   63              tGravityAcc-entropy()-X     entropy()           
    ## 64   64              tGravityAcc-entropy()-Y     entropy()           
    ## 65   65              tGravityAcc-entropy()-Z     entropy()           
    ## 66   66            tGravityAcc-arCoeff()-X,1     arCoeff()          ,
    ## 67   67            tGravityAcc-arCoeff()-X,2     arCoeff()          ,
    ## 68   68            tGravityAcc-arCoeff()-X,3     arCoeff()          ,
    ## 69   69            tGravityAcc-arCoeff()-X,4     arCoeff()          ,
    ## 70   70            tGravityAcc-arCoeff()-Y,1     arCoeff()          ,
    ## 71   71            tGravityAcc-arCoeff()-Y,2     arCoeff()          ,
    ## 72   72            tGravityAcc-arCoeff()-Y,3     arCoeff()          ,
    ## 73   73            tGravityAcc-arCoeff()-Y,4     arCoeff()          ,
    ## 74   74            tGravityAcc-arCoeff()-Z,1     arCoeff()          ,
    ## 75   75            tGravityAcc-arCoeff()-Z,2     arCoeff()          ,
    ## 76   76            tGravityAcc-arCoeff()-Z,3     arCoeff()          ,
    ## 77   77            tGravityAcc-arCoeff()-Z,4     arCoeff()          ,
    ## 78   78        tGravityAcc-correlation()-X,Y correlation()           
    ## 79   79        tGravityAcc-correlation()-X,Z correlation()           
    ## 80   80        tGravityAcc-correlation()-Y,Z correlation()           
    ## 81   81                tBodyAccJerk-mean()-X        mean()           
    ## 82   82                tBodyAccJerk-mean()-Y        mean()           
    ## 83   83                tBodyAccJerk-mean()-Z        mean()           
    ## 84   84                 tBodyAccJerk-std()-X         std()           
    ## 85   85                 tBodyAccJerk-std()-Y         std()           
    ## 86   86                 tBodyAccJerk-std()-Z         std()           
    ## 87   87                 tBodyAccJerk-mad()-X         mad()           
    ## 88   88                 tBodyAccJerk-mad()-Y         mad()           
    ## 89   89                 tBodyAccJerk-mad()-Z         mad()           
    ## 90   90                 tBodyAccJerk-max()-X         max()           
    ## 91   91                 tBodyAccJerk-max()-Y         max()           
    ## 92   92                 tBodyAccJerk-max()-Z         max()           
    ## 93   93                 tBodyAccJerk-min()-X         min()           
    ## 94   94                 tBodyAccJerk-min()-Y         min()           
    ## 95   95                 tBodyAccJerk-min()-Z         min()           
    ## 96   96                   tBodyAccJerk-sma()         sma()           
    ## 97   97              tBodyAccJerk-energy()-X      energy()           
    ## 98   98              tBodyAccJerk-energy()-Y      energy()           
    ## 99   99              tBodyAccJerk-energy()-Z      energy()           
    ## 100 100                 tBodyAccJerk-iqr()-X         iqr()           
    ## 101 101                 tBodyAccJerk-iqr()-Y         iqr()           
    ## 102 102                 tBodyAccJerk-iqr()-Z         iqr()           
    ## 103 103             tBodyAccJerk-entropy()-X     entropy()           
    ## 104 104             tBodyAccJerk-entropy()-Y     entropy()           
    ## 105 105             tBodyAccJerk-entropy()-Z     entropy()           
    ## 106 106           tBodyAccJerk-arCoeff()-X,1     arCoeff()          ,
    ## 107 107           tBodyAccJerk-arCoeff()-X,2     arCoeff()          ,
    ## 108 108           tBodyAccJerk-arCoeff()-X,3     arCoeff()          ,
    ## 109 109           tBodyAccJerk-arCoeff()-X,4     arCoeff()          ,
    ## 110 110           tBodyAccJerk-arCoeff()-Y,1     arCoeff()          ,
    ## 111 111           tBodyAccJerk-arCoeff()-Y,2     arCoeff()          ,
    ## 112 112           tBodyAccJerk-arCoeff()-Y,3     arCoeff()          ,
    ## 113 113           tBodyAccJerk-arCoeff()-Y,4     arCoeff()          ,
    ## 114 114           tBodyAccJerk-arCoeff()-Z,1     arCoeff()          ,
    ## 115 115           tBodyAccJerk-arCoeff()-Z,2     arCoeff()          ,
    ## 116 116           tBodyAccJerk-arCoeff()-Z,3     arCoeff()          ,
    ## 117 117           tBodyAccJerk-arCoeff()-Z,4     arCoeff()          ,
    ## 118 118       tBodyAccJerk-correlation()-X,Y correlation()           
    ## 119 119       tBodyAccJerk-correlation()-X,Z correlation()           
    ## 120 120       tBodyAccJerk-correlation()-Y,Z correlation()           
    ## 121 121                   tBodyGyro-mean()-X        mean()           
    ## 122 122                   tBodyGyro-mean()-Y        mean()           
    ## 123 123                   tBodyGyro-mean()-Z        mean()           
    ## 124 124                    tBodyGyro-std()-X         std()           
    ## 125 125                    tBodyGyro-std()-Y         std()           
    ## 126 126                    tBodyGyro-std()-Z         std()           
    ## 127 127                    tBodyGyro-mad()-X         mad()           
    ## 128 128                    tBodyGyro-mad()-Y         mad()           
    ## 129 129                    tBodyGyro-mad()-Z         mad()           
    ## 130 130                    tBodyGyro-max()-X         max()           
    ## 131 131                    tBodyGyro-max()-Y         max()           
    ## 132 132                    tBodyGyro-max()-Z         max()           
    ## 133 133                    tBodyGyro-min()-X         min()           
    ## 134 134                    tBodyGyro-min()-Y         min()           
    ## 135 135                    tBodyGyro-min()-Z         min()           
    ## 136 136                      tBodyGyro-sma()         sma()           
    ## 137 137                 tBodyGyro-energy()-X      energy()           
    ## 138 138                 tBodyGyro-energy()-Y      energy()           
    ## 139 139                 tBodyGyro-energy()-Z      energy()           
    ## 140 140                    tBodyGyro-iqr()-X         iqr()           
    ## 141 141                    tBodyGyro-iqr()-Y         iqr()           
    ## 142 142                    tBodyGyro-iqr()-Z         iqr()           
    ## 143 143                tBodyGyro-entropy()-X     entropy()           
    ## 144 144                tBodyGyro-entropy()-Y     entropy()           
    ## 145 145                tBodyGyro-entropy()-Z     entropy()           
    ## 146 146              tBodyGyro-arCoeff()-X,1     arCoeff()          ,
    ## 147 147              tBodyGyro-arCoeff()-X,2     arCoeff()          ,
    ## 148 148              tBodyGyro-arCoeff()-X,3     arCoeff()          ,
    ## 149 149              tBodyGyro-arCoeff()-X,4     arCoeff()          ,
    ## 150 150              tBodyGyro-arCoeff()-Y,1     arCoeff()          ,
    ## 151 151              tBodyGyro-arCoeff()-Y,2     arCoeff()          ,
    ## 152 152              tBodyGyro-arCoeff()-Y,3     arCoeff()          ,
    ## 153 153              tBodyGyro-arCoeff()-Y,4     arCoeff()          ,
    ## 154 154              tBodyGyro-arCoeff()-Z,1     arCoeff()          ,
    ## 155 155              tBodyGyro-arCoeff()-Z,2     arCoeff()          ,
    ## 156 156              tBodyGyro-arCoeff()-Z,3     arCoeff()          ,
    ## 157 157              tBodyGyro-arCoeff()-Z,4     arCoeff()          ,
    ## 158 158          tBodyGyro-correlation()-X,Y correlation()           
    ## 159 159          tBodyGyro-correlation()-X,Z correlation()           
    ## 160 160          tBodyGyro-correlation()-Y,Z correlation()           
    ## 161 161               tBodyGyroJerk-mean()-X        mean()           
    ## 162 162               tBodyGyroJerk-mean()-Y        mean()           
    ## 163 163               tBodyGyroJerk-mean()-Z        mean()           
    ## 164 164                tBodyGyroJerk-std()-X         std()           
    ## 165 165                tBodyGyroJerk-std()-Y         std()           
    ## 166 166                tBodyGyroJerk-std()-Z         std()           
    ## 167 167                tBodyGyroJerk-mad()-X         mad()           
    ## 168 168                tBodyGyroJerk-mad()-Y         mad()           
    ## 169 169                tBodyGyroJerk-mad()-Z         mad()           
    ## 170 170                tBodyGyroJerk-max()-X         max()           
    ## 171 171                tBodyGyroJerk-max()-Y         max()           
    ## 172 172                tBodyGyroJerk-max()-Z         max()           
    ## 173 173                tBodyGyroJerk-min()-X         min()           
    ## 174 174                tBodyGyroJerk-min()-Y         min()           
    ## 175 175                tBodyGyroJerk-min()-Z         min()           
    ## 176 176                  tBodyGyroJerk-sma()         sma()           
    ## 177 177             tBodyGyroJerk-energy()-X      energy()           
    ## 178 178             tBodyGyroJerk-energy()-Y      energy()           
    ## 179 179             tBodyGyroJerk-energy()-Z      energy()           
    ## 180 180                tBodyGyroJerk-iqr()-X         iqr()           
    ## 181 181                tBodyGyroJerk-iqr()-Y         iqr()           
    ## 182 182                tBodyGyroJerk-iqr()-Z         iqr()           
    ## 183 183            tBodyGyroJerk-entropy()-X     entropy()           
    ## 184 184            tBodyGyroJerk-entropy()-Y     entropy()           
    ## 185 185            tBodyGyroJerk-entropy()-Z     entropy()           
    ## 186 186          tBodyGyroJerk-arCoeff()-X,1     arCoeff()          ,
    ## 187 187          tBodyGyroJerk-arCoeff()-X,2     arCoeff()          ,
    ## 188 188          tBodyGyroJerk-arCoeff()-X,3     arCoeff()          ,
    ## 189 189          tBodyGyroJerk-arCoeff()-X,4     arCoeff()          ,
    ## 190 190          tBodyGyroJerk-arCoeff()-Y,1     arCoeff()          ,
    ## 191 191          tBodyGyroJerk-arCoeff()-Y,2     arCoeff()          ,
    ## 192 192          tBodyGyroJerk-arCoeff()-Y,3     arCoeff()          ,
    ## 193 193          tBodyGyroJerk-arCoeff()-Y,4     arCoeff()          ,
    ## 194 194          tBodyGyroJerk-arCoeff()-Z,1     arCoeff()          ,
    ## 195 195          tBodyGyroJerk-arCoeff()-Z,2     arCoeff()          ,
    ## 196 196          tBodyGyroJerk-arCoeff()-Z,3     arCoeff()          ,
    ## 197 197          tBodyGyroJerk-arCoeff()-Z,4     arCoeff()          ,
    ## 198 198      tBodyGyroJerk-correlation()-X,Y correlation()           
    ## 199 199      tBodyGyroJerk-correlation()-X,Z correlation()           
    ## 200 200      tBodyGyroJerk-correlation()-Y,Z correlation()           
    ## 201 201                   tBodyAccMag-mean()        mean()           
    ## 202 202                    tBodyAccMag-std()         std()           
    ## 203 203                    tBodyAccMag-mad()         mad()           
    ## 204 204                    tBodyAccMag-max()         max()           
    ## 205 205                    tBodyAccMag-min()         min()           
    ## 206 206                    tBodyAccMag-sma()         sma()           
    ## 207 207                 tBodyAccMag-energy()      energy()           
    ## 208 208                    tBodyAccMag-iqr()         iqr()           
    ## 209 209                tBodyAccMag-entropy()     entropy()           
    ## 210 210               tBodyAccMag-arCoeff()1     arCoeff()           
    ## 211 211               tBodyAccMag-arCoeff()2     arCoeff()           
    ## 212 212               tBodyAccMag-arCoeff()3     arCoeff()           
    ## 213 213               tBodyAccMag-arCoeff()4     arCoeff()           
    ## 214 214                tGravityAccMag-mean()        mean()           
    ## 215 215                 tGravityAccMag-std()         std()           
    ## 216 216                 tGravityAccMag-mad()         mad()           
    ## 217 217                 tGravityAccMag-max()         max()           
    ## 218 218                 tGravityAccMag-min()         min()           
    ## 219 219                 tGravityAccMag-sma()         sma()           
    ## 220 220              tGravityAccMag-energy()      energy()           
    ## 221 221                 tGravityAccMag-iqr()         iqr()           
    ## 222 222             tGravityAccMag-entropy()     entropy()           
    ## 223 223            tGravityAccMag-arCoeff()1     arCoeff()           
    ## 224 224            tGravityAccMag-arCoeff()2     arCoeff()           
    ## 225 225            tGravityAccMag-arCoeff()3     arCoeff()           
    ## 226 226            tGravityAccMag-arCoeff()4     arCoeff()           
    ## 227 227               tBodyAccJerkMag-mean()        mean()           
    ## 228 228                tBodyAccJerkMag-std()         std()           
    ## 229 229                tBodyAccJerkMag-mad()         mad()           
    ## 230 230                tBodyAccJerkMag-max()         max()           
    ## 231 231                tBodyAccJerkMag-min()         min()           
    ## 232 232                tBodyAccJerkMag-sma()         sma()           
    ## 233 233             tBodyAccJerkMag-energy()      energy()           
    ## 234 234                tBodyAccJerkMag-iqr()         iqr()           
    ## 235 235            tBodyAccJerkMag-entropy()     entropy()           
    ## 236 236           tBodyAccJerkMag-arCoeff()1     arCoeff()           
    ## 237 237           tBodyAccJerkMag-arCoeff()2     arCoeff()           
    ## 238 238           tBodyAccJerkMag-arCoeff()3     arCoeff()           
    ## 239 239           tBodyAccJerkMag-arCoeff()4     arCoeff()           
    ## 240 240                  tBodyGyroMag-mean()        mean()           
    ## 241 241                   tBodyGyroMag-std()         std()           
    ## 242 242                   tBodyGyroMag-mad()         mad()           
    ## 243 243                   tBodyGyroMag-max()         max()           
    ## 244 244                   tBodyGyroMag-min()         min()           
    ## 245 245                   tBodyGyroMag-sma()         sma()           
    ## 246 246                tBodyGyroMag-energy()      energy()           
    ## 247 247                   tBodyGyroMag-iqr()         iqr()           
    ## 248 248               tBodyGyroMag-entropy()     entropy()           
    ## 249 249              tBodyGyroMag-arCoeff()1     arCoeff()           
    ## 250 250              tBodyGyroMag-arCoeff()2     arCoeff()           
    ## 251 251              tBodyGyroMag-arCoeff()3     arCoeff()           
    ## 252 252              tBodyGyroMag-arCoeff()4     arCoeff()           
    ## 253 253              tBodyGyroJerkMag-mean()        mean()           
    ## 254 254               tBodyGyroJerkMag-std()         std()           
    ## 255 255               tBodyGyroJerkMag-mad()         mad()           
    ## 256 256               tBodyGyroJerkMag-max()         max()           
    ## 257 257               tBodyGyroJerkMag-min()         min()           
    ## 258 258               tBodyGyroJerkMag-sma()         sma()           
    ## 259 259            tBodyGyroJerkMag-energy()      energy()           
    ## 260 260               tBodyGyroJerkMag-iqr()         iqr()           
    ## 261 261           tBodyGyroJerkMag-entropy()     entropy()           
    ## 262 262          tBodyGyroJerkMag-arCoeff()1     arCoeff()           
    ## 263 263          tBodyGyroJerkMag-arCoeff()2     arCoeff()           
    ## 264 264          tBodyGyroJerkMag-arCoeff()3     arCoeff()           
    ## 265 265          tBodyGyroJerkMag-arCoeff()4     arCoeff()           
    ## 266 266                    fBodyAcc-mean()-X        mean()           
    ## 267 267                    fBodyAcc-mean()-Y        mean()           
    ## 268 268                    fBodyAcc-mean()-Z        mean()           
    ## 269 269                     fBodyAcc-std()-X         std()           
    ## 270 270                     fBodyAcc-std()-Y         std()           
    ## 271 271                     fBodyAcc-std()-Z         std()           
    ## 272 272                     fBodyAcc-mad()-X         mad()           
    ## 273 273                     fBodyAcc-mad()-Y         mad()           
    ## 274 274                     fBodyAcc-mad()-Z         mad()           
    ## 275 275                     fBodyAcc-max()-X         max()           
    ## 276 276                     fBodyAcc-max()-Y         max()           
    ## 277 277                     fBodyAcc-max()-Z         max()           
    ## 278 278                     fBodyAcc-min()-X         min()           
    ## 279 279                     fBodyAcc-min()-Y         min()           
    ## 280 280                     fBodyAcc-min()-Z         min()           
    ## 281 281                       fBodyAcc-sma()         sma()           
    ## 282 282                  fBodyAcc-energy()-X      energy()           
    ## 283 283                  fBodyAcc-energy()-Y      energy()           
    ## 284 284                  fBodyAcc-energy()-Z      energy()           
    ## 285 285                     fBodyAcc-iqr()-X         iqr()           
    ## 286 286                     fBodyAcc-iqr()-Y         iqr()           
    ## 287 287                     fBodyAcc-iqr()-Z         iqr()           
    ## 288 288                 fBodyAcc-entropy()-X     entropy()           
    ## 289 289                 fBodyAcc-entropy()-Y     entropy()           
    ## 290 290                 fBodyAcc-entropy()-Z     entropy()           
    ## 291 291                 fBodyAcc-maxInds()-X     maxInds()           
    ## 292 292                 fBodyAcc-maxInds()-Y     maxInds()           
    ## 293 293                 fBodyAcc-maxInds()-Z     maxInds()           
    ## 294 294                fBodyAcc-meanFreq()-X    meanFreq()           
    ## 295 295                fBodyAcc-meanFreq()-Y    meanFreq()           
    ## 296 296                fBodyAcc-meanFreq()-Z    meanFreq()           
    ## 297 297                fBodyAcc-skewness()-X    skewness()           
    ## 298 298                fBodyAcc-kurtosis()-X    kurtosis()           
    ## 299 299                fBodyAcc-skewness()-Y    skewness()           
    ## 300 300                fBodyAcc-kurtosis()-Y    kurtosis()           
    ## 301 301                fBodyAcc-skewness()-Z    skewness()           
    ## 302 302                fBodyAcc-kurtosis()-Z    kurtosis()           
    ## 303 303           fBodyAcc-bandsEnergy()-1,8 bandsEnergy()           
    ## 304 304          fBodyAcc-bandsEnergy()-9,16 bandsEnergy()           
    ## 305 305         fBodyAcc-bandsEnergy()-17,24 bandsEnergy()           
    ## 306 306         fBodyAcc-bandsEnergy()-25,32 bandsEnergy()           
    ## 307 307         fBodyAcc-bandsEnergy()-33,40 bandsEnergy()           
    ## 308 308         fBodyAcc-bandsEnergy()-41,48 bandsEnergy()           
    ## 309 309         fBodyAcc-bandsEnergy()-49,56 bandsEnergy()           
    ## 310 310         fBodyAcc-bandsEnergy()-57,64 bandsEnergy()           
    ## 311 311          fBodyAcc-bandsEnergy()-1,16 bandsEnergy()           
    ## 312 312         fBodyAcc-bandsEnergy()-17,32 bandsEnergy()           
    ## 313 313         fBodyAcc-bandsEnergy()-33,48 bandsEnergy()           
    ## 314 314         fBodyAcc-bandsEnergy()-49,64 bandsEnergy()           
    ## 315 315          fBodyAcc-bandsEnergy()-1,24 bandsEnergy()           
    ## 316 316         fBodyAcc-bandsEnergy()-25,48 bandsEnergy()           
    ## 317 317           fBodyAcc-bandsEnergy()-1,8 bandsEnergy()           
    ## 318 318          fBodyAcc-bandsEnergy()-9,16 bandsEnergy()           
    ## 319 319         fBodyAcc-bandsEnergy()-17,24 bandsEnergy()           
    ## 320 320         fBodyAcc-bandsEnergy()-25,32 bandsEnergy()           
    ## 321 321         fBodyAcc-bandsEnergy()-33,40 bandsEnergy()           
    ## 322 322         fBodyAcc-bandsEnergy()-41,48 bandsEnergy()           
    ## 323 323         fBodyAcc-bandsEnergy()-49,56 bandsEnergy()           
    ## 324 324         fBodyAcc-bandsEnergy()-57,64 bandsEnergy()           
    ## 325 325          fBodyAcc-bandsEnergy()-1,16 bandsEnergy()           
    ## 326 326         fBodyAcc-bandsEnergy()-17,32 bandsEnergy()           
    ## 327 327         fBodyAcc-bandsEnergy()-33,48 bandsEnergy()           
    ## 328 328         fBodyAcc-bandsEnergy()-49,64 bandsEnergy()           
    ## 329 329          fBodyAcc-bandsEnergy()-1,24 bandsEnergy()           
    ## 330 330         fBodyAcc-bandsEnergy()-25,48 bandsEnergy()           
    ## 331 331           fBodyAcc-bandsEnergy()-1,8 bandsEnergy()           
    ## 332 332          fBodyAcc-bandsEnergy()-9,16 bandsEnergy()           
    ## 333 333         fBodyAcc-bandsEnergy()-17,24 bandsEnergy()           
    ## 334 334         fBodyAcc-bandsEnergy()-25,32 bandsEnergy()           
    ## 335 335         fBodyAcc-bandsEnergy()-33,40 bandsEnergy()           
    ## 336 336         fBodyAcc-bandsEnergy()-41,48 bandsEnergy()           
    ## 337 337         fBodyAcc-bandsEnergy()-49,56 bandsEnergy()           
    ## 338 338         fBodyAcc-bandsEnergy()-57,64 bandsEnergy()           
    ## 339 339          fBodyAcc-bandsEnergy()-1,16 bandsEnergy()           
    ## 340 340         fBodyAcc-bandsEnergy()-17,32 bandsEnergy()           
    ## 341 341         fBodyAcc-bandsEnergy()-33,48 bandsEnergy()           
    ## 342 342         fBodyAcc-bandsEnergy()-49,64 bandsEnergy()           
    ## 343 343          fBodyAcc-bandsEnergy()-1,24 bandsEnergy()           
    ## 344 344         fBodyAcc-bandsEnergy()-25,48 bandsEnergy()           
    ## 345 345                fBodyAccJerk-mean()-X        mean()           
    ## 346 346                fBodyAccJerk-mean()-Y        mean()           
    ## 347 347                fBodyAccJerk-mean()-Z        mean()           
    ## 348 348                 fBodyAccJerk-std()-X         std()           
    ## 349 349                 fBodyAccJerk-std()-Y         std()           
    ## 350 350                 fBodyAccJerk-std()-Z         std()           
    ## 351 351                 fBodyAccJerk-mad()-X         mad()           
    ## 352 352                 fBodyAccJerk-mad()-Y         mad()           
    ## 353 353                 fBodyAccJerk-mad()-Z         mad()           
    ## 354 354                 fBodyAccJerk-max()-X         max()           
    ## 355 355                 fBodyAccJerk-max()-Y         max()           
    ## 356 356                 fBodyAccJerk-max()-Z         max()           
    ## 357 357                 fBodyAccJerk-min()-X         min()           
    ## 358 358                 fBodyAccJerk-min()-Y         min()           
    ## 359 359                 fBodyAccJerk-min()-Z         min()           
    ## 360 360                   fBodyAccJerk-sma()         sma()           
    ## 361 361              fBodyAccJerk-energy()-X      energy()           
    ## 362 362              fBodyAccJerk-energy()-Y      energy()           
    ## 363 363              fBodyAccJerk-energy()-Z      energy()           
    ## 364 364                 fBodyAccJerk-iqr()-X         iqr()           
    ## 365 365                 fBodyAccJerk-iqr()-Y         iqr()           
    ## 366 366                 fBodyAccJerk-iqr()-Z         iqr()           
    ## 367 367             fBodyAccJerk-entropy()-X     entropy()           
    ## 368 368             fBodyAccJerk-entropy()-Y     entropy()           
    ## 369 369             fBodyAccJerk-entropy()-Z     entropy()           
    ## 370 370             fBodyAccJerk-maxInds()-X     maxInds()           
    ## 371 371             fBodyAccJerk-maxInds()-Y     maxInds()           
    ## 372 372             fBodyAccJerk-maxInds()-Z     maxInds()           
    ## 373 373            fBodyAccJerk-meanFreq()-X    meanFreq()           
    ## 374 374            fBodyAccJerk-meanFreq()-Y    meanFreq()           
    ## 375 375            fBodyAccJerk-meanFreq()-Z    meanFreq()           
    ## 376 376            fBodyAccJerk-skewness()-X    skewness()           
    ## 377 377            fBodyAccJerk-kurtosis()-X    kurtosis()           
    ## 378 378            fBodyAccJerk-skewness()-Y    skewness()           
    ## 379 379            fBodyAccJerk-kurtosis()-Y    kurtosis()           
    ## 380 380            fBodyAccJerk-skewness()-Z    skewness()           
    ## 381 381            fBodyAccJerk-kurtosis()-Z    kurtosis()           
    ## 382 382       fBodyAccJerk-bandsEnergy()-1,8 bandsEnergy()           
    ## 383 383      fBodyAccJerk-bandsEnergy()-9,16 bandsEnergy()           
    ## 384 384     fBodyAccJerk-bandsEnergy()-17,24 bandsEnergy()           
    ## 385 385     fBodyAccJerk-bandsEnergy()-25,32 bandsEnergy()           
    ## 386 386     fBodyAccJerk-bandsEnergy()-33,40 bandsEnergy()           
    ## 387 387     fBodyAccJerk-bandsEnergy()-41,48 bandsEnergy()           
    ## 388 388     fBodyAccJerk-bandsEnergy()-49,56 bandsEnergy()           
    ## 389 389     fBodyAccJerk-bandsEnergy()-57,64 bandsEnergy()           
    ## 390 390      fBodyAccJerk-bandsEnergy()-1,16 bandsEnergy()           
    ## 391 391     fBodyAccJerk-bandsEnergy()-17,32 bandsEnergy()           
    ## 392 392     fBodyAccJerk-bandsEnergy()-33,48 bandsEnergy()           
    ## 393 393     fBodyAccJerk-bandsEnergy()-49,64 bandsEnergy()           
    ## 394 394      fBodyAccJerk-bandsEnergy()-1,24 bandsEnergy()           
    ## 395 395     fBodyAccJerk-bandsEnergy()-25,48 bandsEnergy()           
    ## 396 396       fBodyAccJerk-bandsEnergy()-1,8 bandsEnergy()           
    ## 397 397      fBodyAccJerk-bandsEnergy()-9,16 bandsEnergy()           
    ## 398 398     fBodyAccJerk-bandsEnergy()-17,24 bandsEnergy()           
    ## 399 399     fBodyAccJerk-bandsEnergy()-25,32 bandsEnergy()           
    ## 400 400     fBodyAccJerk-bandsEnergy()-33,40 bandsEnergy()           
    ## 401 401     fBodyAccJerk-bandsEnergy()-41,48 bandsEnergy()           
    ## 402 402     fBodyAccJerk-bandsEnergy()-49,56 bandsEnergy()           
    ## 403 403     fBodyAccJerk-bandsEnergy()-57,64 bandsEnergy()           
    ## 404 404      fBodyAccJerk-bandsEnergy()-1,16 bandsEnergy()           
    ## 405 405     fBodyAccJerk-bandsEnergy()-17,32 bandsEnergy()           
    ## 406 406     fBodyAccJerk-bandsEnergy()-33,48 bandsEnergy()           
    ## 407 407     fBodyAccJerk-bandsEnergy()-49,64 bandsEnergy()           
    ## 408 408      fBodyAccJerk-bandsEnergy()-1,24 bandsEnergy()           
    ## 409 409     fBodyAccJerk-bandsEnergy()-25,48 bandsEnergy()           
    ## 410 410       fBodyAccJerk-bandsEnergy()-1,8 bandsEnergy()           
    ## 411 411      fBodyAccJerk-bandsEnergy()-9,16 bandsEnergy()           
    ## 412 412     fBodyAccJerk-bandsEnergy()-17,24 bandsEnergy()           
    ## 413 413     fBodyAccJerk-bandsEnergy()-25,32 bandsEnergy()           
    ## 414 414     fBodyAccJerk-bandsEnergy()-33,40 bandsEnergy()           
    ## 415 415     fBodyAccJerk-bandsEnergy()-41,48 bandsEnergy()           
    ## 416 416     fBodyAccJerk-bandsEnergy()-49,56 bandsEnergy()           
    ## 417 417     fBodyAccJerk-bandsEnergy()-57,64 bandsEnergy()           
    ## 418 418      fBodyAccJerk-bandsEnergy()-1,16 bandsEnergy()           
    ## 419 419     fBodyAccJerk-bandsEnergy()-17,32 bandsEnergy()           
    ## 420 420     fBodyAccJerk-bandsEnergy()-33,48 bandsEnergy()           
    ## 421 421     fBodyAccJerk-bandsEnergy()-49,64 bandsEnergy()           
    ## 422 422      fBodyAccJerk-bandsEnergy()-1,24 bandsEnergy()           
    ## 423 423     fBodyAccJerk-bandsEnergy()-25,48 bandsEnergy()           
    ## 424 424                   fBodyGyro-mean()-X        mean()           
    ## 425 425                   fBodyGyro-mean()-Y        mean()           
    ## 426 426                   fBodyGyro-mean()-Z        mean()           
    ## 427 427                    fBodyGyro-std()-X         std()           
    ## 428 428                    fBodyGyro-std()-Y         std()           
    ## 429 429                    fBodyGyro-std()-Z         std()           
    ## 430 430                    fBodyGyro-mad()-X         mad()           
    ## 431 431                    fBodyGyro-mad()-Y         mad()           
    ## 432 432                    fBodyGyro-mad()-Z         mad()           
    ## 433 433                    fBodyGyro-max()-X         max()           
    ## 434 434                    fBodyGyro-max()-Y         max()           
    ## 435 435                    fBodyGyro-max()-Z         max()           
    ## 436 436                    fBodyGyro-min()-X         min()           
    ## 437 437                    fBodyGyro-min()-Y         min()           
    ## 438 438                    fBodyGyro-min()-Z         min()           
    ## 439 439                      fBodyGyro-sma()         sma()           
    ## 440 440                 fBodyGyro-energy()-X      energy()           
    ## 441 441                 fBodyGyro-energy()-Y      energy()           
    ## 442 442                 fBodyGyro-energy()-Z      energy()           
    ## 443 443                    fBodyGyro-iqr()-X         iqr()           
    ## 444 444                    fBodyGyro-iqr()-Y         iqr()           
    ## 445 445                    fBodyGyro-iqr()-Z         iqr()           
    ## 446 446                fBodyGyro-entropy()-X     entropy()           
    ## 447 447                fBodyGyro-entropy()-Y     entropy()           
    ## 448 448                fBodyGyro-entropy()-Z     entropy()           
    ## 449 449                fBodyGyro-maxInds()-X     maxInds()           
    ## 450 450                fBodyGyro-maxInds()-Y     maxInds()           
    ## 451 451                fBodyGyro-maxInds()-Z     maxInds()           
    ## 452 452               fBodyGyro-meanFreq()-X    meanFreq()           
    ## 453 453               fBodyGyro-meanFreq()-Y    meanFreq()           
    ## 454 454               fBodyGyro-meanFreq()-Z    meanFreq()           
    ## 455 455               fBodyGyro-skewness()-X    skewness()           
    ## 456 456               fBodyGyro-kurtosis()-X    kurtosis()           
    ## 457 457               fBodyGyro-skewness()-Y    skewness()           
    ## 458 458               fBodyGyro-kurtosis()-Y    kurtosis()           
    ## 459 459               fBodyGyro-skewness()-Z    skewness()           
    ## 460 460               fBodyGyro-kurtosis()-Z    kurtosis()           
    ## 461 461          fBodyGyro-bandsEnergy()-1,8 bandsEnergy()           
    ## 462 462         fBodyGyro-bandsEnergy()-9,16 bandsEnergy()           
    ## 463 463        fBodyGyro-bandsEnergy()-17,24 bandsEnergy()           
    ## 464 464        fBodyGyro-bandsEnergy()-25,32 bandsEnergy()           
    ## 465 465        fBodyGyro-bandsEnergy()-33,40 bandsEnergy()           
    ## 466 466        fBodyGyro-bandsEnergy()-41,48 bandsEnergy()           
    ## 467 467        fBodyGyro-bandsEnergy()-49,56 bandsEnergy()           
    ## 468 468        fBodyGyro-bandsEnergy()-57,64 bandsEnergy()           
    ## 469 469         fBodyGyro-bandsEnergy()-1,16 bandsEnergy()           
    ## 470 470        fBodyGyro-bandsEnergy()-17,32 bandsEnergy()           
    ## 471 471        fBodyGyro-bandsEnergy()-33,48 bandsEnergy()           
    ## 472 472        fBodyGyro-bandsEnergy()-49,64 bandsEnergy()           
    ## 473 473         fBodyGyro-bandsEnergy()-1,24 bandsEnergy()           
    ## 474 474        fBodyGyro-bandsEnergy()-25,48 bandsEnergy()           
    ## 475 475          fBodyGyro-bandsEnergy()-1,8 bandsEnergy()           
    ## 476 476         fBodyGyro-bandsEnergy()-9,16 bandsEnergy()           
    ## 477 477        fBodyGyro-bandsEnergy()-17,24 bandsEnergy()           
    ## 478 478        fBodyGyro-bandsEnergy()-25,32 bandsEnergy()           
    ## 479 479        fBodyGyro-bandsEnergy()-33,40 bandsEnergy()           
    ## 480 480        fBodyGyro-bandsEnergy()-41,48 bandsEnergy()           
    ## 481 481        fBodyGyro-bandsEnergy()-49,56 bandsEnergy()           
    ## 482 482        fBodyGyro-bandsEnergy()-57,64 bandsEnergy()           
    ## 483 483         fBodyGyro-bandsEnergy()-1,16 bandsEnergy()           
    ## 484 484        fBodyGyro-bandsEnergy()-17,32 bandsEnergy()           
    ## 485 485        fBodyGyro-bandsEnergy()-33,48 bandsEnergy()           
    ## 486 486        fBodyGyro-bandsEnergy()-49,64 bandsEnergy()           
    ## 487 487         fBodyGyro-bandsEnergy()-1,24 bandsEnergy()           
    ## 488 488        fBodyGyro-bandsEnergy()-25,48 bandsEnergy()           
    ## 489 489          fBodyGyro-bandsEnergy()-1,8 bandsEnergy()           
    ## 490 490         fBodyGyro-bandsEnergy()-9,16 bandsEnergy()           
    ## 491 491        fBodyGyro-bandsEnergy()-17,24 bandsEnergy()           
    ## 492 492        fBodyGyro-bandsEnergy()-25,32 bandsEnergy()           
    ## 493 493        fBodyGyro-bandsEnergy()-33,40 bandsEnergy()           
    ## 494 494        fBodyGyro-bandsEnergy()-41,48 bandsEnergy()           
    ## 495 495        fBodyGyro-bandsEnergy()-49,56 bandsEnergy()           
    ## 496 496        fBodyGyro-bandsEnergy()-57,64 bandsEnergy()           
    ## 497 497         fBodyGyro-bandsEnergy()-1,16 bandsEnergy()           
    ## 498 498        fBodyGyro-bandsEnergy()-17,32 bandsEnergy()           
    ## 499 499        fBodyGyro-bandsEnergy()-33,48 bandsEnergy()           
    ## 500 500        fBodyGyro-bandsEnergy()-49,64 bandsEnergy()           
    ## 501 501         fBodyGyro-bandsEnergy()-1,24 bandsEnergy()           
    ## 502 502        fBodyGyro-bandsEnergy()-25,48 bandsEnergy()           
    ## 503 503                   fBodyAccMag-mean()        mean()           
    ## 504 504                    fBodyAccMag-std()         std()           
    ## 505 505                    fBodyAccMag-mad()         mad()           
    ## 506 506                    fBodyAccMag-max()         max()           
    ## 507 507                    fBodyAccMag-min()         min()           
    ## 508 508                    fBodyAccMag-sma()         sma()           
    ## 509 509                 fBodyAccMag-energy()      energy()           
    ## 510 510                    fBodyAccMag-iqr()         iqr()           
    ## 511 511                fBodyAccMag-entropy()     entropy()           
    ## 512 512                fBodyAccMag-maxInds()     maxInds()           
    ## 513 513               fBodyAccMag-meanFreq()    meanFreq()           
    ## 514 514               fBodyAccMag-skewness()    skewness()           
    ## 515 515               fBodyAccMag-kurtosis()    kurtosis()           
    ## 516 516               fBodyAccJerkMag-mean()        mean()           
    ## 517 517                fBodyAccJerkMag-std()         std()           
    ## 518 518                fBodyAccJerkMag-mad()         mad()           
    ## 519 519                fBodyAccJerkMag-max()         max()           
    ## 520 520                fBodyAccJerkMag-min()         min()           
    ## 521 521                fBodyAccJerkMag-sma()         sma()           
    ## 522 522             fBodyAccJerkMag-energy()      energy()           
    ## 523 523                fBodyAccJerkMag-iqr()         iqr()           
    ## 524 524            fBodyAccJerkMag-entropy()     entropy()           
    ## 525 525            fBodyAccJerkMag-maxInds()     maxInds()           
    ## 526 526           fBodyAccJerkMag-meanFreq()    meanFreq()           
    ## 527 527           fBodyAccJerkMag-skewness()    skewness()           
    ## 528 528           fBodyAccJerkMag-kurtosis()    kurtosis()           
    ## 529 529                  fBodyGyroMag-mean()        mean()           
    ## 530 530                   fBodyGyroMag-std()         std()           
    ## 531 531                   fBodyGyroMag-mad()         mad()           
    ## 532 532                   fBodyGyroMag-max()         max()           
    ## 533 533                   fBodyGyroMag-min()         min()           
    ## 534 534                   fBodyGyroMag-sma()         sma()           
    ## 535 535                fBodyGyroMag-energy()      energy()           
    ## 536 536                   fBodyGyroMag-iqr()         iqr()           
    ## 537 537               fBodyGyroMag-entropy()     entropy()           
    ## 538 538               fBodyGyroMag-maxInds()     maxInds()           
    ## 539 539              fBodyGyroMag-meanFreq()    meanFreq()           
    ## 540 540              fBodyGyroMag-skewness()    skewness()           
    ## 541 541              fBodyGyroMag-kurtosis()    kurtosis()           
    ## 542 542              fBodyGyroJerkMag-mean()        mean()           
    ## 543 543               fBodyGyroJerkMag-std()         std()           
    ## 544 544               fBodyGyroJerkMag-mad()         mad()           
    ## 545 545               fBodyGyroJerkMag-max()         max()           
    ## 546 546               fBodyGyroJerkMag-min()         min()           
    ## 547 547               fBodyGyroJerkMag-sma()         sma()           
    ## 548 548            fBodyGyroJerkMag-energy()      energy()           
    ## 549 549               fBodyGyroJerkMag-iqr()         iqr()           
    ## 550 550           fBodyGyroJerkMag-entropy()     entropy()           
    ## 551 551           fBodyGyroJerkMag-maxInds()     maxInds()           
    ## 552 552          fBodyGyroJerkMag-meanFreq()    meanFreq()           
    ## 553 553          fBodyGyroJerkMag-skewness()    skewness()           
    ## 554 554          fBodyGyroJerkMag-kurtosis()    kurtosis()           
    ## 555 555          angle(tBodyAccMean,gravity)       angle()           
    ## 556 556  angle(tBodyAccJerkMean,gravityMean)       angle()           
    ## 557 557     angle(tBodyGyroMean,gravityMean)       angle()           
    ## 558 558 angle(tBodyGyroJerkMean,gravityMean)       angle()           
    ## 559 559                 angle(X,gravityMean)       angle()           
    ## 560 560                 angle(Y,gravityMean)       angle()           
    ## 561 561                 angle(Z,gravityMean)       angle()           
    ##     bandsEnergySep2 angleSep2
    ## 1                            
    ## 2                            
    ## 3                            
    ## 4                            
    ## 5                            
    ## 6                            
    ## 7                            
    ## 8                            
    ## 9                            
    ## 10                           
    ## 11                           
    ## 12                           
    ## 13                           
    ## 14                           
    ## 15                           
    ## 16                           
    ## 17                           
    ## 18                           
    ## 19                           
    ## 20                           
    ## 21                           
    ## 22                           
    ## 23                           
    ## 24                           
    ## 25                           
    ## 26                           
    ## 27                           
    ## 28                           
    ## 29                           
    ## 30                           
    ## 31                           
    ## 32                           
    ## 33                           
    ## 34                           
    ## 35                           
    ## 36                           
    ## 37                           
    ## 38                           
    ## 39                           
    ## 40                           
    ## 41                           
    ## 42                           
    ## 43                           
    ## 44                           
    ## 45                           
    ## 46                           
    ## 47                           
    ## 48                           
    ## 49                           
    ## 50                           
    ## 51                           
    ## 52                           
    ## 53                           
    ## 54                           
    ## 55                           
    ## 56                           
    ## 57                           
    ## 58                           
    ## 59                           
    ## 60                           
    ## 61                           
    ## 62                           
    ## 63                           
    ## 64                           
    ## 65                           
    ## 66                           
    ## 67                           
    ## 68                           
    ## 69                           
    ## 70                           
    ## 71                           
    ## 72                           
    ## 73                           
    ## 74                           
    ## 75                           
    ## 76                           
    ## 77                           
    ## 78                           
    ## 79                           
    ## 80                           
    ## 81                           
    ## 82                           
    ## 83                           
    ## 84                           
    ## 85                           
    ## 86                           
    ## 87                           
    ## 88                           
    ## 89                           
    ## 90                           
    ## 91                           
    ## 92                           
    ## 93                           
    ## 94                           
    ## 95                           
    ## 96                           
    ## 97                           
    ## 98                           
    ## 99                           
    ## 100                          
    ## 101                          
    ## 102                          
    ## 103                          
    ## 104                          
    ## 105                          
    ## 106                          
    ## 107                          
    ## 108                          
    ## 109                          
    ## 110                          
    ## 111                          
    ## 112                          
    ## 113                          
    ## 114                          
    ## 115                          
    ## 116                          
    ## 117                          
    ## 118                          
    ## 119                          
    ## 120                          
    ## 121                          
    ## 122                          
    ## 123                          
    ## 124                          
    ## 125                          
    ## 126                          
    ## 127                          
    ## 128                          
    ## 129                          
    ## 130                          
    ## 131                          
    ## 132                          
    ## 133                          
    ## 134                          
    ## 135                          
    ## 136                          
    ## 137                          
    ## 138                          
    ## 139                          
    ## 140                          
    ## 141                          
    ## 142                          
    ## 143                          
    ## 144                          
    ## 145                          
    ## 146                          
    ## 147                          
    ## 148                          
    ## 149                          
    ## 150                          
    ## 151                          
    ## 152                          
    ## 153                          
    ## 154                          
    ## 155                          
    ## 156                          
    ## 157                          
    ## 158                          
    ## 159                          
    ## 160                          
    ## 161                          
    ## 162                          
    ## 163                          
    ## 164                          
    ## 165                          
    ## 166                          
    ## 167                          
    ## 168                          
    ## 169                          
    ## 170                          
    ## 171                          
    ## 172                          
    ## 173                          
    ## 174                          
    ## 175                          
    ## 176                          
    ## 177                          
    ## 178                          
    ## 179                          
    ## 180                          
    ## 181                          
    ## 182                          
    ## 183                          
    ## 184                          
    ## 185                          
    ## 186                          
    ## 187                          
    ## 188                          
    ## 189                          
    ## 190                          
    ## 191                          
    ## 192                          
    ## 193                          
    ## 194                          
    ## 195                          
    ## 196                          
    ## 197                          
    ## 198                          
    ## 199                          
    ## 200                          
    ## 201                          
    ## 202                          
    ## 203                          
    ## 204                          
    ## 205                          
    ## 206                          
    ## 207                          
    ## 208                          
    ## 209                          
    ## 210                          
    ## 211                          
    ## 212                          
    ## 213                          
    ## 214                          
    ## 215                          
    ## 216                          
    ## 217                          
    ## 218                          
    ## 219                          
    ## 220                          
    ## 221                          
    ## 222                          
    ## 223                          
    ## 224                          
    ## 225                          
    ## 226                          
    ## 227                          
    ## 228                          
    ## 229                          
    ## 230                          
    ## 231                          
    ## 232                          
    ## 233                          
    ## 234                          
    ## 235                          
    ## 236                          
    ## 237                          
    ## 238                          
    ## 239                          
    ## 240                          
    ## 241                          
    ## 242                          
    ## 243                          
    ## 244                          
    ## 245                          
    ## 246                          
    ## 247                          
    ## 248                          
    ## 249                          
    ## 250                          
    ## 251                          
    ## 252                          
    ## 253                          
    ## 254                          
    ## 255                          
    ## 256                          
    ## 257                          
    ## 258                          
    ## 259                          
    ## 260                          
    ## 261                          
    ## 262                          
    ## 263                          
    ## 264                          
    ## 265                          
    ## 266                          
    ## 267                          
    ## 268                          
    ## 269                          
    ## 270                          
    ## 271                          
    ## 272                          
    ## 273                          
    ## 274                          
    ## 275                          
    ## 276                          
    ## 277                          
    ## 278                          
    ## 279                          
    ## 280                          
    ## 281                          
    ## 282                          
    ## 283                          
    ## 284                          
    ## 285                          
    ## 286                          
    ## 287                          
    ## 288                          
    ## 289                          
    ## 290                          
    ## 291                          
    ## 292                          
    ## 293                          
    ## 294                          
    ## 295                          
    ## 296                          
    ## 297                          
    ## 298                          
    ## 299                          
    ## 300                          
    ## 301                          
    ## 302                          
    ## 303               ,          
    ## 304               ,          
    ## 305               ,          
    ## 306               ,          
    ## 307               ,          
    ## 308               ,          
    ## 309               ,          
    ## 310               ,          
    ## 311               ,          
    ## 312               ,          
    ## 313               ,          
    ## 314               ,          
    ## 315               ,          
    ## 316               ,          
    ## 317               ,          
    ## 318               ,          
    ## 319               ,          
    ## 320               ,          
    ## 321               ,          
    ## 322               ,          
    ## 323               ,          
    ## 324               ,          
    ## 325               ,          
    ## 326               ,          
    ## 327               ,          
    ## 328               ,          
    ## 329               ,          
    ## 330               ,          
    ## 331               ,          
    ## 332               ,          
    ## 333               ,          
    ## 334               ,          
    ## 335               ,          
    ## 336               ,          
    ## 337               ,          
    ## 338               ,          
    ## 339               ,          
    ## 340               ,          
    ## 341               ,          
    ## 342               ,          
    ## 343               ,          
    ## 344               ,          
    ## 345                          
    ## 346                          
    ## 347                          
    ## 348                          
    ## 349                          
    ## 350                          
    ## 351                          
    ## 352                          
    ## 353                          
    ## 354                          
    ## 355                          
    ## 356                          
    ## 357                          
    ## 358                          
    ## 359                          
    ## 360                          
    ## 361                          
    ## 362                          
    ## 363                          
    ## 364                          
    ## 365                          
    ## 366                          
    ## 367                          
    ## 368                          
    ## 369                          
    ## 370                          
    ## 371                          
    ## 372                          
    ## 373                          
    ## 374                          
    ## 375                          
    ## 376                          
    ## 377                          
    ## 378                          
    ## 379                          
    ## 380                          
    ## 381                          
    ## 382               ,          
    ## 383               ,          
    ## 384               ,          
    ## 385               ,          
    ## 386               ,          
    ## 387               ,          
    ## 388               ,          
    ## 389               ,          
    ## 390               ,          
    ## 391               ,          
    ## 392               ,          
    ## 393               ,          
    ## 394               ,          
    ## 395               ,          
    ## 396               ,          
    ## 397               ,          
    ## 398               ,          
    ## 399               ,          
    ## 400               ,          
    ## 401               ,          
    ## 402               ,          
    ## 403               ,          
    ## 404               ,          
    ## 405               ,          
    ## 406               ,          
    ## 407               ,          
    ## 408               ,          
    ## 409               ,          
    ## 410               ,          
    ## 411               ,          
    ## 412               ,          
    ## 413               ,          
    ## 414               ,          
    ## 415               ,          
    ## 416               ,          
    ## 417               ,          
    ## 418               ,          
    ## 419               ,          
    ## 420               ,          
    ## 421               ,          
    ## 422               ,          
    ## 423               ,          
    ## 424                          
    ## 425                          
    ## 426                          
    ## 427                          
    ## 428                          
    ## 429                          
    ## 430                          
    ## 431                          
    ## 432                          
    ## 433                          
    ## 434                          
    ## 435                          
    ## 436                          
    ## 437                          
    ## 438                          
    ## 439                          
    ## 440                          
    ## 441                          
    ## 442                          
    ## 443                          
    ## 444                          
    ## 445                          
    ## 446                          
    ## 447                          
    ## 448                          
    ## 449                          
    ## 450                          
    ## 451                          
    ## 452                          
    ## 453                          
    ## 454                          
    ## 455                          
    ## 456                          
    ## 457                          
    ## 458                          
    ## 459                          
    ## 460                          
    ## 461               ,          
    ## 462               ,          
    ## 463               ,          
    ## 464               ,          
    ## 465               ,          
    ## 466               ,          
    ## 467               ,          
    ## 468               ,          
    ## 469               ,          
    ## 470               ,          
    ## 471               ,          
    ## 472               ,          
    ## 473               ,          
    ## 474               ,          
    ## 475               ,          
    ## 476               ,          
    ## 477               ,          
    ## 478               ,          
    ## 479               ,          
    ## 480               ,          
    ## 481               ,          
    ## 482               ,          
    ## 483               ,          
    ## 484               ,          
    ## 485               ,          
    ## 486               ,          
    ## 487               ,          
    ## 488               ,          
    ## 489               ,          
    ## 490               ,          
    ## 491               ,          
    ## 492               ,          
    ## 493               ,          
    ## 494               ,          
    ## 495               ,          
    ## 496               ,          
    ## 497               ,          
    ## 498               ,          
    ## 499               ,          
    ## 500               ,          
    ## 501               ,          
    ## 502               ,          
    ## 503                          
    ## 504                          
    ## 505                          
    ## 506                          
    ## 507                          
    ## 508                          
    ## 509                          
    ## 510                          
    ## 511                          
    ## 512                          
    ## 513                          
    ## 514                          
    ## 515                          
    ## 516                          
    ## 517                          
    ## 518                          
    ## 519                          
    ## 520                          
    ## 521                          
    ## 522                          
    ## 523                          
    ## 524                          
    ## 525                          
    ## 526                          
    ## 527                          
    ## 528                          
    ## 529                          
    ## 530                          
    ## 531                          
    ## 532                          
    ## 533                          
    ## 534                          
    ## 535                          
    ## 536                          
    ## 537                          
    ## 538                          
    ## 539                          
    ## 540                          
    ## 541                          
    ## 542                          
    ## 543                          
    ## 544                          
    ## 545                          
    ## 546                          
    ## 547                          
    ## 548                          
    ## 549                          
    ## 550                          
    ## 551                          
    ## 552                          
    ## 553                          
    ## 554                          
    ## 555                         ,
    ## 556                         ,
    ## 557                         ,
    ## 558                         ,
    ## 559                         ,
    ## 560                         ,
    ## 561                         ,
    ##                                                          formula
    ## 1                                               mean(tBodyAcc-X)
    ## 2                                               mean(tBodyAcc-Y)
    ## 3                                               mean(tBodyAcc-Z)
    ## 4                                                std(tBodyAcc-X)
    ## 5                                                std(tBodyAcc-Y)
    ## 6                                                std(tBodyAcc-Z)
    ## 7                                                mad(tBodyAcc-X)
    ## 8                                                mad(tBodyAcc-Y)
    ## 9                                                mad(tBodyAcc-Z)
    ## 10                                               max(tBodyAcc-X)
    ## 11                                               max(tBodyAcc-Y)
    ## 12                                               max(tBodyAcc-Z)
    ## 13                                               min(tBodyAcc-X)
    ## 14                                               min(tBodyAcc-Y)
    ## 15                                               min(tBodyAcc-Z)
    ## 16                           sma(tBodyAcc-XtBodyAcc-YtBodyAcc-Z)
    ## 17                                            energy(tBodyAcc-X)
    ## 18                                            energy(tBodyAcc-Y)
    ## 19                                            energy(tBodyAcc-Z)
    ## 20                                               iqr(tBodyAcc-X)
    ## 21                                               iqr(tBodyAcc-Y)
    ## 22                                               iqr(tBodyAcc-Z)
    ## 23                                           entropy(tBodyAcc-X)
    ## 24                                           entropy(tBodyAcc-Y)
    ## 25                                           entropy(tBodyAcc-Z)
    ## 26                                         arCoeff(tBodyAcc-X,1)
    ## 27                                         arCoeff(tBodyAcc-X,2)
    ## 28                                         arCoeff(tBodyAcc-X,3)
    ## 29                                         arCoeff(tBodyAcc-X,4)
    ## 30                                         arCoeff(tBodyAcc-Y,1)
    ## 31                                         arCoeff(tBodyAcc-Y,2)
    ## 32                                         arCoeff(tBodyAcc-Y,3)
    ## 33                                         arCoeff(tBodyAcc-Y,4)
    ## 34                                         arCoeff(,1tBodyAcc-Z)
    ## 35                                         arCoeff(,2tBodyAcc-Z)
    ## 36                                         arCoeff(,3tBodyAcc-Z)
    ## 37                                         arCoeff(,4tBodyAcc-Z)
    ## 38                             correlation(tBodyAcc-XtBodyAcc-Y)
    ## 39                             correlation(tBodyAcc-XtBodyAcc-Z)
    ## 40                             correlation(tBodyAcc-YtBodyAcc-Z)
    ## 41                                           mean(tGravityAcc-X)
    ## 42                                           mean(tGravityAcc-Y)
    ## 43                                           mean(tGravityAcc-Z)
    ## 44                                            std(tGravityAcc-X)
    ## 45                                            std(tGravityAcc-Y)
    ## 46                                            std(tGravityAcc-Z)
    ## 47                                            mad(tGravityAcc-X)
    ## 48                                            mad(tGravityAcc-Y)
    ## 49                                            mad(tGravityAcc-Z)
    ## 50                                            max(tGravityAcc-X)
    ## 51                                            max(tGravityAcc-Y)
    ## 52                                            max(tGravityAcc-Z)
    ## 53                                            min(tGravityAcc-X)
    ## 54                                            min(tGravityAcc-Y)
    ## 55                                            min(tGravityAcc-Z)
    ## 56                  sma(tGravityAcc-XtGravityAcc-YtGravityAcc-Z)
    ## 57                                         energy(tGravityAcc-X)
    ## 58                                         energy(tGravityAcc-Y)
    ## 59                                         energy(tGravityAcc-Z)
    ## 60                                            iqr(tGravityAcc-X)
    ## 61                                            iqr(tGravityAcc-Y)
    ## 62                                            iqr(tGravityAcc-Z)
    ## 63                                        entropy(tGravityAcc-X)
    ## 64                                        entropy(tGravityAcc-Y)
    ## 65                                        entropy(tGravityAcc-Z)
    ## 66                                      arCoeff(tGravityAcc-X,1)
    ## 67                                      arCoeff(tGravityAcc-X,2)
    ## 68                                      arCoeff(tGravityAcc-X,3)
    ## 69                                      arCoeff(tGravityAcc-X,4)
    ## 70                                      arCoeff(tGravityAcc-Y,1)
    ## 71                                      arCoeff(tGravityAcc-Y,2)
    ## 72                                      arCoeff(tGravityAcc-Y,3)
    ## 73                                      arCoeff(tGravityAcc-Y,4)
    ## 74                                      arCoeff(,1tGravityAcc-Z)
    ## 75                                      arCoeff(,2tGravityAcc-Z)
    ## 76                                      arCoeff(,3tGravityAcc-Z)
    ## 77                                      arCoeff(,4tGravityAcc-Z)
    ## 78                       correlation(tGravityAcc-XtGravityAcc-Y)
    ## 79                       correlation(tGravityAcc-XtGravityAcc-Z)
    ## 80                       correlation(tGravityAcc-YtGravityAcc-Z)
    ## 81                                          mean(tBodyAccJerk-X)
    ## 82                                          mean(tBodyAccJerk-Y)
    ## 83                                          mean(tBodyAccJerk-Z)
    ## 84                                           std(tBodyAccJerk-X)
    ## 85                                           std(tBodyAccJerk-Y)
    ## 86                                           std(tBodyAccJerk-Z)
    ## 87                                           mad(tBodyAccJerk-X)
    ## 88                                           mad(tBodyAccJerk-Y)
    ## 89                                           mad(tBodyAccJerk-Z)
    ## 90                                           max(tBodyAccJerk-X)
    ## 91                                           max(tBodyAccJerk-Y)
    ## 92                                           max(tBodyAccJerk-Z)
    ## 93                                           min(tBodyAccJerk-X)
    ## 94                                           min(tBodyAccJerk-Y)
    ## 95                                           min(tBodyAccJerk-Z)
    ## 96               sma(tBodyAccJerk-XtBodyAccJerk-YtBodyAccJerk-Z)
    ## 97                                        energy(tBodyAccJerk-X)
    ## 98                                        energy(tBodyAccJerk-Y)
    ## 99                                        energy(tBodyAccJerk-Z)
    ## 100                                          iqr(tBodyAccJerk-X)
    ## 101                                          iqr(tBodyAccJerk-Y)
    ## 102                                          iqr(tBodyAccJerk-Z)
    ## 103                                      entropy(tBodyAccJerk-X)
    ## 104                                      entropy(tBodyAccJerk-Y)
    ## 105                                      entropy(tBodyAccJerk-Z)
    ## 106                                    arCoeff(tBodyAccJerk-X,1)
    ## 107                                    arCoeff(tBodyAccJerk-X,2)
    ## 108                                    arCoeff(tBodyAccJerk-X,3)
    ## 109                                    arCoeff(tBodyAccJerk-X,4)
    ## 110                                    arCoeff(tBodyAccJerk-Y,1)
    ## 111                                    arCoeff(tBodyAccJerk-Y,2)
    ## 112                                    arCoeff(tBodyAccJerk-Y,3)
    ## 113                                    arCoeff(tBodyAccJerk-Y,4)
    ## 114                                    arCoeff(,1tBodyAccJerk-Z)
    ## 115                                    arCoeff(,2tBodyAccJerk-Z)
    ## 116                                    arCoeff(,3tBodyAccJerk-Z)
    ## 117                                    arCoeff(,4tBodyAccJerk-Z)
    ## 118                    correlation(tBodyAccJerk-XtBodyAccJerk-Y)
    ## 119                    correlation(tBodyAccJerk-XtBodyAccJerk-Z)
    ## 120                    correlation(tBodyAccJerk-YtBodyAccJerk-Z)
    ## 121                                            mean(tBodyGyro-X)
    ## 122                                            mean(tBodyGyro-Y)
    ## 123                                            mean(tBodyGyro-Z)
    ## 124                                             std(tBodyGyro-X)
    ## 125                                             std(tBodyGyro-Y)
    ## 126                                             std(tBodyGyro-Z)
    ## 127                                             mad(tBodyGyro-X)
    ## 128                                             mad(tBodyGyro-Y)
    ## 129                                             mad(tBodyGyro-Z)
    ## 130                                             max(tBodyGyro-X)
    ## 131                                             max(tBodyGyro-Y)
    ## 132                                             max(tBodyGyro-Z)
    ## 133                                             min(tBodyGyro-X)
    ## 134                                             min(tBodyGyro-Y)
    ## 135                                             min(tBodyGyro-Z)
    ## 136                       sma(tBodyGyro-XtBodyGyro-YtBodyGyro-Z)
    ## 137                                          energy(tBodyGyro-X)
    ## 138                                          energy(tBodyGyro-Y)
    ## 139                                          energy(tBodyGyro-Z)
    ## 140                                             iqr(tBodyGyro-X)
    ## 141                                             iqr(tBodyGyro-Y)
    ## 142                                             iqr(tBodyGyro-Z)
    ## 143                                         entropy(tBodyGyro-X)
    ## 144                                         entropy(tBodyGyro-Y)
    ## 145                                         entropy(tBodyGyro-Z)
    ## 146                                       arCoeff(tBodyGyro-X,1)
    ## 147                                       arCoeff(tBodyGyro-X,2)
    ## 148                                       arCoeff(tBodyGyro-X,3)
    ## 149                                       arCoeff(tBodyGyro-X,4)
    ## 150                                       arCoeff(tBodyGyro-Y,1)
    ## 151                                       arCoeff(tBodyGyro-Y,2)
    ## 152                                       arCoeff(tBodyGyro-Y,3)
    ## 153                                       arCoeff(tBodyGyro-Y,4)
    ## 154                                       arCoeff(,1tBodyGyro-Z)
    ## 155                                       arCoeff(,2tBodyGyro-Z)
    ## 156                                       arCoeff(,3tBodyGyro-Z)
    ## 157                                       arCoeff(,4tBodyGyro-Z)
    ## 158                          correlation(tBodyGyro-XtBodyGyro-Y)
    ## 159                          correlation(tBodyGyro-XtBodyGyro-Z)
    ## 160                          correlation(tBodyGyro-YtBodyGyro-Z)
    ## 161                                        mean(tBodyGyroJerk-X)
    ## 162                                        mean(tBodyGyroJerk-Y)
    ## 163                                        mean(tBodyGyroJerk-Z)
    ## 164                                         std(tBodyGyroJerk-X)
    ## 165                                         std(tBodyGyroJerk-Y)
    ## 166                                         std(tBodyGyroJerk-Z)
    ## 167                                         mad(tBodyGyroJerk-X)
    ## 168                                         mad(tBodyGyroJerk-Y)
    ## 169                                         mad(tBodyGyroJerk-Z)
    ## 170                                         max(tBodyGyroJerk-X)
    ## 171                                         max(tBodyGyroJerk-Y)
    ## 172                                         max(tBodyGyroJerk-Z)
    ## 173                                         min(tBodyGyroJerk-X)
    ## 174                                         min(tBodyGyroJerk-Y)
    ## 175                                         min(tBodyGyroJerk-Z)
    ## 176           sma(tBodyGyroJerk-XtBodyGyroJerk-YtBodyGyroJerk-Z)
    ## 177                                      energy(tBodyGyroJerk-X)
    ## 178                                      energy(tBodyGyroJerk-Y)
    ## 179                                      energy(tBodyGyroJerk-Z)
    ## 180                                         iqr(tBodyGyroJerk-X)
    ## 181                                         iqr(tBodyGyroJerk-Y)
    ## 182                                         iqr(tBodyGyroJerk-Z)
    ## 183                                     entropy(tBodyGyroJerk-X)
    ## 184                                     entropy(tBodyGyroJerk-Y)
    ## 185                                     entropy(tBodyGyroJerk-Z)
    ## 186                                   arCoeff(tBodyGyroJerk-X,1)
    ## 187                                   arCoeff(tBodyGyroJerk-X,2)
    ## 188                                   arCoeff(tBodyGyroJerk-X,3)
    ## 189                                   arCoeff(tBodyGyroJerk-X,4)
    ## 190                                   arCoeff(tBodyGyroJerk-Y,1)
    ## 191                                   arCoeff(tBodyGyroJerk-Y,2)
    ## 192                                   arCoeff(tBodyGyroJerk-Y,3)
    ## 193                                   arCoeff(tBodyGyroJerk-Y,4)
    ## 194                                   arCoeff(,1tBodyGyroJerk-Z)
    ## 195                                   arCoeff(,2tBodyGyroJerk-Z)
    ## 196                                   arCoeff(,3tBodyGyroJerk-Z)
    ## 197                                   arCoeff(,4tBodyGyroJerk-Z)
    ## 198                  correlation(tBodyGyroJerk-XtBodyGyroJerk-Y)
    ## 199                  correlation(tBodyGyroJerk-XtBodyGyroJerk-Z)
    ## 200                  correlation(tBodyGyroJerk-YtBodyGyroJerk-Z)
    ## 201                                            mean(tBodyAccMag)
    ## 202                                             std(tBodyAccMag)
    ## 203                                             mad(tBodyAccMag)
    ## 204                                             max(tBodyAccMag)
    ## 205                                             min(tBodyAccMag)
    ## 206                                             sma(tBodyAccMag)
    ## 207                                          energy(tBodyAccMag)
    ## 208                                             iqr(tBodyAccMag)
    ## 209                                         entropy(tBodyAccMag)
    ## 210                                        arCoeff(tBodyAccMag1)
    ## 211                                        arCoeff(tBodyAccMag2)
    ## 212                                        arCoeff(tBodyAccMag3)
    ## 213                                        arCoeff(tBodyAccMag4)
    ## 214                                         mean(tGravityAccMag)
    ## 215                                          std(tGravityAccMag)
    ## 216                                          mad(tGravityAccMag)
    ## 217                                          max(tGravityAccMag)
    ## 218                                          min(tGravityAccMag)
    ## 219                                          sma(tGravityAccMag)
    ## 220                                       energy(tGravityAccMag)
    ## 221                                          iqr(tGravityAccMag)
    ## 222                                      entropy(tGravityAccMag)
    ## 223                                     arCoeff(tGravityAccMag1)
    ## 224                                     arCoeff(tGravityAccMag2)
    ## 225                                     arCoeff(tGravityAccMag3)
    ## 226                                     arCoeff(tGravityAccMag4)
    ## 227                                        mean(tBodyAccJerkMag)
    ## 228                                         std(tBodyAccJerkMag)
    ## 229                                         mad(tBodyAccJerkMag)
    ## 230                                         max(tBodyAccJerkMag)
    ## 231                                         min(tBodyAccJerkMag)
    ## 232                                         sma(tBodyAccJerkMag)
    ## 233                                      energy(tBodyAccJerkMag)
    ## 234                                         iqr(tBodyAccJerkMag)
    ## 235                                     entropy(tBodyAccJerkMag)
    ## 236                                    arCoeff(tBodyAccJerkMag1)
    ## 237                                    arCoeff(tBodyAccJerkMag2)
    ## 238                                    arCoeff(tBodyAccJerkMag3)
    ## 239                                    arCoeff(tBodyAccJerkMag4)
    ## 240                                           mean(tBodyGyroMag)
    ## 241                                            std(tBodyGyroMag)
    ## 242                                            mad(tBodyGyroMag)
    ## 243                                            max(tBodyGyroMag)
    ## 244                                            min(tBodyGyroMag)
    ## 245                                            sma(tBodyGyroMag)
    ## 246                                         energy(tBodyGyroMag)
    ## 247                                            iqr(tBodyGyroMag)
    ## 248                                        entropy(tBodyGyroMag)
    ## 249                                       arCoeff(tBodyGyroMag1)
    ## 250                                       arCoeff(tBodyGyroMag2)
    ## 251                                       arCoeff(tBodyGyroMag3)
    ## 252                                       arCoeff(tBodyGyroMag4)
    ## 253                                       mean(tBodyGyroJerkMag)
    ## 254                                        std(tBodyGyroJerkMag)
    ## 255                                        mad(tBodyGyroJerkMag)
    ## 256                                        max(tBodyGyroJerkMag)
    ## 257                                        min(tBodyGyroJerkMag)
    ## 258                                        sma(tBodyGyroJerkMag)
    ## 259                                     energy(tBodyGyroJerkMag)
    ## 260                                        iqr(tBodyGyroJerkMag)
    ## 261                                    entropy(tBodyGyroJerkMag)
    ## 262                                   arCoeff(tBodyGyroJerkMag1)
    ## 263                                   arCoeff(tBodyGyroJerkMag2)
    ## 264                                   arCoeff(tBodyGyroJerkMag3)
    ## 265                                   arCoeff(tBodyGyroJerkMag4)
    ## 266                                             mean(fBodyAcc-X)
    ## 267                                             mean(fBodyAcc-Y)
    ## 268                                             mean(fBodyAcc-Z)
    ## 269                                              std(fBodyAcc-X)
    ## 270                                              std(fBodyAcc-Y)
    ## 271                                              std(fBodyAcc-Z)
    ## 272                                              mad(fBodyAcc-X)
    ## 273                                              mad(fBodyAcc-Y)
    ## 274                                              mad(fBodyAcc-Z)
    ## 275                                              max(fBodyAcc-X)
    ## 276                                              max(fBodyAcc-Y)
    ## 277                                              max(fBodyAcc-Z)
    ## 278                                              min(fBodyAcc-X)
    ## 279                                              min(fBodyAcc-Y)
    ## 280                                              min(fBodyAcc-Z)
    ## 281                          sma(fBodyAcc-XfBodyAcc-YfBodyAcc-Z)
    ## 282                                           energy(fBodyAcc-X)
    ## 283                                           energy(fBodyAcc-Y)
    ## 284                                           energy(fBodyAcc-Z)
    ## 285                                              iqr(fBodyAcc-X)
    ## 286                                              iqr(fBodyAcc-Y)
    ## 287                                              iqr(fBodyAcc-Z)
    ## 288                                          entropy(fBodyAcc-X)
    ## 289                                          entropy(fBodyAcc-Y)
    ## 290                                          entropy(fBodyAcc-Z)
    ## 291                                          maxInds(fBodyAcc-X)
    ## 292                                          maxInds(fBodyAcc-Y)
    ## 293                                          maxInds(fBodyAcc-Z)
    ## 294                                         meanFreq(fBodyAcc-X)
    ## 295                                         meanFreq(fBodyAcc-Y)
    ## 296                                         meanFreq(fBodyAcc-Z)
    ## 297                                         skewness(fBodyAcc-X)
    ## 298                                         kurtosis(fBodyAcc-X)
    ## 299                                         skewness(fBodyAcc-Y)
    ## 300                                         kurtosis(fBodyAcc-Y)
    ## 301                                         skewness(fBodyAcc-Z)
    ## 302                                         kurtosis(fBodyAcc-Z)
    ## 303               bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z1,8)
    ## 304              bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z9,16)
    ## 305             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z17,24)
    ## 306             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z25,32)
    ## 307             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z33,40)
    ## 308             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z41,48)
    ## 309             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z49,56)
    ## 310             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z57,64)
    ## 311              bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z1,16)
    ## 312             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z17,32)
    ## 313             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z33,48)
    ## 314             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z49,64)
    ## 315              bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z1,24)
    ## 316             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z25,48)
    ## 317               bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z1,8)
    ## 318              bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z9,16)
    ## 319             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z17,24)
    ## 320             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z25,32)
    ## 321             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z33,40)
    ## 322             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z41,48)
    ## 323             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z49,56)
    ## 324             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z57,64)
    ## 325              bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z1,16)
    ## 326             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z17,32)
    ## 327             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z33,48)
    ## 328             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z49,64)
    ## 329              bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z1,24)
    ## 330             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z25,48)
    ## 331               bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z1,8)
    ## 332              bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z9,16)
    ## 333             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z17,24)
    ## 334             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z25,32)
    ## 335             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z33,40)
    ## 336             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z41,48)
    ## 337             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z49,56)
    ## 338             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z57,64)
    ## 339              bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z1,16)
    ## 340             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z17,32)
    ## 341             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z33,48)
    ## 342             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z49,64)
    ## 343              bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z1,24)
    ## 344             bandsEnergy(fBodyAcc-XfBodyAcc-YfBodyAcc-Z25,48)
    ## 345                                         mean(fBodyAccJerk-X)
    ## 346                                         mean(fBodyAccJerk-Y)
    ## 347                                         mean(fBodyAccJerk-Z)
    ## 348                                          std(fBodyAccJerk-X)
    ## 349                                          std(fBodyAccJerk-Y)
    ## 350                                          std(fBodyAccJerk-Z)
    ## 351                                          mad(fBodyAccJerk-X)
    ## 352                                          mad(fBodyAccJerk-Y)
    ## 353                                          mad(fBodyAccJerk-Z)
    ## 354                                          max(fBodyAccJerk-X)
    ## 355                                          max(fBodyAccJerk-Y)
    ## 356                                          max(fBodyAccJerk-Z)
    ## 357                                          min(fBodyAccJerk-X)
    ## 358                                          min(fBodyAccJerk-Y)
    ## 359                                          min(fBodyAccJerk-Z)
    ## 360              sma(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z)
    ## 361                                       energy(fBodyAccJerk-X)
    ## 362                                       energy(fBodyAccJerk-Y)
    ## 363                                       energy(fBodyAccJerk-Z)
    ## 364                                          iqr(fBodyAccJerk-X)
    ## 365                                          iqr(fBodyAccJerk-Y)
    ## 366                                          iqr(fBodyAccJerk-Z)
    ## 367                                      entropy(fBodyAccJerk-X)
    ## 368                                      entropy(fBodyAccJerk-Y)
    ## 369                                      entropy(fBodyAccJerk-Z)
    ## 370                                      maxInds(fBodyAccJerk-X)
    ## 371                                      maxInds(fBodyAccJerk-Y)
    ## 372                                      maxInds(fBodyAccJerk-Z)
    ## 373                                     meanFreq(fBodyAccJerk-X)
    ## 374                                     meanFreq(fBodyAccJerk-Y)
    ## 375                                     meanFreq(fBodyAccJerk-Z)
    ## 376                                     skewness(fBodyAccJerk-X)
    ## 377                                     kurtosis(fBodyAccJerk-X)
    ## 378                                     skewness(fBodyAccJerk-Y)
    ## 379                                     kurtosis(fBodyAccJerk-Y)
    ## 380                                     skewness(fBodyAccJerk-Z)
    ## 381                                     kurtosis(fBodyAccJerk-Z)
    ## 382   bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z1,8)
    ## 383  bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z9,16)
    ## 384 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z17,24)
    ## 385 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z25,32)
    ## 386 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z33,40)
    ## 387 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z41,48)
    ## 388 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z49,56)
    ## 389 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z57,64)
    ## 390  bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z1,16)
    ## 391 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z17,32)
    ## 392 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z33,48)
    ## 393 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z49,64)
    ## 394  bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z1,24)
    ## 395 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z25,48)
    ## 396   bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z1,8)
    ## 397  bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z9,16)
    ## 398 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z17,24)
    ## 399 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z25,32)
    ## 400 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z33,40)
    ## 401 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z41,48)
    ## 402 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z49,56)
    ## 403 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z57,64)
    ## 404  bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z1,16)
    ## 405 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z17,32)
    ## 406 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z33,48)
    ## 407 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z49,64)
    ## 408  bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z1,24)
    ## 409 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z25,48)
    ## 410   bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z1,8)
    ## 411  bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z9,16)
    ## 412 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z17,24)
    ## 413 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z25,32)
    ## 414 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z33,40)
    ## 415 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z41,48)
    ## 416 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z49,56)
    ## 417 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z57,64)
    ## 418  bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z1,16)
    ## 419 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z17,32)
    ## 420 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z33,48)
    ## 421 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z49,64)
    ## 422  bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z1,24)
    ## 423 bandsEnergy(fBodyAccJerk-XfBodyAccJerk-YfBodyAccJerk-Z25,48)
    ## 424                                            mean(fBodyGyro-X)
    ## 425                                            mean(fBodyGyro-Y)
    ## 426                                            mean(fBodyGyro-Z)
    ## 427                                             std(fBodyGyro-X)
    ## 428                                             std(fBodyGyro-Y)
    ## 429                                             std(fBodyGyro-Z)
    ## 430                                             mad(fBodyGyro-X)
    ## 431                                             mad(fBodyGyro-Y)
    ## 432                                             mad(fBodyGyro-Z)
    ## 433                                             max(fBodyGyro-X)
    ## 434                                             max(fBodyGyro-Y)
    ## 435                                             max(fBodyGyro-Z)
    ## 436                                             min(fBodyGyro-X)
    ## 437                                             min(fBodyGyro-Y)
    ## 438                                             min(fBodyGyro-Z)
    ## 439                       sma(fBodyGyro-XfBodyGyro-YfBodyGyro-Z)
    ## 440                                          energy(fBodyGyro-X)
    ## 441                                          energy(fBodyGyro-Y)
    ## 442                                          energy(fBodyGyro-Z)
    ## 443                                             iqr(fBodyGyro-X)
    ## 444                                             iqr(fBodyGyro-Y)
    ## 445                                             iqr(fBodyGyro-Z)
    ## 446                                         entropy(fBodyGyro-X)
    ## 447                                         entropy(fBodyGyro-Y)
    ## 448                                         entropy(fBodyGyro-Z)
    ## 449                                         maxInds(fBodyGyro-X)
    ## 450                                         maxInds(fBodyGyro-Y)
    ## 451                                         maxInds(fBodyGyro-Z)
    ## 452                                        meanFreq(fBodyGyro-X)
    ## 453                                        meanFreq(fBodyGyro-Y)
    ## 454                                        meanFreq(fBodyGyro-Z)
    ## 455                                        skewness(fBodyGyro-X)
    ## 456                                        kurtosis(fBodyGyro-X)
    ## 457                                        skewness(fBodyGyro-Y)
    ## 458                                        kurtosis(fBodyGyro-Y)
    ## 459                                        skewness(fBodyGyro-Z)
    ## 460                                        kurtosis(fBodyGyro-Z)
    ## 461            bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z1,8)
    ## 462           bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z9,16)
    ## 463          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z17,24)
    ## 464          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z25,32)
    ## 465          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z33,40)
    ## 466          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z41,48)
    ## 467          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z49,56)
    ## 468          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z57,64)
    ## 469           bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z1,16)
    ## 470          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z17,32)
    ## 471          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z33,48)
    ## 472          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z49,64)
    ## 473           bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z1,24)
    ## 474          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z25,48)
    ## 475            bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z1,8)
    ## 476           bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z9,16)
    ## 477          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z17,24)
    ## 478          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z25,32)
    ## 479          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z33,40)
    ## 480          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z41,48)
    ## 481          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z49,56)
    ## 482          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z57,64)
    ## 483           bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z1,16)
    ## 484          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z17,32)
    ## 485          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z33,48)
    ## 486          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z49,64)
    ## 487           bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z1,24)
    ## 488          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z25,48)
    ## 489            bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z1,8)
    ## 490           bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z9,16)
    ## 491          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z17,24)
    ## 492          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z25,32)
    ## 493          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z33,40)
    ## 494          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z41,48)
    ## 495          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z49,56)
    ## 496          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z57,64)
    ## 497           bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z1,16)
    ## 498          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z17,32)
    ## 499          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z33,48)
    ## 500          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z49,64)
    ## 501           bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z1,24)
    ## 502          bandsEnergy(fBodyGyro-XfBodyGyro-YfBodyGyro-Z25,48)
    ## 503                                            mean(fBodyAccMag)
    ## 504                                             std(fBodyAccMag)
    ## 505                                             mad(fBodyAccMag)
    ## 506                                             max(fBodyAccMag)
    ## 507                                             min(fBodyAccMag)
    ## 508                                             sma(fBodyAccMag)
    ## 509                                          energy(fBodyAccMag)
    ## 510                                             iqr(fBodyAccMag)
    ## 511                                         entropy(fBodyAccMag)
    ## 512                                         maxInds(fBodyAccMag)
    ## 513                                        meanFreq(fBodyAccMag)
    ## 514                                        skewness(fBodyAccMag)
    ## 515                                        kurtosis(fBodyAccMag)
    ## 516                                        mean(fBodyAccJerkMag)
    ## 517                                         std(fBodyAccJerkMag)
    ## 518                                         mad(fBodyAccJerkMag)
    ## 519                                         max(fBodyAccJerkMag)
    ## 520                                         min(fBodyAccJerkMag)
    ## 521                                         sma(fBodyAccJerkMag)
    ## 522                                      energy(fBodyAccJerkMag)
    ## 523                                         iqr(fBodyAccJerkMag)
    ## 524                                     entropy(fBodyAccJerkMag)
    ## 525                                     maxInds(fBodyAccJerkMag)
    ## 526                                    meanFreq(fBodyAccJerkMag)
    ## 527                                    skewness(fBodyAccJerkMag)
    ## 528                                    kurtosis(fBodyAccJerkMag)
    ## 529                                           mean(fBodyGyroMag)
    ## 530                                            std(fBodyGyroMag)
    ## 531                                            mad(fBodyGyroMag)
    ## 532                                            max(fBodyGyroMag)
    ## 533                                            min(fBodyGyroMag)
    ## 534                                            sma(fBodyGyroMag)
    ## 535                                         energy(fBodyGyroMag)
    ## 536                                            iqr(fBodyGyroMag)
    ## 537                                        entropy(fBodyGyroMag)
    ## 538                                        maxInds(fBodyGyroMag)
    ## 539                                       meanFreq(fBodyGyroMag)
    ## 540                                       skewness(fBodyGyroMag)
    ## 541                                       kurtosis(fBodyGyroMag)
    ## 542                                       mean(fBodyGyroJerkMag)
    ## 543                                        std(fBodyGyroJerkMag)
    ## 544                                        mad(fBodyGyroJerkMag)
    ## 545                                        max(fBodyGyroJerkMag)
    ## 546                                        min(fBodyGyroJerkMag)
    ## 547                                        sma(fBodyGyroJerkMag)
    ## 548                                     energy(fBodyGyroJerkMag)
    ## 549                                        iqr(fBodyGyroJerkMag)
    ## 550                                    entropy(fBodyGyroJerkMag)
    ## 551                                    maxInds(fBodyGyroJerkMag)
    ## 552                                   meanFreq(fBodyGyroJerkMag)
    ## 553                                   skewness(fBodyGyroJerkMag)
    ## 554                                   kurtosis(fBodyGyroJerkMag)
    ## 555                                  angle(tBodyAccMean,gravity)
    ## 556                          angle(tBodyAccJerkMean,gravityMean)
    ## 557                             angle(tBodyGyroMean,gravityMean)
    ## 558                         angle(tBodyGyroJerkMean,gravityMean)
    ## 559                                         angle(X,gravityMean)
    ## 560                                         angle(Y,gravityMean)
    ## 561                                         angle(Z,gravityMean)
    ##                                                                      description
    ## 1                                                                     Mean value
    ## 2                                                                     Mean value
    ## 3                                                                     Mean value
    ## 4                                                             Standard deviation
    ## 5                                                             Standard deviation
    ## 6                                                             Standard deviation
    ## 7                                                      Median absolute deviation
    ## 8                                                      Median absolute deviation
    ## 9                                                      Median absolute deviation
    ## 10                                                        Largest value in array
    ## 11                                                        Largest value in array
    ## 12                                                        Largest value in array
    ## 13                                                       Smallest value in array
    ## 14                                                       Smallest value in array
    ## 15                                                       Smallest value in array
    ## 16                                                         Signal magnitude area
    ## 17           Energy measure. Sum of the squares divided by the number of values.
    ## 18           Energy measure. Sum of the squares divided by the number of values.
    ## 19           Energy measure. Sum of the squares divided by the number of values.
    ## 20                                                           Interquartile range
    ## 21                                                           Interquartile range
    ## 22                                                           Interquartile range
    ## 23                                                                Signal entropy
    ## 24                                                                Signal entropy
    ## 25                                                                Signal entropy
    ## 26                        Autorregresion coefficients with Burg order equal to 4
    ## 27                        Autorregresion coefficients with Burg order equal to 4
    ## 28                        Autorregresion coefficients with Burg order equal to 4
    ## 29                        Autorregresion coefficients with Burg order equal to 4
    ## 30                        Autorregresion coefficients with Burg order equal to 4
    ## 31                        Autorregresion coefficients with Burg order equal to 4
    ## 32                        Autorregresion coefficients with Burg order equal to 4
    ## 33                        Autorregresion coefficients with Burg order equal to 4
    ## 34                        Autorregresion coefficients with Burg order equal to 4
    ## 35                        Autorregresion coefficients with Burg order equal to 4
    ## 36                        Autorregresion coefficients with Burg order equal to 4
    ## 37                        Autorregresion coefficients with Burg order equal to 4
    ## 38                                   correlation coefficient between two signals
    ## 39                                   correlation coefficient between two signals
    ## 40                                   correlation coefficient between two signals
    ## 41                                                                    Mean value
    ## 42                                                                    Mean value
    ## 43                                                                    Mean value
    ## 44                                                            Standard deviation
    ## 45                                                            Standard deviation
    ## 46                                                            Standard deviation
    ## 47                                                     Median absolute deviation
    ## 48                                                     Median absolute deviation
    ## 49                                                     Median absolute deviation
    ## 50                                                        Largest value in array
    ## 51                                                        Largest value in array
    ## 52                                                        Largest value in array
    ## 53                                                       Smallest value in array
    ## 54                                                       Smallest value in array
    ## 55                                                       Smallest value in array
    ## 56                                                         Signal magnitude area
    ## 57           Energy measure. Sum of the squares divided by the number of values.
    ## 58           Energy measure. Sum of the squares divided by the number of values.
    ## 59           Energy measure. Sum of the squares divided by the number of values.
    ## 60                                                           Interquartile range
    ## 61                                                           Interquartile range
    ## 62                                                           Interquartile range
    ## 63                                                                Signal entropy
    ## 64                                                                Signal entropy
    ## 65                                                                Signal entropy
    ## 66                        Autorregresion coefficients with Burg order equal to 4
    ## 67                        Autorregresion coefficients with Burg order equal to 4
    ## 68                        Autorregresion coefficients with Burg order equal to 4
    ## 69                        Autorregresion coefficients with Burg order equal to 4
    ## 70                        Autorregresion coefficients with Burg order equal to 4
    ## 71                        Autorregresion coefficients with Burg order equal to 4
    ## 72                        Autorregresion coefficients with Burg order equal to 4
    ## 73                        Autorregresion coefficients with Burg order equal to 4
    ## 74                        Autorregresion coefficients with Burg order equal to 4
    ## 75                        Autorregresion coefficients with Burg order equal to 4
    ## 76                        Autorregresion coefficients with Burg order equal to 4
    ## 77                        Autorregresion coefficients with Burg order equal to 4
    ## 78                                   correlation coefficient between two signals
    ## 79                                   correlation coefficient between two signals
    ## 80                                   correlation coefficient between two signals
    ## 81                                                                    Mean value
    ## 82                                                                    Mean value
    ## 83                                                                    Mean value
    ## 84                                                            Standard deviation
    ## 85                                                            Standard deviation
    ## 86                                                            Standard deviation
    ## 87                                                     Median absolute deviation
    ## 88                                                     Median absolute deviation
    ## 89                                                     Median absolute deviation
    ## 90                                                        Largest value in array
    ## 91                                                        Largest value in array
    ## 92                                                        Largest value in array
    ## 93                                                       Smallest value in array
    ## 94                                                       Smallest value in array
    ## 95                                                       Smallest value in array
    ## 96                                                         Signal magnitude area
    ## 97           Energy measure. Sum of the squares divided by the number of values.
    ## 98           Energy measure. Sum of the squares divided by the number of values.
    ## 99           Energy measure. Sum of the squares divided by the number of values.
    ## 100                                                          Interquartile range
    ## 101                                                          Interquartile range
    ## 102                                                          Interquartile range
    ## 103                                                               Signal entropy
    ## 104                                                               Signal entropy
    ## 105                                                               Signal entropy
    ## 106                       Autorregresion coefficients with Burg order equal to 4
    ## 107                       Autorregresion coefficients with Burg order equal to 4
    ## 108                       Autorregresion coefficients with Burg order equal to 4
    ## 109                       Autorregresion coefficients with Burg order equal to 4
    ## 110                       Autorregresion coefficients with Burg order equal to 4
    ## 111                       Autorregresion coefficients with Burg order equal to 4
    ## 112                       Autorregresion coefficients with Burg order equal to 4
    ## 113                       Autorregresion coefficients with Burg order equal to 4
    ## 114                       Autorregresion coefficients with Burg order equal to 4
    ## 115                       Autorregresion coefficients with Burg order equal to 4
    ## 116                       Autorregresion coefficients with Burg order equal to 4
    ## 117                       Autorregresion coefficients with Burg order equal to 4
    ## 118                                  correlation coefficient between two signals
    ## 119                                  correlation coefficient between two signals
    ## 120                                  correlation coefficient between two signals
    ## 121                                                                   Mean value
    ## 122                                                                   Mean value
    ## 123                                                                   Mean value
    ## 124                                                           Standard deviation
    ## 125                                                           Standard deviation
    ## 126                                                           Standard deviation
    ## 127                                                    Median absolute deviation
    ## 128                                                    Median absolute deviation
    ## 129                                                    Median absolute deviation
    ## 130                                                       Largest value in array
    ## 131                                                       Largest value in array
    ## 132                                                       Largest value in array
    ## 133                                                      Smallest value in array
    ## 134                                                      Smallest value in array
    ## 135                                                      Smallest value in array
    ## 136                                                        Signal magnitude area
    ## 137          Energy measure. Sum of the squares divided by the number of values.
    ## 138          Energy measure. Sum of the squares divided by the number of values.
    ## 139          Energy measure. Sum of the squares divided by the number of values.
    ## 140                                                          Interquartile range
    ## 141                                                          Interquartile range
    ## 142                                                          Interquartile range
    ## 143                                                               Signal entropy
    ## 144                                                               Signal entropy
    ## 145                                                               Signal entropy
    ## 146                       Autorregresion coefficients with Burg order equal to 4
    ## 147                       Autorregresion coefficients with Burg order equal to 4
    ## 148                       Autorregresion coefficients with Burg order equal to 4
    ## 149                       Autorregresion coefficients with Burg order equal to 4
    ## 150                       Autorregresion coefficients with Burg order equal to 4
    ## 151                       Autorregresion coefficients with Burg order equal to 4
    ## 152                       Autorregresion coefficients with Burg order equal to 4
    ## 153                       Autorregresion coefficients with Burg order equal to 4
    ## 154                       Autorregresion coefficients with Burg order equal to 4
    ## 155                       Autorregresion coefficients with Burg order equal to 4
    ## 156                       Autorregresion coefficients with Burg order equal to 4
    ## 157                       Autorregresion coefficients with Burg order equal to 4
    ## 158                                  correlation coefficient between two signals
    ## 159                                  correlation coefficient between two signals
    ## 160                                  correlation coefficient between two signals
    ## 161                                                                   Mean value
    ## 162                                                                   Mean value
    ## 163                                                                   Mean value
    ## 164                                                           Standard deviation
    ## 165                                                           Standard deviation
    ## 166                                                           Standard deviation
    ## 167                                                    Median absolute deviation
    ## 168                                                    Median absolute deviation
    ## 169                                                    Median absolute deviation
    ## 170                                                       Largest value in array
    ## 171                                                       Largest value in array
    ## 172                                                       Largest value in array
    ## 173                                                      Smallest value in array
    ## 174                                                      Smallest value in array
    ## 175                                                      Smallest value in array
    ## 176                                                        Signal magnitude area
    ## 177          Energy measure. Sum of the squares divided by the number of values.
    ## 178          Energy measure. Sum of the squares divided by the number of values.
    ## 179          Energy measure. Sum of the squares divided by the number of values.
    ## 180                                                          Interquartile range
    ## 181                                                          Interquartile range
    ## 182                                                          Interquartile range
    ## 183                                                               Signal entropy
    ## 184                                                               Signal entropy
    ## 185                                                               Signal entropy
    ## 186                       Autorregresion coefficients with Burg order equal to 4
    ## 187                       Autorregresion coefficients with Burg order equal to 4
    ## 188                       Autorregresion coefficients with Burg order equal to 4
    ## 189                       Autorregresion coefficients with Burg order equal to 4
    ## 190                       Autorregresion coefficients with Burg order equal to 4
    ## 191                       Autorregresion coefficients with Burg order equal to 4
    ## 192                       Autorregresion coefficients with Burg order equal to 4
    ## 193                       Autorregresion coefficients with Burg order equal to 4
    ## 194                       Autorregresion coefficients with Burg order equal to 4
    ## 195                       Autorregresion coefficients with Burg order equal to 4
    ## 196                       Autorregresion coefficients with Burg order equal to 4
    ## 197                       Autorregresion coefficients with Burg order equal to 4
    ## 198                                  correlation coefficient between two signals
    ## 199                                  correlation coefficient between two signals
    ## 200                                  correlation coefficient between two signals
    ## 201                                                                   Mean value
    ## 202                                                           Standard deviation
    ## 203                                                    Median absolute deviation
    ## 204                                                       Largest value in array
    ## 205                                                      Smallest value in array
    ## 206                                                        Signal magnitude area
    ## 207          Energy measure. Sum of the squares divided by the number of values.
    ## 208                                                          Interquartile range
    ## 209                                                               Signal entropy
    ## 210                       Autorregresion coefficients with Burg order equal to 4
    ## 211                       Autorregresion coefficients with Burg order equal to 4
    ## 212                       Autorregresion coefficients with Burg order equal to 4
    ## 213                       Autorregresion coefficients with Burg order equal to 4
    ## 214                                                                   Mean value
    ## 215                                                           Standard deviation
    ## 216                                                    Median absolute deviation
    ## 217                                                       Largest value in array
    ## 218                                                      Smallest value in array
    ## 219                                                        Signal magnitude area
    ## 220          Energy measure. Sum of the squares divided by the number of values.
    ## 221                                                          Interquartile range
    ## 222                                                               Signal entropy
    ## 223                       Autorregresion coefficients with Burg order equal to 4
    ## 224                       Autorregresion coefficients with Burg order equal to 4
    ## 225                       Autorregresion coefficients with Burg order equal to 4
    ## 226                       Autorregresion coefficients with Burg order equal to 4
    ## 227                                                                   Mean value
    ## 228                                                           Standard deviation
    ## 229                                                    Median absolute deviation
    ## 230                                                       Largest value in array
    ## 231                                                      Smallest value in array
    ## 232                                                        Signal magnitude area
    ## 233          Energy measure. Sum of the squares divided by the number of values.
    ## 234                                                          Interquartile range
    ## 235                                                               Signal entropy
    ## 236                       Autorregresion coefficients with Burg order equal to 4
    ## 237                       Autorregresion coefficients with Burg order equal to 4
    ## 238                       Autorregresion coefficients with Burg order equal to 4
    ## 239                       Autorregresion coefficients with Burg order equal to 4
    ## 240                                                                   Mean value
    ## 241                                                           Standard deviation
    ## 242                                                    Median absolute deviation
    ## 243                                                       Largest value in array
    ## 244                                                      Smallest value in array
    ## 245                                                        Signal magnitude area
    ## 246          Energy measure. Sum of the squares divided by the number of values.
    ## 247                                                          Interquartile range
    ## 248                                                               Signal entropy
    ## 249                       Autorregresion coefficients with Burg order equal to 4
    ## 250                       Autorregresion coefficients with Burg order equal to 4
    ## 251                       Autorregresion coefficients with Burg order equal to 4
    ## 252                       Autorregresion coefficients with Burg order equal to 4
    ## 253                                                                   Mean value
    ## 254                                                           Standard deviation
    ## 255                                                    Median absolute deviation
    ## 256                                                       Largest value in array
    ## 257                                                      Smallest value in array
    ## 258                                                        Signal magnitude area
    ## 259          Energy measure. Sum of the squares divided by the number of values.
    ## 260                                                          Interquartile range
    ## 261                                                               Signal entropy
    ## 262                       Autorregresion coefficients with Burg order equal to 4
    ## 263                       Autorregresion coefficients with Burg order equal to 4
    ## 264                       Autorregresion coefficients with Burg order equal to 4
    ## 265                       Autorregresion coefficients with Burg order equal to 4
    ## 266                                                                   Mean value
    ## 267                                                                   Mean value
    ## 268                                                                   Mean value
    ## 269                                                           Standard deviation
    ## 270                                                           Standard deviation
    ## 271                                                           Standard deviation
    ## 272                                                    Median absolute deviation
    ## 273                                                    Median absolute deviation
    ## 274                                                    Median absolute deviation
    ## 275                                                       Largest value in array
    ## 276                                                       Largest value in array
    ## 277                                                       Largest value in array
    ## 278                                                      Smallest value in array
    ## 279                                                      Smallest value in array
    ## 280                                                      Smallest value in array
    ## 281                                                        Signal magnitude area
    ## 282          Energy measure. Sum of the squares divided by the number of values.
    ## 283          Energy measure. Sum of the squares divided by the number of values.
    ## 284          Energy measure. Sum of the squares divided by the number of values.
    ## 285                                                          Interquartile range
    ## 286                                                          Interquartile range
    ## 287                                                          Interquartile range
    ## 288                                                               Signal entropy
    ## 289                                                               Signal entropy
    ## 290                                                               Signal entropy
    ## 291                      index of the frequency component with largest magnitude
    ## 292                      index of the frequency component with largest magnitude
    ## 293                      index of the frequency component with largest magnitude
    ## 294      Weighted average of the frequency components to obtain a mean frequency
    ## 295      Weighted average of the frequency components to obtain a mean frequency
    ## 296      Weighted average of the frequency components to obtain a mean frequency
    ## 297                                      skewness of the frequency domain signal
    ## 298                                      kurtosis of the frequency domain signal
    ## 299                                      skewness of the frequency domain signal
    ## 300                                      kurtosis of the frequency domain signal
    ## 301                                      skewness of the frequency domain signal
    ## 302                                      kurtosis of the frequency domain signal
    ## 303 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 304 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 305 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 306 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 307 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 308 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 309 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 310 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 311 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 312 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 313 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 314 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 315 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 316 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 317 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 318 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 319 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 320 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 321 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 322 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 323 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 324 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 325 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 326 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 327 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 328 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 329 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 330 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 331 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 332 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 333 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 334 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 335 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 336 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 337 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 338 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 339 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 340 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 341 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 342 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 343 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 344 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 345                                                                   Mean value
    ## 346                                                                   Mean value
    ## 347                                                                   Mean value
    ## 348                                                           Standard deviation
    ## 349                                                           Standard deviation
    ## 350                                                           Standard deviation
    ## 351                                                    Median absolute deviation
    ## 352                                                    Median absolute deviation
    ## 353                                                    Median absolute deviation
    ## 354                                                       Largest value in array
    ## 355                                                       Largest value in array
    ## 356                                                       Largest value in array
    ## 357                                                      Smallest value in array
    ## 358                                                      Smallest value in array
    ## 359                                                      Smallest value in array
    ## 360                                                        Signal magnitude area
    ## 361          Energy measure. Sum of the squares divided by the number of values.
    ## 362          Energy measure. Sum of the squares divided by the number of values.
    ## 363          Energy measure. Sum of the squares divided by the number of values.
    ## 364                                                          Interquartile range
    ## 365                                                          Interquartile range
    ## 366                                                          Interquartile range
    ## 367                                                               Signal entropy
    ## 368                                                               Signal entropy
    ## 369                                                               Signal entropy
    ## 370                      index of the frequency component with largest magnitude
    ## 371                      index of the frequency component with largest magnitude
    ## 372                      index of the frequency component with largest magnitude
    ## 373      Weighted average of the frequency components to obtain a mean frequency
    ## 374      Weighted average of the frequency components to obtain a mean frequency
    ## 375      Weighted average of the frequency components to obtain a mean frequency
    ## 376                                      skewness of the frequency domain signal
    ## 377                                      kurtosis of the frequency domain signal
    ## 378                                      skewness of the frequency domain signal
    ## 379                                      kurtosis of the frequency domain signal
    ## 380                                      skewness of the frequency domain signal
    ## 381                                      kurtosis of the frequency domain signal
    ## 382 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 383 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 384 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 385 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 386 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 387 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 388 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 389 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 390 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 391 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 392 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 393 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 394 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 395 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 396 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 397 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 398 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 399 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 400 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 401 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 402 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 403 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 404 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 405 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 406 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 407 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 408 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 409 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 410 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 411 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 412 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 413 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 414 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 415 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 416 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 417 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 418 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 419 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 420 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 421 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 422 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 423 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 424                                                                   Mean value
    ## 425                                                                   Mean value
    ## 426                                                                   Mean value
    ## 427                                                           Standard deviation
    ## 428                                                           Standard deviation
    ## 429                                                           Standard deviation
    ## 430                                                    Median absolute deviation
    ## 431                                                    Median absolute deviation
    ## 432                                                    Median absolute deviation
    ## 433                                                       Largest value in array
    ## 434                                                       Largest value in array
    ## 435                                                       Largest value in array
    ## 436                                                      Smallest value in array
    ## 437                                                      Smallest value in array
    ## 438                                                      Smallest value in array
    ## 439                                                        Signal magnitude area
    ## 440          Energy measure. Sum of the squares divided by the number of values.
    ## 441          Energy measure. Sum of the squares divided by the number of values.
    ## 442          Energy measure. Sum of the squares divided by the number of values.
    ## 443                                                          Interquartile range
    ## 444                                                          Interquartile range
    ## 445                                                          Interquartile range
    ## 446                                                               Signal entropy
    ## 447                                                               Signal entropy
    ## 448                                                               Signal entropy
    ## 449                      index of the frequency component with largest magnitude
    ## 450                      index of the frequency component with largest magnitude
    ## 451                      index of the frequency component with largest magnitude
    ## 452      Weighted average of the frequency components to obtain a mean frequency
    ## 453      Weighted average of the frequency components to obtain a mean frequency
    ## 454      Weighted average of the frequency components to obtain a mean frequency
    ## 455                                      skewness of the frequency domain signal
    ## 456                                      kurtosis of the frequency domain signal
    ## 457                                      skewness of the frequency domain signal
    ## 458                                      kurtosis of the frequency domain signal
    ## 459                                      skewness of the frequency domain signal
    ## 460                                      kurtosis of the frequency domain signal
    ## 461 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 462 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 463 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 464 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 465 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 466 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 467 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 468 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 469 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 470 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 471 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 472 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 473 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 474 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 475 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 476 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 477 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 478 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 479 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 480 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 481 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 482 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 483 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 484 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 485 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 486 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 487 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 488 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 489 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 490 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 491 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 492 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 493 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 494 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 495 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 496 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 497 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 498 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 499 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 500 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 501 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 502 Energy of a frequency interval within the 64 bins of the FFT of each window.
    ## 503                                                                   Mean value
    ## 504                                                           Standard deviation
    ## 505                                                    Median absolute deviation
    ## 506                                                       Largest value in array
    ## 507                                                      Smallest value in array
    ## 508                                                        Signal magnitude area
    ## 509          Energy measure. Sum of the squares divided by the number of values.
    ## 510                                                          Interquartile range
    ## 511                                                               Signal entropy
    ## 512                      index of the frequency component with largest magnitude
    ## 513      Weighted average of the frequency components to obtain a mean frequency
    ## 514                                      skewness of the frequency domain signal
    ## 515                                      kurtosis of the frequency domain signal
    ## 516                                                                   Mean value
    ## 517                                                           Standard deviation
    ## 518                                                    Median absolute deviation
    ## 519                                                       Largest value in array
    ## 520                                                      Smallest value in array
    ## 521                                                        Signal magnitude area
    ## 522          Energy measure. Sum of the squares divided by the number of values.
    ## 523                                                          Interquartile range
    ## 524                                                               Signal entropy
    ## 525                      index of the frequency component with largest magnitude
    ## 526      Weighted average of the frequency components to obtain a mean frequency
    ## 527                                      skewness of the frequency domain signal
    ## 528                                      kurtosis of the frequency domain signal
    ## 529                                                                   Mean value
    ## 530                                                           Standard deviation
    ## 531                                                    Median absolute deviation
    ## 532                                                       Largest value in array
    ## 533                                                      Smallest value in array
    ## 534                                                        Signal magnitude area
    ## 535          Energy measure. Sum of the squares divided by the number of values.
    ## 536                                                          Interquartile range
    ## 537                                                               Signal entropy
    ## 538                      index of the frequency component with largest magnitude
    ## 539      Weighted average of the frequency components to obtain a mean frequency
    ## 540                                      skewness of the frequency domain signal
    ## 541                                      kurtosis of the frequency domain signal
    ## 542                                                                   Mean value
    ## 543                                                           Standard deviation
    ## 544                                                    Median absolute deviation
    ## 545                                                       Largest value in array
    ## 546                                                      Smallest value in array
    ## 547                                                        Signal magnitude area
    ## 548          Energy measure. Sum of the squares divided by the number of values.
    ## 549                                                          Interquartile range
    ## 550                                                               Signal entropy
    ## 551                      index of the frequency component with largest magnitude
    ## 552      Weighted average of the frequency components to obtain a mean frequency
    ## 553                                      skewness of the frequency domain signal
    ## 554                                      kurtosis of the frequency domain signal
    ## 555                                                    Angle between to vectors.
    ## 556                                                    Angle between to vectors.
    ## 557                                                    Angle between to vectors.
    ## 558                                                    Angle between to vectors.
    ## 559                                                    Angle between to vectors.
    ## 560                                                    Angle between to vectors.
    ## 561                                                    Angle between to vectors.

Contingency Tables
------------------

### (OK) Features by domain

``` r
sort(table("features by domain" = features$domain), decreasing = TRUE)
```

    ## features by domain
    ##   f   t     
    ## 289 265   7

### (OK) Features by Raw Signal

``` r
sort(table("features by rawSignal" = features$rawSignal), decreasing = TRUE)
```

    ## features by rawSignal
    ##  Acc Gyro      
    ##  343  211    7

### (OK) Features by Statistic

``` r
sort(table("features by statistic" = features$statistic), decreasing = TRUE)
```

    ## features by statistic
    ## bandsEnergy     arCoeff      energy     entropy         iqr         mad 
    ##         126          80          33          33          33          33 
    ##         max        mean         min         std         sma correlation 
    ##          33          33          33          33          17          15 
    ##    kurtosis     maxInds    meanFreq    skewness       angle 
    ##          13          13          13          13           7

### (!!) Features by Signal (concatenate axisSep,axis,axes,axesSep to produce uniaxal, biaxial, triaxial and magnitude signals)

``` r
sort(table("features by signal" = with(features, paste0(domain, prefix, rawSignal, jerkSuffix, magSuffix, axisSep, axis, axesSep, axes))), decreasing = TRUE)
```

    ## features by signal
    ##      fBodyAcc-XYZ  fBodyAccJerk-XYZ     fBodyGyro-XYZ   fBodyAccJerkMag 
    ##                43                43                43                13 
    ##       fBodyAccMag  fBodyGyroJerkMag      fBodyGyroMag   tBodyAccJerkMag 
    ##                13                13                13                13 
    ##       tBodyAccMag  tBodyGyroJerkMag      tBodyGyroMag    tGravityAccMag 
    ##                13                13                13                13 
    ##        fBodyAcc-X        fBodyAcc-Y        fBodyAcc-Z    fBodyAccJerk-X 
    ##                12                12                12                12 
    ##    fBodyAccJerk-Y    fBodyAccJerk-Z       fBodyGyro-X       fBodyGyro-Y 
    ##                12                12                12                12 
    ##       fBodyGyro-Z        tBodyAcc-X        tBodyAcc-Y        tBodyAcc-Z 
    ##                12                12                12                12 
    ##    tBodyAccJerk-X    tBodyAccJerk-Y    tBodyAccJerk-Z       tBodyGyro-X 
    ##                12                12                12                12 
    ##       tBodyGyro-Y       tBodyGyro-Z   tBodyGyroJerk-X   tBodyGyroJerk-Y 
    ##                12                12                12                12 
    ##   tBodyGyroJerk-Z     tGravityAcc-X     tGravityAcc-Y     tGravityAcc-Z 
    ##                12                12                12                12 
    ##                         tBodyAcc-XY      tBodyAcc-XYZ       tBodyAcc-XZ 
    ##                 7                 1                 1                 1 
    ##       tBodyAcc-YZ   tBodyAccJerk-XY  tBodyAccJerk-XYZ   tBodyAccJerk-XZ 
    ##                 1                 1                 1                 1 
    ##   tBodyAccJerk-YZ      tBodyGyro-XY     tBodyGyro-XYZ      tBodyGyro-XZ 
    ##                 1                 1                 1                 1 
    ##      tBodyGyro-YZ  tBodyGyroJerk-XY tBodyGyroJerk-XYZ  tBodyGyroJerk-XZ 
    ##                 1                 1                 1                 1 
    ##  tBodyGyroJerk-YZ    tGravityAcc-XY   tGravityAcc-XYZ    tGravityAcc-XZ 
    ##                 1                 1                 1                 1 
    ##    tGravityAcc-YZ 
    ##                 1

### Features by Signal by Domain

``` r
with(features,table("features by signal by domain" = paste0(domain, prefix, rawSignal, jerkSuffix, magSuffix, axisSep, axis, axesSep, axes), domain))
```

    ##                             domain
    ## features by signal by domain     f  t
    ##                               7  0  0
    ##            fBodyAcc-X         0 12  0
    ##            fBodyAcc-XYZ       0 43  0
    ##            fBodyAcc-Y         0 12  0
    ##            fBodyAcc-Z         0 12  0
    ##            fBodyAccJerk-X     0 12  0
    ##            fBodyAccJerk-XYZ   0 43  0
    ##            fBodyAccJerk-Y     0 12  0
    ##            fBodyAccJerk-Z     0 12  0
    ##            fBodyAccJerkMag    0 13  0
    ##            fBodyAccMag        0 13  0
    ##            fBodyGyro-X        0 12  0
    ##            fBodyGyro-XYZ      0 43  0
    ##            fBodyGyro-Y        0 12  0
    ##            fBodyGyro-Z        0 12  0
    ##            fBodyGyroJerkMag   0 13  0
    ##            fBodyGyroMag       0 13  0
    ##            tBodyAcc-X         0  0 12
    ##            tBodyAcc-XY        0  0  1
    ##            tBodyAcc-XYZ       0  0  1
    ##            tBodyAcc-XZ        0  0  1
    ##            tBodyAcc-Y         0  0 12
    ##            tBodyAcc-YZ        0  0  1
    ##            tBodyAcc-Z         0  0 12
    ##            tBodyAccJerk-X     0  0 12
    ##            tBodyAccJerk-XY    0  0  1
    ##            tBodyAccJerk-XYZ   0  0  1
    ##            tBodyAccJerk-XZ    0  0  1
    ##            tBodyAccJerk-Y     0  0 12
    ##            tBodyAccJerk-YZ    0  0  1
    ##            tBodyAccJerk-Z     0  0 12
    ##            tBodyAccJerkMag    0  0 13
    ##            tBodyAccMag        0  0 13
    ##            tBodyGyro-X        0  0 12
    ##            tBodyGyro-XY       0  0  1
    ##            tBodyGyro-XYZ      0  0  1
    ##            tBodyGyro-XZ       0  0  1
    ##            tBodyGyro-Y        0  0 12
    ##            tBodyGyro-YZ       0  0  1
    ##            tBodyGyro-Z        0  0 12
    ##            tBodyGyroJerk-X    0  0 12
    ##            tBodyGyroJerk-XY   0  0  1
    ##            tBodyGyroJerk-XYZ  0  0  1
    ##            tBodyGyroJerk-XZ   0  0  1
    ##            tBodyGyroJerk-Y    0  0 12
    ##            tBodyGyroJerk-YZ   0  0  1
    ##            tBodyGyroJerk-Z    0  0 12
    ##            tBodyGyroJerkMag   0  0 13
    ##            tBodyGyroMag       0  0 13
    ##            tGravityAcc-X      0  0 12
    ##            tGravityAcc-XY     0  0  1
    ##            tGravityAcc-XYZ    0  0  1
    ##            tGravityAcc-XZ     0  0  1
    ##            tGravityAcc-Y      0  0 12
    ##            tGravityAcc-YZ     0  0  1
    ##            tGravityAcc-Z      0  0 12
    ##            tGravityAccMag     0  0 13

### Features by Signal by Raw Signal

``` r
with(features,table("features by signal by rawSignal" = paste0(domain, prefix, rawSignal, jerkSuffix, magSuffix, axisSep, axis, axesSep, axes), rawSignal))
```

    ##                                rawSignal
    ## features by signal by rawSignal    Acc Gyro
    ##                                  7   0    0
    ##               fBodyAcc-X         0  12    0
    ##               fBodyAcc-XYZ       0  43    0
    ##               fBodyAcc-Y         0  12    0
    ##               fBodyAcc-Z         0  12    0
    ##               fBodyAccJerk-X     0  12    0
    ##               fBodyAccJerk-XYZ   0  43    0
    ##               fBodyAccJerk-Y     0  12    0
    ##               fBodyAccJerk-Z     0  12    0
    ##               fBodyAccJerkMag    0  13    0
    ##               fBodyAccMag        0  13    0
    ##               fBodyGyro-X        0   0   12
    ##               fBodyGyro-XYZ      0   0   43
    ##               fBodyGyro-Y        0   0   12
    ##               fBodyGyro-Z        0   0   12
    ##               fBodyGyroJerkMag   0   0   13
    ##               fBodyGyroMag       0   0   13
    ##               tBodyAcc-X         0  12    0
    ##               tBodyAcc-XY        0   1    0
    ##               tBodyAcc-XYZ       0   1    0
    ##               tBodyAcc-XZ        0   1    0
    ##               tBodyAcc-Y         0  12    0
    ##               tBodyAcc-YZ        0   1    0
    ##               tBodyAcc-Z         0  12    0
    ##               tBodyAccJerk-X     0  12    0
    ##               tBodyAccJerk-XY    0   1    0
    ##               tBodyAccJerk-XYZ   0   1    0
    ##               tBodyAccJerk-XZ    0   1    0
    ##               tBodyAccJerk-Y     0  12    0
    ##               tBodyAccJerk-YZ    0   1    0
    ##               tBodyAccJerk-Z     0  12    0
    ##               tBodyAccJerkMag    0  13    0
    ##               tBodyAccMag        0  13    0
    ##               tBodyGyro-X        0   0   12
    ##               tBodyGyro-XY       0   0    1
    ##               tBodyGyro-XYZ      0   0    1
    ##               tBodyGyro-XZ       0   0    1
    ##               tBodyGyro-Y        0   0   12
    ##               tBodyGyro-YZ       0   0    1
    ##               tBodyGyro-Z        0   0   12
    ##               tBodyGyroJerk-X    0   0   12
    ##               tBodyGyroJerk-XY   0   0    1
    ##               tBodyGyroJerk-XYZ  0   0    1
    ##               tBodyGyroJerk-XZ   0   0    1
    ##               tBodyGyroJerk-Y    0   0   12
    ##               tBodyGyroJerk-YZ   0   0    1
    ##               tBodyGyroJerk-Z    0   0   12
    ##               tBodyGyroJerkMag   0   0   13
    ##               tBodyGyroMag       0   0   13
    ##               tGravityAcc-X      0  12    0
    ##               tGravityAcc-XY     0   1    0
    ##               tGravityAcc-XYZ    0   1    0
    ##               tGravityAcc-XZ     0   1    0
    ##               tGravityAcc-Y      0  12    0
    ##               tGravityAcc-YZ     0   1    0
    ##               tGravityAcc-Z      0  12    0
    ##               tGravityAccMag     0  13    0

### Features by Signal by Statistic

``` r
with(features,table("features by signal by statistic" = paste0(domain, prefix, rawSignal, jerkSuffix, magSuffix, axisSep, axis, axesSep, axes), statistic))
```

    ##                                statistic
    ## features by signal by statistic angle arCoeff bandsEnergy correlation
    ##                                     7       0           0           0
    ##               fBodyAcc-X            0       0           0           0
    ##               fBodyAcc-XYZ          0       0          42           0
    ##               fBodyAcc-Y            0       0           0           0
    ##               fBodyAcc-Z            0       0           0           0
    ##               fBodyAccJerk-X        0       0           0           0
    ##               fBodyAccJerk-XYZ      0       0          42           0
    ##               fBodyAccJerk-Y        0       0           0           0
    ##               fBodyAccJerk-Z        0       0           0           0
    ##               fBodyAccJerkMag       0       0           0           0
    ##               fBodyAccMag           0       0           0           0
    ##               fBodyGyro-X           0       0           0           0
    ##               fBodyGyro-XYZ         0       0          42           0
    ##               fBodyGyro-Y           0       0           0           0
    ##               fBodyGyro-Z           0       0           0           0
    ##               fBodyGyroJerkMag      0       0           0           0
    ##               fBodyGyroMag          0       0           0           0
    ##               tBodyAcc-X            0       4           0           0
    ##               tBodyAcc-XY           0       0           0           1
    ##               tBodyAcc-XYZ          0       0           0           0
    ##               tBodyAcc-XZ           0       0           0           1
    ##               tBodyAcc-Y            0       4           0           0
    ##               tBodyAcc-YZ           0       0           0           1
    ##               tBodyAcc-Z            0       4           0           0
    ##               tBodyAccJerk-X        0       4           0           0
    ##               tBodyAccJerk-XY       0       0           0           1
    ##               tBodyAccJerk-XYZ      0       0           0           0
    ##               tBodyAccJerk-XZ       0       0           0           1
    ##               tBodyAccJerk-Y        0       4           0           0
    ##               tBodyAccJerk-YZ       0       0           0           1
    ##               tBodyAccJerk-Z        0       4           0           0
    ##               tBodyAccJerkMag       0       4           0           0
    ##               tBodyAccMag           0       4           0           0
    ##               tBodyGyro-X           0       4           0           0
    ##               tBodyGyro-XY          0       0           0           1
    ##               tBodyGyro-XYZ         0       0           0           0
    ##               tBodyGyro-XZ          0       0           0           1
    ##               tBodyGyro-Y           0       4           0           0
    ##               tBodyGyro-YZ          0       0           0           1
    ##               tBodyGyro-Z           0       4           0           0
    ##               tBodyGyroJerk-X       0       4           0           0
    ##               tBodyGyroJerk-XY      0       0           0           1
    ##               tBodyGyroJerk-XYZ     0       0           0           0
    ##               tBodyGyroJerk-XZ      0       0           0           1
    ##               tBodyGyroJerk-Y       0       4           0           0
    ##               tBodyGyroJerk-YZ      0       0           0           1
    ##               tBodyGyroJerk-Z       0       4           0           0
    ##               tBodyGyroJerkMag      0       4           0           0
    ##               tBodyGyroMag          0       4           0           0
    ##               tGravityAcc-X         0       4           0           0
    ##               tGravityAcc-XY        0       0           0           1
    ##               tGravityAcc-XYZ       0       0           0           0
    ##               tGravityAcc-XZ        0       0           0           1
    ##               tGravityAcc-Y         0       4           0           0
    ##               tGravityAcc-YZ        0       0           0           1
    ##               tGravityAcc-Z         0       4           0           0
    ##               tGravityAccMag        0       4           0           0
    ##                                statistic
    ## features by signal by statistic energy entropy iqr kurtosis mad max
    ##                                      0       0   0        0   0   0
    ##               fBodyAcc-X             1       1   1        1   1   1
    ##               fBodyAcc-XYZ           0       0   0        0   0   0
    ##               fBodyAcc-Y             1       1   1        1   1   1
    ##               fBodyAcc-Z             1       1   1        1   1   1
    ##               fBodyAccJerk-X         1       1   1        1   1   1
    ##               fBodyAccJerk-XYZ       0       0   0        0   0   0
    ##               fBodyAccJerk-Y         1       1   1        1   1   1
    ##               fBodyAccJerk-Z         1       1   1        1   1   1
    ##               fBodyAccJerkMag        1       1   1        1   1   1
    ##               fBodyAccMag            1       1   1        1   1   1
    ##               fBodyGyro-X            1       1   1        1   1   1
    ##               fBodyGyro-XYZ          0       0   0        0   0   0
    ##               fBodyGyro-Y            1       1   1        1   1   1
    ##               fBodyGyro-Z            1       1   1        1   1   1
    ##               fBodyGyroJerkMag       1       1   1        1   1   1
    ##               fBodyGyroMag           1       1   1        1   1   1
    ##               tBodyAcc-X             1       1   1        0   1   1
    ##               tBodyAcc-XY            0       0   0        0   0   0
    ##               tBodyAcc-XYZ           0       0   0        0   0   0
    ##               tBodyAcc-XZ            0       0   0        0   0   0
    ##               tBodyAcc-Y             1       1   1        0   1   1
    ##               tBodyAcc-YZ            0       0   0        0   0   0
    ##               tBodyAcc-Z             1       1   1        0   1   1
    ##               tBodyAccJerk-X         1       1   1        0   1   1
    ##               tBodyAccJerk-XY        0       0   0        0   0   0
    ##               tBodyAccJerk-XYZ       0       0   0        0   0   0
    ##               tBodyAccJerk-XZ        0       0   0        0   0   0
    ##               tBodyAccJerk-Y         1       1   1        0   1   1
    ##               tBodyAccJerk-YZ        0       0   0        0   0   0
    ##               tBodyAccJerk-Z         1       1   1        0   1   1
    ##               tBodyAccJerkMag        1       1   1        0   1   1
    ##               tBodyAccMag            1       1   1        0   1   1
    ##               tBodyGyro-X            1       1   1        0   1   1
    ##               tBodyGyro-XY           0       0   0        0   0   0
    ##               tBodyGyro-XYZ          0       0   0        0   0   0
    ##               tBodyGyro-XZ           0       0   0        0   0   0
    ##               tBodyGyro-Y            1       1   1        0   1   1
    ##               tBodyGyro-YZ           0       0   0        0   0   0
    ##               tBodyGyro-Z            1       1   1        0   1   1
    ##               tBodyGyroJerk-X        1       1   1        0   1   1
    ##               tBodyGyroJerk-XY       0       0   0        0   0   0
    ##               tBodyGyroJerk-XYZ      0       0   0        0   0   0
    ##               tBodyGyroJerk-XZ       0       0   0        0   0   0
    ##               tBodyGyroJerk-Y        1       1   1        0   1   1
    ##               tBodyGyroJerk-YZ       0       0   0        0   0   0
    ##               tBodyGyroJerk-Z        1       1   1        0   1   1
    ##               tBodyGyroJerkMag       1       1   1        0   1   1
    ##               tBodyGyroMag           1       1   1        0   1   1
    ##               tGravityAcc-X          1       1   1        0   1   1
    ##               tGravityAcc-XY         0       0   0        0   0   0
    ##               tGravityAcc-XYZ        0       0   0        0   0   0
    ##               tGravityAcc-XZ         0       0   0        0   0   0
    ##               tGravityAcc-Y          1       1   1        0   1   1
    ##               tGravityAcc-YZ         0       0   0        0   0   0
    ##               tGravityAcc-Z          1       1   1        0   1   1
    ##               tGravityAccMag         1       1   1        0   1   1
    ##                                statistic
    ## features by signal by statistic maxInds mean meanFreq min skewness sma std
    ##                                       0    0        0   0        0   0   0
    ##               fBodyAcc-X              1    1        1   1        1   0   1
    ##               fBodyAcc-XYZ            0    0        0   0        0   1   0
    ##               fBodyAcc-Y              1    1        1   1        1   0   1
    ##               fBodyAcc-Z              1    1        1   1        1   0   1
    ##               fBodyAccJerk-X          1    1        1   1        1   0   1
    ##               fBodyAccJerk-XYZ        0    0        0   0        0   1   0
    ##               fBodyAccJerk-Y          1    1        1   1        1   0   1
    ##               fBodyAccJerk-Z          1    1        1   1        1   0   1
    ##               fBodyAccJerkMag         1    1        1   1        1   1   1
    ##               fBodyAccMag             1    1        1   1        1   1   1
    ##               fBodyGyro-X             1    1        1   1        1   0   1
    ##               fBodyGyro-XYZ           0    0        0   0        0   1   0
    ##               fBodyGyro-Y             1    1        1   1        1   0   1
    ##               fBodyGyro-Z             1    1        1   1        1   0   1
    ##               fBodyGyroJerkMag        1    1        1   1        1   1   1
    ##               fBodyGyroMag            1    1        1   1        1   1   1
    ##               tBodyAcc-X              0    1        0   1        0   0   1
    ##               tBodyAcc-XY             0    0        0   0        0   0   0
    ##               tBodyAcc-XYZ            0    0        0   0        0   1   0
    ##               tBodyAcc-XZ             0    0        0   0        0   0   0
    ##               tBodyAcc-Y              0    1        0   1        0   0   1
    ##               tBodyAcc-YZ             0    0        0   0        0   0   0
    ##               tBodyAcc-Z              0    1        0   1        0   0   1
    ##               tBodyAccJerk-X          0    1        0   1        0   0   1
    ##               tBodyAccJerk-XY         0    0        0   0        0   0   0
    ##               tBodyAccJerk-XYZ        0    0        0   0        0   1   0
    ##               tBodyAccJerk-XZ         0    0        0   0        0   0   0
    ##               tBodyAccJerk-Y          0    1        0   1        0   0   1
    ##               tBodyAccJerk-YZ         0    0        0   0        0   0   0
    ##               tBodyAccJerk-Z          0    1        0   1        0   0   1
    ##               tBodyAccJerkMag         0    1        0   1        0   1   1
    ##               tBodyAccMag             0    1        0   1        0   1   1
    ##               tBodyGyro-X             0    1        0   1        0   0   1
    ##               tBodyGyro-XY            0    0        0   0        0   0   0
    ##               tBodyGyro-XYZ           0    0        0   0        0   1   0
    ##               tBodyGyro-XZ            0    0        0   0        0   0   0
    ##               tBodyGyro-Y             0    1        0   1        0   0   1
    ##               tBodyGyro-YZ            0    0        0   0        0   0   0
    ##               tBodyGyro-Z             0    1        0   1        0   0   1
    ##               tBodyGyroJerk-X         0    1        0   1        0   0   1
    ##               tBodyGyroJerk-XY        0    0        0   0        0   0   0
    ##               tBodyGyroJerk-XYZ       0    0        0   0        0   1   0
    ##               tBodyGyroJerk-XZ        0    0        0   0        0   0   0
    ##               tBodyGyroJerk-Y         0    1        0   1        0   0   1
    ##               tBodyGyroJerk-YZ        0    0        0   0        0   0   0
    ##               tBodyGyroJerk-Z         0    1        0   1        0   0   1
    ##               tBodyGyroJerkMag        0    1        0   1        0   1   1
    ##               tBodyGyroMag            0    1        0   1        0   1   1
    ##               tGravityAcc-X           0    1        0   1        0   0   1
    ##               tGravityAcc-XY          0    0        0   0        0   0   0
    ##               tGravityAcc-XYZ         0    0        0   0        0   1   0
    ##               tGravityAcc-XZ          0    0        0   0        0   0   0
    ##               tGravityAcc-Y           0    1        0   1        0   0   1
    ##               tGravityAcc-YZ          0    0        0   0        0   0   0
    ##               tGravityAcc-Z           0    1        0   1        0   0   1
    ##               tGravityAccMag          0    1        0   1        0   1   1

### Features by Statistic by Domain

``` r
with(features,table("features by statistic by domain" = statistic, domain))
```

    ##                                domain
    ## features by statistic by domain       f   t
    ##                     angle         7   0   0
    ##                     arCoeff       0   0  80
    ##                     bandsEnergy   0 126   0
    ##                     correlation   0   0  15
    ##                     energy        0  13  20
    ##                     entropy       0  13  20
    ##                     iqr           0  13  20
    ##                     kurtosis      0  13   0
    ##                     mad           0  13  20
    ##                     max           0  13  20
    ##                     maxInds       0  13   0
    ##                     mean          0  13  20
    ##                     meanFreq      0  13   0
    ##                     min           0  13  20
    ##                     skewness      0  13   0
    ##                     sma           0   7  10
    ##                     std           0  13  20

### Features by Statistic by Raw Signal

``` r
with(features,table("features by statistic by rawSignal" = statistic, rawSignal))
```

    ##                                   rawSignal
    ## features by statistic by rawSignal    Acc Gyro
    ##                        angle        7   0    0
    ##                        arCoeff      0  48   32
    ##                        bandsEnergy  0  84   42
    ##                        correlation  0   9    6
    ##                        energy       0  20   13
    ##                        entropy      0  20   13
    ##                        iqr          0  20   13
    ##                        kurtosis     0   8    5
    ##                        mad          0  20   13
    ##                        max          0  20   13
    ##                        maxInds      0   8    5
    ##                        mean         0  20   13
    ##                        meanFreq     0   8    5
    ##                        min          0  20   13
    ##                        skewness     0   8    5
    ##                        sma          0  10    7
    ##                        std          0  20   13

### Features by Statistic by prefix

``` r
with(features,table("features by statistic by prefix" = statistic, prefix))
```

    ##                                prefix
    ## features by statistic by prefix     Body Gravity
    ##                     angle         7    0       0
    ##                     arCoeff       0   64      16
    ##                     bandsEnergy   0  126       0
    ##                     correlation   0   12       3
    ##                     energy        0   29       4
    ##                     entropy       0   29       4
    ##                     iqr           0   29       4
    ##                     kurtosis      0   13       0
    ##                     mad           0   29       4
    ##                     max           0   29       4
    ##                     maxInds       0   13       0
    ##                     mean          0   29       4
    ##                     meanFreq      0   13       0
    ##                     min           0   29       4
    ##                     skewness      0   13       0
    ##                     sma           0   15       2
    ##                     std           0   29       4

### Features by Statistic by Jerk Suffix

``` r
with(features,table("features by statistic by jerkSuffix" = statistic, jerkSuffix))
```

    ##                                    jerkSuffix
    ## features by statistic by jerkSuffix    Jerk
    ##                         angle        7    0
    ##                         arCoeff     48   32
    ##                         bandsEnergy 84   42
    ##                         correlation  9    6
    ##                         energy      20   13
    ##                         entropy     20   13
    ##                         iqr         20   13
    ##                         kurtosis     8    5
    ##                         mad         20   13
    ##                         max         20   13
    ##                         maxInds      8    5
    ##                         mean        20   13
    ##                         meanFreq     8    5
    ##                         min         20   13
    ##                         skewness     8    5
    ##                         sma         10    7
    ##                         std         20   13

### Features by Statistic by Mag Suffix

``` r
with(features,table("features by statistic by magSuffix" = statistic, magSuffix))
```

    ##                                   magSuffix
    ## features by statistic by magSuffix     Mag
    ##                        angle         7   0
    ##                        arCoeff      60  20
    ##                        bandsEnergy 126   0
    ##                        correlation  15   0
    ##                        energy       24   9
    ##                        entropy      24   9
    ##                        iqr          24   9
    ##                        kurtosis      9   4
    ##                        mad          24   9
    ##                        max          24   9
    ##                        maxInds       9   4
    ##                        mean         24   9
    ##                        meanFreq      9   4
    ##                        min          24   9
    ##                        skewness      9   4
    ##                        sma           8   9
    ##                        std          24   9

### Features by domain,prefix,rawSignal,jerkSuffix,MagSuffix by Statistic

``` r
with(features[features$axis!="",],table("features by signal by statistic" = paste(domain, prefix, rawSignal, jerkSuffix, magSuffix,axisSep, axis, axesSep, axes), statistic))
```

    ##                                statistic
    ## features by signal by statistic arCoeff energy entropy iqr kurtosis mad
    ##         f Body Acc   - X              0      1       1   1        1   1
    ##         f Body Acc   - Y              0      1       1   1        1   1
    ##         f Body Acc   - Z              0      1       1   1        1   1
    ##         f Body Acc Jerk  - X          0      1       1   1        1   1
    ##         f Body Acc Jerk  - Y          0      1       1   1        1   1
    ##         f Body Acc Jerk  - Z          0      1       1   1        1   1
    ##         f Body Gyro   - X             0      1       1   1        1   1
    ##         f Body Gyro   - Y             0      1       1   1        1   1
    ##         f Body Gyro   - Z             0      1       1   1        1   1
    ##         t Body Acc   - X              4      1       1   1        0   1
    ##         t Body Acc   - Y              4      1       1   1        0   1
    ##         t Body Acc   - Z              4      1       1   1        0   1
    ##         t Body Acc Jerk  - X          4      1       1   1        0   1
    ##         t Body Acc Jerk  - Y          4      1       1   1        0   1
    ##         t Body Acc Jerk  - Z          4      1       1   1        0   1
    ##         t Body Gyro   - X             4      1       1   1        0   1
    ##         t Body Gyro   - Y             4      1       1   1        0   1
    ##         t Body Gyro   - Z             4      1       1   1        0   1
    ##         t Body Gyro Jerk  - X         4      1       1   1        0   1
    ##         t Body Gyro Jerk  - Y         4      1       1   1        0   1
    ##         t Body Gyro Jerk  - Z         4      1       1   1        0   1
    ##         t Gravity Acc   - X           4      1       1   1        0   1
    ##         t Gravity Acc   - Y           4      1       1   1        0   1
    ##         t Gravity Acc   - Z           4      1       1   1        0   1
    ##                                statistic
    ## features by signal by statistic max maxInds mean meanFreq min skewness std
    ##         f Body Acc   - X          1       1    1        1   1        1   1
    ##         f Body Acc   - Y          1       1    1        1   1        1   1
    ##         f Body Acc   - Z          1       1    1        1   1        1   1
    ##         f Body Acc Jerk  - X      1       1    1        1   1        1   1
    ##         f Body Acc Jerk  - Y      1       1    1        1   1        1   1
    ##         f Body Acc Jerk  - Z      1       1    1        1   1        1   1
    ##         f Body Gyro   - X         1       1    1        1   1        1   1
    ##         f Body Gyro   - Y         1       1    1        1   1        1   1
    ##         f Body Gyro   - Z         1       1    1        1   1        1   1
    ##         t Body Acc   - X          1       0    1        0   1        0   1
    ##         t Body Acc   - Y          1       0    1        0   1        0   1
    ##         t Body Acc   - Z          1       0    1        0   1        0   1
    ##         t Body Acc Jerk  - X      1       0    1        0   1        0   1
    ##         t Body Acc Jerk  - Y      1       0    1        0   1        0   1
    ##         t Body Acc Jerk  - Z      1       0    1        0   1        0   1
    ##         t Body Gyro   - X         1       0    1        0   1        0   1
    ##         t Body Gyro   - Y         1       0    1        0   1        0   1
    ##         t Body Gyro   - Z         1       0    1        0   1        0   1
    ##         t Body Gyro Jerk  - X     1       0    1        0   1        0   1
    ##         t Body Gyro Jerk  - Y     1       0    1        0   1        0   1
    ##         t Body Gyro Jerk  - Z     1       0    1        0   1        0   1
    ##         t Gravity Acc   - X       1       0    1        0   1        0   1
    ##         t Gravity Acc   - Y       1       0    1        0   1        0   1
    ##         t Gravity Acc   - Z       1       0    1        0   1        0   1

Other documentation
-------------------

### Time Magnitude Signal Pattern:

    timeMagnitudeSignal-statistic()
    signals:    tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag,
                tBodyGyroJerkMag
    statistics:  mean(), std(), mad(), max(), min(), sma(), energy(), iqr(),
                entropy()
    results:    5 signals X 9 statistics = 45

    timeMagnitudeSignal-statistic()level
    signals:    tBodyAccMag, tGravityAccMag, tBodyAccJerkMag,
                tBodyGyroMag, tBodyGyroJerkMag
    statistics:  arCoeff()
    levels:     1, 2, 3, 4
    results:    5 signals X 1 statistics X 4 levels = 20

### Frequency Magnitude Signal Pattern:

    frequencyMagnitudeSignal-statistic()
    signals:    fBodyAccMag, fBodyBodyAccJerkMag, fBodyBodyGyroMag,
                fBodyBodyGyroJerkMag
    statistics:  mean(), std(), mad(), max(), min(), sma(), energy(), iqr(),
                entropy() plus meanFreq(), skewness(), kurtosis()
    results:    4 signals X 12 statistics = 48

    frequencyMagnitudeSignal-statistic
    signals:    fBodyAccMag, fBodyBodyAccJerkMag, fBodyBodyGyroMag,
                fBodyBodyGyroJerkMag 
    statistics:   maxInds
    results:    4 signals X 1 statistics = 4

### Time Axial Signal Pattern:

    timeAxialSignal-statistic()
    signals:    tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk
    statistics:  sma()
    axis:       3-axial (XYZ)
    results:    5 3-axial-signals X 1 statistic = 5

    timeAxialSignal-statistic()-axis
    signals:    tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk
    statistics:  mean(), std(), mad(), max(), min(), energy(), iqr(), entropy()
    axis:       X, Y, Z
    results:    5 signals X 8 statistics X 3 axis = 120

    timeAxialSignal-statistic()-X,Y
    signals:    tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk
    statistics:   correlation()
    (axis:      X, Y)
    results:    5 signals X 1 statistic = 5

    timeAxialSignal-statistic()-Y,Z
    signals:    tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk
    statistics:   correlation()
    (axis:      Y, Z)
    results:    5 signals X 1 statistic = 5

    timeAxialSignal-statistic()-X,Z
    signals:    tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk
    statistics:   correlation()
    (axis:      X, Z)
    results:    5 signals X 1 statistic = 5

    timeAxialSignal-statistic()-axis,level
    signals:    tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk
    statistics:  arCoeff()
    axis:       X, Y, Z
    levels:     1, 2, 3, 4
    results:    5 signals X 1 statistic X 3 axis X 4 levels  = 60

### Frequency Axial Signal Pattern:

    frequencyAxialSignal-statistic()
    signals:    fBodyAcc, fBodyAccJerk, fBodyGyro
    statistics:  sma()
    axis:       3-axial (XYZ)
    results:    3 3-axial-signals X 1 statistic = 3

    frequencyAxialSignal-statistic-axis
    signals:    fBodyAcc, fBodyAccJerk, fBodyGyro
    statistics:  maxInds
    axis:       X, Y, Z
    results:    3 signals X 1 statistic X 3 axis = 9

    frequencyAxialSignal-statistic()-axis
    signals:    fBodyAcc, fBodyAccJerk, fBodyGyro
    statistics:  mean(), std(), mad(), max(), min(), energy(), iqr(), entropy(),
                meanFreq(), skewnewss(), kurtosis()
    axis:       X, Y, Z
    results:    3 signals X 11 X 3 axis = 99

### Frequency Interval Energy Signal Pattern:

    frequencyIntervalEnergySignal-statistic()-lower,upper
    signals:    fBodyAcc, fBodyAccJerk, fBodyGyro
    statistics:  bandsEnergy()
    axis:       3-axial (XYZ)
    interval series:
        8 in 64: [1,8],[9,16],[17,24],[25,32],[33,40],[41,48],[49,56],[57,64]
        4 in 64: [1,16],[17,32],[33,48],[49,64]
        2 in 48: [1,24],[25,48]
    results:    3 3-axial-signals X 1 statistic X 3 series X (8+4+2 levels)=126

### Angle Pattern

    angle(angleArgument,angleArgument)
    statistics:   angle()
    Arguments:  (tBodyAccMean,gravity)
                (tBodyAccJerkMean*)*,gravityMean)
                (tBodyGyroMean,gravityMean)
                (tBodyGyroJerkMean,gravityMean)
                (X,gravityMean)
                (Y,gravityMean)
                (Z,gravityMean)
    results:    1 statistic X 7 paired arguments = 7
