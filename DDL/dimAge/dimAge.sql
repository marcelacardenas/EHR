
-- ddl/dimAge.sql
DROP TABLE IF EXISTS dimAge;
CREATE TABLE dimAge(
idAge smallint AUTO_INCREMENT,
segment varchar(10),
CONSTRAINT idAge PRIMARY KEY(idAge) 
);