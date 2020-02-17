# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# Creating Portfolio-Allocation-Function

portfolio_allocation <- function(probability, gamma, stock_zero, stock_up, stock_down, budget){
  
  # Initial Value of the Stock
  S_0 <- stock_zero  
  
  # Value of Stock in up-state
  S_u <- stock_up  
  
  # Value of Stock in down-state
  S_d <- stock_down  
  
  # The given Budget
  w_0 <- budget 
  
  # Probablity of stock going up, (1-p) is the probability of the stock going down
  p   <- probability 
  
  # Gamma, determines wether investor is risk-averse (Gamma positive), or risk-loving (Gamma negative)
  g   <- gamma  
  
  # Making sure it is S_d < S_0 < S_u
  if(S_d > S_0 | S_u < S_0){
    stop("It must be: Stock_down < Stock_zero < Stock_up.")
  }
  
  # Making sure p is in [0,1]
  if(p < 0 | p > 1){
    stop("The parameter probability has to be in the interval from 0 to 1.")
  }
  
  # Calculating q (risk neutral probality)
  q <- solve(S_u-S_d,S_0-S_d)
  
  # Calculating Pricing Kernels
  K_u <- q/p
  K_d <- (1-q)/(1-p)
  
  # Calculating parameter lambda 
  l <- solve((q*K_u^(-1/g)+(1-q)*K_d^(-1/g))^(-g),w_0^(-g))
  
  # Calculating X_u and X_d 
  X_u <- (l*K_u)^(-1/g)
  X_d <- (l*K_d)^(-1/g)
  
  # Calculating x and y, x = # of shares, y = # of bonds
  A <- matrix(data = c(S_u,1,S_d,1), nrow = 2, ncol = 2, byrow = T)
  b <- matrix(data = c(X_u,X_d), nrow = 2, ncol = 1, byrow = T)
  
  num <- solve(A,b)
  
  x<- num[1,1]
  y<- num[2,1]
  
  # Creating Output-Data-Matrix 
  output <- round(matrix(data = c(p,q,g,K_u,K_d,X_u,X_d,x,y),ncol = 9, nrow = 1, byrow = T),3)
  colnames(output) <- c("p","q","gamma","K_u","K_d","X_u","X_d","x","y")
  rownames(output) <- c("Values")
  
  return(output)
  
}


# Creating Data-Frame with varying parameter gamma
# Table: gamma from (-1 to 1, by 0.2)

list_1 <- lapply(X = seq(-1,1,0.2),function(x){
  portfolio_allocation(probability = 0.2, gamma = x,
                       stock_zero = 270, stock_up = 300, stock_down = 250, budget = 1200)
}
)

df_1 <- as.data.frame(do.call(rbind, list_1))
rownames(df_1) <- NULL
df_1


# Creating Data-Frame with varying parameter p and fix gamma at 1 (risk averse)
# Table: p from (0.1 to 0.9, by 0.1)

list_2 <- lapply(X = seq(0.1,0.9,0.1),function(x){
  portfolio_allocation(probability = x, gamma = 1,
                       stock_zero = 270, stock_up = 300, stock_down = 250, budget = 1200)
}
)

df_2 <- as.data.frame(do.call(rbind, list_2))
rownames(df_2) <- NULL
df_2

# Creating Data-Frame with varying parameter p and fix gamma at -1 (risk loving)
# Table: p from (0.1 to 0.9, by 0.1)

list_3 <- lapply(X = seq(0.1,0.9,0.1),function(x){
  portfolio_allocation(probability = x, gamma = -1,
                       stock_zero = 270, stock_up = 300, stock_down = 250, budget = 1200)
}
)

df_3 <- as.data.frame(do.call(rbind, list_3))
rownames(df_3) <- NULL
df_3


# Plotting number of bonds and number of stocks against a changing gamma
# First use Portfolio-function to calculate the values

list_4 <- lapply(X = seq(-10,10,0.2),function(x){
  portfolio_allocation(probability = 0.2, gamma = x,
                       stock_zero = 270, stock_up = 300, stock_down = 250, budget = 1200)
}
)

df_4 <- as.data.frame(do.call(rbind, list_4))
rownames(df_4) <- NULL


# Plot 1: number of stock against gamma and Plot 2: number of bonds against gamma

par(mfrow=c(1,2))
plot(df_4$gamma , df_4$y,type = "l", col = "red",
     lwd = 2, ylab = "number of bonds", xlab = "gamma")
plot(df_4$gamma , df_4$x,type = "l", col = "blue",
     lwd = 2, ylab = "number of stocks", xlab = "gamma")


# Plot of Utility function, to illustrate what different values of gamma imply 
# Creating Utility function 

utility <- function(x,a){
  if(a==1){
    y <- log(x)
  }else
  {
    y <- (x^(1-a))/(1-a)
  }
  return(y)
}


x <- seq(0.01,10,0.01)

# Setting a equal to zero -> risk-neutrality
y_a_zero <- utility(x,0)


# Setting a bigger than zero (here a = 1) -> risk-aversion
y_a_pos <- utility(x,1)

# Setting a smaller than zero (here a = -1) -> risk-proclivity
y_a_neg <- utility(x,-1)

par(mfrow=c(1,1))
par(pty="s")
plot(x,y_a_zero,type = "l",col="blue",lwd=2,xlab = "Portfolio Value", ylab = "Utility")
lines(x,y_a_pos,type = "l",col="red", lwd=2)
lines(x,y_a_neg,type = "l",col="green", lwd=2)










