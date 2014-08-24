### Introduction

This file describes the background, the data files and the general logic / steps to clean and tidy the smartphone data.

Please Note: One of the big assumptions I made is that the mean and std of "all" measurements (not just the direct observations but also calculated and secondary / tertiary measurements like fourier tranforms) needs to be in the tidy dataset. I could have assumed the exact opposite just as easily but I chose this as the working assumption which gives me more data in the tidy dataset than less!

### Data Set Description (per the source)

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

#### For each observation (activity per subject) the following high level information is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

#### The dataset includes the following files:

* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

### Variables

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

### Steps and details

The RScript in this repository (run_analysis.R) performs the above steps and provides the tidy data as "tidydata.txt"

###Assumptions

* Please set the working directory to where the UCIHARDataset is extracted (that folder should be at the same level as this script)
* Please pass an inversible matrix to the function as the fringe cases and validation are not handled in the script based on instructions

###Logic

This script does the following actions to meet each of the required goals:

##### Merges the training and the test sets to create one data set.
* Features.text is used as the names vector for training and test datsets (X_test.txt and X_train.txt)
* X_test.txt and X_train.txt are read into memory and colnames are updated with the features.txt information
* subject_test.txt and subject_train.txt are used as the column vectors and are appended (colbind) to the above above data frames respectively
* test_y.txt and train_y.txt are the activity data sets that are also appended to the above data frames respectively as the activity identifiers for the rows in the datasets
* Then we merge (rbind) the test and train data sets to create one dataset

####Extracts only the measurements on the mean and standard deviation for each measurement. 
* We use grepl and merge to now select only the columns that have "mean" or "std" in their names

####Uses descriptive activity names to name the activities in the data set
* We use the activitylabels.txt file as the descriptive activity names and join that data frame with the test and train data frames on the activity id to populate descriptive activity names
* Note: We did this prior to the merge of test and train datasets but it can be done after too

####Appropriately labels the data set with descriptive variable names.
* We use gsub to iteratively refine the names of the extracted data set's columns to be descriptive. Ex: tBody to "Time-Body"
* We can continue to change the names till we feel comfortabl that the names are descriptive enough

####Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
* We use melt function to group the data set on activity name and subject along with pivoting the data on the column names as variables
* We use ddply to summarize the resulting data frame and calculate the mean for each variable (column name), subject and acvitity
* We write the resulting data frame through write.table with row.name = F option as instructed and have our file!!

### Column Names in the tidy data set:
* Subject column represents each of the 30 subjects that are part of the study
* Activity column represents each of the 6 activities that were part of the study
* variable column represents each of the relevant measures extracted from the original data. Names are self descriptive. Ex: Time prefixed variables are part of the time based collection during study and Fourier prefixed variables are part of the transformed / calculated FFT values of the collected data. XAxis, YAxis and ZAxis suffixed observations are also self explanatory. Accelerometer vs Gyroscope readings are tagged with that text in their names appropriately. Mean vs Std measures are also tagged appropriately.