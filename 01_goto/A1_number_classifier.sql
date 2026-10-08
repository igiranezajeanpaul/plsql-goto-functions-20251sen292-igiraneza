SET SERVEROUTPUT ON;
BEGIN
    FOR movement IN (
        SELECT m.movement_id, p.product_name, m.quantity_change
        FROM alyos_stock_movements m
        JOIN alyos_products p ON p.product_id = m.product_id
        ORDER BY m.movement_id
    ) LOOP
        DBMS_OUTPUT.PUT(movement.movement_id || ' - ' || movement.product_name || ': ');
        IF movement.quantity_change IS NULL THEN
            GOTO missing_quantity;
        ELSIF movement.quantity_change > 0 THEN
            GOTO received;
        ELSIF movement.quantity_change < 0 THEN
            GOTO dispatched;
        ELSE
            GOTO no_movement;
        END IF;
        <<received>>
        DBMS_OUTPUT.PUT_LINE('Positive: stock received');
        GOTO finished;
        <<dispatched>>
        DBMS_OUTPUT.PUT_LINE('Negative: stock dispatched');
        GOTO finished;
        <<no_movement>>
        DBMS_OUTPUT.PUT_LINE('Zero: no stock movement');
        GOTO finished;
        <<missing_quantity>>
        DBMS_OUTPUT.PUT_LINE('Invalid: quantity is missing');
        <<finished>>
        NULL;
    END LOOP;
END;
/
