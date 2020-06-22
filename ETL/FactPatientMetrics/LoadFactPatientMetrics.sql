
-- etl/LoadFactPatientMetrics.sql
INSERT INTO FactPatientMetrics (idAge,idPatient,idDate,Age,dateConsultation,totalConsults)
SELECT
CASE WHEN da.idAge < 20 THEN da.idAge ELSE 20 END AS'idAge',
DP.idPatient AS 'idPatient' ,
DAT.idDate as 'idDate',
TIMESTAMPDIFF(year, dP.birthdate, DC.dateConsultation)+1 AS 'Age',
DC.dateConsultation as 'dateConsultation' ,
1 AS 'totalConsults'
FROM DimConsults DC
left JOIN DimPatient DP ON DC.idPatient = DP.idPatient
left JOIN DimAge DA ON DATEDIFF(DP.birthdate, DC.dateconsultation) = DA.idAge
left JOIN DimDate DAT on DC.dateconsultation = dat.ConsultDate;