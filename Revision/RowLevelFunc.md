# SQL Row-Level Functions - Practice Queries

## Sample Table: Employees

| emp_id | emp_name | salary | department | joining_date | bonus |
| ------ | -------- | ------ | ---------- | ------------ | ----- |
| 1      | Mohit    | 50000  | IT         | 2023-01-10   | NULL  |
| 2      | Aman     | 45000  | HR         | 2022-08-15   | 5000  |
| 3      | Ravi     | 60000  | Sales      | 2021-05-20   | NULL  |

---

# 1. Character Functions

## UPPER()

Convert employee names into uppercase.

```sql
SELECT UPPER(emp_name)
FROM Employees;
```

---

## LOWER()

Convert employee names into lowercase.

```sql
SELECT LOWER(emp_name)
FROM Employees;
```

---

## LENGTH()

Find length of employee names.

```sql
SELECT emp_name,
       LENGTH(emp_name)
FROM Employees;
```

---

## CONCAT()

Concatenate employee name and department.

```sql
SELECT CONCAT(emp_name,' works in ',department)
FROM Employees;
```

---

## SUBSTRING()

Extract first three characters from employee names.

```sql
SELECT SUBSTRING(emp_name,1,3)
FROM Employees;
```

---

## TRIM()

Remove leading and trailing spaces.

```sql
SELECT TRIM('   Mohit   ');
```

---

## REPLACE()

Replace IT department with Information Technology.

```sql
SELECT REPLACE(department,'IT','Information Technology')
FROM Employees;
```

---

## LEFT()

Extract first four characters.

```sql
SELECT LEFT(emp_name,4)
FROM Employees;
```

---

## RIGHT()

Extract last three characters.

```sql
SELECT RIGHT(emp_name,3)
FROM Employees;
```

---

# 2. Number Functions

## ROUND()

Round salary after dividing by 3.

```sql
SELECT ROUND(salary/3,2)
FROM Employees;
```

---

## CEIL()

Round salary upwards.

```sql
SELECT CEIL(salary/1000)
FROM Employees;
```

---

## FLOOR()

Round salary downwards.

```sql
SELECT FLOOR(salary/1000)
FROM Employees;
```

---

## ABS()

Return absolute value.

```sql
SELECT ABS(-100);
```

---

## MOD()

Find remainder.

```sql
SELECT MOD(25,7);
```

---

## POWER()

Find square of salary.

```sql
SELECT POWER(salary,2)
FROM Employees;
```

---

## SQRT()

Find square root.

```sql
SELECT SQRT(625);
```

---

# 3. Date Functions

## CURDATE()

Display current date.

```sql
SELECT CURDATE();
```

---

## NOW()

Display current date and time.

```sql
SELECT NOW();
```

---

## YEAR()

Extract joining year.

```sql
SELECT emp_name,
       YEAR(joining_date)
FROM Employees;
```

---

## MONTH()

Extract joining month.

```sql
SELECT emp_name,
       MONTH(joining_date)
FROM Employees;
```

---

## DAY()

Extract day.

```sql
SELECT emp_name,
       DAY(joining_date)
FROM Employees;
```

---

## MONTHNAME()

Display month name.

```sql
SELECT emp_name,
       MONTHNAME(joining_date)
FROM Employees;
```

---

## DAYNAME()

Display day name.

```sql
SELECT emp_name,
       DAYNAME(joining_date)
FROM Employees;
```

---

## DATEDIFF()

Find days between today and joining date.

```sql
SELECT emp_name,
       DATEDIFF(CURDATE(),joining_date)
FROM Employees;
```

---

## DATE_ADD()

Add 30 days to joining date.

```sql
SELECT emp_name,
       DATE_ADD(joining_date,INTERVAL 30 DAY)
FROM Employees;
```

---

## DATE_SUB()

Subtract 1 year from joining date.

```sql
SELECT emp_name,
       DATE_SUB(joining_date,INTERVAL 1 YEAR)
FROM Employees;
```

---

# 4. Conversion Functions

## CAST()

Convert decimal into integer.

```sql
SELECT CAST(123.89 AS SIGNED);
```

---

## Convert Integer to Character

```sql
SELECT CAST(100 AS CHAR);
```

---

## CONVERT()

Convert string to date.

```sql
SELECT CONVERT('2026-06-22',DATE);
```

---

# 5. General Functions

## IFNULL()

Replace NULL bonus with zero.

```sql
SELECT emp_name,
       IFNULL(bonus,0)
FROM Employees;
```

---

## COALESCE()

Return first non-null value.

```sql
SELECT COALESCE(NULL,NULL,500,1000);
```

---

## NULLIF()

Return NULL if both values are same.

```sql
SELECT NULLIF(10,10);
```

---

Return first value if values are different.

```sql
SELECT NULLIF(10,5);
```

---

# Mixed Interview Queries

## Convert employee names into uppercase and display length.

```sql
SELECT UPPER(emp_name),
       LENGTH(emp_name)
FROM Employees;
```

---

## Display employee name with joining year.

```sql
SELECT emp_name,
       YEAR(joining_date)
FROM Employees;
```

---

## Replace NULL bonus with 0.

```sql
SELECT emp_name,
       IFNULL(bonus,0)
FROM Employees;
```

---

## Display employee details in sentence form.

```sql
SELECT CONCAT(emp_name,' belongs to ',department)
FROM Employees;
```

---

## Find square root of salary.

```sql
SELECT emp_name,
       SQRT(salary)
FROM Employees;
```

---

## Find employees joined in January.

```sql
SELECT *
FROM Employees
WHERE MONTH(joining_date)=1;
```

---

## Find employees whose names start with 'M'.

```sql
SELECT *
FROM Employees
WHERE LEFT(emp_name,1)='M';
```

---

## Find employees whose names end with 't'.

```sql
SELECT *
FROM Employees
WHERE RIGHT(emp_name,1)='t';
```

---

# Quick Revision

### Character Functions

* UPPER()
* LOWER()
* LENGTH()
* CONCAT()
* SUBSTRING()
* TRIM()
* REPLACE()
* LEFT()
* RIGHT()

### Number Functions

* ROUND()
* CEIL()
* FLOOR()
* ABS()
* MOD()
* POWER()
* SQRT()

### Date Functions

* CURDATE()
* NOW()
* YEAR()
* MONTH()
* DAY()
* MONTHNAME()
* DAYNAME()
* DATEDIFF()
* DATE_ADD()
* DATE_SUB()

### Conversion Functions

* CAST()
* CONVERT()

### General Functions

* IFNULL()
* COALESCE()
* NULLIF()

-- These are the most commonly used Row-Level Functions in SQL interviews and real-world projects.
