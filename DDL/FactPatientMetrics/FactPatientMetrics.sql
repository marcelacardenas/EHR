
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
