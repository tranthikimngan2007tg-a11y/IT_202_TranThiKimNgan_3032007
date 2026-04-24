-- Tạo CSDL
CREATE DATABASE OnlineLearning;
USE OnlineLearning;

-- Bảng Sinh viên
CREATE TABLE Student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Bảng Khóa học
CREATE TABLE Course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    sessions INT CHECK (sessions > 0)
);

-- Bảng Giảng viên
CREATE TABLE Instructor (
    instructor_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Bảng Đăng ký học
CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    UNIQUE(student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

-- Bảng Kết quả học tập
CREATE TABLE Result (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    midterm_score DECIMAL(3,1) CHECK (midterm_score BETWEEN 0 AND 10),
    final_score DECIMAL(3,1) CHECK (final_score BETWEEN 0 AND 10),
    UNIQUE(student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);


-- Thêm sinh viên
INSERT INTO Student (full_name, birth_date, email)
VALUES 
('Nguyen Van A', '2002-01-15', 'vana@example.com'),
('Tran Thi B', '2001-05-20', 'thib@example.com'),
('Le Van C', '2003-03-10', 'vanc@example.com'),
('Pham Thi D', '2002-07-25', 'thid@example.com'),
('Hoang Van E', '2001-12-30', 'vane@example.com');

-- Thêm khóa học
INSERT INTO Course (course_name, description, sessions)
VALUES
('Database Systems', 'Learn SQL and database design', 15),
('Web Development', 'HTML, CSS, JS basics', 20),
('Machine Learning', 'Intro to ML concepts', 25),
('Computer Networks', 'Networking fundamentals', 18),
('Operating Systems', 'OS principles and design', 22);

-- Thêm giảng viên
INSERT INTO Instructor (full_name, email)
VALUES
('Nguyen Van G', 'vang@example.com'),
('Tran Thi H', 'thih@example.com'),
('Le Van I', 'vani@example.com'),
('Pham Thi J', 'thij@example.com'),
('Hoang Van K', 'vank@example.com');

-- Thêm đăng ký học
INSERT INTO Enrollment (student_id, course_id, enrollment_date)
VALUES
(1, 1, '2024-09-01'),
(2, 2, '2024-09-02'),
(3, 3, '2024-09-03'),
(4, 4, '2024-09-04'),
(5, 5, '2024-09-05');

-- Thêm kết quả học tập
INSERT INTO Result (student_id, course_id, midterm_score, final_score)
VALUES
(1, 1, 7.5, 8.0),
(2, 2, 6.0, 7.0),
(3, 3, 8.5, 9.0),
(4, 4, 5.5, 6.5),
(5, 5, 9.0, 9.5);



-- Cập nhật email cho một sinh viên
UPDATE Student SET email = 'vana_new@example.com' WHERE student_id = 1;

-- Cập nhật mô tả cho một khóa học
UPDATE Course SET description = 'Advanced SQL and database design' WHERE course_id = 1;

-- Cập nhật điểm cuối kỳ cho một sinh viên
UPDATE Result SET final_score = 8.5 WHERE student_id = 1 AND course_id = 1;

-- Xóa một lượt đăng ký học không hợp lệ
DELETE FROM Enrollment WHERE enrollment_id = 1;

-- Xóa kết quả học tập tương ứng
DELETE FROM Result WHERE student_id = 1 AND course_id = 1;


-- Lấy danh sách tất cả sinh viên
SELECT * FROM Student;

-- Lấy danh sách giảng viên
SELECT * FROM Instructor;

-- Lấy danh sách các khóa học
SELECT * FROM Course;

-- Lấy thông tin các lượt đăng ký khóa học
SELECT * FROM Enrollment;

-- Lấy thông tin các lần đánh giá kết quả
SELECT * FROM Result;




