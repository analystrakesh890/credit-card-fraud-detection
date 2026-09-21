CREATE DATABASE fraud_detection;
USE fraud_detection;
USE fraud_detection;

CREATE TABLE credit_card_transactions (
    Time DOUBLE,
    V1 DOUBLE,
    V2 DOUBLE,
    V3 DOUBLE,
    V4 DOUBLE,
    V5 DOUBLE,
    V6 DOUBLE,
    V7 DOUBLE,
    V8 DOUBLE,
    V9 DOUBLE,
    V10 DOUBLE,
    V11 DOUBLE,
    V12 DOUBLE,
    V13 DOUBLE,
    V14 DOUBLE,
    V15 DOUBLE,
    V16 DOUBLE,
    V17 DOUBLE,
    V18 DOUBLE,
    V19 DOUBLE,
    V20 DOUBLE,
    V21 DOUBLE,
    V22 DOUBLE,
    V23 DOUBLE,
    V24 DOUBLE,
    V25 DOUBLE,
    V26 DOUBLE,
    V27 DOUBLE,
    V28 DOUBLE,
    Amount DOUBLE,
    Class TINYINT
);

DESCRIBE credit_card_transactions;



USE fraud_detection;

LOAD DATA INFILE 'C:/Users/hp/Downloads/creditcard.csv'
INTO TABLE credit_card_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

USE fraud_detection;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/creditcard.csv'
INTO TABLE credit_card_transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_rows
FROM credit_card_transactions;

SELECT
    Class,
    COUNT(*) AS total_transactions
FROM credit_card_transactions
GROUP BY Class;

#amount check 
SELECT
    MIN(Amount) AS minimum_amount,
    MAX(Amount) AS maximum_amount,
    AVG(Amount) AS average_amount
FROM credit_card_transactions;

#null check table
SELECT
    COUNT(*) AS total_rows,
    COUNT(Amount) AS amount_not_null,
    COUNT(Class) AS class_not_null
FROM credit_card_transactions;

#step 4 fraud analysis
#total transaction
SELECT COUNT(*) AS total_transactions
FROM credit_card_transactions;
#total fraude transaction
SELECT COUNT(*) AS fraud_transactions
FROM credit_card_transactions
WHERE Class = 1;
#fraud rate %
SELECT
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS fraud_rate_percent
FROM credit_card_transactions;
#Genunie vs fraud percentage
SELECT
    Class,
    COUNT(*) AS transactions,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM credit_card_transactions), 2) AS percentage
FROM credit_card_transactions
GROUP BY Class;
#fraud amount vs genuine amount
SELECT
    Class,
    COUNT(*) AS transactions,
    ROUND(SUM(Amount), 2) AS total_amount,
    ROUND(AVG(Amount), 2) AS average_amount
FROM credit_card_transactions
GROUP BY Class;


# Question 1: Average se bahut zyada amount wali transactions
SELECT
    Time,
    Amount,
    Class
FROM credit_card_transactions
WHERE Amount > (
    SELECT AVG(Amount)
    FROM credit_card_transactions
);

#Question 2: Average fraud amount se zyada fraud transactions
SELECT
    Time,
    Amount,
    Class
FROM credit_card_transactions
WHERE Class = 1
AND Amount > (
    SELECT AVG(Amount)
    FROM credit_card_transactions
    WHERE Class = 1
);

#Question 3: Highest transaction amount
SELECT
    Time,
    Amount,
    Class
FROM credit_card_transactions
WHERE Amount = (
    SELECT MAX(Amount)
    FROM credit_card_transactions
);

#Question 4: Fraud transactions above overall average
SELECT
    Time,
    Amount,
    Class
FROM credit_card_transactions
WHERE Class = 1
AND Amount > (
    SELECT AVG(Amount)
    FROM credit_card_transactions
);

#Fraud vs Genuine — Count
SELECT
    Class,
    COUNT(*) AS transaction_count
FROM credit_card_transactions
GROUP BY Class;

#Fraud transactions mein average amount
SELECT
    Class,
    COUNT(*) AS transaction_count,
    ROUND(AVG(Amount), 2) AS avg_amount
FROM credit_card_transactions
GROUP BY Class
HAVING Class = 1;

#Amount range ke according transactions
SELECT
    CASE
        WHEN Amount < 100 THEN 'Below 100'
        WHEN Amount < 500 THEN '100 - 499'
        WHEN Amount < 1000 THEN '500 - 999'
        WHEN Amount < 5000 THEN '1000 - 4999'
        ELSE '5000+'
    END AS amount_range,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS fraud_transactions
FROM credit_card_transactions
GROUP BY amount_range
ORDER BY fraud_transactions DESC;

#Sirf woh amount ranges jahan fraud mila
SELECT
    CASE
        WHEN Amount < 100 THEN 'Below 100'
        WHEN Amount < 500 THEN '100 - 499'
        WHEN Amount < 1000 THEN '500 - 999'
        WHEN Amount < 5000 THEN '1000 - 4999'
        ELSE '5000+'
    END AS amount_range,
    COUNT(*) AS fraud_transactions
FROM credit_card_transactions
WHERE Class = 1
GROUP BY amount_range
HAVING COUNT(*) > 0
ORDER BY fraud_transactions DESC;

#Question: Fraud transactions ko highest amount se lowest amount tak unique ranking do.
SELECT
    Time,
    Amount,
    Class,
    ROW_NUMBER() OVER (
        ORDER BY Amount DESC
    ) AS transaction_rank
FROM credit_card_transactions
WHERE Class = 1;

#rank
SELECT
    Time,
    Amount,
    Class,
    RANK() OVER (
        ORDER BY Amount DESC
    ) AS amount_rank
FROM credit_card_transactions
WHERE Class = 1;

#dense rank
SELECT
    Time,
    Amount,
    Class,
    DENSE_RANK() OVER (
        ORDER BY Amount DESC
    ) AS amount_rank
FROM credit_card_transactions
WHERE Class = 1;

# Top 10 Highest Fraud Transactions
SELECT *
FROM (
    SELECT
        Time,
        Amount,
        ROW_NUMBER() OVER (
            ORDER BY Amount DESC
        ) AS rn
    FROM credit_card_transactions
    WHERE Class = 1
) AS fraud_transactions
WHERE rn <= 10;

#Previous Transaction Amount
SELECT
    Time,
    Amount,
    Class,
    LAG(Amount) OVER (
        ORDER BY Time
    ) AS previous_amount
FROM credit_card_transactions;

#Previous Transaction se Amount Difference
SELECT
    Time,
    Amount,
    Class,
    LAG(Amount) OVER (
        ORDER BY Time
    ) AS previous_amount,
    Amount - LAG(Amount) OVER (
        ORDER BY Time
    ) AS amount_difference
FROM credit_card_transactions;

#Fraud Transactions ka Previous Amount
SELECT
    Time,
    Amount,
    LAG(Amount) OVER (
        ORDER BY Time
    ) AS previous_amount
FROM credit_card_transactions
WHERE Class = 1;

#Fraud Transaction aur Previous Transaction Compare
SELECT
    Time,
    Amount,
    previous_amount,
    ROUND(Amount - previous_amount, 2) AS amount_difference
FROM (
    SELECT
        Time,
        Amount,
        Class,
        LAG(Amount) OVER (
            ORDER BY Time
        ) AS previous_amount
    FROM credit_card_transactions
) AS t
WHERE Class = 1
ORDER BY Amount DESC;

#next transaction
SELECT
    Time,
    Amount,
    Class,
    LEAD(Amount) OVER (
        ORDER BY Time
    ) AS next_amount
FROM credit_card_transactions;

#current vs next transaction
SELECT
    Time,
    Amount,
    Class,
    LEAD(Amount) OVER (
        ORDER BY Time
    ) AS next_amount,
    LEAD(Amount) OVER (
        ORDER BY Time
    ) - Amount AS amount_difference
FROM credit_card_transactions;

#Fraud ke baad Next Transaction
SELECT
    Time,
    Amount,
    Class,
    next_amount
FROM (
    SELECT
        Time,
        Amount,
        Class,
        LEAD(Amount) OVER (
            ORDER BY Time
        ) AS next_amount
    FROM credit_card_transactions
) AS t
WHERE Class = 1
ORDER BY Time;

#ovearll average amount
SELECT
    ROUND(AVG(Amount), 2) AS overall_average
FROM credit_card_transactions;

#har transaction ke sath average amount
SELECT
    Time,
    Amount,
    Class,
    ROUND(AVG(Amount) OVER (), 2) AS overall_average
FROM credit_card_transactions;

#average se kitna jyda
SELECT
    Time,
    Amount,
    Class,
    ROUND(AVG(Amount) OVER (), 2) AS overall_average,
    ROUND(
        Amount - AVG(Amount) OVER (),
        2
    ) AS difference_from_average
FROM credit_card_transactions;

#suspicious transaction
WITH transaction_analysis AS (
    SELECT
        Time,
        Amount,
        Class,
        AVG(Amount) OVER () AS overall_average
    FROM credit_card_transactions
)
SELECT
    Time,
    Amount,
    Class,
    ROUND(overall_average, 2) AS overall_average,
    CASE
        WHEN Amount > overall_average * 3
        THEN 'Suspicious'
        ELSE 'Normal'
    END AS risk_status
FROM transaction_analysis;

#Fraud Transactions ko CTE mein nikalo
WITH fraud_transactions AS (
    SELECT
        Time,
        Amount,
        Class
    FROM credit_card_transactions
    WHERE Class = 1
)
SELECT *
FROM fraud_transactions;

#fraude ka average amount
WITH fraud_transactions AS (
    SELECT
        Time,
        Amount,
        Class
    FROM credit_card_transactions
    WHERE Class = 1
)
SELECT
    COUNT(*) AS fraud_count,
    ROUND(AVG(Amount), 2) AS average_fraud_amount,
    ROUND(MAX(Amount), 2) AS maximum_fraud_amount
FROM fraud_transactions;

#average se jyda fraud transaction
WITH fraud_transactions AS (
    SELECT
        Time,
        Amount,
        Class
    FROM credit_card_transactions
    WHERE Class = 1
),
fraud_average AS (
    SELECT
        AVG(Amount) AS avg_fraud_amount
    FROM fraud_transactions
)
SELECT
    f.Time,
    f.Amount,
    f.Class
FROM fraud_transactions f
CROSS JOIN fraud_average a
WHERE f.Amount > a.avg_fraud_amount
ORDER BY f.Amount DESC;

#cte aur window function
WITH fraud_analysis AS (
    SELECT
        Time,
        Amount,
        Class,
        AVG(Amount) OVER () AS avg_fraud_amount
    FROM credit_card_transactions
    WHERE Class = 1
)
SELECT
    Time,
    Amount,
    ROUND(avg_fraud_amount, 2) AS avg_fraud_amount,
    ROUND(Amount - avg_fraud_amount, 2) AS difference
FROM fraud_analysis
WHERE Amount > avg_fraud_amount
ORDER BY Amount DESC;

#Pehle fraud transactions ka average amount nikalo, phir usse greater fraud transactions find karo.
SELECT
    Time,
    Amount,
    Class
FROM credit_card_transactions
WHERE Class = 1
AND Amount > (
    SELECT AVG(Amount)
    FROM credit_card_transactions
    WHERE Class = 1
)
ORDER BY Amount DESC;

#Aise fraud transactions find karo jinka amount overall average se bhi zyada hai aur woh fraud hain.
SELECT
    Time,
    Amount,
    Class
FROM credit_card_transactions
WHERE Class = 1
AND Amount > (
    SELECT AVG(Amount)
    FROM credit_card_transactions
    WHERE Amount > (
        SELECT AVG(Amount)
        FROM credit_card_transactions
    )
);

SELECT
    MAX(Amount) AS max_fraud_amount
FROM credit_card_transactions
WHERE Class = 1;


SELECT
    Time,
    Amount,
    Class
FROM credit_card_transactions
WHERE Class = 1
AND Amount = (
    SELECT MAX(Amount)
    FROM credit_card_transactions
    WHERE Class = 1
);


SELECT
    'Fraud transactions found' AS status
WHERE EXISTS (
    SELECT 1
    FROM credit_card_transactions
    WHERE Class = 1
);

#Risk classification
SELECT
    Time,
    Amount,
    Class,
    CASE
        WHEN Class = 1 THEN 'Fraud'
        WHEN Amount > 1000 THEN 'High Amount'
        ELSE 'Normal'
    END AS risk_status
FROM credit_card_transactions
LIMIT 100;

#MULTIPLE RULE
SELECT
    Time,
    Amount,
    Class,
    CASE
        WHEN Class = 1 AND Amount > 1000
            THEN 'High Risk Fraud'

        WHEN Class = 1
            THEN 'Fraud'

        WHEN Amount > 1000
            THEN 'High Amount'

        ELSE 'Normal'
    END AS risk_level
FROM credit_card_transactions
LIMIT 100;

#RISK LEVEL COUNT
SELECT
    CASE
        WHEN Class = 1 AND Amount > 1000
            THEN 'High Risk Fraud'

        WHEN Class = 1
            THEN 'Fraud'

        WHEN Amount > 1000
            THEN 'High Amount'

        ELSE 'Normal'
    END AS risk_level,
    COUNT(*) AS transaction_count
FROM credit_card_transactions
GROUP BY risk_level
ORDER BY transaction_count DESC;

#isk level ke according total transactions aur total amount
SELECT
    CASE
        WHEN Class = 1 AND Amount > 1000 THEN 'High Risk Fraud'
        WHEN Class = 1 THEN 'Fraud'
        WHEN Amount > 1000 THEN 'High Amount'
        ELSE 'Normal'
    END AS risk_level,
    COUNT(*) AS transaction_count,
    ROUND(SUM(Amount), 2) AS total_amount
FROM credit_card_transactions
GROUP BY risk_level
ORDER BY transaction_count DESC;

#High Risk Fraud
SELECT
    Time,
    Amount,
    Class
FROM credit_card_transactions
WHERE Class = 1
AND Amount > 1000
ORDER BY Amount DESC
LIMIT 20;

#Overall Fraud Summary
SELECT
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    SUM(CASE WHEN Class = 0 THEN 1 ELSE 0 END) AS genuine_transactions,
    ROUND(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS fraud_rate_percent
FROM credit_card_transactions;

#fraud amount summery
SELECT
    COUNT(*) AS fraud_transactions,
    ROUND(SUM(Amount), 2) AS total_fraud_amount,
    ROUND(AVG(Amount), 2) AS average_fraud_amount,
    ROUND(MAX(Amount), 2) AS maximum_fraud_amount,
    ROUND(MIN(Amount), 2) AS minimum_fraud_amount
FROM credit_card_transactions
WHERE Class = 1;

#high risk fraud summery
SELECT
    COUNT(*) AS high_risk_fraud_count,
    ROUND(SUM(Amount), 2) AS high_risk_fraud_amount,
    ROUND(AVG(Amount), 2) AS average_high_risk_amount
FROM credit_card_transactions
WHERE Class = 1
AND Amount > 1000;

#final risk report
SELECT
    CASE
        WHEN Class = 1 AND Amount > 1000 THEN 'High Risk Fraud'
        WHEN Class = 1 THEN 'Fraud'
        WHEN Amount > 1000 THEN 'High Amount'
        ELSE 'Normal'
    END AS risk_level,
    COUNT(*) AS transaction_count,
    ROUND(SUM(Amount), 2) AS total_amount,
    ROUND(AVG(Amount), 2) AS average_amount
FROM credit_card_transactions
GROUP BY risk_level
ORDER BY transaction_count DESC;