-- Replicating the raw table structure for a dedicated cleaning environment
 create table sales 
 like sales_store;

-- Populating the cleaning table with original data

insert into sales 
select * from sales_store;

-- Verification of data transfer
select *from sales;


-- Data Cleaning
-- 1. Checking duplicates on the basis of transaction_id
with cte as 
(
select *,
        row_number() over(partition by transaction_id order by customer_id) as rn
from sales
)
,
cte2 as
(
select transaction_id from cte where rn = 2)
select * from cte
where transaction_id in (select transaction_id from cte where rn = 2)
;
-- Removing duplicates by rebuilding the table with distinct records

create table sales_backup as 
select distinct * from sales;
truncate sales;
insert into sales select * from sales_backup;
drop table sales_backup;


select * from sales;

-- 2. Schema refinement: Correcting column headers

desc sales;
alter table sales
rename column prce to price;

alter table sales
rename column quantiy to quantity;

-- 3. Data Integrity: Auditing for NULL values across the dataset

select * from sales 
where transaction_id is null 
or customer_id is null
or customer_name is null
or customer_age is null
or gender is  null
or product_id is null
or product_name is null
or product_category is null
or quantity is null
or price is null
or payment_mode is null
or purchase_date is null
or time_of_purchase is null
or status is null;

-- Deleting row where transction_id is null
delete from sales where transaction_id is null ;

-- Manual data imputation for specific records with known missing attributes
UPDATE sales
SET customer_name='Mahika Saini',customer_age=35,gender='Male'
WHERE transaction_id='TXN432798';

-- Cross-referencing customer names to fix missing or incorrect customer IDs
select *
from sales
where customer_name = "Damini Raju";

-- Updating with cross referenced customer name
update  sales
set customer_id = "CUST1401"
where customer_name = "Damini Raju";

-- 4. Categorical Standardization: Normalizing Gender values

select distinct gender from sales ;

update sales 
set gender = "F"
where gender = "Female";
update sales 
set gender = "M"
where gender = "Male";

-- 5. Categorical Standardization: Mapping Payment Mode aliases

select distinct payment_mode from sales;

update sales 
set payment_mode = "Credit Card"
where payment_mode = "CC";