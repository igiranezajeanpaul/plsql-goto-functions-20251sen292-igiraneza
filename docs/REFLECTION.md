# Reflection

**Name:** Igiraneza Jean Paul  
**Student ID:** 20251sen292  

## My project

I used Alyos, as an importer and distributor, for my example. The project classifies stock movements and checks payroll records. I used fictional employees and salaries in Rwandan francs (RWF). The tax rates are examples for this assignment, not Rwanda's official tax rates.

I ran the scripts individually in Oracle SQL Developer so I could examine each result before moving to the next task.

## GOTO statements

- **A1 - Number Classifier:** I used GOTO to classify stock movements as positive, negative, zero or missing. Each jump selects the correct message.
- **A2 - Salary Review:** I used GOTO to identify invalid salaries, salaries needing review and acceptable salaries. The program prints the result without changing the salary.
- **A3 - Illegal GOTO and Fix:** I saw that jumping into an IF from outside causes an error. Moving the label outside the IF made the jump legal.
- **A4 - Rewrite Without GOTO:** I used IF, ELSIF and ELSE to produce the same results as A2. This version is easier to follow because each condition is beside its action.

## Functions and tests

- **B1 - Annual Salary:** The function multiplies monthly salary by 12. For example, 250,000 RWF per month gives 3,000,000 RWF per year.
- **B2 - Years of Service:** The function calculates completed service years from the hire date to an assessment date. Missing dates and hire dates after the assessment date are rejected.
- **B3 - Tax Calculator:** The function calculates monthly tax using the project's fictional progressive bands. Each rate applies only to the amount within its band.
- **B4 - Department Name:** The function finds a department name using its ID. It handles NO_DATA_FOUND by returning NULL when no department matches.
- **B5 - Functions in SQL:** I called the functions in a SELECT query to produce a report for all 12 payroll-import records. The report shows calculated values and payroll-validation results.

The final checks confirmed that all five functions were valid, all 24 function tests passed, and all 15 payroll tests passed.

## SQL and PL/SQL challenges

**An illegal GOTO jump.** In A3, I ran the intentionally incorrect block and received PLS-00375. The statement tried to jump from outside an IF into its body. I then ran the corrected version, with the destination label after END IF, and it completed successfully. This demonstrated that a label must be in a location the GOTO is allowed to reach.

**Handling missing values.** The test data included missing salaries, hire dates and departments. The code uses IS NULL to check missing values. In B5, CASE expressions stop invalid inputs from reaching calculation functions. I checked the report and saw blank calculation fields where an input was unsuitable, together with a rejection reason from the payroll validator. These were planned test cases, not unexpected execution errors.

**Understanding expected and actual results.** I initially questioned why the test script already contained VALID and INVALID messages. Those messages are the expected results. The validator still reads the data and produces its own answer, which the test compares with the expectation. For example, employee 105 has a zero salary, so returning INVALID makes that test pass. This clarified the difference between a failed test and a correctly rejected record.

**Checking boundary values.** In A2 and A4, I compared employee 102's salary of 149,999 RWF with employee 104's salary of 150,000 RWF. The first required review, while the second was acceptable. Both programs gave the same results, showing that replacing GOTO with IF/ELSIF/ELSE preserved the rule at its boundary.

**User permissions and tablespace storage.** My student account initially lacked CREATE TABLE permission. Using the SYS connection in my PDB, I granted CREATE TABLE and CREATE PROCEDURE, then returned to the student account to run the assignment. The tables were created, but the inserts failed with ORA-01950 because their storage was assigned to SYSTEM without sufficient quota. When I tried to assign USERS as the default tablespace, Oracle reported that USERS did not exist in that PDB. I created it, set it as the student's default tablespace and assigned a 20 MB quota. Changing the default did not move the existing tables, so I moved all five tables and rebuilt their primary-key indexes in USERS. I verified that the indexes were VALID before retrying the inserts.

**Checking whether inserts succeeded.** After fixing the permissions and storage, I ran the inserts again and used COUNT(*) to verify the data. The counts were four departments, five employees, twelve payroll imports, two products and four stock movements. The earlier message "Commit complete" alone did not prove that the inserts had succeeded. This showed the difference between permission to create a table and permission to allocate storage for its data.

## Improvements and limits

Keeping incomplete payroll records in a separate import table allows the validator to explain errors without putting invalid data into the accepted employee table. A future version could record different import batches and keep a history of corrections. It would also need agreed payroll and tax rules before being used for a real business.

## Notes - AI assistance

I used ChatGPT to help develop the Alyos example and draft the SQL scripts, test cases and documentation. It also explained PL/SQL concepts and helped interpret the errors and results I shared during execution.

I ran the scripts individually in Oracle SQL Developer, captured the actual output and checked the results with guidance. I also asked for clarification when I didn't understand.

The execution results and troubleshooting described here come from the work I carried out. I am responsible for reviewing the final submission and being able to explain its code and business rules.

