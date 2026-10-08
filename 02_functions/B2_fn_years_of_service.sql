CREATE OR REPLACE FUNCTION fn_years_of_service (
    p_hire_date IN DATE,
    p_as_of_date IN DATE DEFAULT SYSDATE
) RETURN NUMBER
IS
BEGIN
    IF p_hire_date IS NULL OR p_as_of_date IS NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'Both dates are required');
    END IF;
    IF TRUNC(p_hire_date) > TRUNC(p_as_of_date) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Hire date is after the assessment date');
    END IF;
    RETURN TRUNC(MONTHS_BETWEEN(TRUNC(p_as_of_date), TRUNC(p_hire_date)) / 12);
END;
/
SHOW ERRORS FUNCTION fn_years_of_service;
