p <-  .5 #Multiplied by 1.1 so that probability is never 1
r <- .1
a <- (3/5)*r
pois <- rpois(1, 3500) #Generates a point of poisson variance for following lines.
xval <- runif(pois, min=-1, max=1)
yval <- runif(pois, min=-1,max=1)
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
plot(xval,yval,main="Matern II, a = (4/5)r")
for(i in 1:length(xval)) {
  for(j in 1:length(xval)){
    if((sqrt((xval[i]-xval[j])^2+(yval[i]-yval[j])^2)) < r && runif(1,0,1) < p){
      adj[i,j] = 1
      segments(xval[j],yval[j],xval[i],yval[i])
    }
  }
}

