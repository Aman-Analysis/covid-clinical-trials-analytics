# 🧬 COVID-19 Clinical Trials Analytics  
### **SQL Data Cleaning + MySQL ETL + Power BI Dashboard**

This project analyzes **5,783 global COVID-19 clinical trials** using  
**MySQL for data cleaning, transformation, ETL**,  
and **Power BI** for building an interactive analytics dashboard.

The project was built end-to-end starting from a raw CSV dataset, and includes:

- SQL-based data profiling and cleaning  
- Extracting structured variables from messy text fields  
- Creating analysis-ready tables & views  
- Building a multi-page Power BI dashboard  
- Insights relevant to clinical data analytics roles  

This project showcases skills required for **Clinical Data Analyst**,  
**Healthcare Data Analyst**, **Biostatistics Analyst**,  
and **Clinical Operations Analytics** roles.

---

# 📁 **Project Structure**

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

less
Copy code

---

# 📊 **Dashboard Overview**

The Power BI dashboard consists of **4 interactive pages**:

### **1️⃣ Overview Page**
- Total trials  
- Trials by phase  
- Trials by status  
- Trials started per year  
- Filters: phase, status, year  

### **2️⃣ Enrollment Insights**
- Average enrollment  
- Maximum enrollment  
- Enrollment distribution (histogram bins)  
- Average enrollment by phase  

### **3️⃣ Sponsor Insights**
- Top 10 sponsors by number of trials  
- Interactive trial details table  
- Filters: sponsor, phase, status  

### **4️⃣ Location Insights**
- World map of trial locations  
- Top 10 countries by number of trials  
- Country-level trial breakdown table  

> Add screenshots of your dashboard pages inside `/powerbi/screenshots/`  
> and embed them below after uploading.

---

# 🛢️ **SQL Work: Data Cleaning & Transformation (MySQL)**

## 🔹 Step 1 — Create Table (Wide Structure + Text Columns Safe)

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
🔹 Step 2 — Load CSV Using LOAD DATA
sql
Copy code
LOAD DATA LOCAL INFILE 'COVID_clinical_trials.csv'
INTO TABLE covid_clinical_trials
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
🔹 Step 3 — Standardize Phase & Status
sql
Copy code
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
sql
Copy code
UPDATE covid_clinical_trials
SET Status_group = CASE
    WHEN Status LIKE '%Recruiting%' THEN 'Recruiting'
    WHEN Status LIKE '%Completed%' THEN 'Completed'
    WHEN Status LIKE '%Terminated%' THEN 'Terminated'
    WHEN Status LIKE '%Withdrawn%' THEN 'Withdrawn'
    ELSE 'Other'
END;
🔹 Step 4 — Convert Dates From Text → SQL Dates
sql
Copy code
UPDATE covid_clinical_trials
SET Start_Date_parsed =
    STR_TO_DATE(Start_Date, '%M %e, %Y');
(Additional logic added for alternate date formats.)

🔹 Step 5 — Extract Enrollment as Numeric
sql
Copy code
UPDATE covid_clinical_trials
SET Enrollment_num = NULLIF(
    REGEXP_REPLACE(Enrollment, '[^0-9]', ''), ''
);
🔹 Step 6 — Extract Country From Locations
sql
Copy code
ALTER TABLE covid_clinical_trials
ADD COLUMN Country VARCHAR(255);

UPDATE covid_clinical_trials
SET Country = TRIM(SUBSTRING_INDEX(Locations, ',', -1));
🔹 Step 7 — Create an Analysis View for Power BI
sql
Copy code
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
This view is clean, typed, and optimized for BI tools.

📘 Key SQL Data Quality Checks
sql
Copy code
-- Null checks
SELECT COUNT(*) FROM covid_clinical_trials
WHERE Enrollment_num IS NULL;

-- Duplicate trial detection
SELECT NCT_Number, COUNT(*)
FROM covid_clinical_trials
GROUP BY NCT_Number
HAVING COUNT(*) > 1;

-- Inconsistent date records
SELECT *
FROM covid_clinical_trials
WHERE Start_Date_parsed > Completion_Date_parsed;
📊 Power BI Dashboard Pages
(Screenshots should be inserted after uploading your PNG files.)

Overview Page
✔ Trial volumes
✔ Phase distribution
✔ Status distribution
✔ Yearly trial trends

Enrollment Insights
✔ Average and max enrollment
✔ Enrollment by phase
✔ Distribution (bins)

Sponsor Insights
✔ Top 10 sponsors
✔ Trial-level drilldown table

Location Insights
✔ World map visualization
✔ Top 10 countries

🧠 Key Insights From This Analysis
Most trials occur at Phase 2 and Phase 3 levels.

Enrollment varies widely, with several massive trials (>10,000 participants).

A small number of sponsors account for a large share of global trials.

The USA, India, and China lead in trial activity for COVID-19 research.

Trial activity peaked strongly in 2020–2021, aligned with pandemic response timelines.

🔄 How to Reproduce This Project
1. Clone the repository
bash
Copy code
git clone https://github.com/yourusername/covid-clinical-trials-analytics.git
2. Import MySQL scripts
Run sql/create_table.sql

Run sql/load_data.sql

Run sql/data_cleaning.sql

Run sql/create_view.sql

3. Open Power BI file
Open:

Copy code
powerbi/Clinical_Trials_Dashboard.pbix
Update the ODBC connection to your MySQL server.

🚀 Future Improvements
Model trial duration & delays

Add predictive modeling for completion likelihood

NLP analysis of study titles & conditions

Sponsor segmentation clustering

Enhanced geographic mapping with ISO country codes

📜 License
This project is released under the MIT License.

🤝 Contact & Contributions
If you'd like to contribute or collaborate on clinical data analytics:

Your Name
Email: amanullashaikh555.com
LinkedIn: https://www.linkedin.com/in/amanulla-shaik-648788391/
GitHub: https://github.com/Aman-Analysis
Portfolio: https://aman-analysis.github.io/amanullashaik.github.io/
