CREATE TABLE accounts8 (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    balance DECIMAL(10, 2) DEFAULT 0.00
 );
 CREATE TABLE products8 (
    id SERIAL PRIMARY KEY,
    shop VARCHAR(100) NOT NULL,
    product VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
 );-- Insert test data
 INSERT INTO accounts8 (name, balance) VALUES
    ('Alice', 1000.00),
    ('Bob', 500.00),
    ('Wally', 750.00);
 INSERT INTO products8 (shop, product, price) VALUES
    ('Joe''s Shop', 'Coke', 2.50),
    ('Joe''s Shop', 'Pepsi', 3.00);
--task1
--3.2
 BEGIN;
 UPDATE accounts8 SET balance = balance - 100.00
    WHERE name = 'Alice';
 UPDATE accounts8 SET balance = balance + 100.00
    WHERE name = 'Bob';
 COMMIT;
--1)Alice 900, Bob 600
--2)To ensure atomicity, either both UPDATEs are executed or neither. without grouping, there is a situation like Alice loses 100, but Bob doesn't receive 100 (a failure between commands).
--3)Only the first UPDATE will execute →Alice will lose money, Bob will receive nothing → the data will be corrupted.

--task2
--3.3
 BEGIN;
 UPDATE accounts8 SET balance = balance - 500.00
    WHERE name = 'Alice';
 SELECT * FROM accounts8 WHERE name = 'Alice';-- Oops! Wrong amount, let's undo
 ROLLBACK;
 SELECT * FROM accounts8 WHERE name = 'Alice';
--a) balance is 400
--b) it is 900 again
--c)calculation error, invalid UPDATE or DELETE, not enough money/products, checks failed, user canceled the action

--task3
--3.4
BEGIN;
 UPDATE accounts8 SET balance = balance - 100.00
    WHERE name = 'Alice';
 SAVEPOINT my_savepoint;
UPDATE accounts8 SET balance = balance + 100.00
    WHERE name = 'Bob';-- Oops, should transfer to Wally instead
 ROLLBACK TO my_savepoint;
 UPDATE accounts8 SET balance = balance + 100.00
    WHERE name = 'Wally';
 COMMIT;
SELECT * FROM accounts8;
--a)alice 800, bob 600, wally 850
--b)yes, temporarily. But after ROLLBACK TO savepoint, his loan was cancelled.
--c)SAVEPOINT allows you to roll back part of an operation without canceling the entire transaction

--task4
--3.5
 BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
 SELECT * FROM products8 WHERE shop = 'Joe''s Shop';
BEGIN;
 DELETE FROM products8 WHERE shop = 'Joe''s Shop';
 INSERT INTO products8 (shop, product, price)
    VALUES ('Joe''s Shop', 'Fanta', 3.50);
 COMMIT;
 SELECT * FROM products8 WHERE shop = 'Joe''s Shop';
 COMMIT;

 BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
 SELECT * FROM products8 WHERE shop = 'Joe''s Shop';
BEGIN;
 DELETE FROM products8 WHERE shop = 'Joe''s Shop';
 INSERT INTO products8 (shop, product, price)
    VALUES ('Joe''s Shop', 'Fanta', 3.50);
 COMMIT;
 SELECT * FROM products8 WHERE shop = 'Joe''s Shop';
 COMMIT;

--a)before commit → old data, after commit → new data→ With READ COMMITTED, each SELECT reads only the last committed result.
--b)terminal 1 won't see any changes from Terminal 2 until it completes its own transaction. It always sees the same data.
--c) READ COMMITTED Only sees committed data, but may see different data on re-read.  SERIALIZABLE Highest isolation. Transactions appear to execute serially.

--task5
--task3.6
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
 SELECT MAX(price), MIN(price) FROM products8
    WHERE shop = 'Joe''s Shop';-- Wait for Terminal 2
 BEGIN;
 INSERT INTO products8 (shop, product, price)
    VALUES ('Joe''s Shop', 'Sprite', 4.00);
 COMMIT;
 SELECT MAX(price), MIN(price) FROM products8
    WHERE shop = 'Joe''s Shop';
 COMMIT;
--a)No
--b)When a range includes new rows, the same SELECT statement returns a different set of rows.
--c)SERIALIZABLE

--task6
--3.7
 BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 SELECT * FROM products8 WHERE shop = 'Joe''s Shop';
 BEGIN;
 UPDATE products8 SET price = 99.99
    WHERE product = 'Fanta';
SELECT * FROM products8 WHERE shop = 'Joe''s Shop';
ROLLBACK;
SELECT * FROM products8 WHERE shop = 'Joe''s Shop';
 COMMIT;
--a)In PostgreSQL - no, because PostgreSQL does NOT support dirty reads.
--b)reading uncommitted data that can later be rolled back.
--c)because it can:read false data, make decisions based on data that will later disappear, compromise the integrity of the system

--EX4
--1
SELECT balance FROM accounts8 WHERE name='Bob';
BEGIN;
UPDATE accounts8 SET balance=balance-200 WHERE name='Bob';
UPDATE accounts8 SET balance=balance+200 WHERE name='Wally';
COMMIT;
ROLLBACK;
--2

BEGIN;
INSERT INTO products8 (shop, product, price) VALUES ('Joe''s Shop', 'FeuseTea', 1.50);
SAVEPOINT s1;
UPDATE products8 SET price=3.75 WHERE product='Fanta';
SAVEPOINT s2;
DELETE FROM products8 WHERE product='FeuseTea';
ROLLBACK TO s1;
COMMIT;
SELECT * FROM products8;

--3
BEGIN;
SELECT balance FROM accounts8 WHERE name='Alice';
UPDATE accounts8 SET balance = balance - 200 WHERE name='Alice';
BEGIN;
SELECT balance FROM accounts8 WHERE name='Alice';
UPDATE accounts8 SET balance = balance - 200 WHERE name='Alice';
COMMIT;
COMMIT;

--4
BEGIN;
UPDATE products8 SET price = 5 WHERE product='Cola';
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT MAX(price), MIN(price) FROM products8;
ROLLBACK;
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT MAX(price), MIN(price) FROM products8;
COMMIT;

--5  Questions for Self-Assessment
--1) Atomic-All operations succeed or all fail.Subtract 100 from Alice Add 100 to Bob If one step fails → both are undone
--Consisten-Database constraints are preserved. The database moves from one valid state to another. If a withdrawal would make balance negative → transaction fails and the constraint is preserved.
--  Isolated-It appears to the user as if only one process executes at a time.Two users buy the last ticket: isolation ensures only one gets it.
-- Durable-Effects of a process do not get lost if the system crashes. If a transfer is committed, a power outage will not revert the balances.
--2)COMMIT- permanently saves all changes made during the transaction. ROLLBACK - undoes all changes made in the current transaction and returns to the previous stable state.
--3)use SAVEPOINT when you want to undo part of a transaction, not the entire thing.
--4) SERIALIZABLE - Transactions appear to execute serially.
--REPEATABLE READ- Only sees committed data, but may see different data on re-read.
--READ COMMITTED-Data read is guaranteed to be the same if read again.
--SERIALIZABLE-Can see uncommitted changes from other transactions.
--5)Dirty read-Reading uncommitted changes made by another transaction.
--READ UNCOMMITTED
--6)Non-repeatable read happens when a row changes between two reads in the same transaction
--T1: SELECT price FROM products WHERE product='Cola'; → 5.00
--T2 updates price to 6.00 and commits
--T1 reads again → 6.00
--7) Phantom read happens when new rows appear that match a previous query condition.
--SERIALIZABLE (standard SQL)
--REPEATABLE READ
--8)Because it is faster, lighter, less locking, and supports high concurrency. SERIALIZABLE is safe but much slower.
--9)They ensure operations are atomic, isolated, and follow rules, preventing race conditions and corruption.
--10)They are lost.Database automatically rolls back incomplete transactions.