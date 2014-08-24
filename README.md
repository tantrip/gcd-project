Getting and Cleaning Data - Course Project
===========

####This is the submission for the above course project on coursera. Please see below the assumptions and logic of this script.

-----

####Purpose

The purpose of this script is to clean the [data collected from Samsung Galaxy S smartphones from 30 individuals and over 6 types of activity](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and to create a summarized tidy data set according to the below specifications for the course project.

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

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


