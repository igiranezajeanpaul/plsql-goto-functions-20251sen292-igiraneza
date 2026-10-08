CREATE OR REPLACE FUNCTION fn_dept_name (
    p_department_id IN NUMBER
) RETURN VARCHAR2
IS
    v_name alyos_departments.department_name%TYPE;
BEGIN
    SELECT department_name INTO v_name
    FROM alyos_departments
    WHERE department_id = p_department_id;
    RETURN v_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL; -- Caller decides how to display or reject missing data.
END;
/
SHOW ERRORS FUNCTION fn_dept_name;
