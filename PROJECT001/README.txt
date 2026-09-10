# Data Cleaning & Analytical Queries in Microsoft SQL Server.

## Overview
This repository contains end-to-end SQL scripts designed to clean messy relational datasets ('staff_raw' and 'sales') and answer data-quality and reporting queries.

## Topics Covered
* String Manipulation: Standardizing casing, stripping invalid whitespace, and parsing nested string indexes (TRIM, SUBSTRING, CHARINDEX, REPLACE).
* Date Math & Parsing: Converting mixed string formats to DATE, computing exact tenure, and running month-end calculations (TRY_CAST, DATEDIFF, DATEADD, EOMONTH, DATETRUNC).
* NULL & Data Quality Handling: Preventing divide-by-zero crashes, generating automated NULL audit reports, and setting default values (ISNULL, COALESCE, NULLIF).

## Repository Structure
* `schema_and_data.sql`: Setup script containing raw table definitions and sample data insertions.
* `data_cleaning_solutions.sql`: Complete query solutions for Tasks 1 through 26.

## Requirements
* Microsoft SQL Server (T-SQL)