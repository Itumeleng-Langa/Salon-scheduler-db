--
-- PostgreSQL database dump
--

-- Create the database (if needed)
-- CREATE DATABASE salon;

-- Connect to salon database
\c salon

-- Create customers table
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR(15) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL
);

-- Create services table
CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

-- Create appointments table
CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL,
  service_id INT NOT NULL,
  time VARCHAR(20) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (service_id) REFERENCES services(service_id)
);

-- Insert sample services
INSERT INTO services (name) VALUES 
  ('cut'),
  ('color'),
  ('perm'),
  ('style'),
  ('trim');
