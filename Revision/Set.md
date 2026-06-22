# SQL Set Operations

## Introduction

A **Set** in SQL is a collection of rows returned by a query. SQL provides **Set Operators** to combine the results of two or more `SELECT` statements.

Example:

```sql
SELECT city
FROM Customers;
```

returns one set of cities.

```sql
SELECT city
FROM Suppliers;
```

returns another set of cities.

Set operators combine these sets.

---

# Rules of Set Operations

Before using any set operator (`UNION`, `UNION ALL`, `INTERSECT`, `EXCEPT/MINUS`), the following rules must be satisfied.

---

## Rule 1: Same Number of Columns

### Correct

```sql
SELECT customer_name
FROM Customers

UNION

SELECT supplier_name
FROM Suppliers;
```

Both queries return one column.

### Incorrect

```sql
SELECT customer_name, city
FROM Customers

UNION

SELECT supplier_name
FROM Suppliers;
```

**Error:** Number of columns must be the same.

---

## Rule 2: Corresponding Columns Must Have Compatible Data Types

### Correct

```sql
SELECT customer_name
FROM Customers

UNION

SELECT supplier_name
FROM Suppliers;
```

Both columns are VARCHAR.

### Correct

```sql
SELECT customer_id
FROM Customers

UNION

SELECT supplier_id
FROM Suppliers;
```

Both columns are INT.

### Incorrect

```sql
SELECT customer_name
FROM Customers

UNION

SELECT supplier_id
FROM Suppliers;
```

VARCHAR and INT are incompatible.

---

## Rule 3: Column Names Come from the First SELECT Statement

```sql
SELECT customer_name
FROM Customers

UNION

SELECT supplier_name
FROM Suppliers;
```

Output column name:

```
customer_name
```

Column names are always taken from the first query.

---

# Types of Set Operators

There are four main set operators:

1. UNION
2. UNION ALL
3. INTERSECT
4. EXCEPT (MINUS in Oracle)

---

# Example Tables

## Table A

| id |
| -- |
| 1  |
| 2  |
| 3  |
| 4  |

## Table B

| id |
| -- |
| 3  |
| 4  |
| 5  |
| 6  |

---

# 1. UNION

Returns all distinct rows by removing duplicates.

### Query

```sql
SELECT id
FROM A

UNION

SELECT id
FROM B;
```

### Step 1

From A:

```
1
2
3
4
```

### Step 2

From B:

```
3
4
5
6
```

### Step 3

Combined Result:

```
1
2
3
4
3
4
5
6
```

### Step 4

Duplicates removed:

```
1
2
3
4
5
6
```

### Output

| id |
| -- |
| 1  |
| 2  |
| 3  |
| 4  |
| 5  |
| 6  |

---

# 2. UNION ALL

Returns all rows including duplicates.

### Query

```sql
SELECT id
FROM A

UNION ALL

SELECT id
FROM B;
```

### Output

| id |
| -- |
| 1  |
| 2  |
| 3  |
| 4  |
| 3  |
| 4  |
| 5  |
| 6  |

### Key Point

* UNION removes duplicates.
* UNION ALL keeps duplicates.
* UNION ALL is faster because no duplicate checking is performed.

---

# 3. INTERSECT

Returns only the common rows between two sets.

### Query

```sql
SELECT id
FROM A

INTERSECT

SELECT id
FROM B;
```

### Table A

```
1
2
3
4
```

### Table B

```
3
4
5
6
```

### Common Values

```
3
4
```

### Output

| id |
| -- |
| 3  |
| 4  |

### Mathematical Representation

```
A ∩ B
```

---

# 4. EXCEPT (MINUS in Oracle)

Returns rows present in the first query but absent in the second query.

### Query

```sql
SELECT id
FROM A

EXCEPT

SELECT id
FROM B;
```

### Table A

```
1
2
3
4
```

### Table B

```
3
4
5
6
```

Remove common values:

```
3
4
```

Remaining values:

```
1
2
```

### Output

| id |
| -- |
| 1  |
| 2  |

### Mathematical Representation

```
A - B
```

---

# Summary Table

| Operator  | Meaning                                  | Duplicate Removed |
| --------- | ---------------------------------------- | ----------------- |
| UNION     | Combines both sets                       | Yes               |
| UNION ALL | Combines both sets                       | No                |
| INTERSECT | Returns common rows                      | Yes               |
| EXCEPT    | Returns rows in first set but not second | Yes               |

---

# Venn Diagram Representation

## UNION

```
A ∪ B

1 2 3 4 5 6
```

---

## INTERSECT

```
A ∩ B

3 4
```

---

## EXCEPT

```
A - B

1 2
```

---

# Difference Between UNION and UNION ALL

| UNION                        | UNION ALL          |
| ---------------------------- | ------------------ |
| Removes duplicates           | Keeps duplicates   |
| Slower                       | Faster             |
| Performs DISTINCT internally | No duplicate check |
| More processing required     | Less processing    |

### Example

```sql
SELECT id FROM A
UNION
SELECT id FROM B;
```

Result:

```
1
2
3
4
5
6
```

---

```sql
SELECT id FROM A
UNION ALL
SELECT id FROM B;
```

Result:

```
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

# Quick Revision

* **UNION** → Combines both sets and removes duplicates.
* **UNION ALL** → Combines both sets and keeps duplicates.
* **INTERSECT** → Returns common rows only.
* **EXCEPT** → Returns rows present in the first set but absent in the second set.
* Number of columns must be the same.
* Corresponding columns should have compatible data types.
* Output column names are taken from the first SELECT statement.
