# Liquidity prediction

## Sprint 1
**The Problem**: In trading, slippage is the difference between desired and real execution price, and can be broken down into the spread, market impact, and volatility costs.
When executing large orders and/ or during times of poor liquidity, the execution price is likely far from the desired price, resulting in poor execution. With the 
cryptocurrency market being filled with fake liquidity, wash trading, spoofing, etc, it is the perfect candidate.
This project will focus on the cryptocurrency market as the data is freely aviable compared to the trad market.

**The Question**: Can ML be utilized to minimize this slippage? Or at a minimum offer a more accurate estimation?

To answer this question, an initial dataset is scraped to explore if the project is viable and needed.
The dataset captured Bybit inverse perpetual futures over the course of 2 days using [this tool](https://github.com/CannedKilroy/crypto).
The Bybit bitcoin inverse perp futures was chosen since the api is well documented, i'm familiar with it, and it is very liquid and active. 
If the project looks viable then a larger dataset can be scraped over many weeks / tickers / exchanges.  

EDA Questions to help answer if the project is viable and needed:  
- Is liquidity still a large enough issue for slippage to be a concern when exercising large market orders.
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

### Current approach:
There are a few practical approachs to limiting slippage, however there is always some tradeoff between time uncertainty, price uncertainty, etc
 
- Smart order routing: Check other exchanges to find the BBO, and route your order there. 
  This approach is limited if a user is unable to use more than a single exchange.

- Limit orders: Guarentee price but may never be executed.
More advanced algorithms:

- Order slicing: Split a large order into smaller orders. 
There are many algorithms for this, such as TWAP / VWAP, iceberg orders, POV, swarm, randomized slicing, etc

However, apart from smart order routing, these approaches are naive to market conditions. 


### Challenges:
- Aggregating time and sales data accuratly to extract slippage. Should be relatively accurate if the market is not active however if the market becomes very active in can become impossible to accuratly separate trades.

- Data accuracy. Scraping only 1 exchange, symbol, and type of derivative might not be enough for accurate data. Spot data my be needed as well. 


















