CREATE TABLE departments(
    department_id INT primary key ,
    department_name VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE students(
    student_id INT primary key,
    student_name VARCHAR(20) NOT NULL ,
    department_id INT REFERENCES departments(department_id) ON DELETE RESTRICT
);

CREATE TABLE courses(
    course_id INT PRIMARY KEY,
    course_name VARCHAR(20) NOT NULL,
    department_id INt REFERENCES departments(department_id) ON DELETE RESTRICT
);

CREATE TABLE marks(
    student_id INT REFERENCES students(student_id) ON DELETE CASCADE ,
    course_id INT REFERENCES courses(course_id) ON DELETE CASCADE ,
    score INT CHECK ( score >= 0  AND score <= 100),
    PRIMARY KEY (student_id,course_id)
);

--if insert doesnt contain any id its generated automatically
ALTER TABLE departments
ALTER COLUMN department_id
ADD GENERATED ALWAYS AS IDENTITY;

ALTER TABLE students
    ALTER COLUMN student_id
        ADD GENERATED ALWAYS AS IDENTITY;

ALTER TABLE courses
    ALTER COLUMN course_id
        ADD GENERATED ALWAYS AS IDENTITY;

ALTER TABLE courses
ALTER COLUMN course_name TYPE VARCHAR(40);