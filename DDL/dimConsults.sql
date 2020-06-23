
-- ddl/dimConsults.sql
DROP TABLE IF EXISTS dimConsults;
CREATE TABLE dimConsults(
idConsultation bigint,
dateConsultation date,
idPatient bigint,
CONSTRAINT idConsultation PRIMARY KEY(idConsultation) 
);