# SQL Window Functions — Complete Guide

A window function performs a calculation across a set of rows that are related to the current row — but unlike `GROUP BY`, it does **not collapse the rows**. Every row keeps its identity, and you get an extra calculated column alongside it.

**Sample table used throughout this guide — `employees`:**

| emp_id | emp_name | department | salary | hire_date  |
|--------|----------|------------|--------|------------|
| 1      | Aman     | IT         | 55000  | 2021-03-01 |
| 2      | Riya     | IT         | 62000  | 2020-07-15 |
| 3      | Karan    | IT         | 62000  | 2022-01-10 |
| 4      | Simran   | HR         | 48000  | 2019-05-20 |
| 5      | Vikas    | HR         | 51000  | 2021-11-02 |
| 6      | Neha     | Sales      | 45000  | 2020-09-09 |
| 7      | Rohit    | Sales      | 53000  | 2022-04-18 |
| 8      | Pooja    | Sales      | 53000  | 2023-02-25 |

```sql
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    hire_date DATE
);
```

---

## 1. OVER() — Foundation

`OVER()` is what turns a normal aggregate/ranking function into a **window function**. Without it, `SUM()`, `AVG()`, etc. need `GROUP BY` and collapse rows. With `OVER()`, the function runs "over a window of rows" while every original row stays visible.

```sql
SELECT
    emp_name,
    department,
    salary,
    SUM(salary) OVER() AS total_company_salary
FROM employees;
```

**What happens:** Every single row gets the **same** value — the total salary of the whole company — but you still see all 8 individual employee rows. That's the core idea: aggregate value + row-level detail, together.

---

## 2. PARTITION BY

`PARTITION BY` slices the table into **groups** (like `GROUP BY` would), and the window function is then calculated **separately within each group**, while still keeping every row.

```sql
SELECT
    emp_name,
    department,
    salary,
    SUM(salary) OVER(PARTITION BY department) AS dept_total_salary
FROM employees;
```

**What happens:** Now `dept_total_salary` resets per department. IT employees see the IT total, HR employees see the HR total, Sales employees see the Sales total — but all 8 rows are still there individually.

Think of `PARTITION BY` as "restart the calculation whenever the department changes."

---

## 3. ORDER BY inside OVER()

When you put `ORDER BY` **inside** `OVER()`, you're telling SQL the **sequence** in which rows should be processed. This is essential for ranking functions and running totals — it decides "row 1, row 2, row 3..." within each partition.

```sql
SELECT
    emp_name,
    department,
    salary,
    SUM(salary) OVER(PARTITION BY department ORDER BY salary) AS running_total
FROM employees;
```

**What happens:** Within each department, salaries are sorted ascending, and `running_total` keeps adding the current row's salary to all salaries before it (a **running/cumulative sum**). This is very different from Topic 2 — there, the whole department total appeared on every row. Here, the total grows row by row.

> ⚠️ This is one of the most confused topics: `ORDER BY` inside `OVER()` does NOT sort your final output. It only controls the window's internal calculation order. To sort the displayed result, you still need a separate `ORDER BY` at the end of the query.

---

## 4. ROW_NUMBER()

Gives every row a **unique, sequential number** within its partition, based on the `ORDER BY`. No ties — even if two rows have the same value, they get different numbers.

```sql
SELECT
    emp_name,
    department,
    salary,
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS row_num
FROM employees;
```

**What happens:** Within each department, the highest paid employee gets `row_num = 1`, next gets `2`, and so on — strictly sequential, never repeating, even Karan and Riya (both 62000 in IT) will get `1` and `2` in some order.

**Common real use:** Removing duplicates, or picking the "top 1 row per group."

```sql
-- Get the highest-paid employee in each department
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS rn
    FROM employees
) t
WHERE rn = 1;
```

---

## 5. RANK()

Like `ROW_NUMBER()`, but **ties get the same rank**, and after a tie, ranks are **skipped**.

```sql
SELECT
    emp_name,
    department,
    salary,
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rnk
FROM employees;
```

**What happens (IT department):** Riya and Karan both have 62000 → both get rank `1`. Aman, with the next salary, gets rank `3` (rank `2` is skipped because two rows already took position 1).

---

## 6. DENSE_RANK()

Same as `RANK()`, ties share the same rank — but **no ranks are skipped** afterward.

```sql
SELECT
    emp_name,
    department,
    salary,
    DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dense_rnk
FROM employees;
```

**What happens (IT department):** Riya and Karan tie at rank `1`. Aman gets rank `2` (not `3`) — the next rank just continues normally.

**Quick comparison table (IT dept, sorted by salary desc):**

| emp_name | salary | ROW_NUMBER | RANK | DENSE_RANK |
|----------|--------|------------|------|------------|
| Riya     | 62000  | 1          | 1    | 1          |
| Karan    | 62000  | 2          | 1    | 1          |
| Aman     | 55000  | 3          | 3    | 2          |

---

## 7. SUM() OVER()

Used for **running totals** or **group totals**, depending on whether `ORDER BY` is used.

```sql
-- Running total of salary within each department, ordered by hire date
SELECT
    emp_name,
    department,
    hire_date,
    salary,
    SUM(salary) OVER(PARTITION BY department ORDER BY hire_date) AS running_salary
FROM employees;
```

**What happens:** For each department, as you move down by hire date, `running_salary` accumulates — each new employee's row shows the total salary spent in that department **up to and including** them.

---

## 8. AVG() OVER()

Calculates a **running average** or **group average**, same logic as `SUM()`.

```sql
SELECT
    emp_name,
    department,
    salary,
    AVG(salary) OVER(PARTITION BY department) AS dept_avg_salary,
    salary - AVG(salary) OVER(PARTITION BY department) AS diff_from_avg
FROM employees;
```

**What happens:** Every employee can instantly see how their salary compares to their department's average — useful for spotting under/over-paid employees without writing a self-join.

---

## 9. COUNT() OVER()

Counts rows in a partition (or the whole table) without collapsing them.

```sql
SELECT
    emp_name,
    department,
    COUNT(*) OVER(PARTITION BY department) AS dept_headcount
FROM employees;
```

**What happens:** Every IT employee row shows `3` (since there are 3 IT employees), every HR row shows `2`, every Sales row shows `3` — while still listing all individual employees.

---

## 10. LAG()

Looks **backward** — fetches a value from a **previous row** within the partition, based on the `ORDER BY`.

```sql
SELECT
    emp_name,
    department,
    salary,
    hire_date,
    LAG(salary, 1) OVER(PARTITION BY department ORDER BY hire_date) AS prev_employee_salary
FROM employees;
```

**What happens:** For each employee, you see the salary of the **previously hired** person in the same department. The very first hired employee in each department gets `NULL` (no previous row exists) — unless you supply a default:

```sql
LAG(salary, 1, 0) OVER(PARTITION BY department ORDER BY hire_date) AS prev_salary
```
Here, `0` is returned instead of `NULL` for the first row.

**Real use case:** Month-over-month comparison, "previous purchase amount," etc.

---

## 11. LEAD()

The opposite of `LAG()` — looks **forward** to a **next row's** value.

```sql
SELECT
    emp_name,
    department,
    salary,
    hire_date,
    LEAD(salary, 1) OVER(PARTITION BY department ORDER BY hire_date) AS next_employee_salary
FROM employees;
```

**What happens:** Each row shows the salary of the **next hired** employee in that department. The last hired employee in each department gets `NULL` (nothing comes after).

**Real use case:** "What's the next transaction date?", churn analysis, detecting gaps between events.

---

## 12. FIRST_VALUE()

Returns the value from the **first row** of the window/partition (based on `ORDER BY`), repeated on every row.

```sql
SELECT
    emp_name,
    department,
    salary,
    hire_date,
    FIRST_VALUE(emp_name) OVER(PARTITION BY department ORDER BY hire_date) AS first_hired_employee
FROM employees;
```

**What happens:** Every row in a department shows the name of the **first person ever hired** there — constant for the whole partition, similar in spirit to Topic 2's "repeat on every row" behavior, but instead of an aggregate, it picks an actual row's value.

---

## 13. LAST_VALUE()

Returns the value from the **last row** of the window — but this one needs care.

```sql
SELECT
    emp_name,
    department,
    salary,
    hire_date,
    LAST_VALUE(emp_name) OVER(
        PARTITION BY department
        ORDER BY hire_date
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_hired_employee
FROM employees;
```

> ⚠️ **The #1 gotcha with `LAST_VALUE()`:** By default, the window frame only looks at rows "up to the current row" (`RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`). That means `LAST_VALUE()` without specifying the frame will just return the **current row itself**, not the true last row of the partition! You must explicitly add `RANGE/ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` to get the real last row on every row.

---

## 14. NTILE()

Splits the partition into **N roughly equal buckets/groups** and assigns each row a bucket number. Commonly used for things like quartiles, deciles, or salary bands.

```sql
SELECT
    emp_name,
    department,
    salary,
    NTILE(2) OVER(PARTITION BY department ORDER BY salary DESC) AS salary_band
FROM employees;
```

**What happens:** Within each department, employees are split into 2 groups based on salary rank — `1` = higher-paid half, `2` = lower-paid half. If rows can't be split perfectly evenly, the earlier buckets get the extra row(s).

**Real use case:** Splitting customers into spending tiers (top 25%, next 25%, etc.) using `NTILE(4)`.

---

## 15. Interview Questions (Top 20)

**Conceptual**

1. **What is a window function, and how is it different from a normal aggregate function with `GROUP BY`?**
   → Aggregate + `GROUP BY` collapses rows into one row per group. Window functions calculate across a group of rows but **keep every row visible**.

2. **What does `PARTITION BY` do inside `OVER()`?**
   → It divides the result set into groups (partitions); the window function is calculated independently within each group.

3. **What's the difference between `PARTITION BY` and `GROUP BY`?**
   → `GROUP BY` reduces the number of returned rows; `PARTITION BY` does not reduce rows — it just groups for calculation purposes.

4. **What role does `ORDER BY` play inside `OVER()`?**
   → It defines the logical order in which rows are processed for ranking, running totals, `LAG`/`LEAD`, etc. It does not sort the final query output.

5. **Can you use a window function in the `WHERE` clause directly? Why or why not?**
   → No — window functions are evaluated after `WHERE`, so you must wrap the query in a subquery/CTE and filter on the alias afterward.

**Ranking Functions**

6. **Difference between `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`?**
   → `ROW_NUMBER()` never repeats numbers. `RANK()` gives ties the same number but skips subsequent numbers. `DENSE_RANK()` gives ties the same number without skipping.

7. **How would you find the 2nd highest salary in each department?**
   ```sql
   SELECT * FROM (
       SELECT *, DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dr
       FROM employees
   ) t WHERE dr = 2;
   ```

8. **How do you remove duplicate rows using a window function?**
   → Use `ROW_NUMBER()` partitioned by the duplicate-defining columns, then keep only `rn = 1`.

9. **When would `RANK()` give a misleading result compared to `DENSE_RANK()`?**
   → When you want "top N distinct performance levels" — `RANK()`'s skipped numbers can make it look like more people exist at a rank than actually do.

10. **How do you get the top 3 highest-paid employees per department?**
    ```sql
    SELECT * FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS rn
        FROM employees
    ) t WHERE rn <= 3;
    ```

**Aggregate Window Functions**

11. **How do you calculate a running total in SQL?**
    → `SUM(col) OVER(PARTITION BY ... ORDER BY ...)` — the `ORDER BY` is what makes it "running" instead of a flat group total.

12. **How would you find each employee's salary compared to the department average?**
    ```sql
    SELECT emp_name, salary,
           salary - AVG(salary) OVER(PARTITION BY department) AS diff
    FROM employees;
    ```

13. **What happens if you use `SUM() OVER()` with no `PARTITION BY` and no `ORDER BY`?**
    → It computes one grand total over the entire table, repeated on every row.

14. **How is `COUNT(*) OVER(PARTITION BY dept)` useful in real analysis?**
    → It instantly attaches "department headcount" to every employee row — handy for ratios like "salary as % of department" without a separate join.

**LAG / LEAD / FIRST_VALUE / LAST_VALUE**

15. **How would you calculate the difference between an employee's salary and the previous hire's salary in the same department?**
    ```sql
    SELECT emp_name, department, salary,
           salary - LAG(salary) OVER(PARTITION BY department ORDER BY hire_date) AS diff
    FROM employees;
    ```

16. **Why does `LAST_VALUE()` sometimes return the same value as the current row instead of the true last row?**
    → Because the default window frame is `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`. You must explicitly extend the frame to `UNBOUNDED FOLLOWING` to get the actual last row.

17. **How do `LAG()` and `LEAD()` handle the first/last row of a partition where no previous/next row exists?**
    → They return `NULL` by default, unless you provide an explicit default value as the third argument.

18. **Give a real-world use case for `LEAD()`.**
    → Calculating the number of days until a customer's next order, to detect inactive/churned customers.

**NTILE / Frames / Mixed**

19. **How would you split employees into 4 salary quartiles?**
    ```sql
    SELECT emp_name, salary,
           NTILE(4) OVER(ORDER BY salary DESC) AS quartile
    FROM employees;
    ```

20. **Write a query to find employees earning more than their department's average salary.**
    ```sql
    SELECT * FROM (
        SELECT *, AVG(salary) OVER(PARTITION BY department) AS dept_avg
        FROM employees
    ) t
    WHERE salary > dept_avg;
    ```

---

### Quick Recap Table

| # | Function            | Purpose                                      |
|---|----------------------|-----------------------------------------------|
| 1 | `OVER()`             | Turns aggregate/ranking into a window function |
| 2 | `PARTITION BY`       | Groups rows for separate calculation, no collapsing |
| 3 | `ORDER BY` in `OVER()` | Defines row sequence inside the window       |
| 4 | `ROW_NUMBER()`       | Unique sequential number per partition        |
| 5 | `RANK()`             | Ties share rank, gaps after ties              |
| 6 | `DENSE_RANK()`       | Ties share rank, no gaps                      |
| 7 | `SUM() OVER()`       | Running or group total                        |
| 8 | `AVG() OVER()`       | Running or group average                      |
| 9 | `COUNT() OVER()`     | Running or group count                        |
| 10| `LAG()`              | Value from a previous row                     |
| 11| `LEAD()`             | Value from a next row                         |
| 12| `FIRST_VALUE()`      | First row's value in the window               |
| 13| `LAST_VALUE()`       | Last row's value (needs explicit frame!)      |
| 14| `NTILE(n)`           | Splits partition into n equal buckets         |