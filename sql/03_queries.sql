-- BASIC QUERIES
--1. list all students with their department names
SELECT student_id,student_name,s.department_id,d.department_name
FROM students AS s
INNER JOIN departments AS d
ON s.department_id = d.department_id;

--2.finding if any student has not given any department
SELECT student_id,student_name,s.department_id,d.department_name
FROM students AS s
LEFT JOIN departments AS d
              ON s.department_id = d.department_id;

--3. finding count of students in each department
SELECT department_name,count(*)
FROM students AS s
JOIN departments AS d
ON s.department_id = d.department_id
GROUP BY department_name;

--4. finding student with no entry in marks table
SELECT student_name FROM students
                             LEFT JOIN marks
                                       On students.student_id = marks.student_id
WHERE marks.student_id IS NULL ;

--5. finding courses with  no entry in marks table
SELECT course_name FROM courses AS c
                            LEFT JOIN marks AS m
                                      ON c.course_id = m.course_id
WHERE m.course_id IS NULL;

--6. finding departments with no entries in courses table
SELECT department_name FROM departments AS d
                                LEFT JOIN courses AS c
                                          ON d.department_id = c.department_id
WHERE c.department_id IS NULL ;

--7. average score of each course with more than 3 students
SELECT course_name,round(AVG(score),2)
FROM marks m
JOIN courses c
ON m.course_id = c.course_id
GROUP BY course_name
HAVING count(score) > 3;

--INTERMEDIATE QUERIES
--1. average score each student across all their courses
SELECT student_name,ROUND(AVG(score),2)
FROM marks m
JOIN students s
ON m.student_id = s.student_id
GROUP BY student_name;

--2. students with more score than the average of the course
SELECT student_name,round(AVG(score),2) AS "average" FROM students s
JOIN marks m
ON s.student_id = m.student_id
GROUP BY student_name
HAVING avg(score) > (SELECT AVG(score) FROM marks);

--3. departments having at least one student scoring above 90
SELECT distinct department_name FROM students
JOIN departments d on students.department_id = d.department_id
WHERE student_id = any(SELECT DISTINCT marks.student_id FROM marks
                          WHERE score > 90);

SELECT d.department_name
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM students s
             JOIN marks m
                  ON s.student_id = m.student_id
    WHERE s.department_id = d.department_id
      AND m.score > 90
);

-- Window functions and CTE's
--1. rank students by average score within each department
WITH avg_scores AS (
    SELECT department_id,s.student_id,student_name,ROUND(AVG(score),2) AS avg
    FROM marks m
             JOIN students s
                  ON m.student_id = s.student_id
    GROUP BY s.student_id,student_name,department_id
)
SELECT department_id,student_name,avg,rank() OVER (PARTITION BY department_id ORDER BY avg desc)
FROM avg_scores;

SELECT course_id,avg(score) FROM marks
GROUP BY course_id;
--2. top 2 students per department using row number
WITH avg_scores AS (
    SELECT department_id,s.student_id,student_name,ROUND(AVG(score),2) AS avg
    FROM marks m
             JOIN students s
                  ON m.student_id = s.student_id
    GROUP BY s.student_id,student_name,department_id
),
ranking AS(
    select department_id,student_name,avg,row_number() over (partition by department_id order by avg desc) AS rank from avg_scores
)
select department_name,student_name,avg,rank FROM ranking
JOIN departments ON ranking.department_id = departments.department_id
WHERE rank <=2
order by department_name;

--- 3.Each mark compared with that course's average (AVG() OVER (PARTITION BY course_id)).
WITH average_scores AS (
    SELECT student_name,course_name,score,AVG(score) OVER(partition by marks.course_id) AS course_avg FROM marks
    JOIN public.students s on marks.student_id = s.student_id
    JOIN public.courses c on marks.course_id = c.course_id
)
SELECT student_name,course_name,score,course_avg,
       CASE
           WHEN score > course_avg THEN 'above average'
           WHEN score = course_avg THEN 'average'
           ELSE 'below average'
        END AS status
       FROM average_scores;

--4.Running total of scores per student ordered by course_id.
SELECT student_id,course_id,score,SUM(score) OVER (partition by student_id ORDER BY marks.course_id )
from marks;

--VIEWS AND TRANSACTIONS
--1. create a view on student_averages
CREATE VIEW student_averages AS
SELECT student_id,AVG(score) FROM marks
GROUP BY student_id;
SELECT * FROM student_averages;

--2. create a materialized view
CREATE MATERIALIZED VIEW department_summary as
SELECT d.department_id,department_name,count(DISTINCT s.student_id),avg(m.score)
FROM departments d
LEFT JOIN students s on d.department_id = s.department_id
LEFT JOIN marks m on s.student_id = m.student_id
GROUP BY d.department_id, department_name;

--3. creating a transaction
BEGIN;
UPDATE marks
SET score = score - 10
WHERE student_id = 1;

ROLLBACK;
SELECT * FROM marks;
