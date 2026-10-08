SET SERVEROUTPUT ON;
BEGIN
    FOR emp IN (SELECT employee_id, monthly_salary
                FROM alyos_payroll_imports ORDER BY employee_id) LOOP
        IF emp.monthly_salary IS NULL OR emp.monthly_salary <= 0 THEN
            DBMS_OUTPUT.PUT_LINE(emp.employee_id || ': INVALID SALARY');
        ELSIF emp.monthly_salary < 150000 THEN
            DBMS_OUTPUT.PUT_LINE(emp.employee_id || ': REVIEW NEEDED');
        ELSE
            DBMS_OUTPUT.PUT_LINE(emp.employee_id || ': ACCEPTABLE');
        END IF;
    END LOOP;
END;
/
