
/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

------------------------------------------------------------
-- #1# Create Bronze Layer icluding all files in all sources
------------------------------------------------------------
-- STEP1 : write a query to make sure that the table isn't in the DB and if it was in the DB drop it and create the table
-- STEP 2 : write a query to create the table 

--1st table
if object_id('bronze.crm_cust_info','U') is not null
	drop table bronze.crm_cust_info;
create table bronze.crm_cust_info (
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date
);

--2nd table
if object_id('bronze.crm_prd_info','U') is not null
	drop table bronze.crm_prd_info;
create table bronze.crm_prd_info (
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost nvarchar(50),
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date
);

--3rd table
if object_id('bronze.crm_sales_details','U') is not null
	drop table bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);

--4th table
if object_id('bronze.erp_cust_az12','U') is not null
	drop table bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
	CID NVARCHAR(50),
	BDATE date,
	GEN NVARCHAR(50)
);

--5th table
if object_id('bronze.erp_loc_a101','U') is not null
	drop table bronze.erp_loc_a101;
create table bronze.erp_loc_a101 (
	CID nvarchar(50),
	CNTRY nvarchar(50)
);

--6th table
if object_id('bronze.erp_px_cat_g1v2','U') is not null
	drop table bronze.erp_px_cat_g1v2;
create table bronze.erp_px_cat_g1v2 (
	ID nvarchar(50),
	CAT nvarchar(50),
	SUBCAT nvarchar(50),
	MAINTENANCE nvarchar(50)
);



