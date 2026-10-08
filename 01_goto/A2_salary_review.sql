SET SERVEROUTPUT ON;
BEGIN
    FOR emp IN (SELECT employee_id, monthly_salary
                FROM alyos_payroll_imports ORDER BY employee_id) LOOP
        IF emp.monthly_salary IS NULL OR emp.monthly_salary <= 0 THEN
            GOTO invalid_salary;
        ELSIF emp.monthly_salary < 150000 THEN
            GOTO review_needed;
        ELSE
            GOTO acceptable;
        END IF;

        <<invalid_salary>>
        DBMS_OUTPUT.PUT_LINE(emp.employee_id || ': INVALID SALARY');
        GOTO finished_employee;
        <<review_needed>>
        DBMS_OUTPUT.PUT_LINE(emp.employee_id || ': REVIEW NEEDED');
        GOTO finished_employee;
        <<acceptable>>
        DBMS_OUTPUT.PUT_LINE(emp.employee_id || ': ACCEPTABLE');
        <<finished_employee>>
        NULL;
    END LOOP;
END;
/
