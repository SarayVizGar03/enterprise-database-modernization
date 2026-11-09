
-- =====================================================
-- 08_procedures.sql
-- Project: Enterprise Database Modernization
-- Purpose: Create stored procedures
-- =====================================================


-- 1. Procedure: Register a new customer

CREATE OR REPLACE PROCEDURE SP_REGISTER_CUSTOMER (
    P_CUSTOMER_NAME IN CUSTOMERS.CUSTOMER_NAME%TYPE,
    P_FIRST_NAME    IN CUSTOMERS.FIRST_NAME%TYPE,
    P_LAST_NAME     IN CUSTOMERS.LAST_NAME%TYPE,
    P_EMAIL         IN CUSTOMERS.EMAIL%TYPE
)
AS
BEGIN
    INSERT INTO CUSTOMERS (
        CUSTOMER_NAME,
        FIRST_NAME,
        LAST_NAME,
        EMAIL
    )
    VALUES (
        P_CUSTOMER_NAME,
        P_FIRST_NAME,
        P_LAST_NAME,
        P_EMAIL
    );

    DBMS_OUTPUT.PUT_LINE('Customer registered successfully.');

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Error: Customer email already exists.');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error registering customer: ' || SQLERRM);
        RAISE;
END SP_REGISTER_CUSTOMER;
/


-- 2. Procedure: Update order status

CREATE OR REPLACE PROCEDURE SP_UPDATE_ORDER_STATUS (
    P_ORDER_ID IN SALES_ORDERS.ORDER_ID%TYPE,
    P_STATUS   IN SALES_ORDERS.STATUS%TYPE
)
AS
BEGIN
    IF P_STATUS NOT IN ('PENDING', 'COMPLETED', 'CANCELLED') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid order status.');
    END IF;

    UPDATE SALES_ORDERS
    SET STATUS = P_STATUS
    WHERE ORDER_ID = P_ORDER_ID;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Order not found.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Order status updated successfully.');

END SP_UPDATE_ORDER_STATUS;
/


-- 3. Procedure: Get orders by customer

CREATE OR REPLACE PROCEDURE SP_GET_CUSTOMER_ORDERS (
    P_CUSTOMER_ID IN SALES_ORDERS.CUSTOMER_ID%TYPE
)
AS
BEGIN
    FOR REC IN (
        SELECT
            ORDER_ID,
            ORDER_DATE,
            STATUS
        FROM SALES_ORDERS
        WHERE CUSTOMER_ID = P_CUSTOMER_ID
        ORDER BY ORDER_DATE
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Order: ' || REC.ORDER_ID ||
            ' | Date: ' || TO_CHAR(REC.ORDER_DATE, 'YYYY-MM-DD') ||
            ' | Status: ' || REC.STATUS
        );
    END LOOP;

END SP_GET_CUSTOMER_ORDERS;
/


-- 4. Procedure: Calculate total sales by order

CREATE OR REPLACE PROCEDURE SP_GET_ORDER_TOTAL (
    P_ORDER_ID IN SALES_ORDERS.ORDER_ID%TYPE
)
AS
    V_TOTAL NUMBER(14,2);
BEGIN
    SELECT NVL(SUM(QUANTITY * UNIT_PRICE), 0)
    INTO V_TOTAL
    FROM ORDER_ITEMS
    WHERE ORDER_ID = P_ORDER_ID;

    DBMS_OUTPUT.PUT_LINE(
        'Order ID: ' || P_ORDER_ID ||
        ' | Total: ' || TO_CHAR(V_TOTAL, 'FM9999999990.00')
    );

END SP_GET_ORDER_TOTAL;
/


-- 5. Validate stored procedures

SELECT
    OBJECT_NAME,
    STATUS
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'PROCEDURE'
AND OBJECT_NAME IN (
    'SP_REGISTER_CUSTOMER',
    'SP_UPDATE_ORDER_STATUS',
    'SP_GET_CUSTOMER_ORDERS',
    'SP_GET_ORDER_TOTAL'
)
ORDER BY OBJECT_NAME;


-- 6. Review compilation errors

SELECT
    NAME,
    TYPE,
    LINE,
    POSITION,
    TEXT
FROM USER_ERRORS
WHERE TYPE = 'PROCEDURE'
AND NAME IN (
    'SP_REGISTER_CUSTOMER',
    'SP_UPDATE_ORDER_STATUS',
    'SP_GET_CUSTOMER_ORDERS',
    'SP_GET_ORDER_TOTAL'
)
ORDER BY NAME, SEQUENCE;
