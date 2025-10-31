--task1
--1.1
CREATE TABLE employees6 (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10, 2)
 );
CREATE TABLE departments6 (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
 );
CREATE TABLE projects6 (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT,
    budget DECIMAL(10, 2)
);
--1.2
INSERT INTO employees6 (emp_id, emp_name, dept_id, salary)
VALUES
 (1, 'John Smith', 101, 50000),
 (2, 'Jane Doe', 102, 60000),
 (3, 'Mike Johnson', 101, 55000),
 (4, 'Sarah Williams', 103, 65000),
 (5, 'Tom Brown', NULL, 45000);
 INSERT INTO departments6 (dept_id, dept_name, location) VALUES
 (101, 'IT', 'Building A'),
 (102, 'HR', 'Building B'),
 (103, 'Finance', 'Building C'),
 (104, 'Marketing', 'Building D');
INSERT INTO projects6 (project_id, project_name, dept_id,
budget) VALUES
 (1, 'Website Redesign', 101, 100000),
 (2, 'Employee Training', 102, 50000),
 (3, 'Budget Analysis', 103, 75000),
 (4, 'Cloud Migration', 101, 150000),
 (5, 'AI Research', NULL, 200000);
--part2
--2.1
SELECT e.emp_name, d.dept_name
FROM employees6 e CROSS JOIN departments6 d;
--4*5=20
--2.2
SELECT e.emp_name, d.dept_name
FROM employees6 e, departments6 d;

SELECT e.emp_name, d.dept_name
FROM employees6 e
INNER JOIN departments6 d ON TRUE;
--2.3
SELECT e.emp_name, p.project_name
FROM employees6 e CROSS JOIN projects6 p ORDER BY e.emp_name, p.project_name;
--part3
--3.1
SELECT e.emp_name, d.dept_name, d.location
FROM employees6 e
INNER JOIN departments6 d ON e.dept_id = d.dept_id;
--4.
--because he has no department
--3.2
SELECT e.emp_name, d.dept_name, d.location
FROM employees6 e
INNER JOIN departments6 d USING (dept_id);
--there is no difference
--3.3
SELECT e.emp_name, d.dept_name, d.location
FROM employees6 e
NATURAL INNER JOIN departments6 d;
--3.4
SELECT e.emp_name, d.dept_name, p.project_name
FROM employees6 e
INNER JOIN departments6 d ON e.dept_id = d.dept_id
INNER JOIN projects6 p ON d.dept_id = p.dept_id;
--task4
--4.1
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS
dept_dept, d.dept_name
FROM employees6 e
LEFT JOIN departments6 d ON e.dept_id = d.dept_id;
--with nothing about department
--4.2
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS
dept_dept, d.dept_name
FROM employees6 e
LEFT JOIN departments6 d USING (dept_id);
--4.3
SELECT e.emp_name, e.dept_id
FROM employees6 e
LEFT JOIN departments6 d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;
--4.4
SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM departments6 d
LEFT JOIN employees6 e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY employee_count DESC;
--part5
--5.1
SELECT e.emp_name, d.dept_name
FROM employees6 e
RIGHT JOIN departments6 d ON e.dept_id = d.dept_id;
--5.2
SELECT d.dept_name, e.emp_name
FROM departments6 d
LEFT JOIN employees6 e ON d.dept_id = e.dept_id;
--5.3
SELECT d.dept_name, d.location
FROM employees6 e
RIGHT JOIN departments6 d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;
--part6
--6.1
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS
dept_dept, d.dept_name
FROM employees6 e
FULL JOIN departments6 d ON e.dept_id = d.dept_id;
--left:tom brown: emp_dept, dept_dept, dept_name(no department)
--right:104 Marketing: no employee
--6.2
SELECT d.dept_name, p.project_name, p.budget
FROM departments6 d
FULL JOIN projects6 p ON d.dept_id = p.dept_id;
--6.3
SELECT
    CASE
        WHEN e.emp_id IS NULL THEN 'Department without employees'
        WHEN d.dept_id IS NULL THEN 'Employee without department'
        ELSE 'Matched'
    END AS record_status,
    e.emp_id,
    d.dept_id
FROM employees6 e
FULL JOIN departments6 d ON e.dept_id=d.dept_id
WHERE e.emp_id IS NULL OR d.dept_id IS NULL;
--part7
--7.1
SELECT e.emp_name, d.dept_name, e.salary
FROM employees6 e
LEFT JOIN departments6 d ON e.dept_id = d.dept_id AND
d.location = 'Building A';
--7.2
SELECT e.emp_name, d.dept_name, e.salary
FROM employees6 e
LEFT JOIN departments6 d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';
--query1: employees without a department, their dept_name will be NULL, but they are still included and employees in departments not in Building A, their dept_name will also be NULL, but they are still included
--only employees in Building A, they will have the department information.
--query2: employees who have no department or in other buildings will be excluded from the result, only who are in Building A will be included
--7.3
SELECT e.emp_name, d.dept_name, e.salary
FROM employees6 e
INNER JOIN departments6 d ON e.dept_id = d.dept_id AND
d.location = 'Building A';

SELECT e.emp_name, d.dept_name, e.salary
FROM employees6 e
INNER JOIN departments6 d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';
--no difference, because INNER JOIN include only full matched result

--part8
--8.1
SELECT
    d.dept_name,
    e.emp_name,
    e.salary,
    p.project_name,
    p.budget
 FROM departments6 d
 LEFT JOIN employees6 e ON d.dept_id = e.dept_id
 LEFT JOIN projects6 p ON d.dept_id = p.dept_id
 ORDER BY d.dept_name, e.emp_name;
--8.2
ALTER TABLE employees6 ADD COLUMN manager_id INT;
UPDATE employees6 SET manager_id = 3 WHERE emp_id = 1;
UPDATE employees6 SET manager_id = 3 WHERE emp_id = 2;
UPDATE employees6 SET manager_id = NULL WHERE emp_id = 3;
UPDATE employees6 SET manager_id = 3 WHERE emp_id = 4;
UPDATE employees6 SET manager_id = 3 WHERE emp_id = 5;
SELECT
    e.emp_name AS employee,
    m.emp_name AS manager
FROM employees6 e
LEFT JOIN employees6 m ON e.manager_id=m.emp_id;
--8.3
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM departments6 d
INNER JOIN employees6 e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 50000;
--1
--INNER JOIN: use when you only want the data that exists in both tables.
--LEFT JOIN: use when you need all data from the left table, even if there is no match in the right table.
--2
--combinations: for generating combinations of items, such as creating all possible pairs of products and customers.
--3
--ON: filters before the join, affecting the join process itself.
--WHERE: filters after the join, excluding rows with NULL values from outer joins.
--4
--5*10=50
--5
--NATURAL JOIN automatically joins on columns with the same name in both tables.
--6
--joins on all columns with the same name, which may not be desired, can't specify which columns to join on explicitly.
--7
--SELECT * FROM B RIGHT JOIN A
--ON A.id = B.id
--8
--use FULL OUTER JOIN to return all rows from both tables, including non-matching rows from both sides

--additional
--1
SELECT e.emp_name, d.dept_name
FROM employees6 e
LEFT JOIN departments6 d ON e.dept_id=d.dept_id
UNION
SELECT e.emp_name, d.dept_name
FROM employees6 e
RIGHT JOIN departments6 d ON e.dept_id=d.dept_id;
--2
SELECT e.emp_name
FROM employees6 e
JOIN departments6 d ON e.dept_id=d.dept_id
WHERE d.dept_id IN(
    SELECT dept_id
    FROM projects6 p
    GROUP BY dept_id
    HAVING count(p.project_id)>1
);
--3
--SELECT e1.emp_name AS enployee, e2.emp_name AS enployee_manager, e3.emp_name AS manager_of_manager
--FROM employee e1
--LEFT JOIN employee e2 ON e2.emp_id=e1.manager_id
--LEFT JOIN e2.manager_id=e3.emp_id

--4
SELECT e1.emp_name AS e1, e2.emp_name AS e2
FROM employees6 e1
JOIN employees6 e2 ON e1.dept_id=e2.dept_id
WHERE e1.emp_id<e2.emp_id