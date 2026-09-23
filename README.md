# Credit Card Fraud Detection using SQL

## 📌 Project Overview

This project focuses on analyzing credit card transactions and identifying fraudulent transactions using **SQL and MySQL**.

The main goal is to analyze transaction patterns, calculate fraud rates, identify high-value fraud transactions, and create rule-based risk classifications using practical SQL techniques.

---

## 📊 Dataset

**Credit Card Fraud Detection Dataset**

Source: Kaggle — Credit Card Fraud Detection

Dataset contains:

* `Time` — Time elapsed between transactions
* `V1` to `V28` — Anonymized transaction features
* `Amount` — Transaction amount
* `Class` — Fraud indicator

### Fraud Classification

* `Class = 0` → Genuine Transaction
* `Class = 1` → Fraudulent Transaction

The original CSV dataset is **not included** in this repository because of its large size.

---

## 🛠️ Tools Used

* MySQL
* MySQL Workbench
* SQL
* GitHub

---

## 🔍 Project Workflow

### 1. Database Creation

Created a dedicated MySQL database:

```sql
CREATE DATABASE fraud_detection;
USE fraud_detection;
```

### 2. Table Creation

Created a transaction table containing:

* Time
* V1–V28
* Amount
* Class

### 3. Data Import

Imported the Kaggle CSV dataset into MySQL and validated the imported records.

**Total transactions:** 284,807

### 4. Data Validation

Performed:

* Row count validation
* NULL checks
* Minimum and maximum amount analysis
* Fraud vs genuine transaction count

### 5. Fraud Rate Analysis

Calculated:

* Total transactions
* Total fraud transactions
* Total genuine transactions
* Fraud percentage
* Average fraud amount
* Maximum fraud amount

### 6. Subquery Analysis

Used subqueries to identify:

* Transactions above average amount
* Fraud transactions above average fraud amount
* Maximum fraud transaction
* High-value fraud transactions

### 7. GROUP BY & HAVING

Performed grouped analysis using:

* `GROUP BY`
* `HAVING`
* `COUNT()`
* `SUM()`
* `AVG()`

Also analyzed fraud transactions across different amount ranges.

### 8. Window Functions

Applied:

* `ROW_NUMBER()`
* `RANK()`
* `DENSE_RANK()`

These were used to rank fraudulent transactions according to transaction amount.

### 9. LAG & LEAD

Used:

```sql
LAG()
```

to analyze the previous transaction amount.

Used:

```sql
LEAD()
```

to analyze the next transaction amount.

### 10. Anomaly Detection

Used:

```sql
AVG() OVER()
```

to compare individual transactions against the overall average transaction amount.

### 11. CTE Analysis

Used Common Table Expressions (`CTEs`) to make complex fraud analysis queries more readable and structured.

### 12. Advanced Subqueries

Practiced:

* Scalar subqueries
* Nested subqueries
* Correlated subquery concepts
* `EXISTS`

### 13. Fraud Risk Rules

Created SQL-based risk classifications:

| Condition                   | Risk Level      |
| --------------------------- | --------------- |
| Class = 1 AND Amount > 1000 | High Risk Fraud |
| Class = 1                   | Fraud           |
| Amount > 1000               | High Amount     |
| Otherwise                   | Normal          |

### 14. Final Fraud Report

Created a final SQL summary containing:

* Total transactions
* Fraud transactions
* Genuine transactions
* Fraud rate
* Total fraud amount
* Average fraud amount
* Maximum fraud amount
* High-risk fraud transactions

---

## 📈 Key SQL Concepts

This project demonstrates practical knowledge of:

* SELECT
* WHERE
* CASE WHEN
* Aggregate Functions
* GROUP BY
* HAVING
* ORDER BY
* Subqueries
* Nested Subqueries
* EXISTS
* CTEs
* Window Functions
* ROW_NUMBER
* RANK
* DENSE_RANK
* LAG
* LEAD
* AVG() OVER()
* Fraud-rate calculations
* Rule-based risk classification

---

## 💡 Key Business Questions

This project answers questions such as:

1. How many fraudulent transactions are present?
2. What percentage of transactions are fraudulent?
3. What is the average fraud transaction amount?
4. What is the maximum fraud transaction amount?
5. Which transactions have amounts above the average?
6. Which are the highest-value fraud transactions?
7. How can transactions be classified into different risk levels?
8. How can SQL window functions help analyze transaction patterns?

---

## 📁 Project Structure

```text
credit-card-fraud-detection-sql/
│
├── README.md
│
├── sql/
│   └── fraud_detection_analysis.sql
│
└── .gitignore
```

---

## ▶️ How to Run the Project

### Step 1 — Download Dataset

Download the Credit Card Fraud Detection dataset from Kaggle.

### Step 2 — Create Database

```sql
CREATE DATABASE fraud_detection;
USE fraud_detection;
```

### Step 3 — Create Table

Create the `credit_card_transactions` table using the SQL structure provided in the project.

### Step 4 — Import Dataset

Import `creditcard.csv` into the MySQL table.

If MySQL's `secure_file_priv` restriction is enabled, place the CSV inside the allowed MySQL upload directory.

### Step 5 — Run SQL Queries

Open:

```text
sql/fraud_detection_analysis.sql
```

Run the queries section by section in MySQL Workbench.

---

## ⚠️ Dataset Note

The dataset contains anonymized PCA-transformed features (`V1`–`V28`). Therefore, this project focuses primarily on transaction amount, fraud classification, time-based analysis, and SQL-driven fraud detection rather than customer or merchant-level analysis.

---

## 🎯 Project Outcome

The project demonstrates how SQL can be used to perform an end-to-end fraud analysis workflow, from data validation and exploratory analysis to advanced SQL techniques and rule-based fraud-risk classification.

---

## 👤 Author

**Rakesh Gupta**

Aspiring Data Analyst
Skills: SQL | MySQL | Data Analysis

---

## ⭐ Skills Demonstrated

**SQL | MySQL | Data Cleaning | Data Analysis | Fraud Detection | Subqueries | CTEs | Window Functions | Business Analysis**
