CREATE DATABASE college_db;
/*TASK 1.1*/
CREATE TABLE students(
student_id BIGINT,
FullName varchar(255),
email varchar(255) UNIQUE,
Age int,
join_date DATE,
active_flag BIT DEFAULT '1',
PRIMARY KEY (student_id)
);
/*TASK 1.2*/
CREATE TABLE courses(
course_id INT,
course_name varchar(255) NOT NULL,
fees DECIMAL
);
/*TASK 1.3*/
CREATE TABLE enrollments(
enroll_id BIGINT PRIMARY KEY,
student_id BIGINT,
course_id INT,
enroll_timestamp TIMESTAMP
);
/*TASK 2.1*/
INSERT INTO students(student_id,FullName,email,Age,join_date,active_flag)
VALUES
(1001, 'Ashmitha', 'ashmitha.@gmail.com', 21, '2024-06-15', 1),
(1002, 'Rahul Sharma', 'rahul.sharma@yahoo.com', 22, '2024-07-01', 1),
(1003, 'Sneha Patel', 'sneha.patel@hotmail.com', 20, '2024-05-20', 1),
(1004, 'Arjun Kumar', 'arjun.kumar@gmail.com', 23, '2024-08-10', 0),
(1005, 'Priya Singh', 'priya.singh@yahoo.com', 19, '2024-04-12', 1),
(1006, 'Vikram Dasari', 'vikram.dasari@gmail.com', 24, '2024-09-05', 1),
(1007, 'Neha Joshi', 'neha.joshi@hotmail.com', 22, '2024-03-18', 1),
(1008, 'Kiran Mehta', 'kiran.mehta@gmail.com', 21, '2024-02-25', 0),
(1009, 'Anjali Verma', 'anjali.verma@yahoo.com', 20, '2024-01-30', 1),
(1010, 'Suresh Rao', 'suresh.rao@gmail.com', 23, '2024-10-01', 1);
/*TASK 2.2*/
INSERT INTO courses(course_id,course_name,fees)
VALUES
(1, 'Java Programming', 15000.00),
(2, 'Python for Data Science', 18000.00),
(3, 'Web Development', 20000.00),
(4, 'Database Management Systems', 12000.00),
(5, 'Artificial Intelligence Basics', 25000.00);
/*TASK 2.3*/
INSERT INTO enrollments(enroll_id,student_id,course_id,enroll_timestamp)
VALUES
(5001, 1001, 1, DEFAULT),
(5002, 1001, 3, DEFAULT),
(5003, 1002, 2, DEFAULT),
(5004, 1002, 4, DEFAULT),
(5005, 1003, 1, DEFAULT),
(5006, 1003, 5, DEFAULT),
(5007, 1004, 3, DEFAULT),
(5008, 1005, 2, DEFAULT),
(5009, 1005, 4, DEFAULT),
(5010, 1006, 5, DEFAULT),
(5011, 1006, 1, DEFAULT),
(5012, 1007, 3, DEFAULT),
(5013, 1008, 4, DEFAULT),
(5014, 1009, 2, DEFAULT),
(5015, 1010, 5, DEFAULT);
/*TASK 3.1*/
INSERT INTO students(student_id,FullName,email,Age,join_date,active_flag)
VALUES
(1011, 'Ramesh Naidu', 'ramesh.naidu@gmail.com', 22, '2024-11-01', 1),
(1012, 'Divya Sri', 'divya.sri@yahoo.com', 20, '2024-11-05', 1),
(1013, 'Sanjay Kumar', 'sanjay.kumar@hotmail.com', 23, '2024-11-10', 0);
INSERT INTO courses (course_id, course_name, fees)
VALUES
(6, 'Full Stack AI & Cloud Engineering', 150000.00);
INSERT INTO enrollments (enroll_id, student_id, course_id, enroll_timestamp)
VALUES
(5030, 1011, 1, DEFAULT),
(5031, 1011, 3, DEFAULT),
(5032, 1012, 2, DEFAULT),
(5033, 1012, 4, DEFAULT);
/*TASK 3.2*/
SELECT * FROM students;
SELECT FullName, email FROM students;
SELECT Age FROM students 
ORDER BY Age DESC;
SELECT  TOP 5 join_date FROM students;
SELECT DISTINCT Age FROM students;
SELECT DISTINCT course_name FROM courses;
/*TASK 3.3*/
UPDATE students
SET Age=26
WHERE student_id=1006;
UPDATE students
SET active_flag=0
WHERE student_id IN (1006,1007);
UPDATE courses
SET fees=fees * 1.10;
DELETE FROM students WHERE student_id=1003;
DELETE FROM courses WHERE fees<1000;
SELECT * FROM enrollments;
ALTER TABLE enrollments
ADD enroll_time DATETIME2 DEFAULT SYSDATETIME();
ALTER TABLE enrollments
DROP COLUMN enroll_timestamp;
UPDATE enrollments
SET enroll_time =
CASE enroll_id
    WHEN 5004 THEN '2024-06-01 10:15:00'
    WHEN 5005 THEN '2024-06-03 11:00:00'
    WHEN 5006 THEN '2024-06-05 09:30:00'
    WHEN 5007 THEN '2024-06-07 14:20:00'
    WHEN 5008 THEN '2024-06-10 16:45:00'
    WHEN 5009 THEN '2024-06-12 12:10:00'
    WHEN 5010 THEN '2024-06-15 10:00:00'
    WHEN 5011 THEN '2024-06-18 11:30:00'
    WHEN 5012 THEN '2024-06-20 09:50:00'
    WHEN 5013 THEN '2024-06-22 13:15:00'
    WHEN 5014 THEN '2024-06-25 15:40:00'
    WHEN 5015 THEN '2024-06-28 10:25:00'
    WHEN 5030 THEN '2024-07-01 09:05:00'
    WHEN 5031 THEN '2024-07-03 14:55:00'
    WHEN 5032 THEN '2024-07-05 16:20:00'
    WHEN 5033 THEN '2024-07-07 11:10:00'
END
WHERE enroll_id BETWEEN 5004 AND 5015
   OR enroll_id BETWEEN 5030 AND 5033;
SELECT * FROM enrollments;
DELETE FROM enrollments
WHERE enroll_time < '2024-07-01';
/*TASK 3.4*/
ALTER TABLE students
ALTER COLUMN Fullname varchar(200);
EXEC sp_rename 'students.join_date','registration_date','COLUMN';
ALTER TABLE students
ADD phone_number VARCHAR(15);

DROP TABLE enrollments1;
/*TASK 4.1*/
SELECT Age FROM students
WHERE Age>21;
SELECT FullName FROM students
WHERE active_flag=1;
SELECT course_name FROM courses
WHERE fees BETWEEN 1000 AND 5000;
SELECT * FROM courses;
SELECT FullName FROM students
WHERE Age IN(20,22,25);
/*TASK 4.2*/
SELECT FullName FROM students
WHERE Age>20 AND active_flag=1;
SELECT FullName FROM students
WHERE Age < 20 OR active_flag=0;
SELECT course_name FROM courses
WHERE fees > 2000 AND course_name LIKE '%Data%' ;
/*TASK 4.3*/
SELECT email FROM students
WHERE email LIKE '%gmail.com%';
SELECT course_name FROM courses
WHERE course_name LIKE '%data%';
SELECT course_name FROM courses
WHERE course_name LIKE '%new%';
/*TASK 4.4*/
INSERT INTO students (student_id, FullName, email, Age, registration_date, active_flag)
VALUES
(1014, 'Manoj Krishna', 'manoj.krishna@gmail.com', NULL, '2024-11-15', 1);
SELECT Age FROM students
WHERE Age IS NULL;
SELECT Age FROM students
WHERE Age IS NOT NULL;
/*TASK 5.1*/
SELECT COUNT(student_id)
FROM students
WHERE active_flag=1;
/*TASK 5.2*/
SELECT SUM(fees)
FROM courses
WHERE FEES>20000;
SELECT AVG(fees)
FROM courses;
/*TASK 5.3*/
SELECT MIN(Age)
FROM students;
SELECT MAX(fees)
FROM courses;
SELECT MAX(registration_date) AS oldestjoin_date
FROM students;
SELECT MIN(registration_date) AS Latestjoin_date
FROM students;
/*TASK 5.4*/
SELECT COUNT(active_flag), FullName
FROM students
GROUP BY FullName;
SELECT COUNT(Age), FullName
FROM students
GROUP BY FullName;
SELECT COUNT(fees), course_name
FROM courses
GROUP BY course_name;
/*TASK 5.5*/
SELECT COUNT(course_id), course_id
FROM enrollments
GROUP BY course_id
HAVING COUNT(course_id)>3;
SELECT COUNT(Age), active_flag
FROM students
GROUP BY active_flag
HAVING AVG(Age)>21;
SELECT COUNT(course_id), course_id
FROM enrollments
GROUP BY course_id
HAVING COUNT(course_id)>2;
/*task 6*/
SELECT COUNT(*)
FROM students
WHERE FullName LIKE 'a%';
SELECT * FROM courses
WHERE fees BETWEEN 10500 AND 20000
ORDER BY fees;
SELECT * FROM students
WHERE age IS NOT NULL AND active_flag=0;
SELECT * FROM STUDENTS
WHERE Age>20
ORDER BY Age;
SELECT COUNT(enroll_id), course_id
FROM enrollments
GROUP BY course_id
HAVING COUNT(enroll_id)>=1;


