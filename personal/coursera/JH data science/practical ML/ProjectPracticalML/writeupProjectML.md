Practical Machine Learning Project writeup
========================================================

## Synopsis
This reports contains the writeup of the project for the coursera course: *practinal machine learning*. It consistist on developing a predictive algorithm for the *Weight Lifting Exercise Dataset*, which has information from seonsors on people while performing barbell lift correctly and incorrectly in 5 different ways. In order to achieve this, several steps are followed:

1. First the data is loaded. 
2. Then some preprocessing is done to the data in order to find the appropiate type for each variable and eliminate variables that don't contain usufull information.
3. The data is splitted into 10 folds, and the algorithm is tested in each case. This way some conclusions are extracted about the accuracy of the algorithm.
4. Finally the model is trained on the whole train data and the test outcomes are predicted

## Load data

```r
setwd("C:/Users/miguel.picallo.cruz/Documents/personal/coursera/JH data science/practical ML")
train = read.csv("pml-training.csv")
test = read.csv("pml-testing.csv")
```


## Preprocess data
### Put appropiate types:
Count different elements in each variable, if too many (10 in this case), then it should be a numeric variable.

```r
countElem = apply(train, 2, function(x) {
    length(unique(x))
})
for (i in 1:(ncol(train) - 1)) {
    if (countElem[i] > 10) {
        train[, i] = as.numeric(train[, i])
        test[, i] = as.numeric(test[, i])
    }
}
```


### Eliminate variables with too much missing information:
Check which variables have missing data and how much (in %). 

```r
countNA = data.frame(train = apply(train, 2, function(x) {
    sum(is.na(x))/length(x) * 100
}), test = apply(test, 2, function(x) {
    sum(is.na(x))/length(x)
} * 100))
# Either 0% or 100% NAs:
unique(countNA$test)
```

```
## [1]   0 100
```

```r
# 0% NAs for train variables where test variables NAs is 0% NAs:
sum(countNA$test == 0 & countNA$train > 0)
```

```
## [1] 0
```

```r
plot(countNA$train, col = "blue", main = "% of NAs in each data set (blue for train, red for test)", 
    xlab = "variable", type = "b", ylab = "%")
lines(countNA$test, col = "red", type = "b")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

It can be observed that test has some of its variable with all variables NAs, those variables can be eliminated. The rest of the variables have for test and train 0% of missing data.

```r
NAs.test = which(countNA$test != 0)
out = NAs.test
train = train[, -out]
test = test[, -out]
```


## Data splitted using k-fold and model's performance is tested
### Split Data:
Split the data for k-fols cross-validation and initialize predictions:

```r
set.seed(1)
library(caret)
```

```
## Loading required package: lattice
## Loading required package: ggplot2
```

```r
folds = createFolds(y = train$classe, k = 10, list = T, returnTrain = T)
pred = factor(rep("A", nrow(train)), levels = levels(train$classe))
```


### k-folds predictions:
Use predictive algorithm random forest to train model and predict outcome for the k-folds:

```r
library(randomForest)
```

```
## randomForest 4.6-7
## Type rfNews() to see new features/changes/bug fixes.
```

```r
for (i in 1:length(folds)) {
    print(i)  # print in which k-fols is the for loop
    model = randomForest(classe ~ ., data = train[folds[[i]], -1])
    pred[-folds[[i]]] = predict(model, train[-folds[[i]], -1])
}
```

```
## [1] 1
## [1] 2
## [1] 3
## [1] 4
## [1] 5
## [1] 6
## [1] 7
## [1] 8
## [1] 9
## [1] 10
```

### Estimate out of sample missclassification error:
Out of sample missclassification error of whole data set:

```r
missClass = sum(pred != train$classe)/nrow(train) * 100
missClass
```

```
## [1] 0.07644
```

Compute mean and standard deviation of each missclassification error of the k-fold:

```r
missClassi = c()
for (i in 1:length(folds)) {
    missClassi = c(missClassi, sum(pred[-folds[[i]]] != train$classe[-folds[[i]]])/(nrow(train) - 
        length(folds[[i]])) * 100)
}
mu = mean(missClassi)
sdev = sd(missClassi)
# mean:
mu
```

```
## [1] 0.07644
```

```r
# standard deviation:
sdev
```

```
## [1] 0.02686
```

```r
# 95% confident internal for missClassification error:
mu - 2 * sdev
```

```
## [1] 0.02272
```

```r
mu + 2 * sdev
```

```
## [1] 0.1302
```

It can be observed that at most missclassification rate is expected to be less than 0.15% with 95% probability.
## Final training and testing

### Train with whole data and test:

```r
test$new_window = factor(test$new_window, levels = c("no", "yes"))
model = randomForest(classe ~ ., data = train[, -1])
answers = predict(model, test[, -c(1, ncol(test))])
```


### Write down answers for submission:

```r
pml_write_files = function(x) {
    n = length(x)
    for (i in 1:n) {
        filename = paste0("problem_id_", i, ".txt")
        write.table(x[i], file = filename, quote = FALSE, row.names = FALSE, 
            col.names = FALSE)
    }
}
pml_write_files(answers)
```

