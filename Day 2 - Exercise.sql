/*Day 2 Assignment: Filtering & Sorting

All exercises use hr.employees and hr.departments only.

Part 1: Practice Questions (With Answers and Explanations)*/


/* Question 1  
List employees in `department_id` 50.
Answer:*/
--sql
SELECT employee_id, first_name, last_name, department_id
FROM hr.employees
WHERE department_id = 50;

/* Question 2  
List employees whose salary is between 5000 and 10000 (inclusive).
Answer:*/
--sql
SELECT employee_id, first_name, last_name, salary
FROM hr.employees
WHERE salary BETWEEN 5000 AND 10000;

/* Question 3  
List employees whose last name starts with 'K'.
Answer:*/
--sql
SELECT employee_id, first_name, last_name
FROM hr.employees
WHERE last_name LIKE 'K%';


/* Question 4  
List the top 5 highest-paid employees (employee_id, first_name, salary).
Answer:*/
--sql
SELECT employee_id, first_name, salary
FROM hr.employees
ORDER BY salary DESC
FETCH FIRST 5 ROWS ONLY;


/*Part 2: Self-Practice (No Answers)
Using hr.employees only:
*/

--1. List employees who have no `commission_pct` (NULL).

select * from HR.EMPLOYEES where commission_pct is NULL;

--2. List employees whose `job_id` contains the string `'MAN'`.

select * from HR.EMPLOYEES where job_id like '%MAN%';

--3. List all employees ordered by `hire_date` descending (newest first).

select * from HR.employees order by hire_date desc;



/*Part 3: Additional Practice — 20 Medium + 20 Hard/* Questions (With Hints)
All use hr.employees and hr.departments only.
 20 Medium Questions */

-- M1. List employees in department_id 80 with salary greater than 8000.  
--   Hint: WHERE department_id = 80 AND salary > 8000.

select employee_id, first_name, last_name, department_id, salary from HR.employees 
WHERE department_id = 80 AND salary > 8000;

-- M2. Find employees whose last_name ends with 'n'.  
--   Hint: WHERE last_name LIKE '%n'.

select employee_id, first_name, last_name from HR.EMPLOYEES
where last_name like '%n';

-- M3. List employees hired after January 1, 2005.  
--   Hint: WHERE hire_date > DATE '2005-01-01' or hire_date >= DATE '2005-01-01'.

select employee_id, first_name, last_name, hire_date from HR.EMPLOYEES
WHERE hire_date > DATE '2005-01-01';

-- M4. Get employees whose job_id is either 'SA_REP' or 'SA_MAN'.  
--   Hint: WHERE job_id IN ('SA_REP', 'SA_MAN').

select employee_id, first_name, last_name from HR.EMPLOYEES
WHERE job_id IN ('SA_REP', 'SA_MAN');

-- M5. List employees with salary between 4000 and 7000 (inclusive).  
--   Hint: WHERE salary BETWEEN 4000 AND 7000.

select Employee_id, first_name, last_name, salary from HR.EMPLOYEES
where salary BETWEEN 4000 AND 7000;

-- M6. Find employees who have a manager (manager_id is not null).  
--   Hint: WHERE manager_id IS NOT NULL.

select * from HR.EMPLOYEES where manager_id IS NOT NULL;

-- M7. List departments with department_id 10, 20, or 30 from hr.departments.  
--   Hint: WHERE department_id IN (10, 20, 30).

select * from HR.DEPARTMENTS where department_id IN (10, 20, 30);

-- M8. Get the top 3 employees by hire_date (oldest first).  
--   Hint: ORDER BY hire_date ASC then FETCH FIRST 3 ROWS ONLY.

select * from HR.EMPLOYEES order by HIRE_DATE 
FETCH FIRST 3 rows only;

-- M9. List employees in department 50, ordered by last_name ascending.  
--   Hint: WHERE department_id = 50 ORDER BY last_name.

select * from hr.EMPLOYEES WHERE department_id = 50 ORDER BY last_name;

-- M10. Find employees whose first_name starts with 'J'.  
--   Hint: WHERE first_name LIKE 'J%'.

select * from HR.employees WHERE first_name LIKE 'J%';

-- M11. List employees with salary not in the range 5000 to 10000.  
--   Hint: WHERE salary NOT BETWEEN 5000 AND 10000, or salary < 5000 OR salary > 10000.

select * from Hr.EMPLOYEES WHERE salary NOT BETWEEN 5000 AND 10000;

-- M12. Get employees whose job_id contains 'CLERK'.  
--   Hint: WHERE job_id LIKE '%CLERK%'.

select * from hr.EMPLOYEES WHERE job_id LIKE '%CLERK%';

-- M13. List employees with commission_pct greater than 0.2.  
--   Hint: WHERE commission_pct > 0.2 (and optionally commission_pct IS NOT NULL).

select * from hr.EMPLOYEES WHERE commission_pct > 0.2 and commission_pct IS NOT NULL;

-- M14. Find the 10 most recently hired employees.  
--   Hint: ORDER BY hire_date DESC FETCH FIRST 10 ROWS ONLY.

select * from hr.EMPLOYEES ORDER BY hire_date DESC FETCH FIRST 10 ROWS ONLY;

-- M15. List employees in departments 50 or 60, ordered by department_id then salary descending.  
--   Hint: WHERE department_id IN (50, 60) ORDER BY department_id, salary DESC.

select * from hr.EMPLOYEES WHERE department_id IN (50, 60) ORDER BY department_id, salary DESC;

-- M16. Get employees whose last_name has exactly 5 characters.  
--   Hint: WHERE last_name LIKE '_____' (5 underscores).

select * from HR.EMPLOYEES where last_name LIKE '_____';  

-- M17. List departments where manager_id is not null from hr.departments.  
--   Hint: FROM hr.departments WHERE manager_id IS NOT NULL.

select * from hr.DEPARTMENTS WHERE manager_id IS NOT NULL;

-- M18. Find employees with salary >= 10000, ordered by salary ascending.  
--   Hint: WHERE salary >= 10000 ORDER BY salary.

select * from HR.EMPLOYEES WHERE salary >= 10000 ORDER BY salary;

-- M19. List employees whose email ends with '.com' or contains 'example' (if applicable; otherwise use a pattern that exists).  
--   Hint: WHERE email LIKE '%.com' or email LIKE '%example%' depending on data.

select * from hr.EMPLOYEES WHERE email LIKE '%.com';

-- M20. Get distinct job_id values from employees in department 50.  
--   Hint: SELECT DISTINCT job_id FROM hr.employees WHERE department_id = 50.

SELECT DISTINCT job_id FROM hr.employees WHERE department_id = 50; 

--20 Hard Questions

-- H1. List employees in department 80 with salary > 7000 OR job_id = 'SA_MAN', ordered by salary DESC.  
--   Hint: WHERE (department_id = 80 AND salary > 7000) OR job_id = 'SA_MAN' ORDER BY salary DESC.

select * from hr.EMPLOYEES WHERE (department_id = 80 AND salary > 7000) OR job_id = 'SA_MAN' ORDER BY salary DESC;

-- H2. Find employees hired between Jan 1, 2000 and Dec 31, 2005.  
--   Hint: WHERE hire_date BETWEEN DATE '2000-01-01' AND DATE '2005-12-31'.

select * from hr.EMPLOYEES WHERE hire_date BETWEEN DATE '2000-01-01' AND DATE '2005-12-31';

-- H3. List employees whose last_name is 4 characters and starts with 'K'.  
--   Hint: WHERE last_name LIKE 'K___'.

SELECT * from hr.EMPLOYEES WHERE last_name LIKE 'K___';

-- H4. Get top 5 highest-paid employees in department 50 only.  
--   Hint: WHERE department_id = 50 ORDER BY salary DESC FETCH FIRST 5 ROWS ONLY.

select * from hr.EMPLOYEES WHERE department_id = 50 ORDER BY salary DESC FETCH FIRST 5 ROWS ONLY;

-- H5. List employees with no manager and salary > 5000.  
--   Hint: WHERE manager_id IS NULL AND salary > 5000.

select * from hr.EMPLOYEES WHERE manager_id IS NULL AND salary > 5000;

-- H6. Find employees whose first_name has an 'a' as the second character.  
--   Hint: WHERE first_name LIKE '_a%'.

select * from  hr.EMPLOYEES WHERE first_name LIKE '_a%';

-- H7. List departments (hr.departments) with department_id between 40 and 90.  
--   Hint: WHERE department_id BETWEEN 40 AND 90.

select * from hr.DEPARTMENTS where department_id BETWEEN 40 AND 90;

-- H8. Get employees with salary < 3000 or salary > 15000, ordered by salary.  
--   Hint: WHERE salary < 3000 OR salary > 15000 ORDER BY salary.

select * from hr.EMPLOYEES WHERE salary < 3000 OR salary > 15000 ORDER BY salary;

-- H9. List employees in department 60 with job_id 'IT_PROG', or in department 100 with job_id like 'FI%'.  
--   Hint: WHERE (department_id = 60 AND job_id = 'IT_PROG') OR (department_id = 100 AND job_id LIKE 'FI%').

select * from hr.employees WHERE (department_id = 60 AND job_id = 'IT_PROG') OR (department_id = 100 AND job_id LIKE 'FI%');

-- H10. Find employees whose hire_date is in the year 2003.  
--   Hint: WHERE EXTRACT(YEAR FROM hire_date) = 2003 or hire_date between DATE '2003-01-01' AND DATE '2003-12-31'.

select * from hr.employees WHERE EXTRACT(YEAR FROM hire_date) = 2003 or hire_date between DATE '2003-01-01' AND DATE '2003-12-31';

-- H11. List employees with commission_pct NULL and job_id starting with 'SA'.  
--   Hint: WHERE commission_pct IS NULL AND job_id LIKE 'SA%'.

select * from hr.EMPLOYEES WHERE commission_pct IS NULL AND job_id LIKE 'SA%';

-- H12. Get the 3 oldest employees (earliest hire_date) in department 90.  
--   Hint: WHERE department_id = 90 ORDER BY hire_date ASC FETCH FIRST 3 ROWS ONLY.

select * from hr.EMPLOYEES WHERE department_id = 90 ORDER BY hire_date ASC FETCH FIRST 3 ROWS ONLY;

-- H13. List employees whose last_name does not start with 'A', 'B', or 'C'.  
--   Hint: WHERE last_name NOT LIKE 'A%' AND last_name NOT LIKE 'B%' AND last_name NOT LIKE 'C%'; or use NOT IN with SUBSTR.

select * from hr.EMPLOYEES WHERE last_name NOT LIKE 'A%' AND last_name NOT LIKE 'B%' AND last_name NOT LIKE 'C%';

-- H14. Find employees with salary in (5000, 6000, 7000, 8000).  
--   Hint: WHERE salary IN (5000, 6000, 7000, 8000).

select * from hr.EMPLOYEES WHERE salary IN (5000, 6000, 7000, 8000);

-- H15. List employees ordered by department_id ASC, then by hire_date DESC within each department.  
--   Hint: ORDER BY department_id, hire_date DESC.

select * from hr.EMPLOYEES ORDER BY department_id, hire_date DESC;

-- H16. Get employees whose first_name and last_name both start with the same letter (simplified: same first letter).  
--   Hint: WHERE SUBSTR(first_name,1,1) = SUBSTR(last_name,1,1).

select * from hr.EMPLOYEES WHERE SUBSTR(first_name,1,1) = SUBSTR(last_name,1,1);

-- H17. List employees with manager_id not null and department_id in (50, 80, 100).  
--   Hint: WHERE manager_id IS NOT NULL AND department_id IN (50, 80, 100).

select * from hr.EMPLOYEES WHERE manager_id IS NOT NULL AND department_id IN (50, 80, 100);

-- H18. Find employees with salary between 3000 and 5000 and job_id containing 'REP'.  
--   Hint: WHERE salary BETWEEN 3000 AND 5000 AND job_id LIKE '%REP%'.

select * from hr.EMPLOYEES WHERE salary BETWEEN 3000 AND 5000 AND job_id LIKE '%REP%';

-- H19. List departments (hr.departments) ordered by department_name descending.  
--   Hint: SELECT * FROM hr.departments ORDER BY department_name DESC.

select * from hr.DEPARTMENTS ORDER BY department_name DESC;

-- H20. Get employees with hire_date not in 2004 (all years except 2004).  
--   Hint: WHERE EXTRACT(YEAR FROM hire_date) <> 2004 or hire_date < DATE '2004-01-01' OR hire_date > DATE '2004-12-31'.

select * from hr.EMPLOYEES WHERE EXTRACT(YEAR FROM hire_date) <> 2004 or hire_date < DATE '2004-01-01' OR hire_date > DATE '2004-12-31';