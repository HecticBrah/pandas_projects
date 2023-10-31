-- Use a selected database
USE police_db;

-- Select information about a table
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='police_data';

-- Select everything from a table
SELECT * FROM police_data;

-- Convert case_id column into int
ALTER TABLE police_data
ALTER COLUMN case_id int NOT NULL; 

-- Set case_id as a Primary Key
ALTER TABLE police_data
ADD PRIMARY KEY (case_id); 

-- Getting a Primary Key column from police_data table
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + CONSTRAINT_NAME), 'IsPrimaryKey') = 1
AND TABLE_NAME = 'police_data'

-- Set stop_date column as not null
ALTER TABLE police_data
ALTER COLUMN stop_date DATETIME NOT NULL; 

-- Set stop_time column as not null
ALTER TABLE police_data
ALTER COLUMN stop_time VARCHAR(25)  NOT NULL;

-- Convert year_of_birth column into int
ALTER TABLE police_data
ALTER COLUMN year_of_birth int NOT NULL;

-- Set driver_gender column as  non null
ALTER TABLE police_data
ALTER COLUMN driver_gender VARCHAR(25) NOT NULL;

-- Convert year_of_birth column into int
ALTER TABLE police_data
ALTER COLUMN year_of_birth int NOT NULL;

-- Convert driver_age column into tinyint
ALTER TABLE police_data
ALTER COLUMN driver_age tinyint NOT NULL;

-- Set driver_race column as  non null
ALTER TABLE police_data
ALTER COLUMN driver_race VARCHAR(25) NOT NULL;

-- Convert stop_time column into time
ALTER TABLE police_data
ALTER COLUMN stop_time char(5) NOT NULL;

-- Set violation_raw column as  non null
ALTER TABLE police_data
ALTER COLUMN violation_raw VARCHAR(100) NOT NULL;

-- Set violation column as  non null
ALTER TABLE police_data
ALTER COLUMN violation VARCHAR(50) NOT NULL;

-- Set search_conducted column as char and non null
ALTER TABLE police_data
ALTER COLUMN search_conducted CHAR(10) NOT NULL;

-- Set search_type column as  non null
ALTER TABLE police_data
ALTER COLUMN search_type VARCHAR(150) NOT NULL;

-- Set stop_outcome column as  non null
ALTER TABLE police_data
ALTER COLUMN stop_outcome VARCHAR(100) NOT NULL;

-- Set is_arrested column as varchar and non null
ALTER TABLE police_data
ALTER COLUMN is_arrested VARCHAR(50) NOT NULL;

-- Set stop_duration column as varchar and non null
ALTER TABLE police_data
ALTER COLUMN stop_duration VARCHAR(50) NOT NULL;

-- Set drugs_related_stop column as char and non null
ALTER TABLE police_data
ALTER COLUMN drugs_related_stop CHAR(10) NOT NULL;

-- Convert stopped_by column into int
ALTER TABLE police_data
ALTER COLUMN stopped_by int NOT NULL; 

-- Set stopped_by as a Foreign Key
ALTER TABLE police_data
ADD CONSTRAINT FK_stopped_by
FOREIGN KEY (stopped_by) REFERENCES officers_data(badge_number);

SELECT CONVERT(DATETIME, CONVERT(DATETIME, stop_date) + ' ' + CONVERT(CHAR, stop_time)) AS stop_date_and_time
FROM police_data;

-- Add a new column of datetime type
ALTER TABLE police_data
ADD stop_date_and_time DATETIME;

-- Update the new column with combined values
UPDATE police_data
SET stop_date_and_time = CONVERT(DATETIME, CONVERT(DATETIME, stop_date) + ' ' + CONVERT(CHAR, stop_time));

-- Drop the original date and time columns
ALTER TABLE police_data
DROP COLUMN stop_date;

ALTER TABLE police_data
DROP COLUMN stop_time;

-- Set stop_date_and_time column as non null
ALTER TABLE police_data
ALTER COLUMN stop_date_and_time DATETIME NOT NULL;

-- Showing different datetime formats and deciding which one would fit the most
SELECT CONVERT(VARCHAR, stop_date_and_time, 120) AS Format_120, -- yyyy-mm-dd hh:mi:ss (24h)
       CONVERT(VARCHAR, stop_date_and_time, 100) AS Format_100, -- mon dd yyyy hh:miAM (or PM)
       CONVERT(VARCHAR, stop_date_and_time, 103) AS Format_103, -- dd/mm/yyyy hh:mi:ss
       CONVERT(VARCHAR, stop_date_and_time, 101) AS Format_101  -- mm/dd/yyyy
FROM police_data;

-- Adding a new column to the table
ALTER TABLE police_data
ADD stop_date_and_time_new VARCHAR(30); -- Adjust the size according to the expected length of the formatted datetime

-- Updating the new column with the formatted datetime including AM/PM
UPDATE police_data
SET stop_date_and_time_new = CONVERT(VARCHAR, stop_date_and_time, 100);

-- Set stop_date_and_time column as non null
ALTER TABLE police_data
ALTER COLUMN stop_date_and_time_new VARCHAR(30) NOT NULL;

--Dropping old stop_date_and_time column
ALTER TABLE police_data
DROP COLUMN stop_date_and_time;

--renaming new stop_date_and_time_new column
EXEC sp_rename 'police_data.stop_date_and_time_new', 'stop_date_and_time', 'COLUMN';
