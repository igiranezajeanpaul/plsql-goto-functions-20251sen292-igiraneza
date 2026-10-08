SET SERVEROUTPUT ON;
ALTER SESSION SET NLS_CALENDAR = 'GREGORIAN';
DECLARE
    v_count PLS_INTEGER := 0;
    PROCEDURE assert_number(p_label VARCHAR2, p_actual NUMBER, p_expected NUMBER) IS
    BEGIN
        IF p_actual IS NULL OR p_actual <> p_expected THEN
            RAISE_APPLICATION_ERROR(-20991, 'FAIL: ' || p_label);
        END IF;
        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE('PASS: ' || p_label);
    END;
    PROCEDURE assert_text(p_label VARCHAR2, p_actual VARCHAR2, p_expected VARCHAR2) IS
    BEGIN
        IF (p_actual IS NULL AND p_expected IS NOT NULL)
           OR (p_actual IS NOT NULL AND p_expected IS NULL)
           OR p_actual <> p_expected THEN
            RAISE_APPLICATION_ERROR(-20992, 'FAIL: ' || p_label);
        END IF;
        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE('PASS: ' || p_label);
    END;
    PROCEDURE expect_error(p_label VARCHAR2, p_sql VARCHAR2, p_code NUMBER) IS
        v_result NUMBER;
        v_caught BOOLEAN := FALSE;
    BEGIN
        BEGIN
            EXECUTE IMMEDIATE p_sql INTO v_result;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE <> p_code THEN RAISE; END IF;
                v_caught := TRUE;
        END;
        IF NOT v_caught THEN
            RAISE_APPLICATION_ERROR(-20993, 'FAIL: expected error: ' || p_label);
        END IF;
        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE('PASS: ' || p_label);
    END;
BEGIN
    assert_number('Annual 250000 RWF', fn_annual_salary(250000), 3000000);
    assert_number('Annual zero', fn_annual_salary(0), 0);
    assert_number('Annual decimal input', fn_annual_salary(123456.78), 1481481.36);
    expect_error('Annual negative', 'SELECT fn_annual_salary(-1) FROM dual', -20001);
    expect_error('Annual null', 'SELECT fn_annual_salary(NULL) FROM dual', -20001);
    assert_number('Exact anniversary', fn_years_of_service(DATE '2019-10-08', DATE '2026-10-08'), 7);
    assert_number('Before anniversary', fn_years_of_service(DATE '2019-10-09', DATE '2026-10-08'), 6);
    assert_number('Same day', fn_years_of_service(DATE '2026-10-08', DATE '2026-10-08'), 0);
    assert_number('Leap-day month-end convention', fn_years_of_service(DATE '2020-02-29', DATE '2021-02-28'), 1);
    expect_error('Missing hire date', q'[SELECT fn_years_of_service(NULL, DATE '2026-10-08') FROM dual]', -20002);
    expect_error('Missing as-of date', q'[SELECT fn_years_of_service(DATE '2020-01-01', NULL) FROM dual]', -20002);
    expect_error('Future hire date', q'[SELECT fn_years_of_service(DATE '2027-01-01', DATE '2026-10-08') FROM dual]', -20003);
    assert_number('Tax zero', fn_calculate_tax(0), 0);
    assert_number('Tax lower boundary', fn_calculate_tax(100000), 0);
    assert_number('Tax above lower boundary', fn_calculate_tax(100001), 0.10);
    assert_number('Tax middle band', fn_calculate_tax(250000), 15000);
    assert_number('Tax upper boundary', fn_calculate_tax(300000), 20000);
    assert_number('Tax above upper boundary', fn_calculate_tax(300001), 20000.20);
    assert_number('Tax high band', fn_calculate_tax(450000), 50000);
    expect_error('Tax negative', 'SELECT fn_calculate_tax(-1) FROM dual', -20004);
    expect_error('Tax null', 'SELECT fn_calculate_tax(NULL) FROM dual', -20004);
    assert_text('Known department', fn_dept_name(10), 'Imports and Procurement');
    assert_text('Unknown department', fn_dept_name(999), NULL);
    assert_text('Null department', fn_dept_name(NULL), NULL);
    DBMS_OUTPUT.PUT_LINE('Function tests passed: ' || v_count);
END;
/
