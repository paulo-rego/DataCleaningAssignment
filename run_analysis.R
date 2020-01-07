
#Reading train data
y_train <- read.table("~/R/week4/train/y_train.txt")
x_train <- read.table("~/R/week4/train/x_train.txt")
subject_train <- read.table("~/R/week4/train/subject_train.txt")

#Reading test data
y_test <- read.table("~/R/week4/test/y_test.txt", quote="\"")
x_test <- read.table("~/R/week4/test/X_test.txt", quote="\"")
subject_test <- read.table("~/R/week4/test/subject_test.txt")

#Reading features and labels
features <- read.table("~/R/week4/features.txt", stringsAsFactors=FALSE)
activity_labels <- read.table("~/R/week4/activity_labels.txt",stringsAsFactors=FALSE)

#Naming the columns before merging the data
names(subject_test) = "subject_id"
names(subject_train) = "subject_id"
names(y_train) = "activity"
names(y_test) = "activity"
names(x_test) = features$V2
names(x_train) = features$V2

#Merging all test data into a single dataframe
test <- cbind(subject_test,y_test,x_test)

#Merging all train data into a single dataframe
train <- cbind(subject_train,y_train,x_train)

#Merging train and test data into a single dataframe
allData <- rbind(train,test)

#Replacing activity id with activity name
allData[,2] <- factor(allData[,2], levels=activity_labels$V1, labels=activity_labels$V2)

#Getting which columns will be relavant from now on. Searchs for mean() and std() on the column names
relevant <- c(1,2,grep("[Mm]ean\\(\\)",names(allData)),grep("[Ss]td\\(\\)",names(allData)))

#Subsetting relevant data
relevantData <- allData[,relevant]

#Altering the column names to make them more understandable
names <- colnames(relevantData)
names <- gsub("^t","time_",names)
names <- gsub("^f","frequency_",names)
names <- gsub("-X","_xAxis",names)
names <- gsub("-Y","_yAxis",names)
names <- gsub("-Z","_zAxis",names)
names <- gsub("-std\\(\\)", "_std",names)
names <- gsub("-mean\\(\\)", "_mean",names)
names <- gsub("Jerk", "_jerk",names)
names <- gsub("Mag", "_magnitude",names)
names <- gsub("Gyro", "_gyroscope",names)
names <- gsub("BodyBody", "body",names)
names <- gsub("Body", "body",names)
names <- gsub("Acc", "_acceleration",names)

#Applying the new names
names(relevantData) <- names

#Changing activity names to lower case because all caps is an eyesore
relevantData$activity <- tolower(relevantData$activity)

#loading Reshape2 library so it's easier to melt and reshape the dataframe
library("reshape2")

#Melting the DataFrame
longData <- melt(relevantData, id=1:2, measure.vars=3:68)

#Casting the data and summarizing it by mean
finalData <- dcast(longData, subject_id + activity ~ variable, mean)

#Saving the tidy dataframe
write.table(finalData, "tidyData.txt", row.name = FALSE )

