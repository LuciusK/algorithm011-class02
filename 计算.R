library(dslabs)
data("movielens")
head(movielens, 3)

round(table(movielens$rating)/length(movielens$rating),3)

library(reshape)
Z <- cast(movielens, userId~movieId, value="rating")
dim(Z)

Z <- as.matrix(Z)
image(Z, col=grey.colors(10))


###-----------------------------------------------------

set.seed(1234)
x <- sample(1:100004)
train <- movielens
test <- movielens
train[x[75003:100004],'rating']=NA
test[x[1:75003],'rating']=NA

library(reshape)
traindata <- cast(train, userId~movieId, value="rating")
dim(traindata)

testdata <- cast(test, userId~movieId, value="rating")
dim(testdata)

traindata <- as.matrix(traindata)
testdata <- as.matrix(testdata)

####--------------------------------------------------------------

completion <- function(traindata, r, n){
  h = Sys.time()
  zhat <- traindata
  zhat[is.na(zhat)] <- 3
  
  for (k in 1:n) {
    s = Sys.time()
    svd <- svd(zhat)
    U <- svd$u
    d <- svd$d
    V <- svd$v
    
    mhat <- U[,1:r]%*%diag(d[1:r])%*%t(V[,1:r])
    
    zhatc <- traindata
    
    #for (i in 1:dim(zhatc)[1]) {
    #  for (j in 1:dim(zhatc)[2]) {
    #    if(is.na(zhatc[i,j]) == TRUE){
    #      zhatc[i,j] <- mhat[i,j]
    #    }else{next}
    #  }
    #}
    zhatc[is.na(zhatc)] <- mhat[is.na(zhatc)]
    x <- zhatc - zhat
    mx <- x * x
    fn <- sqrt(sum(mx))
    cat('第', k, '次迭代结束，F范式：', fn, '\n')
    zhat <- zhatc
    e = Sys.time()
    cat('第', k, '次迭代，共用：', e-s, '\n')
    if(fn < 10){
      print('fn小于10，算法收敛')
      break
    }
  }
  ha = Sys.time()
  cat('迭代达到上限,共用：', ha-h, '分钟')
  return(mhat)
}

Mat <- completion(traindata, 50, 20)

####--------------------------------------------------------------




#随机SVD
library(rsvd)
rc <- function(train, r, n){
  h = Sys.time()
  zhat <- train
  zhat[is.na(zhat)] <- mean(zhat, na.rm = TRUE)
  
  for (k in 1:n) {
    s = Sys.time()
    rsvd <- rsvd(zhat, k = r)
    U <- rsvd$u
    d <- rsvd$d
    V <- rsvd$v
    
    mhat <- U%*%diag(d)%*%t(V)
    zhatc <- train
    #for (i in 1:dim(zhatc)[1]) {
    #  for (j in 1:dim(zhatc)[2]) {
    #    if(is.na(zhatc[i,j]) == TRUE){
    #      zhatc[i,j] <- mhat[i,j]
    #    }else{next}
    #  }
    #}
    zhatc[is.na(zhatc)] <- mhat[is.na(zhatc)]
    x <- zhatc - zhat
    mx <- x * x
    fn <- sqrt(sum(mx))
    cat('第', k, '次迭代结束，F范式：', fn, '\n')
    zhat <- zhatc
    e = Sys.time()
    cat('第', k, '次迭代，共用：', e-s, '\n')
    if(fn < 1){
      print('fn小于1，算法收敛')
      break
    }
  }
  ha = Sys.time()
  cat('迭代达到上限,共用：', ha-h)
  return(mhat)
}

rc4 <- function(train, r, n){
  h = Sys.time()
  zhat <- train
  zhat[is.na(zhat)] <- mean(zhat, na.rm = TRUE)
  
  for (k in 1:n) {
    s = Sys.time()
    rsvd <- rsvd(zhat, k = r)
    U <- rsvd$u
    d <- rsvd$d
    V <- rsvd$v
    
    mhat <- U%*%diag(d)%*%t(V)
    zhatc <- train
    #for (i in 1:dim(zhatc)[1]) {
    #  for (j in 1:dim(zhatc)[2]) {
    #    if(is.na(zhatc[i,j]) == TRUE){
    #      zhatc[i,j] <- mhat[i,j]
    #    }else{next}
    #  }
    #}
    zhatc[is.na(zhatc)] <- mhat[is.na(zhatc)]
    x <- zhatc - zhat
    mx <- x * x
    fn <- sqrt(sum(mx))
    cat('第', k, '次迭代结束，F范式：', fn, '\n')
    zhat <- zhatc
    e = Sys.time()
    cat('第', k, '次迭代，共用：', e-s, '\n')
    if(fn < 1){
      print('fn小于1，算法收敛')
      break
    }
  }
  ha = Sys.time()
  cat('迭代达到上限,共用：', ha-h)
  return(mhat)
}

rMat <- rc(traindata, 50, 20)


####--------------------------------------------------------------


RMSE <- function(train, M){
  rmse <- c()
  len <- sum(is.na(train))
  #for (i in 1:dim(train)[1]){
  #  for (j in 1:dim(train)[2]){
  #    if(is.na(train[i,j]) == FALSE){
  #      x <- (M[i,j] - train[i,j])**2
  #      rmse <- c(rmse, x)
  #    }
  #  }
  #}
  #rmse <- sqrt(sum(rmse))
  train[is.na(train)] <- M[is.na(train)]
  x <- (train - M)
  mx <- x * x
  rmse <- sqrt(sum(mx)/len)
  return(rmse)
}



list1 <- seq(2,7)

Compute <- function(train, test, n, list, rc){
  train_rmse <- c()
  test_rmse <- c()
  for (r in list) {
    s = Sys.time()
    rmat <- rc(train, r, n)
    xrmse <- RMSE(train, rmat)
    crmse <- RMSE(test, rmat)
    train_rmse <- c(train_rmse, xrmse)
    test_rmse <- c(test_rmse, crmse)
    cat('秩为', r, '时，训练集的RMSE为', xrmse, '\n')
    cat('秩为', r, '时，测试集的RMSE为', crmse, '\n')
    e = Sys.time()
    cat('共用：', e-s, '\n')
  }
  return(cbind(train_rmse, test_rmse))
}


rmsedata <- Compute(traindata, testdata, 30, list = list1, rc=rc)
rmsedatanew <- Compute(traindata, testdata, 30, list = list1, rc=rc4)
opar <- par(no.readonly = TRUE)

par(mfcol=c(1,2))
plot(list1, rmsedata[,1], type='b', ylim = c(0.059,0.094), main = "训练集和测试集的RMSE比较", xlab = "秩r", ylab = "RMSE")
lines(list1, rmsedata[,2], type = 'b', col='red')

plot(list1, rmsedata[,2], type = 'b', main = "测试集的RMSE", xlab = "秩r", ylab = "RMSE")
####--------------------------------------------------------------

list3 <- seq(2,12)
#带中心化的随机SVD
library(rsvd)
nrc1 <- function(train, r, n){
  h = Sys.time()
  zhat <- train
  zhat[is.na(zhat)] <- mean(zhat, na.rm = TRUE)
  cmean <- colMeans(zhat)
  meanmat <- matrix(rep(cmean, dim(train)[1]),nrow = dim(train)[1], byrow = TRUE)
  zhat <- zhat - meanmat
  
  for (k in 1:n) {
    s = Sys.time()
    rsvd <- rsvd(zhat, r)
    U <- rsvd$u
    d <- rsvd$d
    V <- rsvd$v
    
    mhat <- U%*%diag(d)%*%t(V)
    zhatc <- train
    
    zhatc[is.na(zhatc)] <- mhat[is.na(zhatc)]
    
    x <- zhatc - zhat
    mx <- x * x
    fn <- sqrt(sum(mx))
    cat('第', k, '次迭代结束，F范式：', fn,'\n')
    zhat <- zhatc
    
    cmean <- colMeans(zhat)
    meanmat <- matrix(rep(cmean, dim(train)[1]),nrow = dim(train)[1], byrow = TRUE)
    zhat <- zhat - meanmat
    
    e = Sys.time()
    cat('第', k, '次迭代，共用：', e-s,'\n')
    if(fn < 10){
      print('fn小于10，算法收敛')
      break
    }
  }
  ha = Sys.time()
  cat('迭代达到上限,共用：', ha-h, '分钟')
  return(mhat)
}


nrc2 <- function(train, r, n){
  h = Sys.time()
  zhat <- train
  zhat[is.na(zhat)] <- mean(zhat, na.rm = TRUE)
  rmean <- rowMeans(zhat)
  meanmat <- matrix(rep(rmean, dim(train)[2]),ncol = dim(train)[2])
  zhat <- zhat - meanmat
  
  for (k in 1:n) {
    s = Sys.time()
    rsvd <- rsvd(zhat, r)
    U <- rsvd$u
    d <- rsvd$d
    V <- rsvd$v
    
    mhat <- U%*%diag(d)%*%t(V)
    zhatc <- train
    
    zhatc[is.na(zhatc)] <- mhat[is.na(zhatc)]
    
    x <- zhatc - zhat
    mx <- x * x
    fn <- sqrt(sum(mx))
    cat('第', k, '次迭代结束，F范式：', fn,'\n')
    zhat <- zhatc
    
    rmean <- rowMeans(zhat)
    meanmat <- matrix(rep(rmean, dim(train)[2]),ncol = dim(train)[2])
    zhat <- zhat - meanmat
    
    e = Sys.time()
    cat('第', k, '次迭代，共用：', e-s,'\n')
    if(fn < 10){
      print('fn小于10，算法收敛')
      break
    }
  }
  ha = Sys.time()
  cat('迭代达到上限,共用：', ha-h, '分钟')
  return(mhat)
}


rmsedata1 <- Compute(traindata, testdata, 30, list = list3, rc=nrc1)
rmsedata1_1 <- Compute(traindata, testdata, 30, list = list3, rc=nrc2)

par(mfcol=c(2,2))
plot(list3, rmsedata1[,1], type='o', ylim = c(0.133,0.254), main = "训练集和测试集的RMSE比较", xlab = "秩r", ylab = "RMSE")
lines(list3, rmsedata1[,2], type = 'o', col='red')
plot(list3, rmsedata1[,2], type = 'o', main = "测试集的RMSE", xlab = "秩r", ylab = "RMSE")

plot(list3, rmsedata1_1[,1], type='o', ylim = c(0.125,0.21), main = "训练集和测试集的RMSE比较", xlab = "秩r", ylab = "RMSE")
lines(list3, rmsedata1_1[,2], type = 'o', col='red')
plot(list3, rmsedata1_1[,2], type = 'o', main = "测试集的RMSE", xlab = "秩r", ylab = "RMSE")

####--------------------------------------------------------------


#带有softimpute的随机SVD
library(rsvd)
library(softImpute)
src <- function(train, r, n){
  h = Sys.time()
  zhat <- train
  fit <- softImpute(zhat,rank=5)
  zhat <- complete(zhat, fit)
  
  for (k in 1:n) {
    s = Sys.time()
    rsvd <- rsvd(zhat, r)
    U <- rsvd$u
    d <- rsvd$d
    V <- rsvd$v
    
    mhat <- U%*%diag(d)%*%t(V)
    zhatc <- train
    
    zhatc[is.na(zhatc)] <- mhat[is.na(zhatc)]
    
    x <- zhatc - zhat
    mx <- x * x
    fn <- sqrt(sum(mx))
    cat('第', k, '次迭代结束，F范式：', fn,'\n')
    zhat <- zhatc
    e = Sys.time()
    cat('第', k, '次迭代，共用：', e-s,'\n')
    if(fn < 10){
      print('fn小于10，算法收敛')
      break
    }
  }
  ha = Sys.time()
  cat('迭代达到上限,共用：', ha-h, '分钟')
  return(mhat)
}

srMat <- src(traindata, 4, 30)

list4 <- seq(2,7)

rmsedata2 <- Compute(traindata, testdata, 30, list = list4, rc=src)

par(mfcol=c(1,2))
plot(list4, rmsedata2[,1], type='o', ylim = c(0.085,0.13), main = "训练集和测试集的RMSE比较", xlab = "秩r", ylab = "RMSE")
lines(list4, rmsedata2[,2], type = 'o', col='red')

plot(list4, rmsedata2[,2], type = 'o', main = "测试集的RMSE", xlab = "秩r", ylab = "RMSE")

####--------------------------------------------------------------


bigdata <- read.table("ratings.dat",sep = ":")

bigdata <- bigdata[,c(-2,-4,-6)]

names(bigdata) <- c("userId", "movieId", "rating", "timestamp")

head(bigdata, 3)

round(table(bigdata$rating)/length(bigdata$rating),3)



bigdata <- bigdata[1:100020,]
set.seed(666)
x <- sample(1:100020)
trainbig <- bigdata
testbig <- bigdata
trainbig[x[75016:100020],'rating']=NA
testbig[x[1:75015],'rating']=NA

library(reshape)
trainbigdata <- cast(trainbig, userId~movieId, value="rating")
dim(trainbigdata)

testbigdata <- cast(testbig, userId~movieId, value="rating")
dim(testbigdata)

trainbigdata <- as.matrix(trainbigdata)
testbigdata <- as.matrix(testbigdata)


library(rsvd)

#bigMat <- rc(trainbigdata, 50, 20)

rmsebigdata <- Compute(trainbigdata, testbigdata, 30, list = list1, rc=rc)

par(mfcol=c(1,2))
plot(list1, rmsebigdata[,1], type='o', ylim = c(0.1,0.16), main = "训练集和测试集的RMSE比较", xlab = "秩r", ylab = "RMSE")
lines(list1, rmsebigdata[,2], type = 'o', col='red')

plot(list1, rmsebigdata[,2], type = 'o', main = "测试集的RMSE", xlab = "秩r", ylab = "RMSE")




