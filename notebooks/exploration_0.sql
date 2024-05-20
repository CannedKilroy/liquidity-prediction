/* 
Author: CannedKilroy
Date: May 12, 2024
Description: Explores the dataset and
whether the project is needed. Is 
slippage still a large enough
concern to require ML to optimize order routing
and execution within crypto futures?
*/

-- --------------------------------------------------------------
-- EXPLORE DB
-- --------------------------------------------------------------
USE data_crypto;
SET GLOBAL sql_mode = 'ONLY_FULL_GROUP_BY';

SHOW TABLES;

SELECT * FROM logs LIMIT 50;
SELECT * FROM ohlcv LIMIT 50;
SELECT * FROM orderbook LIMIT 50;
SELECT * FROM ticker LIMIT 50;
SELECT * FROM trades LIMIT 50;


-- --------------------------------------------------------------
-- EXPLORE orderbook
-- Is the orderbook thin enough at times for liquidity to still be a issue?
-- Is the bid ask spread sometimes large enough to be a factor in execution? 
-- --------------------------------------------------------------
SELECT * FROM orderbook LIMIT 1; -- Best bid is first then desc, and the best ask is first then asc

ANALYZE TABLE orderbook;
SELECT COUNT(*) FROM orderbook;

-- Extract the Bid/Ask spread
SELECT JSON_EXTRACT(asks, '$[0][0]')-
JSON_EXTRACT(bids, '$[0][0]') 
FROM orderbook LIMIT 1;

-- Extract the volume inbalance
SELECT JSON_EXTRACT(asks, '$[0][1]')-
JSON_EXTRACT(bids, '$[0][1]') 
FROM orderbook LIMIT 1;

-- Create view with spread and volume inbalance
CREATE OR REPLACE VIEW orderbook_spread AS
SELECT
    id,  -- Assuming there's an identifier column in your table
    JSON_EXTRACT(asks, '$[0][0]') AS ask_price,
    JSON_EXTRACT(bids, '$[0][0]') AS bid_price,
    (JSON_EXTRACT(asks, '$[0][0]') - JSON_EXTRACT(bids, '$[0][0]')) AS spread,
	(JSON_EXTRACT(asks, '$[0][1]') - JSON_EXTRACT(bids, '$[0][1]')) AS volume_inbalance
FROM
    orderbook;

-- Summary stats for bid / ask spread
SELECT AVG(spread) AS AVERAGE_SPREAD,
MIN(spread) AS MIN_SPREAD,
MAX(spread) AS MAX_SPREAD 
FROM orderbook_spread;
/* 
The spread can be quite high, even with the maturity of the crypto market.
If crossing the spread can be minimized, part of order slippage can be minimized as well.
Most exchanges have a tick size of 0.5 cents, so the minimum makes sense, as does the average as
majority of time the bid ask spread is equal to the tick size. 
*/

-- Summary stats for liquidity inbalance on BB / BA
SELECT AVG(volume_inbalance) AS AVERAGE_INBALANCE,
MIN(volume_inbalance) AS MIN_INBALANCE,
MAX(volume_inbalance) AS MAX_INBALANCE 
FROM orderbook_spread;
-- This is not useful now but will be later

-- The orders need to be aggregated for more info 
-- This is fairly complex and will be done in python.

-- --------------------------------------------------------------
-- EXPLORE trades
-- What is the threshold where trades are large enough to worry about slippage?
-- How does this threshold change with liquidity?
-- What markers are best for determining liquidity? 
-- --------------------------------------------------------------

-- Sample of 20 trades
SELECT *
FROM trades
ORDER BY
created_at
LIMIT 20;

-- Trades by exchange
SELECT exchange, COUNT(*) 
FROM trades 
GROUP BY exchange 
LIMIT 1000;
-- The only exchange
-- is Bybit with 198,009 trades

-- Summary stats for price
SELECT AVG(executed_price) AS AVERAGE_executed_price,
MIN(executed_price) AS MIN_executed_price,
MAX(executed_price) AS MAX_executed_price
FROM trades;

-- --------------------------------------------------------------
-- EXPLORE logs
-- Are there any logs while the data was scraped?
-- Any logs that could show gaps in the data?
-- --------------------------------------------------------------

-- Get min and max times for the data
SET @min_date_time = NULL;
SET @max_date_time = NULL;
SELECT 
    MIN(date_time), 
    MAX(date_time)
INTO 
    @min_date_time, 
    @max_date_time
FROM 
    orderbook;
SELECT @min_date_time, @max_date_time;
-- The data is taken from '2024-05-17 01:52:07' to '2024-05-18 18:00:54'

-- Are there any logs during the data?
SELECT COUNT(*) 
AS LOGS_COUNT 
FROM logs;

SELECT * FROM logs ORDER BY date_time ASC;

SELECT COUNT(*)
FROM logs
WHERE date_time
BETWEEN @min_date_time AND @max_date_time;
-- There are some logs during the data being collected


-- We dont need the logs for every stream
SELECT *
FROM logs
WHERE date_time
BETWEEN @min_date_time AND @max_date_time
AND stream = 'watch_trades'
ORDER BY date_time ASC;
/*
There were a few instances of logs during the data being scraped. Near the start
a request timed out with the websocket heart beat missing. A connection reset error
throughout the dataset, and finally a network error at the end. None of the errors
were persistant. 
*/ 