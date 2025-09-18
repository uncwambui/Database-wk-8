-- Create a database named 'library_db'
CREATE DATABASE IF NOT EXISTS library_db;

-- Switch to the 'library_db' database
USE library_db;

-- Create a table named 'authors' with the specified columns
CREATE TABLE authors (
  author_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL
);

-- Create a table named 'books' with the specified columns and a foreign key reference to 'authors'
CREATE TABLE books (
  book_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  isbn VARCHAR(13) UNIQUE,
  published_year INT,
  copies_available INT DEFAULT 1,
  author_id INT,
  FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

-- Create a table named 'members' with the specified columns
CREATE TABLE members (
  member_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(30) UNIQUE,
  membership_date DATE NOT NULL
);

-- Create a table named 'borrow_records' with the specified columns and foreign key references to 'books' and 'members'
CREATE TABLE borrow_records (
  borrow_id INT AUTO_INCREMENT PRIMARY KEY,
  book_id INT NOT NULL,
  member_id INT NOT NULL,
  borrow_date DATE NOT NULL,
  return_date DATE,
  FOREIGN KEY (book_id) REFERENCES books(book_id),
  FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Insert sample data into the 'authors' table
INSERT INTO authors (first_name,last_name) VALUES
 ('Ngugi','Thiong`o'),
 ('Jane','Austen'),
 ('Anna','Todd');

-- Insert sample data into the 'books' table
 INSERT INTO books (title,isbn,published_year,copies_available,author_id) VALUES
 ('The River Between','723456789',1965,5,1),
 ('Pride and Prejudice','0141439513',1813,8,2),
 ('After','147692488',2014,6,3);

-- Insert sample data into the 'members' table
 INSERT INTO members (first_name,last_name,email,phone,membership_date) VALUES
 ('Linda','Mckay','linda@mail.com','07511122265','2025-01-10'),
 ('Wayne','Johnson','wayne@mail.com','0704355441','2025-06-11'),
 ('Liza','Queen','liza@mail.com','0753334443','2025-03-15');

 -- Insert sample data into the 'borrow_records' table
INSERT INTO borrow_records (book_id,member_id,borrow_date,return_date) VALUES
 (1,1,'2025-09-01',NULL),
 (2,2,'2025-09-01','2025-10-05'),
 (3,3,'2025-09-05','2025-09-12');

-- List all borrowed books with member names
SELECT b.title, m.first_name AS member_name, br.borrow_date, br.return_date
FROM borrow_records br
JOIN books b ON br.book_id = b.book_id
JOIN members m ON br.member_id = m.member_id;

-- Find books that are currently borrowed (not yet returned)
SELECT b.title, m.first_name AS borrowed_by, br.borrow_date
FROM borrow_records br
JOIN books b ON br.book_id = b.book_id
JOIN members m ON br.member_id = m.member_id
WHERE br.return_date IS NULL;

--  Count how many books each member has borrowed
SELECT m.first_name, m.last_name, COUNT(br.borrow_id) AS total_borrowed
FROM members m
LEFT JOIN borrow_records br ON m.member_id = br.member_id
GROUP BY m.member_id;


--  Find most borrowed books
SELECT b.title, COUNT(br.borrow_id) AS borrow_count
FROM books b
JOIN borrow_records br ON b.book_id = br.book_id
GROUP BY b.book_id
ORDER BY borrow_count DESC;