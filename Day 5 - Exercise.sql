/*Day 5 Assignment: DCL and TCL
Use a copy of hr.employees (e.g-- Hr_emp_backup) for updates so you do not change production data.
Part 1: Practice/* Questions (With Answers and Explanations)*/

/* Question 1
Simulate a transaction: (a) Update salary for one employee in your backup table, (b) Create a savepoint, (c) Update another employee salary, (d) Rollback to the savepoint, (e) Commit. After (e), which change(s) are permanent?
Answer:*/
-- (a) First update
UPDATE hr_emp_backup SET salary = salary * 1.05 WHERE employee_id = 100;

-- (b) Savepoint
SAVEPOINT after_first;

-- (c) Second update
UPDATE hr_emp_backup SET salary = salary * 1.10 WHERE employee_id = 101;

-- (d) Rollback to savepoint (undoes only the second update)
ROLLBACK TO SAVEPOINT after_first;

-- (e) Commit
COMMIT;

/* Question 2
In your own words, explain what happens to session visibility when you COMMIT vs when you ROLLBACK in another session that is querying the same table.
Answer:*/ 
(conceptual): COMMIT makes your changes visible to other sessions; their new queries will see the updated data. 
ROLLBACK discards your changes; other sessions never see them. 
Read consistency means each query in another session sees data as of a consistent point in time; they do not see your uncommitted changes until you commit.


--Part 2: Self-Practice (No Answers)

--1. Write a script that performs two separate UPDATEs on your backup table, then performs one ROLLBACK (no savepoint). What happens to both updates?

both updates are lost — the database returns to its original state before the transaction began.

--2. List the object privileges a user would need to be able to query hr.employees (e.g. SELECT). If you cannot grant, describe what you would run as the table owner.

GRANT statement 

/*Part 3: Additional Practice — 20 Medium + 20 Hard/* Questions (With --Hints)
Use hr_emp_backup or copy tables for DML; describe DCL as the schema owner where applicable.*/

--20 Medium Questions

-- M1. After updating one row in hr_emp_backup, issue COMMIT. Then run a SELECT to verify.  
   --Hint: UPDATE ... ; COMMIT; SELECT  FROM hr_emp_backup WHERE ... ;

-- M2. Update two different rows in hr_emp_backup, then ROLLBACK. Verify both changes are undone.  
   --Hint: Two UPDATEs; ROLLBACK; SELECT to confirm original values.

-- M3. Create a savepoint after one UPDATE, then do another UPDATE, then ROLLBACK TO SAVEPOINT. What is the state before COMMIT?  
   --Hint: First update remains in transaction; second is undone.

-- M4. Write the SQL to GRANT SELECT on hr.employees to a role named hr_select_role (run as HR if you have access).  
   --Hint: CREATE ROLE hr_select_role; GRANT SELECT ON hr.employees TO hr_select_role;

-- M5. Revoke SELECT on hr.departments from a user (use a placeholder user name).  
   --Hint: REVOKE SELECT ON hr.departments FROM some_user;

-- M6. In one transaction, update salary for employee_id 100, create savepoint sp1, update salary for employee_id 101, then ROLLBACK TO sp1, then COMMIT. Who has the new salary?  
   --Hint: Only employee 100; 101's update was rolled back.

-- M7. Grant INSERT and UPDATE on hr_emp_backup to a role (your own backup table in your schema).  
   --Hint: GRANT INSERT, UPDATE ON hr_emp_backup TO your_role;

-- M8. Run UPDATE on hr_emp_backup for 3 rows, then ROLLBACK. Check SQL%ROWCOUNT after UPDATE (in PL/SQL) and after ROLLBACK.  
   --Hint: After UPDATE, SQL%ROWCOUNT = 3; after ROLLBACK, the updates are undone.

-- M9. Create a role hr_report and grant it SELECT on hr.employees and hr.departments.  
   --Hint: CREATE ROLE hr_report; GRANT SELECT ON hr.employees TO hr_report; GRANT SELECT ON hr.departments TO hr_report;

-- M10. After a DELETE from hr_emp_backup, do not COMMIT. In another session (or same), can you see the deleted rows before COMMIT?  
    --Hint: In the same session, the rows are gone; in another session with read consistency, they may still be visible until the first session commits.

-- M11. Write a script: UPDATE one row, SAVEPOINT a, UPDATE another row, SAVEPOINT b, UPDATE a third row, ROLLBACK TO SAVEPOINT a, then COMMIT. Which rows are updated permanently?  
    --Hint: Only the first update; second and third are rolled back.

-- M12. Grant SELECT on hr.employees to a user. Then revoke it.  
    --Hint: GRANT SELECT ON hr.employees TO user1; REVOKE SELECT ON hr.employees FROM user1;

-- M13. In a single transaction, run two UPDATEs on hr_emp_backup (different departments). Then COMMIT-- How many rows are committed?  
    --Hint: All rows updated by both UPDATEs are committed together.

-- M14. Create a role and grant it only SELECT on hr.departments (no other tables).  
    --Hint: CREATE ROLE dept_reader; GRANT SELECT ON hr.departments TO dept_reader;

-- M15. After an UPDATE, run SELECT to verify, then ROLLBACK. Why is ROLLBACK useful here?  
    --Hint: To discard the change if the SELECT showed something wrong.

-- M16. Use two savepoints: after first UPDATE (sp1), after second UPDATE (sp2). Then ROLLBACK TO sp1. What happens to the second update?  
    --Hint: The second update is undone; first remains in the transaction.

-- M17. List the privileges you would need (as DBA) to allow a user to create a table and insert into hr.employees (conceptual).  
    --Hint: CREATE TABLE (system), INSERT on hr.employees (object), and possibly quota on tablespace.

-- M18. Run UPDATE on hr_emp_backup, then COMMIT. Run another UPDATE, then ROLLBACK. Is the first update still committed?  
    --Hint: Yes; ROLLBACK only undoes the second update.

-- M19. Grant a role to a user: GRANT hr_reader TO app_user; What can app_user do?  
    --Hint: Whatever privileges were granted to hr_reader (e.g. SELECT on hr.employees and hr.departments).

-- M20. In one transaction, DELETE 5 rows from hr_emp_backup, then ROLLBACK. Verify the 5 rows are back.  
    --Hint: DELETE ... WHERE ... ; ROLLBACK; SELECT COUNT() should show rows restored.

--20 Hard Questions

-- H1. Implement a "try and undo" pattern: UPDATE 10 rows, check SQL%ROWCOUNT, if not 10 then ROLLBACK else COMMIT (in PL/SQL).  
   --Hint: BEGIN UPDATE ... ; IF SQL%ROWCOUNT != 10 THEN ROLLBACK; ELSE COMMIT; END IF; END;

-- H2. Create two savepoints. After three UPDATEs (one after each savepoint), ROLLBACK TO the first savepoint. Then COMMIT. Which updates are permanent?  
   --Hint: Only the first update (before first savepoint) is committed; the other two are rolled back.

-- H3. Write a script that grants SELECT, INSERT, UPDATE on hr.employees to role hr_hrw (read and write), then revokes UPDATE only.  
   --Hint: GRANT SELECT, INSERT, UPDATE ON hr.employees TO hr_hrw; REVOKE UPDATE ON hr.employees FROM hr_hrw;

-- H4. In a transaction, update salary for department 50, savepoint, update salary for department 60, rollback to savepoint, update salary for department 70, commit. Which departments are updated?  
   --Hint: 50 and 70; 60 is rolled back.

-- H5. Explain: Session A updates a row and does not commit. Session B updates the same row. What happens?  
   --Hint: Session B blocks (waits) until A commits or rolls back; then B proceeds or gets a conflict depending on isolation.

-- H6. Create a role that has SELECT on hr.employees and hr.departments, and grant that role to two different users (placeholder names).  
   --Hint: CREATE ROLE r; GRANT SELECT ON hr.employees TO r; GRANT SELECT ON hr.departments TO r; GRANT r TO u1; GRANT r TO u2;

-- H7. Run UPDATE on hr_emp_backup, then create savepoint, then DELETE 1 row, then ROLLBACK TO SAVEPOINT, then COMMIT. Is the row deleted?  
   --Hint: No; the DELETE was rolled back. Only the UPDATE is committed.

-- H8. What object privilege is needed to allow a user to run SELECT  FROM hr.employees?  
   --Hint: SELECT on hr.employees (and possibly on schema/table if qualified).

-- H9. In one transaction, INSERT one row, SAVEPOINT, INSERT another row, ROLLBACK TO SAVEPOINT, COMMIT-- How many rows are in the table?  
   --Hint: One (the first insert); the second insert was rolled back.

-- H10. Grant SELECT on hr.employees to a role, then grant that role to a user. Then revoke the role from the user. Can the user still query hr.employees?  
    --Hint: No; revoking the role removes the privilege.

-- H11. Write a transaction that updates 3 rows in hr_emp_backup, then rolls back only the last update using a savepoint.  
    --Hint: UPDATE row1; UPDATE row2; SAVEPOINT s; UPDATE row3; ROLLBACK TO s; COMMIT;

-- H12. If you REVOKE SELECT ON hr.employees FROM a role, do users who were granted that role lose access immediately?  
    --Hint: Yes (or at next reconnection depending on DB); the role no longer has the privilege.

-- H13. Run DELETE from hr_emp_backup where department_id = 50, then SAVEPOINT, then DELETE where department_id = 60, then ROLLBACK TO SAVEPOINT, then COMMIT. Which departments' rows are deleted?  
    --Hint: Only department 50; department 60 delete was rolled back.

-- H14. Create a role with SELECT on hr.employees. Grant the role to user A. Grant the role to role B. Grant role B to user C. Can user C query hr.employees?  
    --Hint: Yes, if role B was granted the first role (role chain); or grant SELECT to role B and grant B to C.

-- H15. In a single transaction, run five UPDATEs with savepoints between each. Roll back to the second savepoint-- How many UPDATEs are still in the transaction?  
    --Hint: Two (the first two updates); the third, fourth, fifth are undone.

-- H16. Revoke INSERT on hr.employees from a role. Does this affect users who have the role?  
    --Hint: Yes; they lose INSERT on hr.employees through that role.

-- H17. Update hr_emp_backup in a transaction but do not commit. Open another session and try to SELECT the same rows. Explain read consistency.  
    --Hint: The second session sees the old values until the first commits; Oracle read consistency.

-- H18. Write a script that uses a savepoint before a risky UPDATE, then checks a condition (e.g. SQL%ROWCOUNT), and rolls back to the savepoint if the condition is not met.  
    --Hint: SAVEPOINT before; UPDATE; IF condition THEN COMMIT; ELSE ROLLBACK TO SAVEPOINT; END IF;

-- H19. Grant SELECT ON hr.employees to user X. User X creates a view on hr.employees. Can user X grant SELECT on that view to user Y without having GRANT OPTION on hr.employees?  
    --Hint: Typically yes for the view (user X owns the view); Y can query the view. X cannot grant Y direct SELECT on hr.employees unless X has GRANT OPTION.

-- H20. In one transaction: INSERT row 1, SAVEPOINT a, INSERT row 2, SAVEPOINT b, DELETE row 1, ROLLBACK TO SAVEPOINT b, COMMIT. What rows exist?  
    --Hint: Both rows (row 1 and row 2); the DELETE was rolled back when we rolled back to b. So after COMMIT we have both inserts.
