/*Day 18 Assignment: Indexes
All exercises refer to employees and departments. Create indexes only if your environment allows (e.g. on a copy table or with proper privileges).
Part 1: Practice Questions (With Answers and Explanations)*/

/*Question 1
Write the SQL to create an index on employees(department_id). Name the index (e.g. idx_emp_dept).
Answer:*/

CREATE INDEX idx_emp_dept ON employees(department_id);

--Explanation: This supports queries that filter or join on department_id. The optimizer can use the index for WHERE department_id = ? or JOIN on department_id.

/*Question 2
Write the SQL to create a composite index on employees that would help a query filtering by department_id and job_id together (e.g. WHERE department_id = 50 AND job_id = 'ST_CLERK').
Answer:*/

CREATE INDEX idx_emp_dept_job ON employees(department_id, job_id);

--Explanation: Put the more selective or commonly used column first. The index can be used for (department_id), or (department_id, job_id). It is not used for WHERE job_id = ? alone (leading column is department_id).

/*Question 3
Explain whether an index on salary would likely be used for the condition salary > 5000 (assume many rows have salary > 5000). What if only a few rows have salary > 5000?
Answer:*/ 
If many rows have salary > 5000, the optimizer may choose a full table scan because reading a large fraction of the table via the index can be more expensive than scanning the table once. If few rows have salary > 5000, an index on salary can be used for a range scan and look up only those rows, which is usually more efficient. The decision depends on statistics (table size, distribution, selectivity).


/*Part 2: Self-Practice (No Answers)*/

--1. Write CREATE INDEX for a query that filters by hire_date range (e.g--Hire_date BETWEEN date1 AND date2).

CREATE INDEX idx_emp_dept ON employees(hire_date);

--2. In what situation might a full table scan be preferred over an index scan on employees? (Consider table size and selectivity.)

when retrieving a large portion of the employees table; such as when querying more than 20-30% of rows.

/*Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)
Refer to employees and departments; create indexes only if your environment allows.*/

--20 Medium Questions

--M1. Create index on employees(department_id)--Hint: CREATE INDEX idx_emp_dept ON employees(department_id);

CREATE INDEX idx_emp_dept ON employees(department_id);

--M2. Create index on employees(salary)--Hint: CREATE INDEX idx_emp_sal ON employees(salary);

CREATE INDEX idx_emp_sal ON employees(salary);

--M3. Create composite index (department_id, job_id)--Hint: CREATE INDEX idx_dj ON employees(department_id, job_id);

CREATE INDEX idx_dj ON employees(department_id, job_id);

--M4. Create index on employees(hire_date)--Hint: CREATE INDEX idx_hire ON employees(hire_date);

CREATE INDEX idx_hire ON employees(hire_date);

--M5. Create unique index on employees(email)--Hint: CREATE UNIQUE INDEX idx_email ON employees(email);

CREATE UNIQUE INDEX idx_email ON employees(email);

--M6. When would index on department_id help? Hint: WHERE department_id = ? or JOIN on department_id.

where Oracle’s optimizer can use it to reduce the number of rows scanned.

--M7. Name an index meaningfully--Hint: idx_emp_dept, idx_employees_salary, etc.

CREATE INDEX idx_emp_dept ON employees(department_id);

--M8. Create index on departments(department_id) — usually PK already has one--Hint: CREATE INDEX ... or note PK index.

CREATE INDEX idx_departments_id ON departments(department_id);

--M9. Why composite (department_id, job_id) order? Hint: Leading column department_id used in many WHERE clauses.

A composite index involves multiple columns and allows the database engine to optimize queries involving those columns. 
The order of these columns within the index is crucial for optimizing specific types of queries.

--M10. When might index on low-cardinality column not help? Hint: Very few distinct values (e.g. gender) with no other filter.

unless the distribution of values is very skewed (e.g. 99% A, 0.99% NULL, 0.01% B).

--M11. Create index for ORDER BY hire_date--Hint: CREATE INDEX idx_hire ON employees(hire_date);

CREATE INDEX idx_hire ON employees(hire_date);

--M12. Drop an index by name--Hint: DROP INDEX index_name;

DROP INDEX idx_hire;

--M13. What type of index is default in Oracle? Hint: B-tree.

A B-tree (balanced tree) index 

--M14. Index for WHERE salary > 5000--Hint: CREATE INDEX on salary; range scan possible.

CREATE INDEX idx_salary_above_5000 ON employees(salary)
WHERE salary > 5000;

--M15. Why not index every column? Hint: Storage and DML cost; optimizer may not use all.



--M16. Composite index (job_id, department_id) — which predicates can use it? Hint: job_id = ? or (job_id = ? AND department_id = ?); not department_id alone.

CREATE INDEX idx_dj ON employees(department_id, job_id);

--M17. Create index on departments(location_id) if used in JOIN--Hint: CREATE INDEX idx_dept_loc ON departments(location_id);

CREATE INDEX idx_dept_loc ON departments(location_id);

--M18. What is a covering index? Hint: Index includes all columns needed by query; avoid table access.

A covering index is an index that contains all the columns a query needs, allowing the database to retrieve results directly from the index without accessing the table.

--M19. When does INSERT become slower? Hint: More indexes on table; each must be updated.

Indexes in databases act like search-optimized data structures (often B-trees) that allow quick lookups, but they come with a trade-off: every insert or update must also maintain these structures.

--M20. Index for COUNT() WHERE department_id = 50--Hint: Index on department_id helps filter.

CREATE INDEX idx_emp_dept50 ON employees (department_id)
WHERE department_id = 50;


--20 Hard Questions

--H1. Design composite index for WHERE department_id = ? AND job_id = ? AND salary > ?--Hint: (department_id, job_id, salary) or (department_id, job_id) with salary for filter.

CREATE INDEX idx_dept_job_salary ON employees (department_id, job_id, salary);

--H2. When would full table scan be chosen over index? Hint: Large fraction of rows returned; small table; low selectivity.



--H3. Create function-based index UPPER(last_name) for case-insensitive search--Hint: CREATE INDEX idx_upper_last ON employees(UPPER(last_name));

CREATE INDEX idx_upper_last ON employees(UPPER(last_name));

--H4. Explain index range scan for salary BETWEEN 5000 AND 10000--Hint: B-tree finds first key >= 5000 and scans until > 10000.



--H5. Why might two separate indexes (department_id) and (job_id) be less efficient than one composite (department_id, job_id) for dept+job query? Hint: One index access vs two; composite can satisfy both.

Optimizes queries that filter or sort using multiple columns together

--H6. What is index skip scan? Hint: Oracle can use composite index when leading column is not in predicate but has few distinct values.

Index skipping is a optimization technique that allows queries to use a composite index even when the leading column of the index is not included in the WHERE clause. 

--H7. Create index for ORDER BY department_id, salary DESC--Hint: CREATE INDEX idx_dept_sal ON employees(department_id, salary DESC);

CREATE INDEX idx_dept_sal ON employees(department_id, salary DESC);

--H8. When to avoid index on column that is always used with function (e.g. TRUNC(hire_date))? Hint: Function on column prevents index use; consider function-based index on TRUNC(hire_date).



--H9--Monitor index usage (concept)--Hint: USER_INDEXES; V$OBJECT_USAGE; or statistics.

ALTER INDEX emp_name_idx MONITORING USAGE;


--H10. Partial index (Oracle: not standard) — concept: index only rows where condition--Hint: Some DBs support WHERE in index definition; Oracle has limited support.

CREATE INDEX emp_active_idx ON employees (
    CASE WHEN status = 'ACTIVE' THEN employee_id END);

--H11. Composite index (manager_id, department_id) — for which query? Hint: WHERE manager_id = ? AND department_id = ? or manager_id = ?.



--H12. Why unique index on email? Hint: Enforce uniqueness; fast lookup for login.

CREATE UNIQUE INDEX idx_users_email ON users (LOWER(email));

--H13. Rebuild or coalesce index (concept)--Hint: ALTER INDEX ... REBUILD; for fragmentation.

ALTER INDEX idx_users_email REBUILD;

--H14. Index on (department_id, hire_date) for "earliest hire per department." Hint: Supports ORDER BY department_id, hire_date and filter by department_id.

CREATE INDEX idx_dept_hire ON employees (department_id, hire_date);

SELECT department_id, employee_id, hire_date
FROM (SELECT emp.*,
        ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY hire_date) AS row_num
    FROM employees emp)
WHERE row_num = 1;

--H15. When might optimizer choose full scan despite index? Hint: Statistics show large % of rows; index clustering factor poor.



--H16. Create index for JOIN employees e ON e.department_id = d.department_id--Hint: Index on employees(department_id).

CREATE INDEX idx_employees_dept_id ON employees (department_id);

--H17. Bitmap index (concept): when? Hint: Low cardinality; data warehouse; read-heavy.

CREATE BITMAP INDEX idx_emp_gender ON employees (gender);

Bitmap indexes used for low-cardinality, mostly static columns in read-heavy environments.

--H18. Why not composite (salary, department_id) for WHERE department_id = 50? Hint: Leading column should be department_id for that predicate.



--H19. Invisible index (Oracle): purpose--Hint: Test impact of dropping without actually dropping; make invisible first.

ALTER INDEX idx_customer_name INVISIBLE;

It is not used by the optimizer by default but can still be used if explicitly specified in a query (OPTIMIZER_USE_INVISIBLE_INDEXES).

--H20. List indexes on employees--Hint: SELECT index_name, column_name FROM user_ind_columns WHERE table_name = 'EMPLOYEES';

SELECT index_name, column_name FROM user_ind_columns WHERE table_name = 'EMPLOYEES';
