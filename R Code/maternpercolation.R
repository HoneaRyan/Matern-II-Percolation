require("plotrix")

data1 <- read.table("data1.txt", header=TRUE) #reads data from simulation
lmod <- lm(infclus ~ ., data=data1) #linear model for p,r,a predicting phi
summary(lmod) #summarizes model


####Making graphs of variables####

pprob <- c() #declares p probability array
aprob <- c() #declares a probability array
rprob <- c() #declares r probability array
arprob <- c() #declares a*r probability array
approb <- c() #declares a*p probability array

#loop below calculates probabilities of Phi associated with p and r
for (i in 1:10) {
  pprob[i] = sum(data1$infclus == 1 & data1$p == i)/sum(data1$p == i)
  rprob[i] = sum(data1$infclus == 1 & data1$r == i)/sum(data1$r == i)
}
#loop below calculates probabilities of Phi assocaited with a
for (i in 1:4) {
  aprob[i] = sum(data1$infclus == 1 & data1$a == i)/sum(data1$a == i)
}

#loop below calculates probabilities of Phi associate with a*r and a*p
for(i in 1:4) {
  for (j in 1:10) {
    arprob[(i-1)*10 + j] = sum(data1$infclus == 1 & data1$r == j & data1$a == i
      )/sum(data1$r == j & data1$a == i)
    approb[(i-1)*10 + j] = sum(data1$infclus == 1 & data1$p == j & data1$a == i
    )/sum(data1$p == j & data1$a == i)
  }
}

lmodp <- lm(pprob ~ c(1:10)) #linear model for prediction of Phi with just p
lmodr <- lm(rprob ~ c(1:10)) #linear model for prediction of Phi with just r
lmoda <- lm(aprob ~ c(1:4)) #linear model for prediction of Phi with just a
lmodar <- lm(arprob ~ c(1:40)) #linear model for prediction of Phi with a:r
lmodap <- lm(approb ~ c(1:40)) #linear model for prediction of Phi with a:p

par(mfrow = c(2,2)) #for image formatting
plot(pprob ~ c(1:10), xlab="Probability of Connection", ylab = "Probability of Infinite Cluster", 
     main = "Infinite Cluster Probability versus p")
abline(lmodp) #graphs line of best fit for p
plot(rprob ~ c(1:10), xlab="Radial Distance Required for Connection",
     ylab = "Probability of Infinite Cluster", main = "Infinite Cluster Probability versus r")
abline(lmodr) #graphs line of best fit for r
plot(aprob ~ c(1:4), xlab="Radial Distance required for Deletion",
     ylab = "Probability of Infinite Cluster", main = "Infinite Cluster Probability versus a")
abline(lmoda) #graphs line of best fit for a
plot(arprob ~ c(1:40), xlab = "Deletion and Connection", ylab = "Probability of Infinite Cluster",
     main = "Infinite Cluster versus r")
abline(lmodar, lty = 2) #graphs line of best fit for a:r


###Plotting ar based on individual sections###
broken1 <- subset(data1, data1$a == 1)
broken2 <- subset(data1, data1$a == 2); broken2$r = broken2$r + 10
broken3 <- subset(data1, data1$a == 3); broken3$r = broken3$r + 20
broken4 <- subset(data1, data1$a == 4); broken4$r = broken4$r + 30
lmodbr1 <- lm(broken1$infclus ~ broken1$r)
lmodbr2 <- lm(broken2$infclus ~ broken2$r)
lmodbr3 <- lm(broken3$infclus ~ broken3$r)
lmodbr4 <- lm(broken4$infclus ~ broken4$r)
plot(arprob ~ c(1:40), xlab = "Deletion and Connection", ylab = "Probability of Infinite Cluster",
     main = "Infinite Cluster versus r accounting for changes in a")
abline(v = c(10.5,20.5,30.5), lwd = 2, col="black")
ablineclip(lmodbr1, x1=0, x2 = 10.5, lwd = 2, col = "red")
ablineclip(lmodbr2, x1=10.5, x2 = 20, lwd = 2, col = "red")
ablineclip(lmodbr3, x1=20.5, x2 = 30, lwd = 2, col = "red")
ablineclip(lmodbr4, x1=30.5, lwd = 2, col = "red")


###Plotting ap based on indivudal sections###
broken1 <- subset(data1, data1$a == 1)
broken2 <- subset(data1, data1$a == 2); broken2$p = broken2$p + 10
broken3 <- subset(data1, data1$a == 3); broken3$p = broken3$p + 20
broken4 <- subset(data1, data1$a == 4); broken4$p = broken4$p + 30
lmodbr1 <- lm(broken1$infclus ~ broken1$p)
lmodbr2 <- lm(broken2$infclus ~ broken2$p)
lmodbr3 <- lm(broken3$infclus ~ broken3$p)
lmodbr4 <- lm(broken4$infclus ~ broken4$p)
plot(approb ~ c(1:40), xlab = "Deletion and Probability", ylab = "Probability of Infinite Cluster",
     main = "Infinite Cluster versus p accounting for a")
abline(lmodar, lty = 2) #graphs line of best fit for a:r
abline(v = c(10.5,20.5,30.5), lwd = 2, col="black")
ablineclip(lmodbr1, x1=0, x2 = 10.5, lwd = 2, col = "red")
ablineclip(lmodbr2, x1=10.5, x2 = 20, lwd = 2, col = "red")
ablineclip(lmodbr3, x1=20.5, x2 = 30, lwd = 2, col = "red")
ablineclip(lmodbr4, x1=30.5, lwd = 2, col = "red")



lmod <- lm(infclus ~ p + a + r + a:r, data=data1)
summary(lmod)
par(mfrow=c(2,2))
plot(lmod)