# Liquidity prediction

The fully rendered notebooks can be found here:
https://drive.google.com/drive/folders/1bkBDZIH8QscmPnJdRIX5-CoyTAmhAJ_A

## Sprint 1
**The Problem**:  
In trading, slippage refers to the discrepancy between the anticipated execution price of a trade and the actual price at which the trade is executed. It can be broken down into spread, market impact, and volatility costs. Slippage is highest when executing large orders in times of poor liquidity, and leads to poor order execution.
 
**The Question**:  
Can ML be utilized to offer a more accurate estimation?

**Information**:  
To answer this question, an initial dataset is scraped to explore if the project is viable and needed.
The dataset consists of Bybit inverse perpetual futures data captured over the course of 2 days using [my tool](https://github.com/CannedKilroy/crypto). If the project looks viable then a larger dataset can be scraped over many weeks / tickers / exchanges.  

**Current approach**:
- Limit orders:
  - Limit orders guarantee price however do not guarantee execution.

- Order slicing: Split a large order into smaller orders. 
There are many algorithms for this, such as TWAP / VWAP, iceberg orders, POV, swarm, randomized slicing, etc

However, this project is meant specifically for market orders. 

**Initial Questions**:  
EDA Questions to help answer if the project is viable and needed:  
- Is liquidity still a large enough issue for slippage to be a concern when exercising large market orders?
  - Is the orderbook thin enough at times for slippage to be an issue?
    - Under what times / conditions?
    - What markers seem to be predictors?
    - How can fake liquidity and market maker skew be accounted for?
- At what trade size does slippage start to be a concern?
  - How variable is this ie:
  - Under assumption of static or dynamic orderbook?
  - How much does this change on "off" hours?
  - Does this change when traditional markets are open / closed?
- Is any information missing from the dataset?
  - How to aggregate trades for slippage calculation?
- Possibility for feature engineering?
- Is a simple buffer for the market maker skew sufficient instead of ML? 

**Challenges**:
1. Aggregating time and sales data accurately to extract slippage. As long as the market is not highly volatile, it should be relatively accurate.
  - Completed

2. Accuracy from scraping derivative data from only 1 exchange / symbol. Spot data my be needed as well.
  - This is largely a non issue but can be improved on the next dataset.  
