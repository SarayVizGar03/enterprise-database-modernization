
-- ============================================================
-- Project: Enterprise Database Modernization
-- File: 03_validation_queries.sql
-- Database: Oracle
-- Description: Data validation and integrity checks
-- ============================================================


-- 1. Validate total records in each table

SELECT 'BRANCHES' AS TABLE_NAME, COUNT(*) AS TOTAL_RECORDS
FROM BRANCHES
UNION ALL
SELECT 'CUSTOMERS', COUNT(*)
FROM CUSTOMERS
UNION ALL
SELECT 'PRODUCTS', COUNT(*)
FROM PRODUCTS
UNION ALL
SELECT 'SALES_ORDERS', COUNT(*)
FROM SALES_ORDERS
UNION ALL
SELECT 'ORDER_ITEMS', COUNT(*)
FROM ORDER_ITEMS;


-- 2. Validate customers without email

SELECT
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME
FROM CUSTOMERS
WHERE EMAIL IS NULL;


-- 3. Validate duplicate customer emails

SELECT
    EMAIL,
    COUNT(*) AS TOTAL
FROM CUSTOMERS
GROUP BY EMAIL
HAVING COUNT(*) > 1;


-- 4. Validate orders without valid customers

SELECT
    SO.ORDER_ID,
    SO.CUSTOMER_ID
FROM SALES_ORDERS SO
LEFT JOIN CUSTOMERS C
    ON SO.CUSTOMER_ID = C.CUSTOMER_ID
WHERE C.CUSTOMER_ID IS NULL;


-- 5. Validate orders without valid branches

SELECT
    SO.ORDER_ID,
    SO.BRANCH_ID
FROM SALES_ORDERS SO
LEFT JOIN BRANCHES B
    ON SO.BRANCH_ID = B.BRANCH_ID
WHERE B.BRANCH_ID IS NULL;


-- 6. Validate order items without valid products

SELECT
    OI.ORDER_ITEM_ID,
    OI.PRODUCT_ID
FROM ORDER_ITEMS OI
LEFT JOIN PRODUCTS P
    ON OI.PRODUCT_ID = P.PRODUCT_ID
WHERE P.PRODUCT_ID IS NULL;


-- 7. Validate products with invalid prices

SELECT
    PRODUCT_ID,
    PRODUCT_NAME,
    PRICE
FROM PRODUCTS
WHERE PRICE <= 0;


-- 8. Validate order items with invalid quantities or prices

SELECT
    ORDER_ITEM_ID,
    QUANTITY,
    UNIT_PRICE
FROM ORDER_ITEMS
WHERE QUANTITY <= 0
   OR UNIT_PRICE <= 0;


-- 9. Validate sales order details

SELECT
    SO.ORDER_ID,
    C.FIRST_NAME || ' ' || C.LAST_NAME AS CUSTOMER_NAME,
    B.BRANCH_NAME,
    SO.ORDER_DATE
FROM SALES_ORDERS SO
INNER JOIN CUSTOMERS C
    ON SO.CUSTOMER_ID = C.CUSTOMER_ID
INNER JOIN BRANCHES B
    ON SO.BRANCH_ID = B.BRANCH_ID
ORDER BY SO.ORDER_DATE;


-- 10. Calculate total sales per order

SELECT
    SO.ORDER_ID,
    SUM(OI.QUANTITY * OI.UNIT_PRICE) AS ORDER_TOTAL
FROM SALES_ORDERS SO
INNER JOIN ORDER_ITEMS OI
    ON SO.ORDER_ID = OI.ORDER_ID
GROUP BY SO.ORDER_ID
ORDER BY SO.ORDER_ID;


-- 11. Validate products that have never been sold

SELECT
    P.PRODUCT_ID,
    P.PRODUCT_NAME
FROM PRODUCTS P
LEFT JOIN ORDER_ITEMS OI
    ON P.PRODUCT_ID = OI.PRODUCT_ID
WHERE OI.PRODUCT_ID IS NULL;


-- 12. Validate sales orders without details

SELECT
    SO.ORDER_ID,
    SO.ORDER_DATE
FROM SALES_ORDERS SO
LEFT JOIN ORDER_ITEMS OI
    ON SO.ORDER_ID = OI.ORDER_ID
WHERE OI.ORDER_ID IS NULL;


-- ============================================================
-- END OF VALIDATION QUERIES
-- ============================================================
