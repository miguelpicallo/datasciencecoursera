# quizz 2

library(AppliedPredictiveModeling)
library(caret)
data(AlzheimerDisease)

adData = data.frame(diagnosis,predictors)
trainIndex = createDataPartition(diagnosis,p=0.5,list=FALSE)
training = adData[trainIndex,]
testing = adData[trainIndex,]

library(AppliedPredictiveModeling)
data(concrete)
library(caret)
set.seed(975)
inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training = mixtures[ inTrain,]
testing = mixtures[-inTrain,]

library(ggplot2)
library(Hmisc)
training$FlyAshG=cut2(training$FlyAsh,g=4)
qplot(1:nrow(training),CompressiveStrength,data=training,colour=FlyAshG,data)

set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

names(training)[grep('IL',names(training))]
matrix=training[,grep('IL',names(training))]
matrix=matrix[,-13]
matrix.test=testing[,grep('IL',names(training))]
matrix.test=matrix.test[,-13]

preProc=preProcess(matrix,method='pca',thresh=0.8)
matrixPC=predict(preProc,matrix)
matrixPC.test=predict(preProc,matrix.test)

model1=train(training$diagnosis~.,method='glm',data=matrixPC)
confusionMatrix(testing$diagnosis,predict(model1,matrixPC.test))

model2=train(training$diagnosis~.,method='glm',data=training[,-1])
confusionMatrix(testing$diagnosis,predict(model2,testing[,-1]))

# quizz 3

library(AppliedPredictiveModeling)
data(segmentationOriginal)
library(caret)

inTrain = which(segmentationOriginal$Case=='Train')
train=segmentationOriginal[inTrain,]
test=segmentationOriginal[-inTrain,]

set.seed(125)
model=train(train$Class~.,method='rpart',data=train)
fit=model$finalModel
par(xpd = TRUE)
plot(fit, compress = TRUE)
text(fit, use.n = TRUE)

library(pgmm)
data(olive)
olive = olive[,-1]
newdata = as.data.frame(t(colMeans(olive)))

model=train(olive$Area~.,method='rpart',data=olive)$finalModel
predict(model,newdata)


library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]

set.seed(13234)
out=c(1,4,5)
model=train(trainSA$chd~.,method='glm',family='binomial',data=trainSA[,-out])$finalModel

missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}

missClass(testSA$chd,predict(model,testSA[,-out],type='response'))
missClass(trainSA$chd,predict(model,trainSA[,-out],type='response'))


library(ElemStatLearn)
data(vowel.train)
data(vowel.test) 
set.seed(33833)
library(randomForest)
vowel.train$y=as.factor(vowel.train$y)
vowel.test$y=as.factor(vowel.test$y)
model=train(vowel.train$y~.,method='rf',data=vowel.train)
vi=varImp(model)
row.names(vi)[order(unlist(vi))]

# quizz 4
set.seed(33833)
model1=train(vowel.train$y~.,method='rf',data=vowel.train)
model2=train(vowel.train$y~.,method='gbm',data=vowel.train)
pred1=predict(model1,vowel.test)
pred2=predict(model2,vowel.test)

agree=which(pred1==pred2)
confusionMatrix(vowel.test$y,pred1)
confusionMatrix(vowel.test$y,pred2)
confusionMatrix(vowel.test$y[agree],pred1[agree])

set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain 

set.seed(62433)
