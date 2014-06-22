## Merges the training and the test sets to create one data set.
#this can be run as long as the Samsung data is in your working directory
SamsungData <- "getdata_projectfiles_UCI HAR Dataset.zip"

ytrain <- read.table(unz(SamsungData, filename="UCI HAR Dataset/train/y_train.txt"))
xtrain <- read.table(unz(SamsungData, filename="UCI HAR Dataset/train/X_train.txt"))
subjectTrain <- read.table(unz(SamsungData, filename="UCI HAR Dataset/train/subject_train.txt"))

ytest  <- read.table(unz(SamsungData, filename="UCI HAR Dataset/test/y_test.txt"))
xtest  <- read.table(unz(SamsungData, filename="UCI HAR Dataset/test/X_test.txt"))
subjectTest <- read.table(unz(SamsungData, filename="UCI HAR Dataset/test/subject_test.txt"))

features <- read.table(unz(SamsungData, filename="UCI HAR Dataset/features.txt"), stringsAsFactors=FALSE)
activitylabels <- read.table(unz(SamsungData, filename="UCI HAR Dataset/activity_labels.txt"), stringsAsFactors=FALSE)

# name columns
colnames(ytrain) <- "labels"
colnames(subjectTrain) <- "subject"

colnames(ytest) <- "labels"
colnames(subjectTest) <- "subject"

# add labels and subjects to dataset
xtrain <- cbind(xtrain, ytrain)
xtrain <- cbind(xtrain, subjectTrain)

xtest <- cbind(xtest, ytest)
xtest <- cbind(xtest, subjectTest)

# merge test and training data
mergedData <- rbind(xtrain, xtest)

## Extracts only the measurements on the mean and standard deviation for each measurement. 

measurementsExtract <- (grepl("mean\\(\\)", features$V2)  | grepl("std\\(\\)", features$V2))
df <- mergedData[ , c(measurementsExtract, c(TRUE, TRUE))]

## Uses descriptive activity names to name the activities in the data set

df$labels <- factor(df$labels, labels=activitylabels$V2)

## Appropriately labels the data set with descriptive variable names. 

names <- features[measurementsExtract, ]
# rename - remove "()-" from names
names$V2 <- gsub("(\\-)|(\\()|(\\))", "", names$V2)
colnames(df) <- c(names$V2, c("activity", "subject"))
c(names$V2, c("activity", "subject"))

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
library(reshape)

moltenData <- melt(df, id.vars=c("subject", "activity"))
x <- cast(data=moltenData, subject + activity ~ variable, fun.aggregate=mean)
#reorder by subject and activity.  Do not print result with help of invisible().
invisible(x[order(x$subject, x$activity),])
#names(xx)

#write data to file "tidy.txt"
write.table(x, file="tidy.txt", sep=",", row.names= FALSE, col.names=TRUE)

# to read data
xxx <- read.table("tidy.txt", sep=",", header=TRUE)
