[<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/banner.png" width="888" alt="Visit QuantNet">](http://quantlet.de/)

## [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/qloqo.png" alt="Visit QuantNet">](http://quantlet.de/) **SFM_Portfolio_Allocation** [<img src="https://github.com/QuantLet/Styleguide-and-FAQ/blob/master/pictures/QN2.png" width="60" alt="Visit QuantNet 2.0">](http://quantlet.de/)

```yaml


Name of Quantlet: 'SFM_Portfolio_Allocation'

Published in: 'Statistics of Financial Markets 1'

Description: 'Returns the Portfolio Allocation in a one-period Binomial-Model, for different Pricing Kernels and utility-functions'

Keywords: 'Portfolio Allocation, Pricing Kernel, Binomial Model, Utility, Risk Aversion, Risk Proclivity'

Author: 'Pablo Spitzley Rodriguez, Andrey Lyan' 


```

### R Code
```r

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
    stop("It must be: stock_down < Stock_zero < Stock_up.")
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


# Creating Data-Frame with varying parameter p
# Table: p from (0.05 to 0.95, by 0.5) and gamma = 1

list <- lapply(X = seq(0.05,0.95,0.05),function(x){
  portfolio_allocation(probability = x, gamma = 1,
                       stock_zero = 270, stock_up = 300, stock_down = 250, budget = 1200)
}
)

df <- as.data.frame(do.call(rbind, list))
rownames(df) <- NULL
df























```

automatically created on 2020-01-31