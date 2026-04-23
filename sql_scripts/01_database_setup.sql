drop table if exists sales_store;
CREATE TABLE sales_store (
  transaction_id VARCHAR(255),
  customer_id VARCHAR(255),
  customer_name VARCHAR(255),
  customer_age INT,
  gender VARCHAR(255),
  product_id VARCHAR(255),
  product_name VARCHAR(255),
  product_category VARCHAR(255),
  quantiy INT,
  prce FLOAT,
  payment_mode VARCHAR(255),
  purchase_date DATE,
  time_of_purchase TIME,
  status VARCHAR(255)
);

-- =================================================================================
-- DATA LOADING SCRIPT: Retail Sales Dataset
-- Purpose: Import raw CSV data into the 'sales_store' table.
-- Special Handling: This script manages 5 extra "ghost" columns found in the CSV 
-- and performs data cleaning (TRIM and NULL handling) during the import process.
-- =================================================================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_store_dataset - Copy.csv'
INTO TABLE sales_store

-- 1. DEFINE DATA FORMATTING
-- Tells MySQL how to distinguish between different cells and rows
FIELDS TERMINATED BY ','          -- Identifies the comma as the column separator
OPTIONALLY ENCLOSED BY '"'       -- Allows MySQL to correctly read data if it contains quotes (e.g., "Sofa,Blue")
LINES TERMINATED BY '\r\n'       -- Uses \r (Carriage Return) + \n (Line Feed) for Windows compatibility
IGNORE 1 LINES                    -- Skips the first row (the header names) in the CSV

-- 2. COLUMN MAPPING (Variable List)
-- We read the CSV data into temporary "@" variables first.
-- This allows us to handle columns that don't exist in our table.
(
    @transaction_id, 
    @customer_id, 
    @customer_name, 
    @customer_age, 
    @gender, 
    @product_id, 
    @product_name, 
    @product_category, 
    @quantiy, 
    @prce, 
    @payment_mode, 
    @purchase_date, 
    @time_of_purchase, 
    @status,
    -- THE FIX: These 5 variables catch trailing empty commas in the CSV 
    -- and prevent "Error 1262: Row was truncated"
    @dummy1, @dummy2, @dummy3, @dummy4, @dummy5 
)

-- 3. DATA TRANSFORMATION & CLEANING
-- We move the data from the temporary variables into the actual table columns.
SET 
    -- TRIM() removes hidden spaces or carriage returns
    -- NULLIF(..., '') converts empty strings into proper NULL values for database integrity
    transaction_id   = NULLIF(TRIM(@transaction_id), ''), 
    customer_id      = NULLIF(TRIM(@customer_id), ''), 
    customer_name    = NULLIF(TRIM(@customer_name), ''), 
    customer_age     = NULLIF(TRIM(@customer_age), ''), 
    gender           = NULLIF(TRIM(@gender), ''), 
    product_id       = NULLIF(TRIM(@product_id), ''), 
    product_name     = NULLIF(TRIM(@product_name), ''), 
    product_category = NULLIF(TRIM(@product_category), ''), 
    quantiy          = NULLIF(TRIM(@quantiy), ''), 
    prce             = NULLIF(TRIM(@prce), ''), 
    payment_mode     = NULLIF(TRIM(@payment_mode), ''), 
    purchase_date    = NULLIF(TRIM(@purchase_date), ''), 
    time_of_purchase = NULLIF(TRIM(@time_of_purchase), ''), 
    status           = NULLIF(TRIM(@status), '');

