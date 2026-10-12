-- 00_reset.sql
-- WARNING: This deletes the project's existing data and objects.

DROP MATERIALIZED VIEW IF EXISTS department_summary;
DROP VIEW IF EXISTS student_averages;

DROP TABLE IF EXISTS marks;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS departments;