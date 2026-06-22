--In SQL, a set is a collection of rows returned by a query. SQL provides set operators to combine the results of two or more SELECT statements.


# SQL Set Operators - Practice Queries

## Tables Used

### Employees_2024

-- | emp_id | emp_name |
-- | ------ | -------- |
-- | 1      | Mohit    |
-- | 2      | Aman     |
-- | 3      | Ravi     |
-- | 4      | Priya    |

### Employees_2025

-- | emp_id | emp_name |
-- | ------ | -------- |
-- | 3      | Ravi     |
-- | 4      | Priya    |
-- | 5      | Simran   |
-- | 6      | Rohit    |

---

-- # 1. UNION

-- Combines rows from both tables and removes duplicates.

```sql
SELECT emp_name
FROM Employees_2024

UNION

SELECT emp_name
FROM Employees_2025;
```

### Output

```text
Mohit
Aman
Ravi
Priya
Simran
Rohit
```

---

## Example 2: Union of Employee IDs

```sql
SELECT emp_id
FROM Employees_2024

UNION

SELECT emp_id
FROM Employees_2025;
```

### Output

```text
1
2
3
4
5
6
```

---

## Example 3: Employees from IT and HR Department

```sql
SELECT emp_name
FROM IT_Employees

UNION

SELECT emp_name
FROM HR_Employees;
```

---

-- # 2. UNION ALL

-- Returns all rows including duplicates.

```sql
SELECT emp_name
FROM Employees_2024

UNION ALL

SELECT emp_name
FROM Employees_2025;
```

### Output

```text
Mohit
Aman
Ravi
Priya
Ravi
Priya
Simran
Rohit
```

---

## Example 2: IDs with Duplicates

```sql
SELECT emp_id
FROM Employees_2024

UNION ALL

SELECT emp_id
FROM Employees_2025;
```

### Output

```text
1
2
3
4
3
4
5
6
```

---

## Example 3: Product Lists from Two Warehouses

```sql
SELECT product_name
FROM Warehouse_A

UNION ALL

SELECT product_name
FROM Warehouse_B;
```

---

# 3. INTERSECT

Returns only common rows.

```sql
SELECT emp_name
FROM Employees_2024

INTERSECT

SELECT emp_name
FROM Employees_2025;
```

### Output

```text
Ravi
Priya
```

---

## Example 2: Common Employee IDs

```sql
SELECT emp_id
FROM Employees_2024

INTERSECT

SELECT emp_id
FROM Employees_2025;
```

### Output

```text
3
4
```

---

## Example 3: Customers Who Purchased in Both Years

```sql
SELECT customer_id
FROM Orders_2024

INTERSECT

SELECT customer_id
FROM Orders_2025;
```

---

# 4. EXCEPT

Returns rows present in first query but absent in second query.

```sql
SELECT emp_name
FROM Employees_2024

EXCEPT

SELECT emp_name
FROM Employees_2025;
```

### Output

```text
Mohit
Aman
```

---

## Example 2: Employee IDs Present Only in 2024

```sql
SELECT emp_id
FROM Employees_2024

EXCEPT

SELECT emp_id
FROM Employees_2025;
```

### Output

```text
1
2
```

---

## Example 3: Customers Who Purchased in 2024 but Not in 2025

```sql
SELECT customer_id
FROM Orders_2024

EXCEPT

SELECT customer_id
FROM Orders_2025;
```

---

# Real Interview Questions

## Q1. Find all unique cities from Customers and Suppliers

```sql
SELECT city
FROM Customers

UNION

SELECT city
FROM Suppliers;
```

---

## Q2. Display all cities including duplicates

```sql
SELECT city
FROM Customers

UNION ALL

SELECT city
FROM Suppliers;
```

---

## Q3. Find common cities between Customers and Suppliers

```sql
SELECT city
FROM Customers

INTERSECT

SELECT city
FROM Suppliers;
```

---

## Q4. Find cities where customers exist but suppliers do not

```sql
SELECT city
FROM Customers

EXCEPT

SELECT city
FROM Suppliers;
```

---

# Practice Problems

### Problem 1

Find all unique department names from two tables.

```sql
SELECT department_name
FROM Department_A

UNION

SELECT department_name
FROM Department_B;
```

---

### Problem 2

Find departments existing in both tables.

```sql
SELECT department_name
FROM Department_A

INTERSECT

SELECT department_name
FROM Department_B;
```

---

### Problem 3

Find departments present in Department_A but not in Department_B.

```sql
SELECT department_name
FROM Department_A

EXCEPT

SELECT department_name
FROM Department_B;
```

---

### Problem 4

Display all department names including duplicates.

```sql
SELECT department_name
FROM Department_A

UNION ALL

SELECT department_name
FROM Department_B;
```

---

# Quick Revision

| Operator  | Purpose                                            |
| --------- | -------------------------------------------------- |
| UNION     | Combines rows and removes duplicates               |
| UNION ALL | Combines rows and keeps duplicates                 |
| INTERSECT | Returns common rows                                |
| EXCEPT    | Returns rows present in first query but not second |

---

# Key Rules

1. Both SELECT statements must have the same number of columns.
2. Corresponding columns should have compatible data types.
3. Column names in the output are taken from the first SELECT statement.
4. UNION removes duplicates automatically.
5. UNION ALL is faster because it doesn't perform duplicate checking.
6. INTERSECT returns common rows only.
7. EXCEPT returns rows from the first set that are absent in the second set.

