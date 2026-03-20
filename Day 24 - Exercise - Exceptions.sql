/*Day 24 Assignment: Exception Handling
All exercises use employees and departments.
Part 1: Practice/*Question s (With Answers and Explanations)*/

/*Question  1
Write a block that selects an employee by employee_id (use a variable, e.g. 99999) into first_name and last_name--Handle NO_DATA_FOUND and print a message like "Employee not found."
Answer:*/

DECLARE
  v_id NUMBER := 99999;
  v_fname employees.first_name%TYPE;
  v_lname employees.last_name%TYPE;
BEGIN
  SELECT first_name, last_name INTO v_fname, v_lname FROM employees WHERE employee_id = v_id;
  DBMS_OUTPUT.PUT_LINE(v_fname || ' ' || v_lname);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee not found.');
END;
/

--Explanation: SELECT INTO raises NO_DATA_FOUND when no row is returned. The EXCEPTION section catches it and prints a message instead of propagating the error.

/*Question  2
Write a block that fetches one employee's salary. If the salary is greater than 50000, raise a custom exception (declare it in DECLARE) and handle it by printing "Salary exceeds limit." Otherwise print the salary.
Answer:*/

DECLARE
  v_salary employees.salary%TYPE;
  e_high_salary EXCEPTION;
BEGIN
  SELECT salary INTO v_salary FROM employees WHERE employee_id = 100;
  IF v_salary > 50000 THEN
    RAISE e_high_salary;
  END IF;
  DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
EXCEPTION
  WHEN e_high_salary THEN
    DBMS_OUTPUT.PUT_LINE('Salary exceeds limit.');
END;
/

--Explanation: Declare EXCEPTION e_high_salary. After SELECT INTO, IF salary > 50000 THEN RAISE e_high_salary. In EXCEPTION, WHEN e_high_salary THEN handle with a message.

/*Question  3
In a block, use RAISE_APPLICATION_ERROR(-20001, 'Your message') when a condition is met (e.g. when department_id from a SELECT is NULL). Pass a clear error message.
Answer:*/

DECLARE
  v_dept_id employees.department_id%TYPE;
BEGIN
  SELECT department_id INTO v_dept_id FROM employees WHERE employee_id = 178;
  IF v_dept_id IS NULL THEN
    RAISE_APPLICATION_ERROR(-20001, 'Employee has no department assigned.');
  END IF;
  DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept_id);
END;
/

--Explanation: RAISE_APPLICATION_ERROR stops execution and returns error code -20001 (in range -20000 to -20999) and the message to the client. No handler is required; the error propagates.

/*Part 2: Self-Practice (No Answers)*/

--1. Write a block that does SELECT INTO for a query that can return more than one row (e.g. by job_id)--Handle TOO_MANY_ROWS and print a message.

DECLARE
    TYPE emp_rec IS RECORD (
        employee_id employees.employee_id%TYPE,
        first_name  employees.first_name%TYPE,
        job_id      employees.job_id%TYPE
    );
    TYPE emp_table IS TABLE OF emp_rec;

    v_emps emp_table; 
BEGIN
    SELECT employee_id, first_name, job_id
    BULK COLLECT INTO v_emps
    FROM employees WHERE job_id = 'IT_PROG';

    IF v_emps.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No employees found for job_id IT_PROG.');
    ELSE
        FOR i IN 1 .. v_emps.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('ID: ' || v_emps(i).employee_id ||', Name: ' || v_emps(i).first_name ||', Job: ' || v_emps(i).job_id);
        END LOOP;
    END IF;
END;
/

--2. In an exception handler, re-raise the exception after logging (e.g. DBMS_OUTPUT or INSERT into a log table) using RAISE; so the caller still sees the error.

WHEN exception_name THEN
RAISE exception_name;
END;


/*Part 3: Additional Practice — 20 Medium + 20 Hard/*Question s (With Hints)
All use employees and departments.
20 Medium Questions*/

--M1. SELECT first_name INTO v FROM employees WHERE employee_id = 99999; handle NO_DATA_FOUND--Hint: EXCEPTION WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Not found');

DECLARE
    v_first_name employees.first_name%TYPE;
BEGIN
    BEGIN
        SELECT first_name
        INTO v_first_name
        FROM employees
        WHERE employee_id = 99999;

        DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_first_name);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No employee found with the given ID.');
    END;
END;
/

--M2. IF v_salary > 50000 THEN RAISE_APPLICATION_ERROR(-20001, 'Too high'); Hint: RAISE_APPLICATION_ERROR in range -20000 to -20999.

SET SERVEROUTPUT ON;

DECLARE
    v_salary NUMBER := 60000;
BEGIN
    IF v_salary > 50000 THEN

        RAISE_APPLICATION_ERROR(
            -20001, 
            'Salary is too high. Maximum allowed is 50000.'
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE('Salary is within the allowed range.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);
END;
/

--M3. Declare e_my_err EXCEPTION; raise it in block; handle WHEN e_my_err--Hint: DECLARE e_my_err EXCEPTION; BEGIN ... RAISE e_my_err; EXCEPTION WHEN e_my_err THEN ...

SET SERVEROUTPUT ON;

DECLARE
    e_my_err EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Starting block...');

    RAISE e_my_err;

    DBMS_OUTPUT.PUT_LINE('This will not be printed.');

EXCEPTION
    WHEN e_my_err THEN
        DBMS_OUTPUT.PUT_LINE('Caught the user-defined exception: e_my_err');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/

--M4--Handle TOO_MANY_ROWS when SELECT INTO by job_id--Hint: SELECT ... INTO v FROM employees WHERE job_id = 'SA_REP'; EXCEPTION WHEN TOO_MANY_ROWS THEN ...

SET SERVEROUTPUT ON;

DECLARE
    v_employee_name   employees.first_name%TYPE;
    v_job_id          employees.job_id%TYPE := 'IT_PROG'; 
BEGIN
    BEGIN
        SELECT first_name INTO v_employee_name FROM employees WHERE job_id = v_job_id;

        DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_employee_name);

    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE(
                'Error: More than one employee found for job_id = ' || v_job_id
            );
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE(
                'No employee found for job_id = ' || v_job_id
            );
    END;
END;
/

--M5. In OTHERS handler print SQLERRM--Hint: WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);

DECLARE
    v_num   NUMBER := 10;
    v_denom NUMBER := 0;
    v_result NUMBER;
BEGIN
    v_result := v_num / v_denom;

    DBMS_OUTPUT.PUT_LINE('Result: ' || v_result);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SQLERRM);

END;
/

--M6. RAISE_APPLICATION_ERROR when department_id from SELECT is NULL--Hint: IF v_dept_id IS NULL THEN RAISE_APPLICATION_ERROR(-20001, 'No department');

DECLARE
    v_department_id departments.department_id%TYPE;
    v_employee_id   employees.employee_id%TYPE := 101; 
BEGIN
    SELECT department_id INTO v_department_id FROM employees WHERE employee_id = v_employee_id;

    IF v_department_id IS NULL THEN
        RAISE_APPLICATION_ERROR(
            -20001, 
            'Department ID is NULL for employee ID ' || v_employee_id
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE('Department ID: ' || v_department_id);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20002, 
            'No employee found with ID ' || v_employee_id
        );
END;
/

--M7--Handle DUP_VAL_ON_INDEX in block that inserts--Hint: EXCEPTION WHEN DUP_VAL_ON_INDEX THEN ...

CREATE TABLE employees (
    emp_id   NUMBER PRIMARY KEY,
    emp_name VARCHAR2(50) NOT NULL
);

INSERT INTO employees (emp_id, emp_name) VALUES (1, 'Alice');
COMMIT;

DECLARE
    v_emp_id   employees.emp_id%TYPE := 1; 
    v_emp_name employees.emp_name%TYPE := 'Bob';
BEGIN
    BEGIN
        INSERT INTO employees (emp_id, emp_name)
        VALUES (v_emp_id, v_emp_name);

        DBMS_OUTPUT.PUT_LINE('Employee inserted successfully.');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE(
                'Error: Duplicate value for EMP_ID ' || v_emp_id ||
                '. Record not inserted.'
            );
    END;
END;
/

--M8. After handling exception, re-raise with RAISE; Hint: WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM); RAISE;

SET SERVEROUTPUT ON;

DECLARE
    v_num NUMBER := 10;
    v_den NUMBER := 0; 
BEGIN
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Starting calculation...');
        DBMS_OUTPUT.PUT_LINE('Result: ' || (v_num / v_den));
        
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            DBMS_OUTPUT.PUT_LINE('Error: Division by zero occurred. Logging and re-raising...');
            
            RAISE;
    END;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Outer block caught exception: ' || SQLERRM);
END;
/

--M9--Handle ZERO_DIVIDE--Hint: WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('Division by zero');

DECLARE
    numerator   NUMBER := 100;
    denominator NUMBER := 0;
    result      NUMBER;
BEGIN
    result := numerator / denominator;

    DBMS_OUTPUT.PUT_LINE('Result: ' || result);

EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Error: Division by zero is not allowed.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/

--M10. Custom exception e_no_emp; raise when SELECT COUNT(*) = 0 for department--Hint: IF v_count = 0 THEN RAISE e_no_emp;

DECLARE
    v_dept_id   NUMBER := 50; 
    v_emp_count NUMBER;

    e_no_emp EXCEPTION;

BEGIN
    SELECT COUNT(*) INTO v_emp_count FROM employees WHERE department_id = v_dept_id;

    IF v_emp_count = 0 THEN
        RAISE e_no_emp;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Department ' || v_dept_id || 
                             ' has ' || v_emp_count || ' employees.');
    END IF;

EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('No employees found in department ' || v_dept_id || '.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Department ID ' || v_dept_id || ' does not exist.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/

--M11. PRAGMA EXCEPTION_INIT for -2291 (foreign key violation)--Hint: e_fk EXCEPTION; PRAGMA EXCEPTION_INIT(e_fk, -2291);



--M12. In function, WHEN NO_DATA_FOUND THEN RETURN NULL--Hint: EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;

CREATE OR REPLACE FUNCTION get_employee_name(p_emp_id NUMBER)
RETURN VARCHAR2
IS
    v_name employees.emp_name%TYPE;
BEGIN
    SELECT emp_name INTO v_name FROM employees WHERE emp_id = p_emp_id;
    RETURN v_name;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RETURN NULL;
END;
/

SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('ID 1: ' || NVL(get_employee_name(1), 'Not Found'));
    DBMS_OUTPUT.PUT_LINE('ID 3: ' || NVL(get_employee_name(3), 'Not Found'));
END;
/

--M13. Nested block: inner block raises; outer block handles--Hint: BEGIN BEGIN ... RAISE e; END; EXCEPTION WHEN e THEN ... END;

SET SERVEROUTPUT ON;

DECLARE
    v_outer_msg VARCHAR2(50) := 'Outer block variable';

BEGIN
    DBMS_OUTPUT.PUT_LINE('Outer block started');

    DECLARE
        v_inner_msg VARCHAR2(50) := 'Inner block variable';
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Inner block started');
        DBMS_OUTPUT.PUT_LINE('Inner message: ' || v_inner_msg);

        DBMS_OUTPUT.PUT_LINE('About to raise exception...');
        RAISE ZERO_DIVIDE;

        DBMS_OUTPUT.PUT_LINE('This line will not execute');

    EXCEPTION
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('Inner block handled VALUE_ERROR');
    END;

    DBMS_OUTPUT.PUT_LINE('This line will not execute if ZERO_DIVIDE propagates');

EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Outer block handled ZERO_DIVIDE');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Outer block handled some other exception: ' || SQLERRM);
END;
/

--M14--Handle VALUE_ERROR (e.g. string to number conversion)--Hint: WHEN VALUE_ERROR THEN ...

SET SERVEROUTPUT ON;

DECLARE
    v_input   VARCHAR2(20) := '123ABC'; 
    v_number  NUMBER;
BEGIN
    BEGIN
        v_number := TO_NUMBER(v_input);
        DBMS_OUTPUT.PUT_LINE('Converted number: ' || v_number);
    EXCEPTION
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('VALUE_ERROR: "' || v_input || '" is not a valid number.');
            v_number := 0;
    END;

    DBMS_OUTPUT.PUT_LINE('Final value used: ' || v_number);

END;
/

--M15. RAISE_APPLICATION_ERROR with user message including variable: 'Employee ' || v_id || ' not found'--Hint: RAISE_APPLICATION_ERROR(-20001, 'Employee ' || v_id || ' not found');



--M16. Two handlers: first NO_DATA_FOUND, then OTHERS--Hint: WHEN NO_DATA_FOUND THEN ... WHEN OTHERS THEN ...

SET SERVEROUTPUT ON;

DECLARE
    v_emp_name   employees.first_name%TYPE;
    v_emp_id     NUMBER := 9999;

BEGIN
    SELECT first_name INTO v_emp_name FROM employees WHERE employee_id = v_emp_id;

    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_emp_name);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No employee found with ID ' || v_emp_id);

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/

--M17. In procedure, if SQL%ROWCOUNT = 0 then RAISE_APPLICATION_ERROR--Hint: IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(-20001, 'No rows updated');

CREATE OR REPLACE PROCEDURE update_employee_salary (
    p_emp_id   IN employees.employee_id%TYPE,
    p_new_sal  IN employees.salary%TYPE
) AS
BEGIN
    UPDATE employees SET salary = p_new_sal WHERE employee_id = p_emp_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'No employee found with ID ' || p_emp_id
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE('Salary updated successfully for employee ID ' || p_emp_id);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RAISE;
END;
/

--M18--Handle INVALID_CURSOR (e.g. fetch from closed cursor)--Hint: WHEN INVALID_CURSOR THEN ...



--M19. Log error then re-raise: INSERT INTO log_table (err_msg) VALUES (SQLERRM); RAISE; Hint: Use autonomous transaction if inserting in same table context.

CREATE TABLE log_table (
    log_id     NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    err_msg    VARCHAR2(4000),
    log_date   TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- 2. PL/SQL block that logs the error and re-raises it

DECLARE
    v_dividend NUMBER := 10;
    v_divisor  NUMBER := 0;
    v_result   NUMBER;
BEGIN
    v_result := v_dividend / v_divisor;

EXCEPTION
    WHEN OTHERS THEN
        BEGIN
            INSERT INTO log_table (err_msg)
            VALUES (SQLERRM); 
            COMMIT; 
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        RAISE;
END;
/

--M20. Custom exception with PRAGMA for ORA-01403 (NO_DATA_FOUND)--Hint: e_none EXCEPTION; PRAGMA EXCEPTION_INIT(e_none, -1403);

SET SERVEROUTPUT ON;

DECLARE
    e_no_data_found_custom EXCEPTION;

    PRAGMA EXCEPTION_INIT(e_no_data_found_custom, -1403);

    v_emp_name employees.first_name%TYPE;

BEGIN
    SELECT first_name INTO v_emp_name FROM employees WHERE employee_id = -1; 

    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_emp_name);

EXCEPTION
    WHEN e_no_data_found_custom THEN
        DBMS_OUTPUT.PUT_LINE('Custom Handler: No matching employee found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/


--20 Hard Questions

--H1. Chain exceptions: in OTHERS get SQLCODE/SQLERRM, raise with RAISE_APPLICATION_ERROR(-20002, SQLERRM) to preserve message--Hint: WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20002, SQLERRM);



--H2. Autonomous transaction procedure to log errors: log_err(p_msg); COMMIT in log_err so main transaction can roll back but log persists--Hint: PRAGMA AUTONOMOUS_TRANSACTION; INSERT INTO log_table ...; COMMIT;

CREATE TABLE error_log (
    log_id      NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    log_date    TIMESTAMP DEFAULT SYSTIMESTAMP,
    error_msg   VARCHAR2(4000)
);

CREATE OR REPLACE PROCEDURE log_err(p_msg IN VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION; 
BEGIN
    INSERT INTO error_log (error_msg)
    VALUES (p_msg);

    COMMIT; 
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END log_err;
/

--H3--Handle multiple Oracle errors with one PRAGMA each: -1 (unique), -2291 (FK), -1407 (cannot insert NULL)--Hint: Declare three exceptions with three PRAGMA EXCEPTION_INIT.



--H4. In loop, continue on NO_DATA_FOUND (fetch next), exit on others--Hint: BEGIN ... FETCH ... EXCEPTION WHEN NO_DATA_FOUND THEN EXIT; WHEN OTHERS THEN RAISE; END;

DECLARE
    v_name   VARCHAR2(100);
BEGIN
  FOR i IN 1 .. 10 LOOP
    BEGIN
        SELECT ename INTO v_name FROM emp WHERE empid = i;

        DBMS_OUTPUT.PUT_LINE('ID ' || i || ': ' || v_name);

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('ID ' || i || ': No data found, skipping...');
          CONTINUE; 

      WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Unexpected error at ID ' || i || ': ' || SQLERRM);
          EXIT;
    END;
  END LOOP;
END;
/

--H5. Function that returns VARCHAR2: on NO_DATA_FOUND return 'N/A', else return department_name--Hint: EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 'N/A';

CREATE OR REPLACE FUNCTION get_department_name (
    p_department_id IN departments.department_id%TYPE
) RETURN VARCHAR2
IS
    v_department_name departments.department_name%TYPE;
BEGIN
    SELECT department_name INTO v_department_name FROM departments WHERE department_id = p_department_id;

    RETURN v_department_name;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'N/A';
    WHEN OTHERS THEN
        RETURN 'ERROR';
END;
/

--H6. Save exception in variable: e EXCEPTION; v_code NUMBER; v_msg VARCHAR2(4000); in OTHERS: v_code := SQLCODE; v_msg := SQLERRM; then process--Hint: Store in variables for later use (e.g. log).

DECLARE
    e           EXCEPTION;           
    v_code      NUMBER;              
    v_msg       VARCHAR2(4000);     

BEGIN
    DECLARE
        v_num NUMBER := 10;
        v_den NUMBER := 0;
        v_res NUMBER;
    BEGIN
        v_res := v_num / v_den;  
    END;

EXCEPTION
    WHEN OTHERS THEN
        v_code := SQLCODE;   
        v_msg  := SQLERRM;     

        DBMS_OUTPUT.PUT_LINE('Error Code: ' || v_code);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || v_msg);

        RAISE_APPLICATION_ERROR(-20001, 'Custom Error: ' || v_msg);
END;
/

--H7. RAISE_APPLICATION_ERROR when salary < 0 in trigger or procedure--Hint: IF :NEW.salary < 0 THEN RAISE_APPLICATION_ERROR(-20002, 'Salary cannot be negative');

CREATE OR REPLACE TRIGGER trg_check_salary
BEFORE INSERT OR UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
    IF :NEW.salary < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary cannot be negative.');
    END IF;
END;
/

--H8--Handle CURSOR_ALREADY_OPEN (open same cursor twice without close)--Hint: WHEN CURSOR_ALREADY_OPEN THEN CLOSE c; then re-open or skip.

SET SERVEROUTPUT ON;

DECLARE
    CURSOR emp_cur IS
        SELECT employee_id, first_name FROM employees WHERE ROWNUM <= 3;

    v_emp_id   employees.employee_id%TYPE;
    v_fname    employees.first_name%TYPE;

BEGIN
    OPEN emp_cur;
    DBMS_OUTPUT.PUT_LINE('Cursor opened first time.');

    BEGIN
        OPEN emp_cur;
    EXCEPTION
        WHEN CURSOR_ALREADY_OPEN THEN
            DBMS_OUTPUT.PUT_LINE('Error: Cursor is already open. Closing and reopening...');
            CLOSE emp_cur; 
            OPEN emp_cur;  
    END;

    LOOP
        FETCH emp_cur INTO v_emp_id, v_fname;
        EXIT WHEN emp_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Emp ID: ' || v_emp_id || ', Name: ' || v_fname);
    END LOOP;

    CLOSE emp_cur;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
        IF emp_cur%ISOPEN THEN
            CLOSE emp_cur;
        END IF;
END;
/

--H9. Nested block: inner raises OTHERS and re-raises; outer catches and logs--Hint: Outer EXCEPTION WHEN OTHERS THEN log; (inner already re-raised).



--H10. Create custom error codes -20001 to -20005 for different business rules; document--Hint: RAISE_APPLICATION_ERROR(-20001, 'Rule 1'); etc.



--H11. In trigger, RAISE_APPLICATION_ERROR to abort DML--Hint: IF :NEW.salary < :OLD.salary THEN RAISE_APPLICATION_ERROR(-20002, 'No decrease');



--H12. Procedure with OUT parameter for error message; on exception set p_err := SQLERRM and don't re-raise--Hint: EXCEPTION WHEN OTHERS THEN p_err := SQLERRM; (no RAISE)



--H13--Handle ROWTYPE_MISMATCH (fetch into wrong type)--Hint: WHEN ROWTYPE_MISMATCH THEN ...



--H14. Retry logic: on deadlock (ORA-00060) retry 3 times--Hint: FOR i IN 1..3 LOOP BEGIN ... EXIT; EXCEPTION WHEN OTHERS THEN IF SQLCODE = -60 AND i < 3 THEN ... ELSE RAISE; END IF; END; END LOOP;



--H15. Exception that carries a number: custom record type with (code NUMBER, msg VARCHAR2); raise with that--Hint: Use RAISE_APPLICATION_ERROR with code and message; or custom record in package.



--H16. In OTHERS, check SQLCODE and handle only -1 (unique), else RAISE--Hint: WHEN OTHERS THEN IF SQLCODE = -1 THEN ... ELSE RAISE; END IF;



--H17. Procedure that returns success/failure in OUT; on any exception set success := 0 and err_msg := SQLERRM--Hint: p_ok OUT NUMBER, p_err OUT VARCHAR2; EXCEPTION WHEN OTHERS THEN p_ok := 0; p_err := SQLERRM;



--H18. PRAGMA EXCEPTION_INIT for ORA-02292 (child record exists)--Hint: e_child EXCEPTION; PRAGMA EXCEPTION_INIT(e_child, -2292);



--H19. Block that handles NO_DATA_FOUND and sets default value then continues (e.g. v_name := 'Unknown')--Hint: WHEN NO_DATA_FOUND THEN v_name := 'Unknown'; (then use v_name below — need structure so execution continues).



--H20. Raise custom exception from nested block; outer handles and raises different RAISE_APPLICATION_ERROR with custom message--Hint: Inner RAISE e_custom; outer WHEN e_custom THEN RAISE_APPLICATION_ERROR(-20003, 'Business rule failed');



