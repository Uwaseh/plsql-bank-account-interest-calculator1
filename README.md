# plsql-bank-account-interest-calculator1
A PL/SQL project that simulates a Bank Account Interest Calculator using Collections, Records, and GOTO statements. Demonstrates associative arrays, VARRAYs, nested tables, and record types to calculate and display monthly and total interests for multiple bank accounts.
# Bank Account Interest Calculator

## Overview
This PL/SQL application demonstrates advanced database programming concepts by calculating monthly interest for bank accounts over a 6-month period. It showcases the use of collections, records, cursors, and control structures in Oracle PL/SQL.

## Features
- **Interest Calculation**: Computes monthly interest for valid bank accounts over 6 months
- **Data Validation**: Automatically skips accounts with invalid balances (NULL or ≤ 0)
- **Detailed Reporting**: Displays monthly breakdown and total interest earned
- **Error Handling**: Robust exception handling for database operations

## Database Schema

```sql
CREATE TABLE bank_accounts (
  account_no NUMBER PRIMARY KEY,
  customer_name VARCHAR2(100),
  balance NUMBER
);
```

### Sample Data
The application includes 5 sample accounts:
- **Alice Kamanzi** (101): 500,000 RWF
- **Bob Uwizeyimana** (102): -20,000 RWF *(Invalid - negative balance)*
- **Diane Nkurunziza** (103): 800,000 RWF
- **Eric Maniraguha** (104): 0 RWF *(Invalid - zero balance)*
- **Clare Uwimana** (105): 300,000 RWF

## Technical Implementation

### PL/SQL Concepts Demonstrated

#### 1. **Associative Array**
```sql
TYPE t_balance_tab IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
```
Stores account balances indexed by account number for efficient lookup.

#### 2. **VARRAY (Variable-Size Array)**
```sql
TYPE t_interest_rates IS VARRAY(6) OF NUMBER;
v_interest_rates t_interest_rates := t_interest_rates(0.5, 0.6, 0.55, 0.7, 0.65, 0.6);
```
Fixed-size array storing monthly interest rates (as percentages).

#### 3. **Nested Table**
```sql
TYPE t_interest_amounts IS TABLE OF NUMBER;
```
Dynamic collection storing calculated interest amounts for each month.

#### 4. **Record Type**
```sql
TYPE r_account IS RECORD (
  account_no bank_accounts.account_no%TYPE,
  customer_name bank_accounts.customer_name%TYPE,
  balance bank_accounts.balance%TYPE
);
```
Custom data structure holding account information using `%TYPE` anchoring.

#### 5. **Explicit Cursor**
```sql
CURSOR c_accounts IS SELECT * FROM bank_accounts ORDER BY account_no;
```
Retrieves and processes account data sequentially.

#### 6. **GOTO Statement**
```sql
GOTO skip_account;
<<skip_account>>
```
Demonstrates unconventional control flow for skipping invalid accounts.

## Interest Rate Schedule
Monthly interest rates applied over 6 months:
- **Month 1**: 0.5%
- **Month 2**: 0.6%
- **Month 3**: 0.55%
- **Month 4**: 0.7%
- **Month 5**: 0.65%
- **Month 6**: 0.6%

## Installation & Execution

### Prerequisites
- Oracle Database (11g or higher)
- SQL*Plus or any Oracle client tool
- Appropriate database privileges (CREATE TABLE, INSERT, SELECT)

### Steps to Run

1. **Create the table and insert sample data:**
```sql
CREATE TABLE bank_accounts (
  account_no NUMBER PRIMARY KEY,
  customer_name VARCHAR2(100),
  balance NUMBER
);

INSERT INTO bank_accounts VALUES (101, 'Alice Kamanzi', 500000);
INSERT INTO bank_accounts VALUES (102, 'Bob Uwizeyimana', -20000);
INSERT INTO bank_accounts VALUES (103, 'Diane Nkurunziza', 800000);
INSERT INTO bank_accounts VALUES (104, 'Eric Maniraguha', 0);
INSERT INTO bank_accounts VALUES (105, 'Clare Uwimana', 300000);
COMMIT;
```

2. **Enable server output:**
```sql
SET SERVEROUTPUT ON SIZE 1000000
```

3. **Execute the PL/SQL block** (copy and run the entire DECLARE...END; block)

## Sample Output

```
=== BANK ACCOUNT INTEREST CALCULATOR ===

Account: 101 - Alice Kamanzi
Balance: 500000
Monthly interest amounts:
  Month 1: 2500
  Month 2: 3000
  Month 3: 2750
  Month 4: 3500
  Month 5: 3250
  Month 6: 3000
Total interest for 6 months: 18000

Skipping invalid account: 102 (Bob Uwizeyimana)

Account: 103 - Diane Nkurunziza
Balance: 800000
Monthly interest amounts:
  Month 1: 4000
  Month 2: 4800
  Month 3: 4400
  Month 4: 5600
  Month 5: 5200
  Month 6: 4800
Total interest for 6 months: 28800

Skipping invalid account: 104 (Eric Maniraguha)

Account: 105 - Clare Uwimana
Balance: 300000
Monthly interest amounts:
  Month 1: 1500
  Month 2: 1800
  Month 3: 1650
  Month 4: 2100
  Month 5: 1950
  Month 6: 1800
Total interest for 6 months: 10800
```

## Calculation Formula

```
Monthly Interest = Balance × (Interest Rate / 100)
Total Interest = Sum of all monthly interests
```

**Example for Alice Kamanzi (500,000 RWF):**
- Month 1: 500,000 × 0.5 / 100 = 2,500
- Month 2: 500,000 × 0.6 / 100 = 3,000
- Total: 18,000 RWF

## Key Learning Points

1. **Collections Management**: Demonstrates three types of PL/SQL collections with different use cases
2. **Cursor Processing**: Efficient row-by-row data processing with explicit cursors
3. **Type Anchoring**: Using `%TYPE` ensures data type consistency with database columns
4. **Data Validation**: Business logic to skip invalid records
5. **Dynamic Arrays**: Using `EXTEND` and `DELETE` methods for nested table manipulation
6. **Control Flow**: Practical use of GOTO for exception scenarios

## Notes

- Interest calculations are simplified for demonstration purposes
- In production systems, GOTO statements are generally discouraged in favor of structured programming
- The `SET SERVEROUTPUT ON SIZE 1000000` command ensures sufficient buffer for output display
- All monetary values are assumed to be in Rwandan Francs (RWF)

## Author
Bank Account Interest Calculator - PL/SQL Demonstration Project

## License
Educational/Demonstration purposes
