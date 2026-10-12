# Student Performance Database

A normalized PostgreSQL database for tracking students, departments, courses, and marks, with analytical queries for department and student performance.

## Goals

- Design a normalized schema (up to 3NF) with proper keys and constraints.
- Practise joins, aggregates, subqueries, CTEs, and window functions on related tables.
- Write repeatable SQL scripts that rebuild the database from scratch.

## Tech

- PostgreSQL (local, via PostgreSQL.app)
- DataGrip as the SQL client
- Git for version control

## Schema

```
departments (department_id PK, department_name UNIQUE NOT NULL)
students    (student_id PK, student_name NOT NULL, department_id FK -> departments)
courses     (course_id PK, course_name NOT NULL, department_id FK -> departments)
marks       (student_id FK -> students, course_id FK -> courses, score, PK (student_id, course_id))
```

Design notes:

- `marks` is the junction table for the many-to-many relationship between students and courses. Its composite primary key stops the same student being graded twice in the same course.
- `score` gets a `CHECK (score BETWEEN 0 AND 100)` constraint.
- `department_name` is unique, and `student_name` / `course_name` are NOT NULL.
- Decide and document the `ON DELETE` behaviour for each foreign key (NO ACTION, CASCADE, or RESTRICT) and why.

## Stages

### Stage 1: Schema
- [ ] Write `sql/01_schema.sql` with all four tables, keys, and constraints.
- [ ] Verify that invalid inserts fail (score 105, duplicate department name, duplicate student-course pair).

### Stage 2: Seed data
- [ ] Write `sql/02_seed.sql` with at least 4 departments, 15+ students, 8+ courses, and enough marks to make averages meaningful.
- [ ] Include a few edge cases on purpose: a student with no marks, a course with no students, a department with no courses.

### Stage 3: Basic queries
- [ ] List all students with their department names (INNER JOIN).
- [ ] List all students, including those with no department, using LEFT JOIN.
- [ ] Find students with no marks recorded (anti-join with LEFT JOIN ... IS NULL).
- [ ] Average score per course, with courses having fewer than 3 scores filtered out using HAVING.

### Stage 4: Intermediate queries
- [ ] Each student's average score across all courses (GROUP BY).
- [ ] Students scoring above the overall average (scalar subquery).
- [ ] Departments that have at least one student scoring above 90 (EXISTS).

### Stage 5: Window functions and CTEs
- [ ] Rank students by average score within each department using RANK().
- [ ] Top 2 students per department using ROW_NUMBER() inside a CTE.
- [ ] Each mark compared with that course's average (AVG() OVER (PARTITION BY course_id)).
- [ ] Running total of scores per student ordered by course_id.

### Stage 6: Views and transactions
- [ ] Create a view `student_averages` for reuse.
- [ ] Create a materialized view `department_summary` and practise refreshing it after new marks are added.
- [ ] Write a transaction that updates a student's score and then rolls back, and verify the result.

### Stage 7: Reproducibility and docs
- [ ] Write `sql/00_reset.sql` to drop and recreate everything from scratch.
- [ ] Put every query from Stages 3 to 5 into `sql/03_queries.sql`, each with a comment that states the question it answers.
- [ ] Write a README covering setup, how to run the scripts, and sample output.

## Folder structure

```
student-performance-db/
├── README.md
├── plan.md
└── sql/
    ├── 00_reset.sql
    ├── 01_schema.sql
    ├── 02_seed.sql
    └── 03_queries.sql
```

## Definition of done

- Running `00_reset.sql`, then `01_schema.sql`, then `02_seed.sql` rebuilds the database without errors.
- Every query in `03_queries.sql` runs and its output matches what you expect by hand for the seed data.
- Constraints reject bad data.
- The README lets someone else set it up in under 10 minutes.

## Git setup

```bash
git init
git add .
git commit -m "Initial plan for student performance database"
git branch -M main
git remote add origin https://github.com/manish-vattamwar/student-performance-db.git
git push -u origin main
```

Create the empty repository on GitHub first, without a README or .gitignore, so the first push doesn't conflict.

## Progress log

- Plan created.
