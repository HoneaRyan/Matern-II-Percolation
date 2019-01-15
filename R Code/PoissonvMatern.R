####Matern II EX
a <- .025
pois <- rpois(1, 7500) #Generates a point of poisson variance for following lines.
xval <- runif(pois, min=0, max=1)
yval <- runif(pois, min=0,max=1)
par(mfrow=c(1, 2))
plot(xval, yval,main="Poisson Process",xlab="x", ylab="y")
adj <- diag(pois+1) #initializing this matrix
for(i in 1:(pois-1)){
  for(j in (i+1):pois){
    if((sqrt((xval[j]-xval[i])^2+(yval[j]-yval[i])^2)) < a){
      xval[i] = 0
      yval[i] = 0
    }
  }
}
xval <- xval[xval != 0] #Removing all deleted points
yval <- yval[yval != 0] #Removing all deleted points
xval <- c(0,xval) #Creating a center (origin) point
yval <- c(0,yval) #Creating a center (origin) point
plot(xval,yval,main="Matern II",xlab="x", ylab="y")
