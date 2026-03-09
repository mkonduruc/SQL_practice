/*Day 14 Assignment: Window Functions – Ranking
All exercises use hr.employees (and hr.departments if needed).
Part 1: Practice Questions (With Answers and Explanations)*/

/* Question 1
Rank employees by salary within each department. Show employee_id, first_name, department_id, salary, and rank. Use RANK() with PARTITION BY department_id ORDER BY salary DESC.
Answer:*/

SELECT employee_id, first_name, department_id, salary,
  RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM hr.employees;

--Explanation: PARTITION BY department_id creates a separate ranking per department. ORDER BY salary DESC assigns rank 1 to the highest salary in that department. Ties get the same rank; the next rank skips (RANK behavior).

/* Question 2
Get the top earner per department (one row per department). Use ROW_NUMBER() in a subquery/CTE, then filter WHERE rn = 1.
Answer:*/

SELECT employee_id, first_name, department_id, salary
FROM (
  SELECT employee_id, first_name, department_id, salary,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
  FROM hr.employees
) sub
WHERE rn = 1;

--Explanation: The inner query assigns row number 1 to the highest salary in each department (ties get different numbers). The outer query keeps only rn = 1, so we get one top earner per department.

/* Question 3
Assign DENSE_RANK by hire_date within each job_id. Show job_id, employee_id, hire_date, and dense_rank. Oldest hire in the job gets 1.
Answer:*/

SELECT job_id, employee_id, hire_date,
  DENSE_RANK() OVER (PARTITION BY job_id ORDER BY hire_date) AS hire_rank
FROM hr.employees;

--Explanation: PARTITION BY job_id, ORDER BY hire_date (ascending) so the earliest hire gets rank 1. DENSE_RANK does not skip numbers when there are ties.

/*Part 2: Self-Practice (No Answers)*/

--1. Use NTILE(4) to assign each employee to one of four salary quartiles (over the whole table, ordered by salary). Show employee_id, salary, and quartile number.

select employee_id, first_name, last_name, salary, NTILE(4) over(order by salary) as quartile
from hr.employees;

--2. Rank employees by commission_pct with NULLS LAST (so NULL commission_pct appear at the end of the ranking).

select employee_id, first_name, last_name, commission_pct, RANK() over(order by commission_pct ) as rank_commission
from hr.employees;

/*Part 3: Additional Practice —--20 Medium +--20 Hard Questions (With Hints)
All use hr.employees and hr.departments only.*/

--20 Medium Questions

--M1. ROW_NUMBER() OVER (ORDER BY salary DESC) for each employee--Hint: Add ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn.

select employee_id, salary , ROW_NUMBER() OVER (ORDER BY salary DESC) from hr.employees; 

--M2. RANK() OVER (PARTITION BY department_id ORDER BY salary DESC)--Hint: Rank by salary within department.

select employee_id, department_id, salary, RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) from hr.employees; 

--M3. DENSE_RANK() OVER (ORDER BY hire_date) for tenure order--Hint: DENSE_RANK() OVER (ORDER BY hire_date).

select employee_id, hire_date, DENSE_RANK() OVER (ORDER BY hire_date) from hr.employees; 


--M4. NTILE(4) OVER (ORDER BY salary) for salary quartiles--Hint: NTILE(4) OVER (ORDER BY salary) AS quartile.

select employee_id, salary, NTILE(4) OVER (ORDER BY salary) from hr.employees; 

--M5. Top 1 per department by salary: use ROW_NUMBER() in subquery, then WHERE rn = --Hint: Subquery with ROW_NUMBER() PARTITION BY department_id ORDER BY salary DESC; outer WHERE rn = 1.

select employee_id, salary, department_id from
(select employee_id, salary, department_id, ROW_NUMBER() over(PARTITION BY department_id ORDER BY salary DESC) rank_salary from hr.employees)
where rank_salary = 1; 

--M6. RANK() OVER (ORDER BY salary DESC NULLS LAST)--Hint: NULLS LAST in ORDER BY.

select employee_id, salary, department_id, ROW_NUMBER() over(PARTITION BY department_id ORDER BY salary DESC) rank_salary from hr.employees;

--M7. ROW_NUMBER() OVER (PARTITION BY job_id ORDER BY hire_date)--Hint: Row number by hire date within job.

select employee_id, job_id, hire_date, ROW_NUMBER() OVER (PARTITION BY job_id ORDER BY hire_date) from hr.employees;

--M8. DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary)--Hint: Dense rank by salary within dept.

select employee_id, department_id, salary, DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary) from hr.employees;

--M9. NTILE(5) OVER (ORDER BY salary) for quintiles--Hint: NTILE(5).

select employee_id, salary, NTILE(5) OVER (ORDER BY salary) from hr.employees;

--M10. RANK() OVER (PARTITION BY department_id ORDER BY hire_date DESC) (newest first = 1)--Hint: Rank by hire_date DESC per dept.

select employee_id, department_id, hire_date from(
select employee_id, department_id, hire_date, RANK() OVER (PARTITION BY department_id ORDER BY hire_date DESC) rank_hire from hr.employees
) where rank_hire = 1; 

--M11. Show employee_id, salary, and ROW_NUMBER() OVER (ORDER BY employee_id)--Hint: Simple row number by employee_id.

select employee_id, salary, ROW_NUMBER() OVER (ORDER BY employee_id) from hr.employees;

--M12. DENSE_RANK() OVER (ORDER BY commission_pct DESC NULLS LAST)--Hint: Rank commission; NULLS LAST.

select employee_id, commission_pct, salary, DENSE_RANK() OVER (ORDER BY commission_pct DESC NULLS LAST) from hr.employees;

--M13. ROW_NUMBER() OVER (PARTITION BY department_id, job_id ORDER BY salary DESC)--Hint: Partition by dept and job.

select employee_id, department_id, job_id, salary, ROW_NUMBER() OVER (PARTITION BY department_id, job_id ORDER BY salary DESC) from hr.employees;

--M14. NTILE(10) OVER (ORDER BY salary) for deciles--Hint: NTILE(10).

select employee_id, salary, NTILE(10) OVER (ORDER BY salary) from hr.employees;

--M15. RANK() OVER (ORDER BY salary) for ascending rank (lowest salary = 1)--Hint: ORDER BY salary ASC.

select employee_id, department_id, salary, RANK() OVER (ORDER BY salary) from hr.employees; 

--M16. Top 3 per job_id by salary: ROW_NUMBER() PARTITION BY job_id ORDER BY salary DESC, then filter rn <= 3 --Hint: Subquery with rn; WHERE rn <= 3.

select job_id, employee_id, salary, rank_jobid from (
select employee_id, job_id, salary, ROW_NUMBER() over(PARTITION BY job_id ORDER BY salary DESC) rank_jobid from hr.employees
) where rank_jobid <= 3
order by job_id, employee_id;

--M17. DENSE_RANK() OVER (PARTITION BY job_id ORDER BY hire_date)--Hint: Dense rank by hire date per job.

select job_id, employee_id, hire_date, DENSE_RANK() OVER (PARTITION BY job_id ORDER BY hire_date) from hr.employees;

--M18. RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) and filter rank = 1 (highest per dept)--Hint: In subquery; WHERE rank = 1.

select department_id, employee_id, salary from(
select employee_id, department_id, salary, RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) rank_salary from hr.employees
) where rank_salary = 1; 

--M19. NTILE(3) OVER (PARTITION BY department_id ORDER BY salary)--Hint: Tertiles within each department.

select department_id, salary, NTILE(3) OVER (PARTITION BY department_id ORDER BY salary) from hr.employees;

--M20. ROW_NUMBER() OVER (PARTITION BY manager_id ORDER BY salary DESC) (rank among direct reports)--Hint: Partition by manager_id.

select manager_id, employee_id, salary, ROW_NUMBER() OVER (PARTITION BY manager_id ORDER BY salary DESC) from hr.employees;

--20 Hard Questions

--H1. Top 2 earners per department: ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC), filter rn <= --Hint: Subquery, WHERE rn <= 2.

select department_id, employee_id, salary from(
select department_id, employee_id, salary, ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) rank_depart from hr.employees
) where rank_depart < 3;

--H2. Rank employees by salary within department; show only those with rank <= 3 (top 3 per dept)--Hint: RANK() or ROW_NUMBER(); filter rank/rn <= 3.

select department_id, employee_id, salary from(
select department_id, employee_id, salary, ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) rank_dept from hr.employees
) where rank_dept <= 3; 

--H3. DENSE_RANK() OVER (PARTITION BY job_id ORDER BY salary DESC) and also show job_id and count of people in that job (use COUNT(*) OVER (PARTITION BY job_id))--Hint: Two window functions: DENSE_RANK and COUNT(*) OVER (PARTITION BY job_id).

select job_id, employee_id, salary, DENSE_RANK() OVER (PARTITION BY job_id ORDER BY salary DESC) from hr.employees;

--H4. NTILE(4) OVER (ORDER BY salary) and then group by quartile to show min(salary), max(salary) per quartile--Hint: Subquery with NTILE; outer query GROUP BY quartile.

select quartile, min(salary) least_salary from (
select employee_id, salary, NTILE(4) OVER (ORDER BY salary) quartile from hr.employees
) group by quartile;

--H5. ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY hire_date) to get "first hired" per department (rn=1)--Hint: ORDER BY hire_date; WHERE rn = 1.

select department_id, employee_id, hire_date from(
select department_id, employee_id, hire_date, ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY hire_date) rank_hire from hr.employees
) where rank_hire = 1;

--H6. Rank by salary within department; show only employees with rank 1 or 2 (two highest per dept)--Hint: RANK() or DENSE_RANK(); WHERE rank IN (1,2).

select department_id, employee_id, salary from (
select department_id, employee_id, salary, RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) rank_dept from hr.employees
) where rank_dept < 3; 

--H7. RANK() OVER (PARTITION BY job_id ORDER BY salary DESC) and RANK() OVER (PARTITION BY job_id ORDER BY hire_date)--Hint: Two different RANK() in same SELECT.

select job_id, employee_id, hire_date, salary, RANK() over(PARTITION BY job_id ORDER BY salary DESC) rank_salary, Rank() over(PARTITION BY job_id ORDER BY hire_date) rank_hire from hr.employees; 

--H8. NTILE(4) OVER (PARTITION BY department_id ORDER BY salary) (quartiles within dept)--Hint: NTILE(4) with PARTITION BY department_id.

select department_id, employee_id, salary, NTILE(4) OVER (PARTITION BY department_id ORDER BY salary) from hr.employees;

--H9. DENSE_RANK() OVER (ORDER BY salary DESC) and filter where dense_rank = 5 (5th highest salary)--Hint: Subquery; WHERE dense_rank = 5.

select employee_id, department_id, salary from (
select employee_id, department_id, salary, DENSE_RANK() OVER (ORDER BY salary DESC) rank_salary from hr.employees
) where rank_salary = 5;

--H10. ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC, employee_id) to break ties--Hint: Add employee_id to ORDER BY for deterministic order.

select department_id, employee_id, salary, ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC, employee_id) from hr.employees;

--H11. Top 1 employee per department by tenure (earliest hire): ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY hire_date), rn=--Hint: ORDER BY hire_date ASC; rn=1.

select department_id, employee_id, hire_date from (
select department_id, employee_id, hire_date, ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY hire_date) rank_dept from hr.employees
) where rank_dept = 1;

--H12. RANK() OVER (PARTITION BY job_id ORDER BY salary) and show only rank 1 (lowest salary per job)--Hint: Subquery; WHERE rank = 1.

select job_id, employee_id, salary from (
select job_id, employee_id, salary, RANK() OVER (PARTITION BY job_id ORDER BY salary) rank_salary from hr.employees
) where rank_salary = 1; 

--H13. NTILE(2) OVER (PARTITION BY department_id ORDER BY salary) (median split per dept)--Hint: NTILE(2) per department_id.

select department_id, employee_id, salary, NTILE(2) OVER (PARTITION BY department_id ORDER BY salary) from hr.employees;

--H14. DENSE_RANK() OVER (PARTITION BY department_id ORDER BY hire_date DESC) and filter rank = 1 (most recently hired per dept)--Hint: ORDER BY hire_date DESC; rank=1.

select department_id, employee_id, salary from(
select employee_id, department_id, salary, DENSE_RANK() OVER (PARTITION BY department_id ORDER BY hire_date DESC) rank_dept from hr.employees
) where rank_dept = 1;

--H15. ROW_NUMBER() OVER (ORDER BY salary DESC) and filter row number between 5 and 10 (5th to 10th highest salary)--Hint: WHERE rn BETWEEN 5 AND 10.

select employee_id, job_id, hire_date from(
select employee_id, job_id, hire_date, ROW_NUMBER() OVER (ORDER BY salary) rank_salary from hr.employees
) where rank_salary between 5 and 10;

--H16. Rank employees by salary within department; show department_id, employee_id, salary, rank; include only departments with at least 3 employees--Hint: Use subquery with RANK(); outer WHERE department_id IN (SELECT department_id FROM hr.employees GROUP BY department_id HAVING COUNT(*) >= 3) or use COUNT(*) OVER.

select department_id, employee_id, salary from (
select department_id, employee_id, salary, RANK() OVER (PARTITION BY department_id ORDER BY salary) rank_salary from hr.employees
) where rank_salary < 4; 

--H17. NTILE(4) OVER (ORDER BY salary) and ROUND(AVG(salary) OVER (), 2) in same SELECT--Hint: NTILE + AVG(salary) OVER () for company avg.

select employee_id, salary, AVG(salary) OVER (ORDER BY salary), NTILE(4) OVER (ORDER BY salary) from hr.employees;

--H18. RANK() OVER (PARTITION BY manager_id ORDER BY salary DESC) (rank among direct reports per manager)--Hint: Partition by manager_id.

select manager_id, employee_id, salary, RANK() OVER (PARTITION BY manager_id ORDER BY salary DESC) from hr.employees; 

--H19. Top 3 jobs by total salary: from (SELECT job_id, SUM(salary) s FROM hr.employees GROUP BY job_id ORDER BY s DESC FETCH FIRST 3 ROWS ONLY) or use RANK() over grouped data--Hint: Subquery with GROUP BY and RANK() OVER (ORDER BY SUM(salary) DESC) or FETCH.

SELECT job_id, SUM(salary) total_salary FROM hr.employees GROUP BY job_id ORDER BY total_salary DESC FETCH FIRST 3 ROWS ONLY;

select job_id, total_salary from (select job_id, total_salary, RANK() OVER (ORDER BY total_salary DESC) rank_salary from (SELECT job_id, SUM(salary) total_salary FROM hr.employees GROUP BY job_id)) where rank_salary <= 3; 

--H20. DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) and also show (SELECT department_name FROM hr.departments d WHERE d.department_id = e.department_id)--Hint: Join departments or scalar subquery for name; DENSE_RANK in SELECT.

select department_name, employee_id, salary, DENSE_RANK() OVER (PARTITION BY emp.department_id ORDER BY salary DESC) from hr.employees emp
join hr.departments dpt on dpt.department_id = emp.department_id;
