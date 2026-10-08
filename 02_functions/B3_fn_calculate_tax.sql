CREATE OR REPLACE FUNCTION fn_calculate_tax (
    p_monthly_salary IN NUMBER
) RETURN NUMBER
IS
    v_tax NUMBER;
BEGIN
    IF p_monthly_salary IS NULL OR p_monthly_salary < 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Tax input must be non-negative and not null');
    END IF;
    IF p_monthly_salary <= 100000 THEN
        v_tax := 0;
    ELSIF p_monthly_salary <= 300000 THEN
        v_tax := (p_monthly_salary - 100000) * 0.10;
    ELSE
        v_tax := 20000 + (p_monthly_salary - 300000) * 0.20;
    END IF;
    RETURN ROUND(v_tax, 2);
END;
/
SHOW ERRORS FUNCTION fn_calculate_tax;
