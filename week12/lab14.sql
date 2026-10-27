\set ON_ERROR_STOP on
\pset pager off
SET search_path TO lab_data;
\echo '14.1 INNER JOIN: matching artists and songs'
SELECT a.artist_name, s.name AS song FROM artists a
INNER JOIN songs s USING (artist_id) ORDER BY a.artist_id,s.song_id;
\echo '14.2 LEFT JOIN: Bad Bunny has no song in the published input'
SELECT a.artist_name, s.name AS song FROM artists a
LEFT JOIN songs s USING (artist_id) ORDER BY a.artist_id,s.song_id;
\echo '14.3 RIGHT JOIN: all artists on the right'
SELECT a.artist_name, s.name AS song FROM songs s
RIGHT JOIN artists a USING (artist_id) ORDER BY a.artist_id,s.song_id;
\echo '14.4 FULL OUTER JOIN: include unmatched records'
SELECT a.artist_name, s.name AS song FROM artists a
FULL OUTER JOIN songs s USING (artist_id) ORDER BY a.artist_id,s.song_id;
-- Product sets have unmatched rows on BOTH sides without inventing source rows.
WITH a AS (SELECT DISTINCT product FROM purchases WHERE user_id = 123),
     b AS (SELECT DISTINCT product FROM purchases WHERE user_id <> 123)
SELECT a.product AS user_123_product, b.product AS other_users_product
FROM a FULL JOIN b USING (product) ORDER BY COALESCE(a.product,b.product);
\echo '14.5 CROSS JOIN: 3 artists x 2 categories = 6 rows'
SELECT a.artist_name,c.category FROM artists a
CROSS JOIN (SELECT DISTINCT category FROM purchases) c ORDER BY 1,2;
\echo '14.6 Multiple tables / many-to-many through enrollment junction'
SELECT s.name,c.course_id,e.semester,e.grade
FROM lab8.students s JOIN lab8.enrollments e USING (student_id)
JOIN lab8.courses c USING (course_id)
WHERE e.grade IS NOT NULL ORDER BY s.student_id,c.course_id,e.semester;
\echo '14.7 SELF JOIN: employees and managers; missing managers stay NULL'
SELECT e.name AS employee,m.name AS manager FROM employee e
LEFT JOIN employee m ON e.manager_id=m.employee_id ORDER BY e.employee_id;
\echo '14.8 JOIN with conditions and aliases'
SELECT u.city,t.order_id,t.price*t.quantity AS total
FROM users u INNER JOIN trades t ON u.user_id=t.user_id
    AND t.status='Completed'
WHERE t.traded_at >= '2022-08-01' AND t.price*t.quantity > 100 ORDER BY t.order_id;
\echo '14.9 One-to-one and one-to-many'
SELECT s.name,p.profile_id FROM lab8.students s
LEFT JOIN lab8.student_profiles p USING (student_id) ORDER BY s.student_id;
SELECT a.artist_name,COUNT(s.song_id) AS songs FROM artists a
LEFT JOIN songs s USING (artist_id) GROUP BY a.artist_id,a.artist_name ORDER BY a.artist_id;
\echo '14.10 Indexes for join columns; NULL anti-join'
CREATE INDEX idx_songs_artist_id ON songs(artist_id);
CREATE INDEX idx_trades_user_id ON trades(user_id);
CREATE INDEX idx_employee_manager_id ON employee(manager_id);
SELECT a.artist_name FROM artists a LEFT JOIN songs s USING (artist_id)
WHERE s.song_id IS NULL;
\echo '14.11 Cartesian-product pitfall: 12 combinations vs 4 matched rows'
SELECT (SELECT COUNT(*) FROM artists,songs) AS cartesian_rows,
       (SELECT COUNT(*) FROM artists JOIN songs USING(artist_id)) AS correct_rows;
\echo '14.12 DataLemur recommended practice: Well Paid Employees'
SELECT e.employee_id,e.name FROM employee e JOIN employee m ON e.manager_id=m.employee_id
WHERE e.salary>m.salary ORDER BY e.employee_id;
