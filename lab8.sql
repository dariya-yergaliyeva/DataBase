--part2
--2.1
CREATE INDEX emp_salary_idx ON employees6(salary);
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'employees6';

--2.2
CREATE INDEX emp_dept_idx ON employees6(dept_id);
SELECT * FROM employees6 WHERE dept_id = 101;

--2.3
SELECT
    tablename,
    indexname,
    indexdef
 FROM pg_indexes
 WHERE schemaname = 'public'
 ORDER BY tablename, indexname;

--part3
--3.1
CREATE INDEX emp_dept_salary_idx ON employees6(dept_id, salary);
SELECT emp_name, salary
FROM employees6
WHERE dept_id = 101 AND salary > 52000;
--Useless, because:The index is sorted not simply by salary,but by (dept_id, salary).PostgreSQL cannot make a “quick jump” to salary > 52000 without using dept_id, because all salary values are mixed together across departments.
 --3.2
CREATE INDEX emp_salary_dept_idx ON employees6(salary, dept_id);
SELECT * FROM employees6 WHERE dept_id = 102 AND salary > 50000;
SELECT * FROM employees6 WHERE salary > 50000 AND dept_id = 102;
--there is no difference

--part4
ALTER TABLE employees6 ADD COLUMN email VARCHAR(100);
 UPDATE employees6 SET email = 'john.smith@company.com' WHERE emp_id = 1;
 UPDATE employees6 SET email = 'jane.doe@company.com' WHERE emp_id = 2;
 UPDATE employees6 SET email = 'mike.johnson@company.com' WHERE emp_id = 3;
 UPDATE employees6 SET email = 'sarah.williams@company.com' WHERE emp_id = 4;
 UPDATE employees6 SET email = 'tom.brown@company.com' WHERE emp_id = 5;

CREATE UNIQUE INDEX emp_email_idx ON employees6(email);

INSERT INTO employees6 (emp_id, emp_name, dept_id, salary, email)
VALUES (6, 'New Employee', 101, 55000, 'john.smith@company.com');
--violates uniqueness of email

--4.2
 ALTER TABLE employees ADD COLUMN phone VARCHAR(20) UNIQUE;
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'employees' AND indexname LIKE '%phone%';
--yes, index created automatically

--part5
--5.1
CREATE INDEX emp_salary_desc_idx ON employees6(salary DESC );

SELECT emp_name, salary
FROM employees6
ORDER BY salary DESC;
--This descending index helps the ORDER BY query because the rows are already stored in DESC order. PostgreSQL can return the data directly from the index without performing an expensive sort.

--5.2
CREATE INDEX proj_budget_nulls_first_idx ON projects6(budget NULLS FIRST);
SELECT project_name, budget
FROM projects6
ORDER BY budget NULLS FIRST;

--part6
--6.1
CREATE INDEX emp_name_lower_idx ON employees6(LOWER(emp_name));
SELECT * FROM employees6 WHERE LOWER(emp_name) = 'john smith';
--Without the LOWER(emp_name) expression index, PostgreSQL must scan the entire table and compute LOWER(emp_name) for every row to do a case-insensitive search.
--6.2
ALTER TABLE employees6 ADD COLUMN hire_date DATE;
UPDATE employees6 SET hire_date = '2020-01-15' WHERE emp_id = 1;
UPDATE employees6 SET hire_date = '2019-06-20' WHERE emp_id = 2;
UPDATE employees6 SET hire_date = '2021-03-10' WHERE emp_id = 3;
UPDATE employees6 SET hire_date = '2020-11-05' WHERE emp_id = 4;
UPDATE employees6 SET hire_date = '2018-08-25' WHERE emp_id = 5;

CREATE INDEX emp_hire_year_idx ON employees6(EXTRACT(YEAR FROM hire_date));
SELECT emp_name, hire_date
FROM employees6
WHERE EXTRACT(YEAR FROM hire_date)=2020;

--part7
--7.1
ALTER INDEX emp_salary_idx RENAME TO employees_salary_index;

--7.2
DROP INDEX emp_salary_dept_idx;
--7.3
REINDEX INDEX employees_salary_index;
--part8
--8.1
SELECT e.emp_name, e.salary, d.dept_name
FROM employees6 e
JOIN departments6 d ON e.dept_id=d.dept_id
WHERE e.salary>50000
ORDER BY e.salary DESC;

CREATE INDEX emp_salary_filter_idx ON employees6(salary) WHERE salary>50000;
--8.2
CREATE INDEX proj_high_budget_idx ON projects6(budget) WHERE budget>80000;

SELECT project_name, budget
FROM projects6
WHERE budget>80000;
--8.3
EXPLAIN SELECT * FROM employees6 WHERE salary>52000;
--seq scan. all table, it means that to run for all table is faster than with index, or table is too small, so that it is easier to use all table or to many match

--part9
--9.1
CREATE INDEX dept_name_hash_idx ON departments6 USING HASH (dept_name);
SELECT * FROM departments6 WHERE dept_name='IT';
--When looking up one exact value millions of times per second and you don’t care about sorting or ranges.

--9.2
CREATE INDEX proj_btree_idx ON projects6(project_name);
CREATE INDEX proj_hash_idx ON projects6 USING HASH (project_name);

SELECT * FROM projects6 WHERE project_name = 'Website Redesign';
SELECT * FROM projects WHERE project_name > 'Database';

--part10
--10.1
SELECT
    schemaname,
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexname::regclass)) as index_size
FROM pg_indexes
WHERE schemaname='public'
ORDER BY tablename, indexname;
--The largest index is proj_hash_idx and dept_name_hash_idx table projects6 and departments6.
--It is the largest because the underlying table has many rows and the index contains wide (or multiple) columns, and possibly some bloat due to frequent updates/deletes.

--10.2
DROP INDEX IF EXISTS proj_hash_idx;

--10.3
CREATE VIEW index_documents AS
    SELECT
        tablename,
        indexname,
        indexdef,
        'Improves salary-based queries' AS purpose
FROM pg_indexes
WHERE schemaname='public' AND indexname LIKE '%salary%';

SELECT * FROM index_documents;