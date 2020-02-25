#tail dependency plot for simulated: bivariate normal copula with normal margins; 
#bivariate t copula with t margins; 
#bivariate t copula with norm margins; 
#bivariate independent copula with norm margins; 

rm(list = ls(all = TRUE))
#setwd("C:/...")

#install.packages("copula")
library(copula)
set.seed(100)

#png("taildep.png", width = 800, height = 600)
#par(bg=NA)

layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
par(mar = c(2, 2, 2, 2))

cop_norm_norm = mvdc(normalCopula(0.6), c("norm", "norm"),
              list(mean = 0, sd =1))
sim1 = rMvdc(5000, cop_norm_norm)
plot(sim1[,1],sim1[,2],col='black',main = "Normal Copula with Normal Marg.",xlab = "X_1", ylab = "X_2",
     xlim=c(-5,5), ylim=c(-6,6), pch = 1)
grid (NULL,NULL, lty = 4, col = "darkgrey") 
linear1 = lm(sim1[,2]~sim1[,1]) 
abline(linear1, col = 'black')

cop_t_t = mvdc(tCopula(0.6,dim=2,df=3), c("t", "t"),
               list(df=7, df=7))
sim3 = rMvdc(5000, cop_t_t)
plot(sim3[,1], sim3[,2], col='black',main = "t-Copula with t-Marg.", xlab = "X_1", ylab = "X_2",
     xlim=c(-5,5), ylim=c(-6,6))
grid (NULL,NULL, lty = 4, col = "darkgrey") 
linear3 = lm(sim3[,2]~sim3[,1]) 
abline(linear3, col = 'black')

cop_t_norm = mvdc(tCopula(0.6,dim=2,df=3), c("norm", "norm"),
             list(mean = 0, sd =1))
sim2 = rMvdc(5000, cop_t_norm)
plot(sim2[,1], sim2[,2], col='black',main = "t-Copula with Normal Marg.", xlab = "X_1", ylab = "X_2",
     xlim=c(-5,5), ylim=c(-6,6))
grid (NULL,NULL, lty = 4, col = "darkgrey") 
linear2 = lm(sim2[,2]~sim2[,1]) 
abline(linear2, col = 'black')

cop_ind_norm = mvdc(normalCopula(0), c("norm", "norm"),
             list(mean = 0, sd =1))
sim4 = rMvdc(5000, cop_ind_norm)
plot(sim4[,1], sim4[,2], col='black',main = "Independence Copula with Normal Marg.", xlab = "X_1", ylab = "X_2",
     xlim=c(-5,5), ylim=c(-6,6))
grid (NULL,NULL, lty = 4, col = "darkgrey")

#dev.copy(png,'taildep.png')
#dev.off()

#quartz.save("test.png")
