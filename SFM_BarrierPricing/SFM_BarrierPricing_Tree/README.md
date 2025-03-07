<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of QuantLet: SFEBarrier_Pricing_Tree

Published in: Statistics of Financial Markets

Description: Computes Barrier option prices using a binomial tree for assets with/without continuous dividends. barrier option types: up-and-out, up-and-in, down-and-out, down-and-in

Keywords: binomial, tree, asset, call, put, option, option-price, barrier-option, up-and-out, up-and-in, down-and-out, down-and-in

See also: SFEdown-and-out, SFEBarrier, SFEBarrier_Pricing_MC

Author: Franziska Wehrmann

Submitted: Thu, January 30 2020 by Franziska Wehrmann

Input: 
- S0 : current stock price
- K : strike price
- T : time to maturity
- sigma : volatility
- r : interest rate
- div : dividend
- N : number of steps in the tree
- B : barrier
- option : call or put
- barrier_type : up/down and in/out

Output: price of option

```
