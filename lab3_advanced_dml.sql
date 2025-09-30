CREATE DATABASE advanced_lab;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    department VARCHAR(50),
    salary INTEGER,
    hire_date DATE,
    status VARCHAR(50) DEFAULT 'Active'
);

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100),
    budget INTEGER,
    manager_id INTEGER
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INTEGER,
    start_date DATE,
    end_date DATE,
    budget INTEGER,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO employees (emp_id, first_name, last_name, department)
VALUES (1, 'Assel', 'Bazhikey', 'fullstack');

INSERT INTO employees (emp_id, first_name, last_name, department)
VALUES (2,'Anel', 'Yeraliyeva', 'backend');

INSERT INTO employees (first_name, last_name, department)
VALUES
    ('Dariya', 'Yergaliyeva', 'fullstack'),
    ('Bek', 'Yerlepes', 'ML'),
    ('Nurasyl', 'Dulatuly', 'backend'),
    ('Serdar', 'Dundar', 'frontend');

SELECT setval(pg_get_serial_sequence('employees', 'emp_id'), (SELECT MAX(emp_id) FROM employees));

INSERT INTO employees (first_name, last_name, department, hire_date, salary)
VALUES ('Timur', 'Fedorov', 'Marketing', CURRENT_DATE, 50000 * 1.1);

CREATE TEMPORARY TABLE temp_employees AS
    SELECT * FROM employees WHERE department = 'fullstack';

UPDATE employees SET salary = salary * 1.1 WHERE department = 'Marketing';

UPDATE employees
SET salary = CASE
    WHEN first_name = 'Assel' AND last_name = 'Bazhikey' THEN 70000
    WHEN first_name = 'Anel' AND last_name = 'Yeraliyeva' THEN 65000
    WHEN first_name = 'Dariya' AND last_name = 'Yergaliyeva' THEN 70000
    WHEN first_name = 'Bek' AND last_name = 'Yerlepes' THEN 75000
    WHEN first_name = 'Nurasyl' AND last_name = 'Dulatuly' THEN 65000
    WHEN first_name = 'Serdar' AND last_name = 'Dundar' THEN 60000
    ELSE salary
END
WHERE first_name IN ('Anel', 'Dariya', 'Bek', 'Nurasyl', 'Serdar');

UPDATE employees SET status = 'Senior'
WHERE salary > 60000 AND hire_date < '2020-01-01';

UPDATE employees
SET department = CASE
  WHEN salary > 80000 THEN 'Management'
  WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
  ELSE 'Junior'
END
WHERE salary IS NOT NULL;

UPDATE employees
SET  department = DEFAULT
WHERE status = 'Inactive';

UPDATE departments
SET budget=budget*1.20
WHERE dept_id IN (
    SELECT dept_id
    FROM employees
    GROUP BY dept_id
    HAVING AVG(salary)>50000
);

UPDATE employees
SET salary=salary*1.15,
    status='Promoted'
WHERE department='sales';

DELETE FROM employees WHERE status = 'Terminated';

DELETE FROM employees WHERE salary < 40000 AND hire_date > '2023-01-01' AND department IS NULL;

DELETE FROM departments
WHERE dept_id NOT IN (
SELECT DISTINCT CAST(department AS INTEGER)
FROM employees
WHERE department IS NOT NULL);

DELETE FROM projects
WHERE end_date<'2023-01-01'
RETURNING *;

INSERT INTO employees (first_name, last_name, department, salary)
VALUES ('Batyrzhan', 'Orunbay', NULL, NULL);

UPDATE employees
SET department='Unassigned' WHERE department IS NULL;

DELETE FROM employees
WHERE salary IS NULL OR department IS NULL;

INSERT INTO employees (first_name, last_name, department)
VALUES ('Kamila', 'Yertiskyzy', 'Managment')
RETURNING emp_id, first_name, last_name;

UPDATE employees SET salary=salary + 5000
WHERE department = 'Managment'
RETURNING emp_id, salary-5000 AS old_salary, salary;

DELETE FROM employees
WHERE hire_date<'2021-01-01'
RETURNING *;

INSERT INTO employees (first_name, last_name, department)
SELECT 'Rauan', 'Assetov', 'backend'
WHERE NOT EXISTS (SELECT 1 FROM employees WHERE first_name='Rauan' AND last_name = 'Assetov');

UPDATE employees
SET salary = CASE
    WHEN departments.budget > 100000 THEN salary*1.10
    ELSE salary * 1.05
END
FROM departments;

INSERT INTO employees (first_name, last_name, department, salary)
VALUES ('Altair', 'Namazbekuly', 'HR', 65000),
       ('Arssen', 'Zhanat', 'Sales', 60000),
       ('Merey', 'Shynaly', 'Finance', 55000),
       ('Adiya', 'Ussen', 'Managment', 57000),
       ('Miras', 'Maibasar', 'Managment', 69000);

UPDATE employees SET salary=salary*1.10 WHERE hire_date=CURRENT_DATE;

INSERT INTO employees (first_name, last_name, department, status)
VALUES
       ('Nriya', 'Ussen', 'Analitic', 'Inactive'),
       ('Amir', 'Meirambek', 'Managment', 'Inactive');

CREATE TABLE employee_archive AS
     SELECT * FROM employees WHERE status='Inactive';

DELETE FROM employees
WHERE status='Inactive';

UPDATE projects
SET end_date=end_date + INTERVAL '30 days'
WHERE budget>5000
AND dept_id IN(
    SELECT dept_id
    FROM employees
    GROUP BY dept_id
    HAVING COUNT(*)>3
);

