/*Day 11 Assignment: Subqueries (Scalar and Table)
All exercises use hr.employees and hr.departments only.
Part 1: Practice Questions (With Answers and Explanations)*/

/* Question 1
List employees who earn more than the company average salary. Use a subquery for the average.
Answer:*/

SELECT employee_id, first_name, last_name, salary
FROM hr.employees
WHERE salary > (SELECT AVG(salary) FROM hr.employees);

--Explanation: The subquery (SELECT AVG(salary) FROM hr.employees) returns a single value. The outer query keeps only rows where salary is greater than that value.

/* Question 2
List employees whose department_id exists in hr.departments (i.e. they belong to a valid department). Use IN with a subquery.
Answer:*/

SELECT employee_id, first_name, last_name, department_id
FROM hr.employees
WHERE department_id IN (SELECT department_id FROM hr.departments);

--Explanation: The subquery returns all department_id values from hr.departments. IN checks whether each employee's department_id is in that set. This also excludes NULL department_id because NULL IN (...) is not true.

/* Question 3
Show department names from hr.departments along with the count of employees in that department. Use a scalar subquery in the SELECT list for the count (correlated by department_id).
Answer:*/

SELECT d.department_id, d.department_name,
  (SELECT COUNT(*) FROM hr.employees e WHERE e.department_id = d.department_id) AS employee_count
FROM hr.departments d;

--Explanation: For each department row, the correlated subquery counts employees where e.department_id matches d.department_id. This yields one count per department; departments with zero employees get 0.

/*Part 2: Self-Practice (No Answers)*/

--1. List employees whose salary is greater than the average salary of their own department (use a correlated subquery).

select employee_id, first_name, last_name, salary, department_id from hr.EMPLOYEES emp
where salary > (select avg(salary) from hr.EMPLOYEES rfr where rfr.department_id = emp.department_id);

--2. List departments that have at least one employee (use EXISTS with a correlated subquery).

SELECT department_id, department_name from hr.DEPARTMENTS dpt
where exists (select department_id from hr.employees emp where dpt.department_id = emp.department_id);

--3. In a single query, show each department_id and the maximum salary in that department, using a subquery in the FROM clause (derived table) that groups by department_id.

select department_id, maximum_salary 
from (select department_id, max(salary) as maximum_salary from hr.employees group by department_id);

/*Part 3: Additional Practice —--20 Medium +--20 Hard Questions (With Hints)
All use hr.employees and hr.departments only.*/

--20 Medium Questions

--M1. List employees with salary > (SELECT AVG(salary) FROM hr.employees)--Hint: WHERE salary > (scalar subquery).

select employee_id, first_name, last_name, salary, department_id from hr.EMPLOYEES emp
where salary > (select avg(salary) from hr.EMPLOYEES rfr);

--M2. List employees where department_id IN (SELECT department_id FROM hr.departments)--Hint: IN with subquery.

select employee_id, first_name, last_name, salary, department_id from hr.EMPLOYEES emp
where department_id in (select department_id from hr.departments);

--M3. Show employee_id, salary, and (SELECT AVG(salary) FROM hr.employees) AS avg_sal in SELECT--Hint: Scalar subquery in SELECT list.

select employee_id, first_name, last_name, salary, (SELECT AVG(salary) FROM hr.employees) avg_salary from hr.EMPLOYEES;

--M4. List departments where (SELECT COUNT(*) FROM hr.employees e WHERE e.department_id = d.department_id) > --Hint: Correlated scalar in WHERE.

SELECT department_id, department_name from hr.DEPARTMENTS dpt
where exists (select department_id from hr.employees emp where dpt.department_id = emp.department_id);

--M5. List employees where department_id IN (SELECT department_id FROM hr.departments WHERE department_id IN (10,20,30))--Hint: IN (subquery).

SELECT employee_id, first_name, last_name, salary, department_id from hr.employees dpt
where department_id in (select department_id from hr.departments WHERE department_id IN (10,20,30));

--M6. Show department_id, department_name, (SELECT COUNT(*) FROM hr.employees e WHERE e.department_id = d.department_id) FROM hr.departments d--Hint: Correlated scalar in SELECT.

select department_id, department_name, 
(SELECT COUNT(*) FROM hr.employees emp WHERE emp.department_id = dept.department_id) employee_count 
from hr.departments dept;

--M7. List employees with salary < (SELECT MIN(salary) FROM hr.employees WHERE department_id = 50)--Hint: Scalar subquery for min in dept 50.

SELECT employee_id, first_name, last_name, salary, department_id from hr.employees 
where salary < (SELECT MIN(salary) FROM hr.employees WHERE department_id = 50);

--M8. Show employee_id, first_name, (SELECT department_name FROM hr.departments d WHERE d.department_id = e.department_id) FROM hr.employees e--Hint: Correlated scalar in SELECT.

SELECT employee_id, first_name, last_name, 
(SELECT department_name FROM hr.departments dpt WHERE dpt.department_id = emp.department_id) department_name 
FROM hr.employees emp;

--M9. List departments that have at least one employee using EXISTS--Hint: WHERE EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id).

SELECT department_id, department_name from hr.DEPARTMENTS dpt
where exists (select 1 from hr.employees emp where dpt.department_id = emp.department_id);

--M10. List employees where job_id IN (SELECT DISTINCT job_id FROM hr.employees WHERE department_id = 80)--Hint: IN (subquery).

SELECT employee_id, first_name, last_name from hr.employees
where job_id IN (SELECT DISTINCT job_id FROM hr.employees WHERE department_id = 80);

--M11. Show department_id, (SELECT SUM(salary) FROM hr.employees e WHERE e.department_id = d.department_id) FROM hr.departments d--Hint: Correlated scalar in SELECT.

select department_id, (SELECT SUM(salary) FROM hr.employees emp WHERE emp.department_id = dpt.department_id) total_salary FROM hr.departments dpt;

--M12. List employees with salary between (SELECT MIN(salary) FROM hr.employees) and (SELECT MAX(salary) FROM hr.employees)--Hint: Two scalar subqueries in BETWEEN.

SELECT employee_id, first_name, last_name from hr.employees
where salary between (SELECT MIN(salary) FROM hr.employees) and (SELECT MAX(salary) FROM hr.employees);

--M13. List employees where department_id NOT IN (SELECT department_id FROM hr.departments WHERE department_id IS NOT NULL)--Hint: NOT IN (subquery); exclude NULL in subquery to avoid logic issues.

SELECT employee_id, first_name, last_name from hr.employees
where department_id NOT IN (SELECT department_id FROM hr.departments WHERE department_id IS NOT NULL);

--M14. Show employee_id, salary, (SELECT MAX(salary) FROM hr.employees) - salary AS diff_from_max--Hint: Scalar subquery in expression.

select employee_id, salary, (SELECT MAX(salary) FROM hr.employees) - salary AS diff_from_max from hr.employees;

--M15. List departments where (SELECT AVG(salary) FROM hr.employees e WHERE e.department_id = d.department_id) > 700--Hint: Correlated scalar in WHERE.

select dept.* from hr.DEPARTMENTS dept
where (SELECT AVG(salary) FROM hr.employees emp WHERE emp.department_id = dept.department_id) > 700;

--M16. From (SELECT department_id, COUNT(*) c FROM hr.employees GROUP BY department_id) sub, SELECT * WHERE c > 5 --Hint: Derived table in FROM with alias.

select * From (SELECT department_id, COUNT(*) employee_count FROM hr.employees GROUP BY department_id) where employee_count > 5 ;

--M17. List employees with salary >= (SELECT AVG(salary) FROM hr.employees WHERE job_id = e.job_id)--Hint: Correlated subquery comparing to job average.

SELECT employee_id, first_name, last_name from hr.employees emp
where salary >= (SELECT AVG(salary) FROM hr.employees WHERE job_id = emp.job_id);

--M18. Show department_name and (SELECT COUNT(*) FROM hr.employees e WHERE e.department_id = d.department_id) FROM hr.departments d--Hint: Correlated count in SELECT.

select department_name, 
(SELECT COUNT(distinct employee_id) FROM hr.employees emp WHERE emp.department_id = dept.department_id) employee_count 
FROM hr.departments dept;

--M19. List employees where EXISTS (SELECT 1 FROM hr.departments d WHERE d.department_id = e.department_id)--Hint: EXISTS with correlation.

SELECT employee_id, first_name, last_name from hr.employees emp
where EXISTS (SELECT 1 FROM hr.departments dpt WHERE dpt.department_id = emp.department_id);

--M20. From (SELECT job_id, AVG(salary) avg_sal FROM hr.employees GROUP BY job_id) sub, select job_id, avg_sal where avg_sal > 800--Hint: Derived table, then filter.

select job_id, avg_sal 
From (SELECT job_id, AVG(salary) avg_sal FROM hr.employees GROUP BY job_id) 
where avg_sal > 800;

--20 Hard Questions

--H1. Employees whose salary is in the top 5 company-wide (salary >= (SELECT MIN(salary) FROM (SELECT salary FROM hr.employees ORDER BY salary DESC FETCH FIRST 5 ROWS ONLY)))--Hint: Subquery in FROM or scalar with nested subquery.

SELECT employee_id, first_name, last_name from hr.employees emp
where salary >= (SELECT MIN(salary) FROM (SELECT salary FROM hr.employees ORDER BY salary DESC FETCH FIRST 5 ROWS ONLY));

--H2. Departments where total salary > (SELECT AVG(total) FROM (SELECT SUM(salary) total FROM hr.employees GROUP BY department_id))--Hint: HAVING SUM(salary) > (scalar from derived table).

select department_id, sum(salary) total_salary from hr.employees
where total_salary > (SELECT AVG(total) FROM (SELECT SUM(salary) total FROM hr.employees GROUP BY department_id)) 
group by department_id;

--H3. Employees who have the same job_id as their manager (correlated: (SELECT job_id FROM hr.employees m WHERE m.employee_id = e.manager_id) = e.job_id)--Hint: Correlated scalar subquery.

SELECT employee_id, first_name, last_name from hr.employees emp
where (SELECT job_id FROM hr.employees mngr WHERE mngr.employee_id = emp.manager_id) = emp.job_id;

--H4. Show employee_id, salary, and (SELECT department_name FROM hr.departments d WHERE d.department_id = e.department_id) and (SELECT COUNT(*) FROM hr.employees e2 WHERE e2.department_id = e.department_id)--Hint: Two correlated scalars in SELECT.

SELECT employee_id, salary, (SELECT department_name FROM hr.departments dpt WHERE dpt.department_id = emp.department_id), (SELECT COUNT(*) FROM hr.employees rfr WHERE rfr.department_id = emp.department_id)
from hr.employees emp;

--H5. List departments that have more employees than (SELECT AVG(cnt) FROM (SELECT COUNT(*) cnt FROM hr.employees GROUP BY department_id))--Hint: Correlated count in HAVING vs scalar from derived table.

select department_id, count(employee_id) employee_count from hr.EMPLOYEES
where employee_count > (SELECT AVG(cnt) FROM (SELECT COUNT(*) cnt FROM hr.employees GROUP BY department_id))
group by department_id;

--H6. Employees where salary > all salaries in department 50 (salary > (SELECT MAX(salary) FROM hr.employees WHERE department_id = 50))--Hint: Use MAX in subquery for "greater than all."

SELECT employee_id, salary from hr.EMPLOYEES
where salary > (SELECT MAX(salary) FROM hr.employees WHERE department_id = 50);

--H7. From (SELECT department_id, COUNT(*) c, SUM(salary) s FROM hr.employees GROUP BY department_id) join hr.departments on department_id; show department_name, c, s--Hint: Derived table join departments.

select dpt.department_name, employee_count, total_salary
From (SELECT department_id, COUNT(employee_id) employee_count, SUM(salary) total_salary FROM hr.employees GROUP BY department_id) sub
join hr.departments dpt on dpt.department_id = sub.department_id;

--H8. Employees whose department has exactly 3 people: WHERE (SELECT COUNT(*) FROM hr.employees e2 WHERE e2.department_id = e.department_id) = --Hint: Correlated count = 3.

select distinct department_id from hr.EMPLOYEES emp
WHERE (SELECT COUNT(*) FROM hr.employees rfr WHERE rfr.department_id = emp.department_id) = 3;

--H9. Departments where manager_id is in (SELECT employee_id FROM hr.employees) (department's manager exists)--Hint: WHERE d.manager_id IN (SELECT employee_id FROM hr.employees).

select department_id, department_name, manager_id from hr.DEPARTMENTS 
where manager_id in (SELECT employee_id FROM hr.employees);

--H10. Show each employee_id and (SELECT first_name||' '||last_name FROM hr.employees m WHERE m.employee_id = e.manager_id) AS manager_name--Hint: Correlated scalar in SELECT.

select employee_id, (SELECT first_name||' '||last_name FROM hr.employees mgr WHERE mgr.employee_id = emp.manager_id) AS manager_name from hr.employees emp;

--H11. List employees in department_id that has the highest total salary (department_id IN (SELECT department_id FROM (SELECT department_id, SUM(salary) s FROM hr.employees GROUP BY department_id ORDER BY s DESC FETCH FIRST 1 ROW ONLY)))--Hint: Subquery in FROM + ORDER BY + FETCH; then IN.

select employee_id, salary, department_id from hr.EMPLOYEES 
where department_id IN (SELECT department_id FROM (SELECT department_id, SUM(salary) s FROM hr.employees GROUP BY department_id ORDER BY s DESC FETCH FIRST 1 ROW ONLY));

--H12. Employees where salary > (SELECT AVG(salary) FROM hr.employees e2 WHERE e2.department_id = e.department_id) * 1.1 --Hint: Correlated avg * 1.1.

select employee_id, salary, department_id from hr.EMPLOYEES emp
where salary > (SELECT AVG(salary) FROM hr.employees e2 WHERE e2.department_id = emp.department_id) * 1.1;

--H13. Departments with no employees: NOT EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id)--Hint: NOT EXISTS correlated.

select department_id, department_name from hr.departments dpt
where NOT EXISTS (SELECT 1 FROM hr.employees emp WHERE emp.department_id = dpt.department_id);

--H14. Show department_id, department_name, (SELECT AVG(salary) FROM hr.employees e WHERE e.department_id = d.department_id), (SELECT COUNT(*) FROM hr.employees e WHERE e.department_id = d.department_id) FROM hr.departments d--Hint: Two correlated scalars.

select department_id, department_name, 
(SELECT AVG(salary) FROM hr.employees emp WHERE emp.department_id = dept.department_id) avg_salary, 
(SELECT COUNT(employee_id) FROM hr.employees emp WHERE emp.department_id = dept.department_id) employee_count 
FROM hr.departments dept;

--H15. List job_id and count from hr.employees where count > (SELECT AVG(cnt) FROM (SELECT COUNT(*) cnt FROM hr.employees GROUP BY job_id))--Hint: GROUP BY job_id HAVING COUNT(*) > (scalar from derived table).

select job_id, count(employee_id) employee_count from hr.employees 
where employee_count > (SELECT AVG(cnt) FROM (SELECT COUNT(*) cnt FROM hr.employees GROUP BY job_id))
group by job_id;

--H16. Employees whose hire_date is (SELECT MIN(hire_date) FROM hr.employees WHERE department_id = e.department_id)--Hint: Correlated min: e.hire_date = (SELECT MIN(hire_date)...).

select emp.* from hr.employees emp 
where hire_date = (SELECT MIN(hire_date) FROM hr.employees WHERE department_id = emp.department_id);

--H17. From (SELECT department_id, ROUND(AVG(salary),2) a FROM hr.employees GROUP BY department_id) sub join hr.departments d on sub.department_id = d.department_id; show d.department_name, sub.a--Hint: Derived table join.

select department_name 
From (SELECT department_id, ROUND(AVG(salary),2) a FROM hr.employees GROUP BY department_id) sub join hr.departments d on sub.department_id = d.department_id;

--H18. Employees where salary >= (SELECT MAX(salary) FROM hr.employees e2 WHERE e2.department_id = e.department_id) * 0.9 --Hint: Correlated max * 0.9 (within 10% of dept max).

select emp.* from hr.employees emp
where salary >= (SELECT MAX(salary) FROM hr.employees rfr WHERE rfr.department_id = emp.department_id) * 0.9; 

--H19. Departments where (SELECT COUNT(DISTINCT job_id) FROM hr.employees e WHERE e.department_id = d.department_id) >= 2 --Hint: Correlated count distinct in WHERE.

select department_id, department_name from hr.departments dpt
where (SELECT COUNT(DISTINCT job_id) FROM hr.employees emp WHERE emp.department_id = dpt.department_id) >= 2;

--H20. Show employee_id, salary, (SELECT AVG(salary) FROM hr.employees), salary - (SELECT AVG(salary) FROM hr.employees) AS diff--Hint: Two uses of same scalar subquery in SELECT.

select employee_id, salary, (SELECT AVG(salary) FROM hr.employees) avg_salary, salary - (SELECT AVG(salary) FROM hr.employees) AS diff 
from hr.EMPLOYEES;
