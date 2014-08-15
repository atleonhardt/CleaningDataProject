library(reshape2)

xtest<-read.table("X_test.txt")
xtrain<-read.table("X_train.txt")
xtogether<-rbind(xtest,xtrain)
feat<-read.table("features.txt")
names(xtogether)<-feat[[2]]


means<-grep("mean",names(xtogether))
remove<-grep("meanF",names(xtogether))
means<-means [! means %in% remove]
std<-grep("std",names(xtogether))
meanstd<-c(means,std)
xmeanstd<-xtogether[,meanstd]

trainlabels<-read.table("y_train.txt")
testlabels<-read.table("y_test.txt")
labelsall<-rbind(testlabels,trainlabels)


labelsall[labelsall==1]<-"WALKING"
labelsall[labelsall==2]<-"WALKING_UPSTAIRS"
labelsall[labelsall==3]<-"WALKING_DOWNSTAIRS"
labelsall[labelsall==4]<-"SITTING"
labelsall[labelsall==5]<-"STANDING"
labelsall[labelsall==6]<-"LAYING"

data<-cbind(labelsall,xmeanstd)

subject_test<-read.table("subject_test.txt")
subject_train<-read.table("subject_train.txt")
allsubject<-rbind(subject_test,subject_train)


data2<-cbind(paste(allsubject[[1]],data[[1]]),xmeanstd)
names(data2)[1]<-"subjectactivity"




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

Tidy<-Tidy[order(Tidy[[1]]),]
row.names(Tidy)<-1:180

write.table(Tidy,file="Tidy.txt")