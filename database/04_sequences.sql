-- =====================================================
-- 04_sequences.sql
-- Project: Enterprise Database Modernization
-- Purpose: Create and test database sequences
-- =====================================================


-- 1. Create sequence for migration audit records

CREATE SEQUENCE SEQ_MIGRATION_AUDIT
START WITH 1
INCREMENT BY 1
MINVALUE 1
NOCACHE
NOCYCLE;


-- 2. Generate the next sequence value

SELECT SEQ_MIGRATION_AUDIT.NEXTVAL AS GENERATED_ID
FROM DUAL;


-- 3. Retrieve the current sequence value

SELECT SEQ_MIGRATION_AUDIT.CURRVAL AS CURRENT_ID
FROM DUAL;


-- 4. Generate multiple consecutive values

SELECT SEQ_MIGRATION_AUDIT.NEXTVAL AS GENERATED_ID
FROM DUAL;

SELECT SEQ_MIGRATION_AUDIT.NEXTVAL AS GENERATED_ID
FROM DUAL;

SELECT SEQ_MIGRATION_AUDIT.NEXTVAL AS GENERATED_ID
FROM DUAL;


-- 5. Validate sequence configuration

SELECT
    SEQUENCE_NAME,
    MIN_VALUE,
    INCREMENT_BY,
    CYCLE_FLAG,
    CACHE_SIZE
FROM USER_SEQUENCES
WHERE SEQUENCE_NAME = 'SEQ_MIGRATION_AUDIT';