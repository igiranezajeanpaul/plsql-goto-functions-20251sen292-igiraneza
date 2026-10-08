SET SERVEROUTPUT ON;
ALTER SESSION SET NLS_CALENDAR = 'GREGORIAN';
DECLARE
    v_count PLS_INTEGER := 0;
    PROCEDURE check_status(p_id NUMBER, p_expected VARCHAR2,
                           p_date DATE DEFAULT DATE '2026-10-08') IS
        v_actual VARCHAR2(200);
    BEGIN
        v_actual := fn_validate_payroll(p_id, p_date);
        IF v_actual IS NULL OR v_actual <> p_expected THEN
            RAISE_APPLICATION_ERROR(-20994,
                'FAIL employee ' || p_id || ': ' || NVL(v_actual, '(null)'));
        END IF;
        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE('PASS ' || NVL(TO_CHAR(p_id), '(null)') || ': ' || v_actual);
    END;
BEGIN
    check_status(101, 'VALID');
    check_status(102, 'VALID');
    check_status(103, 'VALID');
    check_status(104, 'VALID');
    check_status(105, 'INVALID: salary must be greater than zero');
    check_status(106, 'INVALID: salary must be greater than zero');
    check_status(107, 'INVALID: department is missing or unknown');
    check_status(108, 'INVALID: hire date is in the future');
    check_status(109, 'INVALID: employee is inactive');
    check_status(110, 'INVALID: salary must be greater than zero');
    check_status(111, 'INVALID: hire date is missing');
    check_status(112, 'INVALID: department is missing or unknown');
    check_status(999, 'INVALID: payroll import not found');
    check_status(NULL, 'INVALID: payroll import not found');
    check_status(101, 'INVALID: assessment date is missing', NULL);
    DBMS_OUTPUT.PUT_LINE('Payroll tests passed: ' || v_count);
END;
/
