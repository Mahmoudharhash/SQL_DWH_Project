/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
-- STEP1 : Take a Bronze layer DDL script and replace "bronze." with "silver." to create silver tables.
-- STEP 2 : add a column for every table to Track the record's creation or load time in the DWH.

--1st table
if object_id('silver.crm_cust_info','U') is not null
	drop table silver.crm_cust_info;
create table silver.crm_cust_info (
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date,
	dwh_create_date DATETIME2 DEFAULT GETDATE()  -- Track the record's creation or load time in the DWH
);

--2nd table
if object_id('silver.crm_prd_info','U') is not null
	drop table silver.crm_prd_info;
create table silver.crm_prd_info (
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost nvarchar(50),
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date DATETIME2 DEFAULT GETDATE()  -- Track the record's creation or load time in the DWH
);

--3rd table
if object_id('silver.crm_sales_details','U') is not null
	drop table silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()  -- Track the record's creation or load time in the DWH
);

--4th table
if object_id('silver.erp_cust_az12','U') is not null
	drop table silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
	CID NVARCHAR(50),
	BDATE date,
	GEN NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()  -- Track the record's creation or load time in the DWH
);

--5th table
if object_id('silver.erp_loc_a101','U') is not null
	drop table silver.erp_loc_a101;
create table silver.erp_loc_a101 (
	CID nvarchar(50),
	CNTRY nvarchar(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()  -- Track the record's creation or load time in the DWH
);

--6th table
if object_id('silver.erp_px_cat_g1v2','U') is not null
	drop table silver.erp_px_cat_g1v2;
create table silver.erp_px_cat_g1v2 (
	ID nvarchar(50),
	CAT nvarchar(50),
	SUBCAT nvarchar(50),
	MAINTENANCE nvarchar(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()  -- Track the record's creation or load time in the DWH
);
