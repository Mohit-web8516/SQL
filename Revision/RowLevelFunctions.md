# SQL Row-Level Functions

## Introduction

Row-Level Functions (also called Single Row Functions) operate on **one row at a time** and return **one result for each row**.

For example:

```sql
SELECT UPPER('mohit');
```

Output:

```
MOHIT
```

If a table contains 10 rows, the function is applied to each row individually and returns 10 outputs.

---

# Types of Row-Level Functions

1. Character Functions
2. Number Functions
3. Date Functions
4. Conversion Functions
5. General Functions

---

# Sample Table: Employees

| emp_id | emp_name | salary | department | joining_date |
| ------ | -------- | -----: | ---------- | ------------ |
| 1      | Mohit    |  50000 | IT         | 2023-01-10   |
| 2      | Aman     |  45000 | HR         | 2022-08-15   |
| 3      | Ravi     |  60000 | Sales      | 2021-05-20   |

---

# 1. Character Functions

Character functions work with strings.

---

## UPPER()

Converts text into uppercase.

### Syntax

```sql
UPPER(column_name)
```

### Example

```sql
SELECT UPPER(emp_name)
FROM Employees;
```

Output

```
MOHIT
AMAN
RAVI
```

---

## LOWER()

Converts text into lowercase.

```sql
SELECT LOWER(emp_name)
FROM Employees;
```

Output

```
mohit
aman
ravi
```

---

## LENGTH()

Returns the number of characters.

```sql
SELECT emp_name,
       LENGTH(emp_name)
FROM Employees;
```

Output

| emp_name | LENGTH |
| -------- | ------ |
| Mohit    | 5      |
| Aman     | 4      |
| Ravi     | 4      |

---

## CONCAT()

Combines two or more strings.

```sql
SELECT CONCAT(emp_name,' works in ',department)
FROM Employees;
```

Output

```
Mohit works in IT
Aman works in HR
Ravi works in Sales
```

---

## SUBSTRING()

Extracts part of a string.

```sql
SELECT SUBSTRING(emp_name,1,3)
FROM Employees;
```

Output

```
Moh
Ama
Rav
```

---

## TRIM()

Removes spaces from both ends.

```sql
SELECT TRIM('   Mohit   ');
```

Output

```
Mohit
```

---

## REPLACE()

Replaces one string with another.

```sql
SELECT REPLACE('Mohit Kumar','Kumar','Shrivastav');
```

Output

```
Mohit Shrivastav
```

---

# 2. Number Functions

---

## ROUND()

Rounds a number.

```sql
SELECT ROUND(123.567,2);
```

Output

```
123.57
```

---

## CEIL()

Returns smallest integer greater than or equal to a number.

```sql
SELECT CEIL(12.2);
```

Output

```
13
```

---

## FLOOR()

Returns largest integer smaller than or equal to a number.

```sql
SELECT FLOOR(12.9);
```

Output

```
12
```

---

## ABS()

Returns absolute value.

```sql
SELECT ABS(-500);
```

Output

```
500
```

---

## MOD()

Returns remainder.

```sql
SELECT MOD(17,5);
```

Output

```
2
```

---

## POWER()

Raises a number to a power.

```sql
SELECT POWER(2,4);
```

Output

```
16
```

---

# 3. Date Functions

---

## CURDATE()

Returns current date.

```sql
SELECT CURDATE();
```

Example Output

```
2026-06-22
```

---

## NOW()

Returns current date and time.

```sql
SELECT NOW();
```

---

## YEAR()

Extracts year from date.

```sql
SELECT YEAR(joining_date)
FROM Employees;
```

Output

```
2023
2022
2021
```

---

## MONTH()

Extracts month.

```sql
SELECT MONTH(joining_date)
FROM Employees;
```

Output

```
1
8
5
```

---

## DAY()

Extracts day.

```sql
SELECT DAY(joining_date)
FROM Employees;
```

Output

```
10
15
20
```

---

## DATEDIFF()

Finds difference between two dates.

```sql
SELECT DATEDIFF(CURDATE(), joining_date)
FROM Employees;
```

Returns number of days between the dates.

---

# 4. Conversion Functions

---

## CAST()

Converts one datatype to another.

```sql
SELECT CAST(100.75 AS INT);
```

Output

```
100
```

---

## CONVERT()

Another conversion function.

```sql
SELECT CONVERT('2026-06-22',DATE);
```

Output

```
2026-06-22
```

---

# 5. General Functions

---

## IFNULL()

Replaces NULL with another value.

```sql
SELECT IFNULL(NULL,0);
```

Output

```
0
```

---

## COALESCE()

Returns the first non-null value.

```sql
SELECT COALESCE(NULL,NULL,100,200);
```

Output

```
100
```

---

## NULLIF()

Returns NULL if two expressions are equal.

```sql
SELECT NULLIF(10,10);
```

Output

```
NULL
```

```sql
SELECT NULLIF(10,5);
```

Output

```
10
```

---

# Practice Queries

---

## Convert Employee Names to Uppercase

```sql
SELECT UPPER(emp_name)
FROM Employees;
```

---

## Find Length of Employee Names

```sql
SELECT emp_name,
       LENGTH(emp_name)
FROM Employees;
```

---

## Round Salary to Nearest Integer

```sql
SELECT ROUND(salary)
FROM Employees;
```

---

## Find Current Date

```sql
SELECT CURDATE();
```

---

## Extract Joining Year

```sql
SELECT emp_name,
       YEAR(joining_date)
FROM Employees;
```

---

## Replace NULL Bonus with Zero

```sql
SELECT IFNULL(bonus,0)
FROM Employees;
```

---

# Summary Table

| Function Type        | Examples                                                             |
| -------------------- | -------------------------------------------------------------------- |
| Character Functions  | UPPER(), LOWER(), LENGTH(), CONCAT(), SUBSTRING(), TRIM(), REPLACE() |
| Number Functions     | ROUND(), CEIL(), FLOOR(), ABS(), MOD(), POWER()                      |
| Date Functions       | CURDATE(), NOW(), YEAR(), MONTH(), DAY(), DATEDIFF()                 |
| Conversion Functions | CAST(), CONVERT()                                                    |
| General Functions    | IFNULL(), COALESCE(), NULLIF()                                       |

---

# Quick Revision

* Row-Level Functions operate on one row at a time.
* One input row produces one output row.
* Types:

  * Character Functions
  * Number Functions
  * Date Functions
  * Conversion Functions
  * General Functions
* These functions are heavily used in WHERE, SELECT, ORDER BY, and GROUP BY clauses.
