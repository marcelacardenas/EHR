
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