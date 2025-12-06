SELECT 
    Phase_norm,
    Status_group,
    COUNT(*) AS n_trials
FROM covid_clinical_trials
GROUP BY Phase_norm, Status_group
ORDER BY Phase_norm, n_trials DESC;

SELECT 
    YEAR(Start_Date_parsed) AS start_year,
    COUNT(*) AS n_trials
FROM covid_clinical_trials
WHERE Start_Date_parsed IS NOT NULL
GROUP BY YEAR(Start_Date_parsed)
ORDER BY start_year;

SELECT 
    Phase_norm,
    COUNT(*) AS n_trials,
    ROUND(AVG(Enrollment_num)) AS avg_enrollment,
    MIN(Enrollment_num) AS min_enrollment,
    MAX(Enrollment_num) AS max_enrollment
FROM covid_clinical_trials
WHERE Enrollment_num IS NOT NULL
GROUP BY Phase_norm
ORDER BY avg_enrollment DESC;

SELECT 
    Sponsor_Collaborators,
    COUNT(*) AS n_trials
FROM covid_clinical_trials
GROUP BY Sponsor_Collaborators
ORDER BY n_trials DESC
LIMIT 15;

