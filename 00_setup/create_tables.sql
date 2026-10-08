CREATE TABLE alyos_departments (
    department_id NUMBER(4) CONSTRAINT alyos_dept_pk PRIMARY KEY,
    department_name VARCHAR2(60) NOT NULL
);

CREATE TABLE alyos_employees (
    employee_id NUMBER(6) CONSTRAINT alyos_emp_pk PRIMARY KEY,
    employee_name VARCHAR2(80) NOT NULL,
    department_id NUMBER(4) NOT NULL,
    hire_date DATE NOT NULL,
    monthly_salary NUMBER(12,2) NOT NULL,
    employment_status VARCHAR2(10) NOT NULL,
    CONSTRAINT alyos_emp_dept_fk FOREIGN KEY (department_id)
        REFERENCES alyos_departments(department_id),
    CONSTRAINT alyos_emp_salary_ck CHECK (monthly_salary > 0),
    CONSTRAINT alyos_emp_status_ck CHECK (employment_status IN ('ACTIVE', 'INACTIVE'))
);

CREATE TABLE alyos_payroll_imports (
    employee_id NUMBER(6) CONSTRAINT alyos_import_pk PRIMARY KEY,
    employee_name VARCHAR2(80) NOT NULL,
    department_id NUMBER(4),
    hire_date DATE,
    monthly_salary NUMBER(12,2),
    employment_status VARCHAR2(10) NOT NULL,
    CONSTRAINT alyos_import_status_ck CHECK (employment_status IN ('ACTIVE', 'INACTIVE'))
);

CREATE TABLE alyos_products (
    product_id NUMBER(6) CONSTRAINT alyos_product_pk PRIMARY KEY,
    product_name VARCHAR2(80) NOT NULL,
    unit_name VARCHAR2(20) NOT NULL
);

CREATE TABLE alyos_stock_movements (
    movement_id NUMBER(6) CONSTRAINT alyos_movement_pk PRIMARY KEY,
    product_id NUMBER(6) NOT NULL,
    movement_date DATE NOT NULL,
    quantity_change NUMBER(10),
    CONSTRAINT alyos_movement_product_fk FOREIGN KEY (product_id)
        REFERENCES alyos_products(product_id)
);

INSERT INTO alyos_departments VALUES (10, 'Imports and Procurement');
INSERT INTO alyos_departments VALUES (20, 'Warehouse and Logistics');
INSERT INTO alyos_departments VALUES (30, 'Sales and Distribution');
INSERT INTO alyos_departments VALUES (40, 'Finance and Administration');


INSERT INTO alyos_payroll_imports VALUES (101, 'Aline', 10, DATE '2020-03-15', 250000, 'ACTIVE');
INSERT INTO alyos_payroll_imports VALUES (102, 'Brian', 20, DATE '2023-07-01', 149999, 'ACTIVE');
INSERT INTO alyos_payroll_imports VALUES (103, 'Chantal', 30, DATE '2019-10-08', 450000, 'ACTIVE');
INSERT INTO alyos_payroll_imports VALUES (104, 'David', 40, DATE '2024-01-10', 150000, 'ACTIVE');
INSERT INTO alyos_payroll_imports VALUES (105, 'Esther', 20, DATE '2025-02-01', 0, 'ACTIVE');
INSERT INTO alyos_payroll_imports VALUES (106, 'Felix', 30, DATE '2025-05-10', -5000, 'ACTIVE');
INSERT INTO alyos_payroll_imports VALUES (107, 'Grace', NULL, DATE '2022-09-01', 220000, 'ACTIVE');
INSERT INTO alyos_payroll_imports VALUES (108, 'Henry', 10, DATE '2027-01-01', 300000, 'ACTIVE');
INSERT INTO alyos_payroll_imports VALUES (109, 'Irene', 40, DATE '2020-04-01', 320000, 'INACTIVE');
INSERT INTO alyos_payroll_imports VALUES (110, 'Joel', 20, DATE '2024-02-01', NULL, 'ACTIVE');
INSERT INTO alyos_payroll_imports VALUES (111, 'Kezia', 30, NULL, 200000, 'ACTIVE');
INSERT INTO alyos_payroll_imports VALUES (112, 'Lionel', 99, DATE '2022-01-01', 280000, 'ACTIVE');


INSERT INTO alyos_employees
    SELECT * FROM alyos_payroll_imports WHERE employee_id IN (101, 102, 103, 104, 109);

INSERT INTO alyos_products VALUES (1, 'Imported cooking oil', 'carton');
INSERT INTO alyos_products VALUES (2, 'Imported rice', 'bag');
INSERT INTO alyos_stock_movements VALUES (1, 1, DATE '2026-10-01', 50);
INSERT INTO alyos_stock_movements VALUES (2, 1, DATE '2026-10-02', -20);
INSERT INTO alyos_stock_movements VALUES (3, 2, DATE '2026-10-03', 0);
INSERT INTO alyos_stock_movements VALUES (4, 2, DATE '2026-10-04', NULL);
COMMIT;
