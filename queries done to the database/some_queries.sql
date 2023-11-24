-- Use a selected database
USE police_db;

-- Select information about a table
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='police_data';

-- Select everything from a table
SELECT * FROM police_data;

--Select everything from a table where stopped_by is 100
SELECT * FROM police_data where stopped_by = 100

--Select violation, driver_age and driver_ace where driver_race is Other
SELECT violation, driver_age, driver_race FROM police_data WHERE driver_race = 'Other'

--Count how many records each year contains 
--CONVERT(DATETIME, stop_date_and_time, 120) converts the stop_date_and_time VARCHAR column to the datetime data type in the 120 format to make the count easier by changing varchar value to datetime value where year goes first (YYYY-MM-DD HH:MI:SS).
--CONVERT(VARCHAR, ..., 120) reconverts this datetime back to a VARCHAR in the 120 format.
--LEFT(..., 4) extracts the first four characters.
--COUNT(*) counts occurrences of these first four characters.
--GROUP BY LEFT(..., 4) groups the results by the first four characters after conversion.
SELECT LEFT(CONVERT(VARCHAR, CONVERT(DATETIME, stop_date_and_time, 120), 120), 4) AS Extracted_year,
       COUNT(*) AS Stops_in_a_year
FROM police_data
GROUP BY LEFT(CONVERT(VARCHAR, CONVERT(DATETIME, stop_date_and_time, 120), 120), 4)


--More optimized way of doing the query with a subquery
SELECT Extracted_year, COUNT(*) AS Count
FROM (
    SELECT LEFT(CONVERT(VARCHAR, CONVERT(DATETIME, stop_date_and_time, 120), 120), 4) AS Extracted_year
    FROM police_data
) subquery
GROUP BY Extracted_year


--Further improvements to the query by using CTE (Common Table Expression)
WITH ConvertedData AS (
    SELECT LEFT(CONVERT(VARCHAR, CONVERT(DATETIME, stop_date_and_time, 120), 120), 4) AS Extracted_year
    FROM police_data
)

SELECT Extracted_year, COUNT(*) AS Count
FROM ConvertedData
GROUP BY Extracted_year


--Count records from 2014 year
--Converts the stop_date_and_time VARCHAR column to a datetime using the CONVERT function and then to the 120 style (YYYY-MM-DD HH:MI:SS).
--Extracts the first four characters of the converted datetime value using LEFT.
--Counts the occurrences where the first four characters of the converted value match '2014'.
SELECT LEFT(CONVERT(VARCHAR, CONVERT(DATETIME, stop_date_and_time, 120), 120), 4) AS Extracted_year,
       COUNT(*) AS Stops_in_a_year
FROM police_data
WHERE LEFT(CONVERT(VARCHAR, CONVERT(DATETIME, stop_date_and_time, 120), 120), 4) = '2014'
GROUP BY LEFT(CONVERT(VARCHAR, CONVERT(DATETIME, stop_date_and_time, 120), 120), 4)

--Get the total number of stops recorded
SELECT COUNT(*) AS TotalStops FROM police_data;

--Count stops by gender.
SELECT driver_gender, COUNT(*) AS StopsByGender FROM police_data GROUP BY driver_gender;

--Joining tables
SELECT * FROM police_data JOIN officers_data ON police_data.stopped_by = officers_data.badge_number;

--Joining tables
SELECT * FROM officers_data JOIN police_departments_data ON officers_data.city_department_id = police_departments_data.city_department_id;

--Data quality check
SELECT COUNT(*) FROM police_data WHERE stop_outcome = 'N/D';

--Getting average stop duration time
SELECT AVG(stop_duration_in_minutes) AS average_stop_time FROM police_data;

--Getting values for different races in the table and sorting it by occurrences
SELECT driver_race, COUNT(*) AS DifferentRaces FROM police_data GROUP BY driver_race ORDER BY DifferentRaces DESC; 

--Adding a new column with just the date
ALTER TABLE police_data
ADD just_date VARCHAR(10); -- Adjust the VARCHAR length to accommodate the new format

--Setting values of a new column by getting the values from original stop_date_and_time column which was in varchar 100 format and converting it to 101 format
UPDATE police_data
SET just_date = CONVERT(VARCHAR, CONVERT(DATE, stop_date_and_time, 100), 101);

--Selecting every column based on a date condition
SELECT *
FROM police_data
WHERE just_date = '08/28/2005'; -- Adjust the date as needed

--Selecting every column based on a date condition
SELECT *
FROM police_data
WHERE just_date = CAST('20050828' AS DATETIME); -- Adjust the date as needed

--Selecting every NYE record for 2005 year
SELECT *
FROM police_data
WHERE just_date = '12/31/2005';

--Selecting every NYE record
SELECT *
FROM police_data
WHERE SUBSTRING(just_date, 1, 5) = '12/31';

--Counting NYE records
SELECT COUNT(*) AS RecordsCount
FROM police_data
WHERE SUBSTRING(just_date, 1, 5) = '12/31';

--The query selects several columns: case_id, driver_gender, driver_race, stop_duration_in_minutes, and stopped_by from the police_data table.
--ROW_NUMBER() OVER(PARTITION BY stopped_by ORDER BY stop_duration_in_minutes) AS rownum generates a sequential row number for each row within partitions based on the stopped_by column. Within each partition, the rows are ordered based on the stop_duration_in_minutes.
--FROM police_data: Specifies the table from which the data is being retrieved (police_data).
--ORDER BY stopped_by, stop_duration_in_minutes: Orders the final result set by stopped_by first and then by stop_duration_in_minutes.
--This query essentially assigns a row number to each row within groups defined by the stopped_by column. The row numbers are based on the ascending order of stop_duration_in_minutes within each group of stopped_by.

SELECT case_id, driver_gender, driver_race, stop_duration_in_minutes, stopped_by,
ROW_NUMBER() OVER(PARTITION BY stopped_by
ORDER BY stop_duration_in_minutes) AS rownum
FROM police_data
ORDER BY stopped_by, stop_duration_in_minutes;
