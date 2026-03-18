/*Day 20 Assignment: PL/SQL Basics
All exercises use employees (and departments if needed). Use SET SERVEROUTPUT ON before running blocks that use DBMS_OUTPUT.
Part 1: Practice Questions (With Answers and Explanations)*/

/*Question 1
Write an anonymous block that fetches one employee by employee_id (e.g. 100) and prints their first and last name using DBMS_OUTPUT. Use variables and SELECT INTO.
Answer:*/

SET SERVEROUTPUT ON
DECLARE
  v_first_name employees.first_name%TYPE;
  v_last_name  employees.last_name%TYPE;
BEGIN
  SELECT first_name, last_name INTO v_first_name, v_last_name
  FROM employees WHERE employee_id = 100;
  DBMS_OUTPUT.PUT_LINE('Employee: ' || v_first_name || ' ' || v_last_name);
EXCEPTION
  WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Employee not found');
END;
/

--Explanation: %TYPE anchors variable types to the table columns. SELECT INTO populates the variables. DBMS_OUTPUT.PUT_LINE prints the result. NO_DATA_FOUND handles the case when employee_id does not exist.

/*Question 2
Write a block that loops over employees in department_id 50 and prints each employee_id and salary. Use a cursor FOR loop or a simple loop with a cursor.
Answer (cursor FOR loop):*/

SET SERVEROUTPUT ON
DECLARE
  CURSOR c IS SELECT employee_id, salary FROM employees WHERE department_id = 50;
BEGIN
  FOR rec IN c LOOP
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec.employee_id || ', Salary: ' || rec.salary);
  END LOOP;
END;
/

--Explanation: The cursor FOR loop opens, fetches, and closes the cursor. Each row is available as rec; use rec.employee_id and rec.salary.

/*Question 3
Write a block that selects one employee's salary (e.g. employee_id 100) into a variable. Use an IF to print a message if the salary is greater than 15000 (e.g. "High earner").
Answer:*/

SET SERVEROUTPUT ON
DECLARE
  v_salary employees.salary%TYPE;
BEGIN
  SELECT salary INTO v_salary FROM employees WHERE employee_id = 100;
  IF v_salary > 15000 THEN
    DBMS_OUTPUT.PUT_LINE('High earner');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
  END IF;
END;
/

--Explanation: SELECT INTO gets the salary. IF condition checks for > 15000 and prints accordingly.

--Part 2: Self-Practice (No Answers)

--1. Write a FOR loop from 1 to 10 that prints each number using DBMS_OUTPUT.

SET SERVEROUTPUT ON
BEGIN
  FOR rec IN 1..10 LOOP
    DBMS_OUTPUT.PUT_LINE(rec);
  END LOOP;
END;
/

--2. Declare a variable of type employees%ROWTYPE, fetch one row into it (e.g. WHERE employee_id = 101), and print two fields from the row (e.g. first_name, last_name).

SET SERVEROUTPUT ON
DECLARE
  rec employees%ROWTYPE;
BEGIN
  SELECT * into rec FROM employees WHERE employee_id = 100;
  DBMS_OUTPUT.PUT_LINE('First Name: ' || rec.first_name || ', Last NAme: ' || rec.last_name);
END;
/

/*Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)
All use employees and departments; PL/SQL blocks.*/
--20 Medium Questions

--M1. Declare v_count NUMBER; SELECT COUNT(*) INTO v_count FROM employees; print v_count--Hint: BEGIN SELECT COUNT(*) INTO v_count FROM employees; DBMS_OUTPUT.PUT_LINE(v_count); END;

SET SERVEROUTPUT ON
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM employees;
  DBMS_OUTPUT.PUT_LINE(v_count);
END;
/

--M2. Declare v_name VARCHAR2(100); SELECT first_name INTO v_name FROM employees WHERE employee_id = 100; print v_name--Hint: SELECT INTO; DBMS_OUTPUT.PUT_LINE(v_name);

SET SERVEROUTPUT ON
DECLARE
  v_name employees.FIRST_NAME%TYPE;
BEGIN
  SELECT first_name INTO v_name FROM employees WHERE employee_id = 100;
  DBMS_OUTPUT.PUT_LINE('First Name: ' || v_name);
END;
/

--M3. Use %TYPE for variable matching employees.salary--Hint: v_sal employees.salary%TYPE;

SET SERVEROUTPUT ON
DECLARE
  v_salary employees.salary%TYPE;
BEGIN
  SELECT sum(salary) INTO v_salary FROM employees WHERE employee_id = 100;
  DBMS_OUTPUT.PUT_LINE('Total Salary: ' || v_salary);
END;
/

--M4. Use %ROWTYPE for variable holding one row of employees--Hint: v_emp employees%ROWTYPE; SELECT * INTO v_emp FROM employees WHERE employee_id = 100;

SET SERVEROUTPUT ON
DECLARE
  v_emp employees%ROWTYPE;
BEGIN
  SELECT * into v_emp FROM employees WHERE employee_id = 100;
  DBMS_OUTPUT.PUT_LINE('First Name: ' || v_emp.first_name || ', Last NAme: ' || v_emp.last_name);
END;
/

--M5. IF v_salary > 10000 THEN DBMS_OUTPUT.PUT_LINE('High'); ELSE ..--Hint: IF ... THEN ... ELSE ... END IF;

SET SERVEROUTPUT ON
DECLARE
  v_salary employees.salary%TYPE;
BEGIN
  SELECT salary INTO v_salary FROM employees WHERE employee_id = 100;
  IF v_salary > 10000 THEN
    DBMS_OUTPUT.PUT_LINE('High earner');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
  END IF;
END;
/

--M6. FOR i IN 1..5 LOOP DBMS_OUTPUT.PUT_LINE(i); END LOOP; Hint: FOR loop with range.

SET SERVEROUTPUT ON
BEGIN
  FOR rec IN 1..5 LOOP
    DBMS_OUTPUT.PUT_LINE(rec);
  END LOOP;
END;
/

--M7. WHILE i < 10 LOOP i := i + 1; END LOOP; (declare i NUMBER := 0)--Hint: WHILE condition LOOP ... END LOOP;

SET SERVEROUTPUT ON
declare i NUMBER := 0;
BEGIN
  WHILE i < 10 LOOP
    i := i + 1;
    DBMS_OUTPUT.PUT_LINE(i);
  END LOOP;
END;
/

--M8. SELECT first_name, last_name INTO two variables FROM employees WHERE employee_id = 101--Hint: SELECT first_name, last_name INTO v_fname, v_lname FROM ...;

SET SERVEROUTPUT ON
DECLARE
  v_firstname employees.FIRST_NAME%TYPE;
  v_lastname employees.LAST_NAME%TYPE;
BEGIN
  SELECT first_name, last_name INTO v_firstname, v_lastname FROM employees WHERE employee_id = 101;
  DBMS_OUTPUT.PUT_LINE('First Name: ' || v_firstname || ', Last NAme: ' || v_lastname);
END;
/

--M9. Assign v_dept_id := 50; use in SELECT COUNT(*) INTO ... WHERE department_id = v_dept_id--Hint: Use variable in WHERE clause.

SET SERVEROUTPUT ON
DECLARE
  v_dept_id employees.DEPARTMENT_ID%TYPE := 50;
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count from employees WHERE department_id = v_dept_id;
  DBMS_OUTPUT.PUT_LINE(v_count);
END;
/

--M10. LOOP with EXIT WHEN i > 3; i := i + 1; Hint: LOOP ... EXIT WHEN ... END LOOP;

SET SERVEROUTPUT ON;
DECLARE
    i NUMBER := 1; 
BEGIN
    LOOP
        EXIT WHEN i > 3;
        DBMS_OUTPUT.PUT_LINE('i = ' || i);
        i := i + 1;
    END LOOP;
END;
/

--M11. Print 'Hello' and current date (SYSDATE)--Hint: DBMS_OUTPUT.PUT_LINE('Hello ' || TO_CHAR(SYSDATE));

SET SERVEROUTPUT ON;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello ' || TO_CHAR(SYSDATE));
END;
/

--M12. Declare v_emp_id NUMBER := 100; use in SELECT INTO--Hint: WHERE employee_id = v_emp_id;

SET SERVEROUTPUT ON
DECLARE
  v_emp_id NUMBER := 100;
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count from employees WHERE employee_id = v_emp_id;
  DBMS_OUTPUT.PUT_LINE(v_count);
END;
/

--M13. ELSIF: if salary < 5000 then 'Low', elsif salary < 10000 then 'Mid', else 'High'--Hint: IF ... ELSIF ... ELSE ... END IF;

SET SERVEROUTPUT ON
DECLARE
  v_salary employees.salary%TYPE;
BEGIN
  SELECT salary INTO v_salary FROM employees WHERE employee_id = 100;
  IF v_salary < 5000 THEN
    DBMS_OUTPUT.PUT_LINE('Low');
  ELSIF v_salary < 10000 THEN
    DBMS_OUTPUT.PUT_LINE('Mid');
  ELSE
    DBMS_OUTPUT.PUT_LINE('High');
  END IF;
END;
/

--M14. FOR i IN REVERSE 1..5 LOOP (count down)--Hint: FOR i IN REVERSE 1..5 LOOP ...

SET SERVEROUTPUT ON
BEGIN
  FOR rec IN REVERSE 1..5 LOOP
    DBMS_OUTPUT.PUT_LINE(rec);
  END LOOP;
END;
/

--M15. Select department_name INTO variable from departments where department_id = 10--Hint: SELECT department_name INTO v_dname FROM departments WHERE department_id = 10;

SET SERVEROUTPUT ON
DECLARE
  v_dname departments.department_name%TYPE;
BEGIN
  SELECT department_name INTO v_dname FROM departments WHERE department_id = 10;
    DBMS_OUTPUT.PUT_LINE(v_dname);
END;
/


--M16. Declare two variables; assign first with := 1, second with SELECT 2 FROM DUAL INTO--Hint: v1 := 1; SELECT 2 INTO v2 FROM DUAL;

SET SERVEROUTPUT ON
DECLARE
  v_number1 NUMBER := 1;
  v_number2 NUMBER;
BEGIN
  SELECT 2 INTO v_number2 FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('NUmber 1: '|| v_number1 || ' NUmber 2: '|| v_number2);
END;
/

--M17. Print concatenation of two variables (v_fname || ' ' || v_lname)--Hint: DBMS_OUTPUT.PUT_LINE(v_fname || ' ' || v_lname);

SET SERVEROUTPUT ON
DECLARE
  v_firstname employees.FIRST_NAME%TYPE;
  v_lastname employees.LAST_NAME%TYPE;
BEGIN
  SELECT first_name, last_name INTO v_firstname, v_lastname FROM employees WHERE employee_id = 101;
  DBMS_OUTPUT.PUT_LINE('First Name: ' || v_firstname || ', Last NAme: ' || v_lastname);
END;
/

--M18. Use v_emp.first_name and v_emp.last_name from %ROWTYPE variable--Hint: After SELECT * INTO v_emp; use v_emp.first_name.

SET SERVEROUTPUT ON
DECLARE
  v_emp employees%ROWTYPE;
BEGIN
  SELECT * into v_emp FROM employees WHERE employee_id = 100;
  DBMS_OUTPUT.PUT_LINE('First Name: ' || v_emp.first_name || ', Last NAme: ' || v_emp.last_name);
END;
/

--M19. Simple LOOP that runs 3 times (counter and EXIT WHEN)--Hint: i := 0; LOOP i := i+1; EXIT WHEN i > 3; ... END LOOP;

SET SERVEROUTPUT ON;
DECLARE
    i NUMBER := 0; 
BEGIN
    LOOP
        i := i + 1;        
        EXIT WHEN i > 3;
          DBMS_OUTPUT.PUT_LINE('i = ' || i);
    END LOOP;
END;
/

--M20. IF v_count > 0 THEN ... ELSE ..--Hint: Condition with variable.

SET SERVEROUTPUT ON
DECLARE
  v_emp_id NUMBER := 80;
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count from employees WHERE employee_id = v_emp_id;
  IF v_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Number of Employees: '||v_count);
  else
    DBMS_OUTPUT.PUT_LINE('No Employees');
  END IF;
END;
/


--20 Hard Questions

--H1. Loop through employee_id 100 to 105; for each, SELECT salary INTO variable and print employee_id and salary--Hint: FOR id IN 100..105 LOOP SELECT salary INTO v_sal FROM employees WHERE employee_id = id; DBMS_OUTPUT.PUT_LINE(id || ' ' || v_sal); END LOOP;

SET SERVEROUTPUT ON
DECLARE
  v_emp_id NUMBER := 100;
  v_salary employees.salary%TYPE;
BEGIN
  LOOP
    SELECT salary INTO v_salary from employees WHERE employee_id = v_emp_id;
    DBMS_OUTPUT.PUT_LINE('Employee ID: '||v_emp_id|| ' and Salary: '|| v_salary);
    v_emp_id := v_emp_id + 1;        
    EXIT WHEN v_emp_id > 105;
  END LOOP;
END;
/

--H2. Use EXCEPTION WHEN NO_DATA_FOUND THEN print 'Not found'--Hint: EXCEPTION WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Not found');

SET SERVEROUTPUT ON
DECLARE
  v_first_name employees.first_name%TYPE;
  v_last_name  employees.last_name%TYPE;
BEGIN
  SELECT first_name, last_name INTO v_first_name, v_last_name
  FROM employees WHERE employee_id = 100;
  DBMS_OUTPUT.PUT_LINE('Employee: ' || v_first_name || ' ' || v_last_name);
EXCEPTION
  WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Employee not found');
END;
/

--H3. Declare record type with employee_id, first_name, last_name; select into it--Hint: TYPE t_emp IS RECORD (employee_id NUMBER, first_name VARCHAR2(20), last_name VARCHAR2(25)); v_rec t_emp; SELECT employee_id, first_name, last_name INTO v_rec FROM ...

SET SERVEROUTPUT ON
DECLARE
  TYPE t_emp IS RECORD (employee_id NUMBER, first_name VARCHAR2(20), last_name VARCHAR2(25));
  v_rec t_emp;
BEGIN
  SELECT employee_id, first_name , last_name into v_rec FROM employees WHERE employee_id = 100;
  DBMS_OUTPUT.PUT_LINE('Employee ID: '||v_rec.employee_id||', First Name: ' || v_rec.first_name || ', Last NAme: ' || v_rec.last_name);
END;
/

--H4. WHILE loop: fetch employees where department_id = 50 until no rows (use cursor or BULK COLLECT LIMIT 1)--Hint: Use explicit cursor; OPEN; LOOP FETCH ... EXIT WHEN cursor%NOTFOUND; ... END LOOP; CLOSE;

SET SERVEROUTPUT ON;
DECLARE
    TYPE emp_rec IS RECORD (employee_id employees.employee_id%TYPE, first_name  employees.first_name%TYPE, last_name   employees.last_name%TYPE);
    TYPE emp_tab IS TABLE OF emp_rec;
    v_emps emp_tab;
    CURSOR c_emp IS SELECT employee_id, first_name, last_name FROM employees WHERE department_id = 50;
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp BULK COLLECT INTO v_emps LIMIT 1;
        EXIT WHEN v_emps.COUNT = 0;
        FOR i IN 1 .. v_emps.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Emp ID: ' || v_emps(i).employee_id ||
                ', Name: ' || v_emps(i).first_name || ' ' || v_emps(i).last_name
            );
        END LOOP;
    END LOOP;
    CLOSE c_emp;
END;
/

--H5. Nested IF: if dept_id = 50 then if salary > 5000 then 'A' else 'B'; else 'C'--Hint: IF ... THEN IF ... THEN ... ELSE ... END IF; ELSE ... END IF;
     
SET SERVEROUTPUT ON;
DECLARE
    TYPE emp_rec IS RECORD (employee_id employees.employee_id%TYPE, salary employees.salary%TYPE);
    TYPE emp_tab IS TABLE OF emp_rec;
    v_emps emp_tab;
    CURSOR c_emp IS SELECT employee_id, salary FROM employees WHERE department_id = 50;
    result  CHAR(1);
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp BULK COLLECT INTO v_emps LIMIT 1;
        EXIT WHEN v_emps.COUNT = 0;
        FOR i IN 1 .. v_emps.COUNT LOOP
            if v_emps(i).salary > 5000 then result := 'A'; ELSE result := 'B'; END IF;
            DBMS_OUTPUT.PUT_LINE('Emp ID: ' || v_emps(i).employee_id ||', Salary category: ' || result);
        END LOOP;
    END LOOP;
    CLOSE c_emp;
END;
/

--H6. Assign v_total := 0; loop 1 to 10, v_total := v_total + i; print v_total at end--Hint: FOR i IN 1..10 LOOP v_total := v_total + i; END LOOP;

SET SERVEROUTPUT ON;
DECLARE
    v_total NUMBER := 0;  
BEGIN
    FOR i IN 1..10 LOOP
        v_total := v_total + i;  
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total sum from 1 to 10 is: ' || v_total);
END;
/

--H7. SELECT COUNT(*) INTO v_c FROM employees WHERE department_id = v_dept_id; use v_dept_id from another SELECT--Hint: First get v_dept_id (e.g. from departments), then use in second query.

SET SERVEROUTPUT ON;
DECLARE
    v_dept_id   employees.department_id%TYPE;
    v_c         NUMBER;
BEGIN
    SELECT department_id INTO v_dept_id FROM departments WHERE department_name = 'Administration';
    SELECT COUNT(*) INTO v_c FROM employees WHERE department_id = v_dept_id;
    DBMS_OUTPUT.PUT_LINE('Department ID: ' || v_dept_id);
    DBMS_OUTPUT.PUT_LINE('Employee Count: ' || v_c);
END;
/
--select * from departments;

--H8. Declare CONSTANT v_max NUMBER := 100; use in IF condition--Hint: v_max CONSTANT NUMBER := 100; IF v_salary > v_max THEN ...

SET SERVEROUTPUT ON;
DECLARE
    v_max CONSTANT NUMBER := 100;
    v_salary NUMBER; 
BEGIN
  select salary into v_salary from employees where employee_id = 100; 
  IF v_salary < v_max THEN
      DBMS_OUTPUT.PUT_LINE('Value ' || v_salary || ' is less than v_max (' || v_max || ').');
  ELSIF v_salary = v_max THEN
      DBMS_OUTPUT.PUT_LINE('Value equals v_max.');
  ELSE
      DBMS_OUTPUT.PUT_LINE('Value is greater than v_max.');
  END IF;
END;
/

--H9. Use SQL%ROWCOUNT after UPDATE employees SET ... WHERE ...; print number of rows updated--Hint: UPDATE ... ; DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);

SET SERVEROUTPUT ON;
BEGIN
    UPDATE employees SET salary = salary * 1.10 WHERE department_id = 50;

   DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' row(s) updated.');
END;
/

--H10. FOR rec IN (SELECT employee_id, first_name FROM employees WHERE ROWNUM <= 5) LOOP print rec.employee_id, rec.first_name--Hint: FOR rec IN (SELECT ... ) LOOP ... END LOOP;

SET SERVEROUTPUT ON;

BEGIN
    FOR rec IN (SELECT employee_id, first_name FROM employees WHERE ROWNUM <= 5) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.employee_id || ', Name: ' || rec.first_name);
    END LOOP;
END;
/

--H11. Declare v_date DATE := SYSDATE; print it with TO_CHAR--Hint: DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_date, 'DD-MON-YYYY'));

BEGIN
    DECLARE
        v_date DATE := SYSDATE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_date, 'DD-MON-YYYY'));
    END;
END;
/

--H12. IF v_emp.salary IS NULL THEN ..--Hint: Handle NULL in record field.

SET SERVEROUTPUT ON

DECLARE
  CURSOR c IS SELECT employee_id, salary FROM employees WHERE department_id = 50;
BEGIN
  FOR rec IN c LOOP
    IF rec.salary IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Salary is not available for Employee ID: '||rec.employee_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Salary is: ' || rec.salary||' for Employee ID: '||rec.employee_id);
    END IF;
  END LOOP;
END;
/

--H13. Loop: i from 1 to 10; if i mod 2 = 0 then print i--Hint: IF MOD(i, 2) = 0 THEN DBMS_OUTPUT.PUT_LINE(i); END IF;

SET SERVEROUTPUT ON;
BEGIN
    FOR i IN 1..10 LOOP
        IF MOD(i, 2) = 0 THEN
            DBMS_OUTPUT.PUT_LINE(i);
        END IF;
    END LOOP;
END;
/

--H14. Select into %ROWTYPE; then update another variable from v_emp.salary * 1.1--Hint: v_new_sal := v_emp.salary * 1.1;

DECLARE
    v_emp employees%ROWTYPE;
    v_new_salary employees.salary%TYPE;
BEGIN
    SELECT * INTO v_emp FROM employees WHERE employee_id = 101; 
    v_new_salary := v_emp.salary * 1.1;
    DBMS_OUTPUT.PUT_LINE('Employee: ' || v_emp.first_name || ' ' || v_emp.last_name);
    DBMS_OUTPUT.PUT_LINE('Old Salary: ' || v_emp.salary);
    DBMS_OUTPUT.PUT_LINE('New Salary: ' || v_new_salary);
END;
/

--H15. EXIT WHEN condition in the middle of LOOP (e.g. when v_count > 5)--Hint: LOOP ... v_count := v_count + 1; EXIT WHEN v_count > 5; ... END LOOP;

SET SERVEROUTPUT ON;
DECLARE
    v_total NUMBER := 0;  
BEGIN
    FOR i IN 1..10 LOOP
        v_total := v_total + i;  
      exit when v_total > 5;
      DBMS_OUTPUT.PUT_LINE('Total sum from 1 to '||i||' is: ' || v_total);
    END LOOP;
END;
/

--H16. Declare v_result VARCHAR2(100); use CASE in PL/SQL: v_result := CASE WHEN v_sal < 5000 THEN 'Low' WHEN v_sal < 10000 THEN 'Mid' ELSE 'High' END; Hint: Assignment with CASE expression.

SET SERVEROUTPUT ON;
DECLARE
    TYPE emp_rec IS RECORD (employee_id employees.employee_id%TYPE, salary employees.salary%TYPE);
    TYPE emp_tab IS TABLE OF emp_rec;
    v_emps emp_tab;
    CURSOR c_emp IS SELECT employee_id, salary FROM employees WHERE department_id = 50;
    v_result  VARCHAR2(100);
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp BULK COLLECT INTO v_emps LIMIT 1;
        EXIT WHEN v_emps.COUNT = 0;
        FOR i IN 1 .. v_emps.COUNT LOOP
            v_result :=  case when v_emps(i).salary < 5000 then 'Low' WHEN v_emps(i).salary < 10000 THEN 'Mid' ELSE 'High' END;
            DBMS_OUTPUT.PUT_LINE('Emp ID: ' || v_emps(i).employee_id ||', Salary category: ' || v_result);
        END LOOP;
    END LOOP;
    CLOSE c_emp;
END;
/

--H17. Nested FOR: outer 1..2, inner 1..3; print outer and inner--Hint: FOR o IN 1..2 LOOP FOR i IN 1..3 LOOP DBMS_OUTPUT.PUT_LINE(o || ',' || i); END LOOP; END LOOP;

SET SERVEROUTPUT ON;
BEGIN
  FOR o IN 1..2 LOOP
    FOR i IN 1..3 LOOP
      DBMS_OUTPUT.PUT_LINE(o || ',' || i);
    END LOOP;
  END LOOP;
END;
/

--H18. SELECT department_id INTO v_did FROM departments WHERE department_name = 'Sales'; then use v_did in SELECT COUNT(*) FROM employees WHERE department_id = v_did--Hint: Two SELECT INTOs; use first result in second.

DECLARE
    v_did   departments.department_id%TYPE;
    v_count NUMBER;
BEGIN
    SELECT department_id INTO v_did FROM departments WHERE department_name = 'Sales';
    SELECT COUNT(*) INTO v_count FROM employees WHERE department_id = v_did;

    DBMS_OUTPUT.PUT_LINE('Department ID: ' || v_did);
    DBMS_OUTPUT.PUT_LINE('Number of employees: ' || v_count);
END;
/

--H19. Use BIND variable in PL/SQL (e.g. in EXECUTE IMMEDIATE 'SELECT salary FROM employees WHERE employee_id = :1' INTO v_sal USING v_id)--Hint: EXECUTE IMMEDIATE '...' INTO ... USING ...;

SET SERVEROUTPUT ON;
DECLARE
    v_id   employees.employee_id%TYPE := 101; 
    v_sal  employees.salary%TYPE;            
BEGIN
    EXECUTE IMMEDIATE
      'SELECT salary FROM employees WHERE employee_id = :1' INTO v_sal USING v_id;  
    DBMS_OUTPUT.PUT_LINE('Salary for employee ' || v_id || ' is: ' || v_sal);
END;
/

--H20. Block that only runs if v_flag = 1 (IF v_flag = 1 THEN ... entire logic ... END IF)--Hint: Wrap main logic in IF condition.

DECLARE
    v_flag NUMBER := 1;
    v_result NUMBER;
BEGIN
    IF v_flag = 1 THEN
        DBMS_OUTPUT.PUT_LINE('v_flag is 1, executing logic...');
        v_result := 10 * 5;
        DBMS_OUTPUT.PUT_LINE('Result is: ' || v_result);
        v_result := v_result + 100;
        DBMS_OUTPUT.PUT_LINE('Updated result: ' || v_result);
    END IF;
    DBMS_OUTPUT.PUT_LINE('End of program.');
END;
/

