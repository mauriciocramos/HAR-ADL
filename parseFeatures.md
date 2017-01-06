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

``` r
## Experimental: Tidy signals splitting names in domain, prefix and suffix
signalsV0 <- signals %>%
    mutate(domain = gsub("^(t|f).*","\\1",name),
           prefix = gsub("^(t|f)|-XYZ$","",name), # must be gsub
           suffix = gsub(".+-|.+Mag$","",name)) %>%
    print
```

    ##                 name domain          prefix suffix
    ## 1       tBodyAcc-XYZ      t         BodyAcc    XYZ
    ## 2    tGravityAcc-XYZ      t      GravityAcc    XYZ
    ## 3   tBodyAccJerk-XYZ      t     BodyAccJerk    XYZ
    ## 4      tBodyGyro-XYZ      t        BodyGyro    XYZ
    ## 5  tBodyGyroJerk-XYZ      t    BodyGyroJerk    XYZ
    ## 6        tBodyAccMag      t      BodyAccMag       
    ## 7     tGravityAccMag      t   GravityAccMag       
    ## 8    tBodyAccJerkMag      t  BodyAccJerkMag       
    ## 9       tBodyGyroMag      t     BodyGyroMag       
    ## 10  tBodyGyroJerkMag      t BodyGyroJerkMag       
    ## 11      fBodyAcc-XYZ      f         BodyAcc    XYZ
    ## 12  fBodyAccJerk-XYZ      f     BodyAccJerk    XYZ
    ## 13     fBodyGyro-XYZ      f        BodyGyro    XYZ
    ## 14       fBodyAccMag      f      BodyAccMag       
    ## 15   fBodyAccJerkMag      f  BodyAccJerkMag       
    ## 16      fBodyGyroMag      f     BodyGyroMag       
    ## 17  fBodyGyroJerkMag      f BodyGyroJerkMag

Tidy signals:
-------------

``` r
signals <- 
signals %>%
    mutate(group = name,
           domain = sub("^(t|f).*","\\1",name),
           prefix = sub("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?(Mag)?(-XYZ)?","\\2",name),
           rawSignal = sub("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?(Mag)?(-XYZ)?","\\3",name),
           jerkSuffix = sub("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?(Mag)?(-XYZ)?","\\4",name),
           magSuffix = sub("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?(Mag)?(-XYZ)?","\\5",name),
           axisSep = sub("[a-zA-Z]+(-?).*","\\1",name),
           X1 = gsub(".+-|YZ$|.+Mag$","",name),
           X1 = sub("[a-zA-Z]+-?(X?)Y?Z?$","\\1",name),
           X2 = sub("[a-zA-Z]+-?X?(Y?)Z?$","\\1",name),
           X3 = sub("[a-zA-Z]+-?X?Y?(Z?)$","\\1",name)) %>%
    gather(X, axis, X1:X3) %>%
    mutate(X = NULL,
           name = paste0(domain, prefix, rawSignal, jerkSuffix, magSuffix, axisSep, axis)) %>%
    arrange(name) %>%
    distinct() %>%
    print
```

    ##                name             group domain  prefix rawSignal jerkSuffix
    ## 1        fBodyAcc-X      fBodyAcc-XYZ      f    Body       Acc           
    ## 2        fBodyAcc-Y      fBodyAcc-XYZ      f    Body       Acc           
    ## 3        fBodyAcc-Z      fBodyAcc-XYZ      f    Body       Acc           
    ## 4    fBodyAccJerk-X  fBodyAccJerk-XYZ      f    Body       Acc       Jerk
    ## 5    fBodyAccJerk-Y  fBodyAccJerk-XYZ      f    Body       Acc       Jerk
    ## 6    fBodyAccJerk-Z  fBodyAccJerk-XYZ      f    Body       Acc       Jerk
    ## 7   fBodyAccJerkMag   fBodyAccJerkMag      f    Body       Acc       Jerk
    ## 8       fBodyAccMag       fBodyAccMag      f    Body       Acc           
    ## 9       fBodyGyro-X     fBodyGyro-XYZ      f    Body      Gyro           
    ## 10      fBodyGyro-Y     fBodyGyro-XYZ      f    Body      Gyro           
    ## 11      fBodyGyro-Z     fBodyGyro-XYZ      f    Body      Gyro           
    ## 12 fBodyGyroJerkMag  fBodyGyroJerkMag      f    Body      Gyro       Jerk
    ## 13     fBodyGyroMag      fBodyGyroMag      f    Body      Gyro           
    ## 14       tBodyAcc-X      tBodyAcc-XYZ      t    Body       Acc           
    ## 15       tBodyAcc-Y      tBodyAcc-XYZ      t    Body       Acc           
    ## 16       tBodyAcc-Z      tBodyAcc-XYZ      t    Body       Acc           
    ## 17   tBodyAccJerk-X  tBodyAccJerk-XYZ      t    Body       Acc       Jerk
    ## 18   tBodyAccJerk-Y  tBodyAccJerk-XYZ      t    Body       Acc       Jerk
    ## 19   tBodyAccJerk-Z  tBodyAccJerk-XYZ      t    Body       Acc       Jerk
    ## 20  tBodyAccJerkMag   tBodyAccJerkMag      t    Body       Acc       Jerk
    ## 21      tBodyAccMag       tBodyAccMag      t    Body       Acc           
    ## 22      tBodyGyro-X     tBodyGyro-XYZ      t    Body      Gyro           
    ## 23      tBodyGyro-Y     tBodyGyro-XYZ      t    Body      Gyro           
    ## 24      tBodyGyro-Z     tBodyGyro-XYZ      t    Body      Gyro           
    ## 25  tBodyGyroJerk-X tBodyGyroJerk-XYZ      t    Body      Gyro       Jerk
    ## 26  tBodyGyroJerk-Y tBodyGyroJerk-XYZ      t    Body      Gyro       Jerk
    ## 27  tBodyGyroJerk-Z tBodyGyroJerk-XYZ      t    Body      Gyro       Jerk
    ## 28 tBodyGyroJerkMag  tBodyGyroJerkMag      t    Body      Gyro       Jerk
    ## 29     tBodyGyroMag      tBodyGyroMag      t    Body      Gyro           
    ## 30    tGravityAcc-X   tGravityAcc-XYZ      t Gravity       Acc           
    ## 31    tGravityAcc-Y   tGravityAcc-XYZ      t Gravity       Acc           
    ## 32    tGravityAcc-Z   tGravityAcc-XYZ      t Gravity       Acc           
    ## 33   tGravityAccMag    tGravityAccMag      t Gravity       Acc           
    ##    magSuffix axisSep axis
    ## 1                  -    X
    ## 2                  -    Y
    ## 3                  -    Z
    ## 4                  -    X
    ## 5                  -    Y
    ## 6                  -    Z
    ## 7        Mag             
    ## 8        Mag             
    ## 9                  -    X
    ## 10                 -    Y
    ## 11                 -    Z
    ## 12       Mag             
    ## 13       Mag             
    ## 14                 -    X
    ## 15                 -    Y
    ## 16                 -    Z
    ## 17                 -    X
    ## 18                 -    Y
    ## 19                 -    Z
    ## 20       Mag             
    ## 21       Mag             
    ## 22                 -    X
    ## 23                 -    Y
    ## 24                 -    Z
    ## 25                 -    X
    ## 26                 -    Y
    ## 27                 -    Z
    ## 28       Mag             
    ## 29       Mag             
    ## 30                 -    X
    ## 31                 -    Y
    ## 32                 -    Z
    ## 33       Mag

Feature patch
-------------

Fixing features containing bad-formed signal names:

    fBodyBodyAccJerkMag
    fBodyBodyGyroMag
    fBodyBodyGyroJerkMag

``` r
features[grepl("^fBodyBody", features$name), 'name'] <-
    sub("Body", "", features[grepl("^fBodyBody", features$name), 'name'])
```

Fixing feature angle(tBodyAccJerkMean),gravityMean) containing extra ")"

``` r
#TODO
```

fBodyAcc-bandsEnergy() duplicates: fBodyAcc-bandsEnergy()-1,16 : 3 fBodyAcc-bandsEnergy()-1,24 : 3 fBodyAcc-bandsEnergy()-1,8 : 3 fBodyAcc-bandsEnergy()-17,24: 3 fBodyAcc-bandsEnergy()-17,32: 3 fBodyAcc-bandsEnergy()-25,32: 3

``` r
#TODO
```

Tidier features:
----------------

``` r
features <- 
features %>%
    mutate(
        domain = gsub("^(t|f).*|.*","\\1",name),
        #deprecated: signalPrefix = sub("^([a-zA-Z]+)-.*|^.*","\\1",name),
        prefix = sub("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?(Mag)?.*|.*","\\2",name),
        rawSignal = sub("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?(Mag)?.*|.*","\\3",name),
        jerkSuffix = sub("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?(Mag)?.*|.*","\\4",name),
        magSuffix = sub("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?(Mag)?.*|.*","\\5",name),
        varSep = sub("^[a-zA-Z]+(-).*|^.*","\\1",name),
        variable = sub("^[a-zA-Z]+-([a-zA-Z]+).*|^(angle)\\(.*","\\1\\2",name),
        varOpenSep = sub("^[a-zA-Z]+-[a-zA-Z]+(\\(?).*|^angle(\\().*","\\1\\2",name),
        varCloseSep = sub("^[a-zA-Z]+-[a-zA-Z]+\\(?(\\)?).*|^angle\\(.*\\)?(\\))","\\1\\2",name),
        axisSep = sub("^[a-zA-Z]+-[a-zA-Z]+\\(?\\)?(-)([XYZ]){1},?[1-4]?|^.*","\\1",name),
        axis = sub("^[a-zA-Z]+-[a-zA-Z]+\\(?\\)?-([XYZ]){1},?[1-4]?$|^.*$","\\1",name),
        axesSep = sub("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?(-)(sma|correlation|bandsEnergy){1}\\(\\)-?([XY]?),?([YZ]?)[0-9]*,?[0-9]*$|^.*","\\5",name),
        axes = sub("^(t|f)(Body|Gravity)(Acc|Gyro)(Jerk)?-(sma|correlation|bandsEnergy){1}\\(\\)-?([XY]?),?([YZ]?)[0-9]*,?[0-9]*$|^.*","\\5\\6\\7",name),
        axes = sub("sma","XYZ",axes),
        axes = sub("correlation(XY|YZ|XZ){1}","\\1",axes),
        axes = sub("bandsEnergy","XYZ",axes),
        level = sub("^[a-zA-Z]+-[a-zA-Z]+\\(\\)-?[XYZ]?,?([1-4]){1}$|^.*$","\\1",name),
        corAxis1 = sub("^[a-zA-Z]+-correlation+\\(\\)-([XY]){1},([YZ]){1}$|^.*$","\\1",name),
        corAxis2 = sub("^[a-zA-Z]+-correlation+\\(\\)-([XY]){1},([YZ]){1}$|^.*$","\\2",name),
        lower = sub("^[a-zA-Z]+-bandsEnergy+\\(\\)-([0-9]+),([0-9]+)$|^.*$","\\1",name),
        upper = sub("^[a-zA-Z]+-bandsEnergy+\\(\\)-[0-9]+,([0-9]+)$|^.*$","\\1",name),
        angleArg1 = sub("^angle\\(([a-zA-Z]+)\\)?,([a-zA-Z]+)\\)|^.*$","\\1",name),
        angleArg2 = sub("^angle\\(([a-zA-Z]+)\\)?,([a-zA-Z]+)\\)|^.*$","\\2",name)
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
    ## 291 291                   fBodyAcc-maxInds-X      f    Body       Acc
    ## 292 292                   fBodyAcc-maxInds-Y      f    Body       Acc
    ## 293 293                   fBodyAcc-maxInds-Z      f    Body       Acc
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
    ## 370 370               fBodyAccJerk-maxInds-X      f    Body       Acc
    ## 371 371               fBodyAccJerk-maxInds-Y      f    Body       Acc
    ## 372 372               fBodyAccJerk-maxInds-Z      f    Body       Acc
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
    ## 449 449                  fBodyGyro-maxInds-X      f    Body      Gyro
    ## 450 450                  fBodyGyro-maxInds-Y      f    Body      Gyro
    ## 451 451                  fBodyGyro-maxInds-Z      f    Body      Gyro
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
    ## 512 512                  fBodyAccMag-maxInds      f    Body       Acc
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
    ## 525 525              fBodyAccJerkMag-maxInds      f    Body       Acc
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
    ## 538 538                 fBodyGyroMag-maxInds      f    Body      Gyro
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
    ## 551 551             fBodyGyroJerkMag-maxInds      f    Body      Gyro
    ## 552 552          fBodyGyroJerkMag-meanFreq()      f    Body      Gyro
    ## 553 553          fBodyGyroJerkMag-skewness()      f    Body      Gyro
    ## 554 554          fBodyGyroJerkMag-kurtosis()      f    Body      Gyro
    ## 555 555          angle(tBodyAccMean,gravity)                         
    ## 556 556 angle(tBodyAccJerkMean),gravityMean)                         
    ## 557 557     angle(tBodyGyroMean,gravityMean)                         
    ## 558 558 angle(tBodyGyroJerkMean,gravityMean)                         
    ## 559 559                 angle(X,gravityMean)                         
    ## 560 560                 angle(Y,gravityMean)                         
    ## 561 561                 angle(Z,gravityMean)                         
    ##     jerkSuffix magSuffix varSep    variable varOpenSep varCloseSep axisSep
    ## 1                             -        mean          (           )       -
    ## 2                             -        mean          (           )       -
    ## 3                             -        mean          (           )       -
    ## 4                             -         std          (           )       -
    ## 5                             -         std          (           )       -
    ## 6                             -         std          (           )       -
    ## 7                             -         mad          (           )       -
    ## 8                             -         mad          (           )       -
    ## 9                             -         mad          (           )       -
    ## 10                            -         max          (           )       -
    ## 11                            -         max          (           )       -
    ## 12                            -         max          (           )       -
    ## 13                            -         min          (           )       -
    ## 14                            -         min          (           )       -
    ## 15                            -         min          (           )       -
    ## 16                            -         sma          (           )        
    ## 17                            -      energy          (           )       -
    ## 18                            -      energy          (           )       -
    ## 19                            -      energy          (           )       -
    ## 20                            -         iqr          (           )       -
    ## 21                            -         iqr          (           )       -
    ## 22                            -         iqr          (           )       -
    ## 23                            -     entropy          (           )       -
    ## 24                            -     entropy          (           )       -
    ## 25                            -     entropy          (           )       -
    ## 26                            -     arCoeff          (           )       -
    ## 27                            -     arCoeff          (           )       -
    ## 28                            -     arCoeff          (           )       -
    ## 29                            -     arCoeff          (           )       -
    ## 30                            -     arCoeff          (           )       -
    ## 31                            -     arCoeff          (           )       -
    ## 32                            -     arCoeff          (           )       -
    ## 33                            -     arCoeff          (           )       -
    ## 34                            -     arCoeff          (           )       -
    ## 35                            -     arCoeff          (           )       -
    ## 36                            -     arCoeff          (           )       -
    ## 37                            -     arCoeff          (           )       -
    ## 38                            - correlation          (           )        
    ## 39                            - correlation          (           )        
    ## 40                            - correlation          (           )        
    ## 41                            -        mean          (           )       -
    ## 42                            -        mean          (           )       -
    ## 43                            -        mean          (           )       -
    ## 44                            -         std          (           )       -
    ## 45                            -         std          (           )       -
    ## 46                            -         std          (           )       -
    ## 47                            -         mad          (           )       -
    ## 48                            -         mad          (           )       -
    ## 49                            -         mad          (           )       -
    ## 50                            -         max          (           )       -
    ## 51                            -         max          (           )       -
    ## 52                            -         max          (           )       -
    ## 53                            -         min          (           )       -
    ## 54                            -         min          (           )       -
    ## 55                            -         min          (           )       -
    ## 56                            -         sma          (           )        
    ## 57                            -      energy          (           )       -
    ## 58                            -      energy          (           )       -
    ## 59                            -      energy          (           )       -
    ## 60                            -         iqr          (           )       -
    ## 61                            -         iqr          (           )       -
    ## 62                            -         iqr          (           )       -
    ## 63                            -     entropy          (           )       -
    ## 64                            -     entropy          (           )       -
    ## 65                            -     entropy          (           )       -
    ## 66                            -     arCoeff          (           )       -
    ## 67                            -     arCoeff          (           )       -
    ## 68                            -     arCoeff          (           )       -
    ## 69                            -     arCoeff          (           )       -
    ## 70                            -     arCoeff          (           )       -
    ## 71                            -     arCoeff          (           )       -
    ## 72                            -     arCoeff          (           )       -
    ## 73                            -     arCoeff          (           )       -
    ## 74                            -     arCoeff          (           )       -
    ## 75                            -     arCoeff          (           )       -
    ## 76                            -     arCoeff          (           )       -
    ## 77                            -     arCoeff          (           )       -
    ## 78                            - correlation          (           )        
    ## 79                            - correlation          (           )        
    ## 80                            - correlation          (           )        
    ## 81        Jerk                -        mean          (           )       -
    ## 82        Jerk                -        mean          (           )       -
    ## 83        Jerk                -        mean          (           )       -
    ## 84        Jerk                -         std          (           )       -
    ## 85        Jerk                -         std          (           )       -
    ## 86        Jerk                -         std          (           )       -
    ## 87        Jerk                -         mad          (           )       -
    ## 88        Jerk                -         mad          (           )       -
    ## 89        Jerk                -         mad          (           )       -
    ## 90        Jerk                -         max          (           )       -
    ## 91        Jerk                -         max          (           )       -
    ## 92        Jerk                -         max          (           )       -
    ## 93        Jerk                -         min          (           )       -
    ## 94        Jerk                -         min          (           )       -
    ## 95        Jerk                -         min          (           )       -
    ## 96        Jerk                -         sma          (           )        
    ## 97        Jerk                -      energy          (           )       -
    ## 98        Jerk                -      energy          (           )       -
    ## 99        Jerk                -      energy          (           )       -
    ## 100       Jerk                -         iqr          (           )       -
    ## 101       Jerk                -         iqr          (           )       -
    ## 102       Jerk                -         iqr          (           )       -
    ## 103       Jerk                -     entropy          (           )       -
    ## 104       Jerk                -     entropy          (           )       -
    ## 105       Jerk                -     entropy          (           )       -
    ## 106       Jerk                -     arCoeff          (           )       -
    ## 107       Jerk                -     arCoeff          (           )       -
    ## 108       Jerk                -     arCoeff          (           )       -
    ## 109       Jerk                -     arCoeff          (           )       -
    ## 110       Jerk                -     arCoeff          (           )       -
    ## 111       Jerk                -     arCoeff          (           )       -
    ## 112       Jerk                -     arCoeff          (           )       -
    ## 113       Jerk                -     arCoeff          (           )       -
    ## 114       Jerk                -     arCoeff          (           )       -
    ## 115       Jerk                -     arCoeff          (           )       -
    ## 116       Jerk                -     arCoeff          (           )       -
    ## 117       Jerk                -     arCoeff          (           )       -
    ## 118       Jerk                - correlation          (           )        
    ## 119       Jerk                - correlation          (           )        
    ## 120       Jerk                - correlation          (           )        
    ## 121                           -        mean          (           )       -
    ## 122                           -        mean          (           )       -
    ## 123                           -        mean          (           )       -
    ## 124                           -         std          (           )       -
    ## 125                           -         std          (           )       -
    ## 126                           -         std          (           )       -
    ## 127                           -         mad          (           )       -
    ## 128                           -         mad          (           )       -
    ## 129                           -         mad          (           )       -
    ## 130                           -         max          (           )       -
    ## 131                           -         max          (           )       -
    ## 132                           -         max          (           )       -
    ## 133                           -         min          (           )       -
    ## 134                           -         min          (           )       -
    ## 135                           -         min          (           )       -
    ## 136                           -         sma          (           )        
    ## 137                           -      energy          (           )       -
    ## 138                           -      energy          (           )       -
    ## 139                           -      energy          (           )       -
    ## 140                           -         iqr          (           )       -
    ## 141                           -         iqr          (           )       -
    ## 142                           -         iqr          (           )       -
    ## 143                           -     entropy          (           )       -
    ## 144                           -     entropy          (           )       -
    ## 145                           -     entropy          (           )       -
    ## 146                           -     arCoeff          (           )       -
    ## 147                           -     arCoeff          (           )       -
    ## 148                           -     arCoeff          (           )       -
    ## 149                           -     arCoeff          (           )       -
    ## 150                           -     arCoeff          (           )       -
    ## 151                           -     arCoeff          (           )       -
    ## 152                           -     arCoeff          (           )       -
    ## 153                           -     arCoeff          (           )       -
    ## 154                           -     arCoeff          (           )       -
    ## 155                           -     arCoeff          (           )       -
    ## 156                           -     arCoeff          (           )       -
    ## 157                           -     arCoeff          (           )       -
    ## 158                           - correlation          (           )        
    ## 159                           - correlation          (           )        
    ## 160                           - correlation          (           )        
    ## 161       Jerk                -        mean          (           )       -
    ## 162       Jerk                -        mean          (           )       -
    ## 163       Jerk                -        mean          (           )       -
    ## 164       Jerk                -         std          (           )       -
    ## 165       Jerk                -         std          (           )       -
    ## 166       Jerk                -         std          (           )       -
    ## 167       Jerk                -         mad          (           )       -
    ## 168       Jerk                -         mad          (           )       -
    ## 169       Jerk                -         mad          (           )       -
    ## 170       Jerk                -         max          (           )       -
    ## 171       Jerk                -         max          (           )       -
    ## 172       Jerk                -         max          (           )       -
    ## 173       Jerk                -         min          (           )       -
    ## 174       Jerk                -         min          (           )       -
    ## 175       Jerk                -         min          (           )       -
    ## 176       Jerk                -         sma          (           )        
    ## 177       Jerk                -      energy          (           )       -
    ## 178       Jerk                -      energy          (           )       -
    ## 179       Jerk                -      energy          (           )       -
    ## 180       Jerk                -         iqr          (           )       -
    ## 181       Jerk                -         iqr          (           )       -
    ## 182       Jerk                -         iqr          (           )       -
    ## 183       Jerk                -     entropy          (           )       -
    ## 184       Jerk                -     entropy          (           )       -
    ## 185       Jerk                -     entropy          (           )       -
    ## 186       Jerk                -     arCoeff          (           )       -
    ## 187       Jerk                -     arCoeff          (           )       -
    ## 188       Jerk                -     arCoeff          (           )       -
    ## 189       Jerk                -     arCoeff          (           )       -
    ## 190       Jerk                -     arCoeff          (           )       -
    ## 191       Jerk                -     arCoeff          (           )       -
    ## 192       Jerk                -     arCoeff          (           )       -
    ## 193       Jerk                -     arCoeff          (           )       -
    ## 194       Jerk                -     arCoeff          (           )       -
    ## 195       Jerk                -     arCoeff          (           )       -
    ## 196       Jerk                -     arCoeff          (           )       -
    ## 197       Jerk                -     arCoeff          (           )       -
    ## 198       Jerk                - correlation          (           )        
    ## 199       Jerk                - correlation          (           )        
    ## 200       Jerk                - correlation          (           )        
    ## 201                  Mag      -        mean          (           )        
    ## 202                  Mag      -         std          (           )        
    ## 203                  Mag      -         mad          (           )        
    ## 204                  Mag      -         max          (           )        
    ## 205                  Mag      -         min          (           )        
    ## 206                  Mag      -         sma          (           )        
    ## 207                  Mag      -      energy          (           )        
    ## 208                  Mag      -         iqr          (           )        
    ## 209                  Mag      -     entropy          (           )        
    ## 210                  Mag      -     arCoeff          (           )        
    ## 211                  Mag      -     arCoeff          (           )        
    ## 212                  Mag      -     arCoeff          (           )        
    ## 213                  Mag      -     arCoeff          (           )        
    ## 214                  Mag      -        mean          (           )        
    ## 215                  Mag      -         std          (           )        
    ## 216                  Mag      -         mad          (           )        
    ## 217                  Mag      -         max          (           )        
    ## 218                  Mag      -         min          (           )        
    ## 219                  Mag      -         sma          (           )        
    ## 220                  Mag      -      energy          (           )        
    ## 221                  Mag      -         iqr          (           )        
    ## 222                  Mag      -     entropy          (           )        
    ## 223                  Mag      -     arCoeff          (           )        
    ## 224                  Mag      -     arCoeff          (           )        
    ## 225                  Mag      -     arCoeff          (           )        
    ## 226                  Mag      -     arCoeff          (           )        
    ## 227       Jerk       Mag      -        mean          (           )        
    ## 228       Jerk       Mag      -         std          (           )        
    ## 229       Jerk       Mag      -         mad          (           )        
    ## 230       Jerk       Mag      -         max          (           )        
    ## 231       Jerk       Mag      -         min          (           )        
    ## 232       Jerk       Mag      -         sma          (           )        
    ## 233       Jerk       Mag      -      energy          (           )        
    ## 234       Jerk       Mag      -         iqr          (           )        
    ## 235       Jerk       Mag      -     entropy          (           )        
    ## 236       Jerk       Mag      -     arCoeff          (           )        
    ## 237       Jerk       Mag      -     arCoeff          (           )        
    ## 238       Jerk       Mag      -     arCoeff          (           )        
    ## 239       Jerk       Mag      -     arCoeff          (           )        
    ## 240                  Mag      -        mean          (           )        
    ## 241                  Mag      -         std          (           )        
    ## 242                  Mag      -         mad          (           )        
    ## 243                  Mag      -         max          (           )        
    ## 244                  Mag      -         min          (           )        
    ## 245                  Mag      -         sma          (           )        
    ## 246                  Mag      -      energy          (           )        
    ## 247                  Mag      -         iqr          (           )        
    ## 248                  Mag      -     entropy          (           )        
    ## 249                  Mag      -     arCoeff          (           )        
    ## 250                  Mag      -     arCoeff          (           )        
    ## 251                  Mag      -     arCoeff          (           )        
    ## 252                  Mag      -     arCoeff          (           )        
    ## 253       Jerk       Mag      -        mean          (           )        
    ## 254       Jerk       Mag      -         std          (           )        
    ## 255       Jerk       Mag      -         mad          (           )        
    ## 256       Jerk       Mag      -         max          (           )        
    ## 257       Jerk       Mag      -         min          (           )        
    ## 258       Jerk       Mag      -         sma          (           )        
    ## 259       Jerk       Mag      -      energy          (           )        
    ## 260       Jerk       Mag      -         iqr          (           )        
    ## 261       Jerk       Mag      -     entropy          (           )        
    ## 262       Jerk       Mag      -     arCoeff          (           )        
    ## 263       Jerk       Mag      -     arCoeff          (           )        
    ## 264       Jerk       Mag      -     arCoeff          (           )        
    ## 265       Jerk       Mag      -     arCoeff          (           )        
    ## 266                           -        mean          (           )       -
    ## 267                           -        mean          (           )       -
    ## 268                           -        mean          (           )       -
    ## 269                           -         std          (           )       -
    ## 270                           -         std          (           )       -
    ## 271                           -         std          (           )       -
    ## 272                           -         mad          (           )       -
    ## 273                           -         mad          (           )       -
    ## 274                           -         mad          (           )       -
    ## 275                           -         max          (           )       -
    ## 276                           -         max          (           )       -
    ## 277                           -         max          (           )       -
    ## 278                           -         min          (           )       -
    ## 279                           -         min          (           )       -
    ## 280                           -         min          (           )       -
    ## 281                           -         sma          (           )        
    ## 282                           -      energy          (           )       -
    ## 283                           -      energy          (           )       -
    ## 284                           -      energy          (           )       -
    ## 285                           -         iqr          (           )       -
    ## 286                           -         iqr          (           )       -
    ## 287                           -         iqr          (           )       -
    ## 288                           -     entropy          (           )       -
    ## 289                           -     entropy          (           )       -
    ## 290                           -     entropy          (           )       -
    ## 291                           -     maxInds                              -
    ## 292                           -     maxInds                              -
    ## 293                           -     maxInds                              -
    ## 294                           -    meanFreq          (           )       -
    ## 295                           -    meanFreq          (           )       -
    ## 296                           -    meanFreq          (           )       -
    ## 297                           -    skewness          (           )       -
    ## 298                           -    kurtosis          (           )       -
    ## 299                           -    skewness          (           )       -
    ## 300                           -    kurtosis          (           )       -
    ## 301                           -    skewness          (           )       -
    ## 302                           -    kurtosis          (           )       -
    ## 303                           - bandsEnergy          (           )        
    ## 304                           - bandsEnergy          (           )        
    ## 305                           - bandsEnergy          (           )        
    ## 306                           - bandsEnergy          (           )        
    ## 307                           - bandsEnergy          (           )        
    ## 308                           - bandsEnergy          (           )        
    ## 309                           - bandsEnergy          (           )        
    ## 310                           - bandsEnergy          (           )        
    ## 311                           - bandsEnergy          (           )        
    ## 312                           - bandsEnergy          (           )        
    ## 313                           - bandsEnergy          (           )        
    ## 314                           - bandsEnergy          (           )        
    ## 315                           - bandsEnergy          (           )        
    ## 316                           - bandsEnergy          (           )        
    ## 317                           - bandsEnergy          (           )        
    ## 318                           - bandsEnergy          (           )        
    ## 319                           - bandsEnergy          (           )        
    ## 320                           - bandsEnergy          (           )        
    ## 321                           - bandsEnergy          (           )        
    ## 322                           - bandsEnergy          (           )        
    ## 323                           - bandsEnergy          (           )        
    ## 324                           - bandsEnergy          (           )        
    ## 325                           - bandsEnergy          (           )        
    ## 326                           - bandsEnergy          (           )        
    ## 327                           - bandsEnergy          (           )        
    ## 328                           - bandsEnergy          (           )        
    ## 329                           - bandsEnergy          (           )        
    ## 330                           - bandsEnergy          (           )        
    ## 331                           - bandsEnergy          (           )        
    ## 332                           - bandsEnergy          (           )        
    ## 333                           - bandsEnergy          (           )        
    ## 334                           - bandsEnergy          (           )        
    ## 335                           - bandsEnergy          (           )        
    ## 336                           - bandsEnergy          (           )        
    ## 337                           - bandsEnergy          (           )        
    ## 338                           - bandsEnergy          (           )        
    ## 339                           - bandsEnergy          (           )        
    ## 340                           - bandsEnergy          (           )        
    ## 341                           - bandsEnergy          (           )        
    ## 342                           - bandsEnergy          (           )        
    ## 343                           - bandsEnergy          (           )        
    ## 344                           - bandsEnergy          (           )        
    ## 345       Jerk                -        mean          (           )       -
    ## 346       Jerk                -        mean          (           )       -
    ## 347       Jerk                -        mean          (           )       -
    ## 348       Jerk                -         std          (           )       -
    ## 349       Jerk                -         std          (           )       -
    ## 350       Jerk                -         std          (           )       -
    ## 351       Jerk                -         mad          (           )       -
    ## 352       Jerk                -         mad          (           )       -
    ## 353       Jerk                -         mad          (           )       -
    ## 354       Jerk                -         max          (           )       -
    ## 355       Jerk                -         max          (           )       -
    ## 356       Jerk                -         max          (           )       -
    ## 357       Jerk                -         min          (           )       -
    ## 358       Jerk                -         min          (           )       -
    ## 359       Jerk                -         min          (           )       -
    ## 360       Jerk                -         sma          (           )        
    ## 361       Jerk                -      energy          (           )       -
    ## 362       Jerk                -      energy          (           )       -
    ## 363       Jerk                -      energy          (           )       -
    ## 364       Jerk                -         iqr          (           )       -
    ## 365       Jerk                -         iqr          (           )       -
    ## 366       Jerk                -         iqr          (           )       -
    ## 367       Jerk                -     entropy          (           )       -
    ## 368       Jerk                -     entropy          (           )       -
    ## 369       Jerk                -     entropy          (           )       -
    ## 370       Jerk                -     maxInds                              -
    ## 371       Jerk                -     maxInds                              -
    ## 372       Jerk                -     maxInds                              -
    ## 373       Jerk                -    meanFreq          (           )       -
    ## 374       Jerk                -    meanFreq          (           )       -
    ## 375       Jerk                -    meanFreq          (           )       -
    ## 376       Jerk                -    skewness          (           )       -
    ## 377       Jerk                -    kurtosis          (           )       -
    ## 378       Jerk                -    skewness          (           )       -
    ## 379       Jerk                -    kurtosis          (           )       -
    ## 380       Jerk                -    skewness          (           )       -
    ## 381       Jerk                -    kurtosis          (           )       -
    ## 382       Jerk                - bandsEnergy          (           )        
    ## 383       Jerk                - bandsEnergy          (           )        
    ## 384       Jerk                - bandsEnergy          (           )        
    ## 385       Jerk                - bandsEnergy          (           )        
    ## 386       Jerk                - bandsEnergy          (           )        
    ## 387       Jerk                - bandsEnergy          (           )        
    ## 388       Jerk                - bandsEnergy          (           )        
    ## 389       Jerk                - bandsEnergy          (           )        
    ## 390       Jerk                - bandsEnergy          (           )        
    ## 391       Jerk                - bandsEnergy          (           )        
    ## 392       Jerk                - bandsEnergy          (           )        
    ## 393       Jerk                - bandsEnergy          (           )        
    ## 394       Jerk                - bandsEnergy          (           )        
    ## 395       Jerk                - bandsEnergy          (           )        
    ## 396       Jerk                - bandsEnergy          (           )        
    ## 397       Jerk                - bandsEnergy          (           )        
    ## 398       Jerk                - bandsEnergy          (           )        
    ## 399       Jerk                - bandsEnergy          (           )        
    ## 400       Jerk                - bandsEnergy          (           )        
    ## 401       Jerk                - bandsEnergy          (           )        
    ## 402       Jerk                - bandsEnergy          (           )        
    ## 403       Jerk                - bandsEnergy          (           )        
    ## 404       Jerk                - bandsEnergy          (           )        
    ## 405       Jerk                - bandsEnergy          (           )        
    ## 406       Jerk                - bandsEnergy          (           )        
    ## 407       Jerk                - bandsEnergy          (           )        
    ## 408       Jerk                - bandsEnergy          (           )        
    ## 409       Jerk                - bandsEnergy          (           )        
    ## 410       Jerk                - bandsEnergy          (           )        
    ## 411       Jerk                - bandsEnergy          (           )        
    ## 412       Jerk                - bandsEnergy          (           )        
    ## 413       Jerk                - bandsEnergy          (           )        
    ## 414       Jerk                - bandsEnergy          (           )        
    ## 415       Jerk                - bandsEnergy          (           )        
    ## 416       Jerk                - bandsEnergy          (           )        
    ## 417       Jerk                - bandsEnergy          (           )        
    ## 418       Jerk                - bandsEnergy          (           )        
    ## 419       Jerk                - bandsEnergy          (           )        
    ## 420       Jerk                - bandsEnergy          (           )        
    ## 421       Jerk                - bandsEnergy          (           )        
    ## 422       Jerk                - bandsEnergy          (           )        
    ## 423       Jerk                - bandsEnergy          (           )        
    ## 424                           -        mean          (           )       -
    ## 425                           -        mean          (           )       -
    ## 426                           -        mean          (           )       -
    ## 427                           -         std          (           )       -
    ## 428                           -         std          (           )       -
    ## 429                           -         std          (           )       -
    ## 430                           -         mad          (           )       -
    ## 431                           -         mad          (           )       -
    ## 432                           -         mad          (           )       -
    ## 433                           -         max          (           )       -
    ## 434                           -         max          (           )       -
    ## 435                           -         max          (           )       -
    ## 436                           -         min          (           )       -
    ## 437                           -         min          (           )       -
    ## 438                           -         min          (           )       -
    ## 439                           -         sma          (           )        
    ## 440                           -      energy          (           )       -
    ## 441                           -      energy          (           )       -
    ## 442                           -      energy          (           )       -
    ## 443                           -         iqr          (           )       -
    ## 444                           -         iqr          (           )       -
    ## 445                           -         iqr          (           )       -
    ## 446                           -     entropy          (           )       -
    ## 447                           -     entropy          (           )       -
    ## 448                           -     entropy          (           )       -
    ## 449                           -     maxInds                              -
    ## 450                           -     maxInds                              -
    ## 451                           -     maxInds                              -
    ## 452                           -    meanFreq          (           )       -
    ## 453                           -    meanFreq          (           )       -
    ## 454                           -    meanFreq          (           )       -
    ## 455                           -    skewness          (           )       -
    ## 456                           -    kurtosis          (           )       -
    ## 457                           -    skewness          (           )       -
    ## 458                           -    kurtosis          (           )       -
    ## 459                           -    skewness          (           )       -
    ## 460                           -    kurtosis          (           )       -
    ## 461                           - bandsEnergy          (           )        
    ## 462                           - bandsEnergy          (           )        
    ## 463                           - bandsEnergy          (           )        
    ## 464                           - bandsEnergy          (           )        
    ## 465                           - bandsEnergy          (           )        
    ## 466                           - bandsEnergy          (           )        
    ## 467                           - bandsEnergy          (           )        
    ## 468                           - bandsEnergy          (           )        
    ## 469                           - bandsEnergy          (           )        
    ## 470                           - bandsEnergy          (           )        
    ## 471                           - bandsEnergy          (           )        
    ## 472                           - bandsEnergy          (           )        
    ## 473                           - bandsEnergy          (           )        
    ## 474                           - bandsEnergy          (           )        
    ## 475                           - bandsEnergy          (           )        
    ## 476                           - bandsEnergy          (           )        
    ## 477                           - bandsEnergy          (           )        
    ## 478                           - bandsEnergy          (           )        
    ## 479                           - bandsEnergy          (           )        
    ## 480                           - bandsEnergy          (           )        
    ## 481                           - bandsEnergy          (           )        
    ## 482                           - bandsEnergy          (           )        
    ## 483                           - bandsEnergy          (           )        
    ## 484                           - bandsEnergy          (           )        
    ## 485                           - bandsEnergy          (           )        
    ## 486                           - bandsEnergy          (           )        
    ## 487                           - bandsEnergy          (           )        
    ## 488                           - bandsEnergy          (           )        
    ## 489                           - bandsEnergy          (           )        
    ## 490                           - bandsEnergy          (           )        
    ## 491                           - bandsEnergy          (           )        
    ## 492                           - bandsEnergy          (           )        
    ## 493                           - bandsEnergy          (           )        
    ## 494                           - bandsEnergy          (           )        
    ## 495                           - bandsEnergy          (           )        
    ## 496                           - bandsEnergy          (           )        
    ## 497                           - bandsEnergy          (           )        
    ## 498                           - bandsEnergy          (           )        
    ## 499                           - bandsEnergy          (           )        
    ## 500                           - bandsEnergy          (           )        
    ## 501                           - bandsEnergy          (           )        
    ## 502                           - bandsEnergy          (           )        
    ## 503                  Mag      -        mean          (           )        
    ## 504                  Mag      -         std          (           )        
    ## 505                  Mag      -         mad          (           )        
    ## 506                  Mag      -         max          (           )        
    ## 507                  Mag      -         min          (           )        
    ## 508                  Mag      -         sma          (           )        
    ## 509                  Mag      -      energy          (           )        
    ## 510                  Mag      -         iqr          (           )        
    ## 511                  Mag      -     entropy          (           )        
    ## 512                  Mag      -     maxInds                               
    ## 513                  Mag      -    meanFreq          (           )        
    ## 514                  Mag      -    skewness          (           )        
    ## 515                  Mag      -    kurtosis          (           )        
    ## 516       Jerk       Mag      -        mean          (           )        
    ## 517       Jerk       Mag      -         std          (           )        
    ## 518       Jerk       Mag      -         mad          (           )        
    ## 519       Jerk       Mag      -         max          (           )        
    ## 520       Jerk       Mag      -         min          (           )        
    ## 521       Jerk       Mag      -         sma          (           )        
    ## 522       Jerk       Mag      -      energy          (           )        
    ## 523       Jerk       Mag      -         iqr          (           )        
    ## 524       Jerk       Mag      -     entropy          (           )        
    ## 525       Jerk       Mag      -     maxInds                               
    ## 526       Jerk       Mag      -    meanFreq          (           )        
    ## 527       Jerk       Mag      -    skewness          (           )        
    ## 528       Jerk       Mag      -    kurtosis          (           )        
    ## 529                  Mag      -        mean          (           )        
    ## 530                  Mag      -         std          (           )        
    ## 531                  Mag      -         mad          (           )        
    ## 532                  Mag      -         max          (           )        
    ## 533                  Mag      -         min          (           )        
    ## 534                  Mag      -         sma          (           )        
    ## 535                  Mag      -      energy          (           )        
    ## 536                  Mag      -         iqr          (           )        
    ## 537                  Mag      -     entropy          (           )        
    ## 538                  Mag      -     maxInds                               
    ## 539                  Mag      -    meanFreq          (           )        
    ## 540                  Mag      -    skewness          (           )        
    ## 541                  Mag      -    kurtosis          (           )        
    ## 542       Jerk       Mag      -        mean          (           )        
    ## 543       Jerk       Mag      -         std          (           )        
    ## 544       Jerk       Mag      -         mad          (           )        
    ## 545       Jerk       Mag      -         max          (           )        
    ## 546       Jerk       Mag      -         min          (           )        
    ## 547       Jerk       Mag      -         sma          (           )        
    ## 548       Jerk       Mag      -      energy          (           )        
    ## 549       Jerk       Mag      -         iqr          (           )        
    ## 550       Jerk       Mag      -     entropy          (           )        
    ## 551       Jerk       Mag      -     maxInds                               
    ## 552       Jerk       Mag      -    meanFreq          (           )        
    ## 553       Jerk       Mag      -    skewness          (           )        
    ## 554       Jerk       Mag      -    kurtosis          (           )        
    ## 555                                   angle          (           )        
    ## 556                                   angle          (           )        
    ## 557                                   angle          (           )        
    ## 558                                   angle          (           )        
    ## 559                                   angle          (           )        
    ## 560                                   angle          (           )        
    ## 561                                   angle          (           )        
    ##     axis axesSep axes level corAxis1 corAxis2 lower upper
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
    ## 26     X                  1                              
    ## 27     X                  2                              
    ## 28     X                  3                              
    ## 29     X                  4                              
    ## 30     Y                  1                              
    ## 31     Y                  2                              
    ## 32     Y                  3                              
    ## 33     Y                  4                              
    ## 34     Z                  1                              
    ## 35     Z                  2                              
    ## 36     Z                  3                              
    ## 37     Z                  4                              
    ## 38             -   XY              X        Y            
    ## 39             -   XZ              X        Z            
    ## 40             -   YZ              Y        Z            
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
    ## 66     X                  1                              
    ## 67     X                  2                              
    ## 68     X                  3                              
    ## 69     X                  4                              
    ## 70     Y                  1                              
    ## 71     Y                  2                              
    ## 72     Y                  3                              
    ## 73     Y                  4                              
    ## 74     Z                  1                              
    ## 75     Z                  2                              
    ## 76     Z                  3                              
    ## 77     Z                  4                              
    ## 78             -   XY              X        Y            
    ## 79             -   XZ              X        Z            
    ## 80             -   YZ              Y        Z            
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
    ## 106    X                  1                              
    ## 107    X                  2                              
    ## 108    X                  3                              
    ## 109    X                  4                              
    ## 110    Y                  1                              
    ## 111    Y                  2                              
    ## 112    Y                  3                              
    ## 113    Y                  4                              
    ## 114    Z                  1                              
    ## 115    Z                  2                              
    ## 116    Z                  3                              
    ## 117    Z                  4                              
    ## 118            -   XY              X        Y            
    ## 119            -   XZ              X        Z            
    ## 120            -   YZ              Y        Z            
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
    ## 146    X                  1                              
    ## 147    X                  2                              
    ## 148    X                  3                              
    ## 149    X                  4                              
    ## 150    Y                  1                              
    ## 151    Y                  2                              
    ## 152    Y                  3                              
    ## 153    Y                  4                              
    ## 154    Z                  1                              
    ## 155    Z                  2                              
    ## 156    Z                  3                              
    ## 157    Z                  4                              
    ## 158            -   XY              X        Y            
    ## 159            -   XZ              X        Z            
    ## 160            -   YZ              Y        Z            
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
    ## 186    X                  1                              
    ## 187    X                  2                              
    ## 188    X                  3                              
    ## 189    X                  4                              
    ## 190    Y                  1                              
    ## 191    Y                  2                              
    ## 192    Y                  3                              
    ## 193    Y                  4                              
    ## 194    Z                  1                              
    ## 195    Z                  2                              
    ## 196    Z                  3                              
    ## 197    Z                  4                              
    ## 198            -   XY              X        Y            
    ## 199            -   XZ              X        Z            
    ## 200            -   YZ              Y        Z            
    ## 201                                                      
    ## 202                                                      
    ## 203                                                      
    ## 204                                                      
    ## 205                                                      
    ## 206                                                      
    ## 207                                                      
    ## 208                                                      
    ## 209                                                      
    ## 210                       1                              
    ## 211                       2                              
    ## 212                       3                              
    ## 213                       4                              
    ## 214                                                      
    ## 215                                                      
    ## 216                                                      
    ## 217                                                      
    ## 218                                                      
    ## 219                                                      
    ## 220                                                      
    ## 221                                                      
    ## 222                                                      
    ## 223                       1                              
    ## 224                       2                              
    ## 225                       3                              
    ## 226                       4                              
    ## 227                                                      
    ## 228                                                      
    ## 229                                                      
    ## 230                                                      
    ## 231                                                      
    ## 232                                                      
    ## 233                                                      
    ## 234                                                      
    ## 235                                                      
    ## 236                       1                              
    ## 237                       2                              
    ## 238                       3                              
    ## 239                       4                              
    ## 240                                                      
    ## 241                                                      
    ## 242                                                      
    ## 243                                                      
    ## 244                                                      
    ## 245                                                      
    ## 246                                                      
    ## 247                                                      
    ## 248                                                      
    ## 249                       1                              
    ## 250                       2                              
    ## 251                       3                              
    ## 252                       4                              
    ## 253                                                      
    ## 254                                                      
    ## 255                                                      
    ## 256                                                      
    ## 257                                                      
    ## 258                                                      
    ## 259                                                      
    ## 260                                                      
    ## 261                                                      
    ## 262                       1                              
    ## 263                       2                              
    ## 264                       3                              
    ## 265                       4                              
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
    ## 303            -  XYZ                             1     8
    ## 304            -  XYZ                             9    16
    ## 305            -  XYZ                            17    24
    ## 306            -  XYZ                            25    32
    ## 307            -  XYZ                            33    40
    ## 308            -  XYZ                            41    48
    ## 309            -  XYZ                            49    56
    ## 310            -  XYZ                            57    64
    ## 311            -  XYZ                             1    16
    ## 312            -  XYZ                            17    32
    ## 313            -  XYZ                            33    48
    ## 314            -  XYZ                            49    64
    ## 315            -  XYZ                             1    24
    ## 316            -  XYZ                            25    48
    ## 317            -  XYZ                             1     8
    ## 318            -  XYZ                             9    16
    ## 319            -  XYZ                            17    24
    ## 320            -  XYZ                            25    32
    ## 321            -  XYZ                            33    40
    ## 322            -  XYZ                            41    48
    ## 323            -  XYZ                            49    56
    ## 324            -  XYZ                            57    64
    ## 325            -  XYZ                             1    16
    ## 326            -  XYZ                            17    32
    ## 327            -  XYZ                            33    48
    ## 328            -  XYZ                            49    64
    ## 329            -  XYZ                             1    24
    ## 330            -  XYZ                            25    48
    ## 331            -  XYZ                             1     8
    ## 332            -  XYZ                             9    16
    ## 333            -  XYZ                            17    24
    ## 334            -  XYZ                            25    32
    ## 335            -  XYZ                            33    40
    ## 336            -  XYZ                            41    48
    ## 337            -  XYZ                            49    56
    ## 338            -  XYZ                            57    64
    ## 339            -  XYZ                             1    16
    ## 340            -  XYZ                            17    32
    ## 341            -  XYZ                            33    48
    ## 342            -  XYZ                            49    64
    ## 343            -  XYZ                             1    24
    ## 344            -  XYZ                            25    48
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
    ## 382            -  XYZ                             1     8
    ## 383            -  XYZ                             9    16
    ## 384            -  XYZ                            17    24
    ## 385            -  XYZ                            25    32
    ## 386            -  XYZ                            33    40
    ## 387            -  XYZ                            41    48
    ## 388            -  XYZ                            49    56
    ## 389            -  XYZ                            57    64
    ## 390            -  XYZ                             1    16
    ## 391            -  XYZ                            17    32
    ## 392            -  XYZ                            33    48
    ## 393            -  XYZ                            49    64
    ## 394            -  XYZ                             1    24
    ## 395            -  XYZ                            25    48
    ## 396            -  XYZ                             1     8
    ## 397            -  XYZ                             9    16
    ## 398            -  XYZ                            17    24
    ## 399            -  XYZ                            25    32
    ## 400            -  XYZ                            33    40
    ## 401            -  XYZ                            41    48
    ## 402            -  XYZ                            49    56
    ## 403            -  XYZ                            57    64
    ## 404            -  XYZ                             1    16
    ## 405            -  XYZ                            17    32
    ## 406            -  XYZ                            33    48
    ## 407            -  XYZ                            49    64
    ## 408            -  XYZ                             1    24
    ## 409            -  XYZ                            25    48
    ## 410            -  XYZ                             1     8
    ## 411            -  XYZ                             9    16
    ## 412            -  XYZ                            17    24
    ## 413            -  XYZ                            25    32
    ## 414            -  XYZ                            33    40
    ## 415            -  XYZ                            41    48
    ## 416            -  XYZ                            49    56
    ## 417            -  XYZ                            57    64
    ## 418            -  XYZ                             1    16
    ## 419            -  XYZ                            17    32
    ## 420            -  XYZ                            33    48
    ## 421            -  XYZ                            49    64
    ## 422            -  XYZ                             1    24
    ## 423            -  XYZ                            25    48
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
    ## 461            -  XYZ                             1     8
    ## 462            -  XYZ                             9    16
    ## 463            -  XYZ                            17    24
    ## 464            -  XYZ                            25    32
    ## 465            -  XYZ                            33    40
    ## 466            -  XYZ                            41    48
    ## 467            -  XYZ                            49    56
    ## 468            -  XYZ                            57    64
    ## 469            -  XYZ                             1    16
    ## 470            -  XYZ                            17    32
    ## 471            -  XYZ                            33    48
    ## 472            -  XYZ                            49    64
    ## 473            -  XYZ                             1    24
    ## 474            -  XYZ                            25    48
    ## 475            -  XYZ                             1     8
    ## 476            -  XYZ                             9    16
    ## 477            -  XYZ                            17    24
    ## 478            -  XYZ                            25    32
    ## 479            -  XYZ                            33    40
    ## 480            -  XYZ                            41    48
    ## 481            -  XYZ                            49    56
    ## 482            -  XYZ                            57    64
    ## 483            -  XYZ                             1    16
    ## 484            -  XYZ                            17    32
    ## 485            -  XYZ                            33    48
    ## 486            -  XYZ                            49    64
    ## 487            -  XYZ                             1    24
    ## 488            -  XYZ                            25    48
    ## 489            -  XYZ                             1     8
    ## 490            -  XYZ                             9    16
    ## 491            -  XYZ                            17    24
    ## 492            -  XYZ                            25    32
    ## 493            -  XYZ                            33    40
    ## 494            -  XYZ                            41    48
    ## 495            -  XYZ                            49    56
    ## 496            -  XYZ                            57    64
    ## 497            -  XYZ                             1    16
    ## 498            -  XYZ                            17    32
    ## 499            -  XYZ                            33    48
    ## 500            -  XYZ                            49    64
    ## 501            -  XYZ                             1    24
    ## 502            -  XYZ                            25    48
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
    ##             angleArg1   angleArg2
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
    ## 555      tBodyAccMean     gravity
    ## 556  tBodyAccJerkMean gravityMean
    ## 557     tBodyGyroMean gravityMean
    ## 558 tBodyGyroJerkMean gravityMean
    ## 559                 X gravityMean
    ## 560                 Y gravityMean
    ## 561                 Z gravityMean

Features tables
---------------

Simple tables
-------------

Total features by domain

``` r
sort(table("Total features by domain" = features$domain), decreasing = TRUE)
```

    ## Total features by domain
    ##   f   t     
    ## 289 265   7

Total features by Raw Signal

``` r
sort(table("Total features by Raw Signal" = features$rawSignal), decreasing = TRUE)
```

    ## Total features by Raw Signal
    ##  Acc Gyro      
    ##  343  211    7

Total features by Variable

``` r
sort(table("Total features by Variable" = features$variable), decreasing = TRUE)
```

    ## Total features by Variable
    ## bandsEnergy     arCoeff      energy     entropy         iqr         mad 
    ##         126          80          33          33          33          33 
    ##         max        mean         min         std         sma correlation 
    ##          33          33          33          33          17          15 
    ##    kurtosis     maxInds    meanFreq    skewness       angle 
    ##          13          13          13          13           7

Total features by Signal

``` r
sort(table("Total features by Signal" = with(features, paste0(domain, prefix, rawSignal, jerkSuffix, magSuffix, axisSep, axis, axesSep, axes))), decreasing = TRUE)
```

    ## Total features by Signal
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

Cross tables
------------

Total features by Signal by Domain

``` r
with(features,table("Total features by Signal by Domain" = paste0(domain, prefix, rawSignal, jerkSuffix, magSuffix, axisSep, axis, axesSep, axes), domain))
```

    ##                                   domain
    ## Total features by Signal by Domain     f  t
    ##                                     7  0  0
    ##                  fBodyAcc-X         0 12  0
    ##                  fBodyAcc-XYZ       0 43  0
    ##                  fBodyAcc-Y         0 12  0
    ##                  fBodyAcc-Z         0 12  0
    ##                  fBodyAccJerk-X     0 12  0
    ##                  fBodyAccJerk-XYZ   0 43  0
    ##                  fBodyAccJerk-Y     0 12  0
    ##                  fBodyAccJerk-Z     0 12  0
    ##                  fBodyAccJerkMag    0 13  0
    ##                  fBodyAccMag        0 13  0
    ##                  fBodyGyro-X        0 12  0
    ##                  fBodyGyro-XYZ      0 43  0
    ##                  fBodyGyro-Y        0 12  0
    ##                  fBodyGyro-Z        0 12  0
    ##                  fBodyGyroJerkMag   0 13  0
    ##                  fBodyGyroMag       0 13  0
    ##                  tBodyAcc-X         0  0 12
    ##                  tBodyAcc-XY        0  0  1
    ##                  tBodyAcc-XYZ       0  0  1
    ##                  tBodyAcc-XZ        0  0  1
    ##                  tBodyAcc-Y         0  0 12
    ##                  tBodyAcc-YZ        0  0  1
    ##                  tBodyAcc-Z         0  0 12
    ##                  tBodyAccJerk-X     0  0 12
    ##                  tBodyAccJerk-XY    0  0  1
    ##                  tBodyAccJerk-XYZ   0  0  1
    ##                  tBodyAccJerk-XZ    0  0  1
    ##                  tBodyAccJerk-Y     0  0 12
    ##                  tBodyAccJerk-YZ    0  0  1
    ##                  tBodyAccJerk-Z     0  0 12
    ##                  tBodyAccJerkMag    0  0 13
    ##                  tBodyAccMag        0  0 13
    ##                  tBodyGyro-X        0  0 12
    ##                  tBodyGyro-XY       0  0  1
    ##                  tBodyGyro-XYZ      0  0  1
    ##                  tBodyGyro-XZ       0  0  1
    ##                  tBodyGyro-Y        0  0 12
    ##                  tBodyGyro-YZ       0  0  1
    ##                  tBodyGyro-Z        0  0 12
    ##                  tBodyGyroJerk-X    0  0 12
    ##                  tBodyGyroJerk-XY   0  0  1
    ##                  tBodyGyroJerk-XYZ  0  0  1
    ##                  tBodyGyroJerk-XZ   0  0  1
    ##                  tBodyGyroJerk-Y    0  0 12
    ##                  tBodyGyroJerk-YZ   0  0  1
    ##                  tBodyGyroJerk-Z    0  0 12
    ##                  tBodyGyroJerkMag   0  0 13
    ##                  tBodyGyroMag       0  0 13
    ##                  tGravityAcc-X      0  0 12
    ##                  tGravityAcc-XY     0  0  1
    ##                  tGravityAcc-XYZ    0  0  1
    ##                  tGravityAcc-XZ     0  0  1
    ##                  tGravityAcc-Y      0  0 12
    ##                  tGravityAcc-YZ     0  0  1
    ##                  tGravityAcc-Z      0  0 12
    ##                  tGravityAccMag     0  0 13

Total features by Signal by Raw Signal

``` r
with(features,table("Total features by Signal by Raw Signal" = paste0(domain, prefix, rawSignal, jerkSuffix, magSuffix, axisSep, axis, axesSep, axes), rawSignal))
```

    ##                                       rawSignal
    ## Total features by Signal by Raw Signal    Acc Gyro
    ##                                         7   0    0
    ##                      fBodyAcc-X         0  12    0
    ##                      fBodyAcc-XYZ       0  43    0
    ##                      fBodyAcc-Y         0  12    0
    ##                      fBodyAcc-Z         0  12    0
    ##                      fBodyAccJerk-X     0  12    0
    ##                      fBodyAccJerk-XYZ   0  43    0
    ##                      fBodyAccJerk-Y     0  12    0
    ##                      fBodyAccJerk-Z     0  12    0
    ##                      fBodyAccJerkMag    0  13    0
    ##                      fBodyAccMag        0  13    0
    ##                      fBodyGyro-X        0   0   12
    ##                      fBodyGyro-XYZ      0   0   43
    ##                      fBodyGyro-Y        0   0   12
    ##                      fBodyGyro-Z        0   0   12
    ##                      fBodyGyroJerkMag   0   0   13
    ##                      fBodyGyroMag       0   0   13
    ##                      tBodyAcc-X         0  12    0
    ##                      tBodyAcc-XY        0   1    0
    ##                      tBodyAcc-XYZ       0   1    0
    ##                      tBodyAcc-XZ        0   1    0
    ##                      tBodyAcc-Y         0  12    0
    ##                      tBodyAcc-YZ        0   1    0
    ##                      tBodyAcc-Z         0  12    0
    ##                      tBodyAccJerk-X     0  12    0
    ##                      tBodyAccJerk-XY    0   1    0
    ##                      tBodyAccJerk-XYZ   0   1    0
    ##                      tBodyAccJerk-XZ    0   1    0
    ##                      tBodyAccJerk-Y     0  12    0
    ##                      tBodyAccJerk-YZ    0   1    0
    ##                      tBodyAccJerk-Z     0  12    0
    ##                      tBodyAccJerkMag    0  13    0
    ##                      tBodyAccMag        0  13    0
    ##                      tBodyGyro-X        0   0   12
    ##                      tBodyGyro-XY       0   0    1
    ##                      tBodyGyro-XYZ      0   0    1
    ##                      tBodyGyro-XZ       0   0    1
    ##                      tBodyGyro-Y        0   0   12
    ##                      tBodyGyro-YZ       0   0    1
    ##                      tBodyGyro-Z        0   0   12
    ##                      tBodyGyroJerk-X    0   0   12
    ##                      tBodyGyroJerk-XY   0   0    1
    ##                      tBodyGyroJerk-XYZ  0   0    1
    ##                      tBodyGyroJerk-XZ   0   0    1
    ##                      tBodyGyroJerk-Y    0   0   12
    ##                      tBodyGyroJerk-YZ   0   0    1
    ##                      tBodyGyroJerk-Z    0   0   12
    ##                      tBodyGyroJerkMag   0   0   13
    ##                      tBodyGyroMag       0   0   13
    ##                      tGravityAcc-X      0  12    0
    ##                      tGravityAcc-XY     0   1    0
    ##                      tGravityAcc-XYZ    0   1    0
    ##                      tGravityAcc-XZ     0   1    0
    ##                      tGravityAcc-Y      0  12    0
    ##                      tGravityAcc-YZ     0   1    0
    ##                      tGravityAcc-Z      0  12    0
    ##                      tGravityAccMag     0  13    0

Total features by Signal by Variable

``` r
with(features,table("Total features by Signal by Variable" = paste0(domain, prefix, rawSignal, jerkSuffix, magSuffix, axisSep, axis, axesSep, axes), variable))
```

    ##                                     variable
    ## Total features by Signal by Variable angle arCoeff bandsEnergy correlation
    ##                                          7       0           0           0
    ##                    fBodyAcc-X            0       0           0           0
    ##                    fBodyAcc-XYZ          0       0          42           0
    ##                    fBodyAcc-Y            0       0           0           0
    ##                    fBodyAcc-Z            0       0           0           0
    ##                    fBodyAccJerk-X        0       0           0           0
    ##                    fBodyAccJerk-XYZ      0       0          42           0
    ##                    fBodyAccJerk-Y        0       0           0           0
    ##                    fBodyAccJerk-Z        0       0           0           0
    ##                    fBodyAccJerkMag       0       0           0           0
    ##                    fBodyAccMag           0       0           0           0
    ##                    fBodyGyro-X           0       0           0           0
    ##                    fBodyGyro-XYZ         0       0          42           0
    ##                    fBodyGyro-Y           0       0           0           0
    ##                    fBodyGyro-Z           0       0           0           0
    ##                    fBodyGyroJerkMag      0       0           0           0
    ##                    fBodyGyroMag          0       0           0           0
    ##                    tBodyAcc-X            0       4           0           0
    ##                    tBodyAcc-XY           0       0           0           1
    ##                    tBodyAcc-XYZ          0       0           0           0
    ##                    tBodyAcc-XZ           0       0           0           1
    ##                    tBodyAcc-Y            0       4           0           0
    ##                    tBodyAcc-YZ           0       0           0           1
    ##                    tBodyAcc-Z            0       4           0           0
    ##                    tBodyAccJerk-X        0       4           0           0
    ##                    tBodyAccJerk-XY       0       0           0           1
    ##                    tBodyAccJerk-XYZ      0       0           0           0
    ##                    tBodyAccJerk-XZ       0       0           0           1
    ##                    tBodyAccJerk-Y        0       4           0           0
    ##                    tBodyAccJerk-YZ       0       0           0           1
    ##                    tBodyAccJerk-Z        0       4           0           0
    ##                    tBodyAccJerkMag       0       4           0           0
    ##                    tBodyAccMag           0       4           0           0
    ##                    tBodyGyro-X           0       4           0           0
    ##                    tBodyGyro-XY          0       0           0           1
    ##                    tBodyGyro-XYZ         0       0           0           0
    ##                    tBodyGyro-XZ          0       0           0           1
    ##                    tBodyGyro-Y           0       4           0           0
    ##                    tBodyGyro-YZ          0       0           0           1
    ##                    tBodyGyro-Z           0       4           0           0
    ##                    tBodyGyroJerk-X       0       4           0           0
    ##                    tBodyGyroJerk-XY      0       0           0           1
    ##                    tBodyGyroJerk-XYZ     0       0           0           0
    ##                    tBodyGyroJerk-XZ      0       0           0           1
    ##                    tBodyGyroJerk-Y       0       4           0           0
    ##                    tBodyGyroJerk-YZ      0       0           0           1
    ##                    tBodyGyroJerk-Z       0       4           0           0
    ##                    tBodyGyroJerkMag      0       4           0           0
    ##                    tBodyGyroMag          0       4           0           0
    ##                    tGravityAcc-X         0       4           0           0
    ##                    tGravityAcc-XY        0       0           0           1
    ##                    tGravityAcc-XYZ       0       0           0           0
    ##                    tGravityAcc-XZ        0       0           0           1
    ##                    tGravityAcc-Y         0       4           0           0
    ##                    tGravityAcc-YZ        0       0           0           1
    ##                    tGravityAcc-Z         0       4           0           0
    ##                    tGravityAccMag        0       4           0           0
    ##                                     variable
    ## Total features by Signal by Variable energy entropy iqr kurtosis mad max
    ##                                           0       0   0        0   0   0
    ##                    fBodyAcc-X             1       1   1        1   1   1
    ##                    fBodyAcc-XYZ           0       0   0        0   0   0
    ##                    fBodyAcc-Y             1       1   1        1   1   1
    ##                    fBodyAcc-Z             1       1   1        1   1   1
    ##                    fBodyAccJerk-X         1       1   1        1   1   1
    ##                    fBodyAccJerk-XYZ       0       0   0        0   0   0
    ##                    fBodyAccJerk-Y         1       1   1        1   1   1
    ##                    fBodyAccJerk-Z         1       1   1        1   1   1
    ##                    fBodyAccJerkMag        1       1   1        1   1   1
    ##                    fBodyAccMag            1       1   1        1   1   1
    ##                    fBodyGyro-X            1       1   1        1   1   1
    ##                    fBodyGyro-XYZ          0       0   0        0   0   0
    ##                    fBodyGyro-Y            1       1   1        1   1   1
    ##                    fBodyGyro-Z            1       1   1        1   1   1
    ##                    fBodyGyroJerkMag       1       1   1        1   1   1
    ##                    fBodyGyroMag           1       1   1        1   1   1
    ##                    tBodyAcc-X             1       1   1        0   1   1
    ##                    tBodyAcc-XY            0       0   0        0   0   0
    ##                    tBodyAcc-XYZ           0       0   0        0   0   0
    ##                    tBodyAcc-XZ            0       0   0        0   0   0
    ##                    tBodyAcc-Y             1       1   1        0   1   1
    ##                    tBodyAcc-YZ            0       0   0        0   0   0
    ##                    tBodyAcc-Z             1       1   1        0   1   1
    ##                    tBodyAccJerk-X         1       1   1        0   1   1
    ##                    tBodyAccJerk-XY        0       0   0        0   0   0
    ##                    tBodyAccJerk-XYZ       0       0   0        0   0   0
    ##                    tBodyAccJerk-XZ        0       0   0        0   0   0
    ##                    tBodyAccJerk-Y         1       1   1        0   1   1
    ##                    tBodyAccJerk-YZ        0       0   0        0   0   0
    ##                    tBodyAccJerk-Z         1       1   1        0   1   1
    ##                    tBodyAccJerkMag        1       1   1        0   1   1
    ##                    tBodyAccMag            1       1   1        0   1   1
    ##                    tBodyGyro-X            1       1   1        0   1   1
    ##                    tBodyGyro-XY           0       0   0        0   0   0
    ##                    tBodyGyro-XYZ          0       0   0        0   0   0
    ##                    tBodyGyro-XZ           0       0   0        0   0   0
    ##                    tBodyGyro-Y            1       1   1        0   1   1
    ##                    tBodyGyro-YZ           0       0   0        0   0   0
    ##                    tBodyGyro-Z            1       1   1        0   1   1
    ##                    tBodyGyroJerk-X        1       1   1        0   1   1
    ##                    tBodyGyroJerk-XY       0       0   0        0   0   0
    ##                    tBodyGyroJerk-XYZ      0       0   0        0   0   0
    ##                    tBodyGyroJerk-XZ       0       0   0        0   0   0
    ##                    tBodyGyroJerk-Y        1       1   1        0   1   1
    ##                    tBodyGyroJerk-YZ       0       0   0        0   0   0
    ##                    tBodyGyroJerk-Z        1       1   1        0   1   1
    ##                    tBodyGyroJerkMag       1       1   1        0   1   1
    ##                    tBodyGyroMag           1       1   1        0   1   1
    ##                    tGravityAcc-X          1       1   1        0   1   1
    ##                    tGravityAcc-XY         0       0   0        0   0   0
    ##                    tGravityAcc-XYZ        0       0   0        0   0   0
    ##                    tGravityAcc-XZ         0       0   0        0   0   0
    ##                    tGravityAcc-Y          1       1   1        0   1   1
    ##                    tGravityAcc-YZ         0       0   0        0   0   0
    ##                    tGravityAcc-Z          1       1   1        0   1   1
    ##                    tGravityAccMag         1       1   1        0   1   1
    ##                                     variable
    ## Total features by Signal by Variable maxInds mean meanFreq min skewness
    ##                                            0    0        0   0        0
    ##                    fBodyAcc-X              1    1        1   1        1
    ##                    fBodyAcc-XYZ            0    0        0   0        0
    ##                    fBodyAcc-Y              1    1        1   1        1
    ##                    fBodyAcc-Z              1    1        1   1        1
    ##                    fBodyAccJerk-X          1    1        1   1        1
    ##                    fBodyAccJerk-XYZ        0    0        0   0        0
    ##                    fBodyAccJerk-Y          1    1        1   1        1
    ##                    fBodyAccJerk-Z          1    1        1   1        1
    ##                    fBodyAccJerkMag         1    1        1   1        1
    ##                    fBodyAccMag             1    1        1   1        1
    ##                    fBodyGyro-X             1    1        1   1        1
    ##                    fBodyGyro-XYZ           0    0        0   0        0
    ##                    fBodyGyro-Y             1    1        1   1        1
    ##                    fBodyGyro-Z             1    1        1   1        1
    ##                    fBodyGyroJerkMag        1    1        1   1        1
    ##                    fBodyGyroMag            1    1        1   1        1
    ##                    tBodyAcc-X              0    1        0   1        0
    ##                    tBodyAcc-XY             0    0        0   0        0
    ##                    tBodyAcc-XYZ            0    0        0   0        0
    ##                    tBodyAcc-XZ             0    0        0   0        0
    ##                    tBodyAcc-Y              0    1        0   1        0
    ##                    tBodyAcc-YZ             0    0        0   0        0
    ##                    tBodyAcc-Z              0    1        0   1        0
    ##                    tBodyAccJerk-X          0    1        0   1        0
    ##                    tBodyAccJerk-XY         0    0        0   0        0
    ##                    tBodyAccJerk-XYZ        0    0        0   0        0
    ##                    tBodyAccJerk-XZ         0    0        0   0        0
    ##                    tBodyAccJerk-Y          0    1        0   1        0
    ##                    tBodyAccJerk-YZ         0    0        0   0        0
    ##                    tBodyAccJerk-Z          0    1        0   1        0
    ##                    tBodyAccJerkMag         0    1        0   1        0
    ##                    tBodyAccMag             0    1        0   1        0
    ##                    tBodyGyro-X             0    1        0   1        0
    ##                    tBodyGyro-XY            0    0        0   0        0
    ##                    tBodyGyro-XYZ           0    0        0   0        0
    ##                    tBodyGyro-XZ            0    0        0   0        0
    ##                    tBodyGyro-Y             0    1        0   1        0
    ##                    tBodyGyro-YZ            0    0        0   0        0
    ##                    tBodyGyro-Z             0    1        0   1        0
    ##                    tBodyGyroJerk-X         0    1        0   1        0
    ##                    tBodyGyroJerk-XY        0    0        0   0        0
    ##                    tBodyGyroJerk-XYZ       0    0        0   0        0
    ##                    tBodyGyroJerk-XZ        0    0        0   0        0
    ##                    tBodyGyroJerk-Y         0    1        0   1        0
    ##                    tBodyGyroJerk-YZ        0    0        0   0        0
    ##                    tBodyGyroJerk-Z         0    1        0   1        0
    ##                    tBodyGyroJerkMag        0    1        0   1        0
    ##                    tBodyGyroMag            0    1        0   1        0
    ##                    tGravityAcc-X           0    1        0   1        0
    ##                    tGravityAcc-XY          0    0        0   0        0
    ##                    tGravityAcc-XYZ         0    0        0   0        0
    ##                    tGravityAcc-XZ          0    0        0   0        0
    ##                    tGravityAcc-Y           0    1        0   1        0
    ##                    tGravityAcc-YZ          0    0        0   0        0
    ##                    tGravityAcc-Z           0    1        0   1        0
    ##                    tGravityAccMag          0    1        0   1        0
    ##                                     variable
    ## Total features by Signal by Variable sma std
    ##                                        0   0
    ##                    fBodyAcc-X          0   1
    ##                    fBodyAcc-XYZ        1   0
    ##                    fBodyAcc-Y          0   1
    ##                    fBodyAcc-Z          0   1
    ##                    fBodyAccJerk-X      0   1
    ##                    fBodyAccJerk-XYZ    1   0
    ##                    fBodyAccJerk-Y      0   1
    ##                    fBodyAccJerk-Z      0   1
    ##                    fBodyAccJerkMag     1   1
    ##                    fBodyAccMag         1   1
    ##                    fBodyGyro-X         0   1
    ##                    fBodyGyro-XYZ       1   0
    ##                    fBodyGyro-Y         0   1
    ##                    fBodyGyro-Z         0   1
    ##                    fBodyGyroJerkMag    1   1
    ##                    fBodyGyroMag        1   1
    ##                    tBodyAcc-X          0   1
    ##                    tBodyAcc-XY         0   0
    ##                    tBodyAcc-XYZ        1   0
    ##                    tBodyAcc-XZ         0   0
    ##                    tBodyAcc-Y          0   1
    ##                    tBodyAcc-YZ         0   0
    ##                    tBodyAcc-Z          0   1
    ##                    tBodyAccJerk-X      0   1
    ##                    tBodyAccJerk-XY     0   0
    ##                    tBodyAccJerk-XYZ    1   0
    ##                    tBodyAccJerk-XZ     0   0
    ##                    tBodyAccJerk-Y      0   1
    ##                    tBodyAccJerk-YZ     0   0
    ##                    tBodyAccJerk-Z      0   1
    ##                    tBodyAccJerkMag     1   1
    ##                    tBodyAccMag         1   1
    ##                    tBodyGyro-X         0   1
    ##                    tBodyGyro-XY        0   0
    ##                    tBodyGyro-XYZ       1   0
    ##                    tBodyGyro-XZ        0   0
    ##                    tBodyGyro-Y         0   1
    ##                    tBodyGyro-YZ        0   0
    ##                    tBodyGyro-Z         0   1
    ##                    tBodyGyroJerk-X     0   1
    ##                    tBodyGyroJerk-XY    0   0
    ##                    tBodyGyroJerk-XYZ   1   0
    ##                    tBodyGyroJerk-XZ    0   0
    ##                    tBodyGyroJerk-Y     0   1
    ##                    tBodyGyroJerk-YZ    0   0
    ##                    tBodyGyroJerk-Z     0   1
    ##                    tBodyGyroJerkMag    1   1
    ##                    tBodyGyroMag        1   1
    ##                    tGravityAcc-X       0   1
    ##                    tGravityAcc-XY      0   0
    ##                    tGravityAcc-XYZ     1   0
    ##                    tGravityAcc-XZ      0   0
    ##                    tGravityAcc-Y       0   1
    ##                    tGravityAcc-YZ      0   0
    ##                    tGravityAcc-Z       0   1
    ##                    tGravityAccMag      1   1

Total features by Variable by Domain

``` r
with(features,table("Total features by Variable by Domain" = variable, domain))
```

    ##                                     domain
    ## Total features by Variable by Domain       f   t
    ##                          angle         7   0   0
    ##                          arCoeff       0   0  80
    ##                          bandsEnergy   0 126   0
    ##                          correlation   0   0  15
    ##                          energy        0  13  20
    ##                          entropy       0  13  20
    ##                          iqr           0  13  20
    ##                          kurtosis      0  13   0
    ##                          mad           0  13  20
    ##                          max           0  13  20
    ##                          maxInds       0  13   0
    ##                          mean          0  13  20
    ##                          meanFreq      0  13   0
    ##                          min           0  13  20
    ##                          skewness      0  13   0
    ##                          sma           0   7  10
    ##                          std           0  13  20

Total features by Variable by Raw Signal

``` r
with(features,table("Total features by Variable by Raw Signal" = variable, rawSignal))
```

    ##                                         rawSignal
    ## Total features by Variable by Raw Signal    Acc Gyro
    ##                              angle        7   0    0
    ##                              arCoeff      0  48   32
    ##                              bandsEnergy  0  84   42
    ##                              correlation  0   9    6
    ##                              energy       0  20   13
    ##                              entropy      0  20   13
    ##                              iqr          0  20   13
    ##                              kurtosis     0   8    5
    ##                              mad          0  20   13
    ##                              max          0  20   13
    ##                              maxInds      0   8    5
    ##                              mean         0  20   13
    ##                              meanFreq     0   8    5
    ##                              min          0  20   13
    ##                              skewness     0   8    5
    ##                              sma          0  10    7
    ##                              std          0  20   13

Time Magnitude Signal Pattern:
------------------------------

    timeMagnitudeSignal-variable()
    signals:    tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag,
                tBodyGyroJerkMag
    variables:  mean(), std(), mad(), max(), min(), sma(), energy(), iqr(),
                entropy()
    results:    5 signals X 9 variables = 45

    timeMagnitudeSignal-variable()level
    signals:    tBodyAccMag, tGravityAccMag, tBodyAccJerkMag,
                tBodyGyroMag, tBodyGyroJerkMag
    variables:  arCoeff()
    levels:     1, 2, 3, 4
    results:    5 signals X 1 variable X 4 levels = 20

Frequency Magnitude Signal Pattern:
-----------------------------------

    frequencyMagnitudeSignal-variable()
    signals:    fBodyAccMag, fBodyBodyAccJerkMag, fBodyBodyGyroMag,
                fBodyBodyGyroJerkMag
    variables:  mean(), std(), mad(), max(), min(), sma(), energy(), iqr(),
                entropy() plus meanFreq(), skewness(), kurtosis()
    results:    4 signals X 12 variable = 48

    frequencyMagnitudeSignal-variable
    signals:    fBodyAccMag, fBodyBodyAccJerkMag, fBodyBodyGyroMag,
                fBodyBodyGyroJerkMag 
    variable:   maxInds
    results:    4 signals X 1 variable = 4

Time Axial Signal Pattern:
--------------------------

    timeAxialSignal-variable()
    signals:    tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk
    variables:  sma()
    axis:       3-axial (XYZ)
    results:    5 3-axial-signals X 1 variable = 5

    timeAxialSignal-variable()-axis
    signals:    tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk
    variables:  mean(), std(), mad(), max(), min(), energy(), iqr(), entropy()
    axis:       X, Y, Z
    results:    5 signals X 8 variables X 3 axis = 120

    timeAxialSignal-variable()-X,Y
    signals:    tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk
    variable:   correlation()
    (axis:      X, Y)
    results:    5 signals X 1 variable = 5

    timeAxialSignal-variable()-Y,Z
    signals:    tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk
    variable:   correlation()
    (axis:      Y, Z)
    results:    5 signals X 1 variable = 5

    timeAxialSignal-variable()-X,Z
    signals:    tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk
    variable:   correlation()
    (axis:      X, Z)
    results:    5 signals X 1 variable = 5

    timeAxialSignal-variable()-axis,level
    signals:    tBodyAcc, tGravityAcc, tBodyAccJerk, tBodyGyro, tBodyGyroJerk
    variables:  arCoeff()
    axis:       X, Y, Z
    levels:     1, 2, 3, 4
    results:    5 signals X 1 variable X 3 axis X 4 levels  = 60

Frequency Axial Signal Pattern:
-------------------------------

    frequencyAxialSignal-variable()
    signals:    fBodyAcc, fBodyAccJerk, fBodyGyro
    variables:  sma()
    axis:       3-axial (XYZ)
    results:    3 3-axial-signals X 1 variable = 3

    frequencyAxialSignal-variable-axis
    signals:    fBodyAcc, fBodyAccJerk, fBodyGyro
    variables:  maxInds
    axis:       X, Y, Z
    results:    3 signals X 1 variable X 3 axis = 9

    frequencyAxialSignal-variable()-axis
    signals:    fBodyAcc, fBodyAccJerk, fBodyGyro
    variables:  mean(), std(), mad(), max(), min(), energy(), iqr(), entropy(),
                meanFreq(), skewnewss(), kurtosis()
    axis:       X, Y, Z
    results:    3 signals X 11 X 3 axis = 99

Frequency Interval Energy Signal Pattern:
-----------------------------------------

    frequencyIntervalEnergySignal-variable()-lower,upper
    signals:    fBodyAcc, fBodyAccJerk, fBodyGyro
    variables:  bandsEnergy()
    axis:       3-axial (XYZ)
    interval series:
        8 in 64: [1,8],[9,16],[17,24],[25,32],[33,40],[41,48],[49,56],[57,64]
        4 in 64: [1,16],[17,32],[33,48],[49,64]
        2 in 48: [1,24],[25,48]
    results:    3 3-axial-signals X 1 variable X 3 series X (8+4+2 levels)=126

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

    angle(angleArgument,angleArgument)
    variable:   angle()
    Arguments:  (tBodyAccMean,gravity)
                (tBodyAccJerkMean*)*,gravityMean)
                (tBodyGyroMean,gravityMean)
                (tBodyGyroJerkMean,gravityMean)
                (X,gravityMean)
                (Y,gravityMean)
                (Z,gravityMean)
    results:    1 variable X 7 paired arguments = 7
