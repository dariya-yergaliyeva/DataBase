CREATE TABLE customers11 (
    customer_id BIGSERIAL PRIMARY KEY,
    iin CHAR(12) UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    phone TEXT,
    email TEXT UNIQUE,
    status TEXT NOT NULL DEFAULT 'active',
    daily_limit_kzt NUMERIC(18,2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE accounts11 (
    account_id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers11(customer_id),
    account_number TEXT NOT NULL UNIQUE,
    currency TEXT NOT NULL,
    balance NUMERIC(18,2) NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    opened_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    closed_at TIMESTAMPTZ
);

CREATE TABLE exchange_rates (
    rate_id BIGSERIAL PRIMARY KEY,
    from_currency TEXT NOT NULL,
    to_currency TEXT NOT NULL,
    rate NUMERIC(18,6) NOT NULL,
    valid_from TIMESTAMPTZ NOT NULL,
    valid_to TIMESTAMPTZ NOT NULL
);

CREATE TABLE audit_log (
    log_id BIGSERIAL PRIMARY KEY,
    table_name TEXT NOT NULL,
    record_id BIGINT,
    action TEXT NOT NULL,
    old_values JSONB,
    new_values JSONB,
    changed_by TEXT,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ip_address INET
);

CREATE TABLE transactions1 (
    transaction_id BIGSERIAL PRIMARY KEY,
    from_account_id BIGINT REFERENCES accounts11(account_id),
    to_account_id BIGINT REFERENCES accounts11(account_id),
    amount NUMERIC(18,2) NOT NULL,
    currency TEXT NOT NULL,
    exchange_rate NUMERIC(18,6) NOT NULL,
    amount_kzt NUMERIC(18,2) NOT NULL,
    type TEXT NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    description TEXT
);

INSERT INTO customers11(iin, full_name, phone, email, status, daily_limit_kzt) VALUES
('000000000001','Alice Karim','+77010000001','alice@example.com','active',2000000),
('000000000002','Bob Nurlan','+77010000002','bob@example.com','active',1500000),
('000000000003','Carol Dana','+77010000003','carol@example.com','active',3000000),
('000000000004','David Timur','+77010000004','david@example.com','blocked',500000),
('000000000005','Erik Sanzhar','+77010000005','erik@example.com','active',1000000),
('000000000006','Farida Ayan','+77010000006','farida@example.com','active',2500000),
('000000000007','Gulnaz Aidana','+77010000007','gulnaz@example.com','active',1200000),
('000000000008','Hasan Dias','+77010000008','hasan@example.com','active',1800000),
('000000000009','Irina Saltanat','+77010000009','irina@example.com','active',2200000),
('000000000010','Janel Askar','+77010000010','janel@example.com','active',1600000);

INSERT INTO accounts11(customer_id, account_number, currency, balance) VALUES
(1,'KZ0001KZT','kzt',1500000),
(1,'KZ0001USD','usd',3000),
(2,'KZ0002KZT','kzt',800000),
(3,'KZ0003KZT','kzt',2500000),
(4,'KZ0004KZT','kzt',200000),
(5,'KZ0005KZT','kzt',900000),
(6,'KZ0006KZT','kzt',1100000),
(7,'KZ0007KZT','kzt',600000),
(8,'KZ0008KZT','kzt',750000),
(9,'KZ0009KZT','kzt',500000),
(10,'KZ0010KZT','kzt',400000);

INSERT INTO exchange_rates(from_currency, to_currency, rate, valid_from, valid_to) VALUES
('usd','kzt',480.000000,NOW() - INTERVAL '10 days',NOW() + INTERVAL '20 days'),
('eur','kzt',520.000000,NOW() - INTERVAL '10 days',NOW() + INTERVAL '20 days'),
('rub','kzt',5.200000,NOW() - INTERVAL '10 days',NOW() + INTERVAL '20 days'),
('kzt','usd',1.0/480.0,NOW() - INTERVAL '10 days',NOW() + INTERVAL '20 days'),
('kzt','eur',1.0/520.0,NOW() - INTERVAL '10 days',NOW() + INTERVAL '20 days'),
('kzt','rub',1.0/5.2,NOW() - INTERVAL '10 days',NOW() + INTERVAL '20 days'),
('usd','eur',0.920000,NOW() - INTERVAL '10 days',NOW() + INTERVAL '20 days'),
('eur','usd',1.090000,NOW() - INTERVAL '10 days',NOW() + INTERVAL '20 days'),
('usd','rub',92.000000,NOW() - INTERVAL '10 days',NOW() + INTERVAL '20 days'),
('rub','usd',0.010870,NOW() - INTERVAL '10 days',NOW() + INTERVAL '20 days');

INSERT INTO audit_log(table_name, record_id, action, old_values, new_values, changed_by, ip_address) VALUES
('customers',1,'insert',NULL,'{}','system','127.0.0.1'),
('customers',2,'insert',NULL,'{}','system','127.0.0.1'),
('customers',3,'insert',NULL,'{}','system','127.0.0.1'),
('customers',4,'insert',NULL,'{}','system','127.0.0.1'),
('customers',5,'insert',NULL,'{}','system','127.0.0.1'),
('customers',6,'insert',NULL,'{}','system','127.0.0.1'),
('customers',7,'insert',NULL,'{}','system','127.0.0.1'),
('customers',8,'insert',NULL,'{}','system','127.0.0.1'),
('customers',9,'insert',NULL,'{}','system','127.0.0.1'),
('customers',10,'insert',NULL,'{}','system','127.0.0.1');

INSERT INTO transactions1(from_account_id,to_account_id,amount,currency,exchange_rate,amount_kzt,type,status,created_at,completed_at,description) VALUES
(1,3,100000,'kzt',1,100000,'transfer','completed',NOW() - INTERVAL '2 days',NOW() - INTERVAL '2 days','test'),
(3,2,200000,'kzt',1,200000,'transfer','completed',NOW() - INTERVAL '1 day',NOW() - INTERVAL '1 day','test'),
(2,1,50000,'kzt',1,50000,'transfer','completed',NOW() - INTERVAL '1 day',NOW() - INTERVAL '1 day','test'),
(1,5,30000,'kzt',1,30000,'transfer','completed',NOW() - INTERVAL '3 hours',NOW() - INTERVAL '3 hours','test'),
(5,6,40000,'kzt',1,40000,'transfer','completed',NOW() - INTERVAL '2 hours',NOW() - INTERVAL '2 hours','test'),
(6,7,25000,'kzt',1,25000,'transfer','completed',NOW() - INTERVAL '90 minutes',NOW() - INTERVAL '90 minutes','test'),
(7,8,20000,'kzt',1,20000,'transfer','completed',NOW() - INTERVAL '70 minutes',NOW() - INTERVAL '70 minutes','test'),
(8,9,15000,'kzt',1,15000,'transfer','completed',NOW() - INTERVAL '40 minutes',NOW() - INTERVAL '40 minutes','test'),
(9,10,10000,'kzt',1,10000,'transfer','completed',NOW() - INTERVAL '10 minutes',NOW() - INTERVAL '10 minutes','test'),
(1,2,6000000,'kzt',1,6000000,'transfer','completed',NOW() - INTERVAL '5 minutes',NOW() - INTERVAL '5 minutes','large transfer');
--task1---------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE  process_transfer(
    p_from_account_number TEXT,
    p_to_account_number TEXT,
    p_amount NUMERIC,
    p_currency TEXT,
    p_description TEXT
)
LANGUAGE plpgsql
AS $$
    DECLARE
        v_from_account_id BIGINT;
        v_to_account_id BIGINT;
        v_from_customer_id BIGINT;
        v_to_customer_id BIGINT;
        v_from_balance NUMERIC;
        v_to_balance NUMERIC;
        v_from_status TEXT;
        v_to_status TEXT;
        v_from_is_active BOOLEAN;
        v_to_is_active BOOLEAN;
        v_daily_limit_kzt NUMERIC;
        v_today_total_kzt NUMERIC;
        v_rate NUMERIC;
        v_amount_kzt NUMERIC;
        v_now TIMESTAMPTZ := NOW();
        v_tx_id BIGINT;
BEGIN
        SELECT a.account_id, a.customer_id, a.balance, a.is_active, c.status, c.daily_limit_kzt
        INTO v_from_account_id, v_from_customer_id, v_from_balance, v_from_is_active, v_from_status, v_daily_limit_kzt
        FROM accounts11 a
        JOIN customers11 c ON c.customer_id=a.customer_id
        WHERE a.account_number=p_from_account_number
        FOR UPDATE;
        IF NOT FOUND OR NOT v_from_is_active OR v_from_status <> 'active' THEN
            RAISE EXCEPTION 'invalid_or_inactive_from_account';
        end if;
        SELECT a.account_id, a.customer_id, a.balance, a.is_active, c.status
        INTO v_to_account_id, v_to_customer_id, v_to_balance, v_to_is_active, v_to_status
        FROM accounts11 a
        JOIN customers11 c ON c.customer_id = a.customer_id
        WHERE a.account_number = p_to_account_number
        FOR UPDATE;
        IF NOT FOUND OR NOT v_to_is_active OR v_to_status <> 'active' THEN
            RAISE EXCEPTION 'invalid_or_inactive_to_account';
        END IF;
        IF p_currency='kzt' THEN
            v_rate := 1;
            v_amount_kzt := p_amount;
        ELSE
            SELECT rate
            INTO v_rate
            FROM exchange_rates
            WHERE from_currency = p_currency
              AND to_currency = 'kzt'
              AND v_now BETWEEN valid_from AND valid_to
            LIMIT 1;
            IF v_rate IS NULL THEN
                RAISE EXCEPTION 'exchange_rate_not_found';
            end if;
            v_amount_kzt := p_amount * v_rate;
        end if;
        IF v_from_balance < v_amount_kzt THEN
            RAISE EXCEPTION 'insufficient_funds';
        END IF;
        SELECT COALESCE(SUM(amount_kzt),0)
        INTO v_today_total_kzt
        FROM transactions1
        WHERE from_account_id = v_from_account_id
          AND created_at::DATE = CURRENT_DATE
          AND status IN ('pending','completed');

        IF v_today_total_kzt + v_amount_kzt > v_daily_limit_kzt THEN
            RAISE EXCEPTION 'daily_limit_exceeded';
        END IF;
        PERFORM pg_advisory_xact_lock(v_from_account_id);
        PERFORM pg_advisory_xact_lock(v_to_account_id);
        UPDATE accounts11
        SET balance=balance-v_amount_kzt
        WHERE account_id=v_from_account_id;
        INSERT INTO transactions1(from_account_id,to_account_id,amount,currency,exchange_rate,amount_kzt,type,status,created_at,description)
        VALUES(v_from_account_id,v_to_account_id,p_amount,p_currency,v_rate,v_amount_kzt,'transfer','completed',v_now,p_description)
        RETURNING transaction_id INTO v_tx_id;
        UPDATE accounts11
        SET balance = balance + v_amount_kzt
        WHERE account_id = v_to_account_id;
        INSERT INTO audit_log(table_name,record_id,action,old_values,new_values,changed_by,ip_address)
        VALUES('transactions',v_tx_id,'insert',NULL,NULL,CURRENT_USER,'127.0.0.1');
    end;
$$;
--task2----------------------------------------------------------------------------------------------
--1
CREATE OR REPLACE VIEW customer_balance_summary AS
    SELECT
        c.customer_id,
        c.full_name,
        a.account_id,
        a.account_number,
        a.currency,
        a.balance,
        CASE
            WHEN a.currency = 'kzt' THEN  a.balance
            ELSE a.balance * (
                SELECT rate FROM exchange_rates r
                            WHERE r.from_currency=a.currency AND r.to_currency='kzt' AND NOW() BETWEEN r.valid_from AND r.valid_to
                            LIMIT 1
                )
        END AS balance_kzt,
        c.daily_limit_kzt,
        COALESCE(
        (SELECT  SUM(t.amount_kzt)
         FROM transactions1 t
         WHERE t.from_account_id = a.account_id AND t.created_at::DATE = CURRENT_DATE),
        0
        ) AS used_today_kzt,
        RANK() OVER (ORDER BY balance DESC ) AS customer_rank
FROM customers11 c
JOIN accounts11 a on c.customer_id = a.customer_id;
--2
CREATE OR REPLACE VIEW daily_transaction_report AS
    WITH base AS (
        SELECT
            DATE(t.created_at) AS  tx_date,
            t.type,
            t.amount_kzt
        FROM transactions1 t
    )
SELECT
    tx_date,
    type,
    COUNT(*) AS tx_count,
    SUM(amount_kzt) AS total_amount_kzt,
    AVG(amount_kzt) AS avg_amount_kzt,
    SUM(SUM(amount_kzt)) OVER (ORDER BY tx_date) AS running_total_kzt
FROM base
GROUP BY tx_date, type
ORDER BY tx_date;
--3
CREATE OR REPLACE VIEW suspicious_activity_view
WITH (security_barrier=TRUE)
AS
    SELECT
        t.*,
        (amount_kzt>5000000) AS is_large,
        (created_at - LAG(created_at) OVER (PARTITION BY from_account_id ORDER BY created_at)
            < INTERVAL '1 minute') AS is_fast_repeat
FROM transactions1 t;
--3-----------------------------------------------------------------------------------------
CREATE INDEX idx_accounts_customer ON accounts11(customer_id);
CREATE INDEX idx_transaction_time ON transactions1(created_at, type);
CREATE INDEX idx_transaction_amount ON transactions1(amount_kzt);
CREATE INDEX idx_active_accounts ON accounts11(account_number) WHERE is_active;
CREATE INDEX idx_customer_email_lower ON customers11((LOWER(email)));
CREATE INDEX idx_audit_log_gin ON audit_log USING GIN(old_values, new_values);
--4----------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE process_salary_batch(
    p_company_account_number TEXT,
    p_payments JSONB,
    OUT successful_count INT,
    OUT failed_count INT,
    OUT failed_details JSONB
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_company_account_id BIGINT;
    v_company_balance NUMERIC;
    v_elem JSONB;
    v_iin TEXT;
    v_amount NUMERIC;
BEGIN
    successful_count := 0;
    failed_count := 0;
    failed_details := '[]'::JSONB;

    SELECT account_id, balance
    INTO v_company_account_id, v_company_balance
    FROM accounts11
    WHERE account_number = p_company_account_number
    FOR UPDATE;

    PERFORM pg_advisory_lock(v_company_account_id);

    FOR v_elem IN SELECT * FROM jsonb_array_elements(p_payments)
    LOOP
        BEGIN
            v_iin := v_elem->>'iin';
            v_amount := (v_elem->>'amount')::NUMERIC;

            IF v_company_balance < v_amount THEN
                RAISE EXCEPTION 'not_enough_funds_for_%', v_iin;
            END IF;

            v_company_balance := v_company_balance - v_amount;

            UPDATE accounts11
            SET balance = balance - v_amount
            WHERE account_id = v_company_account_id;

            INSERT INTO transactions1(from_account_id,amount,currency,exchange_rate,amount_kzt,type,status,created_at)
            VALUES(v_company_account_id,v_amount,'kzt',1,v_amount,'salary','completed',NOW());

            successful_count := successful_count + 1;

        EXCEPTION
            WHEN OTHERS THEN
                failed_count := failed_count + 1;
                failed_details := failed_details || JSONB_BUILD_OBJECT(
                    'iin', v_iin,
                    'amount', v_amount,
                    'error', SQLERRM
                );
        end;
    end loop;
    UPDATE accounts11
    SET balance = v_company_balance
    WHERE account_id = v_company_account_id;
    PERFORM pg_advisory_unlock(v_company_account_id);
end;
$$;
CREATE MATERIALIZED VIEW salary_report AS
    SELECT
        DATE_TRUNC('month', created_at) AS month,
        COUNT(*) AS total_payments,
        SUM(amount_kzt) AS total_salary_paid
FROM transactions1
WHERE type='salary'
GROUP BY DATE_TRUNC('month', created_at);
