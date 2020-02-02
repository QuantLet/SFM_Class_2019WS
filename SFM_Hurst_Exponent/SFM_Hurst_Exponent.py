
import json
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import scipy

from hurst import compute_Hc, random_walk
from AR import ar

# Execute Download
import binance_download

# Read and select Close price (Header: Timestamp, OHLCV, ...)
p               = pd.read_json('Binance_BTCUSDT_1m_1483228800000-1580342400000.json')
df              = p[[4]] 
df['changes']   = df.pct_change()
changevec       = df['changes'].dropna() + 1
changevec       = changevec.dropna()


random_changes = np.array(changevec)
series = np.cumprod(random_changes) 

H_l = []
c_l = []
data_l = []
mse_l = []
series_splits = np.array_split(series, 1000)

for currseries in series_splits:
    H, c, data = compute_Hc(currseries, kind='price', simplified=True)
    H_l.append(H)
    c_l.append(c)
    data_l.append(data)
    mse_l.append(ar(currseries - 1)) # Get back to simple returns around 0

# Evaluate Hurst equation for complete data set
H, c, data = compute_Hc(series, kind='price', simplified=True)

# Use Autoregressive Model to predict price for periods of differing H.
# Would expect high H periods (e.g. > 0.5) to have a smaller Mean Squared Error than other periods
# Then use some hypothesis test on the mean difference.

# Use t-test for mse_l small when H_l large
cutoff_int = 0.5
idx = np.where(np.array(H_l) > cutoff_int)
mse_supposedly_low = np.array(mse_l)[idx]

not_idx = np.where(np.array(H_l) <= cutoff_int)
mse_supposedly_high = np.array(mse_l)[not_idx]

ttestresult = scipy.stats.ttest_ind(mse_supposedly_high, mse_supposedly_low, equal_var = False) 
print(ttestresult[1]/2) # One sided test

# Hurst Exponent vs MSE
plt.gcf().subplots_adjust(0.2) # Compensate ax labels
plt.ylim(0, 0.0001)
plt.scatter(H_l, mse_l)
plt.xlabel('Hurst Exponent')
plt.ylabel('Mean Squared Error')
plt.title('MSE vs. Hurst Exponent')
plt.savefig('MSE_vs_Hurst.pdf')
plt.show()

# Raw Bitcoin Close Prices
plt.plot(p[4])
plt.title('Bitcoin Close Prices in USDT')
plt.xlabel('2017-01-01 until 2020-01-31')
plt.savefig('Bitcoin_Close_Prices.pdf')
plt.show()

# Autocorrelation of BTC
plt.acorr(df['changes'][2:50000], maxlags=9) # same as [2:] (dropna) but way faster!
plt.title('Autocorrelation of Bitcoin Returns')
plt.xlabel('Lag')
plt.ylabel('Autocorrelation')
plt.savefig('Bitcoin_Autocorrelation.pdf')
plt.show()

# Plot Bitcoin Returns per Minute
plt.plot(df['changes'])
plt.title('BTC / USDT Returns per Minute')
plt.xlabel('2017-01-01 until 2020-01-31')
plt.savefig('BTCUSDT_Minute_Returns.pdf')
plt.show()

# Bitcoin Autocorrelation
# Plot for subsets, add H as horizontal line 
plt.plot(H_l)
plt.title('Hurst Exponent for subsets of BTC/USDT')
plt.axhline(H, color = 'r')
plt.savefig('Hurst_Exponent_For_Subsets.pdf')
plt.show()

# Plot Hurst R/S
f, ax = plt.subplots()
ax.plot(data[0], c*data[0]**H, color="deepskyblue")
ax.scatter(data[0], data[1], color="purple")
ax.set_xscale('log')
ax.set_yscale('log')
ax.set_xlabel('Log Time interval')
ax.set_ylabel('Log R/S ratio')
ax.grid(True)
plt.title('Hurst Exponent')
plt.savefig('Hurst.pdf')
plt.show()

