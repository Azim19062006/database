-- screenshot: pgadmin-lab15-ranking.jpg | William Davis
-- Lab 15 | Ranking with ties and PARTITION BY
SELECT name,department_id,salary,
 ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary DESC,employee_id) AS row_no,
 RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS rank,
 DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS dense_rank
FROM lab_data.employee ORDER BY department_id,salary DESC,employee_id;

-- screenshot: pgadmin-lab15-pivot.jpg | refrigerator
-- Lab 15 | PIVOT with conditional aggregation | Source purchase amounts
SELECT product,year_2021,year_2022 FROM lab15.pivoted_sales ORDER BY product;
