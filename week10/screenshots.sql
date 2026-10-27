-- screenshot: pgadmin-lab12-case.jpg | Senior
-- Lab 12 | CASE and calculated columns | Azim Mamatbaev
SELECT name,salary,salary*0.10 AS potential_bonus,
 CASE WHEN salary>10000 THEN 'Senior'
      WHEN salary>=5000 THEN 'Mid-Level' ELSE 'Junior' END AS level
FROM lab_data.employee ORDER BY salary DESC,employee_id;

-- screenshot: pgadmin-lab12-cte.jpg | Olivia Smith
-- Lab 12 | CTE: salary above department average
WITH averages AS (
 SELECT department_id,AVG(salary) AS average
 FROM lab_data.employee GROUP BY department_id
)
SELECT e.name,e.salary,e.department_id,ROUND(a.average,2) AS department_average
FROM lab_data.employee e JOIN averages a USING(department_id)
WHERE e.salary>a.average ORDER BY e.employee_id;
