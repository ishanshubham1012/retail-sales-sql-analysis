# Sales Data Pipeline & Analytics Project

---

## Project Overview
This project focuses on the end-to-end processing of retail transaction data using SQL. The workflow transitions from raw data ingestion to systematic cleaning and high-level business intelligence. By leveraging advanced SQL techniques, the pipeline ensures data integrity and provides actionable insights into customer behavior, product performance, and operational efficiency.

---

## Database Schema
The primary data structure is the `sales_store` table, which serves as the foundation for the analysis.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| **transaction_id** | VARCHAR(20) | Unique identifier for each sales transaction. |
| **customer_id** | VARCHAR(20) | Unique identifier for the customer. |
| **customer_name** | VARCHAR(30) | Full name of the customer. |
| **customer_age** | INT | Age of the customer at the time of purchase. |
| **gender** | VARCHAR(20) | Gender of the customer. |
| **product_id** | VARCHAR(20) | Unique identifier for the product sold. |
| **product_name** | VARCHAR(20) | Name of the product. |
| **product_category** | VARCHAR(20) | Category/Department of the product. |
| **quantity** | INT | Number of units purchased. |
| **price** | FLOAT | Unit price of the product. |
| **payment_mode** | VARCHAR(20) | Method used for payment (e.g., Credit Card, UPI). |
| **purchase_date** | DATE | Calendar date of the transaction. |
| **time_of_purchase**| TIME | Exact timestamp of the transaction. |
| **status** | VARCHAR(20) | Current state of the order (Delivered, Cancelled, Returned, Pending). |

---

## Data Cleaning Workflow
The pipeline implements a rigorous cleaning process to ensure the dataset is "analysis-ready." The following steps were executed:

* **De-duplication Logic:** Used Common Table Expressions (CTEs) paired with the `ROW_NUMBER()` window function to identify duplicate `transaction_id` entries. Redundant records were filtered out using a backup table strategy to maintain row uniqueness.
* **Schema Standardization:** Applied `ALTER TABLE` commands to correct typos in header names (e.g., correcting "prce" to "price" and "quantiy" to "quantity") to ensure compatibility with downstream reporting tools.
* **Data Integrity & Null Management:** Filtered out records where critical identifiers like `transaction_id` were missing.
    * Performed data imputation by cross-referencing `customer_id` and `customer_name` to fill in missing demographic details, ensuring consistency across the customer base.
* **Categorical Normalization:** Standardized string values for uniformity. This included mapping variations like "Female" to "F" and "Male" to "M," as well as consolidating payment acronyms (e.g., "CC" to "Credit Card").

---

## Business Analysis & Insights
The following analytical queries were developed to extract strategic value from the cleaned dataset:

### 1. Product Performance
* **Top 5 Best Sellers:** Identified the most popular products by total quantity sold using `DENSE_RANK()`.
* **Cancellation Analysis:** Pinpointed products with the highest cancellation frequency to assist in quality control or supply chain reviews.

### 2. Customer Behavior
* **High-Value Customers:** Ranked the top five spenders by calculating the total revenue (`quantity * price`) per customer.
* **Gender-Based Preferences:** Aggregated product category sales by gender to inform targeted marketing campaigns.

### 3. Operational Trends
* **Peak Purchase Times:** Segmented transaction times into "Night," "Morning," "Afternoon," and "Evening" brackets to determine the busiest shopping windows.
* **Monthly Sales Growth:** Tracked revenue trends over time using `DATE_FORMAT` to visualize month-over-month performance.
* **Failure Rates:** Calculated a combined "Not Successful" rate (returns + cancellations) per category to evaluate logistics and customer satisfaction.

---

## Technologies Used
* **Language:** SQL (MySQL Dialect)
* **Key Techniques:**  
    * **Window Functions:** `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()` for complex ordering.
    * **CTEs:** For modular and readable query logic.
    * **Aggregations:** `SUM()`, `COUNT()`, `AVG()` with `GROUP BY` for data summarization.
    * **Conditional Logic:** `CASE WHEN` statements for categorical bucketing and rate calculations.
    * **Data Definition (DDL) & Manipulation (DML):** For schema architecture and data refinement.

