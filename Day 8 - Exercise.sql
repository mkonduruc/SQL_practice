/*Day 8 Assignment: All Join Types
All exercises use hr.employees and hr.departments only.
Part 1: Practice Questions (With Answers and Explanations)*/

/*Question 1  
List all departments and the count of employees in each. Include departments that have zero employees.
Answer:*/

SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS employee_count
FROM hr.departments d
LEFT JOIN hr.employees e ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

--Explanation: Use departments as the left table and LEFT JOIN employees so every department appears. COUNT(e.employee_id) counts only matching employees; departments with no employees get 0 (because employee_id is NULL for those rows).

/*Question 2  
For each employee, show the employee’s first and last name and the manager’s first and last name (self-join on manager_id).
Answer:*/

SELECT e.first_name AS emp_first, e.last_name AS emp_last,
       m.first_name AS mgr_first, m.last_name AS mgr_last
FROM hr.employees e
LEFT JOIN hr.employees m ON e.manager_id = m.employee_id;

--Explanation: Join hr.employees to itself: e = employee, m = manager. ON e.manager_id = m.employee_id. LEFT JOIN so employees with no manager (manager_id NULL) still appear with NULL for manager name.

/*Question 3  
List employees who have no department (department_id is NULL in hr.employees). Use a left join to departments and filter where department is missing.
Answer:*/

SELECT e.employee_id, e.first_name, e.last_name, e.department_id
FROM hr.employees e
LEFT JOIN hr.departments d ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

--Explanation: LEFT JOIN keeps all employees. Where an employee has no matching department (e.g. department_id NULL or not in departments), d.department_id is NULL. Filtering WHERE d.department_id IS NULL returns only those employees.


/*Part 2: Self-Practice (No Answers)*/

--1. Using a self-join, show two levels of hierarchy: employee → manager → manager’s manager (if exists).

SELECT emp.employee_id, emp.first_name, emp.last_name, emp.manager_id, mngr.first_name manager_first_name, mngr.last_name manager_last_name,
mngr.MANAGER_ID senior_manager, snr_mngr.first_name senior_manager_first_name, snr_mngr.last_name senior_manager_last_name 
FROM hr.employees emp 
join hr.employees mngr on emp.manager_id = mngr.employee_id
left join hr.employees snr_mngr on mngr.MANAGER_ID = snr_mngr.employee_id;

--2. List departments that have no employees (use RIGHT JOIN or a subquery / NOT EXISTS from departments).

SELECT dept.department_name, count(distinct emp.employee_id) employee_count
FROM hr.employees emp
right JOIN hr.departments dept ON emp.department_id = dept.department_id
group by emp.department_id, dept.department_name
having employee_count = 0;

select department_name from hr.departments dpt
where not exists (select distinct department_id from hr.EMPLOYEES emp where emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID);

/*Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)
All use hr.employees and hr.departments only.*/

--20 Medium Questions

--M1. List all employees (employee_id, first_name, last_name) and department_name; include employees with no department (LEFT JOIN).  
--Hint: FROM hr.employees e LEFT JOIN hr.departments d ON e.department_id = d.department_id;

select emp.employee_id, emp.first_name, emp.last_name, emp.department_id, dpt.department_name
from hr.EMPLOYEES emp
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID ;

--M2. For each employee show first_name, last_name, and manager's first_name and last_name (self-join).  
--Hint: e LEFT JOIN employees m ON e.manager_id = m.employee_id;

select emp.employee_id, emp.first_name, emp.last_name, emp.manager_id, mngr.first_name Manager_first_name, mngr.last_name Manager_last_name
from hr.EMPLOYEES emp
left join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id;

--M3. List all departments (department_id, department_name) and count of employees; include departments with 0 employees.  
--Hint: FROM hr.departments d LEFT JOIN hr.employees e ON d.department_id = e.department_id GROUP BY d.department_id, d.department_name; COUNT(e.employee_id);

select dpt.department_id, dpt.department_name, count(distinct emp.employee_id) employee_count
from hr.EMPLOYEES emp
right join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID 
group by dpt.department_id, department_name;

--M4. Show employees who have no department (LEFT JOIN to departments, WHERE d.department_id IS NULL).  
--Hint: LEFT JOIN then WHERE d.department_id IS NULL;

select emp.employee_id, emp.first_name, emp.last_name, emp.department_id, dpt.department_name
from hr.EMPLOYEES emp
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID 
where emp.DEPARTMENT_ID is NULL;

--M5. List employee first_name, last_name, and department_name; use COALESCE(d.department_name, 'No Dept').  
--Hint: LEFT JOIN; SELECT e.first_name, e.last_name, COALESCE(d.department_name, 'No Dept');

select emp.employee_id, emp.first_name, emp.last_name, emp.department_id, COALESCE(dpt.department_name, 'No Dept') department_name
from hr.EMPLOYEES emp
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID ;

--M6. Show all departments and total salary in each (include departments with 0 salary).  
--Hint: FROM hr.departments d LEFT JOIN hr.employees e ON d.department_id = e.department_id GROUP BY d.department_id, d.department_name; SUM(e.salary);

select dpt.department_id, dpt.department_name, nvl(sum(emp.salary),0) total_salary
from hr.EMPLOYEES emp
right join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID 
group by dpt.department_id, department_name;

--M7. For each employee show name and manager name; use LEFT JOIN so employees without manager appear.  
--Hint: e LEFT JOIN employees m ON e.manager_id = m.employee_id;

select emp.employee_id, emp.first_name, emp.last_name, emp.manager_id, mngr.first_name Manager_first_name, mngr.last_name Manager_last_name
from hr.EMPLOYEES emp
left join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id;

--M8. List departments (department_name) that have no employees (RIGHT JOIN from employees to departments then WHERE e.employee_id IS NULL, or NOT EXISTS).  
--Hint: FROM hr.departments d LEFT JOIN hr.employees e ON d.department_id = e.department_id WHERE e.employee_id IS NULL;

select dpt.department_id, dpt.department_name, count(distinct emp.employee_id) employee_count
from hr.EMPLOYEES emp
right join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID 
group by dpt.department_id, department_name
having employee_count = 0;

--M9. Show employee_id, first_name, department_id, department_name; include employees with null department_id.  
--Hint: LEFT JOIN so all employees appear;

select emp.employee_id, emp.first_name, emp.last_name, emp.department_id, dpt.department_name
from hr.EMPLOYEES emp
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID ;

--M10. List all departments and the number of employees; show 0 for departments with no employees.  
 --Hint: d LEFT JOIN e, GROUP BY d, COUNT(e.employee_id);

select dpt.department_id, dpt.department_name, count(distinct emp.employee_id) employee_count
from hr.EMPLOYEES emp
right join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID 
group by dpt.department_id, department_name;

--M11. Show employee name and manager name; alias manager columns as mgr_first_name, mgr_last_name.  
 --Hint: Self-join with aliases e and m; select m.first_name AS mgr_first_name, m.last_name AS mgr_last_name;

select  emp.first_name, emp.last_name, mngr.first_name Manager_first_name, mngr.last_name Manager_last_name
from hr.EMPLOYEES emp
left join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id;

--M12. List employees (first_name, last_name) and department_name; include employees whose department_id is not in hr.departments (LEFT JOIN, they get NULL).  
 --Hint: LEFT JOIN; no filter on d;

select emp.employee_id, emp.first_name, emp.last_name, emp.department_id, dpt.department_name
from hr.EMPLOYEES emp
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID ;

--M13. Show department_id, department_name, and employee count; include departments with 0 employees.  
 --Hint: FROM departments d LEFT JOIN employees e ... GROUP BY d.department_id, d.department_name;

select dpt.department_id, dpt.department_name, count(distinct emp.employee_id) employee_count
from hr.EMPLOYEES emp
right join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID 
group by dpt.department_id, department_name;

--M14. For each employee show employee_id, salary, department_name; use NVL(d.department_name, 'Unassigned').  
 --Hint: LEFT JOIN; NVL(d.department_name, 'Unassigned');

select emp.employee_id, emp.first_name, emp.last_name, emp.salary, NVL(dpt.department_name, 'Unassigned')
from hr.EMPLOYEES emp
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID ;

--M15. List employees with their manager's employee_id and manager's last_name (self-join).  
 --Hint: e LEFT JOIN m ON e.manager_id = m.employee_id; select e.*, m.employee_id AS mgr_emp_id, m.last_name AS mgr_last_name;

select  emp.employee_id, emp.first_name, emp.last_name, mngr.employee_id Manager_ID, mngr.last_name Manager_last_name
from hr.EMPLOYEES emp
left join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id;

--M16. Show all departments (department_name) and min salary in that department (NULL for no employees).  
 --Hint: d LEFT JOIN e, GROUP BY d, MIN(e.salary);

select dpt.department_id, dpt.department_name, min(salary) min_salary from hr.EMPLOYEES emp
right join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID 
group by dpt.department_id, department_name;

--M17. List employees who have a manager (manager_id IS NOT NULL) and show manager's first_name.  
 --Hint: INNER JOIN employees m ON e.manager_id = m.employee_id (or LEFT and filter e.manager_id IS NOT NULL);

select  emp.employee_id, emp.first_name, emp.last_name, mngr.employee_id Manager_ID, mngr.last_name Manager_last_name
from hr.EMPLOYEES emp
left join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id
where emp.manager_id IS NOT NULL;

select  emp.employee_id, emp.first_name, emp.last_name, mngr.employee_id Manager_ID, mngr.last_name Manager_last_name
from hr.EMPLOYEES emp
join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id;

--M18. Show employee_id, first_name, department_name; include employees with no department (LEFT JOIN).  
 --Hint: e LEFT JOIN d ON e.department_id = d.department_id;

select emp.employee_id, emp.first_name, emp.last_name, emp.salary, dpt.department_name
from hr.EMPLOYEES emp
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID ;

--M19. List departments (department_id, department_name) and average salary; include departments with no employees (avg NULL or 0).  
 --Hint: d LEFT JOIN e, GROUP BY d.department_id, d.department_name, AVG(e.salary);

select dpt.department_id, dpt.department_name, avg(salary) Average_salary from hr.EMPLOYEES emp
right join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID 
group by dpt.department_id, department_name;

--M20. For each employee show name and department_name; if no department show 'N/A'.  
 --Hint: LEFT JOIN; COALESCE(d.department_name, 'N/A').

select emp.first_name, emp.last_name, NVL(dpt.department_name, 'N/A') department_name
from hr.EMPLOYEES emp
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID ;

--20 Hard Questions

--H1. Show two-level hierarchy: employee name, manager name, and manager's manager name (self-join e to m, m to m2 on m.manager_id = m2.employee_id).  
--Hint: e LEFT JOIN m ON e.manager_id = m.employee_id LEFT JOIN employees m2 ON m.manager_id = m2.employee_id;

SELECT emp.first_name, emp.last_name, mngr.first_name manager_first_name, mngr.last_name manager_last_name,
snr_mngr.first_name senior_manager_first_name, snr_mngr.last_name senior_manager_last_name 
FROM hr.employees emp 
join hr.employees mngr on emp.manager_id = mngr.employee_id
left join hr.employees snr_mngr on mngr.MANAGER_ID = snr_mngr.employee_id;

--H2. List departments that have no employees using NOT EXISTS.  
--Hint: SELECT * FROM hr.departments d WHERE NOT EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id);

select department_name from hr.departments dpt
where not exists (select distinct department_id from hr.EMPLOYEES emp where emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID);

--H3. Show all employees and all departments in one result (FULL OUTER JOIN): employee_id, first_name, department_id, department_name.  
--Hint: FULL OUTER JOIN on e.department_id = d.department_id;

select emp.first_name, emp.last_name, dpt.department_name
from hr.EMPLOYEES emp
full OUTER join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID ;

--H4. For each employee show name, department_name, and manager's department_name (join e to d, e to m, m to dm).  
--Hint: e JOIN d ON e.department_id = d.department_id LEFT JOIN employees m ON e.manager_id = m.employee_id LEFT JOIN departments dm ON m.department_id = dm.department_id;

select emp.first_name, emp.last_name, dpt.department_name, mngr.first_name Manager_first_name, mngr.last_name Manager_last_name, mgr_dpt.department_name mngr_department_name
from hr.EMPLOYEES emp
left join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID 
left join hr.DEPARTMENTS mgr_dpt on mgr_dpt.DEPARTMENT_ID = mngr.DEPARTMENT_ID;

--H5. List employees (name, salary, department_name) who earn more than their manager (self-join, compare e.salary > m.salary).  
--Hint: e JOIN employees m ON e.manager_id = m.employee_id WHERE e.salary > m.salary;

select emp.first_name, emp.last_name, dpt.department_name, emp.salary, mngr.first_name Manager_first_name, mngr.last_name Manager_last_name, mngr.salary Manager_salary
from hr.EMPLOYEES emp
left join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID 
where emp.salary > mngr.salary;

--H6. Show all departments and count of employees; also show count of employees with commission_pct not null per department (use conditional COUNT).  
--Hint: d LEFT JOIN e, GROUP BY d; COUNT(e.employee_id), COUNT(e.commission_pct) or SUM(CASE WHEN e.commission_pct IS NOT NULL THEN 1 ELSE 0 END);

select dpt.department_id, dpt.department_name, count(distinct emp.employee_id) employee_count
from hr.EMPLOYEES emp
right join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID 
where emp.COMMISSION_PCT is not NULL
group by dpt.department_id, department_name;


select dpt.department_id, dpt.department_name, SUM(CASE WHEN emp.commission_pct IS NOT NULL THEN 1 ELSE 0 END) employee_count
from hr.EMPLOYEES emp
right join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID 
group by dpt.department_id, department_name;

--H7. List employees who have the same manager as employee_id 104 (self-join or subquery: manager_id = (SELECT manager_id FROM hr.employees WHERE employee_id = 104)).  
--Hint: WHERE manager_id = (SELECT manager_id FROM hr.employees WHERE employee_id = 104) AND employee_id <> 104;

select emp.first_name, emp.last_name, mngr.first_name Manager_first_name, mngr.last_name Manager_last_name
from hr.EMPLOYEES emp
right join hr.EMPLOYEES mngr on emp.manager_id = mngr.manager_id
where mngr.EMPLOYEE_ID = 104 and emp.EMPLOYEE_ID <> 104;

--H8. Show employee name, department_name, and manager name; include employees with no department and no manager.  
--Hint: e LEFT JOIN d ON e.department_id = d.department_id LEFT JOIN employees m ON e.manager_id = m.employee_id;

select emp.first_name, emp.last_name, dpt.department_name, mngr.first_name Manager_first_name, mngr.last_name Manager_last_name
from hr.EMPLOYEES emp
left join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID ;

--H9. List departments (department_name) where the department's manager (d.manager_id) is not in hr.employees or has no row (LEFT JOIN employees to d.manager_id).  
--Hint: d LEFT JOIN employees mgr ON d.manager_id = mgr.employee_id WHERE mgr.employee_id IS NULL;

select dpt.department_id, dpt.department_name, dpt.MANAGER_ID
from hr.EMPLOYEES emp
right join hr.DEPARTMENTS dpt on emp.employee_id = dpt.manager_id 
where emp.employee_id is null;

select dpt.department_id, dpt.department_name, dpt.MANAGER_ID from hr.DEPARTMENTS dpt where manager_id not in (select employee_iD from hr.employees);

--H10. Show employee_id, first_name, last_name, department_name, and manager's last_name; use LEFT JOINs so employees without department or manager appear.  
 --Hint: e LEFT JOIN d ON e.department_id = d.department_id LEFT JOIN employees m ON e.manager_id = m.employee_id;

select emp.employee_id, emp.first_name, emp.last_name, dpt.department_name, mngr.last_name Manager_last_name
from hr.EMPLOYEES emp
left join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID ;

--H11. List employees (name, salary) whose salary is greater than their manager's salary (self-join e, m).  
 --Hint: e JOIN employees m ON e.manager_id = m.employee_id WHERE e.salary > m.salary;

select emp.first_name, emp.last_name, emp.salary, mngr.first_name Manager_first_name, mngr.last_name Manager_last_name, mngr.salary Manager_salary
from hr.EMPLOYEES emp
left join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id
where emp.salary > mngr.salary;

--H12. Show all departments and total salary; include departments with 0 employees (total 0 or NULL).  
 --Hint: d LEFT JOIN e, GROUP BY d, SUM(e.salary);

select dpt.department_id, dpt.department_name, NVL(sum(emp.salary),0) total_salary
from hr.EMPLOYEES emp
right join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID 
group by dpt.department_id, department_name;

--H13. For each employee show name, department_name, and number of employees in that department (join to aggregated subquery or use COUNT(*) OVER (PARTITION BY e.department_id)).  
 --Hint: e LEFT JOIN d; add COUNT(*) OVER (PARTITION BY e.department_id) AS dept_count;

select distinct emp.employee_id, emp.first_name, emp.last_name, dpt.department_id, dpt.department_name, count(*) over(partition by emp.department_id) Employee_count
from hr.EMPLOYEES emp
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID ;

--H14. List employees who are managers (employee_id in (SELECT manager_id FROM hr.employees)) and show how many people they manage.  
 --Hint: employees m WHERE m.employee_id IN (SELECT manager_id FROM hr.employees) JOIN (SELECT manager_id, COUNT(*) cnt FROM hr.employees GROUP BY manager_id) c ON m.employee_id = c.manager_id;

select distinct emp.manager_id, mngr.first_name Manager_first_name, mngr.last_name Manager_last_name, count(emp.employee_id) over(partition by emp.manager_id) Reporting_count
from hr.EMPLOYEES emp
left join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id;

--H15. Show employee name, department_name, manager name; include employees with no department (department_name NULL) and no manager (manager name NULL).  
 --Hint: e LEFT JOIN d LEFT JOIN employees m ON e.manager_id = m.employee_id;

select emp.first_name||' '||emp.last_name as Employee_name, dpt.department_name, mngr.first_name||' '||mngr.last_name Manager_name
from hr.EMPLOYEES emp
left join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID ;

--H16. List departments (department_name) that have at least one employee with salary > 10000 (JOIN and EXISTS or IN).  
 --Hint: SELECT DISTINCT d.department_name FROM hr.departments d JOIN hr.employees e ON d.department_id = e.department_id WHERE e.salary > 10000;

SELECT dept.department_name, count(distinct emp.employee_id) employee_count
FROM hr.employees emp
right JOIN hr.departments dept ON emp.department_id = dept.department_id
where emp.salary > 10000
group by dept.department_id, dept.department_name
having employee_count >= 1;

--H17. Show employee_id, first_name, last_name, department_name, and manager's first_name; use COALESCE for manager first_name to 'No Manager'.  
 --Hint: e LEFT JOIN d LEFT JOIN m; COALESCE(m.first_name, 'No Manager');

select emp.first_name, emp.last_name, dpt.department_name, COALESCE(mngr.first_name,'No Manager') Manager_first_name
from hr.EMPLOYEES emp
left join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID ;

--H18. List all employees (employee_id, first_name) and all departments (department_id, department_name) in one result with FULL OUTER JOIN; show which side each row came from (e.g. CASE WHEN e.employee_id IS NOT NULL THEN 'Emp' ELSE 'Dept' END).  
 --Hint: FULL OUTER JOIN; add a column that indicates source;

select emp.employee_id, emp.first_name, dpt.department_id, dpt.department_name, case when emp.employee_id is null then 'Dept' else 'Emp' END table_info
from hr.EMPLOYEES emp
full OUTER join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID ;

--H19. For each department show department_name and the name of the employee with the highest salary in that department (join to (SELECT department_id, employee_id, ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) rn FROM hr.employees) WHERE rn = 1).  
 --Hint: Subquery with ROW_NUMBER; join to departments and employees for names;

select department_id, department_name, employee_id, FIRST_NAME, LAST_NAME from (
select dpt.department_id, dpt.department_name, emp.employee_id, emp.FIRST_NAME, emp.LAST_NAME, ROW_NUMBER() OVER (PARTITION BY emp.department_id ORDER BY salary DESC) max_salary
from hr.EMPLOYEES emp
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID)
where max_salary = 1;

--H20. List employees (name, department_name) who were hired before their manager (compare e.hire_date < m.hire_date with self-join).  
 --Hint: e JOIN employees m ON e.manager_id = m.employee_id WHERE e.hire_date < m.hire_date;

select emp.first_name, emp.last_name, dpt.department_name, COALESCE(mngr.first_name,'No Manager') Manager_first_name
from hr.EMPLOYEES emp
left join hr.EMPLOYEES mngr on emp.manager_id = mngr.employee_id
left join hr.DEPARTMENTS dpt on emp.DEPARTMENT_ID = dpt.DEPARTMENT_ID 
where emp.hire_date < mngr.hire_date;
