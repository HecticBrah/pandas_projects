-- Use a selected database
USE police_db;

-- Select information about a table
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='officers_data';

-- Select everything from a table
SELECT * FROM officers_data;

-- Convert badge_number column into int and setting as not null
ALTER TABLE officers_data
ALTER COLUMN badge_number int NOT NULL; 

-- Set badge_number as a Primary Key
ALTER TABLE officers_data
ADD PRIMARY KEY (badge_number); 

-- Set name column as not null
ALTER TABLE officers_data
ALTER COLUMN name VARCHAR(50) NOT NULL;

-- Convert age column into tinyint
ALTER TABLE officers_data
ALTER COLUMN age tinyint NOT NULL;

-- Convert city_department_id column into int
ALTER TABLE officers_data
ALTER COLUMN city_department_id int NOT NULL; 

-- Set city_department_id as a Foreign Key
ALTER TABLE officers_data
ADD CONSTRAINT FK_city_department_id
FOREIGN KEY (city_department_id) REFERENCES police_departments_data(city_department_id);