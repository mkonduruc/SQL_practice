/*Day 22 Assignment: Stored Procedures
All exercises use hr.employees and hr.departments. Create procedures in your schema or in HR if you have privileges.
Part 1: Practice Questions (With Answers and Explanations)*/

/*Question 1
Create a procedure list_emp_by_dept(p_dept_id) that takes a department ID and outputs (e.g. via DBMS_OUTPUT) the first and last name of each employee in that department. Use a cursor FOR loop.
Answer:*/

CREATE OR REPLACE PROCEDURE list_emp_by_dept(p_dept_id IN departments.department_id%TYPE) IS
  CURSOR c IS SELECT first_name, last_name FROM employees WHERE department_id = p_dept_id;
BEGIN
  FOR rec IN c LOOP
    DBMS_OUTPUT.PUT_LINE(rec.first_name || ' ' || rec.last_name);
  END LOOP;
END;
/

--Explanation: IN parameter p_dept_id is used in the cursor WHERE clause. The procedure loops and prints each name. Call with EXEC list_emp_by_dept(50); (and SET SERVEROUTPUT ON).

/*Question 2
Create a procedure raise_salary(p_emp_id, p_pct) that updates the salary of the given employee by increasing it by p_pct percent (e.g. 10 for 10%). Use UPDATE ... WHERE employee_id = p_emp_id. Optionally check SQL%ROWCOUNT and raise an error if no row was updated.
Answer:*/

CREATE OR REPLACE PROCEDURE raise_salary(
  p_emp_id IN employees.employee_id%TYPE,
  p_pct    IN NUMBER
) IS
BEGIN
  UPDATE employees SET salary = salary * (1 + p_pct/100) WHERE employee_id = p_emp_id;
  IF SQL%ROWCOUNT = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Employee not found: ' || p_emp_id);
  END IF;
  COMMIT;
END;
/

--Explanation: UPDATE multiplies salary by (1 + p_pct/100). SQL%ROWCOUNT = 0 means no row matched; raise a user-defined error. COMMIT makes the change permanent (omit if caller should commit).

/*Question 3
Create a procedure that takes department_id as IN and returns the total salary of that department in an OUT parameter. Call it from a block and print the result.
Answer:*/

CREATE OR REPLACE PROCEDURE get_dept_total_salary(
  p_dept_id IN  departments.department_id%TYPE,
  p_total   OUT NUMBER
) IS
BEGIN
  SELECT NVL(SUM(salary), 0) INTO p_total FROM employees WHERE department_id = p_dept_id;
END;
/

-- Call:
DECLARE v_total NUMBER; 
BEGIN 
  get_dept_total_salary(50, v_total); 
  DBMS_OUTPUT.PUT_LINE('Total: ' || v_total); 
END;
/

-- Explanation: The OUT parameter p_total is set by SELECT INTO. NVL(SUM(salary),0) returns 0 when the department has no employees. The caller passes a variable for the OUT and prints it.

--Part 2: Self-Practice (No Answers)

--1. Create a procedure that inserts one row into a backup table (e.g--Hr_emp_backup) with parameters for employee_id, first_name, last_name, salary, department_id.

CREATE TABLE hr_emp_backup (
    employee_id   NUMBER PRIMARY KEY,
    first_name    VARCHAR2(50),
    last_name     VARCHAR2(50),
    salary        NUMBER(10,2),
    department_id NUMBER
);

-- Create the procedure
CREATE OR REPLACE PROCEDURE insert_hr_emp_backup (
    p_employee_id   IN NUMBER,
    p_first_name    IN VARCHAR2,
    p_last_name     IN VARCHAR2,
    p_salary        IN NUMBER,
    p_department_id IN NUMBER
) AS
BEGIN
    INSERT INTO hr_emp_backup (
        employee_id, first_name, last_name, salary, department_id
    ) VALUES (
        p_employee_id, p_first_name, p_last_name, p_salary, p_department_id
    );
END;
/

-- Example call
BEGIN
    insert_hr_emp_backup(101, 'John', 'Doe', 50000, 10);
END;
/

--2. Create a procedure with a default parameter (e.g. p_dept_id IN NUMBER DEFAULT 50) and call it with and without that parameter.

CREATE OR REPLACE PROCEDURE get_employees_by_dept (
    p_dept_id IN NUMBER DEFAULT 50
) AS
BEGIN
    FOR rec IN (
        SELECT employee_id, first_name, last_name, department_id
        FROM employees
        WHERE department_id = p_dept_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || rec.employee_id || 
            ', Name: ' || rec.first_name || ' ' || rec.last_name || 
            ', Dept: ' || rec.department_id
        );
    END LOOP;
END;
/


/*Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)
All use hr.employees and hr.departments; create procedures in your schema or HR if allowed.*/

--20 Medium Questions

--M1. Create procedure get_emp_count(p_dept_id IN, p_count OUT); SELECT COUNT(*) INTO p_count--Hint: CREATE PROCEDURE ... (p_dept_id IN NUMBER, p_count OUT NUMBER) IS BEGIN SELECT COUNT(*) INTO p_count FROM hr.employees WHERE department_id = p_dept_id; END;

CREATE OR REPLACE PROCEDURE get_emp_counts (
    p_dept_id IN  NUMBER,   
    p_count   OUT NUMBER  
) IS
BEGIN

    SELECT COUNT(*) INTO p_count FROM employees WHERE department_id = p_dept_id;

END;
/

--M2. Procedure raise_salary(p_emp_id, p_pct); UPDATE salary by p_pct percent--Hint: UPDATE hr.employees SET salary = salary * (1 + p_pct/100) WHERE employee_id = p_emp_id;

CREATE OR REPLACE PROCEDURE raise_salary (
    p_emp_id IN employees.employee_id%TYPE,
    p_pct    IN NUMBER
) AS
    v_current_salary employees.salary%TYPE;
BEGIN
    IF p_pct = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Percentage increase cannot be zero.');
    END IF;

    SELECT salary INTO v_current_salary FROM employees WHERE employee_id = p_emp_id;

    UPDATE employees SET salary = salary + (salary * p_pct / 100) WHERE employee_id = p_emp_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Salary updated successfully for Employee ID: ' || p_emp_id);
    DBMS_OUTPUT.PUT_LINE('Old Salary: ' || v_current_salary || ', New Salary: ' || (v_current_salary + (v_current_salary * p_pct / 100)));

END raise_salary;
/


SET SERVEROUTPUT ON;
BEGIN
    raise_salary(101, 10); 
END;
/
--M3. Procedure with two OUT params: total_salary and emp_count for a department--Hint: SELECT SUM(salary), COUNT(*) INTO p_total, p_count FROM hr.employees WHERE department_id = p_dept_id;



--M4. Call a procedure from anonymous block and print OUT parameter--Hint: DECLARE v NUMBER; BEGIN get_emp_count(50, v); DBMS_OUTPUT.PUT_LINE(v); END;

DECLARE 
    v NUMBER; 
BEGIN 
    get_emp_count(50, v); 
    DBMS_OUTPUT.PUT_LINE(v); 
END;

--M5. Procedure list_emp_by_dept(p_dept_id) that prints first_name, last_name using cursor FOR loop--Hint: CURSOR c IS SELECT first_name, last_name FROM hr.employees WHERE department_id = p_dept_id; FOR rec IN c LOOP DBMS_OUTPUT.PUT_LINE(...);



--M6. Use %TYPE for procedure parameters (p_dept_id hr.departments.department_id%TYPE)--Hint: p_dept_id IN hr.departments.department_id%TYPE



--M7. Procedure that takes employee_id and returns first_name, last_name in OUT parameters--Hint: p_fname OUT hr.employees.first_name%TYPE, p_lname OUT ...; SELECT first_name, last_name INTO p_fname, p_lname FROM hr.employees WHERE employee_id = p_emp_id;

CREATE OR REPLACE PROCEDURE get_employee_name (
    p_employee_id IN  employees.employee_id%TYPE,
    p_first_name  OUT employees.first_name%TYPE, 
    p_last_name   OUT employees.last_name%TYPE 
) AS
BEGIN
    SELECT first_name, last_name INTO   p_first_name, p_last_name FROM employees WHERE  employee_id = p_employee_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Handle case where employee_id does not exist
        p_first_name := NULL;
        p_last_name  := NULL;
        DBMS_OUTPUT.PUT_LINE('No employee found with ID: ' || p_employee_id);
    WHEN OTHERS THEN
        -- Handle unexpected errors
        p_first_name := NULL;
        p_last_name  := NULL;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--M8. Check SQL%ROWCOUNT after UPDATE in procedure; raise error if 0--Hint: IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(-20001, 'Not found');

CREATE OR REPLACE PROCEDURE update_employee_salary (
    p_emp_id   IN employees.employee_id%TYPE,
    p_new_sal  IN employees.salary%TYPE
) AS
BEGIN
    UPDATE employees SET salary = p_new_sal WHERE employee_id = p_emp_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No rows updated: Employee ID not found.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Salary updated successfully for Employee ID ' || p_emp_id);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RAISE;
END;
/

--M9. Procedure with default: p_dept_id IN NUMBER DEFAULT 50--Hint: p_dept_id IN NUMBER DEFAULT 50

CREATE OR REPLACE PROCEDURE get_employees_by_dept (
    p_dept_id IN NUMBER DEFAULT 50 
) AS
BEGIN
    FOR rec IN (
        SELECT employee_id, first_name, last_name, department_id FROM employees WHERE department_id = p_dept_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.employee_id ||', Name: ' || rec.first_name || ' ' || rec.last_name ||', Dept: ' || rec.department_id);
    END LOOP;
END;
/

--M10. Procedure get_dept_total_salary(p_dept_id, p_total OUT); use NVL(SUM(salary),0)--Hint: SELECT NVL(SUM(salary),0) INTO p_total FROM hr.employees WHERE department_id = p_dept_id;

CREATE OR REPLACE PROCEDURE get_dept_total_salary (
    p_dept_id IN  employees.department_id%TYPE,
    p_total   OUT NUMBER
) AS
BEGIN
    SELECT NVL(SUM(salary), 0) INTO   p_total FROM  employees WHERE  department_id = p_dept_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_total := 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        p_total := 0;
END;
/

--M11. Procedure to update department_id for an employee (p_emp_id, p_dept_id)--Hint: UPDATE hr.employees SET department_id = p_dept_id WHERE employee_id = p_emp_id;

CREATE OR REPLACE PROCEDURE update_employee_department (
    p_emp_id   IN employees.employee_id%TYPE,
    p_dept_id  IN employees.department_id%TYPE
) AS
    v_count_emp  NUMBER;
    v_count_dept NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count_emp FROM employees WHERE employee_id = p_emp_id;

    IF v_count_emp = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Employee ID does not exist.');
    END IF;

    SELECT COUNT(*) INTO v_count_dept FROM departments WHERE department_id = p_dept_id;

    IF v_count_dept = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Department ID does not exist.');
    END IF;

    UPDATE employees SET department_id = p_dept_id WHERE employee_id = p_emp_id;

    DBMS_OUTPUT.PUT_LINE('Department updated successfully for Employee ID ' || p_emp_id);

END ;
/

SET SERVEROUTPUT ON;
BEGIN
    update_employee_department(101, 50);
END;
/

--M12. EXEC procedure_name(args) from SQL*Plus--Hint: EXEC raise_salary(100, 5);


EXEC update_employee_department(101, 50);


--M13. Procedure that inserts into hr_emp_backup (params: emp_id, fname, lname, sal, dept_id)--Hint: INSERT INTO hr_emp_backup (employee_id, first_name, last_name, salary, department_id) VALUES (p_emp_id, p_fname, p_lname, p_sal, p_dept_id);

CREATE OR REPLACE PROCEDURE insert_hr_emp_backup (
    p_emp_id    IN NUMBER,
    p_fname     IN VARCHAR2,
    p_lname     IN VARCHAR2,
    p_sal       IN NUMBER,
    p_dept_id   IN NUMBER
) AS
BEGIN
    INSERT INTO hr_emp_backup (
        employee_id,
        first_name,
        last_name,
        salary,
        department_id
    ) VALUES (
        p_emp_id,
        p_fname,
        p_lname,
        p_sal,
        p_dept_id
    );
END;
/

--M14. Procedure with IN OUT parameter: pass number, add 10 to it, return--Hint: p_val IN OUT NUMBER; p_val := p_val + 10;

CREATE OR REPLACE PROCEDURE add_ten (
    p_num IN OUT NUMBER 
) AS
BEGIN
    p_num := p_num + 10;
END;
/

DECLARE
    v_value NUMBER := 25;  
BEGIN
    DBMS_OUTPUT.PUT_LINE('Before procedure call: ' || v_value);
    add_ten(v_value);
    DBMS_OUTPUT.PUT_LINE('After procedure call: ' || v_value);
END;
/

--M15. Procedure that prints department_name for given department_id (SELECT INTO, DBMS_OUTPUT)--Hint: SELECT department_name INTO v FROM hr.departments WHERE department_id = p_dept_id; DBMS_OUTPUT.PUT_LINE(v);

CREATE OR REPLACE PROCEDURE print_department_name (
    p_department_id IN departments.department_id%TYPE
) AS
    v_department_name departments.department_name%TYPE;
BEGIN
    SELECT department_name INTO v_department_name FROM departments WHERE department_id = p_department_id;

    DBMS_OUTPUT.PUT_LINE('Department Name: ' || v_department_name);
END;
/

--M16. Procedure with three IN params: min_sal, max_sal, dept_id; print employee count in range--Hint: SELECT COUNT(*) INTO v FROM hr.employees WHERE department_id = p_dept_id AND salary BETWEEN p_min AND p_max; DBMS_OUTPUT.PUT_LINE(v);

CREATE OR REPLACE PROCEDURE get_emp_count_in_range (
    p_min_sal IN NUMBER,
    p_max_sal IN NUMBER,
    p_dept_id IN NUMBER
) AS
    v_emp_count NUMBER;
BEGIN
    IF p_min_sal > p_max_sal THEN
        DBMS_OUTPUT.PUT_LINE('Error: Minimum salary cannot be greater than maximum salary.');
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_emp_count FROM employees WHERE department_id = p_dept_id AND salary BETWEEN p_min_sal AND p_max_sal;

    DBMS_OUTPUT.PUT_LINE('Employee count in department ' || p_dept_id ||' with salary between ' || p_min_sal || ' and ' || p_max_sal ||' is: ' || v_emp_count);
END;
/

--M17. Call procedure without optional parameter (use default)--Hint: list_emp_by_dept; -- p_dept_id defaults to 50



--M18. Procedure that returns max salary of department in OUT--Hint: SELECT MAX(salary) INTO p_max_sal FROM hr.employees WHERE department_id = p_dept_id;

CREATE OR REPLACE PROCEDURE get_max_salary_by_dept (
    p_dept_id   IN  EMPLOYEES.DEPARTMENT_ID%TYPE,
    p_max_salary OUT EMPLOYEES.SALARY%TYPE
) AS
BEGIN
    SELECT MAX(salary) INTO p_max_salary FROM employees WHERE department_id = p_dept_id;

    IF p_max_salary IS NULL THEN
        p_max_salary := 0; 
    END IF;
END;
/

--M19. Procedure to set commission_pct for an employee (p_emp_id, p_comm)--Hint: UPDATE hr.employees SET commission_pct = p_comm WHERE employee_id = p_emp_id;

CREATE OR REPLACE PROCEDURE set_commission_pct (
    p_emp_id   IN employees.employee_id%TYPE,
    p_comm     IN employees.commission_pct%TYPE
) AS
BEGIN
    IF p_comm < 0 OR p_comm > 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Commission percentage must be between 0 and 1.');
    END IF;

    UPDATE employees SET commission_pct = p_comm WHERE employee_id = p_emp_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'No employee found with the given ID.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Commission updated successfully for Employee ID: ' || p_emp_id);
END;
/

--M20. Procedure with two IN params: p_job_id, p_dept_id; print count of employees--Hint: SELECT COUNT(*) INTO v FROM hr.employees WHERE job_id = p_job_id AND department_id = p_dept_id; DBMS_OUTPUT.PUT_LINE(v);

CREATE OR REPLACE PROCEDURE get_employee_count (
    p_job_id   IN employees.job_id%TYPE,
    p_dept_id  IN employees.department_id%TYPE
) AS
    v_count NUMBER;
BEGIN
    IF p_job_id IS NULL OR p_dept_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Error: Both job_id and department_id must be provided.');
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_count FROM employees WHERE job_id = p_job_id AND department_id = p_dept_id;

    DBMS_OUTPUT.PUT_LINE('Number of employees with Job ID ' || p_job_id ||' in Department ' || p_dept_id || ': ' || v_count);
END;
/


--20 Hard Questions

--H1. Procedure that accepts REF CURSOR OUT; open it for SELECT * FROM hr.employees WHERE department_id = p_dept_id--Hint: p_rc OUT SYS_REFCURSOR; OPEN p_rc FOR SELECT * FROM hr.employees WHERE department_id = p_dept_id;

CREATE OR REPLACE PROCEDURE get_employees_by_dept (
    p_dept_id IN  employees.department_id%TYPE,
    p_rc      OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_rc FOR
        SELECT * FROM employees WHERE department_id = p_dept_id;
END;
/

--H2. Procedure with OUT parameter as associative array of employee last_names (TYPE t_tab IS TABLE OF VARCHAR2(25) INDEX BY PLS_INTEGER)--Hint: BULK COLLECT INTO p_arr FROM (SELECT last_name FROM hr.employees WHERE department_id = p_dept_id);



--H3. Procedure that updates salary and logs old/new to audit table in same procedure (no trigger)--Hint: SELECT salary INTO v_old FROM hr.employees WHERE employee_id = p_emp_id; UPDATE ...; INSERT INTO audit_table VALUES (...);

CREATE OR REPLACE PROCEDURE update_salary_with_audit (
    p_emp_id     IN employees.employee_id%TYPE,
    p_new_salary IN employees.salary%TYPE
) AS
    v_old_salary employees.salary%TYPE;
BEGIN

    SELECT salary INTO v_old_salary FROM employees WHERE employee_id = p_emp_id FOR UPDATE; 

    UPDATE employees SET salary = p_new_salary WHERE employee_id = p_emp_id;

    INSERT INTO salary_audit (audit_id, p_emp_id, old_salary, new_salary, change_date)
    VALUES (
        salary_audit_seq.NEXTVAL,
        p_emp_id,
        v_old_salary,
        p_new_salary,
        SYSDATE
    );
END;
/

--H4. Procedure with exception handler: on NO_DATA_FOUND set OUT parameter to -1 and don't re-raise--Hint: EXCEPTION WHEN NO_DATA_FOUND THEN p_count := -1;



--H5. Procedure that raises custom RAISE_APPLICATION_ERROR if department_id does not exist in hr.departments--Hint: SELECT COUNT(*) INTO v FROM hr.departments WHERE department_id = p_dept_id; IF v = 0 THEN RAISE_APPLICATION_ERROR(-20002, 'Invalid dept');



--H6. Procedure to "transfer" an employee to another department (update department_id); validate both departments exist--Hint: Check source and target department_id in hr.departments; then UPDATE hr.employees SET department_id = p_new_dept WHERE employee_id = p_emp_id;

CREATE OR REPLACE PROCEDURE transfer_employee_department (
    p_employee_id   IN employees.employee_id%TYPE,
    p_new_dept_id   IN departments.department_id%TYPE
) AS
    v_old_dept_id   employees.department_id%TYPE;
    v_count         NUMBER;
BEGIN
    SELECT department_id INTO v_old_dept_id FROM employees WHERE employee_id = p_employee_id;

    SELECT COUNT(*) INTO v_count FROM departments WHERE department_id = v_old_dept_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Current department does not exist.');
    END IF;

    SELECT COUNT(*) INTO v_count FROM departments WHERE department_id = p_new_dept_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Target department does not exist.');
    END IF;

    IF v_old_dept_id = p_new_dept_id THEN
        RAISE_APPLICATION_ERROR(-20003, 'Employee is already in the target department.');
    END IF;

    UPDATE employees SET department_id = p_new_dept_id WHERE employee_id = p_employee_id;

    DBMS_OUTPUT.PUT_LINE('Employee ' || p_employee_id ||' transferred from department ' || v_old_dept_id ||' to department ' || p_new_dept_id);
END;
/

--H7. Procedure with COMMIT inside vs procedure without COMMIT (caller commits)--Hint: Document; either END with COMMIT; or leave to caller.

CREATE OR REPLACE PROCEDURE update_salary_with_commit (
    p_emp_id   IN employees.employee_id%TYPE,
    p_amount   IN NUMBER
) AS
BEGIN
    UPDATE employees SET salary = salary + p_amount WHERE employee_id = p_emp_id;

    COMMIT; 
END;
/

--H8. Procedure that returns multiple OUT: min_sal, max_sal, avg_sal for a department--Hint: SELECT MIN(salary), MAX(salary), AVG(salary) INTO p_min, p_max, p_avg FROM hr.employees WHERE department_id = p_dept_id;

CREATE OR REPLACE PROCEDURE get_dept_salary_stats (
    p_dept_id   IN  employees.department_id%TYPE, 
    p_min_sal   OUT NUMBER,                       
    p_max_sal   OUT NUMBER,                       
    p_avg_sal   OUT NUMBER                       
) AS
BEGIN
    SELECT MIN(salary), MAX(salary), AVG(salary)
    INTO   p_min_sal, p_max_sal, p_avg_sal
    FROM   employees WHERE  department_id = p_dept_id;

    IF p_min_sal IS NULL THEN
        p_min_sal := 0;
        p_max_sal := 0;
        p_avg_sal := 0;
    END IF;
END;
/

--H9. Create procedure that calls another procedure (e.g. get count then call list_emp_by_dept)--Hint: get_emp_count(50, v); list_emp_by_dept(50);

CREATE OR REPLACE PROCEDURE get_emp_count_by_dept (
    p_dept_id   IN  NUMBER,
    p_count     OUT NUMBER
) AS
BEGIN
    SELECT COUNT(*) INTO p_count FROM employees WHERE department_id = p_dept_id;
END;
/

CREATE OR REPLACE PROCEDURE list_emp_by_dept (
    p_dept_id IN NUMBER
) AS
BEGIN
    FOR rec IN (
        SELECT employee_id, first_name, last_name FROM employees 
        WHERE department_id = p_dept_id ORDER BY employee_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.employee_id || ' - ' ||
                             rec.first_name || ' ' || rec.last_name);
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE show_dept_info (
    p_dept_id IN NUMBER
) AS
    v_count NUMBER;
BEGIN
    get_emp_count_by_dept(p_dept_id, v_count);
    DBMS_OUTPUT.PUT_LINE('Department ' || p_dept_id || ' has ' || v_count || ' employees.');

    IF v_count > 0 THEN
        list_emp_by_dept(p_dept_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No employees found in this department.');
    END IF;
END;
/

-- Example execution
SET SERVEROUTPUT ON;
BEGIN
    show_dept_info(50); 
END;
/

--H10. Procedure with IN OUT parameter: pass employee_id, return full name (first||' '||last) in same IN OUT or second OUT--Hint: p_emp_id IN, p_fullname OUT VARCHAR2; SELECT first_name||' '||last_name INTO p_fullname FROM hr.employees WHERE employee_id = p_emp_id;

CREATE OR REPLACE PROCEDURE get_employee_fullname (
    p_emp IN OUT VARCHAR2 
) AS
    v_emp_id NUMBER;
BEGIN
    BEGIN
        v_emp_id := TO_NUMBER(p_emp);
    EXCEPTION
        WHEN VALUE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid employee_id format.');
    END;

    SELECT first_name || ' ' || last_name INTO p_emp FROM employees WHERE employee_id = v_emp_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_emp := NULL; 
END;
/

--H11. Procedure that updates salaries for all employees in a department by p_pct; return rows updated in OUT--Hint: UPDATE hr.employees SET salary = salary * (1+p_pct/100) WHERE department_id = p_dept_id; p_rows := SQL%ROWCOUNT;

CREATE OR REPLACE PROCEDURE update_department_salaries (
    p_dept_id   IN  employees.department_id%TYPE, 
    p_pct       IN  NUMBER,                      
    p_rows      OUT NUMBER                     
) AS
BEGIN
    IF p_pct IS NULL OR p_pct = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Percentage increase must be non-zero.');
    END IF;

    UPDATE employees
    SET salary = salary * (1 + p_pct / 100)
    WHERE department_id = p_dept_id;

    p_rows := SQL%ROWCOUNT;
END ;
/

--H12. Procedure with default for second parameter: p_emp_id IN, p_pct IN NUMBER DEFAULT 10--Hint: raise_salary(p_emp_id, p_pct DEFAULT 10);

CREATE OR REPLACE PROCEDURE give_bonus (
    p_emp_id IN NUMBER,              
    p_pct    IN NUMBER DEFAULT 10  
) AS
BEGIN

    UPDATE employees SET salary = salary + (salary * p_pct / 100) WHERE employee_id = p_emp_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Bonus of ' || p_pct || '% applied to employee ID ' || p_emp_id);
END;
/

--H13. Use named notation in call: procedure_name(p_dept_id => 50, p_count => v_count)--Hint: get_emp_count(p_dept_id => 50, p_count => v_count);

DECLARE
    v_count NUMBER;
BEGIN
    get_emp_count(p_dept_id => 50,p_count   => v_count);
END;
/

--H14. Procedure that deletes employees in a department (p_dept_id); return deleted count in OUT--Hint: DELETE FROM hr.employees WHERE department_id = p_dept_id; p_deleted := SQL%ROWCOUNT; (use backup table in practice)

CREATE OR REPLACE PROCEDURE delete_employees_by_dept (
    p_dept_id   IN  employees.department_id%TYPE,  
    p_deleted_count OUT NUMBER          
) AS
BEGIN
    p_deleted_count := 0;

    DELETE FROM employees
    WHERE department_id = p_dept_id;

    p_deleted_count := SQL%ROWCOUNT;

    COMMIT;
END;
/

--H15. Procedure with cursor OUT (SYS_REFCURSOR) for query joining employees and departments--Hint: OPEN p_rc FOR SELECT e.employee_id, e.first_name, d.department_name FROM hr.employees e JOIN hr.departments d ON e.department_id = d.department_id;

CREATE OR REPLACE PROCEDURE get_emp_dept_data (
    p_cursor OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_cursor FOR
        SELECT e.employee_id,
               e.first_name,
               e.last_name,
               e.job_id,
               e.salary,
               d.department_id,
               d.department_name,
               d.location_id
        FROM   employees e
        JOIN   departments d
               ON e.department_id = d.department_id
        ORDER BY d.department_name, e.last_name;
END;
/

--H16. Procedure that inserts into backup only if employee exists; return 0 or 1 in OUT--Hint: SELECT ... INTO ... WHERE employee_id = p_emp_id; INSERT INTO backup ...; p_ok := 1; EXCEPTION WHEN NO_DATA_FOUND THEN p_ok := 0;

CREATE OR REPLACE PROCEDURE backup_employee_if_exists (
    p_emp_id   IN  employees.emp_id%TYPE,  
    p_status   OUT NUMBER                
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM employees WHERE emp_id = p_emp_id;

    IF v_count > 0 THEN
        INSERT INTO employees_backup (emp_id, emp_name, dept_id, salary, hire_date)
        SELECT emp_id, emp_name, dept_id, salary, hire_date FROM employees WHERE emp_id = p_emp_id;

        p_status := 1; 
    ELSE
        p_status := 0; 
    END IF;

END;
/

--H17. Procedure with IN OUT number: add 1 and return (p_counter IN OUT NUMBER)--Hint: p_counter := p_counter + 1;

CREATE OR REPLACE PROCEDURE increment_counter (
    p_counter IN OUT NUMBER
) AS
BEGIN
    p_counter := NVL(p_counter, 0) + 1;
END;
/

DECLARE
    v_count NUMBER := 5; 
BEGIN
    DBMS_OUTPUT.PUT_LINE('Before: ' || v_count);

    increment_counter(v_count);

    DBMS_OUTPUT.PUT_LINE('After: ' || v_count);
END;
/

--H18. Procedure list_departments that prints each department_name and its employee count (cursor over depts, count per dept)--Hint: CURSOR c IS SELECT department_id, department_name FROM hr.departments; FOR rec IN c LOOP SELECT COUNT(*) INTO v FROM hr.employees WHERE department_id = rec.department_id; DBMS_OUTPUT.PUT_LINE(rec.department_name || ': ' || v);

CREATE OR REPLACE PROCEDURE list_departments IS
    CURSOR dept_cur IS SELECT department_id, department_name FROM departments ORDER BY department_name;

    v_dept_id   departments.department_id%TYPE;
    v_dept_name departments.department_name%TYPE;
    v_emp_count NUMBER;
BEGIN
    OPEN dept_cur;
    LOOP
        FETCH dept_cur INTO v_dept_id, v_dept_name;
        EXIT WHEN dept_cur%NOTFOUND;

        SELECT COUNT(*) INTO v_emp_count FROM employees WHERE department_id = v_dept_id;

        DBMS_OUTPUT.PUT_LINE(RPAD(v_dept_name, 30) || ' : ' || v_emp_count);
    END LOOP;
    CLOSE dept_cur;
END;
/

--H19. Procedure that gets department_name for department_id and returns it in OUT (handle NO_DATA_FOUND)--Hint: SELECT department_name INTO p_name FROM hr.departments WHERE department_id = p_dept_id; EXCEPTION WHEN NO_DATA_FOUND THEN p_name := NULL;

CREATE OR REPLACE PROCEDURE get_department_name (
    p_department_id   IN  departments.department_id%TYPE,
    p_department_name OUT departments.department_name%TYPE
) AS
BEGIN
    SELECT department_name INTO   p_department_name FROM   departments WHERE  department_id = p_department_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_department_name := NULL;
        DBMS_OUTPUT.PUT_LINE('No department found for ID: ' || p_department_id);
END;
/

--H20. Procedure with three OUT parameters: total_salary, avg_salary, employee_count for a given job_id--Hint: SELECT SUM(salary), AVG(salary), COUNT(*) INTO p_total, p_avg, p_count FROM hr.employees WHERE job_id = p_job_id;

CREATE OR REPLACE PROCEDURE get_job_salary_stats (
    p_job_id         IN  VARCHAR2,  
    p_total_salary   OUT NUMBER,   
    p_avg_salary     OUT NUMBER,   
    p_employee_count OUT NUMBER   
) AS
BEGIN

    p_total_salary   := 0;
    p_avg_salary     := 0;
    p_employee_count := 0;

    SELECT NVL(SUM(salary), 0), NVL(AVG(salary), 0), COUNT(*)
    INTO   p_total_salary, p_avg_salary, p_employee_count 
    FROM   employees WHERE  job_id = p_job_id;
END;
/

