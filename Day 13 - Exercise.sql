/*Day 13 Assignment: Set Operations
All exercises use hr.employees and hr.departments only.
Part 1: Practice Questions (With Answers and Explanations)*/

/* Question 1
List job_id values that appear in employees in department 50 UNION job_id values that appear in employees in department 60. (Each SELECT returns one column job_id.)
Answer:*/

SELECT job_id FROM hr.employees WHERE department_id = 50
UNION
SELECT job_id FROM hr.employees WHERE department_id = 60;

--Explanation: Both queries return one column (job_id). UNION combines the result sets and removes duplicates. Use UNION ALL if you want to keep duplicates.

/* Question 2
List department_id values that appear in both hr.employees and hr.departments (departments that have at least one employee and are in the departments table). Use INTERSECT.
Answer:*/

SELECT department_id FROM hr.employees
INTERSECT
SELECT department_id FROM hr.departments;

--Explanation: INTERSECT returns only rows that appear in both result sets. So we get department_ids that exist in employees and in departments. NULLs are not matched in INTERSECT.

/* Question 3
List department_id values that are in hr.departments but have no employees in hr.employees. Use MINUS.
Answer:*/

SELECT department_id FROM hr.departments
MINUS
SELECT department_id FROM hr.employees;

--Explanation: MINUS returns rows from the first query that are not in the second. So we get departments that exist in the departments table but do not appear as any employee's department_id (including departments with zero employees).

/*Part 2: Self-Practice (No Answers)*/

--1. Use UNION to combine two queries: employees with salary in range 3000–6000 and employees with salary in range 5000–8000. Show employee_id and salary. Observe how UNION removes duplicates.

select employee_id, first_name, last_name from hr.employees where salary between 3000 and 6000
UNION
select employee_id, first_name, last_name from hr.employees where salary between 5000 and 8000;

--2. Use INTERSECT to find manager_id values that appear in both hr.employees (as manager_id) and in hr.employees (as employee_id)—i.e--Managers who are themselves employees.

select manager_id from hr.employees
INTERSECT
select manager_id from hr.DEPARTMENTS;

/*Part 3: Additional Practice —--20 Medium +--20 Hard Questions (With Hints)
All use hr.employees and hr.departments only.*/

--20 Medium Questions

--M1. UNION job_id from department 50 and job_id from department 6--Hint: Two SELECTs with same one column, UNION.

select job_id from hr.employees where department_id = 50
union
select job_id from hr.employees where department_id = 6;

--M2. UNION ALL employee_id, first_name from department 50 and from department 8--Hint: Same columns, UNION ALL.

select employee_id, first_name, last_name from hr.employees where department_id = 50
UNION ALL
select employee_id, first_name, last_name from hr.employees where department_id = 8;

--M3. INTERSECT department_id from hr.employees and department_id from hr.departments--Hint: Returns dept_ids in both.

select department_id from hr.employees
INTERSECT
select department_id from hr.DEPARTMENTS;

--M4. MINUS: department_id from hr.departments MINUS department_id from hr.employees (depts with no employees)--Hint: First query minus second.

select department_id from hr.departments 
MINUS
select department_id from hr.employees;

--M5. UNION ALL first_name, last_name from employees where salary > 10000 and first_name, last_name from employees where department_id = 9--Hint: Two columns, UNION ALL.

select first_name, last_name from hr.employees where salary > 10000
union ALL
select first_name, last_name from hr.employees where department_id = 9;

--M6. INTERSECT job_id from employees where department_id = 50 and job_id from employees where department_id = 8--Hint: Jobs in both depts.

select job_id from hr.employees where department_id = 50
intersect 
select job_id from hr.employees where department_id = 8;

--M7. MINUS: employee_id from employees MINUS employee_id from (select manager_id from employees where manager_id is not null)--Hint: Employees who are not managers (if manager_id list is from employees).

select employee_id from hr.employees 
MINUS
select manager_id from hr.employees where manager_id is not null;

--M8. UNION department_id from employees and department_id from departments; ORDER BY --Hint: UNION then ORDER BY 1 at end.

SELECT department_id FROM hr.departments
union
SELECT department_id FROM hr.employees order by department_id;

--M9. UNION ALL select 10, 'Dept10' from dual and select 20, 'Dept20' from dual (two columns)--Hint: Literals; use dual; same number of columns.

select 10, 'Dept10' from dual 
union ALL
select 20, 'Dept20' from dual;

--M10. INTERSECT manager_id from employees (where not null) and employee_id from employees--Hint: People who are managers (appear as manager_id and as employee_id).

select employee_id from hr.employees 
INTERSECT
select manager_id from hr.employees where manager_id is not null;

--M11. MINUS: job_id from employees where department_id = 80 MINUS job_id from employees where department_id = 5--Hint: Jobs in 80 but not in 50.

select job_id from hr.employees where department_id = 80 
MINUS
select job_id from hr.employees where department_id = 50;

--M12. UNION salary (as one column) from employees where department_id = 50 and salary from employees where department_id = 60; show distinct salaries--Hint: One column, UNION.

select salary from hr.employees where department_id = 50 
UNION 
select salary from hr.employees where department_id = 60;

--M13. INTERSECT department_id from departments and department_id from employees (same as depts that have employees)--Hint: INTERSECT two single-column queries.

select department_id from hr.departments 
intersect 
select department_id from hr.employees;

--M14. UNION ALL employee_id, salary from employees where salary < 5000 and employee_id, salary from employees where salary > 15000--Hint: Two columns, UNION ALL.

select employee_id, salary from hr.employees where salary < 5000 
union all 
select employee_id, salary from hr.employees where salary > 15000;

--M15. MINUS: department_id from employees MINUS department_id from departments (employees' dept_ids not in departments table—usually empty)--Hint: First minus second.
 
select department_id from hr.departments
minus
select department_id from hr.employees ;

--M16. UNION first_name from employees where job_id = 'SA_REP' and first_name from employees where job_id = 'SA_MAN'--Hint: One column, UNION.

select first_name from hr.employees where job_id = 'SA_REP' 
UNION
select first_name from hr.employees where job_id = 'SA_MAN';

--M17. INTERSECT job_id from employees and job_id from (SELECT job_id FROM hr.employees WHERE department_id = 90)--Hint: INTERSECT with subquery (all jobs vs jobs in 90).

select job_id from hr.employees 
INTERSECT 
select job_id from (SELECT job_id FROM hr.employees WHERE department_id = 90);

--M18. UNION ALL select department_id, department_name from departments where department_id = 10 and select department_id, department_name from departments where department_id = 20 --Hint: Two columns from same table, different filter.

select department_id, department_name from hr.departments where department_id = 10 
union all 
select department_id, department_name from hr.departments where department_id = 20 ;

--M19. MINUS: employee_id from employees where department_id = 50 MINUS employee_id from employees where salary > 7000--Hint: In dept 50 but not in high-salary set (interpret: IDs in first set not in second).

select employee_id from hr.employees where department_id = 50 
MINUS 
select employee_id from hr.employees where salary > 7000;

--M20. UNION (no ALL) department_id from employees and department_id from departments--Hint: Distinct department_ids from both tables.

select department_id from hr.employees 
union
select department_id from hr.departments;

--20 Hard Questions

--H1. UNION of three queries: department_id from employees where salary < 3000, where salary between 3000 and 8000, and where salary > 8000 (one column)--Hint: Three SELECTs, UNION.

select department_id from hr.employees where salary < 3000
union select department_id from hr.employees where salary between 3000 and 8000 
UNION select department_id from hr.employees where salary > 8000 ;

--H2. INTERSECT of manager_id from employees and employee_id from employees (managers who are employees)--Hint: INTERSECT; use WHERE manager_id IS NOT NULL in first if needed.

select manager_id from hr.employees 
INTERSECT 
select employee_id from hr.employees ;

--H3. MINUS: departments.department_id MINUS employees.department_id; then join result to departments to show department_name
--Hint: Use subquery: SELECT d.department_id, d.department_name FROM hr.departments d WHERE d.department_id IN (SELECT department_id FROM hr.departments MINUS SELECT department_id FROM hr.employees).

SELECT d.department_id, d.department_name FROM hr.departments d 
WHERE d.department_id IN (SELECT department_id FROM hr.departments MINUS SELECT department_id FROM hr.employees);

--H4. UNION ALL of (employee_id, first_name, last_name, 'A' as flag) from employees where salary > 10000 and same columns with 'B' from employees where salary <= 10000--Hint: Add literal flag column to each SELECT; same 4 columns.

select employee_id, first_name, last_name, 'A' as flag from hr.employees where salary > 10000
union all
select employee_id, first_name, last_name, 'A' as flag from hr.employees where salary <= 10000;

--H5. INTERSECT job_id from employees where department_id IN (10,20) and job_id from employees where department_id IN (50,60)--Hint: Jobs that appear in both sets of departments.

select job_id from hr.employees where department_id IN (10,20) 
intersect
select job_id from hr.employees where department_id IN (50,60);

--H6. MINUS: (SELECT employee_id FROM hr.employees) MINUS (SELECT manager_id FROM hr.employees WHERE manager_id IS NOT NULL)--Hint: Employees who are not anyone's manager.

SELECT employee_id FROM hr.employees
MINUS 
SELECT manager_id FROM hr.employees WHERE manager_id IS NOT NULL;

--H7. UNION of department_id, COUNT(*) from employees group by department_id and department_id, 0 from departments (show all depts with count or 0)--Hint: Need same columns: dept_id and number; second from departments with literal 0; then union with first grouped query—but column types/count must match (grouped gives 2 cols; second query 2 cols).

select department_id, COUNT(*) from hr.employees group by department_id 
UNION
select department_id, 0 from hr.departments;

--H8. INTERSECT (department_id, job_id) from employees where salary > 5000 and (department_id, job_id) from employees where commission_pct is not null--Hint: Two columns in each SELECT; INTERSECT (dept,job) pairs.

select department_id, job_id from hr.employees where salary > 5000 
intersect
select department_id, job_id from hr.employees where commission_pct is not null;

--H9. MINUS: (employee_id, manager_id) from employees where manager_id is not null MINUS (employee_id, manager_id) from employees where department_id = 50 --Hint: Pairs in first set not in second (two columns).

select employee_id, manager_id from hr.employees where manager_id is not null 
MINUS 
select employee_id, manager_id from hr.employees where department_id = 50;

--H10. UNION ALL list of department_id from employees and department_id from departments; then use this in a query to count how many times each department_id appears
--Hint: SELECT department_id, COUNT(*) FROM (SELECT department_id FROM hr.employees UNION ALL SELECT department_id FROM hr.departments) sub GROUP BY department_id.

SELECT department_id, COUNT(*) FROM 
(SELECT department_id FROM hr.employees 
UNION ALL 
SELECT department_id FROM hr.departments) sub GROUP BY department_id;

--H11. INTERSECT (first_name, last_name) from employees where department_id = 50 and (first_name, last_name) from employees where department_id = 80--Hint: Same name in both departments (two columns).

select first_name, last_name from hr.employees where department_id = 50 
intersect 
select first_name, last_name from hr.employees where department_id = 80;

--H12. MINUS: job_id from employees MINUS job_id from employees where hire_date >= DATE '2005-01-01'--Hint: Jobs that have no one hired in 2005 or later (jobs only in older hires).

select job_id from hr.employees 
MINUS 
select job_id from hr.employees where hire_date >= DATE '2005-01-01';

--H13. UNION (SELECT department_id, SUM(salary) FROM hr.employees GROUP BY department_id) and (SELECT NULL, SUM(salary) FROM hr.employees) for grand total--Hint: Two columns; second row is NULL, total; types must match (NUMBER, NUMBER).

SELECT department_id, SUM(salary) total_salary FROM hr.employees GROUP BY department_id
union
SELECT NULL, SUM(salary) total_salary FROM hr.employees; 

--H14. INTERSECT department_id from employees where job_id = 'SA_REP' and department_id from employees where job_id = 'SA_MAN'--Hint: Departments that have both SA_REP and SA_MAN.

select department_id from hr.employees where job_id = 'SA_REP' 
intersect 
select department_id from hr.employees where job_id = 'SA_MAN';

--H15. MINUS: (SELECT manager_id FROM hr.employees WHERE manager_id IS NOT NULL) MINUS (SELECT employee_id FROM hr.employees WHERE department_id = 90)--Hint: Managers who are not in department 90.

(SELECT manager_id FROM hr.employees WHERE manager_id IS NOT NULL) 
MINUS 
(SELECT employee_id FROM hr.employees WHERE department_id = 90);

--H16. UNION of employee_id, first_name, last_name, department_id from employees where salary > (SELECT AVG(salary) FROM hr.employees) and same from employees where salary < (SELECT AVG(salary) FROM hr.employees)--Hint: Two scalar subqueries; same 4 columns.

select employee_id, first_name, last_name, department_id from hr.employees 
where salary > (SELECT AVG(salary) FROM hr.employees)  
union
select employee_id, first_name, last_name, department_id from hr.employees 
where salary < (SELECT AVG(salary) FROM hr.employees);

--H17. INTERSECT (department_id, job_id) from employees and (department_id, job_id) from (SELECT department_id, job_id FROM hr.employees GROUP BY department_id, job_id)--Hint: Same (dept, job) pairs (INTERSECT with self is same set).

select department_id, job_id from hr.employees 
intersect 
select department_id, job_id from (SELECT department_id, job_id FROM hr.employees GROUP BY department_id, job_id);

--H18. MINUS: employee_id from employees where department_id = 80 MINUS employee_id from employees where salary > 10000--Hint: In dept 80 but salary <= 10000 (IDs in first not in second).

select employee_id from hr.employees where department_id = 80 
MINUS 
select employee_id from hr.employees where salary > 10000;

--H19. UNION ALL (SELECT 1, department_id, COUNT(*) FROM hr.employees GROUP BY department_id) and (SELECT 2, NULL, COUNT(*) FROM hr.employees)--Hint: Add level column 1 for dept rows, 2 for total; NULL for department_id in total row.

(SELECT 1, department_id, COUNT(*) FROM hr.employees GROUP BY department_id) 
union all
(SELECT 2, NULL, COUNT(*) FROM hr.employees);

--H20. INTERSECT job_id from employees where department_id IN (SELECT department_id FROM hr.departments) and job_id from employees--Hint: INTERSECT with subquery (all jobs in valid depts vs all jobs—result is jobs in valid depts).

select job_id from hr.employees 
where department_id IN (SELECT department_id FROM hr.departments intersect select department_id from hr.employees);
