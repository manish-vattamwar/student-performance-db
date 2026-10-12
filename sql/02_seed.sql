--departments
--since added generated as always as identity it will generate automatically.
insert into departments (department_name)
values ('Computer science'),
       ('Electronics'),
       ('Mechanical'),
       ('Civil');

-- Courses
INSERT INTO courses (course_name, department_id)
SELECT v.course_name, d.department_id
FROM (
         VALUES
             ('Database Systems', 'Computer Science'),
             ('Data Structures', 'Computer Science'),
             ('Operating Systems', 'Computer Science'),
             ('Digital Electronics', 'Electronics'),
             ('Circuit Theory', 'Electronics'),
             ('Thermodynamics', 'Mechanical'),
             ('Engineering Mechanics', 'Mechanical'),
             ('Environmental Engineering', 'Civil')
     ) AS v(course_name, department_name)
         JOIN departments d
              ON d.department_name = v.department_name;

-- Students
INSERT INTO students (student_name, department_id)
SELECT v.student_name, d.department_id
FROM (
         VALUES
             ('Aarav Sharma', 'Computer Science'),
             ('Diya Patel', 'Computer Science'),
             ('Rohan Mehta', 'Computer Science'),
             ('Ananya Rao', 'Computer Science'),
             ('Kabir Singh', 'Computer Science'),

             ('Ishita Verma', 'Electronics'),
             ('Aditya Reddy', 'Electronics'),
             ('Meera Nair', 'Electronics'),
             ('Arjun Das', 'Electronics'),

             ('Saanvi Gupta', 'Mechanical'),
             ('Vikram Joshi', 'Mechanical'),
             ('Priya Menon', 'Mechanical'),
             ('Karan Shah', 'Mechanical'),

             ('Neha Kumar', 'Civil'),
             ('Rahul Iyer', 'Civil')
     ) AS v(student_name, department_name)
         JOIN departments d
              ON d.department_name = v.department_name;

-- Marks
INSERT INTO marks (student_id, course_id, score)
SELECT
    s.student_id,
    c.course_id,
    v.score
FROM (
         VALUES
             ('Aarav Sharma', 'Database Systems', 95),
             ('Aarav Sharma', 'Data Structures', 88),
             ('Aarav Sharma', 'Operating Systems', 91),

             ('Diya Patel', 'Database Systems', 92),
             ('Diya Patel', 'Data Structures', 96),
             ('Diya Patel', 'Operating Systems', 89),

             ('Rohan Mehta', 'Database Systems', 78),
             ('Rohan Mehta', 'Data Structures', 82),
             ('Rohan Mehta', 'Operating Systems', 80),

             ('Ananya Rao', 'Database Systems', 95),
             ('Ananya Rao', 'Data Structures', 88),
             ('Ananya Rao', 'Operating Systems', 91),

             ('Kabir Singh', 'Database Systems', 67),
             ('Kabir Singh', 'Data Structures', 74),

             ('Ishita Verma', 'Digital Electronics', 93),
             ('Ishita Verma', 'Circuit Theory', 90),

             ('Aditya Reddy', 'Digital Electronics', 81),
             ('Aditya Reddy', 'Circuit Theory', 85),

             ('Meera Nair', 'Digital Electronics', 88),
             ('Meera Nair', 'Circuit Theory', 92),

             ('Arjun Das', 'Digital Electronics', 72),
             ('Arjun Das', 'Circuit Theory', 75),

             ('Saanvi Gupta', 'Thermodynamics', 91),
             ('Saanvi Gupta', 'Engineering Mechanics', 87),

             ('Vikram Joshi', 'Thermodynamics', 83),
             ('Vikram Joshi', 'Engineering Mechanics', 80),

             ('Priya Menon', 'Thermodynamics', 91),
             ('Priya Menon', 'Engineering Mechanics', 87),

             ('Karan Shah', 'Thermodynamics', 76),
             ('Karan Shah', 'Engineering Mechanics', 79),

             ('Neha Kumar', 'Database Systems', 85)
     ) AS v(student_name, course_name, score)
         JOIN students s
              ON s.student_name = v.student_name
         JOIN courses c
              ON c.course_name = v.course_name;


--check
SELECT 'departments' as "table",count(*) AS Count FROM departments
UNION
SELECT 'students',count(*) FROM students
UNION
SELECT 'courses',Count(*) FROM courses
UNION
SELECT 'marks',count(*) from marks;

