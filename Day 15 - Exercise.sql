/*Day 15 Assignment: Window Functions – Value and Frame
All exercises use hr.employees only.
Part 1: Practice Questions (With Answers and Explanations)*/

/* Question 1
Show a running total of salary ordered by hire_date (company-wide). For each row, show employee_id, hire_date, salary, and running_total_salary.
Answer:*/

SELECT employee_id, hire_date, salary,
  SUM(salary) OVER (ORDER BY hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_salary
FROM employees;

-- Explanation: The window is all rows from the start of the result set up to the current row, ordered by hire_date. SUM(salary) over that frame gives the cumulative sum. Default frame for SUM with ORDER BY in Oracle is often equivalent; explicit ROWS UNBOUNDED PRECEDING AND CURRENT ROW makes it clear.

/* Question 2
For each employee, show previous employee salary within the same department (order by employee_id). Use LAG(salary) with PARTITION BY department_id ORDER BY employee_id.
Answer:*/

SELECT employee_id, department_id, salary,
  LAG(salary) OVER (PARTITION BY department_id ORDER BY employee_id) AS prev_salary_in_dept
FROM employees;

-- Explanation: LAG(salary) returns the salary of the previous row in the partition. Partition by department_id and order by employee_id so "previous" is by employee_id within the department. First row in each partition has no previous row, so prev_salary_in_dept is NULL.

/* Question 3
Show a moving 3-row average of salary within each department. Order by employee_id; for each row, average the current row and the two preceding rows (or fewer at the start). Use AVG(salary) with ROWS BETWEEN 2 PRECEDING AND CURRENT ROW.
Answer:*/

SELECT employee_id, department_id, salary,
  AVG(salary) OVER (PARTITION BY department_id ORDER BY employee_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3
FROM employees;

-- Explanation: For each row, the frame is at most the current row and the two preceding rows (by employee_id within department). AVG over that frame gives the moving average. At the start of a department there are fewer than 3 rows, so the average is over 1 or 2 values.

/*Part 2: Self-Practice (No Answers)*/

--1. Use LEAD(hire_date) to show the next employee hire date within the same department (order by hire_date).

SELECT department_id, employee_id,
  LEAD(hire_date) OVER (PARTITION BY department_id ORDER BY hire_date) AS next_hire_date_dept
FROM employees;

--2. Show cumulative salary (running total) per department, ordered by hire_date within each department.

SELECT employee_id, department_id, salary,
  SUM(salary) OVER (PARTITION BY department_id ORDER BY HIRE_DATE) AS cumulative_salary
FROM employees;


/*Part 3: Additional Practice —--20 Medium +--20 Hard Questions (With Hints)
All use hr.employees and hr.departments only.*/

--20 Medium Questions

--M1. LAG(salary) OVER (PARTITION BY department_id ORDER BY employee_id)--Hint: Previous row's salary in dept.
--M2. LEAD(salary) OVER (PARTITION BY department_id ORDER BY employee_id)--Hint: Next row's salary in dept.
--M3. SUM(salary) OVER (ORDER BY hire_date ROWS UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total--Hint: Running total by hire_date.
--M4. AVG(salary) OVER (PARTITION BY department_id)--Hint: Dept average per row.
--M5. LAG(hire_date) OVER (PARTITION BY department_id ORDER BY hire_date)--Hint: Previous hire date in dept.
--M6. SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date ROWS UNBOUNDED PRECEDING AND CURRENT ROW)--Hint: Running total per dept by hire_date.
--M7. LEAD(hire_date) OVER (PARTITION BY department_id ORDER BY hire_date)--Hint: Next hire date in dept.
--M8. AVG(salary) OVER (PARTITION BY department_id ORDER BY employee_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)--Hint: Moving 3-row average per dept.
--M9. FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY salary)--Hint: Min salary in dept.
--M10. LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY salary RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)--Hint: Max salary in dept.
--M11. LAG(salary, 2, 0) OVER (ORDER BY employee_id)--Hint: Salary from 2 rows back; default 0.
--M12. SUM(salary) OVER (PARTITION BY job_id ORDER BY hire_date)--Hint: Running total per job.
--M13. LEAD(commission_pct) OVER (PARTITION BY department_id ORDER BY employee_id)--Hint: Next row's commission_pct in dept.
--M14. AVG(salary) OVER (ORDER BY hire_date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW)--Hint: Moving 5-row average.
--M15. LAG(first_name) OVER (PARTITION BY department_id ORDER BY employee_id)--Hint: Previous employee's first name in dept.
--M16. SUM(salary) OVER () AS total_company_salary (same value per row)--Hint: No PARTITION/ORDER or ORDER BY with full window.
--M17. FIRST_VALUE(hire_date) OVER (PARTITION BY department_id ORDER BY hire_date)--Hint: Earliest hire in dept.
--M18. LAST_VALUE(hire_date) OVER (PARTITION BY department_id ORDER BY hire_date RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)--Hint: Latest hire in dept.
--M19. LAG(salary) OVER (ORDER BY salary DESC)--Hint: Next lower salary (order by salary desc so "previous" in that order).
--M20. COUNT(*) OVER (PARTITION BY department_id)--Hint: Count of employees in dept per row.

--20 Hard Questions

--H1. Running total of salary by hire_date for whole company; also show running count (COUNT(*) OVER (ORDER BY hire_date ROWS UNBOUNDED PRECEDING AND CURRENT ROW))--Hint: SUM and COUNT with same frame.
--H2. For each employee show salary, LAG(salary), and salary - LAG(salary) AS diff_from_prev (difference from previous row's salary in partition)--Hint: LAG in SELECT; then expression; partition by dept order by employee_id.
--H3. Moving average of salary (5 rows: 2 preceding, current, 2 following) per department--Hint: ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING.
--H4. FIRST_VALUE(salary) and LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY salary) with correct frame for LAST_VALUE--Hint: LAST_VALUE needs RANGE UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING.
--H5. Lead of hire_date (next hire in dept) and DATEDIFF or (LEAD(hire_date) - hire_date) for days between hires--Hint: LEAD(hire_date) - hire_date; Oracle date arithmetic gives days.
--H6. Running sum of salary partitioned by department_id, ordered by hire_date; also show row number within department by hire_date--Hint: SUM(...) OVER (PARTITION BY department_id ORDER BY hire_date); ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY hire_date).
--H7. LAG(salary, 1, salary) OVER (PARTITION BY department_id ORDER BY employee_id) (previous salary or self if first)--Hint: Default third arg = salary for first row.
--H8. Percent of department total: salary * 100.0 / SUM(salary) OVER (PARTITION BY department_id)--Hint: Ratio to sum; no ORDER BY in SUM for full partition.
--H9. Running total of salary by department and hire_date; show also cumulative percentage of department total (running_sum / SUM(salary) OVER (PARTITION BY department_id) * 100)--Hint: Running sum and fixed sum per dept.
--H10. LEAD(salary, 2) OVER (PARTITION BY job_id ORDER BY salary DESC) (salary of person 2 ranks below in job)--Hint: LEAD with offset 2.
--H11. FIRST_VALUE(first_name) OVER (PARTITION BY department_id ORDER BY salary DESC) (name of highest-paid in dept)--Hint: ORDER BY salary DESC; first value is top earner.
--H12. Moving 3-row median or middle value: use NTH_VALUE(salary, 2) OVER (PARTITION BY department_id ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) if available, or average of --Hint: Oracle: NTH_VALUE or (LAG(salary)+salary+LEAD(salary))/3 for 3-row window.
--H13. Running sum of salary per department; reset at each new department--Hint: SUM(salary) OVER (PARTITION BY department_id ORDER BY employee_id ROWS UNBOUNDED PRECEDING AND CURRENT ROW).
--H14. LAG(salary) and LEAD(salary) in same SELECT; show salary, prev, next--Hint: Both LAG and LEAD with same PARTITION/ORDER.
--H15. LAST_VALUE(employee_id) OVER (PARTITION BY department_id ORDER BY hire_date RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) (employee_id of last hired in dept)--Hint: LAST_VALUE with full frame.
--H16. Running average (not sum) of salary over hire_date: AVG(salary) OVER (ORDER BY hire_date ROWS UNBOUNDED PRECEDING AND CURRENT ROW)--Hint: AVG with same frame as running sum.
--H17. Difference from department average: salary - AVG(salary) OVER (PARTITION BY department_id)--Hint: No ORDER BY in AVG for partition average.
--H18. LAG(salary) OVER (PARTITION BY department_id ORDER BY hire_date) and compare to current (salary - LAG(salary))--Hint: LAG by hire_date; then diff.
--H19. COUNT(*) OVER (PARTITION BY department_id ORDER BY hire_date ROWS UNBOUNDED PRECEDING AND CURRENT ROW) (running count of employees in dept by hire order)--Hint: Running count with same frame.
--H20. FIRST_VALUE and LAST_VALUE of salary OVER (PARTITION BY job_id ORDER BY salary); show job_id, salary, min_sal, max_sal--Hint: FIRST_VALUE and LAST_VALUE with full frame for LAST_VALUE.

