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



--M2. Use cursor FOR loop over SELECT employee_id, last_name FROM employees WHERE job_id = 'SA_REP'--Hint: FOR rec IN (SELECT ... ) LOOP DBMS_OUTPUT.PUT_LINE(rec.employee_id || ' ' || rec.last_name); END LOOP;



--M3. After UPDATE employees SET salary = salary * 1.1 WHERE department_id = 60; print SQL%ROWCOUNT--Hint: UPDATE ...; DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);



--M4. Parameterized cursor c(p_dept_id); open for 50 and 80; print employee count per department--Hint: CURSOR c(p_dept_id NUMBER) IS SELECT ... WHERE department_id = p_dept_id; count in loop or use COUNT in query.



--M5. Cursor that selects department_id, department_name from departments; loop and print--Hint: CURSOR c_dept IS SELECT department_id, department_name FROM departments;



--M6. Fetch cursor INTO a %ROWTYPE variable (employees%ROWTYPE)--Hint: v_emp employees%ROWTYPE; FETCH c INTO v_emp; use v_emp.first_name, etc.



--M7. Use c%NOTFOUND to exit loop--Hint: EXIT WHEN c%NOTFOUND; (after FETCH).



--M8. Cursor with JOIN employees and departments; select employee_id, first_name, department_name--Hint: SELECT e.employee_id, e.first_name, d.department_name FROM employees e JOIN departments d ON e.department_id = d.department_id;



--M9. After DELETE FROM employees WHERE employee_id = 999; print SQL%ROWCOUNT--Hint: DELETE ...; DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);



--M10. Cursor FOR loop with named cursor (not inline)--Hint: DECLARE CURSOR c IS SELECT ...; BEGIN FOR rec IN c LOOP ...



--M11. Check cursor%ISOPEN before CLOSE--Hint: IF c%ISOPEN THEN CLOSE c; END IF;



--M12. Open parameterized cursor with OPEN c_emp(90)--Hint: OPEN c_emp(90); then FETCH loop.



--M13. Loop that fetches into three variables (employee_id, first_name, last_name)--Hint: FETCH c INTO v_id, v_fname, v_lname;



--M14. Use SQL%FOUND after SELECT INTO--Hint: SELECT ... INTO v FROM ...; IF SQL%FOUND THEN ...



--M15. Cursor for employees where salary > 10000; print employee_id and salary--Hint: CURSOR c IS SELECT employee_id, salary FROM employees WHERE salary > 10000;



--M16. Count rows processed in cursor loop (increment counter)--Hint: v_count := 0; LOOP ... v_count := v_count + 1; END LOOP; print v_count.



--M17. Cursor over departments; for each department print name and (subquery) count of employees--Hint: Cursor SELECT d.department_name, (SELECT COUNT(*) FROM employees e WHERE e.department_id = d.department_id) FROM departments d;



--M18. FOR rec IN (SELECT first_name, last_name FROM employees WHERE ROWNUM <= 5) — inline cursor--Hint: No DECLARE cursor; FOR rec IN (SELECT ...) LOOP ...



--M19. Close cursor in EXCEPTION handler--Hint: EXCEPTION WHEN OTHERS THEN IF c%ISOPEN THEN CLOSE c; END IF; RAISE;



--M20. Cursor that orders by hire_date DESC; print first 3 rows only (EXIT when counter = 3)--Hint: v_n := 0; LOOP FETCH ... EXIT WHEN c%NOTFOUND; v_n := v_n + 1; EXIT WHEN v_n > 3; ...




--20 Hard Questions

--H1. Two cursors: first cursor departments, inner cursor employees for that department_id; nested loops--Hint: OPEN c_dept; LOOP FETCH c_dept INTO v_dept_id; EXIT WHEN c_dept%NOTFOUND; OPEN c_emp(v_dept_id); ... CLOSE c_emp; END LOOP; CLOSE c_dept;



--H2. Cursor with FOR UPDATE; inside loop UPDATE employees SET ... WHERE CURRENT OF c; Hint: CURSOR c IS SELECT ... FROM employees WHERE ... FOR UPDATE; later UPDATE ... WHERE CURRENT OF c;



--H3. Parameterized cursor returning (department_id, department_name, total_salary); use GROUP BY in cursor query--Hint: CURSOR c IS SELECT department_id, department_name, SUM(salary) FROM employees e JOIN departments d ON e.department_id = d.department_id GROUP BY d.department_id, d.department_name;



--H4. Use BULK COLLECT LIMIT 100 to fetch 100 rows at a time from cursor into collection--Hint: OPEN c; LOOP FETCH c BULK COLLECT INTO v_ids, v_names LIMIT 100; EXIT WHEN v_ids.COUNT = 0; process collection; END LOOP;



--H5. Cursor that uses a variable in WHERE (set before OPEN)--Hint: v_dept := 50; CURSOR c IS SELECT ... WHERE department_id = v_dept; OPEN c; (variable evaluated at OPEN).



--H6. REF CURSOR (weak): open for different queries (e.g. one for employees, one for departments) in same block--Hint: TYPE t_rc IS REF CURSOR; v_rc t_rc; OPEN v_rc FOR SELECT ... FROM employees; later OPEN v_rc FOR SELECT ... FROM departments;



--H7. Cursor with OFFSET/FETCH (Oracle 12c+) to skip first 5 rows and take next 10--Hint: SELECT ... FROM employees ORDER BY employee_id OFFSET 5 ROWS FETCH NEXT 10 ROWS ONLY;



--H8. After cursor loop, print total rows processed using cursor%ROWCOUNT (after loop, before CLOSE)--Hint: After LOOP ... END LOOP; DBMS_OUTPUT.PUT_LINE(c%ROWCOUNT); CLOSE c;



--H9. Procedure with OUT parameter as REF CURSOR; open cursor for SELECT from employees and return it to caller--Hint: PROCEDURE get_emps(p_rc OUT SYS_REFCURSOR) IS BEGIN OPEN p_rc FOR SELECT * FROM employees; END;



--H10. Cursor FOR loop that exits early when a condition is met (e.g. when salary > 20000)--Hint: FOR rec IN c LOOP IF rec.salary > 20000 THEN EXIT; END IF; ... END LOOP;



--H11. Select from cursor into record type with 5 columns; declare TYPE t_rec IS RECORD (...)--Hint: TYPE t_rec IS RECORD (id NUMBER, fname VARCHAR2(20), ...); v_rec t_rec; FETCH c INTO v_rec;



--H12. Use WHERE CURRENT OF with cursor declared with FOR UPDATE NOWAIT--Hint: FOR UPDATE NOWAIT; if row locked by another session, lock fails immediately.



--H13. Cursor that joins employees and departments and filters by department_name = 'Sales'--Hint: JOIN departments d ... WHERE d.department_name = 'Sales';



--H14. Loop through cursor and accumulate total salary in a variable; print total at end--Hint: v_total := 0; FOR rec IN c LOOP v_total := v_total + rec.salary; END LOOP;



--H15. Open same parameterized cursor twice (different params) in same block; process both--Hint: FOR rec IN c(50) LOOP ... END LOOP; FOR rec IN c(60) LOOP ... END LOOP;



--H16. Cursor with ORDER BY salary DESC; fetch first row only and print (then exit)--Hint: OPEN c; FETCH c INTO ...; (process); EXIT; or use FETCH once and EXIT WHEN c%NOTFOUND after processing.



--H17--Handle NO_DATA_FOUND when opening cursor and fetching (cursor returns no rows)--Hint: After first FETCH, if c%NOTFOUND before any processing, handle "no rows."



--H18. Cursor that returns one row per department with department_name and comma-separated list of employee last_names (use LISTAGG in cursor query)--Hint: SELECT d.department_name, LISTAGG(e.last_name, ', ') WITHIN GROUP (ORDER BY e.last_name) FROM employees e JOIN departments d ON e.department_id = d.department_id GROUP BY d.department_id, d.department_name;



--H19. Statement that uses SQL%ROWCOUNT after INSERT...SELECT--Hint: INSERT INTO backup SELECT * FROM employees WHERE department_id = 50; DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows inserted');



--H20. Explicit cursor with ORDER BY department_id, salary DESC; process by department (change of department_id)--Hint: Track previous department_id; when rec.department_id != v_prev_dept, print separator or do extra logic.


