# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()
 
# input parameters
   
s0    = 230     # Stock price
k     = 210     # Exercise price
i     = 0.04545 # Interest rate
sigma = 0.25    # Volatility
t     = 0.5     # Time to maturity
n     = 50      # Nmber of intervals

# Main computation
j         = 1
dt        = t/n                                           # Interval of step
u         = exp(sigma * sqrt(dt))                         # Up movement parameter
d         = 1/u                                           # Down movement parameter
b         = i                                             # Costs of carry
p         = 0.5 + 0.5 * (b - sigma^2/2) * sqrt(dt)/sigma  # Probability p
p1        = p^2                                           # Probability of up movement
p2        = 2*p*(1-p)                                     # Probability of no movement
p3        = (1-p)^2                                       # Probability of down movement
un        = rep(1, n + 1) - 1
un[n + 1] = 1
dm        = t(un)                                         # Set of up coefficients

# Generating the matrices of up and down movements' coefficients
while (j < n + 1) {
  d1 = cbind(t(rep(1, n - j) - 1), t((rep(1, j + 1) * d)^(seq(j, 0))))
  dm = rbind(dm, d1)  # Down movement dynamics
  u1 = cbind(t(rep(1, n - j) - 1), t((rep(1, j + 1) * u)^((seq(j, 0)))))
  um = rbind(dm, u1)  # Up movement dynamics
  j  = j + 1
}

# Making a unique matrix of possible stock prices
dm                  = t(dm)
um                  = t(um)
um                  = um[,-52]
um                  = 1/um
um[is.infinite(um)] <- 0
dm                  = dm[nrow(dm):1,]
dm                  = dm[-1,]
sn                  = s0*(rbind(um, dm)) # New stock prices' matrix

# Option pricing
opt          = matrix(0, nrow(sn), ncol(sn)) # Matrix of option prices
opt[, n + 1] = pmax(k - sn[, n + 1], 0)      # Prices at expiration date

# Calculating vectors in of option prices from expiration date till today
loopv = seq(n, 1)
for (j in loopv) {
  l = seq((n-j+2), (j+50))
  # Probable option values discounted back one time step
  discopt = ((p1 * opt[l+1, j + 1]) + (p2 * opt[l, j+1]) + (p3 * opt[l-1, j + 1])) * exp(-b * dt)
  # Option value
  opt[, j] = rbind(t(t(rep(0, ((101-length(l))/2)))),t(t(pmax(k - sn[l, j], discopt))), t(t(rep(0, ((101-length(l))/2)))))
}
print(opt[51,1])
