-- library_db.sql


/* ========== TABLES CREATION ========== */

-- Members table (Patrons)
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    join_date DATE DEFAULT (CURRENT_DATE),
    membership_status ENUM('active', 'expired', 'suspended') DEFAULT 'active',
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
);

-- Books table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    publication_year INT,
    genre VARCHAR(50),
    total_copies INT DEFAULT 1 CHECK (total_copies >= 0),
    available_copies INT DEFAULT 1 CHECK (available_copies >= 0),
    CONSTRAINT copies_check CHECK (available_copies <= total_copies)
);

-- Loans table (Transactions)
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('active', 'returned', 'overdue') DEFAULT 'active',
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    CONSTRAINT chk_dates CHECK (due_date > loan_date AND (return_date IS NULL OR return_date >= loan_date))
);

/* ========== INDEXES ========== */
CREATE INDEX idx_book_title ON books(title);
CREATE INDEX idx_author ON books(author);
CREATE INDEX idx_member_name ON members(last_name, first_name);

/* ========== SAMPLE DATA ========== */
INSERT INTO members (first_name, last_name, email, phone) VALUES
('Jane', 'Doe', 'jane@example.com', '555-0101'),
('John', 'Smith', 'john@example.com', '555-0102');

INSERT INTO books (isbn, title, author, publication_year, genre, total_copies) VALUES
('978-0061120084', 'To Kill a Mockingbird', 'Harper Lee', 1960, 'Fiction', 5),
('978-0451524935', '1984', 'George Orwell', 1949, 'Dystopian', 3);

