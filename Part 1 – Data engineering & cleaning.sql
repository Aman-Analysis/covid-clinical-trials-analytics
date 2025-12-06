RENAME TABLE covid_clinical_trials TO covid_clinical_trials_raw;

CREATE TABLE covid_clinical_trials AS
SELECT *
FROM covid_clinical_trials_raw;

ALTER TABLE covid_clinical_trials
ADD COLUMN Phase_norm VARCHAR(20),
ADD COLUMN Status_group VARCHAR(50);

 
SELECT Phases, Phase_norm
FROM covid_clinical_trials
LIMIT 20;

UPDATE covid_clinical_trials
SET Status_group = CASE
    WHEN Status LIKE '%Recruiting%' THEN 'Recruiting/Active'
    WHEN Status LIKE '%Completed%' THEN 'Completed'
    WHEN Status LIKE '%Terminated%' THEN 'Terminated'
    WHEN Status LIKE '%Withdrawn%' THEN 'Withdrawn'
    WHEN Status LIKE '%Suspended%' THEN 'Suspended'
    ELSE 'Other/Unknown'
END;

SELECT Status, Status_group
FROM covid_clinical_trials
LIMIT 20;
