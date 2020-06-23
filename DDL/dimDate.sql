
-- ddl/dimDate.sql
DROP TABLE IF EXISTS dimDate;  
CREATE TABLE dimDate(
  idDate bigint AUTO_INCREMENT,
  consultDate date,
  Day int AS (DATE_FORMAT(`donsultDate`, '%d')), 
  Month int AS (DATE_FORMAT(`donsultDate`, '%m')), 
  Year int AS (YEAR(`donsultDate`)), 
  season varchar(10),
CONSTRAINT idDate PRIMARY KEY (idDate)
);

