# Alyos Import and Distribution - PL/SQL Assignment III

**Name:** Igiraneza Jean Paul  
**Student ID:** 20251sen292  
**Course:** Database Development with PL/SQL (INSY 8311)

## Project overview

This project uses Alyos, an importer and distributor, to demonstrate PL/SQL GOTO statements, functions and exception handling. It classifies stock movements and checks incoming payroll records.

Employees, products and salary amounts are fictional examples. Money is expressed in Rwandan francs (RWF). The tax bands are classroom examples, not Rwanda's official tax rates.

## Tools and database environment

- **Database:** Oracle Database 21c
- **Application:** Oracle SQL Developer
- **Connection name:** Alyos assignment
- **Database user:** IGIRANEZA_PLSQLAUCA_20251SEN292
- **Pluggable database:** IG_PDB_20251SEN292
- **Tablespace:** USERS, with a 20 MB user quota

The project runs under the student account. SYS was used only for administrative setup and troubleshooting. Passwords are not included in this repository.

## Database tables

| Table | Purpose | Sample rows |
|---|---|---:|
| ALYOS_DEPARTMENTS | Stores department names | 4 |
| ALYOS_EMPLOYEES | Stores accepted employee records | 5 |
| ALYOS_PAYROLL_IMPORTS | Stores incoming records, including invalid test cases | 12 |
| ALYOS_PRODUCTS | Stores products and their units | 2 |
| ALYOS_STOCK_MOVEMENTS | Stores signed stock movements | 4 |

Employee records reference departments, and stock movements reference products. Payroll imports are kept separately so missing fields and unknown departments can be checked before acceptance. The project does not automatically transfer records or make payments.

## Assignment tasks

### Part A - GOTO statements

- **A1 - Number Classifier:** Classifies stored stock movements as positive, negative, zero or missing using GOTO.
- **A2 - Salary Review:** Uses GOTO to report invalid salaries, salaries needing review and acceptable salaries.
- **A3 - Illegal GOTO and Fix:** Demonstrates an illegal jump into an IF and corrects it by placing the label outside the IF.
- **A4 - Rewrite Without GOTO:** Replaces A2's jumps with IF, ELSIF and ELSE while keeping the same results.

### Part B - Functions

- **B1 - Annual Salary:** Returns monthly salary multiplied by 12.
- **B2 - Years of Service:** Returns completed service years between a hire date and an assessment date.
- **B3 - Tax Calculator:** Calculates monthly tax using fictional progressive bands.
- **B4 - Department Name:** Returns a department name, or NULL when the ID has no matching department.
- **B5 - Functions in SQL:** Calls the functions in a SELECT report showing all 12 payroll-import records.

### Part C - Combined task

- **C1 - Payroll Validator:** Uses conditions, GOTO, department lookup and exception handling to return VALID or a rejection reason.
- **C2 - Reflection:** Discusses the exercises, test results and problems solved in [docs/REFLECTION.md](docs/REFLECTION.md).

## Business rules

- Positive stock movements mean receipts; negative movements mean dispatches. Zero means no movement, while NULL means a missing quantity.
- A missing, zero or negative salary is invalid for payroll. A positive salary below 150,000 RWF needs review; 150,000 RWF or more is acceptable for salary review.
- Salary review and payroll eligibility are separate: a salary can need review while the record remains eligible for payroll.
- Annual base salary is monthly salary x 12. The calculation accepts zero, but rejects negative or missing inputs.
- Payroll eligibility requires an active status, a positive salary, a hire date no later than the assessment date and a known assigned department. C1 returns the first rejection reason.
- Reports and tests use **8 October 2026** as the assessment date. Service years use Oracle's MONTHS_BETWEEN calculation with the Gregorian calendar and its month-end convention.

Monthly tax is calculated as follows:

| Portion of monthly salary | Rate |
|---|---:|
| First 100,000 RWF | 0% |
| Next 200,000 RWF | 10% |
| Amount above 300,000 RWF | 20% |

For example, a monthly salary of 450,000 RWF gives annual base pay of 5,400,000 RWF, monthly tax of 50,000 RWF and monthly net pay of 400,000 RWF. Annual pay and tax are rounded to two decimal places.

## Folder structure

```text
00_setup/       Tables and sample data
01_goto/        A1-A4 scripts, including the separate A3 correction
02_functions/   B1-B4 and C1 functions
03_tests/       Function tests, B5 report and C1 tests
screenshots/    Execution evidence
docs/           Reflection
```

I reused my existing student account for this assignment.

## How to run

Use a student schema with CREATE TABLE and CREATE PROCEDURE privileges, plus a default application tablespace with sufficient quota. The environment above uses USERS. Check these settings before setup; USERS does not exist automatically in every PDB.

Open each file in SQL Developer, select the student connection and press **F5**. I ran the scripts individually in this order:

1. `00_setup/create_tables.sql` - create tables and load sample data once.
2. `01_goto/A1_number_classifier.sql`
3. `01_goto/A2_salary_review.sql`
4. `01_goto/A3_illegal_goto.sql` - deliberately produces PLS-00375.
5. `01_goto/A3_fixed_goto.sql` - run the corrected example successfully.
6. `01_goto/A4_rewrite_no_goto.sql`
7. `02_functions/B1_fn_annual_salary.sql`
8. `02_functions/B2_fn_years_of_service.sql`
9. `02_functions/B3_fn_calculate_tax.sql`
10. `02_functions/B4_fn_dept_name.sql`
11. `02_functions/C1_fn_validate_payroll.sql`
12. `03_tests/test_functions.sql`
13. `03_tests/B5_functions_in_select.sql`
14. `03_tests/test_validate_payroll.sql`

C1 must be created before B5 because the report calls it. The intentional A3 error is expected; other errors should be investigated before continuing.


## Verified results

The scripts were executed in SQL Developer and the output was reviewed:

- All five functions were valid, with no compilation errors reported.
- All **24 function tests passed**.
- All **15 payroll tests passed**.
- A1 produced the four expected classifications.
- A2 and A4 produced matching results for all 12 records.
- A3 produced the expected illegal-jump error, followed by a successful correction.
- B5 displayed all 12 records with their calculated values and validation messages.

A test can report PASS for an INVALID record when the function correctly rejects that record. The tests compare actual results with expected answers.

## Screenshot evidence

The required evidence files are:

- `A1_output.png`
- `A2_output.png`
- `A3_error_and_fix.png`
- `A4_output.png`
- `B5_select_output.png`
- `C1_output.png`

## Problems resolved

The student account initially lacked creation privileges. After these were granted, inserts failed because the tables used SYSTEM without sufficient quota. USERS did not exist in the PDB, so it was created and assigned as the user's default tablespace with a quota. The existing tables and their indexes were moved to USERS before the sample data was loaded successfully.

The [reflection](docs/REFLECTION.md) explains these issues and the SQL exercises in more detail.
