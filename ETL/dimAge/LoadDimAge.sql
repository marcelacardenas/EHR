
-- etl/LoadDimAge.sql
LOAD DATA LOCAL INFILE '/Users/marcelacardenas/Desktop/Age.csv'
INTO TABLE dimAge
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(idAge,segment)
SET idAge = NULL;