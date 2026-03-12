/*Day 23 Assignment: Functions
All exercises use employees and departments. Create functions in your schema or 
Part 1: Practice Questions (With Answers and Explanations)*/

/*Question 1
Create a function that takes department_id and returns department_name from departments--Handle NO_DATA_FOUND (return NULL or raise). Name it (e.g. get_department_name).
Answer:*/

CREATE OR REPLACE FUNCTION get_department_name(p_dept_id IN departments.department_id%TYPE)
RETURN departments.department_name%TYPE IS
  v_name departments.department_name%TYPE;
BEGIN
  SELECT department_name INTO v_name FROM departments WHERE department_id = p_dept_id;
  RETURN v_name;
EXCEPTION
  WHEN NO_DATA_FOUND THEN RETURN NULL;
END;
/

select get_department_name(50) from dual;

--Explanation: SELECT INTO gets the name; RETURN the variable. If no row exists, NO_DATA_FOUND is raised and we return NULL. Use in SQL: SELECT get_department_name(50) FROM DUAL;

/*Question 2
Create a function employee_count(p_dept_id) that returns the number of employees in that department. Use it in a SELECT list (e.g. SELECT employee_count(50) FROM DUAL).
Answer:*/

CREATE OR REPLACE FUNCTION employee_count(p_dept_id IN departments.department_id%TYPE)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM employees WHERE department_id = p_dept_id;
  RETURN v_count;
END;
/

-- Usage:
SELECT employee_count(50) FROM DUAL;

--Explanation: COUNT(*) into v_count, then RETURN. The function can be called in SQL because it has no OUT parameters and does not modify database state (in simple form).

/*Question 3
Use your get_department_name function in a SELECT from employees: show employee_id, first_name, and department name (by calling the function with department_id).
Answer:*/

SELECT employee_id, first_name, get_department_name(department_id) AS department_name
FROM employees;

--Explanation: The function is called once per row with that row's department_id. This avoids joining to departments in the query (but may be less efficient than a join for large result sets).

/*Part 2: Self-Practice (No Answers)*/

--1. Create a function that returns the maximum salary in a given department_id. Use it in a SELECT.

CREATE OR REPLACE FUNCTION max_salary(p_dept_id IN departments.department_id%TYPE)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT sum(SALARY) INTO v_count FROM employees WHERE department_id = p_dept_id;
  RETURN v_count;
END;
/

SELECT department_id, max_salary(department_id) AS max_salary
FROM departments;

--2. Create a function that takes department_id and returns a BOOLEAN (true if the department has at least one employee). Call it from a PL/SQL block (functions returning BOOLEAN are not used in SQL SELECT in Oracle).

CREATE OR REPLACE FUNCTION employee_count_bool(p_dept_id IN departments.department_id%TYPE)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT case when COUNT(*) > 0 Then True else False END INTO v_count FROM employees WHERE department_id = p_dept_id;
  RETURN v_count;
END;
/

-- Usage:
SELECT department_id, employee_count_bool(department_id) FROM departments;

/*Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)
All use employees and departments; create functions in your schema or HR if allowed.*/
--20 Medium Questions

--M1. Function get_department_name(p_dept_id) RETURN department_name; handle NO_DATA_FOUND--Hint: SELECT department_name INTO v FROM departments WHERE department_id = p_dept_id; RETURN v; EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;

CREATE OR REPLACE FUNCTION get_department_name(p_dept_id IN departments.department_id%TYPE)
RETURN departments.department_name%TYPE IS
  v_name departments.department_name%TYPE;
BEGIN
  SELECT department_name INTO v_name FROM DEPARTMENTS WHERE department_id = p_dept_id;
  RETURN v_name;
END;
/

-- Usage:
SELECT distinct department_id, get_department_name(department_id) FROM employees;

--M2. Function employee_count(p_dept_id) RETURN NUMBER--Hint: SELECT COUNT(*) INTO v FROM employees WHERE department_id = p_dept_id; RETURN v;

CREATE OR REPLACE FUNCTION employee_count(p_dept_id IN departments.department_id%TYPE)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM employees WHERE department_id = p_dept_id;
  RETURN v_count;
END;
/

-- Usage:
SELECT distinct department_id, employee_count(department_id) FROM employees;

--M3. Use function in SELECT: SELECT employee_id, get_department_name(department_id) FROM employees--Hint: Call function in SELECT list with column as argument.

SELECT distinct department_id, get_department_name(department_id) FROM employees;

--M4. Function max_salary(p_dept_id) RETURN NUMBER (MAX(salary))--Hint: SELECT MAX(salary) INTO v FROM employees WHERE department_id = p_dept_id; RETURN NVL(v,0);

CREATE OR REPLACE FUNCTION max_salary(p_dept_id IN departments.department_id%TYPE)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT sum(SALARY) INTO v_count FROM employees WHERE department_id = p_dept_id;
  RETURN v_count;
END;
/

SELECT department_id, max_salary(department_id) AS max_salary
FROM departments;

--M5. Function full_name(p_first, p_last) RETURN VARCHAR2 DETERMINISTIC--Hint: RETURN p_first || ' ' || p_last;

CREATE OR REPLACE FUNCTION full_name(p_first_name IN employees.first_name%TYPE, p_last_name IN employees.last_name%TYPE)
RETURN employees.first_name%TYPE IS
  v_name employees.first_name%TYPE;
BEGIN
  SELECT p_first_name||' '||p_last_name INTO v_name FROM DUAL;
  RETURN v_name;
END;
/

-- Usage:
SELECT distinct employee_id, full_name(first_name, last_name) FROM employees;

--M6. Function that returns min salary for a job_id--Hint: SELECT MIN(salary) INTO v FROM employees WHERE job_id = p_job_id; RETURN v;

CREATE OR REPLACE FUNCTION min_salary(p_job_id IN employees.job_id%TYPE)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT min(SALARY) INTO v_count FROM employees WHERE p_job_id = job_id;
  RETURN v_count;
END;
/

SELECT job_id, min_salary(job_id) AS max_salary FROM employees;

--M7. Call function from PL/SQL: v := get_department_name(50); Hint: v_name := get_department_name(50);



--M8. Function avg_salary(p_dept_id) RETURN NUMBER--Hint: SELECT AVG(salary) INTO v FROM employees WHERE department_id = p_dept_id; RETURN NVL(v,0);

CREATE OR REPLACE FUNCTION avg_salary(p_dept_id IN departments.department_id%TYPE)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT AVG(SALARY) INTO v_count FROM employees WHERE department_id = p_dept_id;
  RETURN v_count;
END;
/

SELECT department_id, avg_salary(department_id) AS max_salary
FROM departments;

--M9. Function that returns hire_date for employee_id (handle NO_DATA_FOUND)--Hint: SELECT hire_date INTO v FROM employees WHERE employee_id = p_emp_id; RETURN v; EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;

CREATE OR REPLACE FUNCTION get_hire_date(p_employee_id IN employees.employee_id%TYPE)
RETURN employees.hire_date%TYPE IS
  v_name employees.hire_date%TYPE;
BEGIN
  SELECT HIRE_DATE INTO v_name FROM employees WHERE employee_id = p_employee_id;
  RETURN v_name;
END;
/

SELECT employee_id, get_hire_date(employee_id) AS hire_date FROM employees;

--M10. Use employee_count(50) in WHERE: SELECT * FROM departments WHERE employee_count(department_id) > 0 --Hint: Function in WHERE (may be expensive per row).

CREATE OR REPLACE FUNCTION employee_count(p_dept_id IN departments.department_id%TYPE)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM employees WHERE department_id = p_dept_id;
  RETURN v_count;
END;
/

-- Usage:
SELECT distinct department_id, employee_count(department_id) FROM employees
where employee_count(department_id) > 0;

--M11. Function total_salary(p_dept_id) RETURN NUMBER--Hint: SELECT NVL(SUM(salary),0) INTO v FROM employees WHERE department_id = p_dept_id; RETURN v;

CREATE OR REPLACE FUNCTION total_salary(p_dept_id IN departments.department_id%TYPE)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT NVL(sum(SALARY),0) INTO v_count FROM employees WHERE department_id = p_dept_id;
  RETURN v_count;
END;
/

SELECT department_id, total_salary(department_id) AS max_salary FROM departments;

--M12. Function with two parameters: p_emp_id, return salary--Hint: get_salary(p_emp_id) RETURN NUMBER; SELECT salary INTO v FROM employees WHERE employee_id = p_emp_id;

CREATE OR REPLACE FUNCTION get_salary(p_employee_id IN employees.employee_id%TYPE)
RETURN NUMBER IS
  v_name NUMBER;
BEGIN
  SELECT SALARY INTO v_name FROM employees WHERE employee_id = p_employee_id;
  RETURN v_name;
END;
/

SELECT employee_id, get_salary(employee_id) AS salary FROM employees;

--M13. Function that returns commission_pct or 0 if NULL--Hint: RETURN NVL(commission_pct, 0) or SELECT NVL(commission_pct,0) INTO v ...

CREATE OR REPLACE FUNCTION get_commission_pct(p_employee_id IN employees.employee_id%TYPE)
RETURN employees.commission_pct%TYPE IS
  v_name employees.commission_pct%TYPE;
BEGIN
  SELECT  NVL(commission_pct, 0) INTO v_name FROM employees WHERE employee_id = p_employee_id;
  RETURN v_name;
END;
/

SELECT employee_id, get_commission_pct(employee_id) AS salary FROM employees;

--M14. Function dept_has_employees(p_dept_id) RETURN NUMBER (1 if count>0, 0 else)--Hint: v := 0; SELECT COUNT(*) INTO c FROM ...; IF c > 0 THEN v := 1; END IF; RETURN v;

CREATE OR REPLACE FUNCTION dept_has_employees(p_dept_id IN departments.department_id%TYPE)
RETURN BOOLEAN IS
  v_count BOOLEAN;
BEGIN
  SELECT case when COUNT(*) > 0 Then 1 else 0 END INTO v_count FROM employees WHERE department_id = p_dept_id;
  RETURN v_count;
END;
/

-- Usage:
SELECT department_id, dept_has_employees(department_id) FROM departments;

--M15. Use %TYPE for return type: RETURN departments.department_name%TYPE--Hint: RETURN type matches column type.

CREATE OR REPLACE FUNCTION get_department_name(p_dept_id IN departments.department_id%TYPE)
RETURN departments.department_name%TYPE IS
  v_name departments.department_name%TYPE;
BEGIN
  SELECT department_name INTO v_name FROM DEPARTMENTS WHERE department_id = p_dept_id;
  RETURN v_name;
END;
/

-- Usage:
SELECT distinct department_id, get_department_name(department_id) FROM employees;

--M16. Function that returns job_id for employee_id--Hint: SELECT job_id INTO v FROM employees WHERE employee_id = p_emp_id; RETURN v;

CREATE OR REPLACE FUNCTION get_job_id(p_emp_id IN employees.employee_id%TYPE)
RETURN departments.department_name%TYPE IS
  v_name departments.department_name%TYPE;
BEGIN
  SELECT job_id INTO v_name FROM employees WHERE employee_id = p_emp_id;
  RETURN v_name;
END;
/

-- Usage:
SELECT distinct employee_id, get_job_id(employee_id) FROM employees;

--M17. Function in ORDER BY: SELECT * FROM employees ORDER BY get_department_name(department_id)--Hint: ORDER BY function(department_id);

CREATE OR REPLACE FUNCTION get_department_name(p_dept_id IN departments.department_id%TYPE)
RETURN departments.department_name%TYPE IS
  v_name departments.department_name%TYPE;
BEGIN
  SELECT department_name INTO v_name FROM DEPARTMENTS WHERE department_id = p_dept_id;
  RETURN v_name;
END;
/

-- Usage:
SELECT * FROM employees order by get_department_name(department_id);

--M18. Function years_employed(p_emp_id) RETURN NUMBER (MONTHS_BETWEEN/12)--Hint: SELECT MONTHS_BETWEEN(SYSDATE, hire_date)/12 INTO v FROM employees WHERE employee_id = p_emp_id; RETURN v;

CREATE OR REPLACE FUNCTION years_employed(p_emp_id IN employees.employee_id%TYPE)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT MONTHS_BETWEEN(SYSDATE, hire_date)/12 INTO v_count FROM employees WHERE employee_id = p_emp_id;
  RETURN v_count;
END;
/

-- Usage:
SELECT distinct employee_id, years_employed(employee_id) Tenure FROM employees;

--M19. Function that returns 1 if department exists, 0 otherwise--Hint: SELECT COUNT(*) INTO v FROM departments WHERE department_id = p_dept_id; RETURN CASE WHEN v > 0 THEN 1 ELSE 0 END;

CREATE OR REPLACE FUNCTION dept_has_employees(p_dept_id IN departments.department_id%TYPE)
RETURN BOOLEAN IS
  v_count BOOLEAN;
BEGIN
  SELECT case when COUNT(*) > 0 Then 1 else 0 END INTO v_count FROM departments WHERE department_id = p_dept_id;
  RETURN v_count;
END;
/

-- Usage:
SELECT distinct department_id, dept_has_employees(department_id) FROM employees;

--M20. DETERMINISTIC function: format_name(first, last) return 'Last, First'--Hint: RETURN p_last || ', ' || p_first; DETERMINISTIC;

CREATE OR REPLACE FUNCTION format_name(p_first_name IN employees.first_name%TYPE, p_last_name IN employees.last_name%TYPE)
RETURN employees.first_name%TYPE IS
  v_name employees.first_name%TYPE;
BEGIN
  SELECT p_first_name||' '||p_last_name INTO v_name FROM DUAL;
  RETURN v_name;
END;
/

-- Usage:
SELECT distinct employee_id, format_name(first_name, last_name) FROM employees;


--20 Hard Questions

--H1. Function that returns BOOLEAN: dept_has_employees(p_dept_id). Call from PL/SQL only--Hint: RETURN (SELECT COUNT(*) FROM employees WHERE department_id = p_dept_id) > 0; or SELECT COUNT(*) INTO v; RETURN v > 0;



--H2. Function used in function-based index: UPPER(last_name) — create function my_upper(p_val) DETERMINISTIC RETURN UPPER(p_val); Hint: Must be DETERMINISTIC; CREATE INDEX idx ON employees(my_upper(last_name));

CREATE OR REPLACE FUNCTION uppr_name(p_last_name IN employees.last_name%TYPE)
RETURN employees.first_name%TYPE IS
  v_name employees.first_name%TYPE;
BEGIN
  SELECT upper(p_last_name) INTO v_name FROM DUAL;
  RETURN v_name;
END;
/

-- Usage:
SELECT distinct employee_id, uppr_name(last_name) FROM employees;

--H3. Function that returns VARCHAR2: list of employee last_names in department (LISTAGG)--Hint: SELECT LISTAGG(last_name, ', ') WITHIN GROUP (ORDER BY last_name) INTO v FROM employees WHERE department_id = p_dept_id; RETURN v;

CREATE OR REPLACE FUNCTION get_last_name_list(p_dept_id IN departments.department_id%TYPE)
RETURN employees.first_name%TYPE IS
  v_name employees.first_name%TYPE;
BEGIN
  SELECT LISTAGG(last_name, ', ') WITHIN GROUP (ORDER BY last_name) INTO v_name FROM employees WHERE department_id = p_dept_id;
  RETURN v_name;
END;
/

-- Usage:
SELECT distinct department_id, get_last_name_list(department_id) FROM employees;

--H4. Function with exception: return NULL on NO_DATA_FOUND, re-raise TOO_MANY_ROWS--Hint: EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL; WHEN TOO_MANY_ROWS THEN RAISE;

CREATE OR REPLACE FUNCTION get_department_name(p_dept_id IN departments.department_id%TYPE)
RETURN departments.department_name%TYPE IS
  v_name departments.department_name%TYPE;
BEGIN
  SELECT department_name INTO v_name FROM departments WHERE department_id = p_dept_id;
  RETURN v_name;
EXCEPTION
  WHEN NO_DATA_FOUND THEN RETURN NULL;
END;
/

select get_department_name(50) from dual;

--H5. Function that takes job_id and department_id, returns count of employees--Hint: SELECT COUNT(*) INTO v FROM employees WHERE job_id = p_job_id AND department_id = p_dept_id; RETURN v;

CREATE OR REPLACE FUNCTION get_emp_count(p_dept_id IN employees.department_id%TYPE, p_job_id IN employees.job_id%TYPE)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT count(*) INTO v_count FROM employees WHERE department_id = p_dept_id and job_id = p_job_id;
  RETURN v_count;
END;
/

-- Usage:
SELECT distinct department_id, job_id, get_emp_count(department_id, job_id) FROM employees;

--H6. Function returning DATE: earliest hire_date in department--Hint: SELECT MIN(hire_date) INTO v FROM employees WHERE department_id = p_dept_id; RETURN v;

CREATE OR REPLACE FUNCTION first_hire_date(p_dept_id IN employees.department_id%TYPE)
RETURN employees.hire_date%TYPE IS
  v_name employees.hire_date%TYPE;
BEGIN
  SELECT min(hire_date) INTO v_name FROM employees WHERE department_id = p_dept_id;
  RETURN v_name;
END;
/

-- Usage:
SELECT distinct department_id, first_hire_date(department_id) Tenure FROM employees;

--H7. Function in SELECT with GROUP BY: department_id, get_department_name(department_id)--Hint: SELECT department_id, get_department_name(department_id) FROM employees GROUP BY department_id;

CREATE OR REPLACE FUNCTION get_department_name(p_dept_id IN employees.department_id%TYPE)
RETURN departments.department_name%TYPE IS
  v_name departments.department_name%TYPE;
BEGIN
  SELECT department_name INTO v_name FROM departments WHERE department_id = p_dept_id;
  RETURN v_name;
END;
/

-- Usage:
SELECT distinct department_id, get_department_name(department_id) Tenure FROM employees;

--H8. Function salary_band(p_salary) RETURN VARCHAR2: 'Low'/<5000, 'Mid'/<10000, 'High'--Hint: RETURN CASE WHEN p_salary < 5000 THEN 'Low' WHEN p_salary < 10000 THEN 'Mid' ELSE 'High' END;

CREATE OR REPLACE FUNCTION salary_band(p_salary IN employees.salary%TYPE)
RETURN departments.department_name%TYPE IS
  v_count departments.department_name%TYPE;
BEGIN
  SELECT CASE WHEN p_salary < 5000 THEN 'Low' WHEN p_salary < 10000 THEN 'Mid' ELSE 'High' END INTO v_count FROM DUAL;
  RETURN v_count;
END;
/

-- Usage:
SELECT distinct employee_id, salary, salary_band(salary) FROM employees;

--H9. Function that returns manager's last_name for employee_id (self-join in function)--Hint: SELECT m.last_name INTO v FROM employees e JOIN employees m ON e.manager_id = m.employee_id WHERE e.employee_id = p_emp_id; RETURN v;

CREATE OR REPLACE FUNCTION get_manager_name(p_emp_id IN employees.employee_id%TYPE)
RETURN employees.last_name%TYPE IS
  v_name employees.last_name%TYPE;
BEGIN
  SELECT last_name INTO v_name FROM employees WHERE employee_id = p_emp_id;
  RETURN v_name;
END;
/

-- Usage:
SELECT distinct employee_id, get_manager_name(manager_id) manager_last_name FROM employees;

--H10. Function with OUT parameter (not for SQL use): get_emp_info(p_emp_id, p_name OUT) RETURN salary--Hint: Function can have OUT but then cannot use in SQL SELECT; RETURN v_salary;

CREATE OR REPLACE FUNCTION get_manager_name(p_emp_id IN employees.employee_id%TYPE, p_name OUT employees.last_name%TYPE)
RETURN NUMBER IS
  v_name NUMBER;
BEGIN
  SELECT last_name INTO p_name FROM employees WHERE employee_id = p_emp_id;
  SELECT salary INTO v_name FROM employees WHERE employee_id = p_emp_id;
  RETURN v_name;
END;
/

--H11. Function that returns NUMBER: difference between employee salary and department avg--Hint: Get employee salary and department avg (two SELECTs or one with subquery); RETURN v_sal - v_avg;

CREATE OR REPLACE FUNCTION get_department_salary(p_dept_id IN employees.department_id%TYPE,p_salary in NUMBER)
RETURN number IS
  v_name number;
BEGIN
  SELECT sum(salary) - p_salary INTO v_name FROM EMPLOYEES WHERE department_id = p_dept_id;
  RETURN v_name;
END;
/

-- Usage:
SELECT distinct employee_id, department_id, salary, get_department_salary(department_id, SALARY) Salary_diff FROM employees;

--H12. Function department_name_length(p_dept_id) RETURN NUMBER--Hint: SELECT LENGTH(department_name) INTO v FROM departments WHERE department_id = p_dept_id; RETURN v;

CREATE OR REPLACE FUNCTION department_name_length(p_dept_id IN employees.department_id%TYPE)
RETURN NUMBER IS
  v_name NUMBER;
BEGIN
  SELECT LENGTH(department_name) INTO v_name FROM departments WHERE department_id = p_dept_id;
  RETURN v_name;
END;
/

-- Usage:
SELECT distinct department_id, department_name_length(department_id) dept_name_length FROM employees;

--H13. Use function in CASE: SELECT CASE WHEN employee_count(department_id) > 10 THEN 'Large' ..--Hint: CASE WHEN employee_count(department_id) > 10 THEN 'Large' ELSE 'Small' END FROM departments;

CREATE OR REPLACE FUNCTION employee_count(p_dept_id IN departments.department_id%TYPE)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM employees WHERE department_id = p_dept_id;
  RETURN v_count;
END;
/

-- Usage:
select department_id, CASE WHEN employee_count(department_id) > 10 THEN 'Large' ELSE 'Small' END FROM departments;

--H14. Function that returns total salary of employees reporting to a given manager_id--Hint: SELECT NVL(SUM(salary),0) INTO v FROM employees WHERE manager_id = p_mgr_id; RETURN v;

CREATE OR REPLACE FUNCTION total_salary(p_mngr_id IN employees.manager_id%TYPE)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT NVL(sum(SALARY),0) INTO v_count FROM employees WHERE manager_id = p_mngr_id;
  RETURN v_count;
END;
/

SELECT distinct manager_id, total_salary(manager_id) AS Total_salary FROM employees;

--H15. Function returning VARCHAR2: 'YES'/'NO' if department has any employee with commission_pct > --Hint: SELECT COUNT(*) INTO v FROM employees WHERE department_id = p_dept_id AND commission_pct > 0; RETURN CASE WHEN v > 0 THEN 'YES' ELSE 'NO' END;

CREATE OR REPLACE FUNCTION get_commission_pct(p_dept_id IN departments.department_id%TYPE)
RETURN NUMBER IS
  v_name NUMBER;
BEGIN
  SELECT  count(*) INTO v_name FROM employees WHERE department_id = p_dept_id AND commission_pct > 0;
  RETURN v_name;
END;
/

SELECT distinct department_id, CASE WHEN get_commission_pct(department_id) > 0 THEN 'YES' ELSE 'NO' END AS commission_pct_count FROM departments;

--H16. Function with two IN parameters returning NUMBER: ratio of two department counts--Hint: c1 := employee_count(p_dept1); c2 := employee_count(p_dept2); RETURN c1/NULLIF(c2,0);


CREATE OR REPLACE FUNCTION get_dept_ratio(p_dept_id1 IN departments.department_id%TYPE, p_dept_id2 IN departments.department_id%TYPE)
RETURN NUMBER IS
  v_name NUMBER;
BEGIN
  select (SELECT  count(*) FROM employees WHERE department_id = p_dept_id1)/NULLIF((SELECT count(*) FROM employees WHERE department_id = p_dept_id2),0) INTO v_name FROM dual;
  RETURN v_name;
END;
/

SELECT distinct '50' department_id1, '80' department_id2, get_dept_ratio(50, 80) FROM departments;

--H17. Function that returns employee_id of highest-paid in department (handle tie: return one)--Hint: SELECT employee_id INTO v FROM (SELECT employee_id FROM employees WHERE department_id = p_dept_id ORDER BY salary DESC FETCH FIRST 1 ROW ONLY); RETURN v;

CREATE OR REPLACE FUNCTION get_employee_id(p_dept_id IN departments.department_id%TYPE)
RETURN employees.employee_id%TYPE IS
  v_count employees.employee_id%TYPE;
BEGIN
  SELECT employee_id INTO v_count FROM (SELECT employee_id FROM employees WHERE department_id = p_dept_id ORDER BY salary DESC FETCH FIRST 1 ROW ONLY);
  RETURN v_count;
END;
/

-- Usage:
select department_id, get_employee_id(department_id) employee_id FROM departments;

--H18. Pipelined function (advanced): return rows of (employee_id, last_name) for department--Hint: PIPELINED; PIPE ROW(...); RETURN; (advanced topic)



--H19. Function used in CHECK constraint (Oracle 11g+): constraint check (my_func(salary) = 1)--Hint: Function must be DETERMINISTIC and declared in same schema; CHECK (validate_salary(salary) = 1)



--H20. Function that returns default department_id if p_dept_id is NULL: NVL(p_dept_id, 50)--Hint: RETURN NVL(p_dept_id, 50); or IF p_dept_id IS NULL THEN RETURN 50; ELSE RETURN p_dept_id; END IF;

CREATE OR REPLACE FUNCTION get_department_id(p_dept_id IN departments.department_id%TYPE)
RETURN employees.employee_id%TYPE IS
  v_count employees.employee_id%TYPE;
BEGIN
  SELECT NVL(p_dept_id, 50) INTO v_count FROM DUAL;
  RETURN v_count;
END;
/

-- Usage:
select distinct department_id, get_department_id(department_id) modified_department_id FROM employees order by department_id;
