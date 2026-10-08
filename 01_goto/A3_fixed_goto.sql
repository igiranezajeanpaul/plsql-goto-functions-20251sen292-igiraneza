SET SERVEROUTPUT ON;
BEGIN
    IF TRUE THEN
        GOTO report_result;
    END IF;
    <<report_result>>
    DBMS_OUTPUT.PUT_LINE('Fixed: destination is outside the IF');
END;
/
