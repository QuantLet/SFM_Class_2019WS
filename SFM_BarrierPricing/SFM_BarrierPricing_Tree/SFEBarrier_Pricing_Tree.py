import numpy as np
import matplotlib.pyplot as plt
plt.rcParams.update({'font.size': 16})


def calc_parameters(T, N, sigma, r, div):
    """
    Calculates the dependent parameters of the Binomial Tree (CRR)
    input:
      T     : time to maturity
      N     : number of steps of the tree
      sigma : volatility
      r     : interest rate 0.05 = 5%
      div   : dividend 0.03 = 3%
    output: 
      dt    : size of time step
      u     : factor of upwards movement of stock
      d     : factor of downwards movement of stock
      q     : risk-neutral probability
      b     : cost of carry
    """
    dt = T / N
    u = np.exp(sigma * np.sqrt(dt))
    d = 1 / u
    b = r - div
    q = 1 / 2 + 1 / 2 * (b - 1 / 2 * sigma ** 2) * np.sqrt(dt) / sigma  # P(up movement)
    return dt, u, d, q, b


def knockout_01(assets, B, barrier_type):
    """
    Determines weather the asset is higher or lower than the Barrier
    input:
      assets          : array of assets
      B, barrier_type : 'up-and-out' or 'down-and-out' with barrier B
    output:
      indicator       : indicates if this stock contributes to option pricing
    """
    indicator = np.zeros(len(assets))
    if barrier_type == 'up-and-out':
        indicator[assets < B] = 1
        indicator[assets >= B] = 0
    elif barrier_type == 'down-and-out':
        indicator[assets <= B] = 0
        indicator[assets > B] = 1
    return indicator


def calc_price(S0, K, u, d, N, r, dt, q, option, barrier_type):
    """
    Uses Backpropergation to calculate the option price of 
    up/down-and-out barrier option.
    input:
      S0, K, u, d, N, r, dt, q: parameters of the Binomial Tree (CRR) Model
                                as in function calc_parameters      
      option       : 'Call', 'Put'
      barrier_type : 'up-and-out', 'down-and-out'
    output:
      price        : price of the option
    """
    # calculate the values at maturity T
    asset_values = S0 * (u ** np.arange(N, -1, -1)) * (d ** np.arange(0, N + 1, 1))
    asset_values[asset_values > B] = 0
    if option == 'Call':
        option_values = (np.maximum((asset_values - K), 0))
    elif option == 'Put':
        option_values = (np.maximum((K - asset_values), 0))
    else:
        raise KeyError("Options Type Input Error. Either Call or Put")

    # Next we use the recursion formula for pricing in the CRR model:
    for n in np.arange(N - 1, -1, -1):
        asset_val_temp = S0 * (u ** np.arange(n, -1, -1)) * (d ** np.arange(0, n + 1, 1))
        asset_val_temp = knockout_01(asset_val_temp, B, barrier_type)
        option_values[0:n + 1] = np.exp(-1 * r * dt) * (
            np.multiply(q * option_values[0:n + 1]
                        + (1 - q) * option_values[1:n + 2], asset_val_temp))
    return option_values[0]


def calc_price_european(S0, K, u, d, N, r, dt, q, option):
    """
    Uses Backpropergation to calculate the option price of an European option.
    input:
      S0, K, u, d, N, r, dt, q: parameters of the Binomial Tree (CRR) Model
                                as in function calc_parameters      
      option : 'Call', 'Put'
    output:
      price  : price of the option
    """
    # calculate the values at maturity T
    asset_values = S0 * (u ** np.arange(N, -1, -1)) * (d ** np.arange(0, N + 1, 1))
    if option == 'Call':
        option_values = (np.maximum((asset_values - K), 0)).tolist()
    elif option == 'Put':
        option_values = (np.maximum((K - asset_values), 0)).tolist()
    else:
        raise KeyError("Options Type Input Error. Either Call or Put")

    asset_values = asset_values.tolist()

    # Using the recursion formula for pricing in the CRR model:
    for n in np.arange(N - 1, -1, -1):  # from (T-dt, T-2*dt, ...., dt, 0)
        asset_val_temp = (S0 * (u ** np.arange(n, -1, -1)) * (d ** np.arange(0, n + 1, 1)))
        option_val_temp = (np.exp(-1 * r * dt) * (q * np.array(option_values[-(n + 2):-1])
                                                  + (1 - q) * np.array(option_values[-(n + 1):])))

        asset_values += asset_val_temp.tolist()
        option_values += option_val_temp.tolist()
    price = option_values[-1]
    return price


####### MAIN ################

S0 = 230  # current stock price
K = 210  # strike price
T = 0.50  # time to maturity
sigma = 0.25  # volatility
r = 0.04545  # interest rate
div = 0  # dividend
N = 150  # steps in tree
B = 250  # barrier

dt, u, d, q, b = calc_parameters(T, N, sigma, r, div)

# calculate all prices
for option in ['Call', 'Put']:
    print(option)
    for barrier_type in ['up-and-out', 'down-and-out']:
        price_out = calc_price(S0, K, u, d, N, r, dt, q, option, barrier_type)
        price_european = calc_price_european(S0, K, u, d, N, r, dt, q, option)
        print(barrier_type, ' ', price_out)
        print('     -and-in', price_european - price_out)
        print('vanilla opt.', price_european)
        print(' ')
