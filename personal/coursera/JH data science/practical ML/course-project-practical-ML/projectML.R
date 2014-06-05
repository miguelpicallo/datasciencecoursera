# clean workspace
rm(list=ls())
invisible(gc())

# set wd and load data

setwd('C:/Users/miguel.picallo.cruz/Documents/personal/coursera/JH data science/practical ML')
train=read.csv('pml-training.csv')
test=read.csv('pml-testing.csv')

# count different elements to turn classes of variable to their appropiate class

countElem=apply(train,2,function(x){length(unique(x))})
for (i in 1:(ncol(train)-1)){
  if (countElem[i]>10){train[,i]=as.numeric(train[,i]);test[,i]=as.numeric(test[,i])}
}

# take out variables that are all NAs in the test data set:
countNA=data.frame(train=apply(train,2,function(x){sum(is.na(x))}),
                   test=apply(test,2,function(x){sum(is.na(x))}) )
NAs=which(countNA$train!=0)
NAs.test=which(countNA$test!=0)
out=union(NAs,NAs.test)

train=train[,-out]
test=test[,-out]

# split the data for k-fols cross-validation 

set.seed(1)
library(caret)
folds=createFolds(y=train$classe,k=10,list=T,returnTrain=T)
pred=factor(rep('A',nrow(train)),levels=levels(train$classe))

# use predictive algorithm random forest to train model and predict outcome for the k-folds:

library(randomForest)
for (i in 1:length(folds)){
  print(i)
  model=randomForest(classe~.,data=train[folds[[i]],-1])
  pred[-folds[[i]]]=predict(model,train[-folds[[i]],-1])
}

# estimate missclassification error:

# missclassification of whole data set:

missClass=sum(pred!=train$classe)/nrow(train)*100
missClass

# compute mean and standard deviation of each missclassification error of the k-fold:

missClassi=c()
for (i in 1:length(folds)){
  missClassi=c(missClassi,
               sum(pred[-folds[[i]]]!=train$classe[-folds[[i]]])/(nrow(train)-length(folds[[i]]))*100
               )
}
mu=mean(missClassi)
sdev=sd(missClassi)
# 95% confident internal for missClassification error:
mu-2*sdev
mu+2*sdev

# classify test data:
test$new_window=factor(test$new_window,levels=c('no','yes'))
model=randomForest(classe~.,data=train[,-1])
answers=predict(model,test[,-c(1,ncol(test))])

# write down answers:
pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}
pml_write_files(answers)  
