HAR-analysis
================
by Maurício Collaça

Human Activity Recognition (HAR) analysis Code Book
---------------------------------------------------

This code book that describes the variables, data, transformations and work performed to clean up the data from Human Activity Recognition (HAR) using smartphones Data Set Version 1.0

The purpose of this project is to collect, tidy, filter and produce some statistics of the HAR data set, producing a new tidy data set.

The data set used in the project is from the University of California Irvine (UCI) Machine Learning Repository: Human Activity Recognition Using Smartphones Data Set Version 1.0. The data set represent data collected from the embedded accelerometer and gyroscope of the Samsung Galaxy S smartphone. A full description is available at:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

The data set for the project:

Mirror:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>
Original:
<http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip>

Data set description
--------------------

Source: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

Abstract: Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.

Data Set Characteristics: Multivariate, Time-Series
Number of Instances: 10299
Number of Attributes: 561
Associated Tasks: Classification, Clustering
Missing Values? N/A

### Data Set information

The experiments have been carried out with a group of 30 volunteers
Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING)
Captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz.
The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.
The sensor signals (accelerometer and gyroscope) were pre-processed in 128 readings/window).
The sensor acceleration signal, which has gravitational and body motion components, was separated into body acceleration and gravity.
The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used.
From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

### Attribute Information

For each record in the dataset it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.

### Feature Selection

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern: '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are:

mean(): Mean value std(): Standard deviation
mad(): Median absolute deviation
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values.
iqr(): Interquartile range
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal
kurtosis(): kurtosis of the frequency domain signal
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

Data folders
------------

Source: <http://archive.ics.uci.edu/ml/machine-learning-databases/00240/>

### Notes

-   Features are normalized and bounded within \[-1,1\].
-   Each feature vector is a row on the text file.
-   The units used for the accelerations (total and body) are 'g's (gravity of Earth -&gt; 9.80665 m/seg2).
-   The gyroscope units are rad/seg.

### For the overall data set it is provided

-   Information about the variables used on the feature vector. Shows information about the variables used on the feature vector.

    ./HAR-analysis/UCI HAR Dataset/features\_info.txt

-   List of all features.

    ./HAR-analysis/UCI HAR Dataset/features.txt

-   Links the class labels with their activity name

    ./HAR-analysis/UCI HAR Dataset/activity\_labels.txt

### For each record of the data set it is provided

-   A 561-feature vector with time and frequency domain variables.

    ./HAR-analysis/UCI HAR Dataset/**train**/X\_train.txt
    ./HAR-analysis/UCI HAR Dataset/**test**/X\_test.txt

-   Its activity label.

    ./HAR-analysis/UCI HAR Dataset/**train**/y\_train.txt
    ./HAR-analysis/UCI HAR Dataset/**test**/y\_test.txt

-   An identifier of the subject who carried out the experiment. Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

    ./HAR-analysis/UCI HAR Dataset/**train**/subject\_train.txt
    ./HAR-analysis/UCI HAR Dataset/**test**/subject\_test.txt

-   Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.

    -   The acceleration signal from the smartphone accelerometer for the X, Y and Z axis in standard gravity units 'g'. Every row shows a 128 element vector.

        ./HAR-analysis/UCI HAR Dataset/**train**/Inertial Signals/
        total\_acc\_x\_train.txt
        total\_acc\_y\_train.txt
        total\_acc\_z\_train.txt
        ./HAR-analysis/UCI HAR Dataset/**test**/Inertial Signals/
        total\_acc\_x\_test.txt
        total\_acc\_y\_test.txt
        total\_acc\_z\_test.txt

    -   The body acceleration signal obtained by subtracting the gravity from the total acceleration for the X, Y and Z axis.

        ./HAR-analysis/UCI HAR Dataset/**train**/Inertial Signals/
        body\_acc\_x\_train.txt
        body\_acc\_y\_train.txt
        body\_acc\_z\_train.txt ./HAR-analysis/UCI HAR Dataset/**test**/Inertial Signals/
        body\_acc\_x\_test.txt
        body\_acc\_y\_test.txt
        body\_acc\_z\_test.txt

-   Triaxial Angular velocity from the gyroscope for the X, Y and Z axis. The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

    ./HAR-analysis/UCI HAR Dataset/**train**/Inertial Signals/
    body\_gyro\_x\_train.txt
    body\_gyro\_y\_train.txt
    body\_gyro\_z\_train.txt
    ./HAR-analysis/UCI HAR Dataset/**test**/Inertial Signals/
    body\_gyro\_x\_test.txt
    body\_gyro\_y\_test.txt
    body\_gyro\_z\_test.txt

Variables selected for analysis
-------------------------------

Data
----

Transformations
---------------

Acknowledgment
--------------

\[1\] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.
