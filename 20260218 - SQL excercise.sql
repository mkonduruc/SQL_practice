--How many employees earn more than 8000 salary?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where salary > 8000;
--33

--How many employees were hired before 2015?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where extract(year from HIRE_DATE) < 2015;
--24

-- How many employees belong to department 50?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where DEPARTMENT_ID = 50;
--45

-- How many employees have commission percentage assigned?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where COMMISSION_PCT is not NULL;
--35

-- How many employees do not have a manager?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where manager_id is NULL;
--1

-- How many employees’ first name starts with ‘J’?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where FIRST_NAME like 'J%';
--16

-- How many employees’ last name ends with ‘S’?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where LAST_NAME like '%s';
--20

-- How many employees have salary between 4000 and 9000?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where salary between 4000 and 9000;
--42

-- How many employees earn the maximum salary?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where salary = (select max(salary) from hr.EMPLOYEES);
--1

-- How many employees earn the minimum salary?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where salary = (select min(salary) from hr.EMPLOYEES);
--1

-- How many employees have email containing letter ‘A’?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where EMAIL like '%A%';
--58

-- How many employees have job_id starting with ‘IT’?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where JOB_ID like 'IT%';
--5

-- How many employees were hired in 2021?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where extract(year from HIRE_DATE) = 2021;
--0

-- How many employees have salary less than average salary?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where salary < (select avg(salary) from hr.EMPLOYEES);
--56

-- How many employees have phone number available?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where PHONE_NUMBER is NOT NULL;
--107

-- How many employees do not belong to any department?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where DEPARTMENT_ID is NULL;
--1

-- How many employees have exactly 6 characters in first name?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where length(FIRST_NAME) = 6;
--23

-- How many employees have salary greater than 5000 and department 20?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where salary >  5000 and DEPARTMENT_ID = 20;
--2

-- How many employees have commission greater than 0.15?

select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where COMMISSION_PCT > 0.15;
--24

-- How many employees have salary not between 3000 and 7000?


select count(distinct EMPLOYEE_ID) from hr.EMPLOYEES
where salary not between 3000 and 7000;
--68
