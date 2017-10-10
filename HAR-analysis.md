HAR-analysis
================
by Maurício Collaça
on 2017-10-10

Analysis of the Human Activity Recognition (HAR) Using Smartphones Data Set
---------------------------------------------------------------------------

Abstract: Analysis of the Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

Introduction
------------

Activity recognition aims to recognize the actions and goals of one or more agents from a series of observations on the agents' actions and the environmental conditions. Since the 1980s, this research field has captured the attention of several computer science communities due to its strength in providing personalized support for many different applications and its connection to many different fields of study such as medicine, human-computer interaction, or sociology. (Wikipedia, 2016).

Due to its many-faceted nature, different fields may refer to activity recognition as plan recognition, goal recognition, intent recognition, behavior recognition, location estimation and location-based services.

### Layers of sensor-based activity recognition

Sensor-based activity recognition is a challenging task due to the inherent noisy nature of the sensor's data. Thus, statistical modeling has been the main thrust in this direction in layers, where the recognition at several intermediate levels is conducted and connected.

#### Layer 1 - Agent location and environmental conditions

At the lowest level where the sensor data are collected, statistical learning concerns how to find the detailed locations and inertial signals of agents from the received signal data of sensors such as GPS, Accelerometer and Gyroscope.

#### Layer 2 - Agent activity recognition

At an intermediate level, statistical inference may be concerned about how to recognize individuals' activities from the inferred location sequences, environmental conditions and intertial signals at the lower levels.

#### Layer 3 - Behaviours, Plan, Goals and Intent recognition

Furthermore, at the highest level a major concern is to find out the overall behaviours, plans, goals or subgoals of an agent from the activity sequences through a mixture of logical and statistical reasoning.

Scientific conferences where activity recognition work from wearable and environmental often appears are the International Symposium on Wearable Computers (ISWC) and the Association for Computing Machinery's (ACM) International Joint Conference on Pervasive Computting (UbiComp).

### Types of sensor-based activity recognition

The types of sensor-based activity recognition includes single-user, multi-user and group.

#### Single user activity recognition

Sensor-based, single-user activity recognition integrates the emerging area of sensor networks with novel data mining and machine learning techniques to model a wide range of human activities. (Tanzeem Choudhury, Gaetano Borriello, et al., 2008), (Nishkam Ravi, Nikhil Dandekar, Preetham Mysore, Michael Littman., 2005). Mobile devices (e.g. smart phones) provide sufficient sensor data and calculation power to enable physical activity recognition to provide an estimation of the energy consumption during everyday life. Sensor-based activity recognition researchers believe that by empowering ubiquitous computers and sensors to monitor the behavior of agents (under consent), these computers will be better suited to act on our behalf.

#### Multi-user activity recognition

Recognizing activities for multiple users using on-body sensors first appeared in the work by Olivetti Research Ltd (ORL) using active badge systems in the early 90's (Want R., Hopper A., Falcao V., Gibbons J., 1992). Other sensor technology such as acceleration sensors were used for identifying group activity patterns during office scenarios (Bieber G., Kirste T., 2007). An investigattion of the fundamental problem of recognizing activities for multiple users from sensor readings in a home environment, and proposal of a novel pattern mining approach to recognize both single-user and multi-user activities in a unified solution appeared in the International Conference on Mobile and Ubiquitous Systems. (Tao Gu, Zhanqing Wu, Liang Wang, Xianping Tao, and Jian Lu, 2009)

#### Group activity recognition

Recognition of group activities is fundamentally different from single, or multi-user activity recognition in that the goal is to recognize the behavior of the group as an entity, rather than the activities of the individual members within it (Dawud Gordon, Jan-Hendrik Hanne, Martin Berchtold, Ali Asghar Nazari Shirehjini, Michael Beigl, 2013). Group behavior is emergent in nature, meaning that the properties of the behavior of the group are fundamentally different then the properties of the behavior of the individuals within it, or any sum of that behavior (Lewin, K., 1951). The main challenges are in modeling the behavior of the individual group members, as well as the roles of the individual within the group dynamic (Hirano, T., and Maekawa, T., 2013) and their relationship to emergent behavior of the group in parallel (Brdiczka, O., Maisonnasse, J., Reignier, P., and Crowley, J. L., 2007). Challenges which must still be addressed include quantification of the behavior and roles of individuals who join the group, integration of explicit models for role description into inference algorithms, and scalability evaluations for very large groups and crowds. Group activity recognition has applications for crowd management and response in emergency situations, as well as for social networking and Quantified Self applications (Dawud Gordon, 2014).

### Scope of the HAR Data Set V1.0

The scope of this data set covers part of the layer 2 definition because it focus only in activities of daily living (ADL) regardless the location sequences and environmental conditions where those activities were performed, limiting to six activities: WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING and LAYING.

It's understood this data set falls in the single-user type of activity recognition as it contains observations of 30 subjects performing their individual activities and no attribute relates activities between subjects.

### Motivation of this analysis

An exciting area in Data Science is Wearable Computing - see for example this [article from Inside Activity Tracking](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/). Companies like [Fitbit](https://www.fitbit.com/), [Nike](http://www.nike.com/), [Jawbone Up](https://jawbone.com/up), [Strava](https://www.strava.com/), and many others are racing to develop the most advanced algorithms to attract new users.

General information about the environment used
----------------------------------------------

Hardware:

    Processor: Inter(R) Core(TM) i5-2300 CPU @ 2.80Ghz
    Number of Cores: 4
    Installed RAM: 8.00 GB  
    System type: x64-based processor

Operating System:

``` r
Sys.info()[c("sysname","release")]
```

    ##   sysname   release 
    ## "Windows"  "10 x64"

R version:

``` r
R.Version()[c("version.string", "arch")]
```

    ## $version.string
    ## [1] "R version 3.4.2 (2017-09-28)"
    ## 
    ## $arch
    ## [1] "x86_64"

RStudio Desktop version 1.1.383

R packages used beyond the R defaults `{base}`, `{utils}`, `{stat}`:

``` r
packageVersion("dplyr")
```

    ## [1] '0.7.4'

``` r
packageVersion("tidyr")
```

    ## [1] '0.7.1'

Analysis
--------

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

Features
--------

``` r
features <- read_features()
str(features)
```

    ## 'data.frame':    561 obs. of  2 variables:
    ##  $ id  : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ name: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...

Signals
-------

``` r
signals <- read_signals()
str(signals)
```

    ## 'data.frame':    17 obs. of  1 variable:
    ##  $ name: chr  "tBodyAcc-XYZ" "tGravityAcc-XYZ" "tBodyAccJerk-XYZ" "tBodyGyro-XYZ" ...

Calculus
--------

``` r
calculus <- read_calculus()
paste0(calculus$name, ": ", calculus$description)
```

    ##  [1] "mean(): Mean value"                                                                         
    ##  [2] "std(): Standard deviation"                                                                  
    ##  [3] "mad(): Median absolute deviation"                                                           
    ##  [4] "max(): Largest value in array"                                                              
    ##  [5] "min(): Smallest value in array"                                                             
    ##  [6] "sma(): Signal magnitude area"                                                               
    ##  [7] "energy(): Energy measure. Sum of the squares divided by the number of values."              
    ##  [8] "iqr(): Interquartile range"                                                                 
    ##  [9] "entropy(): Signal entropy"                                                                  
    ## [10] "arCoeff(): Autorregresion coefficients with Burg order equal to 4"                          
    ## [11] "correlation(): correlation coefficient between two signals"                                 
    ## [12] "maxInds(): index of the frequency component with largest magnitude"                         
    ## [13] "meanFreq(): Weighted average of the frequency components to obtain a mean frequency"        
    ## [14] "skewness(): skewness of the frequency domain signal"                                        
    ## [15] "kurtosis(): kurtosis of the frequency domain signal"                                        
    ## [16] "bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window."
    ## [17] "angle(): Angle between to vectors."

Activities
----------

``` r
activity_labels <- read_activity_labels()
activity_labels
```

    ##   id               name
    ## 1  1            WALKING
    ## 2  2   WALKING_UPSTAIRS
    ## 3  3 WALKING_DOWNSTAIRS
    ## 4  4            SITTING
    ## 5  5           STANDING
    ## 6  6             LAYING

Vectors for angle calculus
--------------------------

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable.

``` r
angleVectors <- read_angleVectors()
angleVectors
```

    ##                name
    ## 1       gravityMean
    ## 2      tBodyAccMean
    ## 3  tBodyAccJerkMean
    ## 4     tBodyGyroMean
    ## 5 tBodyGyroJerkMean

Feature name patches
--------------------

``` r
source("dsub.R")
```

### Feature names with duplicated component

``` r
dsub("features", "name", "^.([A-Z][a-z]+)(\\1).*", "\\1", "", explain = TRUE, verbose = FALSE)
```

    ## It would affect 39 row(s) with the sentence: features[516:554, "name"] <- sub("Body", "", features[516:554, "name"])

### Removing duplicated component

``` r
dsub("features", "name", "^.([A-Z][a-z]+)(\\1).*", "\\1", "", explain = FALSE, verbose = FALSE)
```

### Feature names containing invalid parenthesis

``` r
dsub("features", "name", "^.+[\\(].+([\\)]).+[\\)].*", "\\1", "", explain = TRUE, verbose = FALSE)
```

    ## It would affect 1 row(s) with the sentence: features[556, "name"] <- sub(")", "", features[556, "name"])

### Removing invalid parenthesis

``` r
dsub("features", "name", "^.+[\\(].+([\\)]).+[\\)].*", "\\1", "", explain = FALSE, verbose = FALSE)
```

### Feature names missing parenthesis

``` r
dsub("features", "name", "^[a-zA-Z]+-([a-zA-Z]+)-?[XYZ]?$", "(\\1)", "\\1()", explain = TRUE, verbose = FALSE)
```

    ## It would affect 13 row(s) with the sentence: features[c(291, 292, 293, 370, 371, 372, 449, 450, 451, 512, 525, 538, 551), "name"] <- sub("(maxInds)", "\\1()", features[c(291, 292, 293, 370, 371, 372, 449, 450, 451, 512, 525, 538, 551), "name"])

### Including missing parenthesis

``` r
dsub("features", "name", "^[a-zA-Z]+-([a-zA-Z]+)-?[XYZ]?$", "(\\1)", "\\1()", explain = FALSE, verbose = FALSE)
```

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

Feature axes decomposition
--------------------------

``` r
features %>%
    select(id,name) %>%
    mutate(axes = getFeatureAxes(name),
           name = NULL,
           axis1 = sub("(X)?Y?Z?","\\1",axes),
           axis2 = sub("X?(Y)?Z?","\\1",axes),
           axis3 = sub("X?Y?(Z)?","\\1",axes),
           axes = NULL
           ) %>%
    gather(seq, axis, axis1:axis3) %>%
    mutate(seq = as.integer(sub("axis","",seq))) %>%
    filter(axis != "") %>%
    arrange(id) %>%
    head
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
features <- decomposeFeatureNames(features)
str(features)
```

    ## 'data.frame':    561 obs. of  29 variables:
    ##  $ id              : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ name            : chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" ...
    ##  $ signal          : chr  "tBodyAcc" "tBodyAcc" "tBodyAcc" "tBodyAcc" ...
    ##  $ axesSep         : chr  "-" "-" "-" "-" ...
    ##  $ axes            : chr  "X" "Y" "Z" "X" ...
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

### Feature name recomposition

``` r
features %>%
    unite(recomposition, sep = "", signal, signalSep:angleClose) %>%
    select(name,recomposition) %>%
    head
```

    ##                name     recomposition
    ## 1 tBodyAcc-mean()-X tBodyAcc-mean()-X
    ## 2 tBodyAcc-mean()-Y tBodyAcc-mean()-Y
    ## 3 tBodyAcc-mean()-Z tBodyAcc-mean()-Z
    ## 4  tBodyAcc-std()-X  tBodyAcc-std()-X
    ## 5  tBodyAcc-std()-Y  tBodyAcc-std()-Y
    ## 6  tBodyAcc-std()-Z  tBodyAcc-std()-Z

Feature Formulas
----------------

``` r
features %>%
    select(id:axes, calculus:calcClose, arCoeffLevel:bandsEnergyUpper, angleOpen:angleClose) %>%
    unite(open, calcOpen, angleOpen, sep = "") %>%
    unite(signal, signal:axes, sep = "") %>%
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
    slice(c(1,16,26,38,303,555))
```

    ## # A tibble: 6 x 4
    ##      id                        name                         formula
    ##   <int>                       <chr>                           <chr>
    ## 1     1           tBodyAcc-mean()-X                mean(tBodyAcc-X)
    ## 2    16              tBodyAcc-sma()               sma(tBodyAcc-XYZ)
    ## 3    26      tBodyAcc-arCoeff()-X,1          arCoeff(tBodyAcc-X, 1)
    ## 4    38  tBodyAcc-correlation()-X,Y        correlation(tBodyAcc-XY)
    ## 5   303  fBodyAcc-bandsEnergy()-1,8 bandsEnergy(fBodyAcc-XYZ, 1, 8)
    ## 6   555 angle(tBodyAccMean,gravity)    angle(tBodyAccMean, gravity)
    ## # ... with 1 more variables: description <chr>

Features Measurements
---------------------

``` r
feature_measurements <- read_feature_measurements()
nrow(feature_measurements)
```

    ## [1] 5777739

``` r
format(object.size(feature_measurements), units = "auto")
```

    ## [1] "132.2 Mb"

``` r
head(feature_measurements)
```

    ##   window subject activity feature       value
    ## 1      1       1        5       1  0.28858451
    ## 2      1       1        5       2 -0.02029417
    ## 3      1       1        5       3 -0.13290514
    ## 4      1       1        5       4 -0.99527860
    ## 5      1       1        5       5 -0.98311061
    ## 6      1       1        5       6 -0.91352645

Inertial Signal Readings
------------------------

``` r
inertial_signals <- read_inertial_signals()
nrow(inertial_signals)
```

    ## [1] 11864448

``` r
format(object.size(inertial_signals), units = "auto")
```

    ## [1] "362.1 Mb"

``` r
head(inertial_signals)
```

    ##   window subject activity signal reading    value
    ## 1      1       1        5 tAcc-X       1 1.012817
    ## 2      1       1        5 tAcc-X       2 1.022833
    ## 3      1       1        5 tAcc-X       3 1.022028
    ## 4      1       1        5 tAcc-X       4 1.017877
    ## 5      1       1        5 tAcc-X       5 1.023680
    ## 6      1       1        5 tAcc-X       6 1.016974

Contingency Tables
------------------

### Feature Contingency Tables

#### Features by Domain

``` r
table(domain = features$domain)
```

    ## domain
    ##       f   t 
    ##   7 289 265

#### Features by Sensor

``` r
table(sensor = features$sensor)
```

    ## sensor
    ##       Acc Gyro 
    ##    7  343  211

#### Features by Calculus

``` r
table(calculus = features$calculus)
```

    ## calculus
    ##       angle     arCoeff bandsEnergy correlation      energy     entropy 
    ##           7          80         126          15          33          33 
    ##         iqr    kurtosis         mad         max     maxInds        mean 
    ##          33          13          33          33          13          33 
    ##    meanFreq         min    skewness         sma         std 
    ##          13          33          13          17          33

#### Features by Signal

``` r
table(signal = features$signal)
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

#### Features by Domain by Sensor

``` r
table(domain = features$domain, sensor = features$sensor)
```

    ##       sensor
    ## domain     Acc Gyro
    ##          7   0    0
    ##      f   0 184  105
    ##      t   0 159  106

#### Features by Calculus by Domain

``` r
table(calculus = features$calculus, domain = features$domain)
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

#### Features by Calculus by Sensor

``` r
table(calculus = features$calculus, features$sensor)
```

    ##              
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

#### Features by Signal by Domain

``` r
table(signal = features$signal, domain = features$domain)
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

#### Features by Signal by Sensor

``` r
table(signal = features$signal,  sensor = features$sensor)
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

#### Features by Signal by Calculus

``` r
table(signal = features$signal, calculus = features$calculus)
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

### Feature Measurement Contingency Tables

#### Feature Measurements by Subject

``` r
table(subject = feature_measurements$subject)
```

    ## subject
    ##      1      2      3      4      5      6      7      8      9     10 
    ## 194667 169422 191301 177837 169422 182325 172788 157641 161568 164934 
    ##     11     12     13     14     15     16     17     18     19     20 
    ## 177276 179520 183447 181203 184008 205326 206448 204204 201960 198594 
    ##     21     22     23     24     25     26     27     28     29     30 
    ## 228888 180081 208692 213741 229449 219912 210936 214302 192984 214863

#### Feature Measurements by Activity

``` r
table(activity = activity_labels$name[feature_measurements$activity])
```

    ## activity
    ##             LAYING            SITTING           STANDING 
    ##            1090584             996897            1069266 
    ##            WALKING WALKING_DOWNSTAIRS   WALKING_UPSTAIRS 
    ##             966042             788766             866184

#### Feature Measurements by Domain

``` r
table(domain = features$domain[feature_measurements$feature])
```

    ## domain
    ##               f       t 
    ##   72093 2976411 2729235

#### Feature Measurements by Sensor

``` r
table(sensor = features$sensor[feature_measurements$feature])
```

    ## sensor
    ##             Acc    Gyro 
    ##   72093 3532557 2173089

#### Feature Measurements by Calculus

``` r
table(calculus = features$calculus[feature_measurements$feature])
```

    ## calculus
    ##       angle     arCoeff bandsEnergy correlation      energy     entropy 
    ##       72093      823920     1297674      154485      339867      339867 
    ##         iqr    kurtosis         mad         max     maxInds        mean 
    ##      339867      133887      339867      339867      133887      339867 
    ##    meanFreq         min    skewness         sma         std 
    ##      133887      339867      133887      175083      339867

#### Feature Measurements by Signal

``` r
table(signal = features$signal[feature_measurements$feature])
```

    ## signal
    ##                          fBodyAcc     fBodyAccJerk  fBodyAccJerkMag 
    ##            72093           813621           813621           133887 
    ##      fBodyAccMag        fBodyGyro fBodyGyroJerkMag     fBodyGyroMag 
    ##           133887           813621           133887           133887 
    ##         tBodyAcc     tBodyAccJerk  tBodyAccJerkMag      tBodyAccMag 
    ##           411960           411960           133887           133887 
    ##        tBodyGyro    tBodyGyroJerk tBodyGyroJerkMag     tBodyGyroMag 
    ##           411960           411960           133887           133887 
    ##      tGravityAcc   tGravityAccMag 
    ##           411960           133887

#### Feature Measurements by Domain by Sensor

``` r
table(domain = features$domain[feature_measurements$feature], sensor = features$sensor[feature_measurements$feature])
```

    ##       sensor
    ## domain             Acc    Gyro
    ##          72093       0       0
    ##      f       0 1895016 1081395
    ##      t       0 1637541 1091694

#### Feature Measurements by Calculus by Domain

``` r
table(calculus = features$calculus[feature_measurements$feature], domain = features$domain[feature_measurements$feature])
```

    ##              domain
    ## calculus                    f       t
    ##   angle         72093       0       0
    ##   arCoeff           0       0  823920
    ##   bandsEnergy       0 1297674       0
    ##   correlation       0       0  154485
    ##   energy            0  133887  205980
    ##   entropy           0  133887  205980
    ##   iqr               0  133887  205980
    ##   kurtosis          0  133887       0
    ##   mad               0  133887  205980
    ##   max               0  133887  205980
    ##   maxInds           0  133887       0
    ##   mean              0  133887  205980
    ##   meanFreq          0  133887       0
    ##   min               0  133887  205980
    ##   skewness          0  133887       0
    ##   sma               0   72093  102990
    ##   std               0  133887  205980

#### Feature Measurements by Calculus by Sensor

``` r
table(calculus = features$calculus[feature_measurements$feature], sensor = features$sensor[feature_measurements$feature])
```

    ##              sensor
    ## calculus                Acc   Gyro
    ##   angle        72093      0      0
    ##   arCoeff          0 494352 329568
    ##   bandsEnergy      0 865116 432558
    ##   correlation      0  92691  61794
    ##   energy           0 205980 133887
    ##   entropy          0 205980 133887
    ##   iqr              0 205980 133887
    ##   kurtosis         0  82392  51495
    ##   mad              0 205980 133887
    ##   max              0 205980 133887
    ##   maxInds          0  82392  51495
    ##   mean             0 205980 133887
    ##   meanFreq         0  82392  51495
    ##   min              0 205980 133887
    ##   skewness         0  82392  51495
    ##   sma              0 102990  72093
    ##   std              0 205980 133887

#### Feature Measurements by Signal by Domain

``` r
table(signal = features$signal[feature_measurements$feature], domain = features$domain[feature_measurements$feature])
```

    ##                   domain
    ## signal                         f      t
    ##                     72093      0      0
    ##   fBodyAcc              0 813621      0
    ##   fBodyAccJerk          0 813621      0
    ##   fBodyAccJerkMag       0 133887      0
    ##   fBodyAccMag           0 133887      0
    ##   fBodyGyro             0 813621      0
    ##   fBodyGyroJerkMag      0 133887      0
    ##   fBodyGyroMag          0 133887      0
    ##   tBodyAcc              0      0 411960
    ##   tBodyAccJerk          0      0 411960
    ##   tBodyAccJerkMag       0      0 133887
    ##   tBodyAccMag           0      0 133887
    ##   tBodyGyro             0      0 411960
    ##   tBodyGyroJerk         0      0 411960
    ##   tBodyGyroJerkMag      0      0 133887
    ##   tBodyGyroMag          0      0 133887
    ##   tGravityAcc           0      0 411960
    ##   tGravityAccMag        0      0 133887

#### Feature Measurements by Signal by Sensor

``` r
table(signal = features$signal[feature_measurements$feature],  sensor = features$sensor[feature_measurements$feature])
```

    ##                   sensor
    ## signal                       Acc   Gyro
    ##                     72093      0      0
    ##   fBodyAcc              0 813621      0
    ##   fBodyAccJerk          0 813621      0
    ##   fBodyAccJerkMag       0 133887      0
    ##   fBodyAccMag           0 133887      0
    ##   fBodyGyro             0      0 813621
    ##   fBodyGyroJerkMag      0      0 133887
    ##   fBodyGyroMag          0      0 133887
    ##   tBodyAcc              0 411960      0
    ##   tBodyAccJerk          0 411960      0
    ##   tBodyAccJerkMag       0 133887      0
    ##   tBodyAccMag           0 133887      0
    ##   tBodyGyro             0      0 411960
    ##   tBodyGyroJerk         0      0 411960
    ##   tBodyGyroJerkMag      0      0 133887
    ##   tBodyGyroMag          0      0 133887
    ##   tGravityAcc           0 411960      0
    ##   tGravityAccMag        0 133887      0

#### Feature Measurements by Signal by Calculus

``` r
table(signal = features$signal[feature_measurements$feature], calculus = features$calculus[feature_measurements$feature])
```

    ##                   calculus
    ## signal              angle arCoeff bandsEnergy correlation energy entropy
    ##                     72093       0           0           0      0       0
    ##   fBodyAcc              0       0      432558           0  30897   30897
    ##   fBodyAccJerk          0       0      432558           0  30897   30897
    ##   fBodyAccJerkMag       0       0           0           0  10299   10299
    ##   fBodyAccMag           0       0           0           0  10299   10299
    ##   fBodyGyro             0       0      432558           0  30897   30897
    ##   fBodyGyroJerkMag      0       0           0           0  10299   10299
    ##   fBodyGyroMag          0       0           0           0  10299   10299
    ##   tBodyAcc              0  123588           0       30897  30897   30897
    ##   tBodyAccJerk          0  123588           0       30897  30897   30897
    ##   tBodyAccJerkMag       0   41196           0           0  10299   10299
    ##   tBodyAccMag           0   41196           0           0  10299   10299
    ##   tBodyGyro             0  123588           0       30897  30897   30897
    ##   tBodyGyroJerk         0  123588           0       30897  30897   30897
    ##   tBodyGyroJerkMag      0   41196           0           0  10299   10299
    ##   tBodyGyroMag          0   41196           0           0  10299   10299
    ##   tGravityAcc           0  123588           0       30897  30897   30897
    ##   tGravityAccMag        0   41196           0           0  10299   10299
    ##                   calculus
    ## signal                iqr kurtosis    mad    max maxInds   mean meanFreq
    ##                         0        0      0      0       0      0        0
    ##   fBodyAcc          30897    30897  30897  30897   30897  30897    30897
    ##   fBodyAccJerk      30897    30897  30897  30897   30897  30897    30897
    ##   fBodyAccJerkMag   10299    10299  10299  10299   10299  10299    10299
    ##   fBodyAccMag       10299    10299  10299  10299   10299  10299    10299
    ##   fBodyGyro         30897    30897  30897  30897   30897  30897    30897
    ##   fBodyGyroJerkMag  10299    10299  10299  10299   10299  10299    10299
    ##   fBodyGyroMag      10299    10299  10299  10299   10299  10299    10299
    ##   tBodyAcc          30897        0  30897  30897       0  30897        0
    ##   tBodyAccJerk      30897        0  30897  30897       0  30897        0
    ##   tBodyAccJerkMag   10299        0  10299  10299       0  10299        0
    ##   tBodyAccMag       10299        0  10299  10299       0  10299        0
    ##   tBodyGyro         30897        0  30897  30897       0  30897        0
    ##   tBodyGyroJerk     30897        0  30897  30897       0  30897        0
    ##   tBodyGyroJerkMag  10299        0  10299  10299       0  10299        0
    ##   tBodyGyroMag      10299        0  10299  10299       0  10299        0
    ##   tGravityAcc       30897        0  30897  30897       0  30897        0
    ##   tGravityAccMag    10299        0  10299  10299       0  10299        0
    ##                   calculus
    ## signal                min skewness    sma    std
    ##                         0        0      0      0
    ##   fBodyAcc          30897    30897  10299  30897
    ##   fBodyAccJerk      30897    30897  10299  30897
    ##   fBodyAccJerkMag   10299    10299  10299  10299
    ##   fBodyAccMag       10299    10299  10299  10299
    ##   fBodyGyro         30897    30897  10299  30897
    ##   fBodyGyroJerkMag  10299    10299  10299  10299
    ##   fBodyGyroMag      10299    10299  10299  10299
    ##   tBodyAcc          30897        0  10299  30897
    ##   tBodyAccJerk      30897        0  10299  30897
    ##   tBodyAccJerkMag   10299        0  10299  10299
    ##   tBodyAccMag       10299        0  10299  10299
    ##   tBodyGyro         30897        0  10299  30897
    ##   tBodyGyroJerk     30897        0  10299  30897
    ##   tBodyGyroJerkMag  10299        0  10299  10299
    ##   tBodyGyroMag      10299        0  10299  10299
    ##   tGravityAcc       30897        0  10299  30897
    ##   tGravityAccMag    10299        0  10299  10299

### Inertial Signal Reading Contingency Tables

#### Inertial Signal Readings by Subject

``` r
table(subject = inertial_signals$subject)
```

    ## subject
    ##      1      2      3      4      5      6      7      8      9     10 
    ## 399744 347904 392832 365184 347904 374400 354816 323712 331776 338688 
    ##     11     12     13     14     15     16     17     18     19     20 
    ## 364032 368640 376704 372096 377856 421632 423936 419328 414720 407808 
    ##     21     22     23     24     25     26     27     28     29     30 
    ## 470016 369792 428544 438912 471168 451584 433152 440064 396288 441216

#### Inertial Signal Readings by Activity

``` r
table(activity = activity_labels$name[inertial_signals$activity])
```

    ## activity
    ##             LAYING            SITTING           STANDING 
    ##            2239488            2047104            2195712 
    ##            WALKING WALKING_DOWNSTAIRS   WALKING_UPSTAIRS 
    ##            1983744            1619712            1778688

#### Inertial Signal Readings by Signal

``` r
table(signal = inertial_signals$signal)
```

    ## signal
    ##      tAcc-X      tAcc-Y      tAcc-Z  tBodyAcc-X  tBodyAcc-Y  tBodyAcc-Z 
    ##     1318272     1318272     1318272     1318272     1318272     1318272 
    ## tBodyGyro-X tBodyGyro-Y tBodyGyro-Z 
    ##     1318272     1318272     1318272

### Inertial Signal Readings by Signal by Activity

``` r
table(signal = inertial_signals$signal, activity = activity_labels$name[inertial_signals$activity])
```

    ##              activity
    ## signal        LAYING SITTING STANDING WALKING WALKING_DOWNSTAIRS
    ##   tAcc-X      248832  227456   243968  220416             179968
    ##   tAcc-Y      248832  227456   243968  220416             179968
    ##   tAcc-Z      248832  227456   243968  220416             179968
    ##   tBodyAcc-X  248832  227456   243968  220416             179968
    ##   tBodyAcc-Y  248832  227456   243968  220416             179968
    ##   tBodyAcc-Z  248832  227456   243968  220416             179968
    ##   tBodyGyro-X 248832  227456   243968  220416             179968
    ##   tBodyGyro-Y 248832  227456   243968  220416             179968
    ##   tBodyGyro-Z 248832  227456   243968  220416             179968
    ##              activity
    ## signal        WALKING_UPSTAIRS
    ##   tAcc-X                197632
    ##   tAcc-Y                197632
    ##   tAcc-Z                197632
    ##   tBodyAcc-X            197632
    ##   tBodyAcc-Y            197632
    ##   tBodyAcc-Z            197632
    ##   tBodyGyro-X           197632
    ##   tBodyGyro-Y           197632
    ##   tBodyGyro-Z           197632

References
----------

Wikipedia. Activity recognition. Available at <https://en.wikipedia.org/wiki/Activity_recognition>. Accessed 26-Jan-2017.

IWSC. International Symposium on Wearable Computers. Available at <http://www.iswc.net/>. Accessed 26-Jan-2017.

UbiComp. International Joint Conference on Pervasive Computting. Available at <http://www.ubicomp.org/>. Acccessed 26-Jan-2017.

Tanzeem Choudhury, Gaetano Borriello, et al. The Mobile Sensing Platform: An Embedded System for Activity Recognition. Appears in the IEEE Pervasive Magazine - Special Issue on Activity-Based Computing, April 2008.

Nishkam Ravi, Nikhil Dandekar, Preetham Mysore, Michael Littman. Activity Recognition from Accelerometer Data. Proceedings of the Seventeenth Conference on Innovative Applications of Artificial Intelligence (IAAI/AAAI 2005).

Want R., Hopper A., Falcao V., Gibbons J.: The Active Badge Location System, ACM Transactions on Information, Systems, Vol. 40, No. 1, pp. 91-102, January 1992.

Bieber G., Kirste T., Untersuchung des gruppendynamischen Aktivitaetsverhaltes im Office-Umfeld, 7. Berliner Werkstatt Mensch-Maschine-Systeme, Berlin, Germany, 2007

Tao Gu, Zhanqing Wu, Liang Wang, Xianping Tao, and Jian Lu. Mining Emerging Patterns for Recognizing Activities of Multiple Users in Pervasive Computing. In Proc. of the 6th International Conference on Mobile and Ubiquitous Systems: Computing, Networking and Services (MobiQuitous '09), Toronto, Canada, July 13–16, 2009.

Dawud Gordon, Jan-Hendrik Hanne, Martin Berchtold, Ali Asghar Nazari Shirehjini, Michael Beigl: Towards Collaborative Group Activity Recognition Using Mobile Devices, Mobile Networks and Applications 18(3), 2013, p. 326-340

Lewin, K. Field theory in social science: selected theoretical papers. Social science paperbacks. Harper, New York, 1951.

Hirano, T., and Maekawa, T. A hybrid unsupervised/supervised model for group activity recognition. In Proceedings of the 2013 International Symposium on Wearable Computers, ISWC ’13, ACM (New York, NY, USA, 2013), 21–24

Brdiczka, O., Maisonnasse, J., Reignier, P., and Crowley, J. L. Detecting small group activities from multimodal observations. Applied Intelligence 30, 1 (July 2007), 47–57.

Dawud Gordon, Group Activity Recognition Using Wearable Sensing Devices, Dissertation, Karlsruhe Institute of Technology, 2014

Acknowledgment
--------------

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.
