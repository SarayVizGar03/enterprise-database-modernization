
-- =====================================================
-- 06_indexes.sql
-- Project: Enterprise Database Modernization
-- Purpose: Create indexes to improve query performance
-- =====================================================


-- 1. Index for searching customers by email

CREATE INDEX IDX_CUSTOMERS_EMAIL
ON CUSTOMERS (EMAIL);


-- 2. Index for searching customers by name

CREATE INDEX IDX_CUSTOMERS_NAME
ON CUSTOMERS (CUSTOMER_NAME);


-- 3. Index for searching orders by customer

CREATE INDEX IDX_ORDERS_CUSTOMER
ON SALES_ORDERS (CUSTOMER_ID);


-- 4. Index for searching orders by branch

CREATE INDEX IDX_ORDERS_BRANCH
ON SALES_ORDERS (BRANCH_ID);


-- 5. Index for filtering orders by date

CREATE INDEX IDX_ORDERS_DATE
ON SALES_ORDERS (ORDER_DATE);


-- 6. Index for searching order items by product

CREATE INDEX IDX_ORDER_ITEMS_PRODUCT
ON ORDER_ITEMS (PRODUCT_ID);


-- 7. Index for searching products by category

CREATE INDEX IDX_PRODUCTS_CATEGORY
ON PRODUCTS (CATEGORY);


-- 8. Validate created indexes

SELECT
    INDEX_NAME,
    TABLE_NAME,
    UNIQUENESS,
    STATUS
FROM USER_INDEXES
WHERE INDEX_NAME IN (
    'IDX_CUSTOMERS_EMAIL',
    'IDX_CUSTOMERS_NAME',
    'IDX_ORDERS_CUSTOMER',
    'IDX_ORDERS_BRANCH',
    'IDX_ORDERS_DATE',
    'IDX_ORDER_ITEMS_PRODUCT',
    'IDX_PRODUCTS_CATEGORY'
)
ORDER BY TABLE_NAME, INDEX_NAME;


-- 9. Review indexed columns

SELECT
    INDEX_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_POSITION
FROM USER_IND_COLUMNS
WHERE INDEX_NAME IN (
    'IDX_CUSTOMERS_EMAIL',
    'IDX_CUSTOMERS_NAME',
    'IDX_ORDERS_CUSTOMER',
    'IDX_ORDERS_BRANCH',
    'IDX_ORDERS_DATE',
    'IDX_ORDER_ITEMS_PRODUCT',
    'IDX_PRODUCTS_CATEGORY'
)
ORDER BY TABLE_NAME, INDEX_NAME, COLUMN_POSITION;
