## Read in Training Data
setwd("~/Analytics/GetCleanData/UCI HAR Dataset")
alabel<-read.table("activity_labels.txt")
feat<-read.table("features.txt")
setwd("~/Analytics/GetCleanData/UCI HAR Dataset/train")
sub_tr<-read.table("subject_train.txt")
y_tr<-read.table("y_train.txt")
x_tr<-read.table("x_train.txt")
colnames(x_tr)<-feat$V2
x_tr[,"subject"]<-sub_tr$V1
x_tr[,"activity"]<-y_tr
## Resulting dataset is x_tr[7352 X 563]

## Read in Test Data
setwd("~/Analytics/GetCleanData/UCI HAR Dataset/test")
x_te<-read.table("X_test.txt")
y_te<-read.table("y_test.txt")
colnames(x_te)<-feat$V2
sub_te<-read.table("subject_test.txt")
x_te[,"subject"]<-sub_te
x_te[,"activity"]<-y_te
## Resulting dataset is x_te[2947 X 563]

## Merge training and test data
alldata<-merge(x_tr,x_te,all=T)
## Resulting dataset is alldata[10299 X 563]

## Replace activity code (1~6) by activity name
for (i in 1:length(alldata)) {alldata$activity[i]<-as.character(alabel[alldata$activity[i],2])}

# Keep only variables containing mean() and std(), plus"subject" and "activity"
fea_num1<-grep("mean",feat$V2)
fea_num2<-grep("std",feat$V2)
fea_num<-c(fea_num1,fea_num2,562,563)
cleandata<-alldata[,fea_num]
## Resulting dataset is cleandata[10299 X 81]

# Average all other variables for each subject and each activity
library(reshape2)
molten = melt(cleandata, id = c("subject", "activity"))
subject_data<-dcast(molten,subject ~ variable,mean)
activity_data<-dcast(molten,activity ~ variable,mean)
clean_mean<-dcast(molten, subject+activity ~ variable, mean)
## Resulting dataset is clean_mean[180 X 81]
