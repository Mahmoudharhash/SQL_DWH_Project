--## Data Cleaning ##
-- Before doing data cleaning , check the quality

--1-- check any dublicates or Null in Primary key

--## check any dublicates or Null
select
	cst_id,
	count(*) as TotCount
from bronze.crm_cust_info
group by cst_id
having count(*)>1 or cst_id is null

--## Cleaning it
select *
from
(
	select 
		*,
		ROW_NUMBER()over(partition by cst_id order by cst_create_date desc) as flag_last
	from bronze.crm_cust_info
	where cst_id is not null
) as t
where flag_last=1


-- 2 -- check for unwanted spaces in string values (name,gender,status,....)
--## CHECK
select cst_firstname
from bronze.crm_cust_info
where cst_firstname <> TRIM(cst_firstname);

select cst_lastname
from bronze.crm_cust_info
where cst_firstname <> TRIM(cst_firstname);

-- Clean it with (TRIM) function and replcae (F,M) to (Female,Male) and (S,M) to (Single,Married)
SELECT  
	cst_id,
    cst_key,
    Trim(cst_firstname) as cst_firstname,
    Trim(cst_lastname) as cst_lastname,
	case
		when Upper(Trim(cst_marital_status)) = 'S' then'Single'
		when Upper(Trim(cst_marital_status)) ='M' then 'Married'
		else 'n/a'
	end as cst_marital_status,
		case
		when Upper(Trim(cst_gndr)) = 'M' then'Male'
		when Upper(Trim(cst_gndr)) ='F' then 'Female'
		else 'n/a'
	end as cst_gndr,
      cst_gndr,
      cst_create_date
  FROM
  (
	select 
		*,
		ROW_NUMBER()over(partition by cst_id order by cst_create_date desc) as flag_last
	from bronze.crm_cust_info
	where cst_id is not null
) as t
where flag_last=1


-- 3 -- Check for negative numbers or null in (cost ,Revenue ,money ,...)
select prd_id,prd_cost
from bronze.crm_prd_info
where prd_cost <1 or prd_cost is null
--replace null with 'n/n' or (0) as the business agreement
select isnull(prd_cost,0) as prd_cost
from bronze.crm_prd_info

-- 4 -- after adding columns in bronze.crm_prd_info we should identify the type for it in Silver Schema
if object_id('silver.crm_prd_info','U') is not null
	drop table silver.crm_prd_info;
create table silver.crm_prd_info (
	prd_id int,
	cat_id nvarchar(50), -- new column
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date DATETIME2 DEFAULT GETDATE()  -- Track the record's creation or load time in the DWH
);


-- 5 -- if we a have a column including dates but its type is (INT)  >>> Do those Checks
select sls_order_dt
from bronze.crm_sales_details
where sls_order_dt<=0
or LEN(sls_order_dt) !=8 --- the length of date is 8
or sls_order_dt > 20200101 -- the boundary of business date
or sls_order_dt < 19000101 -- the boundary of business date

-- Fix it 
select
	case
		when sls_order_dt = 0 or len(sls_order_dt) !=8 then NULL
		ELSE CAST(CAST(sls_order_dt AS varchar) AS DATE )
		END AS sls_order_dt
from bronze.crm_sales_details

-- 6 -- Check Order Dates
-- sls_order_dt  should be less than sls_ship_dt and sls_due_dt
select *
from bronze.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt


-- 7 --  Check sales,Quantity,Price and the Calculation 
select distinct
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales is null or sls_price is null or sls_quantity is null
or sls_sales <=0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales,sls_quantity


-- fix it --
-- conditions
--* if sales is negative or equal zero or null >>>> derive it using Quantity and price
--* if Price is zero or null >>>>> calaculate it using sales and Quantity
--* if price is negative >>>> convert it to a Positive value
SELECT 
	sls_ord_num,
	CASE WHEN sls_sales <= 0 or sls_sales is NULL or sls_sales!= sls_quantity * ABS(sls_price)
			THEN  sls_quantity * ABS(sls_price)
		 ELSE sls_sales
	END AS sls_sales,
    sls_quantity,    
	CASE WHEN sls_price is NULL or sls_price <=0
		 THEN sls_sales / NULLIF(sls_quantity,0)
		 ELSE sls_price
	END AS sls_price

  FROM bronze.crm_sales_details
