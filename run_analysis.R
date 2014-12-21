#This is Course project for Coursera Getting & Cleaning Data
#Data source:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#The code will do the following steps on UCIHAR dataset
#Merge the training & test dataset
#Extract only the measurements on the mean and standard deviation for each measurement
#Use descriptive activity names to name the activities in the data set
#Label the data set with descriptive activity names as directed
#Create a tidy dataset and save it in the working directory


#Provide the working directory path for the loc variable and setting the work directory
loc<-"Please provide the working directory path here"
setwd(loc)

#Downloading the file from the source followed by unzipping

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Dataset.zip",method="auto")
unzip(zipfile="./Dataset.zip",exdir="./UCI HAR Dataset")

#setting up the path to the UCI dataset location

path <- file.path("./UCI HAR Dataset" , "UCI HAR Dataset")

#Read the Activity files from the the saved path

ActivityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)

#Read the Subject files from the the saved path

SubjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)

#Read Fearures files from the the saved path

FeaturesTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

#Merging the training and the test sets
#Concatenating the data tables by rows

Subject <- rbind(dataSubjectTrain, SubjectTest)
Activity<- rbind(dataActivityTrain, ActivityTest)
Features<- rbind(dataFeaturesTrain, FeaturesTest)

#set the names to variables

names(Subject)<-c("subject")
names(Activity)<- c("activity")
FeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(Features)<- FeaturesNames$V2

#Merge columns to get the data frame

Combine <- cbind(Subject, Activity)
Data <- cbind(Features,Combine)

#Extracts only the measurements on the mean and standard deviation for each measurement

FeaturesNames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)",FeaturesNames$V2)]
selectedNames<-c(as.character(FeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#Uses descriptive activity names to name the activities

activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)

#Labels the data set

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#Creates an independent tidy data set with the average of each variable and saves in working directory

Data<-aggregate(. ~subject + activity, Data, mean)
Data<-Data[order(Data2$subject,Data2$activity),]
write.table(Data, file = "tidydata.txt",row.name=FALSE)
