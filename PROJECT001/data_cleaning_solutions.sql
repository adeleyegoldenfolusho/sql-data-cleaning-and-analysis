/* TASK 1: 'staff_raw.full_name' has inconsistent casing, extra internal spaces, and
   leading/trailing whitespace. Produce a clean version where every name is
   in Proper Case with single spaces only. */
   WITH CLEANED_FULL_NAME AS (
   SELECT 
   FULL_NAME,
   REPLACE(REPLACE(REPLACE(TRIM(FULL_NAME), ' ', '<>'), '><' ,''), '<>', ' ') AS CLEANED_NAME
   FROM STAFF_RAW
   )
   SELECT
   CLEANED_NAME,
   CONCAT(
   UPPER(LEFT(CLEANED_NAME,1)) ,
   LOWER(SUBSTRING(CLEANED_NAME,2, CHARINDEX(' ', CLEANED_NAME + ' ') - 1)),
   UPPER(SUBSTRING(CLEANED_NAME, CHARINDEX(' ', CLEANED_NAME + ' ') + 1,1)) ,
   LOWER(SUBSTRING(CLEANED_NAME, CHARINDEX(' ', CLEANED_NAME + ' ') +2, LEN(CLEANED_NAME)))
   ) AS PROPERNAME
   FROM CLEANED_FULL_NAME
 
    
   /* TASK 2: Standardize 'department_raw' into clean values: trim whitespace, and
   make everything title case.*/
   SELECT
   DEPARTMENT_RAW,
   UPPER(LEFT(TRIM(DEPARTMENT_RAW),1))+
   LOWER(SUBSTRING(TRIM(DEPARTMENT_RAW),2,100)) AS CLEANED_DEPARTMENT
   FROM STAFF_RAW

   /* TASK 3: Extract just the digits from 'phone_raw', stripping out parentheses,
   dashes, and spaces. */
   SELECT
   PHONE_RAW,
   REPLACE(REPLACE(REPLACE(REPLACE(PHONE_RAW, '(',''), ')',''), ' ', ''),'-','') AS CLEANED_PHONE_NUMBER
   FROM STAFF_RAW

   /* TASK 4:  Build each employee's company email in the format
   'firstname.lastname@brightmart.com' (all lowercase) from the cleaned
   full_name, ignoring whatever is in the messy email column. */
   SELECT
   EMAIL,
   FULL_NAME,
   LOWER(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(FULL_NAME),' ','<>'),'><', ''),'<>', ' '),' ','.')) +
   '@brightmart.com' AS NEW_EMPLOYEE_EMAIL
   FROM STAFF_RAW

   /* TASK 5:  Some rows have a NULL email. Using COALESCE, return either the
   existing email or the generated 'firstname.lastname@brightmart.com'
   fallback — whichever is available, preferring the generated one for
   consistency but falling back if name-parsing fails. */
   SELECT
   EMAIL,
   COALESCE(LOWER(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(FULL_NAME),' ','<>'),'><', ''),'<>', ' '),' ','.')) +
   '@brightmart.com', EMAIL) AS EMAIL_ADDRESS
   FROM STAFF_RAW

   -- TASK 6: Find every staff member whose 'full_name', once trimmed, is longer than 15 character. --
   SELECT
   FULL_NAME,
   LEN(TRIM(FULL_NAME)) AS LENGHT
   FROM STAFF_RAW
   WHERE LEN(TRIM(FULL_NAME)) > 15

   /* TASK 7: 'salary_text' has a mix of $45,000, NGN 38,000, and plain
   52000. Strip out every non-digit character and produce a clean
   numeric salary  column for all 15 rows. */
   SELECT
   SALARY_TEXT,
   TRIM(REPLACE(REPLACE(REPLACE(SALARY_TEXT, '$', ''), 'NGN',''),',',''))
   FROM STAFF_RAW

   /* TASK 8: For every staff member, produce a single formatted summary string like:
   'John — IT Support — $45,000.00"` using `CONCAT`, and your cleaned
   name/department/salary from above. */
   WITH ABC AS (
   SELECT
   FULL_NAME,
   UPPER(LEFT(TRIM(DEPARTMENT_RAW),1))+
   LOWER(SUBSTRING(TRIM(DEPARTMENT_RAW),2,100)) AS CLEANED_DEPARTMENT,
   TRIM(REPLACE(REPLACE(REPLACE(SALARY_TEXT, '$', ''), 'NGN',''),',','')) AS CLEANED_SALARY
   FROM STAFF_RAW
   )
   SELECT
   CONCAT(
   UPPER(LEFT(TRIM(FULL_NAME),1)),  
   LOWER(SUBSTRING(TRIM(FULL_NAME),2,CHARINDEX(' ', TRIM(FULL_NAME) + ' ')-1)),
   '-',
   CLEANED_DEPARTMENT,
   '-',
   CLEANED_SALARY) AS INFO
   FROM ABC
  
    
    /* TASK 9: 'hire_date_text' contains dates in at least 5 different formats, plus
   invalid entries like 'not a date' and 'N/A'. Write a query that returns only the rows 
   where the value is a valid date */

   SELECT
   HIRE_DATE_TEXT
   FROM STAFF_RAW
   WHERE ISDATE(HIRE_DATE_TEXT) = 1

   -- TASK 10: For the valid dates, convert them to a proper DATE type--
    WITH DEF AS (
    SELECT
     HIRE_DATE_TEXT AS HIRE_DATE
   FROM STAFF_RAW
   WHERE ISDATE(HIRE_DATE_TEXT) = 1
   )
   SELECT
   CAST(HIRE_DATE AS DATE) AS HIREDATE_VALUE
   FROM DEF

   /* TASK 11: For every staff member with a valid hire date, calculate their tenure
    in full years as of today, using DATEDIFF and GETDATE().
    (Careful: naive DATEDIFF(YEAR, ...) counts calendar years crossed, not
    full years e.g., someone hired Dec 2023 shows "2 years" on Jan 2025
    under naive DATEDIFF even though only 1 year has passed. Handle this
    correctly.) */
    WITH DEF AS (
     SELECT
     HIRE_DATE_TEXT AS HIRE_DATE
   FROM STAFF_RAW
   WHERE ISDATE(HIRE_DATE_TEXT) = 1
   )
   SELECT
   CAST(HIRE_DATE AS DATE) AS HIREDATE_VALUE,
   GETDATE() AS CURRENT_DATETIME,
   DATEDIFF(YEAR,CAST(HIRE_DATE AS DATE),GETDATE()) 
   -CASE
            WHEN DATEADD(YEAR, DATEDIFF(YEAR,CAST(HIRE_DATE AS DATE), GETDATE()),
                         CAST(HIRE_DATE AS DATE)) > GETDATE()
            THEN 1 ELSE 0
          END AS full_years_tenure
   FROM DEF
    
    /* TASK 12:  Find every staff member hired in the month of January, regardless
    of year.*/
     SELECT
     STAFF_ID,
     TRY_CONVERT(DATE,HIRE_DATE_TEXT) AS HIRE_DATE
   FROM STAFF_RAW
   WHERE ISDATE(HIRE_DATE_TEXT) = 1 AND MONTH(TRY_CONVERT(DATE,HIRE_DATE_TEXT)) = 1
  
  -- TASK 13: Return each valid hire date's weekday name --
  SELECT
  STAFF_ID,
  DATENAME(WEEKDAY,CAST(HIRE_DATE_TEXT AS DATE)) AS DATENAME_HIREDATE
  FROM STAFF_RAW
  WHERE ISDATE(HIRE_DATE_TEXT) = 1

  /* TASK 14:  For staff with a termination_date_text, calculate how many months they worked,
    using 'DATEDIFF'. Handle the fact that most rows have 'NULL' here — 
    those should show as "Still employed" (use `CASE` + `IS NULL`, or `ISNULL`/`COALESCE` creatively with a placeholder). */
    
   SELECT
    STAFF_ID,
    CASE
        WHEN TERMINATION_DATE_TEXT IS NULL THEN 'STILL EMPLOYED'
        ELSE CAST(DATEDIFF(MONTH, TRY_CONVERT(DATE, HIRE_DATE_TEXT),
                            TRY_CONVERT(DATE, TERMINATION_DATE_TEXT)) AS VARCHAR) + ' MONTHS '
    END AS EMPLOYMENT_DURATION
FROM STAFF_RAW
WHERE ISDATE(HIRE_DATE_TEXT) = 1
   
   /* TASK 15: In the sales table, find every sale where the ship_date is more
    than 5 days after sale_date — these are your "late shipments" */
    SELECT
     SALE_ID
    FROM SALES
    WHERE DATEDIFF(DAY,SALE_DATE, SHIP_DATE) > 5

   /* TASK 16:  For every sale, calculate the estimated refund deadline, defined as
    30 days after ship_date, using DATEADD. If ship_date is NULL
    (never shipped), the refund deadline should also be NULL */
    SELECT
    DATEADD(DAY,30,SHIP_DATE) AS REFUND_DEADLINE
    FROM SALES
     
     /* TASK 17: Using EOMONTH, find the last day of the month for every sale,  then
    count how many sales happened in the last 5 days of their month */
    SELECT
    SALE_DATE,
    EOMONTH(SALE_DATE) AS END_OF_MONTH,
    DATEADD(DAY,-5,EOMONTH(SALE_DATE)) AS '5DAYS_PRIOR'
    FROM SALES
    WHERE SALE_DATE BETWEEN  DATEADD(DAY,-5,EOMONTH(SALE_DATE)) AND EOMONTH(SALE_DATE);

    SELECT *
    FROM SALES
    WHERE DATEDIFF(DAY, sale_date, EOMONTH(sale_date)) <= 4

    -- TASK 18:  Using DATETRUNC group total sales amount by month.--
    SELECT
    DATETRUNC(MONTH,SALE_DATE) AS MONTH_START,
    SUM(AMOUNT) AS TOTALSUM
    FROM SALES
    GROUP BY DATETRUNC(MONTH,SALE_DATE)
    

    /* TASK 19:  Format sale_date as 'DD Mon YYYY' (e.g., `05 Jan 2024`) using
    FORMAT, for a report-friendly display column. */
    SELECT 
    SALE_DATE,
    FORMAT(SALE_DATE, 'dd-MMM-yyyy') AS FORMATTED_DATE
    FROM SALES

    /* TASK 20: Count how many rows in staff_raw have a NULL email, a NULL phone_raw, and a NULL
    manager_name, three separate counts, onequery. */
    SELECT
    SUM(CASE WHEN EMAIL IS NULL THEN 1 ELSE 0 END) AS NULL_EMAILS,
    SUM(CASE WHEN PHONE_RAW IS NULL THEN 1 ELSE 0 END) AS NULL_PHONES,
    SUM(CASE WHEN MANAGER_NAME IS NULL THEN 1 ELSE 0 END) AS NULL_MANAGERS
    FROM STAFF_RAW

    --TASK 21: Replace every NULL bonus with '0', then calculate total compensation (salary + bonus) for everyone. --
    SELECT
    BONUS,
    SALARY_TEXT,
    ISNULL(BONUS, '0.00') +
    CAST(REPLACE(REPLACE(REPLACE(SALARY_TEXT, 'NGN',''),'$',''),',','') AS DECIMAL(10,2)) AS TOTALCOMPENSATION
    FROM STAFF_RAW

   /* TASK 22: In sales, discount_pct is NULL for several rows ,this could mean "no discount" OR "we don't know"
   Business rule: treat NULL as "nodiscount" (i.e 0). Calculate the final price (amount - (amount * discount_pct / 100)`) for every sale. */
    SELECT
    SALE_ID,
    AMOUNT,
    DISCOUNT_PCT,
    ISNULL(DISCOUNT_PCT, 0) AS DISCOUNT,
    AMOUNT - (AMOUNT* (ISNULL(DISCOUNT_PCT, 0)/100)) AS FINALPRICE 
     FROM SALES
     
     /* TASK 23: Find every staff member who has no manager assigned (manager_name IS NULL)
     these might be top-level managers or data-entry errors.
    Cross-reference: are any of them also missing a department? Combine conditions. */
    SELECT
    STAFF_ID,
    MANAGER_NAME
    FROM STAFF_RAW
    WHERE MANAGER_NAME IS NULL AND DEPARTMENT_RAW IS NOT NULL

    /* TASK 24:  Use NULLIF to prevent a divide-by-zero error: calculate amount / discount_pct for every sale,
    making sure rows where discount_pct = 0 return NULL instead of crashing the query. */
    SELECT
    AMOUNT,
    DISCOUNT_PCT,
    AMOUNT / (NULLIF( DISCOUNT_PCT,0)) AS AMOUNT_PER_DISCOUNT
    FROM SALES

    /* TASK 25: Trap question: Write a query using WHERE manager_name = NULL to
    find staff with no manager. Run it. Why does it return zero rows even
    though you know some exist? Fix it correctly. */

    SELECT
    MANAGER_NAME
    FROM STAFF_RAW
    WHERE MANAGER_NAME IS NULL
   
    /* TASK 26: Build a single data quality report query that, for staff_raw,
    returns one row per column showing how many NULLs exist in each of: 'email',
    'phone_raw', 'manager_name', 'bonus', 'termination_date_text'.*/
    SELECT 'email' AS column_name, COUNT(*) AS null_count FROM staff_raw WHERE email IS NULL
UNION ALL
SELECT 'phone_raw', COUNT(*) FROM staff_raw WHERE phone_raw IS NULL
UNION ALL
SELECT 'manager_name', COUNT(*) FROM staff_raw WHERE manager_name IS NULL
UNION ALL
SELECT 'bonus', COUNT(*) FROM staff_raw WHERE bonus IS NULL
UNION ALL
SELECT 'termination_date_text', COUNT(*) FROM staff_raw
  WHERE termination_date_text IS NULL OR TRIM(termination_date_text) = 'N/A';
