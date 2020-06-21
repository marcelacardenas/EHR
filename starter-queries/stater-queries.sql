
-- stater-queries.sql
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
