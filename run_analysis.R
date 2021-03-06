#install dplyr
if(!"dplyr" %in% rownames(installed.packages())) {install.packages("dplyr")}

#load dplyr
if(!"dplyr" %in% rownames(.packages())) {library(dplyr)}

#install tidyr
if(!"tidyr" %in% rownames(installed.packages())) {install.packages("tidyr")}

#load tidyr
if(!"tidyr" %in% rownames(.packages())) {library(tidyr)}

#create directory
if(!file.exists("./data/activitydata")){dir.create("./data/activitydata")}

#assign URL
file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#download data (zip)
if(!file.exists("./data/activitydata/activitydata.zip")){download.file(file.url,destfile="./data/activitydata/activitydata.zip")}

#unzip data
if(!file.exists("./data/activitydata/UCI HAR Dataset")){unzip("./data/activitydata/activitydata.zip",exdir = "./data/activitydata")}

#load variable names
variables <- as.vector(t(read.table("./data/activitydata/UCI HAR Dataset/features.txt",colClasses = c("NULL",NA))))

#clean variable descriptions
variables <- gsub("^t","Time",variables)
variables <- gsub("^f","Frequency",variables)
variables <- gsub("\\(","",variables)
variables <- gsub("\\)","",variables)
variables <- gsub("\\-","",variables)
variables <- gsub("\\,","",variables)

#load test data set
test_data <-read.table("./data/activitydata/UCI HAR Dataset/test/X_test.txt", col.names = variables)

#load test labels
test_labels <-read.table("./data/activitydata/UCI HAR Dataset/test/y_test.txt")

#apply descriptive variable names to test labels
test_labels <- mutate(test_labels, activity = gsub("1","walking",V1))[2]
test_labels <- mutate(test_labels, activity = gsub("2","walking_upstairs",activity))
test_labels <- mutate(test_labels, activity = gsub("3","walking_downstairs",activity))
test_labels <- mutate(test_labels, activity = gsub("4","sitting",activity))
test_labels <- mutate(test_labels, activity = gsub("5","standing",activity))
test_labels <- mutate(test_labels, activity = gsub("6","laying",activity))

#load test subjects
test_subjects <-read.table("./data/activitydata/UCI HAR Dataset/test/subject_test.txt")

#assign column name to test subject data
colnames(test_subjects)[1] <- "subject"

#load train data
train_data <-read.table("./data/activitydata/UCI HAR Dataset/train/X_train.txt",col.names = variables)

#load train labels
train_labels <-read.table("./data/activitydata/UCI HAR Dataset/train/y_train.txt")

#apply descriptive variable names to train labels
train_labels <- mutate(train_labels, activity = gsub("1","walking",V1))[2]
train_labels <- mutate(train_labels, activity = gsub("2","walking_upstairs",activity))
train_labels <- mutate(train_labels, activity = gsub("3","walking_downstairs",activity))
train_labels <- mutate(train_labels, activity = gsub("4","sitting",activity))
train_labels <- mutate(train_labels, activity = gsub("5","standing",activity))
train_labels <- mutate(train_labels, activity = gsub("6","laying",activity))

#load train subjects
train_subjects <-read.table("./data/activitydata/UCI HAR Dataset/train/subject_train.txt")

#assign column name to train subject data
colnames(train_subjects)[1] <- "subject"

#combine test data (data, labels, subjects)
train <- as.data.frame(cbind(group="train",subject=train_subjects,label=train_labels,train_data))

#combine train data (data, labels, subjects)
test <- as.data.frame(cbind(group="test",subject = test_subjects,label = test_labels,test_data))

#combine test and train data sets
all <- as.data.frame(rbind(test,train))

#select columns with mean and standard deviation
mean.std <- select(all, "subject", "activity", grep("[M-m]ean",names(all)),grep("std",names(all)))

#group by activity and subject
means <- mean.std %>%
  group_by(activity, subject)

#summarise groups
summarise <- summarise_all(means,funs(mean))

#remove old objects
rm(file.url,variables,test,test_data,test_labels,test_subjects,train,train_data,train_labels,train_subjects,all,means)

#create .txt file
#write.table(summarise,"summarise.txt",row.names = FALSE)

#create csv files
#write.csv(mean.std,"mean.std.csv")
#write.csv(summarise,"summarise.csv")
