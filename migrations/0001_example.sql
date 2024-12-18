-- Migration number: 0001 	 2024-12-18T05:27:49.870Z
CREATE TABLE students (
    student_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    date_of_birth DATE,
    major TEXT
);

CREATE TABLE professors (
    professor_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    department TEXT NOT NULL
);

CREATE TABLE courses (
    course_id INTEGER PRIMARY KEY,
    course_name TEXT NOT NULL,
    credits INTEGER NOT NULL,
    professor_id INTEGER,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id)
);

CREATE TABLE enrollments (
    enrollment_id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrollment_date DATE NOT NULL,
    grade TEXT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO students (student_id, first_name, last_name, date_of_birth, major)
VALUES 
(1, 'Alice', 'Smith', '2000-05-14', 'Computer Science'),
(2, 'Bob', 'Johnson', '1999-11-22', 'Mathematics'),
(3, 'Carol', 'Lee', '2001-03-10', 'Physics');

INSERT INTO professors (professor_id, first_name, last_name, department)
VALUES 
(1, 'Dr. Emily', 'Brown', 'Computer Science'),
(2, 'Dr. James', 'White', 'Mathematics'),
(3, 'Dr. Sarah', 'Green', 'Physics');

INSERT INTO courses (course_id, course_name, credits, professor_id)
VALUES 
(101, 'Introduction to Programming', 3, 1),
(102, 'Data Structures', 4, 1),
(201, 'Calculus I', 4, 2),
(202, 'Linear Algebra', 3, 2),
(301, 'Quantum Mechanics', 4, 3);

INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date, grade)
VALUES 
(1, 1, 101, '2023-09-01', 'A'),
(2, 1, 102, '2023-09-01', 'B+'),
(3, 2, 201, '2023-09-01', 'A-'),
(4, 2, 202, '2023-09-01', 'B'),
(5, 3, 301, '2023-09-01', 'A');
