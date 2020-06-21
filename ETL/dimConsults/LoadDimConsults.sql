
-- etl/LoadDimConsults.sql
LOAD DATA LOCAL INFILE '/Users/marcelacardenas/Desktop/patientconsult.csv'
INTO TABLE dimConsults
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(idConsultation,dateConsultation,@`dateAppointment`,@`timeAppointment`,@`idPatient`,@`birthDate`,@`gender`,@`idactivityType`,@`activity`, @`idimmunization`,@`Immunization`)
set `idPatient` = @`idPatient`;