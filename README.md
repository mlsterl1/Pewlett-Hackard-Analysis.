# Pewlett-Hackard-Analysis :
* Identify current employees born between 1952-1955 and hired between 1985-1988 that are eligible for retirement and sum by title. 
* Identify current employees and sum by title.
* Identify current employees eligible for mentoring prgram born between January 1, 1965 and December 31, 1965. 
* See the ERD below for the file structure : 
![Pewlett Hackard ERD](EmployeeDB.png)
## Methodology
# Employees eligible for retirement 
* To solve for current employees eligible for retirment I created a table using SELECT and joined the employees, dept_emp, titles and salaries. I then utlized the where and and statement to filter for date of birth between 1952-1955 and only current employees utlizing a to_date = 9999-01-01. This created the employee_retirement table
* SELECT e.emp_no,
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
		AND (hire_date BETWEEN '1985-01-01' AND '1985-12-31')
		AND (de.to_date = '9999-01-01');
* After realizing the table had duplicates because some employees had had more than one job title. I used partioning to filter the data table so that only the most current job titles were show for current employees via the from_date. Here I originally had my from_date from the departments table but realized that it duplicated the date for every title. I think added the from_date from the titles table to get a unique date for each title. This created the employee_retirement_filtered. 
* To count the employees by department I used the Count function on the employee_retirment_filtered table and put them into the employee_eligible_for_retirment_count_title. Total employees by department elgible for retirment are seen below :
![Employees Eligible for Retirement by Title](Employeeretirementbytitle.png)
