-- This script explores the database
USE crypto_test_1;
SET GLOBAL sql_mode = 'ONLY_FULL_GROUP_BY';


-- Show all tables
SHOW tables;

-- Retrieve first 50 rows from each table
SELECT * FROM logs LIMIT 50;
SELECT * FROM ohlcv LIMIT 50;
SELECT * FROM orderbook LIMIT 50;
SELECT * FROM ticker LIMIT 50;
SELECT * FROM trades LIMIT 50;

-- Explore logs
SELECT COUNT(*) FROM logs;
select * from logs 
select exchange, count(*) from logs group by exchange;
