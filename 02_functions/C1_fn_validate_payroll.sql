CREATE OR REPLACE FUNCTION fn_validate_payroll (
    p_employee_id IN NUMBER,
    p_as_of_date IN DATE DEFAULT SYSDATE
) RETURN VARCHAR2
IS
    v_emp alyos_payroll_imports%ROWTYPE;
    v_reason VARCHAR2(100);
BEGIN
    IF p_as_of_date IS NULL THEN
        v_reason := 'assessment date is missing';
        GOTO rejected;
    END IF;

    SELECT * INTO v_emp FROM alyos_payroll_imports
    WHERE employee_id = p_employee_id;

    IF v_emp.employment_status <> 'ACTIVE' THEN
        v_reason := 'employee is inactive';
        GOTO rejected;
    END IF;
    IF v_emp.monthly_salary IS NULL OR v_emp.monthly_salary <= 0 THEN
        v_reason := 'salary must be greater than zero';
        GOTO rejected;
    END IF;
    IF v_emp.hire_date IS NULL THEN
        v_reason := 'hire date is missing';
        GOTO rejected;
    END IF;
    IF TRUNC(v_emp.hire_date) > TRUNC(p_as_of_date) THEN
        v_reason := 'hire date is in the future';
        GOTO rejected;
    END IF;
    IF fn_dept_name(v_emp.department_id) IS NULL THEN
        v_reason := 'department is missing or unknown';
        GOTO rejected;
    END IF;

    RETURN 'VALID';

    <<rejected>>
    RETURN 'INVALID: ' || v_reason;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'INVALID: payroll import not found';
END;
/
SHOW ERRORS FUNCTION fn_validate_payroll;
