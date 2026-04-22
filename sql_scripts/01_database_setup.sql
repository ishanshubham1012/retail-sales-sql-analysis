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