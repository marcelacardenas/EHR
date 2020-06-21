
-- etl/LoadDimDate.sql
LOAD DATA LOCAL INFILE '/Users/marcelacardenas/Desktop/consults.csv'
INTO TABLE DimDate
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(idDate,consultDate,Day,Month,Year,season)
SET idDate = NULL, 
season = CASE
    WHEN (DATE_FORMAT(`consultDate`, '%m')) IN (12,1,2) THEN 'Winter'
    WHEN (DATE_FORMAT(`consultDate`, '%m')) IN (3,4,5) THEN 'Spring'
  WHEN (DATE_FORMAT(`consultDate`, '%m')) IN (6,7,8) THEN 'Summer'
  WHEN (DATE_FORMAT(`consultDate`, '%m')) IN (9,10,11) THen 'Autum'
    Else season = season
    END ;