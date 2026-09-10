-- ============================================================
-- FUNCTIONS & NULLS PRACTICE DATASET (T-SQL / SQL Server)
-- Deliberately messy data: inconsistent casing, stray spaces,
-- mixed date formats, currency symbols in text, and NULLs
-- scattered realistically across both tables.
-- ============================================================

DROP TABLE IF EXISTS staff_raw;
DROP TABLE IF EXISTS sales;

-- ------------------------------------------------------------
-- STAFF_RAW — messy HR export, as if dumped straight from an
-- old system. Everything here is TEXT on purpose, even things
-- that "should" be numbers or dates, so you practice CAST/
-- CONVERT/ISDATE/TRY_CONVERT cleanup.
-- ------------------------------------------------------------
CREATE TABLE staff_raw (
    staff_id             INT PRIMARY KEY,
    full_name            VARCHAR(100),
    email                VARCHAR(100),
    phone_raw            VARCHAR(30),
    hire_date_text       VARCHAR(30),
    termination_date_text VARCHAR(30),
    salary_text          VARCHAR(30),
    department_raw       VARCHAR(50),
    manager_name         VARCHAR(100),
    bonus                DECIMAL(10,2)
);

INSERT INTO staff_raw VALUES
(1,  '  john DOE  ',        'JOHN.DOE@email.com',    '(080) 123-4567', '2020-01-15', NULL,          '$45,000',     ' sales ',        'Amaka Obi',     2500.00),
(2,  'mary  ann SMITH',     'mary.smith@email.com ', '080-234-5678',   '15/03/2019', NULL,          '52000',       'MARKETING',      'Tunde Bakare',  NULL),
(3,  'CHUKWUDI okafor',     NULL,                     '0812345690',     'Jan 5, 2021', NULL,          'NGN 38,000',  'IT Support',     NULL,            1000.00),
(4,  'grace   Umeh',        'grace.umeh@EMAIL.com',  NULL,             '2019.11.02', NULL,          '$60,500',     'Sales',          'Amaka Obi',     NULL),
(5,  'Peter ADEOYE',        'peter.adeoye@email.com','(070) 987-6543', '03-22-2022', NULL,          '41000',       ' it support',    'Chuka Obi',     500.00),
(6,  '  ngozi Adeyemi',     'ngozi.a@email.com',     '080 111 2233',   'not a date', NULL,          '$47,250',     'MARKETING ',     'Tunde Bakare',  NULL),
(7,  'FEMI okoro',          'femi.okoro@email.com',  NULL,             '2018-07-30', '2023-05-01',  '55000',       'Sales',          NULL,            NULL),
(8,  'blessing NWOSU',      NULL,                     '0803334455',    '30/12/2020', NULL,          'NGN 62,000',  'Customer Support','Ruth Ibe',     1500.00),
(9,  'Yusuf  DANLADI',      'yusuf.d@email.com',     '(081) 222-3344', 'February 14, 2017', NULL,   '$39,900',     ' it support ',   'Chuka Obi',     NULL),
(10, 'KELECHI aniagor',     'kelechi.a@email.com ',  '0906667788',     'N/A',        NULL,          '48000',       'Marketing',      'Tunde Bakare',  750.00),
(11, 'halima  SANI',        'halima.sani@email.com', NULL,             '2021-09-09', NULL,          '$50,000',     'sales',          'Amaka Obi',     NULL),
(12, 'David   Eze',         'david.eze@EMAIL.com',   '080-555-1122',   '12/1/2016', '2022-12-31',   '58000',       'IT Support',     NULL,            NULL),
(13, 'Amina yusuf',         NULL,                     '0817778899',    '2022-06-18', NULL,          '$36,750',     'Customer support','Ruth Ibe',     NULL),
(14, 'john ATTAH',          'john.attah@email.com',  '(090) 444-5566', '18-Aug-2015', NULL,          '65000',       'Sales ',         'Amaka Obi',     3000.00),
(15, '  Ruth ibe',          'ruth.ibe@email.com',    NULL,             '2020-02-29', NULL,          '$44,300',     'customer support',NULL,           NULL);

-- ------------------------------------------------------------
-- SALES — transactional data with real dates (for date-math
-- practice) plus messy region text and scattered NULLs.
-- ------------------------------------------------------------
CREATE TABLE sales (
    sale_id       INT PRIMARY KEY,
    customer_name VARCHAR(100),
    product_name  VARCHAR(100),
    sale_date     DATE,
    ship_date     DATE,
    amount        DECIMAL(10,2),
    discount_pct  DECIMAL(5,2),
    region        VARCHAR(50),
    notes         VARCHAR(200)
);

INSERT INTO sales VALUES
(1,  'Amaka Obi',       'Wireless Mouse',      '2024-01-05', '2024-01-08', 30.00,  0.00,  'lagos',       NULL),
(2,  'Tunde Bakare',    'Office Chair',        '2024-01-20', '2024-01-25', 120.00, 10.00, 'ABUJA',       'Bulk order'),
(3,  'Chioma Eze',      'Bluetooth Speaker',   '2024-02-01', NULL,         45.00,  NULL,  'Lagos ',      'Awaiting shipment'),
(4,  'Ibrahim Musa',    'Standing Desk',       '2024-02-14', '2024-02-20', 250.00, 15.00, ' kano',       NULL),
(5,  'Ngozi Adeyemi',   'Desk Lamp',           '2024-03-01', '2024-03-02', 25.00,  0.00,  'Ibadan',      NULL),
(6,  'Femi Okoro',      'Laptop Stand',        '2024-03-15', '2024-03-19', 30.00,  NULL,  'lagos',       NULL),
(7,  'Blessing Nwosu',  'Mechanical Keyboard', '2024-03-22', '2024-03-24', 60.00,  5.00,  'Enugu',       NULL),
(8,  'Yusuf Danladi',   'Yoga Mat',            '2024-04-02', '2024-04-10', 20.00,  0.00,  'KANO',        'Delayed shipment'),
(9,  'Grace Umeh',      'Water Bottle',        '2024-04-10', '2024-04-11', 14.00,  NULL,  'Abuja',       NULL),
(10, 'Kelechi Aniagor', 'Ceramic Mug',         '2024-04-18', '2024-04-19', 10.00,  0.00,  ' lagos ',     NULL),
(11, 'Halima Sani',     'Notebook Set',        '2024-05-01', '2024-05-03', 8.00,   NULL,  'Kaduna',      NULL),
(12, 'Peter Adeoye',    'Fountain Pen',        '2024-05-09', '2024-05-11', 12.00,  0.00,  'ibadan',      NULL),
(13, 'Amaka Obi',       'Scented Candle',      '2024-05-20', '2024-05-22', 9.00,   20.00, 'Lagos',       'Repeat customer'),
(14, 'Tunde Bakare',    'Wireless Mouse',      '2024-06-01', NULL,         15.00,  NULL,  'Abuja',       'Cancelled - not shipped'),
(15, 'Chioma Eze',      'Office Chair',        '2024-06-15', '2024-06-20', 120.00, 10.00, 'LAGOS',       NULL),
(16, 'Ibrahim Musa',    'Bluetooth Speaker',   '2024-07-01', '2024-07-05', 45.00,  0.00,  'kano',        NULL),
(17, 'Ngozi Adeyemi',   'Standing Desk',       '2024-07-14', '2024-07-30', 250.00, 25.00, 'Ibadan ',     'Long delay'),
(18, 'Femi Okoro',      'Desk Lamp',           '2024-08-01', '2024-08-02', 25.00,  NULL,  ' Lagos',      NULL),
(19, 'Blessing Nwosu',  'Laptop Stand',        '2024-08-19', '2024-08-21', 30.00,  0.00,  'enugu',       NULL),
(20, 'Yusuf Danladi',   'Mechanical Keyboard', '2024-09-02', '2024-09-06', 60.00,  10.00, 'Kano',        NULL);
