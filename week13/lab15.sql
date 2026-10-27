\set ON_ERROR_STOP on
\pset pager off
SET search_path TO lab_data;
\echo '15.1 Scalar, row and table subqueries'
SELECT name,salary FROM employee WHERE salary>(SELECT AVG(salary) FROM employee) ORDER BY employee_id;
SELECT name,department_id,salary FROM employee
WHERE (department_id,salary) IN (SELECT department_id,MAX(salary) FROM employee GROUP BY department_id)
ORDER BY employee_id;
SELECT department_id,total_salary FROM (
    SELECT department_id,SUM(salary) AS total_salary FROM employee GROUP BY department_id
) totals WHERE total_salary>10000 ORDER BY department_id;
\echo '15.2 Named CTE'
WITH category_sales AS (SELECT category,SUM(spend) AS total FROM purchases GROUP BY category)
SELECT category,total FROM category_sales WHERE total>500 ORDER BY category;
\echo '15.3 Recursive CTE: source hierarchy, roots have NULL manager'
WITH RECURSIVE org_chart AS (
    SELECT employee_id,name,manager_id,0 AS depth FROM employee WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id,e.name,e.manager_id,o.depth+1 FROM employee e
    JOIN org_chart o ON e.manager_id=o.employee_id
)
SELECT * FROM org_chart ORDER BY depth,employee_id;
SELECT e.employee_id,e.manager_id AS absent_manager FROM employee e
WHERE manager_id IS NOT NULL AND NOT EXISTS
    (SELECT 1 FROM employee m WHERE m.employee_id=e.manager_id) ORDER BY employee_id;
\echo '15.4 UNION and UNION ALL'
SELECT product FROM purchases WHERE user_id=123
UNION SELECT product FROM purchases WHERE user_id<>123 ORDER BY product;
SELECT product FROM purchases WHERE user_id=123
UNION ALL SELECT product FROM purchases WHERE user_id<>123 ORDER BY product;
\echo '15.5 INTERSECT and EXCEPT'
SELECT product FROM purchases WHERE user_id=123
INTERSECT SELECT product FROM purchases WHERE user_id<>123;
SELECT product FROM purchases WHERE user_id=123
EXCEPT SELECT product FROM purchases WHERE user_id<>123;
\echo '15.6 Window ranking, aggregate windows, LAG / LEAD'
SELECT name,department_id,salary,
       ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary DESC,employee_id) AS row_no,
       RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS rank,
       DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS dense_rank
FROM employee ORDER BY department_id,salary DESC,employee_id;
SELECT employee_id,salary,SUM(salary) OVER(PARTITION BY department_id) AS dept_total,
       ROUND(AVG(salary) OVER(PARTITION BY department_id),2) AS dept_avg,
       LAG(salary) OVER(ORDER BY employee_id) AS previous,
       LEAD(salary) OVER(ORDER BY employee_id) AS next
FROM employee ORDER BY employee_id;
\echo '15.7 PIVOT using conditional aggregation; source has 2021 and 2022 only'
CREATE SCHEMA lab15;
CREATE TABLE lab15.pivoted_sales AS
SELECT product,
       SUM(CASE WHEN EXTRACT(YEAR FROM transaction_date)=2021 THEN spend ELSE 0 END) AS year_2021,
       SUM(CASE WHEN EXTRACT(YEAR FROM transaction_date)=2022 THEN spend ELSE 0 END) AS year_2022
FROM purchases GROUP BY product;
SELECT * FROM lab15.pivoted_sales ORDER BY product;
\echo '15.8 UNPIVOT using UNION ALL'
SELECT product,2021 AS year,year_2021 AS spend FROM lab15.pivoted_sales
UNION ALL SELECT product,2022,year_2022 FROM lab15.pivoted_sales ORDER BY product,year;
\echo '15.9 FILTER and custom sorting with CASE'
SELECT employee_id,department_id,SUM(salary) OVER(PARTITION BY department_id) AS dept_total,
       ROUND(AVG(salary) FILTER(WHERE salary>5000) OVER(),2) AS avg_over_5000
FROM employee ORDER BY employee_id;
SELECT name,salary FROM employee
ORDER BY CASE department_id WHEN 3 THEN 1 WHEN 1 THEN 2 ELSE 3 END,salary DESC,employee_id;
\echo '15.10 Optimization: index, statistics, EXPLAIN / EXPLAIN ANALYZE, LIMIT'
CREATE INDEX idx_purchases_category ON purchases(category);
ANALYZE employee;
ANALYZE purchases;
EXPLAIN SELECT employee_id,name FROM employee WHERE manager_id=8;
EXPLAIN (ANALYZE,BUFFERS) SELECT employee_id,name FROM employee WHERE manager_id=8;
SELECT employee_id,name FROM employee ORDER BY employee_id LIMIT 3;
