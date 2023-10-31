-- Use a selected database
USE police_db;

-- Select information about a table
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='police_departments_data';

-- Select everything from a table
SELECT * FROM police_departments_data;

-- Convert city_department_id column into int
ALTER TABLE police_departments_data
ALTER COLUMN city_department_id int NOT NULL; 

-- Set badge_number as a Primary Key
ALTER TABLE police_departments_data
ADD PRIMARY KEY (city_department_id); 

-- Set city column as  non null
ALTER TABLE police_departments_data
ALTER COLUMN city VARCHAR(50) NOT NULL;

-- Set address column as  non null
ALTER TABLE police_departments_data
ALTER COLUMN address VARCHAR(150) NOT NULL;