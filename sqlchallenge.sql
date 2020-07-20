-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  		PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  		PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
  emp_no INT NOT NULL,	
  dept_no VARCHAR(4) NOT NULL, 
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,  
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
  		PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

SELECT * FROM departments;

SELECT * FROM dept_emp;

SELECT * FROM dept_manager;

SELECT * FROM employees;

SELECT * FROM salaries;

SELECT * FROM titles;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

SELECT ri.emp_no,
	ri.first_name,
ri.last_name,
	de.to_date 
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO retirement_dep_info
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no,
	e.first_name,
e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)N (e.emp_no = s.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');
	 
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
INTO sales_dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no) AND (d.dept_name='Sales');

SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
INTO sales__dev_dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE dept_name IN ('Sales','Development')
;
rollback

--------------------------------------------------------------------------------------------------------------------------------------
--Challenge Tech analysis 1 
--sort employees_eligible_for retirement

SELECT e.emp_no,
e.first_name,
e.last_name,
s.salary,
de.to_date,
ti.from_date,
ti.title
INTO retirement_employees
FROM employees as e
INNER JOIN salaries as s
	ON e.emp_no = s.emp_no
INNER JOIN dept_emp as de
	ON e.emp_no = de.emp_no
INNER JOIN titles as ti
	ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
		AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
		AND (de.to_date = '9999-01-01');
		
rollback		
-- Partition the data to show only most recent title per employee
SELECT emp_no,
	first_name,
	last_name,
	title,
	salary,
	from_date
INTO retirement_employees_filtered
FROM
 (SELECT emp_no,
	first_name,
	last_name,
	title,
	salary,
	from_date, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY from_date DESC) rn
 FROM retirement_employees
 ) tmp WHERE rn = 1
ORDER BY emp_no
;



---Show Sum of current employess eligible for retirement
SELECT title,
	COUNT (DISTINCT emp_no)
INTO employees_eligible_for_retirement_count_title
FROM retirement_employees_filtered
GROUP BY title
;


---Show current employees by title 
SELECT e.emp_no,
e.first_name,
e.last_name,
s.salary,
de.to_date,
ti.from_date,
ti.title
INTO current_employees
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE(de.to_date = '9999-01-01');	
--filter out duplicates 
SELECT emp_no,
	first_name,
	last_name,
	title,
	salary,
	from_date
INTO current_employees_by_title
FROM
 (SELECT emp_no,
	first_name,
	last_name,
	title,
	salary,
	from_date, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY from_date DESC) rn
 FROM current_employees
 ) tmp WHERE rn = 1
ORDER BY emp_no
;
SELECT title,
	COUNT (DISTINCT emp_no)
INTO current_employees_by_title_count
FROM current_employees_by_title
GROUP BY title
;		
--Challenge Tech Analysis 2
--Select employees for mentoring program 
SELECT e.emp_no,
e.first_name,
e.last_name,
de.from_date,
ti.to_date,
ti.title
INTO mentoring_employees
FROM employees as e
JOIN titles as ti
ON (e.emp_no = ti.emp_no)
JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
		AND (de.to_date = '9999-01-01');

-- Partition the data to show only most recent title per employee
SELECT emp_no,
	first_name,
	last_name,
	from_date,
	to_date,
	title
INTO mentoring_employees_filtered
FROM
 (SELECT emp_no,
	first_name,
	last_name,
	from_date,
	to_date,
  	title, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY from_date DESC) rn
 FROM mentoring_employees
 ) tmp WHERE rn = 1
ORDER BY emp_no
;

SELECT title,
	COUNT (DISTINCT emp_no)
INTO mentoring_employees_count
FROM mentoring_employees_filtered
GROUP BY title
;		
