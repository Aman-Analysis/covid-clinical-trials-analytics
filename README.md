# 🧬 COVID-19 Clinical Trials Analytics  
### SQL Data Cleaning • MySQL ETL • Power BI Dashboard

This project delivers an end-to-end analysis of **5,783 global COVID-19 clinical trials**, using **MySQL** for data cleaning & transformation and **Power BI** for interactive visualizations.  
It demonstrates skills required for **Clinical Data Analyst**, **Healthcare Data Analyst**, and **Clinical Research Analytics** roles.


# 📌 Project Objectives

- Clean, structure, and model a raw clinical trials dataset using SQL  
- Create analysis-ready tables and MySQL views  
- Build an interactive, multi-page Power BI dashboard  
- Analyze trial phases, status, enrollment, sponsors, and global locations  
- Generate insights relevant to clinical operations and trial analytics  


# 📁 Repository Structure

covid-clinical-trials-analytics/
│
├── data/
│ ├── raw/
│ │ └── COVID_Clinical_Trials.csv
│ └── cleaned/
│ └── covid_clinical_trials.sql
│
├── sql/
│ ├── create_table.sql
│ ├── load_data.sql
│ ├── data_cleaning.sql
│ ├── create_view.sql
│ └── data_quality_checks.sql
│
├── powerbi/
│ ├── Clinical_Trials_Dashboard.pbix
│ └── screenshots/
│ ├── overview_page.png
│ ├── enrollment_page.png
│ ├── sponsor_page.png
│ └── location_page.png
│
└── README.md


# 🛢️ SQL Workflow (MySQL)

## 1️⃣ Create Table

```sql
CREATE TABLE covid_clinical_trials (
  `Rank` INT,
  `NCT_Number` VARCHAR(20),
  `Title` TEXT,
  `Acronym` VARCHAR(255),
  `Status` VARCHAR(100),
  `Study_Results` VARCHAR(100),
  `Conditions` TEXT,
  `Interventions` TEXT,
  `Outcome_Measures` LONGTEXT,
  `Sponsor_Collaborators` TEXT,
  `Gender` VARCHAR(50),
  `Age` VARCHAR(100),
  `Phases` VARCHAR(100),
  `Enrollment` VARCHAR(255),
  `Funded_Bys` VARCHAR(255),
  `Study_Type` VARCHAR(100),
  `Study_Designs` TEXT,
  `Other_IDs` VARCHAR(255),
  `Start_Date` VARCHAR(50),
  `Primary_Completion_Date` VARCHAR(50),
  `Completion_Date` VARCHAR(50),
  `First_Posted` VARCHAR(50),
  `Results_First_Posted` VARCHAR(50),
  `Last_Update_Posted` VARCHAR(50),
  `Locations` LONGTEXT,
  `Study_Documents` LONGTEXT,
  `URL` VARCHAR(255)
) CHARACTER SET utf8mb4;
2️⃣ Load CSV into MySQL
sql
Copy code
LOAD DATA LOCAL INFILE 'COVID_Clinical_Trials.csv'
INTO TABLE covid_clinical_trials
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
3️⃣ Standardize Trial Phase
sql
UPDATE covid_clinical_trials
SET Phase_norm = CASE
    WHEN Phases LIKE '%1%' AND Phases LIKE '%2%' THEN 'Phase 1/2'
    WHEN Phases LIKE '%2%' AND Phases LIKE '%3%' THEN 'Phase 2/3'
    WHEN Phases LIKE '%1%' THEN 'Phase 1'
    WHEN Phases LIKE '%2%' THEN 'Phase 2'
    WHEN Phases LIKE '%3%' THEN 'Phase 3'
    WHEN Phases LIKE '%4%' THEN 'Phase 4'
    ELSE 'Other/NA'
END;
4️⃣ Standardize Trial Status
sql
UPDATE covid_clinical_trials
SET Status_group = CASE
    WHEN Status LIKE '%Recruiting%' THEN 'Recruiting'
    WHEN Status LIKE '%Completed%' THEN 'Completed'
    WHEN Status LIKE '%Terminated%' THEN 'Terminated'
    WHEN Status LIKE '%Withdrawn%' THEN 'Withdrawn'
    ELSE 'Other'
END;
5️⃣ Parse Dates into SQL Format
sql
UPDATE covid_clinical_trials
SET Start_Date_parsed =
    STR_TO_DATE(Start_Date, '%M %e, %Y');
6️⃣ Convert Enrollment to Numeric
sql
UPDATE covid_clinical_trials
SET Enrollment_num = NULLIF(
    REGEXP_REPLACE(Enrollment, '[^0-9]', ''), ''
);
7️⃣ Extract Country from Location Field
sql
ALTER TABLE covid_clinical_trials
ADD COLUMN Country VARCHAR(255);

UPDATE covid_clinical_trials
SET Country = TRIM(SUBSTRING_INDEX(Locations, ',', -1));
8️⃣ Create a Clean Analysis View for Power BI
sql
CREATE OR REPLACE VIEW v_covid_clinical_trials AS
SELECT
    `Rank`,
    NCT_Number,
    Title,
    Phase_norm,
    Status_group,
    Start_Date_parsed,
    Enrollment_num,
    Sponsor_Collaborators,
    Country
FROM covid_clinical_trials;
📊 Power BI Dashboard
Page 1 — Overview
Total trials

Trials by phase

Trials by status

Trials per year

Filters: Year, Phase, Status

Page 2 — Enrollment Insights
Average enrollment

Maximum enrollment

Enrollment distribution bins

Enrollment by phase

Page 3 — Sponsor Insights
Top 10 sponsors

Interactive trial table

Sponsor, phase, and status filters

Page 4 — Location Insights
World map of trial locations

Top 10 countries

Location-based trial details

Screenshots included in /powerbi/screenshots/

📈 Key Insights
Most COVID-19 clinical trials are concentrated in Phase 2 and Phase 3.

A small number of global sponsors contribute the majority of trial activity.

Enrollment varies dramatically, with several extremely large trials (>10k participants).

The United States, India, and China lead in total trial count.

Trial initiations peak in 2020–2021, aligned with vaccine & treatment development timelines.

🚀 How to Run This Project
1. Clone the repo
bash
Copy code
git clone https://github.com/YOUR_USERNAME/covid-clinical-trials-analytics.git
2. Run SQL scripts in order:
create_table.sql

load_data.sql

data_cleaning.sql

create_view.sql

3. Open the Power BI file:
Copy code
powerbi/Clinical_Trials_Dashboard.pbix
4. Update the MySQL ODBC connection to your local server.
🛠️ Tech Stack
MySQL 8.0 — Data cleaning, transformation, views

SQL — ETL, validation, profiling

Power BI — Data modeling + multi-page visualization

GitHub — Version control and publishing

🔮 Future Enhancements
Add trial duration & delay analysis

Use NLP to classify trial titles or medical conditions

Add predictive modeling for completion likelihood

Map site-level locations instead of only countries

📜 License
This project is released under the MIT License.

🙋‍♂️ Contact
Your Name
Email: amanullashaikh555@gmail.com
LinkedIn: https://linkedin.com/in/yourprofile
GitHub: https://github.com/Aman-Analysis
Portfolio: https://aman-analysis.github.io/amanullashaik.github.io/
