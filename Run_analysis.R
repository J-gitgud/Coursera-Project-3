## Get dataset and load usefull libraries

path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

library(dplyr)


##Create data frames 

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

##Merge training and test datasets

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Training_tests <- cbind(Subject, Y, X)

## Mean and standard deviation

Compiled <- Training_tests %>% select(subject, code, contains("mean"), contains("std"))

## labels the data set with descriptive variable names

Compiled$code <- activities[Compiled$code, 2]

names(Compiled)[2] = "activity"
names(Compiled)<-gsub("Acc", "accelerometer", names(Compiled))
names(Compiled)<-gsub("Gyro", "gyroscope", names(Compiled))
names(Compiled)<-gsub("BodyBody", "body", names(Compiled))
names(Compiled)<-gsub("Mag", "magnitude", names(Compiled))
names(Compiled)<-gsub("^t", "time", names(Compiled))
names(Compiled)<-gsub("^f", "frequency", names(Compiled))
names(Compiled)<-gsub("tBody", "TimeBody", names(Compiled))
names(Compiled)<-gsub("-mean()", "Mean", names(Compiled), ignore.case = TRUE)
names(Compiled)<-gsub("-std()", "Deviation", names(Compiled), ignore.case = TRUE)
names(Compiled)<-gsub("-freq()", "frequency", names(Compiled), ignore.case = TRUE)
names(Compiled)<-gsub("angle", "Angle", names(Compiled))
names(Compiled)<-gsub("gravity", "gravity", names(Compiled))

## second tidy data set

second <- Compiled %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean))
write.table(Second, "FinalData.txt", row.name=FALSE)
