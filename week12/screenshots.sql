-- screenshot: pgadmin-lab14-left-join.jpg | Bad Bunny
-- Lab 14 | LEFT JOIN: keep the artist without a matching song
SELECT a.artist_name,s.name AS song
FROM lab_data.artists a LEFT JOIN lab_data.songs s USING(artist_id)
ORDER BY a.artist_id,s.song_id;

-- screenshot: pgadmin-lab14-many-to-many.jpg | Bob Smith
-- Lab 14 | Many-to-many: students -> enrollments -> courses
SELECT s.name,c.course_id,e.semester,e.grade
FROM lab8.students s JOIN lab8.enrollments e USING(student_id)
JOIN lab8.courses c USING(course_id)
WHERE e.grade IS NOT NULL ORDER BY s.student_id,c.course_id,e.semester;
