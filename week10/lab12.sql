\set ON_ERROR_STOP on
\pset pager off
SET search_path TO lab_data;
\echo '12.1 SELECT all / selected columns / calculated alias'
SELECT * FROM employee ORDER BY employee_id;
SELECT name, department_id FROM employee ORDER BY employee_id;
SELECT name, salary, salary * 0.10 AS potential_bonus FROM employee ORDER BY employee_id;
\echo '12.2 WHERE: comparisons, AND, OR, NOT, BETWEEN, NULL'
SELECT name, salary FROM employee WHERE department_id = 1 ORDER BY employee_id;
SELECT name FROM employee WHERE salary > 5000 AND department_id = 1;
SELECT name FROM employee WHERE department_id = 2 OR salary >= 12500 ORDER BY employee_id;
SELECT name FROM employee WHERE NOT department_id = 1 ORDER BY employee_id;
SELECT product, spend FROM purchases WHERE spend BETWEEN 20 AND 50;
SELECT name, manager_id FROM employee WHERE manager_id IS NULL ORDER BY employee_id;
SELECT name FROM employee WHERE manager_id IS NOT NULL ORDER BY employee_id;
\echo '12.3 LIKE percent, underscore, ILIKE'
SELECT name FROM employee WHERE name LIKE 'O%';
SELECT name FROM employee WHERE name LIKE '_va%';
SELECT email FROM users WHERE email ILIKE '%@GMAIL.COM' ORDER BY user_id;
\echo '12.4 Regular expressions: ~, ~*, !~, !~*'
SELECT name FROM employee WHERE name ~ '^[AB]';
SELECT email FROM users WHERE email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$' ORDER BY user_id;
SELECT name FROM employee WHERE name !~ '^[AB]' ORDER BY employee_id;
SELECT email FROM users WHERE email !~* '@GMAIL\.COM$' ORDER BY user_id;
\echo '12.5 IN: values / subquery; EXISTS'
SELECT name, department_id FROM employee WHERE department_id IN (1, 3) ORDER BY employee_id;
SELECT artist_name FROM artists WHERE artist_id IN (SELECT artist_id FROM songs) ORDER BY artist_id;
SELECT artist_name FROM artists a
WHERE EXISTS (SELECT 1 FROM songs s WHERE s.artist_id = a.artist_id) ORDER BY artist_id;
\echo '12.6 CASE (salary thresholds adapted to source amounts)'
SELECT name, salary, CASE WHEN salary > 10000 THEN 'Senior'
    WHEN salary BETWEEN 5000 AND 10000 THEN 'Mid-Level' ELSE 'Junior' END AS employee_level
FROM employee ORDER BY salary DESC, employee_id;
\echo '12.7 CTE: salaries above department average'
WITH department_averages AS (
    SELECT department_id, AVG(salary) AS avg_salary FROM employee GROUP BY department_id
)
SELECT e.name, e.salary, e.department_id, ROUND(da.avg_salary, 2) AS avg_salary
FROM employee e JOIN department_averages da USING (department_id)
WHERE e.salary > da.avg_salary ORDER BY e.employee_id;
