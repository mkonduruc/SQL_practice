/*Day 19 Assignment: Views
All exercises use hr.employees and hr.departments only.
Part 1: Practice Questions (With Answers and Explanations)*/

/*Question 1
Create a view that shows employee_id, first_name, last_name, and department_name. Join hr.employees and hr.departments. Name the view (e.g. emp_dept_view).
Answer:*/

CREATE OR REPLACE VIEW emp_dept_view AS
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id;

--Explanation: The view is a saved SELECT. Users can query the view without writing the join. Ensure you have CREATE VIEW privilege and that the view is created in the correct schema.

/*Question 2
Create a view that shows department_id, department_name, and total salary and employee count for each department (aggregation over hr.employees joined to hr.departments).
Answer:*/

CREATE OR REPLACE VIEW dept_totals_view AS
SELECT d.department_id, d.department_name,
  COUNT(e.employee_id) AS employee_count,
  SUM(e.salary) AS total_salary
FROM hr.departments d
LEFT JOIN hr.employees e ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

--Explanation: LEFT JOIN so departments with no employees still appear with count 0 and total_salary NULL (use NVL(SUM(e.salary),0) if you want 0). This is a complex view (aggregation); it is not directly updatable.

/*Question 3
Create a view on hr.employees that shows only employees in department_id 50, with columns employee_id, first_name, last_name, department_id. Add WITH CHECK OPTION so that inserts/updates through the view cannot set department_id to a value other than 50.
Answer:*/

CREATE OR REPLACE VIEW emp_dept50_view AS
SELECT employee_id, first_name, last_name, department_id
FROM hr.employees
WHERE department_id = 50
WITH CHECK OPTION;

--Explanation: WITH CHECK OPTION ensures that any INSERT or UPDATE through this view satisfies the view's WHERE condition, so department_id must remain 50.


/*Part 2: Self-Practice (No Answers)*/

--1. Create a view of hr.employees that includes only rows where salary > 10000, showing employee_id, first_name, last_name, salary.

CREATE OR REPLACE VIEW emp_Sal_10k AS
select employee_id, first_name, last_name, salary 
from hr.employees 
where salary > 10000;

--2. Create a view that joins hr.employees and hr.departments and shows only departments in a specific location_id (e.g. 1700). Show employee_id, first_name, department_name.

CREATE OR REPLACE VIEW emp_deprt AS
select employee_id, first_name, department_name
from hr.EMPLOYEES emp join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID;

/*Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)
All use hr.employees and hr.departments only.*/

--20 Medium Questions

--M1. Create view: employee_id, first_name, last_name, department_name (join)--Hint: CREATE VIEW v AS SELECT e.employee_id, e.first_name, e.last_name, d.department_name FROM hr.employees e JOIN hr.departments d ON e.department_id = d.department_id;

CREATE OR REPLACE VIEW emp_deprt AS
select employee_id, first_name, last_name, department_name
from hr.EMPLOYEES emp join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID;

--M2. Create view of employees where department_id = 50--Hint: CREATE VIEW v AS SELECT * FROM hr.employees WHERE department_id = 50;

CREATE OR REPLACE VIEW emp_deprt AS
select employee_id, first_name, last_name
from hr.EMPLOYEES where department_id = 50;

--M3. Create view with WITH READ ONLY--Hint: ... WITH READ ONLY;

CREATE OR REPLACE VIEW emp_deprt AS
select employee_id, first_name, last_name
from hr.EMPLOYEES where department_id = 50
WITH READ ONLY; 

--M4. Create view with WITH CHECK OPTION (filter department_id = 80)--Hint: WHERE department_id = 80 WITH CHECK OPTION;

CREATE OR REPLACE VIEW emp_deprt AS
select employee_id, first_name, last_name
from hr.EMPLOYEES where department_id = 50
WITH CHECK OPTION; 

--M5. Create view: department_name, COUNT(employee_id) — need GROUP BY--Hint: View with GROUP BY (complex view).

CREATE OR REPLACE VIEW emp_deprt AS
select department_name, COUNT(employee_id)
from hr.EMPLOYEES emp join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID
group by dpt.department_name;

--M6. Select from your view--Hint: SELECT * FROM your_view;

CREATE OR REPLACE VIEW emp_deprt_view AS
SELECT * FROM emp_deprt; 

--M7. Create view that hides salary (no salary column)--Hint: SELECT employee_id, first_name, last_name, department_id FROM hr.employees;

CREATE OR REPLACE VIEW emp_wo_salary AS
select employee_id, first_name, last_name, department_id FROM hr.employees;

--M8. Create view: employees in 'Sales' department--Hint: Join employees and departments WHERE d.department_name = 'Sales';

CREATE OR REPLACE VIEW emp_deprt_sales AS
select emp.employee_id, last_name, first_name 
from hr.EMPLOYEES emp join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID
WHERE department_name = 'Sales';

--M9. Replace view definition (CREATE OR REPLACE VIEW)--Hint: CREATE OR REPLACE VIEW ... AS ...;

CREATE OR REPLACE VIEW emp_deprt_sales AS
select emp.employee_id, last_name, first_name 
from hr.EMPLOYEES emp join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID
WHERE department_name = 'Sales' and emp.MANAGER_ID is not null; 

--M10. Create view with columns: employee_id, full_name (first||' '||last), department_id--Hint: SELECT employee_id, first_name||' '||last_name AS full_name, department_id FROM hr.employees;

CREATE OR REPLACE VIEW emp_mod AS
select employee_id, full_name (first||' '||last), department_id
from hr.employees;

--M11. Drop a view--Hint: DROP VIEW view_name;

DROP VIEW emp_deprt;

--M12. Create view of hr.departments (all columns)--Hint: CREATE VIEW v AS SELECT * FROM hr.departments;

CREATE OR REPLACE VIEW department_view AS
select * FROM hr.departments;

--M13. Create view with WHERE salary > 500--Hint: SELECT ... FROM hr.employees WHERE salary > 5000;

CREATE OR REPLACE VIEW emp_deprt AS
select * from hr.EMPLOYEES
where salary > 5000;

--M14. Create view joining employees and departments; show only department_id, department_name, total_salary (SUM)--Hint: GROUP BY in view; SUM(salary).

CREATE OR REPLACE VIEW emp_deprt AS
select dpt.department_id, department_name, sum(salary) total_salary
from hr.EMPLOYEES emp join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID
group by dpt.department_id, department_name;

--M15. Create view with alias column names--Hint: SELECT employee_id AS id, first_name AS fname, ...;

CREATE OR REPLACE VIEW emp_deprt AS
select employee_id AS id, first_name AS fname, last_name as lname, salary as income 
from hr.employees;

--M16. Create view: job_id and AVG(salary) per job--Hint: SELECT job_id, AVG(salary) FROM hr.employees GROUP BY job_id;

CREATE OR REPLACE VIEW emp_job_id AS
select job_id, avg(salary) avg_salary 
from hr.EMPLOYEES
group by job_id;

--M17. Create view with WITH CHECK OPTION for salary > 0 --Hint: WHERE salary > 0 WITH CHECK OPTION;

CREATE OR REPLACE VIEW emp_deprt AS
select * from hr.EMPLOYEES
where saLary > 0
WITH CHECK OPTION;

--M18. Create view that shows employee_id, first_name, last_name, department_name, salary (join)--Hint: Join e and d; include salary.

CREATE OR REPLACE VIEW emp_deprt AS
select employee_id, first_name, last_name, department_name, salary
from hr.EMPLOYEES emp join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID;

--M19. List views in schema (USER_VIEWS)--Hint: SELECT view_name FROM user_views;

SELECT view_name FROM user_views;

--M20. Create view of employees with commission_pct IS NOT NULL--Hint: WHERE commission_pct IS NOT NULL;

CREATE OR REPLACE VIEW emp_deprt AS
select employee_id, first_name, last_name, commission_pct, salary
from hr.EMPLOYEES
where commission_pct IS NOT NULL;

--20 Hard Questions

--H1. Create view: department_id, department_name, employee_count, total_salary (join + aggregation)--Hint: Join e and d, GROUP BY d.department_id, d.department_name; COUNT(*), SUM(salary).

CREATE OR REPLACE VIEW emp_deprt AS
select emp.department_id, department_name, count(distinct employee_id) employee_count, sum(salary) total_salary
from hr.EMPLOYEES emp join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID
group by emp.department_id, department_name;

--H2. Create updatable view (simple, one table) with WITH CHECK OPTION; try INSERT through view--Hint: Simple view on one table; WITH CHECK OPTION; INSERT must satisfy WHERE.

CREATE VIEW employee_insert AS
select * from hr.EMPLOYEES
WITH CHECK OPTION;

--H3. Create view that shows top 5 highest-paid employees (use ROWNUM or FETCH in subquery)--Hint: CREATE VIEW v AS SELECT * FROM (SELECT * FROM hr.employees ORDER BY salary DESC FETCH FIRST 5 ROWS ONLY);

CREATE OR REPLACE VIEW emp_deprt AS
select * from hr.EMPLOYEES
order by salary desc
fetch first 5 rows only;

--H4. Create view with ROWID or primary key so it might be key-preserved for update (concept)--Hint: Include primary key columns for key-preserved view.


--H5. Create view: employee_id, manager_id, manager_name (self-join in view)--Hint: e LEFT JOIN employees m ON e.manager_id = m.employee_id; select e.employee_id, e.manager_id, m.first_name||' '||m.last_name AS manager_name.

CREATE OR REPLACE VIEW emp_mngr AS
select emp.employee_id, emp.manager_id, mngr.first_name||' '||mngr.last_name as manager_name
from hr.employees emp join hr.employees mngr on emp.MANAGER_ID = mngr.employee_id;

--H6. Create view with DISTINCT (e.g. distinct job_id from employees)--Hint: CREATE VIEW v AS SELECT DISTINCT job_id FROM hr.employees;

CREATE OR REPLACE VIEW emp_job_id AS
select distinct job_id from hr.employees;

--H7. Create view that joins 3 "tables": employees, departments, and (SELECT department_id, COUNT(*) c FROM hr.employees GROUP BY department_id) sub--Hint: Join employees, departments, and inline view sub on department_id.

CREATE OR REPLACE VIEW emp_deprt AS
select emp.employee_id, department_name, employee_count
from hr.EMPLOYEES emp join hr.departments dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID
join (SELECT department_id, COUNT(*) employee_count FROM hr.employees GROUP BY department_id) rfr on dpt.DEPARTMENT_ID = rfr.DEPARTMENT_ID;

--H8. Create view with CASE in SELECT (e.g. salary_band)--Hint: SELECT ..., CASE WHEN salary < 5000 THEN 'Low' ... END AS salary_band FROM hr.employees;

CREATE OR REPLACE VIEW emp_deprt AS
select employee_id, salary, CASE WHEN salary < 5000 THEN 'Low'  WHEN salary > 5000 then 'High' END AS salary_band
from hr.employees;

--H9. Create view with WITH CHECK OPTION for department_id IN (10,20,30)--Hint: WHERE department_id IN (10,20,30) WITH CHECK OPTION;

CREATE OR REPLACE VIEW emp_deprt AS
select * from hr.employees 
where department_id IN (10,20,30
WITH CHECK OPTION;

--H10. Create view that is read-only and shows only non-sensitive columns (no salary, no commission_pct)--Hint: SELECT employee_id, first_name, last_name, department_id, hire_date, job_id FROM hr.employees WITH READ ONLY;

CREATE OR REPLACE VIEW emp_deprt AS
select * from hr.employees 
where department_id IN (10,20,30)
WITH Read only; 

--H11. Replace view to add a column--Hint: CREATE OR REPLACE VIEW ... AS SELECT ..., new_column FROM ...;

CREATE OR REPLACE VIEW emp_deprt AS
select emp.*, dpt.department_name from hr.employees emp
join hr.departments dpt on emp.department_id = dpt.department_id
where emp.department_id IN (10,20,30)
WITH Read only;  

--H12. Create view: department_name and list of employee last_names (aggregate string — Oracle LISTAGG)--Hint: SELECT d.department_name, LISTAGG(e.last_name, ', ') WITHIN GROUP (ORDER BY e.last_name) FROM hr.employees e JOIN hr.departments d ON e.department_id = d.department_id GROUP BY d.department_id, d.department_name;

CREATE OR REPLACE VIEW emp_deprt AS
select department_name, LISTAGG(last_name, ', ') WITHIN GROUP (ORDER BY last_name) 
FROM hr.employees emp JOIN hr.departments dpt ON emp.department_id = dpt.department_id 
GROUP BY department_name;

--H13. Create view with subquery in SELECT (e.g. department_name as scalar subquery)--Hint: SELECT e.employee_id, (SELECT d.department_name FROM hr.departments d WHERE d.department_id = e.department_id) FROM hr.employees e;

CREATE OR REPLACE VIEW emp_deprt AS
select emp.employee_id, 
(SELECT dpt.department_name FROM hr.departments dpt WHERE dpt.department_id = emp.department_id) department_name
FROM hr.employees emp;

--H14. Create view that shows employees and their rank by salary within department (window function)--Hint: SELECT e.*, RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS sal_rank FROM hr.employees e;

CREATE OR REPLACE VIEW emp_rank AS
select emp.*, RANK() OVER (PARTITION BY emp.department_id ORDER BY emp.salary DESC) AS sal_rank 
FROM hr.employees emp;

--H15. Grant SELECT on view to a role--Hint: GRANT SELECT ON view_name TO role_name;

GRANT SELECT ON emp_rank TO role_name;

--H16. Create view with HAVING (e.g. departments with count > 5)--Hint: View from (SELECT department_id, COUNT(*) c FROM hr.employees GROUP BY department_id HAVING COUNT(*) > 5) or join and group in view with HAVING.

CREATE OR REPLACE VIEW emp_deprt AS
SELECT department_id, COUNT(*) employee_count 
FROM hr.employees 
GROUP BY department_id 
HAVING COUNT(*) > 5; 

--H17. Create view: employees with salary above department average (use subquery or join to avg)--Hint: Join employees to (SELECT department_id, AVG(salary) a FROM hr.employees GROUP BY department_id) and WHERE e.salary > sub.a.

CREATE OR REPLACE VIEW emp_deprt AS
select employee_id, salary, avg_salary from hr.employees emp 
join (select department_id, AVG(salary) avg_salary 
FROM hr.employees GROUP BY department_id) rfr on emp.department_id = rfr.department_id 
WHERE emp.salary > rfr.avg_salary;

--H18. Create view with UNION (e.g. two queries from employees)--Hint: CREATE VIEW v AS SELECT ... FROM hr.employees WHERE ... UNION SELECT ... FROM hr.employees WHERE ...;

CREATE OR REPLACE VIEW emp_deprt AS
select * from hr.employees where department_id = 50
union
select * from hr.employees where department_id = 80;

--H19. Create view that references another view--Hint: CREATE VIEW v2 AS SELECT * FROM your_view WHERE ...;

CREATE OR REPLACE VIEW emp_deprt_v2 AS
select * from emp_deprt
where job_id is not null;

--H20. Create view with ORDER BY (Oracle: order in view may not be guaranteed in subsequent SELECT)--Hint: CREATE VIEW v AS SELECT * FROM hr.employees ORDER BY salary DESC; — document that order not guaranteed when selecting from view.

CREATE OR REPLACE VIEW emp_deprt AS
SELECT * FROM hr.employees ORDER BY salary DESC;
