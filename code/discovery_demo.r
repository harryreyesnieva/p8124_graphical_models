library(pcalg)

## true DAG
## X1 -> X2 <- L -> X3 <- X4

set.seed(123)
n <- 10000
X1 <- rnorm(n, 0 , .5)
X4 <- rnorm(n, 0, 1.4)
L <- rnorm(n, 0, 0.7)
X2 <- rnorm(n, -1 + 0.8*X1 + 0.8*L, 1)
X3 <- rnorm(n, -1 + 2.2*X4 + 1.8*L, 1)

data <- cbind(X1,X2,X3,X4) ## L is not observed in data

indepTest <- gaussCItest ## specify the independence test
suffStat <- list(C = cor(data), n = n) ## using the correlation matrix

fci.est <- fci(suffStat, indepTest, alpha = 0.05, p = 4, verbose=TRUE) ## estimate a PAG
plot(fci.est)

pc.est <- pc(suffStat, indepTest, alpha = 0.05, p = 4, verbose=TRUE) ## estimate at CPDAG
plot(pc.est)

score <- new("GaussL0penObsScore", data) ## define a score function

ges.fit <- ges(score, verbose=TRUE) ## estimate at CPDAG with GES
plot(ges.fit$essgraph)


####

## True DAG: Z1 -> X <-- Z2 ; X --> Y <-- L ; possibly L -?-> X

set.seed(123)
n <- 10000
Z1 <- rnorm(n, 0, .5)
Z2 <- rnorm(n, 0 , 1.5)
L <- rnorm(n, 0, 1)
X <- rnorm(n, 0.8*Z1 + 0.8*Z2 + 0*L, 1) ## try adding a non-zero coefficient for L, see result change
Y <- rnorm(n, 1.6*X + 0.6*L, 1)

data <- cbind(Z1,Z2,X,Y) ## L is not observed in data

indepTest <- gaussCItest ## specify the independence test
suffStat <- list(C = cor(data), n = n) ## using the correlation matrix

fci.est <- fci(suffStat, indepTest, alpha = 0.05, labels = c("Z1","Z2","X","Y"), verbose=TRUE) ## estimate a PAG
plot(fci.est)



## try a random DAG

p <- 10
n <- 10000
myDAG <- randomDAG(p, prob = 0.4)
plot(myDAG)
data <- rmvDAG(n, myDAG, errDist = "normal")
data <- data[,-c(4,5)] ## "hide" two of the variables

indepTest <- gaussCItest ## specify the independence test
suffStat <- list(C = cor(data), n = n) ## using the correlation matrix

fci.est <- fci(suffStat, indepTest, alpha = 0.01, labels = c("1","2","3","6","7","8","9","10"), verbose=TRUE) ## estimate a PAG
plot(fci.est)

pc.est <- pc(suffStat, indepTest, alpha = 0.01, labels = c("1","2","3","6","7","8","9","10"), verbose=TRUE) ## estimate at CPDAG
plot(pc.est)

score <- new("GaussL0penObsScore", data) ## define a score function

ges.fit <- ges(score, verbose=TRUE) ## estimate a CPDAG with GES
plot(ges.fit$essgraph)
