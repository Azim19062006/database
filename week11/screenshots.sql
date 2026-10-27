-- screenshot: pgadmin-lab13-aggregates.jpg | electronics
-- Lab 13 | COUNT, SUM, AVG, MIN, MAX | Published DataLemur rows
SELECT category,COUNT(*) AS purchases,SUM(spend) AS total,
 ROUND(AVG(spend),2) AS average,MIN(spend) AS minimum,MAX(spend) AS maximum
FROM lab_data.purchases GROUP BY category ORDER BY category;

-- screenshot: pgadmin-lab13-statistics.jpg | 3695.00
-- Lab 13 | GROUP BY, statistics, conditional aggregation and percentage
SELECT department_id,COUNT(*) AS employees,ROUND(AVG(salary),2) AS average,
 ROUND(STDDEV(salary),2) AS stddev,ROUND(VARIANCE(salary),2) AS variance,
 COUNT(CASE WHEN salary>5000 THEN 1 END) AS over_5000,
 ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM lab_data.employee),2) AS percent
FROM lab_data.employee GROUP BY department_id ORDER BY department_id;
