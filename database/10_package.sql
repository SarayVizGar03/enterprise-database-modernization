
-- =====================================================
-- 10_packages.sql
-- Project: Enterprise Database Modernization
-- Purpose: Create PL/SQL packages
-- =====================================================


-- 1. Create package specification

CREATE OR REPLACE PACKAGE PKG_ORDER_MANAGEMENT AS

    -- Register a new customer
    PROCEDURE REGISTER_CUSTOMER (
        P_CUSTOMER_NAME IN CUSTOMERS.CUSTOMER_NAME%TYPE,
        P_FIRST_NAME    IN CUSTOMERS.FIRST_NAME%TYPE,
        P_LAST_NAME     IN CUSTOMERS.LAST_NAME%TYPE,
        P_EMAIL         IN CUSTOMERS.EMAIL%TYPE
    );

    -- Update order status
    PROCEDURE UPDATE_ORDER_STATUS (
        P_ORDER_ID IN SALES_ORDERS.ORDER_ID%TYPE,
        P_STATUS   IN SALES_ORDERS.STATUS%TYPE
    );

    -- Calculate order total
    FUNCTION GET_ORDER_TOTAL (
        P_ORDER_ID IN SALES_ORDERS.ORDER_ID%TYPE
    ) RETURN NUMBER;

    -- Count customer orders
    FUNCTION GET_CUSTOMER_ORDER_COUNT (
        P_CUSTOMER_ID IN CUSTOMERS.CUSTOMER_ID%TYPE
    ) RETURN NUMBER;

END PKG_ORDER_MANAGEMENT;
/


-- 2. Create package body

CREATE OR REPLACE PACKAGE BODY PKG_ORDER_MANAGEMENT AS

    PROCEDURE REGISTER_CUSTOMER (
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
            RAISE_APPLICATION_ERROR(
                -20010,
                'Customer email already exists.'
            );
    END REGISTER_CUSTOMER;


    PROCEDURE UPDATE_ORDER_STATUS (
        P_ORDER_ID IN SALES_ORDERS.ORDER_ID%TYPE,
        P_STATUS   IN SALES_ORDERS.STATUS%TYPE
    )
    AS
    BEGIN
        IF P_STATUS NOT IN ('PENDING', 'COMPLETED', 'CANCELLED') THEN
            RAISE_APPLICATION_ERROR(-20011, 'Invalid order status.');
        END IF;

        UPDATE SALES_ORDERS
        SET STATUS = P_STATUS
        WHERE ORDER_ID = P_ORDER_ID;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20012, 'Order not found.');
        END IF;

        DBMS_OUTPUT.PUT_LINE('Order status updated successfully.');
    END UPDATE_ORDER_STATUS;


    FUNCTION GET_ORDER_TOTAL (
        P_ORDER_ID IN SALES_ORDERS.ORDER_ID%TYPE
    )
    RETURN NUMBER
    AS
        V_TOTAL NUMBER(14,2);
    BEGIN
        SELECT NVL(SUM(QUANTITY * UNIT_PRICE), 0)
        INTO V_TOTAL
        FROM ORDER_ITEMS
        WHERE ORDER_ID = P_ORDER_ID;

        RETURN V_TOTAL;
    END GET_ORDER_TOTAL;


    FUNCTION GET_CUSTOMER_ORDER_COUNT (
        P_CUSTOMER_ID IN CUSTOMERS.CUSTOMER_ID%TYPE
    )
    RETURN NUMBER
    AS
        V_TOTAL_ORDERS NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO V_TOTAL_ORDERS
        FROM SALES_ORDERS
        WHERE CUSTOMER_ID = P_CUSTOMER_ID;

        RETURN V_TOTAL_ORDERS;
    END GET_CUSTOMER_ORDER_COUNT;

END PKG_ORDER_MANAGEMENT;
/
 

-- 3. Validate package objects

SELECT
    OBJECT_NAME,
    OBJECT_TYPE,
    STATUS
FROM USER_OBJECTS
WHERE OBJECT_NAME = 'PKG_ORDER_MANAGEMENT'
ORDER BY OBJECT_TYPE;


-- 4. Review compilation errors

SELECT
    NAME,
    TYPE,
    LINE,
    POSITION,
    TEXT
FROM USER_ERRORS
WHERE NAME = 'PKG_ORDER_MANAGEMENT'
ORDER BY TYPE, SEQUENCE;
