
-- ddl/dimPatient.sql
DROP TABLE IF EXISTS dimPatient;
CREATE TABLE dimPatient (
    idPatient int,
    gender VARCHAR(1),
    birthDate DATE,
    generation VARCHAR(30),
    CONSTRAINT idPatient PRIMARY KEY (idPatient)
    );