-- ## Quality checks after inserting in a silver table ##

-- 1 -- check any dublicates or Null
-- Expectation: No Results

select
	cst_id,
	count(*) as TotCount
from silver.crm_cust_info
group by cst_id
having count(*)>1 or cst_id is null

-- 2 -- check for unwanted spaces in string values (name,gender,status,....)
-- Expectation: No Results

select cst_firstname
from silver.crm_cust_info
where cst_firstname <> TRIM(cst_firstname);

select cst_lastname
from silver.crm_cust_info
where cst_firstname <> TRIM(cst_firstname);

-- 3 -- Data Standardization & Consistency
Select Distinct cst_gndr 
from silver.crm_cust_info

-- 4 -- Check for negative numbers or null in (cost ,Revenue ,money ,...)

select prd_id,prd_cost
from silver.crm_prd_info
where prd_cost <0 or prd_cost is null

-- 5 -- Check for invalid Date orders >>>>  end date should be Bigger than start date
select*
from silver.crm_prd_info
where prd_end_dt < prd_start_dt

-- 6 -- Check for invalid Date orders
select *
from silver.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt

-- 7 --- Check Consistency : Sales, Quantity, Price
 select distinct 
 sls_sales,
 sls_quantity,
 sls_price
 from silver.crm_sales_details
 where sls_sales != sls_quantity * sls_price
or sls_sales is null or sls_price is null or sls_quantity is null
or sls_sales <=0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales,sls_quantity
