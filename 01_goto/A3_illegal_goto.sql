SET SERVEROUTPUT ON;
BEGIN
    GOTO inside_if;
    IF TRUE THEN
        <<inside_if>>
        DBMS_OUTPUT.PUT_LINE('This block cannot compile');
    END IF;
END;
/
