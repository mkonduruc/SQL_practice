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



--H2. Use EXCEPTION WHEN NO_DATA_FOUND THEN print 'Not found'--Hint: EXCEPTION WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Not found');



--H3. Declare record type with employee_id, first_name, last_name; select into it--Hint: TYPE t_emp IS RECORD (employee_id NUMBER, first_name VARCHAR2(20), last_name VARCHAR2(25)); v_rec t_emp; SELECT employee_id, first_name, last_name INTO v_rec FROM ...



--H4. WHILE loop: fetch employees where department_id = 50 until no rows (use cursor or BULK COLLECT LIMIT 1)--Hint: Use explicit cursor; OPEN; LOOP FETCH ... EXIT WHEN cursor%NOTFOUND; ... END LOOP; CLOSE;



--H5. Nested IF: if dept_id = 50 then if salary > 5000 then 'A' else 'B'; else 'C'--Hint: IF ... THEN IF ... THEN ... ELSE ... END IF; ELSE ... END IF;



--H6. Assign v_total := 0; loop 1 to 10, v_total := v_total + i; print v_total at end--Hint: FOR i IN 1..10 LOOP v_total := v_total + i; END LOOP;



--H7. SELECT COUNT(*) INTO v_c FROM employees WHERE department_id = v_dept_id; use v_dept_id from another SELECT--Hint: First get v_dept_id (e.g. from departments), then use in second query.



--H8. Declare CONSTANT v_max NUMBER := 100; use in IF condition--Hint: v_max CONSTANT NUMBER := 100; IF v_salary > v_max THEN ...



--H9. Use SQL%ROWCOUNT after UPDATE employees SET ... WHERE ...; print number of rows updated--Hint: UPDATE ... ; DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);



--H10. FOR rec IN (SELECT employee_id, first_name FROM employees WHERE ROWNUM <= 5) LOOP print rec.employee_id, rec.first_name--Hint: FOR rec IN (SELECT ... ) LOOP ... END LOOP;



--H11. Declare v_date DATE := SYSDATE; print it with TO_CHAR--Hint: DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_date, 'DD-MON-YYYY'));



--H12. IF v_emp.salary IS NULL THEN ..--Hint: Handle NULL in record field.



--H13. Loop: i from 1 to 10; if i mod 2 = 0 then print i--Hint: IF MOD(i, 2) = 0 THEN DBMS_OUTPUT.PUT_LINE(i); END IF;



--H14. Select into %ROWTYPE; then update another variable from v_emp.salary * 1.1--Hint: v_new_sal := v_emp.salary * 1.1;



--H15. EXIT WHEN condition in the middle of LOOP (e.g. when v_count > 5)--Hint: LOOP ... v_count := v_count + 1; EXIT WHEN v_count > 5; ... END LOOP;



--H16. Declare v_result VARCHAR2(100); use CASE in PL/SQL: v_result := CASE WHEN v_sal < 5000 THEN 'Low' WHEN v_sal < 10000 THEN 'Mid' ELSE 'High' END; Hint: Assignment with CASE expression.



--H17. Nested FOR: outer 1..2, inner 1..3; print outer and inner--Hint: FOR o IN 1..2 LOOP FOR i IN 1..3 LOOP DBMS_OUTPUT.PUT_LINE(o || ',' || i); END LOOP; END LOOP;



--H18. SELECT department_id INTO v_did FROM departments WHERE department_name = 'Sales'; then use v_did in SELECT COUNT(*) FROM employees WHERE department_id = v_did--Hint: Two SELECT INTOs; use first result in second.



--H19. Use BIND variable in PL/SQL (e.g. in EXECUTE IMMEDIATE 'SELECT salary FROM employees WHERE employee_id = :1' INTO v_sal USING v_id)--Hint: EXECUTE IMMEDIATE '...' INTO ... USING ...;



--H20. Block that only runs if v_flag = 1 (IF v_flag = 1 THEN ... entire logic ... END IF)--Hint: Wrap main logic in IF condition.



