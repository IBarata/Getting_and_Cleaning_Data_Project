####Getting and Cleaning data Project

#Set working directory:
setwd("C:/Users/Inga/Desktop/Coursera/3_Getting_and_Cleaning_Data")

#Check if file exists:
if(!file.exists("./dataProject")){dir.create("./dataProject")}
     
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
     
#Download file:
download.file(url, destfile= "./dataProject/dataset.zip")

#Record download date
dateDownload <- date() #Thu Aug 24 12:20:07 2017

#Unzip dataset
unzip(zipfile="./dataProject/dataset.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = "./dataProject", unzip = "internal",
      setTimes = FALSE)

#____

##1.Merging the training and the test sets to create one data set:

#Preparing data to merge:

#Reading data
  #training:
x_train <- read.table("./dataProject/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./dataProject/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./dataProject/UCI HAR Dataset/train/subject_train.txt")

  #testing:
x_test <- read.table("./dataProject/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./dataProject/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./dataProject/UCI HAR Dataset/test/subject_test.txt")

  #features:
features <- read.table('./dataProject/UCI HAR Dataset/features.txt')

  #activity labels:
activityLabels = read.table('./dataProject/UCI HAR Dataset/activity_labels.txt')

#Assign names to columns
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#Merging the training and the test sets in one data set:
train <- cbind(y_train, subject_train, x_train)
test <- cbind(y_test, subject_test, x_test)
all_data <- rbind(train,test)

#___

##2.Extracting only the measurements on the mean and standard deviation for each measurement

#Reading column names
colNames <- colnames(all_data)

#Extracting data - creating vector for defining ID, mean and standard deviation:
mean_std <- (grepl("activityId" , colNames) | 
              grepl("subjectId" , colNames) | 
              grepl("mean.." , colNames) | 
              grepl("std.." , colNames) 
)

#Creating data set from all_data with the desired columns

set_mean_std <- all_data[ , mean_std == TRUE]

#___

##3.Use descriptive activity names to name the activities in the data set

ActivityNames <- merge(set_mean_std, activityLabels,
                       by='activityId',
                       all.x=TRUE)

##4.Appropriately labeling the data set with descriptive variable names

#Done in previous steps, with the codes:

    #mean_std <- (grepl("activityId" , colNames) | 
                # grepl("subjectId" , colNames) | 
                # grepl("mean.." , colNames) | 
                # grepl("std.." , colNames) 
    #)

#and

    #set_mean_std <- all_data[ , mean_std == TRUE]

#___

##5.Creating a second, independent tidy data set with the average of each variable for each activity and each subject:

#Making second tidy data set:
secondTidySet <- aggregate(. ~subjectId + activityId, ActivityNames, mean)
secondTidySet <- secondTidySet[order(secondTidySet$subjectId, secondTidySet$activityId),]

#Writing second tidy data set in txt file:
write.table(secondTidySet, "secondTidySet.txt", row.name=FALSE)
