/************************ CODE STARTS HERE ***********************************************/
use Hospital;

-- DDL: 
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

-- ddl/dimPatient.sql
DROP TABLE IF EXISTS dimPatient;
CREATE TABLE dimPatient (
    idPatient int,
    gender VARCHAR(1),
    birthDate DATE,
    generation VARCHAR(30),
    CONSTRAINT idPatient PRIMARY KEY (idPatient)
    );

-- ddl/dimAge.sql
DROP TABLE IF EXISTS dimAge;
CREATE TABLE dimAge(
idAge smallint AUTO_INCREMENT,
segment varchar(10),
CONSTRAINT idAge PRIMARY KEY(idAge) 
);

-- ddl/dimConsults.sql
DROP TABLE IF EXISTS dimConsults;
CREATE TABLE dimConsults(
idConsultation bigint,
dateConsultation date,
idPatient bigint,
CONSTRAINT idConsultation PRIMARY KEY(idConsultation) 
);

-- ddl/FactPatientMetrics.sql
#CREATE Fact Table relation with Patient and Date dimensions primary keys
DROP TABLE IF EXISTS FactPatientMetrics;
CREATE TABLE FactPatientMetrics(
idFact serial AUTO_INCREMENT,
idAge smallint,
idPatient int,
idDate bigint,
Age smallint,
dateConsultation date,
totalConsults int,
Primary key (idFact)
, Foreign key (idPatient) REFERENCES dimPatient(idPatient)
, Foreign key (idDate) REFERENCES dimDate(idDate)
);
 
 
 -- ETL
 
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
    
-- etl/LoadDimPatient.sql
LOAD DATA LOCAL INFILE '/Users/marcelacardenas/Desktop/patients.csv'
INTO TABLE dimPatient
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(idPatient,@`idDoctor`,@`birthdate`,@`gender`,generation)
set `Birthdate`=@`birthdate`,`Gender` = @`gender`,
Generation =
CASE
when (year(birthDate) <= 1945) then 'The Silent Generation'
when (year(birthDate) between 1946 and 1964) then 'Baby Boomer Generation'
when (year(birthDate) between 1965 and 1979) then 'Generation X'
when (year(birthDate) between 1980 and 1994) then 'Millennials'
when (year(birthDate) between 1995 and 2012) then 'Gen Z'
when (year(birthDate) between 2013 and 2025) then 'Gen Alpha'
END;

-- etl/LoadDimAge.sql
LOAD DATA LOCAL INFILE '/Users/marcelacardenas/Desktop/Age.csv'
INTO TABLE dimAge
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(idAge,segment)
SET idAge = NULL;

-- etl/LoadDimConsults.sql
LOAD DATA LOCAL INFILE '/Users/marcelacardenas/Desktop/patientconsult.csv'
INTO TABLE dimConsults
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(idConsultation,dateConsultation,@`dateAppointment`,@`timeAppointment`,@`idPatient`,@`birthDate`,@`gender`,@`idactivityType`,@`activity`, @`idimmunization`,@`Immunization`)
set `idPatient` = @`idPatient`;

-- etl/LoadFactPatientMetrics.sql
INSERT INTO FactPatientMetrics (idAge,idPatient,idDate,Age,dateConsultation,totalConsults)
SELECT
DA.idAge AS'idAge' ,
DP.idPatient AS 'idPatient' ,
DAT.idDate as 'idDate',
TIMESTAMPDIFF(year, dP.birthdate, DC.dateConsultation)+1 AS 'Age',
DC.dateConsultation as 'dateConsultation' ,
1 AS 'totalConsults'
FROM DimConsults DC
left JOIN DimPatient DP ON DC.idPatient = DP.idPatient
left JOIN DimAge DA ON DATEDIFF(DP.birthdate, DC.dateconsultation) = DA.idAge
left JOIN DimDate DAT on DC.dateconsultation = dat.ConsultDate;

update FactPatientMetrics set 
idAge = CASE WHEN Age < 20 THEN Age ELSE 20 END; #wasnt able to put case statement into insert fact table.

-- Examples.sql
#Health Care Decisions by Generation: How Do Patients Differ? Top generation in the consults and how many per gender
SELECT  Generation,
        SUM(totalconsults) as total,
        SUM(CASE WHEN gender ='F' THEN 1 ELSE 0 END) AS womenCount, 
        SUM(CASE when gender ='M' THEN  1 else 0 END) AS menCount
FROM FactPatientMetrics f
INNER JOIN DimPatient dp on f.idpatient = dp.idpatient
GROUP BY Generation
ORDER BY total desc;

#Rank segments of educational stage per patient
SELECT  segment,
        RANK () OVER (ORDER BY SUM(totalconsults) DESC) AS consultsRank 
FROM FactPatientMetrics fc
INNER JOIN dimage dag on fc.idage = dag.idage
group by segment;

/************************ CODE ENDS HERE ***********************************************/