# SQL Window Functions — Complete Guide

A window function performs a calculation across a **set of rows related to the current row**, without collapsing those rows into a single output row (unlike `GROUP BY`). This is the single most important thing to understand: **window functions keep every row, but let you "look around" at other rows while computing a value.**

---

## 1. Why Window Functions Exist

Suppose you have employee salaries and want, for each employee, to show their salary **alongside** the average salary of their department.

With plain `GROUP BY`, you can only get one row per department:

```sql
SELECT department, AVG(salary)
FROM employees
GROUP BY department;
```

This collapses all employee rows. You lose individual employee detail.

Window functions solve exactly this: they let you compute aggregates (or rankings, or running totals) **per row**, while still seeing every other row.

```sql
SELECT
    employee_name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM employees;
```

Now every employee row is preserved, and each one shows the department average next to it.

---

## 2. Sample Table Used Throughout This Guide

```sql
CREATE TABLE employees (
    employee_id   INT PRIMARY KEY,
    employee_name VARCHAR(50),
    department    VARCHAR(50),
    salary        INT,
    hire_date     DATE
);

INSERT INTO employees VALUES
(1, 'Aman',   'Engineering', 85000, '2021-03-15'),
(2, 'Priya',  'Engineering', 92000, '2020-07-01'),
(3, 'Rohit',  'Engineering', 78000, '2022-01-10'),
(4, 'Sneha',  'Sales',       65000, '2019-11-23'),
(5, 'Kabir',  'Sales',       70000, '2021-06-12'),
(6, 'Meena',  'Sales',       72000, '2023-02-19'),
(7, 'Farhan', 'HR',          55000, '2020-09-05'),
(8, 'Divya',  'HR',          58000, '2022-08-30');
```

Keep this table in mind — every query below uses it.

---

## 3. Basic Syntax

```sql
function_name(expression) OVER (
    [PARTITION BY column1, column2, ...]
    [ORDER BY column3, column4, ...]
    [frame_clause]
)
```

| Clause | Purpose |
|---|---|
| `function_name(...)` | The function being applied (aggregate, ranking, or value function) |
| `OVER (...)` | Marks it as a window function — defines the "window" of rows |
| `PARTITION BY` | Splits rows into groups (like `GROUP BY`, but doesn't collapse rows) |
| `ORDER BY` | Defines the order of rows *within* each partition (needed for ranking/running calculations) |
| Frame clause | Fine-tunes exactly which rows within the partition are included (e.g. `ROWS BETWEEN ...`) |

If you omit `PARTITION BY`, the entire table is treated as one big partition.

---

## 4. Categories of Window Functions

1. **Aggregate window functions** — `SUM()`, `AVG()`, `COUNT()`, `MIN()`, `MAX()`
2. **Ranking window functions** — `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `NTILE()`
3. **Value / offset window functions** — `LAG()`, `LEAD()`, `FIRST_VALUE()`, `LAST_VALUE()`, `NTH_VALUE()`

---

## 5. Aggregate Window Functions

These are the same functions you already know from `GROUP BY`, just used with `OVER()` instead.

### 5.1 `SUM() OVER()` — Department-wise total salary, per employee

```sql
SELECT
    employee_name,
    department,
    salary,
    SUM(salary) OVER (PARTITION BY department) AS dept_total_salary
FROM employees;
```

| employee_name | department  | salary | dept_total_salary |
|---|---|---|---|
| Aman   | Engineering | 85000 | 255000 |
| Priya  | Engineering | 92000 | 255000 |
| Rohit  | Engineering | 78000 | 255000 |
| Sneha  | Sales       | 65000 | 207000 |
| Kabir  | Sales       | 70000 | 207000 |
| Meena  | Sales       | 72000 | 207000 |
| Farhan | HR          | 55000 | 113000 |
| Divya  | HR          | 58000 | 113000 |

Notice: every row is retained, but each one now also "knows" its department's total.

### 5.2 `AVG() OVER()` — Compare individual salary to department average

```sql
SELECT
    employee_name,
    department,
    salary,
    ROUND(AVG(salary) OVER (PARTITION BY department), 2) AS dept_avg_salary,
    salary - ROUND(AVG(salary) OVER (PARTITION BY department), 2) AS diff_from_avg
FROM employees;
```

This pattern (row value vs. group average, in one row) is extremely common in analytics — e.g. "show how each salesperson's revenue compares to the team average."

### 5.3 `COUNT() OVER()` — Number of employees in each department, per row

```sql
SELECT
    employee_name,
    department,
    COUNT(*) OVER (PARTITION BY department) AS dept_headcount
FROM employees;
```

### 5.4 Running Total (No `PARTITION BY`, with `ORDER BY`)

This is where window functions truly shine — calculating a **running/cumulative total**:

```sql
SELECT
    employee_name,
    hire_date,
    salary,
    SUM(salary) OVER (ORDER BY hire_date) AS running_total_salary
FROM employees;
```

Because there's no `PARTITION BY`, this runs across the whole table, ordered by `hire_date`. Each row shows the cumulative salary spend up to and including that hire date.

### 5.5 Running Total Within Each Department

Combine both clauses:

```sql
SELECT
    employee_name,
    department,
    hire_date,
    salary,
    SUM(salary) OVER (
        PARTITION BY department
        ORDER BY hire_date
    ) AS running_dept_total
FROM employees;
```

This resets the running total for each new department, but accumulates row by row in hire-date order within that department.

---

## 6. Ranking Window Functions

These don't aggregate values — they assign a position/rank to each row.

### 6.1 `ROW_NUMBER()` — Unique sequential number

```sql
SELECT
    employee_name,
    department,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num
FROM employees;
```

| employee_name | department  | salary | row_num |
|---|---|---|---|
| Priya  | Engineering | 92000 | 1 |
| Aman   | Engineering | 85000 | 2 |
| Rohit  | Engineering | 78000 | 3 |
| Meena  | Sales       | 72000 | 1 |
| Kabir  | Sales       | 70000 | 2 |
| Sneha  | Sales       | 65000 | 3 |
| Divya  | HR          | 58000 | 1 |
| Farhan | HR          | 55000 | 2 |

`ROW_NUMBER()` always gives unique, strictly increasing numbers — even if two rows tie on salary, they still get different numbers.

**Common use case:** finding the top-N rows per group (e.g. "highest paid employee per department"):

```sql
SELECT * FROM (
    SELECT
        employee_name,
        department,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn
    FROM employees
) ranked
WHERE rn = 1;
```

### 6.2 `RANK()` — Same value = same rank, but gaps appear after ties

```sql
SELECT
    employee_name,
    salary,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;
```

If two employees tie at, say, 70000, both get rank `4`, and the next employee jumps to rank `6` (skipping 5).

### 6.3 `DENSE_RANK()` — Same value = same rank, NO gaps

```sql
SELECT
    employee_name,
    salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_salary_rank
FROM employees;
```

Same tie situation as above, but the next distinct salary gets rank `5`, not `6`. No numbers are skipped.

**Quick comparison table (illustrative tie example):**

| salary | ROW_NUMBER | RANK | DENSE_RANK |
|---|---|---|---|
| 92000 | 1 | 1 | 1 |
| 85000 | 2 | 2 | 2 |
| 78000 | 3 | 3 | 3 |
| 72000 | 4 | 4 | 4 |
| 72000 *(tie)* | 5 | 4 | 4 |
| 70000 | 6 | 6 | 5 |

### 6.4 `NTILE(n)` — Split rows into `n` equal buckets

```sql
SELECT
    employee_name,
    salary,
    NTILE(4) OVER (ORDER BY salary DESC) AS quartile
FROM employees;
```

Useful for things like splitting customers into salary quartiles, or students into performance deciles.

---

## 7. Value / Offset Window Functions

These let you peek at **other rows** — previous, next, first, or last — relative to the current row.

### 7.1 `LAG()` — Value from a previous row

```sql
SELECT
    employee_name,
    department,
    hire_date,
    salary,
    LAG(salary, 1) OVER (PARTITION BY department ORDER BY hire_date) AS prev_employee_salary
FROM employees;
```

`LAG(salary, 1)` looks one row back (within the same department, ordered by hire date) and returns that salary. The first row in each partition has no previous row, so it returns `NULL`.

**Common use case:** comparing this month's sales to last month's:

```sql
SELECT
    month,
    revenue,
    LAG(revenue, 1) OVER (ORDER BY month) AS previous_month_revenue,
    revenue - LAG(revenue, 1) OVER (ORDER BY month) AS month_over_month_change
FROM monthly_sales;
```

### 7.2 `LEAD()` — Value from a following row

```sql
SELECT
    employee_name,
    department,
    hire_date,
    salary,
    LEAD(salary, 1) OVER (PARTITION BY department ORDER BY hire_date) AS next_employee_salary
FROM employees;
```

Exact mirror image of `LAG()` — looks forward instead of backward.

### 7.3 `FIRST_VALUE()` — First value in the window

```sql
SELECT
    employee_name,
    department,
    salary,
    FIRST_VALUE(employee_name) OVER (
        PARTITION BY department ORDER BY salary DESC
    ) AS highest_paid_in_dept
FROM employees;
```

Every row in a department shows the name of that department's highest earner.

### 7.4 `LAST_VALUE()` — Last value in the window

```sql
SELECT
    employee_name,
    department,
    salary,
    LAST_VALUE(employee_name) OVER (
        PARTITION BY department
        ORDER BY salary DESC
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS lowest_paid_in_dept
FROM employees;
```

⚠️ **Important gotcha:** by default, the window frame only extends up to the *current row* (`RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`), so `LAST_VALUE()` without an explicit frame often returns the current row itself, not the true last row of the partition. That's why the frame clause `UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` is added above — explained in the next section.

---

## 8. The Frame Clause — Controlling Exactly Which Rows Are "In the Window"

By default, when you use `ORDER BY` inside `OVER()`, SQL applies this implicit frame:

```
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
```

This means: "include all rows from the start of the partition up to and including the current row." This is exactly why running totals work the way they do.

You can override this with `ROWS BETWEEN ... AND ...`:

| Frame boundary | Meaning |
|---|---|
| `UNBOUNDED PRECEDING` | Start of the partition |
| `N PRECEDING` | N rows before the current row |
| `CURRENT ROW` | The current row |
| `N FOLLOWING` | N rows after the current row |
| `UNBOUNDED FOLLOWING` | End of the partition |

### 8.1 Moving Average (last 3 rows including current)

```sql
SELECT
    employee_name,
    hire_date,
    salary,
    AVG(salary) OVER (
        ORDER BY hire_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3
FROM employees;
```

This computes the average of the **current row plus the two preceding rows** — a classic 3-row moving average, commonly used for smoothing trends in sales/stock data.

### 8.2 Total Across the Entire Partition (regardless of row order)

```sql
SELECT
    employee_name,
    department,
    salary,
    SUM(salary) OVER (
        PARTITION BY department
        ORDER BY salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS dept_total_unaffected_by_order
FROM employees;
```

This is equivalent to leaving out `ORDER BY` entirely for a `SUM`, but it's useful to know explicitly how to force the "whole partition" frame even when `ORDER BY` is present (e.g. needed alongside `LAST_VALUE()`).

---

## 9. `WHERE`, `GROUP BY`, and Window Functions — Order of Evaluation

A frequent point of confusion: **you cannot filter on a window function using `WHERE`** in the same query, because window functions are computed *after* `WHERE` and `GROUP BY` in SQL's logical processing order:

```
FROM → WHERE → GROUP BY → HAVING → SELECT (window functions evaluated here) → ORDER BY → LIMIT
```

So this is **invalid**:

```sql
-- ❌ This will throw an error
SELECT
    employee_name,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees
WHERE salary_rank = 1;
```

The correct approach is to wrap it in a subquery or CTE:

```sql
-- ✅ Correct
WITH ranked_employees AS (
    SELECT
        employee_name,
        salary,
        RANK() OVER (ORDER BY salary DESC) AS salary_rank
    FROM employees
)
SELECT *
FROM ranked_employees
WHERE salary_rank = 1;
```

---

## 10. Putting It All Together — A Realistic Example

**Goal:** For each department, show every employee, their salary, their rank within the department, how their salary compares to the department average, and the salary of the next most senior hire.

```sql
SELECT
    employee_name,
    department,
    hire_date,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_rank,
    ROUND(AVG(salary) OVER (PARTITION BY department), 2) AS dept_avg_salary,
    salary - ROUND(AVG(salary) OVER (PARTITION BY department), 2) AS diff_from_dept_avg,
    LAG(salary) OVER (PARTITION BY department ORDER BY hire_date) AS prev_hire_salary
FROM employees
ORDER BY department, dept_salary_rank;
```

This single query — impossible to write cleanly with plain `GROUP BY` — demonstrates exactly why window functions are a core SQL skill for analytics, dashboards, and reporting.

---

## 11. Quick Reference Cheat Sheet

| Function | Category | What it does |
|---|---|---|
| `SUM() / AVG() / COUNT() / MIN() / MAX() OVER()` | Aggregate | Aggregate value per row, without collapsing rows |
| `ROW_NUMBER()` | Ranking | Unique sequential number per partition |
| `RANK()` | Ranking | Same value → same rank, gaps after ties |
| `DENSE_RANK()` | Ranking | Same value → same rank, no gaps |
| `NTILE(n)` | Ranking | Splits rows into `n` equal buckets |
| `LAG(col, n)` | Value | Value from `n` rows before |
| `LEAD(col, n)` | Value | Value from `n` rows after |
| `FIRST_VALUE(col)` | Value | First value in the window frame |
| `LAST_VALUE(col)` | Value | Last value in the window frame (needs explicit frame!) |

---

## 12. Key Takeaways

- Window functions add calculated columns **without reducing the number of rows** — unlike `GROUP BY`.
- `PARTITION BY` = "group rows for the calculation" (but keep them all visible).
- `ORDER BY` inside `OVER()` = "the order in which rows are processed" — essential for running totals, ranks, and `LAG`/`LEAD`.
- The frame clause (`ROWS BETWEEN ...`) gives precise control over moving averages, running totals, and first/last-value lookups.
- You can't filter directly on a window function with `WHERE` — use a CTE or subquery instead.