# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# install and load packages
libraries = c("stats")
lapply(libraries, function(x) if (!(x %in% installed.packages())) {
  install.packages(x)
})
lapply(libraries, library, quietly = TRUE, character.only = TRUE)

# parameter settings
n1   = 100
n2   = 1000
beta = 0.8

# simulation of MA(1)-processes
set.seed(123)
x1 = arima.sim(n = n1, list(ma = beta), innov = rnorm(n1))
x2 = arima.sim(n = n2, list(ma = beta), innov = rnorm(n2))

# Plot
par(mfrow = c(2, 1))
par(mfg = c(1, 1))
plot.ts(x1, col = "blue", ylab = "y(t)")
title(paste("MA(1) Process, n =", n1))
par(mfg = c(2, 1))
plot.ts(x2, col = "red", ylab = "y(t)")
title(paste("MA(1) Process, n =", n2))
