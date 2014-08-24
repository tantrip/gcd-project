library(plyr)
library(reshape2)

setwd("UCIHARDataSet/") # please set the working directory to where the UCIHARDataset is extracted (that folder should be at the same level as this script)

features <- read.table("features.txt")
colnames(features) <- c("featureid", "featurename")

activitylabels <- read.table("activity_labels.txt")
colnames(activitylabels) <- c("activity", "activityname")

# Get the test set ready

testx <- read.table("test/X_test.txt")
colnames(testx) <- features$featurename #attach column names to to testx

testsubject <-  read.table("test/subject_test.txt") #subjects - colbind to testx
colnames(testsubject) <- c("subject")

testy <- read.table("test/Y_test.txt") #activity - colbind to testx
colnames(testy) <- c("activity")

fulltest <- cbind(testx, testsubject, testy)

## Get the training set ready

trainx <- read.table("train/X_train.txt")
colnames(trainx) <- features$featurename # attach column names to trainx

trainsubject <-  read.table("train/subject_train.txt") #subjects - colbind to trainx
colnames(trainsubject) <- c("subject")

trainy <- read.table("train/Y_train.txt") #activity - colbind to trainx
colnames(trainy) <- c("activity")

fulltrain <- cbind(trainx, trainsubject, trainy)

# 1. Merges the training and the test sets to create one data set.
merged <- rbind(fulltest, fulltrain)

# 3. Uses descriptive activity names to name the activities in the data set
# append activityname to merged dataset by looking up from activitylabels joined by 'activity' across both data frames
merged <- merge(x = merged, y = activitylabels, by = "activity", all = TRUE)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# extract only the columns that correspond to mean and standard deviation - along with activity and subject columns we need
mergedselect <- merged[,grepl(paste0(c('mean', 'std', 'activityname', 'subject'),collapse="|"),colnames(merged))]


# 4. Appropriately labels the data set with descriptive variable names. 
colnames(mergedselect) <- gsub("tBody", "Time-Body", colnames(mergedselect))
colnames(mergedselect) <- gsub("BodyAcc", "Body-Accelerometer", colnames(mergedselect))
colnames(mergedselect) <- gsub("tGravity", "Time-Gravity", colnames(mergedselect))
colnames(mergedselect) <- gsub("Gyro", "-Gyroscope", colnames(mergedselect))
colnames(mergedselect) <- gsub("Acc-", "Accelerometer-", colnames(mergedselect))
colnames(mergedselect) <- gsub("fBody", "Fourier-Body", colnames(mergedselect))
colnames(mergedselect) <- gsub("-X", "-XAxis", colnames(mergedselect))
colnames(mergedselect) <- gsub("-Y", "-YAxis", colnames(mergedselect))
colnames(mergedselect) <- gsub("-Z", "-ZAxis", colnames(mergedselect))
colnames(mergedselect) <- gsub("BodyBody", "Body-Body", colnames(mergedselect))


# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

melted <- melt(mergedselect, id.vars=c("subject", "activityname"))
tidy <- ddply(melted, c("subject", "activityname", "variable"), summarise, mean = mean(value))

write.table(tidy, "tidydata.txt", sep="\t", row.name=FALSE)
