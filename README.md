# Liquidity prediction

The fully rendered notebooks can be found here:
https://drive.google.com/drive/folders/1bkBDZIH8QscmPnJdRIX5-CoyTAmhAJ_A

## Sprint 2
**The Problem**:  
In trading, slippage refers to the discrepancy between the anticipated execution price of a trade and the actual price at which the trade is executed.Slippage is highest when executing large orders in times of poor liquidity, and leads to poor order execution.
 
**The Question**:  
Can ML be utilized to offer a more accurate estimation?

**Information**:  
To answer this question, an initial dataset is scraped to explore if the project is viable and needed.
The dataset consists of Bybit inverse perpetual futures data captured over the course of 2 days using [my tool](https://github.com/CannedKilroy/crypto). If the project looks viable then a larger dataset can be scraped over many weeks / tickers / exchanges.  

**Current approach**:
To estimate slippage the current approach is to simulate executing the trade on the 'current' orderbook, or sample a distribution of past slippages.

To reduce slippage, limit orders are traditionally used. However, they do not guarantee execution. There are many algorithms that combine some combination of limit / market orders over some time period to give an optimal execution. As ex: TWAP / VWAP, iceberg orders, POV, swarm, randomized slicing, etc

However, this project is meant specifically for market orders or algorithms that use market orders.

**Findings**:
The conventional approach:
- MAE:  0.42776246460483924
- MSE:  2.1197490163600716
- R² : 0.16837050137085274
These scores seem low which shows promise for ML, however, there are many factors that contribute to an accurate estimation.



**Challenges**:
1. Dealing with irregular time series

2. Accuracy from scraping derivative data from only 1 exchange / symbol. Spot data my be needed as well. There may be confounding variables in that the market maker is simply reacting to another trade on a different exchange but your order is in the same direction at the same time

3. Some of the very large market orders wiped out more than the captured 50 level orderbook, ie, there is no way to produce accurate `expected_slippage` score for them unless you extrapolate the orderbook and take a best estimate.