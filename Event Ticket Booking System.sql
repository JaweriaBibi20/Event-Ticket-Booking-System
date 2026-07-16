CREATE DATABASE EventTicketBookingSystem
-- 1. Venues Table
CREATE TABLE Venues1 (
    venue_id INT PRIMARY KEY IDENTITY(1,1),
    venue_name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    capacity INT NOT NULL
);

-- 2. Users Table
CREATE TABLE Users1 (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    registration_date DATETIME DEFAULT GETDATE()
);

-- 3. Events Table
CREATE TABLE Events1 (
    event_id INT PRIMARY KEY IDENTITY(1,1),
    event_name VARCHAR(150) NOT NULL,
    event_date DATETIME NOT NULL,
    ticket_price DECIMAL(10, 2) NOT NULL,
    available_tickets INT NOT NULL,
    venue_id INT,
    FOREIGN KEY (venue_id) REFERENCES Venues(venue_id) ON DELETE SET NULL
);

-- 4. Bookings Table
CREATE TABLE Bookings1 (
    booking_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    event_id INT,
    tickets_booked INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    booking_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Events(event_id) ON DELETE CASCADE
);

-- 5. Payments Table
CREATE TABLE Payments1 (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    booking_id INT,
    payment_method VARCHAR(50) NOT NULL, 
    payment_status VARCHAR(20) DEFAULT 'Pending', 
    payment_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE
);
-- 1. Venues mein data insert krna
INSERT INTO Venues1 (venue_name, location, capacity) VALUES 
('Gaddafi Stadium', 'Lahore', 27000),
('Alhamra Arts Council', 'Lahore', 800),
('Karachi Expo Center', 'Karachi', 5000);

-- 2. Users mein data insert krna
INSERT INTO Users1 (full_name, email, phone) VALUES 
('Ali Khan', 'ali@email.com', '03001234567'),
('Ayesha Ahmed', 'ayesha@email.com', '03219876543'),
('Zainab Fatima', 'zainab@email.com', '03334445556');

-- 3. Events mein data insert krna (Venues ke IDs: 1, 2, 3)
INSERT INTO Events1 (event_name, event_date, ticket_price, available_tickets, venue_id) VALUES 
('Atif Aslam Concert', '2026-06-15 20:00:00', 3500.00, 500, 1),
('Stand-up Comedy Show', '2026-06-20 19:30:00', 1500.00, 150, 2),
('Tech Exhibition 2026', '2026-07-01 10:00:00', 500.00, 2000, 3);

-- 4. Bookings mein data insert krna (User 1 ne Event 1 ki 2 tickets book keen)
INSERT INTO Bookings1 (user_id, event_id, tickets_booked, total_amount) VALUES 
(1, 1, 2, 7000.00),
(2, 2, 3, 4500.00);

-- 5. Payments mein data insert krna (Booking 1 aur 2 ke liye)
INSERT INTO Payments1 (booking_id, payment_method, payment_status) VALUES 
(1, 'EasyPaisa', 'Paid'),
(2, 'Credit Card', 'Pending');



SELECT * FROM Users1
SELECT * FROM Bookings1
SELECT * FROM Events1
SELECT * FROM Payments1



SELECT 
    b.booking_id,
    u.full_name AS [Customer Name],
    e.event_name AS [Event],
    b.tickets_booked AS [Tickets],
    b.total_amount AS [Total Paid],
    p.payment_status AS [Status]
FROM Bookings b
JOIN Users1 u ON b.user_id = u.user_id
JOIN Events1 e ON b.event_id = e.event_id
JOIN Payments1 p ON b.booking_id = p.booking_id;


--Most Popular Event
SELECT TOP 1 
    e.event_name, 
    SUM(b.tickets_booked) AS [Total Tickets Sold]
FROM Bookings1 b
JOIN Events e ON b.event_id = e.event_id
GROUP BY e.event_name
ORDER BY [Total Tickets Sold] DESC;

--Available Tickets Check Karna
SELECT event_name, available_tickets 
FROM Events1
WHERE event_id = 1; -- 1 ki jagah koi bhi ID check kar sakte hain

--Kisi Specific User Ki Booking History
SELECT b.booking_id, e.event_name, b.tickets_booked, b.total_amount, b.booking_date
FROM Bookings1 b
JOIN Events1 e ON b.event_id = e.event_id
WHERE b.user_id = 1; -- Ali Khan ka record

--Total Revenue / Earning
SELECT SUM(total_amount) AS [Total System Revenue] 
FROM Bookings1;

--Pending Payments Waale Customers
SELECT u.full_name, u.email, b.booking_id, b.total_amount
FROM Bookings1 b
JOIN Users1 u ON b.user_id = u.user_id
JOIN Payments1 p ON b.booking_id = p.booking_id
WHERE p.payment_status = 'Pending';

--Empty Venues
SELECT v.venue_name, v.location
FROM Venues v
LEFT JOIN Events1 e ON v.venue_id = e.venue_id
WHERE e.event_id IS NULL;

