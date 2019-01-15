setwd("~/Documents/Undergraduate/Research/")
library(Rcpp)
library(ggplot2)
library(aod)

data1 <- read.table("datasim.txt", header=TRUE)
data2 <- read.table("datasim2.txt", header=TRUE)

train <- data2
test <- data1

infdata <- rbind(data1,data2)

pprob <- c(); rprob <- c(); aprob <- c(); approb <- c(); arprob <- c();

for (i in 1:10) {
  pprob[i] =  length(which((infdata$p == i) & (infdata$infclus == 1)))/length(which(infdata$p == i));
  rprob[i] =  length(which((infdata$r == i) & (infdata$infclus == 1)))/length(which(infdata$r == i));
}

for (i in 1:4) {
  aprob[i] =  length(which((infdata$a == i) & (infdata$infclus == 1)))/length(which(infdata$a == i));
  for (j in 1:10) {
    approb[(i-1)*10 + j] = length(which((infdata$p == j) & (infdata$a == i) &
          (infdata$infclus == 1)))/length(which(infdata$p == j) & (infdata$a == i));
    arprob[(i-1)*10 + j] = length(which((infdata$r == j) & (infdata$a == i) &
          (infdata$infclus == 1)))/length(which(infdata$r == j) & (infdata$a == i));
  
  }
}

mylogit <- glm(infclus ~ p*r*a, data = train,family = binomial(logit))
summary(mylogit)
mylogitupd <- glm(infclus ~ r + a + p:r + r:a + p:r:a, data = train, family = binomial(logit))
summary(mylogitupd)

fitted.results <- predict(mylogit,test,type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
misClasificError <- mean(fitted.results != test$infclus)
print(paste('Accuracy',1-misClasificError))

fitted.results1 <- predict(mylogitupd,test,type='response')
fitted.results1 <- ifelse(fitted.results1 > 0.5,1,0)
misClasificError <- mean(fitted.results1 != test$infclus)
print(paste('Accuracy',1-misClasificError))

fitted.results2 <- predict(mylogitupd, test, type='response')
fitted.results2 <- fitted.results2*ifelse(test$a < 3,1,0)
fitted.results2 <- ifelse(fitted.results2 > .5, 1, 0)

library(caret)
confusionMatrix(data=fitted.results, reference=test$infclus)
confusionMatrix(data=fitted.results1, reference=test$infclus)

#### Graphing Individual Factor Probabilities

par(mfrow=c(1,2))

plabels <- c("1/11","2/11","3/11","4/11","5/11","6/11","7/11","8/11","9/11","10/11")
plot(pprob ~ c(1:10), xlab = "Probability of Connection", 
     ylab = "Infinite Cluster Probability", axes=FALSE)
axis(1, at=c(1:10),labels=plabels, las=2)
axis(2, at=c(0,.45),labels=c(0,.45), las=2)

rlabels = c(expression(paste(Delta, x[mu])), 
            expression(paste(1.2, Delta, x[mu])), 
            expression(paste(1.4, Delta, x[mu])), 
            expression(paste(1.6, Delta, x[mu])), 
            expression(paste(1.8, Delta, x[mu])), 
            expression(paste(2.0, Delta, x[mu])), 
            expression(paste(2.2, Delta, x[mu])), 
            expression(paste(2.4, Delta, x[mu])), 
            expression(paste(2.6, Delta, x[mu])), 
            expression(paste(2.8, Delta, x[mu])))

plot(rprob ~ c(1:10), xlab = "", ylab = "Probability of Percolating Cluster", axes = FALSE)
axis(1, at = c(1:10), labels = rlabels, las=2)
title(xlab="Radius Required for Connection", line=3.5, cex.lab=1.0)
axis(2, at=c(0,.4), labels=c(0,.4),las=2)


par(mfrow=c(1,1))
alabels = c("(1/5)r","(2/5)r","(3/5)r","(4/5)r")
plot(aprob ~ c(1:4), xlab = "Deletion Radius of Point Thinning", 
     ylab = "Probability of Percolating Cluster", axes=FALSE)
axis(1, at = c(1:4), labels = alabels, las=2)
axis(2, at = c(0,.7), labels=c(0,.7),las=2)

par(mfrow=c(1,2))

plot(approb ~ c(1:40), xlab = "Deletion Radius and Connection Probability", 
     ylab = "Probability of Percolating Cluster")
abline(v=10.5); abline(v=20.5); abline(v=30.5);
plot(arprob ~ c(1:40), xlab = "Deletion Radius and Connection Radius", 
     ylab = "Probability of Percolating Cluster")
abline(v=10.5); abline(v=20.5); abline(v=30.5)
title(main="Probability of Percolating Cluster in Respect to a", outer = T, line =-2)
