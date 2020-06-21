
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
idAge = CASE WHEN Age < 20 THEN Age ELSE 20 END;