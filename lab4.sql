CREATE TABLE employees1 (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC(10,2),
    hire_date DATE,
    manager_id INTEGER,
    email VARCHAR(100)
 );
 CREATE TABLE projects1 (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    budget NUMERIC(12,2),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20)
 );
 CREATE TABLE assignments (
    assignment_id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees1(employee_id),
    project_id INTEGER REFERENCES projects1(project_id),
    hours_worked NUMERIC(5,1),
    assignment_date DATE
 );

 INSERT INTO employees1 (first_name, last_name, department,
salary, hire_date, manager_id, email) VALUES
 ('John', 'Smith', 'IT', 75000, '2020-01-15', NULL,
'john.smith@company.com'),
 ('Sarah', 'Johnson', 'IT', 65000, '2020-03-20', 1,
'sarah.j@company.com'),
 ('Michael', 'Brown', 'Sales', 55000, '2019-06-10', NULL,
'mbrown@company.com'),
 ('Emily', 'Davis', 'HR', 60000, '2021-02-01', NULL,
'emily.davis@company.com'),
 ('Robert', 'Wilson', 'IT', 70000, '2020-08-15', 1, NULL),
 ('Lisa', 'Anderson', 'Sales', 58000, '2021-05-20', 3,
'lisa.a@company.com');
 INSERT INTO projects1 (project_name, budget, start_date,
end_date, status) VALUES
 ('Website Redesign', 150000, '2024-01-01', '2024-06-30',
'Active'),
 ('CRM Implementation', 200000, '2024-02-15', '2024-12-31',
'Active'),
 ('Marketing Campaign', 80000, '2024-03-01', '2024-05-31',
'Completed'),
 ('Database Migration', 120000, '2024-01-10', NULL, 'Active');
 INSERT INTO assignments (employee_id, project_id,
hours_worked, assignment_date) VALUES
 (1, 1, 120.5, '2024-01-15'),
 (2, 1, 95.0, '2024-01-20'),
 (1, 4, 80.0, '2024-02-01'),
 (3, 3, 60.0, '2024-03-05'),
 (5, 2, 110.0, '2024-02-20'),
 (6, 3, 75.5, '2024-03-10');
--part1
--task1.1
SELECT
    first_name || ' ' || last_name AS full_name,
    department,
    salary
FROM
    employees1;
--task1.2
SELECT DISTINCT
    department
FROM employees1;
--task1.3
SELECT
    project_name,
    budget,
    CASE
        WHEN budget > 150000 THEN 'Large'
        WHEN budget BETWEEN 100000 AND 150000 THEN 'Medium'
        ELSE 'Small'
    END AS budget_category
FROM projects1;
--task1.4
SELECT
    first_name || ' ' || last_name AS full_name,
    COALESCE(email, 'No email provided') AS email
FROM employees1;
--part2
--task2.1
SELECT
    first_name,
    last_name,
    hire_date
FROM employees1
WHERE hire_date > '2020-01-01';
--task2.2
SELECT
    first_name,
    last_name,
    salary
FROM employees1
WHERE salary BETWEEN 60000 AND 70000;
--task2.3
SELECT
    last_name,
    first_name
FROM employees1
WHERE last_name LIKE 'S%' OR last_name LIKE 'J%';
--task2.4
SELECT
    first_name,
    last_name,
    manager_id,
    department
FROM employees1
WHERE manager_id IS NOT NULL AND department='IT';

--part3
--task3.1
SELECT
    UPPER(first_name || ' ' || last_name) AS full_name_uppercase,
    LENGTH(last_name) AS length_of_last_name,
    SUBSTRING(email FROM 1 FOR 3) AS substr_email
FROM employees1;
--task3.2
SELECT
    first_name || ' ' || last_name AS full_name,
    salary * 12 AS annual_salary,
    ROUND(salary/12, 2) AS monthly_salary,
    salary * 1.10 AS rised_salary_10
FROM employees1;
--task3.3
SELECT
    FORMAT('Project: %s - Budget: $%%.2f - Status: %s', project_name, budget, status) AS formated_project
FROM projects1;
--task3.4
SELECT
    first_name || ' ' || last_name AS full_name,
    EXTRACT(YEAR FROM AGE(hire_date)) AS years_with_company
FROM employees1;
--part4
--task4.1
SELECT
    department,
    AVG(salary) AS avarage_salary
FROM employees1
GROUP BY department;

--task4.2
SELECT
    p.project_name,
    SUM(a.hours_worked) AS total_hours_worked
FROM assignments a
JOIN projects1 p on a.project_id = p.project_id
GROUP BY p.project_name;

--task4.3
SELECT
    department,
    COUNT(employee_id) AS emp_count
FROM employees1
GROUP BY department
HAVING COUNT(employee_id) > 1;
--task4.4
SELECT
    MAX(salary) AS max_salary,
    MIN(salary) AS min_salary,
    SUM(salary) AS total_salary
FROM employees1;
--part5
--task5.1
SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM employees1
WHERE salary > 65000
UNION
SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM employees1
WHERE hire_date>'2020-01-01';
--task5.2
SELECT
    first_name,
    last_name,
    salary,
    department
FROM employees1
WHERE department='IT'
INTERSECT
SELECT
    first_name,
    last_name,
    salary,
    department
FROM employees1
WHERE salary>65000;
--task5.3
SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name,
    salary
FROM
    employees1

EXCEPT

SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    e.salary
FROM
    employees1 e
JOIN
    assignments a ON e.employee_id = a.employee_id;
--part6
--task6.1
SELECT
    employee_id,
    first_name,
    last_name
FROM employees1 e
WHERE EXISTS(SELECT 1 FROM assignments a WHERE a.employee_id=e.employee_id);
--task6.2
SELECT
    employee_id,
    first_name,
    last_name
FROM employees1
WHERE
    employee_id IN(
        SELECT DISTINCT employee_id
        FROM assignments a
        JOIN projects1 p on a.project_id = p.project_id
        WHERE p.status='Active'
    );
--task6.3
SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM employees1
WHERE
    salary>ANY(
        SELECT salary
        FROM employees1
        WHERE department='Sales'
    );

--part7
--task7.1
SELECT
    first_name,
    last_name,
    department,
    AVG(a.hours_worked) AS average_hours_worked,
    RANK() OVER(PARTITION BY e.department ORDER BY e.salary DESC ) AS salary_rank
FROM employees1 e
JOIN assignments a on e.employee_id = a.employee_id
GROUP BY e.employee_id, e.department;
--task7.2
SELECT
    p.project_name,
    SUM(a.hours_worked) AS total_hours_worked,
    COUNT(DISTINCT a.employee_id) AS employees_assignd
FROM projects1 p
JOIN assignments a on p.project_id = a.project_id
GROUP BY p.project_name
HAVING SUM(a.hours_worked)>150;
--task7.3
SELECT
    e.department,
    COUNT(e.employee_id) AS count_of_all_employee,
    AVG(e.salary) AS avarage_salary,
    GREATEST(e.first_name || ' ' || e.last_name) AS greatest_salary,
    LEAST(e.first_name || ' ' || e.last_name) AS smallest_salary
FROM employees1 e
GROUP BY e.department, e.first_name, e.last_name;