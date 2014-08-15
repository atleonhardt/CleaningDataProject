We follow the commented code below and explain the work done in this project.  The names of variables were not changed because it looks more natural to keep
the names of the original datasets. The Course project data set includes:
-run_analysis.R
-Readme.txt
-Codebook.txt
-The Tiny.txt file submitted on Coursera.


### First we load the library reshape2 for melt and dcast commands used towards the end of the analysis. 

library(reshape2)




### We load the files into tables using the read.table command and proceed to bind the tables. We use the features vector to name the columns.

xtest<-read.table("X_test.txt")
xtrain<-read.table("X_train.txt")
xtogether<-rbind(xtest,xtrain)
feat<-read.table("features.txt")
names(xtogether)<-feat[[2]]




### We want to get only the means and standard deviations (which appear in the column names as "mean()" and "std()")
### There are also "meanFreq()" variables that we don't want to include, so we build the "remove" vector.
### We then create the xmeanstd table which contains only the desired variables.

means<-grep("mean",names(xtogether))
remove<-grep("meanF",names(xtogether))
means<-means [! means %in% remove]
std<-grep("std",names(xtogether))
meanstd<-c(means,std)
xmeanstd<-xtogether[,meanstd]




### We load the labels and bind them into one vector.  Then the numbers are replaced by the activity represented by a string.

trainlabels<-read.table("y_train.txt")
testlabels<-read.table("y_test.txt")
labelsall<-rbind(testlabels,trainlabels)
labelsall[labelsall==1]<-"WALKING"
labelsall[labelsall==2]<-"WALKING_UPSTAIRS"
labelsall[labelsall==3]<-"WALKING_DOWNSTAIRS"
labelsall[labelsall==4]<-"SITTING"
labelsall[labelsall==5]<-"STANDING"
labelsall[labelsall==6]<-"LAYING"




### Now we add the labels as a column to the table.

data<-cbind(labelsall,xmeanstd)




### Load the subject vector and bind them. 

subject_test<-read.table("subject_test.txt")
subject_train<-read.table("subject_train.txt")
allsubject<-rbind(subject_test,subject_train)




### This step is to combine into a single column the subject number AND the activity he performs. This will allow us to use the dcast and melt commands.

data2<-cbind(paste(allsubject[[1]],data[[1]]),xmeanstd)
names(data2)[1]<-"subjectactivity"




### We finally construct the "Tidy" table, but it orders the column in the undesired format "1,10,11,12...,19,2,20.. etc"
### So we do gsubs and add an extra zero at the beginning of single digits.

Melt <- melt(data2,id=c("subjectactivity"),measure.vars=names(data2)[2:67])
Tidy <- dcast(Melt, subjectactivity ~ variable,mean)
Tidy[[1]]<-gsub("^1 ","01 ",Tidy[[1]])
Tidy[[1]]<-gsub("^2 ","02 ",Tidy[[1]])
Tidy[[1]]<-gsub("^3 ","03 ",Tidy[[1]])
Tidy[[1]]<-gsub("^4 ","04 ",Tidy[[1]])
Tidy[[1]]<-gsub("^5 ","05 ",Tidy[[1]])
Tidy[[1]]<-gsub("^6 ","06 ",Tidy[[1]])
Tidy[[1]]<-gsub("^7 ","07 ",Tidy[[1]])
Tidy[[1]]<-gsub("^8 ","08 ",Tidy[[1]])
Tidy[[1]]<-gsub("^9 ","09 ",Tidy[[1]])




###Now we can order the table correctly, and create the Tidy.txt file.

Tidy<-Tidy[order(Tidy[[1]]),]
row.names(Tidy)<-1:180

write.table(Tidy,file="Tidy.txt")



