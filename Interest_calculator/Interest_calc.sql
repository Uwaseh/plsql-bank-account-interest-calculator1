CREATE TABLE bank_accounts (
  account_no NUMBER PRIMARY KEY,
  customer_name VARCHAR2(100),
  balance NUMBER
);

INSERT INTO bank_accounts VALUES (101, 'Alice Kamanzi', 500000);
INSERT INTO bank_accounts VALUES (102, 'Bob Uwizeyimana', -20000);  -- Invalid (for GOTO demo)
INSERT INTO bank_accounts VALUES (103, 'Diane Nkurunziza', 800000);
INSERT INTO bank_accounts VALUES (104, 'Eric Maniraguha', 0);        -- Invalid (for GOTO demo)
INSERT INTO bank_accounts VALUES (105, 'Clare Uwimana', 300000);
COMMIT;

SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  -- Associative array to store balances by account number
  TYPE t_balance_tab IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
  v_balance_tab t_balance_tab;

  -- VARRAY for interest rates (6 months)
  TYPE t_interest_rates IS VARRAY(6) OF NUMBER;
  v_interest_rates t_interest_rates := t_interest_rates(0.5, 0.6, 0.55, 0.7, 0.65, 0.6);

  -- Nested table for computed monthly interests
  TYPE t_interest_amounts IS TABLE OF NUMBER;
  v_interest_amounts t_interest_amounts := t_interest_amounts();

  -- Record for account details
  TYPE r_account IS RECORD (
    account_no bank_accounts.account_no%TYPE,
    customer_name bank_accounts.customer_name%TYPE,
    balance bank_accounts.balance%TYPE
  );
  v_account r_account;

  CURSOR c_accounts IS SELECT * FROM bank_accounts ORDER BY account_no;

  v_monthly_interest NUMBER;
  v_total_interest NUMBER;

BEGIN
  DBMS_OUTPUT.PUT_LINE('=== BANK ACCOUNT INTEREST CALCULATOR ===');

  OPEN c_accounts;
  LOOP
    FETCH c_accounts INTO v_account;
    EXIT WHEN c_accounts%NOTFOUND;

    -- Validate balance; if invalid, skip using GOTO
    IF v_account.balance IS NULL OR v_account.balance <= 0 THEN
      DBMS_OUTPUT.PUT_LINE('Skipping invalid account: ' || v_account.account_no || ' (' || v_account.customer_name || ')');
      GOTO skip_account;
    END IF;

    -- Store in associative array
    v_balance_tab(v_account.account_no) := v_account.balance;

    -- Reset nested table for new account
    v_interest_amounts.DELETE;
    v_total_interest := 0;

    -- Calculate interest for each month
    FOR i IN 1 .. v_interest_rates.COUNT LOOP
      v_monthly_interest := v_balance_tab(v_account.account_no) * v_interest_rates(i) / 100;
      v_interest_amounts.EXTEND;
      v_interest_amounts(i) := v_monthly_interest;
      v_total_interest := v_total_interest + v_monthly_interest;
    END LOOP;

    -- Display results
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Account: ' || v_account.account_no || ' - ' || v_account.customer_name);
    DBMS_OUTPUT.PUT_LINE('Balance: ' || v_account.balance);
    DBMS_OUTPUT.PUT_LINE('Monthly interest amounts:');
    FOR i IN 1 .. v_interest_amounts.COUNT LOOP
      DBMS_OUTPUT.PUT_LINE('  Month ' || i || ': ' || ROUND(v_interest_amounts(i),2));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total interest for 6 months: ' || ROUND(v_total_interest,2));

    <<skip_account>>
    NULL; -- Label for GOTO target
  END LOOP;

  CLOSE c_accounts;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

