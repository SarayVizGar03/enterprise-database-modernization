
-- =====================================================
-- Project: Enterprise Database Modernization
-- File: 02_insert_sample_data.sql
-- Description: Insert sample data into database tables
-- =====================================================

-- 1. Insert branches
INSERT INTO BRANCHES (
    BRANCH_ID,
    BRANCH_NAME,
    CITY,
    STATE
) VALUES (
    1,
    'Guadalajara Centro',
    'Guadalajara',
    'Jalisco'
);

INSERT INTO BRANCHES (
    BRANCH_ID,
    BRANCH_NAME,
    CITY,
    STATE
) VALUES (
    2,
    'Monterrey Norte',
    'Monterrey',
    'Nuevo Leon'
);

-- 2. Insert customers
INSERT INTO CUSTOMERS (
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL
) VALUES (
    1,
    'Ana',
    'Garcia',
    'ana.garcia@example.com'
);

INSERT INTO CUSTOMERS (
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL
) VALUES (
    2,
    'Carlos',
    'Lopez',
    'carlos.lopez@example.com'
);

-- 3. Insert products
INSERT INTO PRODUCTS (
    PRODUCT_ID,
    PRODUCT_NAME,
    PRICE
) VALUES (
    1,
    'Laptop',
    15000.00
);

INSERT INTO PRODUCTS (
    PRODUCT_ID,
    PRODUCT_NAME,
    PRICE
) VALUES (
    2,
    'Smartphone',
    8500.00
);

INSERT INTO PRODUCTS (
    PRODUCT_ID,
    PRODUCT_NAME,
    PRICE
) VALUES (
    3,
    'Monitor',
    4200.00
);

-- 4. Insert sales orders
INSERT INTO SALES_ORDERS (
    ORDER_ID,
    CUSTOMER_ID,
    BRANCH_ID,
    ORDER_DATE
) VALUES (
    1,
    1,
    1,
    DATE '2026-01-15'
);

INSERT INTO SALES_ORDERS (
    ORDER_ID,
    CUSTOMER_ID,
    BRANCH_ID,
    ORDER_DATE
) VALUES (
    2,
    2,
    2,
    DATE '2026-01-16'
);

-- 5. Insert order items
INSERT INTO ORDER_ITEMS (
    ORDER_ITEM_ID,
    ORDER_ID,
    PRODUCT_ID,
    QUANTITY,
    UNIT_PRICE
) VALUES (
    1,
    1,
    1,
    1,
    15000.00
);

INSERT INTO ORDER_ITEMS (
    ORDER_ITEM_ID,
    ORDER_ID,
    PRODUCT_ID,
    QUANTITY,
    UNIT_PRICE
) VALUES (
    2,
    1,
    3,
    2,
    4200.00
);

INSERT INTO ORDER_ITEMS (
    ORDER_ITEM_ID,
    ORDER_ID,
    PRODUCT_ID,
    QUANTITY,
    UNIT_PRICE
) VALUES (
    3,
    2,
    2,
    1,
    8500.00
);

-- Save all changes
COMMIT;
