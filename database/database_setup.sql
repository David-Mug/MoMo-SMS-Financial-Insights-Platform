-- Drop existing database if it exists (for clean setup)
DROP DATABASE IF EXISTS momo_db;
CREATE DATABASE momo_db
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_unicode_ci;
USE momo_db;

-- Create Users table
CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique identifier for each user, auto-incremented',
    user_phone_number VARCHAR(20) COMMENT'Mobile phone number used for identification',
    user_name VARCHAR(50) COMMENT 'name of the user'
)
COMMENT='Stores user information for mobile money transactions';

-- Create Transactions table
CREATE TABLE transaction_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique identifier for each transaction category',
    category_type VARCHAR(50) NOT NULL COMMENT 'Specific type or name of the transaction category',
    INDEX idx_category_type (category_type) COMMENT 'Index for category type searches'
) 
COMMENT='Defines transaction categories for classification';

CREATE TABLE user_categories (
    user_id INT NOT NULL COMMENT 'Foreign key referencing the user',
    category_id INT NOT NULL COMMENT 'Foreign key referencing the transaction category',
    PRIMARY KEY (user_id, category_id) COMMENT 'Composite primary key',
    FOREIGN KEY (user_id) REFERENCES user(user_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES transaction_categories(category_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
) 
COMMENT='Junction table linking users to their associated transaction categories';

-- =====================================================
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique identifier for each transaction',
    sender_id INT NOT NULL COMMENT 'Foreign key referencing the user who initiated the transaction',
    receiver_id INT NOT NULL COMMENT 'Foreign key referencing the user who received the transaction',
    amount DECIMAL(15, 2) NOT NULL COMMENT 'Monetary value of the transaction',
    category_id INT NOT NULL COMMENT 'Foreign key linking this transaction to its category type',
    transaction_time DATETIME NOT NULL COMMENT 'Timestamp indicating when the transaction occurred',
    CHECK (amount > 0),
    CHECK (sender_id != receiver_id),
    FOREIGN KEY (sender_id) REFERENCES user(user_id) 
    ON DELETE RESTRICT,
    FOREIGN KEY (receiver_id) REFERENCES user(user_id) 
        ON DELETE RESTRICT,
    FOREIGN KEY (category_id) REFERENCES transaction_categories(category_id) 
        ON DELETE RESTRICT,
    CONSTRAINT chk_different_users CHECK (sender_id != receiver_id),
    INDEX idx_sender (sender_id) COMMENT 'Index for fast sender lookups',
    INDEX idx_receiver (receiver_id) COMMENT 'Index for fast receiver lookups',
    INDEX idx_category (category_id) COMMENT 'Index for category-based queries',
    INDEX idx_transaction_time (transaction_time) COMMENT 'Index for time-based queries and sorting'
) 
COMMENT='Core table storing all mobile money transaction records';

CREATE TABLE system_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique identifier for each log entry',
    action VARCHAR(50) NOT NULL COMMENT 'Description of the specific action or event that was logged',
    timestamp DATETIME NOT NULL COMMENT 'Date and time when the log entry was created',
    transaction_id INT COMMENT 'Foreign key linking log entry to a specific transaction (nullable)',
    category_id INT COMMENT 'Foreign key linking log entry to a transaction category (nullable)',
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE ,
    FOREIGN KEY (category_id) REFERENCES transaction_categories(category_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE ,
    INDEX idx_timestamp (timestamp) COMMENT 'Index for time-based log queries',
    INDEX idx_action (action) COMMENT 'Index for action-based filtering',
    INDEX idx_transaction_log (transaction_id) COMMENT 'Index for transaction-related logs',
    INDEX idx_category_log (category_id) COMMENT 'Index for category-related logs'
) 
COMMENT='System logging table for auditing and tracking data processing events';
