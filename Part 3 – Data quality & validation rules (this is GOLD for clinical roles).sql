SELECT 
    NCT_Number, 
    COUNT(*) AS cnt
FROM covid_clinical_trials
GROUP BY NCT_Number
HAVING cnt > 1;

SELECT
  SUM(NCT_Number IS NULL OR NCT_Number = '') AS missing_nct,
  SUM(Title IS NULL OR Title = '')           AS missing_title,
  SUM(Status IS NULL OR Status = '')         AS missing_status,
  SUM(Phase_norm = 'Other/NA')               AS other_phase
FROM covid_clinical_trials;

SELECT 
    Rank,
    NCT_Number,
    Start_Date_parsed,
    Completion_Date_parsed
FROM covid_clinical_trials
WHERE Start_Date_parsed IS NOT NULL
  AND Completion_Date_parsed IS NOT NULL
  AND Start_Date_parsed > Completion_Date_parsed;
  
SELECT *
FROM covid_clinical_trials
WHERE Enrollment_num < 0
   OR Enrollment_num > 100000;

