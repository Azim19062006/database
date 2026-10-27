\set ON_ERROR_STOP on
\pset pager off
SET search_path TO lab_data;
\echo '13.1 COUNT(*), COUNT(column), COUNT(DISTINCT), NULL handling'
SELECT COUNT(*) AS total_employees, COUNT(manager_id) AS known_manager_ids,
       COUNT(*) - COUNT(manager_id) AS null_manager_ids,
       COUNT(DISTINCT department_id) AS departments FROM employee;
SELECT SUM(salary) AS total_salary, ROUND(AVG(salary),2) AS avg_salary,
       MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM employee;
SELECT SUM(manager_id) AS sum_ignores_null, AVG(manager_id) AS avg_ignores_null,
       COUNT(manager_id) AS count_non_null FROM employee;
\echo '13.2 SUM / AVG / MIN / MAX by group'
SELECT category, COUNT(*) AS purchases, SUM(spend) AS total,
       ROUND(AVG(spend),2) AS average, MIN(spend) AS minimum, MAX(spend) AS maximum
FROM purchases GROUP BY category ORDER BY category;
SELECT category, MAX(transaction_date) AS most_recent FROM purchases GROUP BY category;
\echo '13.3 STRING_AGG and ARRAY_AGG with ordering'
SELECT department_id, STRING_AGG(name, ', ' ORDER BY name) AS names,
       ARRAY_AGG(salary ORDER BY salary) AS salaries
FROM employee GROUP BY department_id ORDER BY department_id;
\echo '13.4 Statistical aggregates'
SELECT department_id, ROUND(STDDEV(salary),2) AS stddev,
       ROUND(VARIANCE(salary),2) AS variance
FROM employee GROUP BY department_id ORDER BY department_id;
SELECT ROUND(CORR(quantity,price)::numeric,4) AS quantity_price_correlation FROM trades;
\echo '13.5 Multiple grouping columns and expressions'
SELECT EXTRACT(YEAR FROM transaction_date) AS year,
       EXTRACT(QUARTER FROM transaction_date) AS quarter,
       COUNT(*) AS purchases, SUM(spend) AS revenue
FROM purchases GROUP BY 1,2 ORDER BY 1,2;
SELECT CASE WHEN salary < 5000 THEN 'Under 5000'
            WHEN salary <= 10000 THEN '5000-10000' ELSE 'Over 10000' END AS salary_group,
       COUNT(*) AS employees, ROUND(AVG(salary),2) AS avg_salary
FROM employee GROUP BY 1 ORDER BY MIN(salary);
\echo '13.6 HAVING vs WHERE; multiple HAVING conditions'
SELECT department_id, COUNT(*) AS employees FROM employee
GROUP BY department_id HAVING COUNT(*) > 1 ORDER BY department_id;
SELECT product, ROUND(AVG(spend),2) AS avg_spend, COUNT(*) AS purchases FROM purchases
GROUP BY product HAVING AVG(spend) > 150 AND COUNT(*) >= 2 ORDER BY product;
\echo '13.7 Aggregate vs window: same average, different number of rows'
SELECT department_id, ROUND(AVG(salary),2) AS dept_average
FROM employee GROUP BY department_id ORDER BY department_id;
SELECT employee_id, name, department_id, salary,
       ROUND(AVG(salary) OVER (PARTITION BY department_id),2) AS dept_average
FROM employee ORDER BY department_id,employee_id;
\echo '13.8 Combined / conditional aggregates and percentage'
SELECT department_id, COUNT(*) AS employees, MIN(salary), MAX(salary),
       ROUND(AVG(salary),2) AS average, ROUND(STDDEV(salary),2) AS stddev,
       COUNT(CASE WHEN salary > 5000 THEN 1 END) AS earn_over_5000,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employee),2) AS percentage
FROM employee GROUP BY department_id ORDER BY department_id;
