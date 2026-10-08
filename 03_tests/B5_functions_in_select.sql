PROMPT All monetary amounts are in Rwandan francs (RWF).
SET LINESIZE 220;
SET PAGESIZE 100;
ALTER SESSION SET NLS_CALENDAR = 'GREGORIAN';
COLUMN employee_name FORMAT A14;
COLUMN department FORMAT A28;
COLUMN payroll_status FORMAT A55;
COLUMN annual_salary FORMAT 9999999990.00;
COLUMN monthly_tax FORMAT 999999990.00;
COLUMN monthly_net FORMAT 999999990.00;

-- CASE guards stop invalid imported values reaching numeric/date functions.
-- We show all employees rather than silently hiding rejected records.
SELECT employee_id, employee_name,
       NVL(fn_dept_name(department_id), 'Unassigned') AS department,
       CASE WHEN monthly_salary >= 0
            THEN fn_annual_salary(monthly_salary) END AS annual_salary,
       CASE WHEN hire_date IS NOT NULL
                 AND TRUNC(hire_date) <= DATE '2026-10-08'
            THEN fn_years_of_service(hire_date, DATE '2026-10-08') END AS years_service,
       CASE WHEN monthly_salary >= 0
            THEN fn_calculate_tax(monthly_salary) END AS monthly_tax,
       CASE WHEN monthly_salary >= 0
            THEN monthly_salary - fn_calculate_tax(monthly_salary) END AS monthly_net,
       fn_validate_payroll(employee_id, DATE '2026-10-08') AS payroll_status
FROM alyos_payroll_imports
ORDER BY employee_id;
