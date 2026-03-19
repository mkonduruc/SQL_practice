/*Day 21 Assignment: Cursors
All exercises use employees and departments. Use SET SERVEROUTPUT ON where you use DBMS_OUTPUT.
Part 1: Practice Questions (With Answers and Explanations)*/

/*Question 1
Write an explicit cursor over employees in department_id 60. Open, fetch in a loop, and print each employee's first and last name. Close the cursor.
Answer:*/

SET SERVEROUTPUT ON
DECLARE
  CURSOR c_emp IS SELECT first_name, last_name FROM employees WHERE department_id = 60;
  v_fname employees.first_name%TYPE;
  v_lname employees.last_name%TYPE;
BEGIN
  OPEN c_emp;
  LOOP
    FETCH c_emp INTO v_fname, v_lname;
    EXIT WHEN c_emp%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_fname || ' ' || v_lname);
  END LOOP;
  CLOSE c_emp;
END;
/

--Explanation: Declare cursor with SELECT, open it, loop with FETCH INTO and EXIT WHEN c_emp%NOTFOUND, then close. Variables must match the select list in type and number.

/*Question 2
Use a cursor FOR loop to iterate over departments and for each department count how many employees it has. Print department_id, department_name, and the count. (Use a subquery in the cursor or a second query inside the loop.)
Answer (cursor with subquery for count):*/

SET SERVEROUTPUT ON
DECLARE
  CURSOR c_dept IS SELECT d.department_id, d.department_name,
      (SELECT COUNT(*) FROM employees e WHERE e.department_id = d.department_id) AS emp_count
    FROM departments d;
BEGIN
  FOR rec IN c_dept LOOP
    DBMS_OUTPUT.PUT_LINE(rec.department_id || ' - ' || rec.department_name || ': ' || rec.emp_count || ' employees');
  END LOOP;
END;
/

-- Explanation: The cursor selects each department and a scalar subquery for employee count. The FOR loop iterates and prints each row.

/*Question 3
Write a parameterized cursor that takes department_id as a parameter and returns employees in that department. Call it for department 50 and print each employee's first_name and last_name.
Answer:*/

SET SERVEROUTPUT ON
DECLARE
  CURSOR c_emp(p_dept_id NUMBER) IS SELECT first_name, last_name FROM employees WHERE department_id = p_dept_id;
BEGIN
  FOR rec IN c_emp(50) LOOP
    DBMS_OUTPUT.PUT_LINE(rec.first_name || ' ' || rec.last_name);
  END LOOP;
END;
/

-- Explanation: The cursor declares a parameter p_dept_id and uses it in the WHERE clause. In the FOR loop, pass 50 as c_emp(50).

/*Part 2: Self-Practice (No Answers)*/

--1. Write a cursor that joins employees and departments and fetches employee_id, first_name, department_name. Print each row in a loop.

SET SERVEROUTPUT ON
DECLARE
  CURSOR c_emp(p_dept_id NUMBER) IS SELECT emp.employee_id, first_name, department_name FROM employees emp join departments dpt on emp.department_id = dpt.department_id WHERE emp.department_id = p_dept_id;
BEGIN
  FOR rec IN c_emp(50) LOOP
    DBMS_OUTPUT.PUT_LINE(rec.employee_id || ' - ' || rec.first_name|| ' - '|| rec.department_name);
  END LOOP;
END;
/

--2. After an UPDATE on employees (e.g. UPDATE ... WHERE department_id = 90), use SQL%ROWCOUNT in the same block to print how many rows were updated.

SET SERVEROUTPUT ON;
BEGIN
  UPDATE employees
  SET salary = salary * 1.10  
  WHERE department_id = 90;

  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' row(s) updated.');
END;
/

/*Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)
All use employees and departments; SET SERVEROUTPUT ON where needed.*/

--20 Medium Questions

--M1. Declare explicit cursor for employees in department_id = 50; OPEN, FETCH, CLOSE; print first_name--Hint: CURSOR c IS SELECT first_name FROM employees WHERE department_id = 50; OPEN c; LOOP FETCH c INTO v; EXIT WHEN c%NOTFOUND; ...

SET SERVEROUTPUT ON;
DECLARE
    CURSOR emp_cursor IS
        SELECT first_name FROM employees WHERE department_id = 50;
    v_first_name employees.first_name%TYPE;
BEGIN
    OPEN emp_cursor;
    FETCH emp_cursor INTO v_first_name;
    DBMS_OUTPUT.PUT_LINE('First Employee Name: ' || v_first_name);
    CLOSE emp_cursor;
END;
/

--M2. Use cursor FOR loop over SELECT employee_id, last_name FROM employees WHERE job_id = 'SA_REP'--Hint: FOR rec IN (SELECT ... ) LOOP DBMS_OUTPUT.PUT_LINE(rec.employee_id || ' ' || rec.last_name); END LOOP;

SET SERVEROUTPUT ON;
BEGIN
    FOR emp_rec IN (SELECT employee_id, last_name FROM employees WHERE job_id = 'SA_REP')
    LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || emp_rec.employee_id || ', Last Name: ' || emp_rec.last_name);
    END LOOP;
END;
/

--M3. After UPDATE employees SET salary = salary * 1.1 WHERE department_id = 60; print SQL%ROWCOUNT--Hint: UPDATE ...; DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);

SET SERVEROUTPUT ON;
BEGIN
    UPDATE employees SET salary = salary * 1.1 WHERE department_id = 60;
    DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);
END;
/

--M4. Parameterized cursor c(p_dept_id); open for 50 and 80; print employee count per department--Hint: CURSOR c(p_dept_id NUMBER) IS SELECT ... WHERE department_id = p_dept_id; count in loop or use COUNT in query.

SET SERVEROUTPUT ON;
DECLARE
    CURSOR c_emp_count (p_dept_id NUMBER) IS SELECT COUNT(*) AS emp_count FROM employees WHERE department_id = p_dept_id;
    v_count NUMBER; 
BEGIN
    OPEN c_emp_count(50);
    FETCH c_emp_count INTO v_count;
    DBMS_OUTPUT.PUT_LINE('Department 50 has ' || v_count || ' employees.');
    CLOSE c_emp_count;

    OPEN c_emp_count(80);
    FETCH c_emp_count INTO v_count;
    DBMS_OUTPUT.PUT_LINE('Department 80 has ' || v_count || ' employees.');
    CLOSE c_emp_count;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No employees found for the given department.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--M5. Cursor that selects department_id, department_name from departments; loop and print--Hint: CURSOR c_dept IS SELECT department_id, department_name FROM departments;

SET SERVEROUTPUT ON;
DECLARE
    CURSOR dept_cursor IS SELECT department_id, department_name FROM departments ORDER BY department_id;

    v_dept_id   departments.department_id%TYPE;
    v_dept_name departments.department_name%TYPE;

BEGIN
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_dept_id, v_dept_name;
        EXIT WHEN dept_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Department ID: ' || v_dept_id ||', Department Name: ' || v_dept_name);
    END LOOP;

    CLOSE dept_cursor;
END;
/

--M6. Fetch cursor INTO a %ROWTYPE variable (employees%ROWTYPE)--Hint: v_emp employees%ROWTYPE; FETCH c INTO v_emp; use v_emp.first_name, etc.

DECLARE
    v_emp employees%ROWTYPE;

    CURSOR c_emp IS SELECT * FROM employees WHERE department_id = 10;
BEGIN
    OPEN c_emp;
    FETCH c_emp INTO v_emp; 

    DBMS_OUTPUT.PUT_LINE('Employee: ' || v_emp.first_name || ' ' || v_emp.last_name);
    CLOSE c_emp;
END;
/

--M7. Use c%NOTFOUND to exit loop--Hint: EXIT WHEN c%NOTFOUND; (after FETCH).

SET SERVEROUTPUT ON;
DECLARE
    CURSOR c_emp IS SELECT first_name, last_name FROM employees ORDER BY employee_id;

    v_first_name employees.first_name%TYPE;
    v_last_name  employees.last_name%TYPE;
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp INTO v_first_name, v_last_name;
        EXIT WHEN c_emp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee: ' || v_first_name || ' ' || v_last_name);
    END LOOP;
    CLOSE c_emp;
END;
/

--M8. Cursor with JOIN employees and departments; select employee_id, first_name, department_name--Hint: SELECT e.employee_id, e.first_name, d.department_name FROM employees e JOIN departments d ON e.department_id = d.department_id;

SET SERVEROUTPUT ON;
DECLARE
    CURSOR emp_dept_cur IS SELECT e.employee_id, e.first_name, d.department_name FROM employees e 
    JOIN departments d ON e.department_id = d.department_id ORDER BY e.employee_id;

    v_employee_id   employees.employee_id%TYPE;
    v_first_name    employees.first_name%TYPE;
    v_department    departments.department_name%TYPE;
BEGIN
    OPEN emp_dept_cur;
    LOOP
        FETCH emp_dept_cur INTO v_employee_id, v_first_name, v_department;
        EXIT WHEN emp_dept_cur%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_employee_id ||', Name: ' || v_first_name ||', Department: ' || v_department);
    END LOOP;
    CLOSE emp_dept_cur;
END;
/

--M9. After DELETE FROM employees WHERE employee_id = 999; print SQL%ROWCOUNT--Hint: DELETE ...; DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);

SET SERVEROUTPUT ON;
BEGIN
    DELETE FROM employees WHERE employee_id = 999;
    DBMS_OUTPUT.PUT_LINE('Rows deleted: ' || SQL%ROWCOUNT);
END;
/

--M10. Cursor FOR loop with named cursor (not inline)--Hint: DECLARE CURSOR c IS SELECT ...; BEGIN FOR rec IN c LOOP ...

SET SERVEROUTPUT ON;
DECLARE
    CURSOR c_emp IS SELECT employee_id, first_name, last_name, salary FROM employees
        WHERE department_id = 50 ORDER BY employee_id;
BEGIN
    FOR rec IN c_emp LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.employee_id ||', Name: ' || rec.first_name || ' ' || rec.last_name ||', Salary: ' || rec.salary);
    END LOOP;
END;
/

--M11. Check cursor%ISOPEN before CLOSE--Hint: IF c%ISOPEN THEN CLOSE c; END IF;

DECLARE
    CURSOR c_emp IS SELECT employee_id, first_name FROM employees WHERE ROWNUM <= 5;

    v_emp_id   employees.employee_id%TYPE;
    v_fname    employees.first_name%TYPE;
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp INTO v_emp_id, v_fname;
        EXIT WHEN c_emp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_emp_id || ', Name: ' || v_fname);
    END LOOP;
    IF c_emp%ISOPEN THEN
        CLOSE c_emp;
    END IF;
END;
/

--M12. Open parameterized cursor with OPEN c_emp(90)--Hint: OPEN c_emp(90); then FETCH loop.

SET SERVEROUTPUT ON;
DECLARE
    v_emp_id     employees.employee_id%TYPE;
    v_first_name employees.first_name%TYPE;
    v_dept_id    employees.department_id%TYPE;

    CURSOR c_emp (p_dept_id NUMBER) IS SELECT employee_id, first_name, department_id FROM employees WHERE department_id = p_dept_id;

BEGIN
    OPEN c_emp(90);
    LOOP
        FETCH c_emp INTO v_emp_id, v_first_name, v_dept_id;
        EXIT WHEN c_emp%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_emp_id ||', Name: ' || v_first_name ||', Dept: ' || v_dept_id);
    END LOOP;
    CLOSE c_emp;
END;
/

--M13. Loop that fetches into three variables (employee_id, first_name, last_name)--Hint: FETCH c INTO v_id, v_fname, v_lname;

SET SERVEROUTPUT ON;
DECLARE
    v_id     employees.employee_id%TYPE;
    v_fname  employees.first_name%TYPE;
    v_lname  employees.last_name%TYPE;

    CURSOR c_emp IS SELECT employee_id, first_name, last_name FROM employees ORDER BY employee_id;

BEGIN
    OPEN c_emp;

    LOOP
        FETCH c_emp INTO v_id, v_fname, v_lname;
        EXIT WHEN c_emp%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ', First Name: ' || v_fname || ', Last Name: ' || v_lname);
    END LOOP;
    CLOSE c_emp;
END;
/

--M14. Use SQL%FOUND after SELECT INTO--Hint: SELECT ... INTO v FROM ...; IF SQL%FOUND THEN ...

DECLARE
    v_emp_name   employees.first_name%TYPE;
BEGIN
    SELECT first_name INTO v_emp_name FROM employees WHERE employee_id = 100;

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee found: ' || v_emp_name);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No employee found.');
    END IF;
END;
/

--M15. Cursor for employees where salary > 10000; print employee_id and salary--Hint: CURSOR c IS SELECT employee_id, salary FROM employees WHERE salary > 10000;

SET SERVEROUTPUT ON;
DECLARE
    v_employee_id employees.employee_id%TYPE;
    v_salary      employees.salary%TYPE;

    CURSOR c IS SELECT employee_id, salary FROM employees WHERE salary > 10000;
BEGIN
    OPEN c;

    LOOP
        FETCH c INTO v_employee_id, v_salary;
        EXIT WHEN c%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_employee_id || ', Salary: ' || v_salary);
    END LOOP;

    CLOSE c;
END;
/

--M16. Count rows processed in cursor loop (increment counter)--Hint: v_count := 0; LOOP ... v_count := v_count + 1; END LOOP; print v_count.

SET SERVEROUTPUT ON;
DECLARE
    v_count NUMBER := 0;

    CURSOR c_emp IS SELECT employee_id, first_name, last_name FROM employees;
BEGIN
    FOR rec IN c_emp LOOP
        v_count := v_count + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total rows processed: ' || v_count);
END;
/

--M17. Cursor over departments; for each department print name and (subquery) count of employees--Hint: Cursor SELECT d.department_name, (SELECT COUNT(*) FROM employees e WHERE e.department_id = d.department_id) FROM departments d;

SET SERVEROUTPUT ON;
DECLARE
    CURSOR dept_cur IS SELECT d.department_name, (SELECT COUNT(*) FROM employees e WHERE e.department_id = d.department_id) AS emp_count
          FROM departments d;

    v_dept_name departments.department_name%TYPE;
    v_emp_count NUMBER;
BEGIN
    OPEN dept_cur;
    LOOP
        FETCH dept_cur INTO v_dept_name, v_emp_count;
        EXIT WHEN dept_cur%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept_name || ' | Employees: ' || v_emp_count);
    END LOOP;

    CLOSE dept_cur;
END;
/

--M18. FOR rec IN (SELECT first_name, last_name FROM employees WHERE ROWNUM <= 5) — inline cursor--Hint: No DECLARE cursor; FOR rec IN (SELECT ...) LOOP ...

SET SERVEROUTPUT ON;
BEGIN
    FOR rec IN (
        SELECT first_name, last_name FROM employees WHERE ROWNUM <= 5
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || rec.first_name || ' ' || rec.last_name);
    END LOOP;
END;
/

--M19. Close cursor in EXCEPTION handler--Hint: EXCEPTION WHEN OTHERS THEN IF c%ISOPEN THEN CLOSE c; END IF; RAISE;

DECLARE
    CURSOR c IS SELECT employee_id, first_name FROM employees;
    v_emp_id   employees.employee_id%TYPE;
    v_fname    employees.first_name%TYPE;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_emp_id, v_fname;
        EXIT WHEN c%NOTFOUND;
    END LOOP;
    CLOSE c;

EXCEPTION
    WHEN OTHERS THEN
        IF c%ISOPEN THEN
            CLOSE c;
        END IF;
        RAISE;
END;
/

--M20. Cursor that orders by hire_date DESC; print first 3 rows only (EXIT when counter = 3)--Hint: v_n := 0; LOOP FETCH ... EXIT WHEN c%NOTFOUND; v_n := v_n + 1; EXIT WHEN v_n > 3; ...

SET SERVEROUTPUT ON;
DECLARE
    CURSOR c_emp IS SELECT employee_id, first_name, last_name, hire_date FROM employees ORDER BY hire_date DESC;

    v_emp_id   employees.employee_id%TYPE;
    v_fname    employees.first_name%TYPE;
    v_lname    employees.last_name%TYPE;
    v_hiredate employees.hire_date%TYPE;

    v_n NUMBER := 0;
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp INTO v_emp_id, v_fname, v_lname, v_hiredate;
        EXIT WHEN c_emp%NOTFOUND;
        v_n := v_n + 1; 
        EXIT WHEN v_n > 3; 
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_emp_id || ', Name: ' || v_fname || ' ' || v_lname || ', Hire Date: ' || TO_CHAR(v_hiredate, 'YYYY-MM-DD'));
    END LOOP;
    CLOSE c_emp;
END;
/


--20 Hard Questions

--H1. Two cursors: first cursor departments, inner cursor employees for that department_id; nested loops--Hint: OPEN c_dept; LOOP FETCH c_dept INTO v_dept_id; EXIT WHEN c_dept%NOTFOUND; OPEN c_emp(v_dept_id); ... CLOSE c_emp; END LOOP; CLOSE c_dept;

SET SERVEROUTPUT ON;
DECLARE
    CURSOR dept_cur IS SELECT department_id, department_name FROM departments ORDER BY department_id;

    CURSOR emp_cur (p_dept_id departments.department_id%TYPE) IS
        SELECT employee_id, first_name, last_name, salary FROM employees WHERE department_id = p_dept_id ORDER BY employee_id;
BEGIN
    FOR dept_rec IN dept_cur LOOP
        DBMS_OUTPUT.PUT_LINE('Department: ' || dept_rec.department_name ||' (ID: ' || dept_rec.department_id || ')');

        FOR emp_rec IN emp_cur(dept_rec.department_id) LOOP
            DBMS_OUTPUT.PUT_LINE('   Employee ID: ' || emp_rec.employee_id ||', Name: ' || emp_rec.first_name || ' ' || emp_rec.last_name ||', Salary: ' || emp_rec.salary);
        END LOOP;
    END LOOP;
END;
/

--H2. Cursor with FOR UPDATE; inside loop UPDATE employees SET ... WHERE CURRENT OF c; --Hint: CURSOR c IS SELECT ... FROM employees WHERE ... FOR UPDATE; later UPDATE ... WHERE CURRENT OF c;

DECLARE
    CURSOR c_emp IS SELECT employee_id, salary FROM employees WHERE department_id = 50 FOR UPDATE; 

BEGIN
    FOR rec IN c_emp LOOP
        UPDATE employees SET salary = rec.salary * 1.10 WHERE CURRENT OF c_emp; 
    END LOOP;
END;
/

--H3. Parameterized cursor returning (department_id, department_name, total_salary); use GROUP BY in cursor query--Hint: CURSOR c IS SELECT department_id, department_name, SUM(salary) FROM employees e JOIN departments d ON e.department_id = d.department_id GROUP BY d.department_id, d.department_name;

SET SERVEROUTPUT ON;
DECLARE
    CURSOR dept_salary_cur (dept_id NUMBER) IS
        SELECT d.department_id, d.department_name, SUM(e.salary) AS total_salary FROM departments d JOIN employees e ON d.department_id = e.department_id
        where d.department_id = dept_id
        GROUP BY d.department_id, d.department_name;

    v_dept_id     departments.department_id%TYPE;
    v_dept_name   departments.department_name%TYPE;
    v_total_sal   NUMBER;

BEGIN
    OPEN dept_salary_cur(100);
    LOOP
        FETCH dept_salary_cur INTO v_dept_id, v_dept_name, v_total_sal;
        EXIT WHEN dept_salary_cur%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Dept ID: ' || v_dept_id ||', Name: ' || v_dept_name ||', Total Salary: ' || v_total_sal);
    END LOOP;
    CLOSE dept_salary_cur;
END;
/

--H4. Use BULK COLLECT LIMIT 100 to fetch 100 rows at a time from cursor into collection--Hint: OPEN c; LOOP FETCH c BULK COLLECT INTO v_ids, v_names LIMIT 100; EXIT WHEN v_ids.COUNT = 0; process collection; END LOOP;

SET SERVEROUTPUT ON;
DECLARE
    TYPE emp_rec_type IS RECORD (
        emp_id     employees.employee_id%TYPE,
        first_name employees.first_name%TYPE,
        salary     employees.salary%TYPE  );
    TYPE emp_tab_type IS TABLE OF emp_rec_type;
    l_emps emp_tab_type;
    CURSOR c_emp IS SELECT employee_id, first_name, salary FROM employees ORDER BY employee_id;
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp BULK COLLECT INTO l_emps LIMIT 100;
        EXIT WHEN l_emps.COUNT = 0;
        FOR i IN 1 .. l_emps.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('ID: ' || l_emps(i).emp_id ||', Name: ' || l_emps(i).first_name ||', Salary: ' || l_emps(i).salary);
        END LOOP;
    END LOOP;
    CLOSE c_emp;
END;
/

--H5. Cursor that uses a variable in WHERE (set before OPEN)--Hint: v_dept := 50; CURSOR c IS SELECT ... WHERE department_id = v_dept; OPEN c; (variable evaluated at OPEN).

SET SERVEROUTPUT ON;
DECLARE
    v_dept_id departments.department_id%TYPE;
    CURSOR c_emp IS SELECT employee_id, first_name, last_name FROM employees WHERE department_id = v_dept_id;
    v_emp_rec c_emp%ROWTYPE;
BEGIN
    v_dept_id := 50;
    OPEN c_emp;
    LOOP
        FETCH c_emp INTO v_emp_rec;
        EXIT WHEN c_emp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Emp ID: ' || v_emp_rec.employee_id ||', Name: ' || v_emp_rec.first_name || ' ' || v_emp_rec.last_name);
    END LOOP;
    CLOSE c_emp;
END;
/

--H6. REF CURSOR (weak): open for different queries (e.g. one for employees, one for departments) in same block--Hint: TYPE t_rc IS REF CURSOR; v_rc t_rc; OPEN v_rc FOR SELECT ... FROM employees; later OPEN v_rc FOR SELECT ... FROM departments;

DECLARE
    TYPE t_rc IS REF CURSOR; 
    v_rc t_rc; 
    emp_id employees.employee_id%TYPE;
    emp_name employees.employee_name%TYPE;
BEGIN

END;
/

--H7. Cursor with OFFSET/FETCH (Oracle 12c+) to skip first 5 rows and take next 10--Hint: SELECT ... FROM employees ORDER BY employee_id OFFSET 5 ROWS FETCH NEXT 10 ROWS ONLY;

DECLARE
    CURSOR emp_cur IS SELECT employee_id, first_name, last_name, salary FROM employees
        ORDER BY employee_id OFFSET 5 ROWS
        FETCH NEXT 10 ROWS ONLY;

    v_emp emp_cur%ROWTYPE;
BEGIN
    OPEN emp_cur;
    LOOP
        FETCH emp_cur INTO v_emp;
        EXIT WHEN emp_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_emp.employee_id || ' - ' || v_emp.first_name);
    END LOOP;
    CLOSE emp_cur;
END;
/

--H8. After cursor loop, print total rows processed using cursor%ROWCOUNT (after loop, before CLOSE)--Hint: After LOOP ... END LOOP; DBMS_OUTPUT.PUT_LINE(c%ROWCOUNT); CLOSE c;

DECLARE
    CURSOR c_emp IS SELECT employee_id, first_name FROM employees WHERE department_id = 10;

    v_emp_id employees.employee_id%TYPE;
    v_first  employees.first_name%TYPE;
BEGIN
    OPEN c_emp;
    LOOP
        FETCH c_emp INTO v_emp_id, v_first;
        EXIT WHEN c_emp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee: ' || v_emp_id || ' - ' || v_first);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total rows processed: ' || c_emp%ROWCOUNT);
    CLOSE c_emp;
END;
/

--H9. Procedure with OUT parameter as REF CURSOR; open cursor for SELECT from employees and return it to caller--Hint: PROCEDURE get_emps(p_rc OUT SYS_REFCURSOR) IS BEGIN OPEN p_rc FOR SELECT * FROM employees; END;



--H10. Cursor FOR loop that exits early when a condition is met (e.g. when salary > 20000)--Hint: FOR rec IN c LOOP IF rec.salary > 20000 THEN EXIT; END IF; ... END LOOP;

SET SERVEROUTPUT ON;

DECLARE
    CURSOR emp_cur IS SELECT employee_id, first_name, salary FROM employees ORDER BY salary;

BEGIN
    FOR emp_rec IN emp_cur LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || emp_rec.employee_id ||', Name: ' || emp_rec.first_name ||', Salary: ' || emp_rec.salary);

        IF emp_rec.salary > 20000 THEN
            DBMS_OUTPUT.PUT_LINE('Condition met. Exiting loop early.');
            EXIT;
        END IF;
    END LOOP;
END;
/

--H11. Select from cursor into record type with 5 columns; declare TYPE t_rec IS RECORD (...)--Hint: TYPE t_rec IS RECORD (id NUMBER, fname VARCHAR2(20), ...); v_rec t_rec; FETCH c INTO v_rec;

SET SERVEROUTPUT ON;

DECLARE
    TYPE t_rec IS RECORD (
        emp_id      NUMBER,
        first_name  VARCHAR2(50),
        last_name   VARCHAR2(50),
        dept_id     NUMBER,
        salary      NUMBER
    );

    v_emp t_rec;

    CURSOR c_emp IS SELECT employee_id,first_name,last_name,department_id,salary FROM employees
        WHERE ROWNUM <= 1; 

BEGIN
    OPEN c_emp;
    FETCH c_emp INTO v_emp;
    CLOSE c_emp;

    DBMS_OUTPUT.PUT_LINE('ID: ' || v_emp.emp_id);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_emp.first_name || ' ' || v_emp.last_name);
    DBMS_OUTPUT.PUT_LINE('Dept: ' || v_emp.dept_id);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_emp.salary);
END;
/

--H12. Use WHERE CURRENT OF with cursor declared with FOR UPDATE NOWAIT--Hint: FOR UPDATE NOWAIT; if row locked by another session, lock fails immediately.

DECLARE
    CURSOR emp_cur IS SELECT employee_id, salary FROM employees WHERE department_id = 10 FOR UPDATE NOWAIT;

    v_emp emp_cur%ROWTYPE;
BEGIN
    OPEN emp_cur;
    LOOP
        FETCH emp_cur INTO v_emp;
        EXIT WHEN emp_cur%NOTFOUND;

        UPDATE employees SET salary = salary * 1.10 WHERE CURRENT OF emp_cur;
    END LOOP;

    CLOSE emp_cur;
    COMMIT;
END;
/

--H13. Cursor that joins employees and departments and filters by department_name = 'Sales'--Hint: JOIN departments d ... WHERE d.department_name = 'Sales';

DECLARE
    CURSOR sales_emp_cur IS
        SELECT e.employee_id,e.first_name,e.last_name,d.department_name FROM employees e
        JOIN departments d ON e.department_id = d.department_id
        WHERE d.department_name = 'Sales';

    v_emp_id     employees.employee_id%TYPE;
    v_first_name employees.first_name%TYPE;
    v_last_name  employees.last_name%TYPE;
    v_dept_name  departments.department_name%TYPE;
BEGIN
    OPEN sales_emp_cur;
    LOOP
        FETCH sales_emp_cur INTO v_emp_id, v_first_name, v_last_name, v_dept_name;
        EXIT WHEN sales_emp_cur%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_emp_id ||', Name: ' || v_first_name || ' ' || v_last_name ||', Dept: ' || v_dept_name);
    END LOOP;
    CLOSE sales_emp_cur;
END;
/

--H14. Loop through cursor and accumulate total salary in a variable; print total at end--Hint: v_total := 0; FOR rec IN c LOOP v_total := v_total + rec.salary; END LOOP;

SET SERVEROUTPUT ON;
DECLARE
    v_total_salary NUMBER := 0;
    CURSOR c_emp IS  SELECT salary  FROM employees; 

BEGIN
    FOR rec IN c_emp LOOP
        v_total_salary := v_total_salary + NVL(rec.salary, 0);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total Salary: ' || v_total_salary);
END;
/

--H15. Open same parameterized cursor twice (different params) in same block; process both--Hint: FOR rec IN c(50) LOOP ... END LOOP; FOR rec IN c(60) LOOP ... END LOOP;

SET SERVEROUTPUT ON;
DECLARE
  TYPE EmpCurTyp IS REF CURSOR;
  emp_cv EmpCurTyp;
  my_job VARCHAR2(15) := 'X';
  sql_stmt VARCHAR2(200);
BEGIN
  OPEN emp_cv FOR 'SELECT * FROM dual WHERE dummy = :j OR dummy = :j' USING my_job, my_job;
  LOOP
    FETCH emp_cv INTO emp_rec;
    EXIT WHEN emp_cv%NOTFOUND;
  END LOOP;
  CLOSE emp_cv;
END;
/

--H16. Cursor with ORDER BY salary DESC; fetch first row only and print (then exit)--Hint: OPEN c; FETCH c INTO ...; (process); EXIT; or use FETCH once and EXIT WHEN c%NOTFOUND after processing.

SET SERVEROUTPUT ON;
DECLARE
    CURSOR c_highest_salary IS
        SELECT employee_id, first_name, last_name, salary FROM employees ORDER BY salary DESC FETCH FIRST 1 ROW ONLY; 

    v_row c_highest_salary%ROWTYPE;
BEGIN

    OPEN c_highest_salary;
    FETCH c_highest_salary INTO v_row;

    IF c_highest_salary%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Highest Salary Employee:');
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_row.employee_id || ', Name: ' || v_row.first_name || ' ' || v_row.last_name || ', Salary: ' || v_row.salary);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No data found.');
    END IF;

    CLOSE c_highest_salary;
END;
/

--H17--Handle NO_DATA_FOUND when opening cursor and fetching (cursor returns no rows)--Hint: After first FETCH, if c%NOTFOUND before any processing, handle "no rows."

DECLARE
    CURSOR sales_cur IS SELECT employee_id, salary FROM employees WHERE hire_date = DATE '2026-03-19';

    v_emp_id  employees.employee_id%TYPE;
    v_amount  employees.salary%TYPE;
    v_found    BOOLEAN := FALSE; 
BEGIN
    OPEN sales_cur;
    LOOP
        FETCH sales_cur INTO v_emp_id, v_amount;
        EXIT WHEN sales_cur%NOTFOUND;
        v_found := TRUE;
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_emp_id || ', Salary: ' || v_amount);
    END LOOP;
    CLOSE sales_cur;

    IF NOT v_found THEN
        RAISE NO_DATA_FOUND;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No sales found for the given date.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/

--H18. Cursor that returns one row per department with department_name and comma-separated list of employee last_names (use LISTAGG in cursor query)--Hint: SELECT d.department_name, LISTAGG(e.last_name, ', ') WITHIN GROUP (ORDER BY e.last_name) FROM employees e JOIN departments d ON e.department_id = d.department_id GROUP BY d.department_id, d.department_name;



--H19. Statement that uses SQL%ROWCOUNT after INSERT...SELECT--Hint: INSERT INTO backup SELECT * FROM employees WHERE department_id = 50; DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows inserted');



--H20. Explicit cursor with ORDER BY department_id, salary DESC; process by department (change of department_id)--Hint: Track previous department_id; when rec.department_id != v_prev_dept, print separator or do extra logic.


