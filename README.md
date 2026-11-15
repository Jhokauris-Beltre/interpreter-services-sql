# Interpreter Services Gap Analysis (SQL)

## Question

Among hospital visits where a patient needed an interpreter, how often did they **not** receive a professional interpreter, and where is that gap concentrated?

## Data

Synthetic dataset generated for practice purposes. It contains no real patient or client information.

- Source table: `interpreter_services.patients_raw_v2` (5,073 rows)
- After removing exact duplicates: 5,000 unique visits
- Key fields: hospital, department, interpreter need, professional interpreter received, reason the need was unmet, wait time, and patient satisfaction

## Tools

MySQL (data audit, cleaning, and analysis) · Power BI (visualizations, coming soon)

## Analysis Plan

### 1. Audit the source data
- Open `interpreter_services.patients_raw_v2` in MySQL.
- Confirm the 5,073 source rows.
- Count unique visits and look for empty or repeated `encounter_id` values.

### 2. Clean only what affects the question
- If two rows are exact copies, keep one.
- If the same `encounter_id` has conflicting data, review the conflict.
- Keep separate visits from the same patient.
- Review the values in language, English proficiency, interpreter need, and service received.
- Standardize Yes, No, and missing values.
- Keep missing values separate from "No."

### 3. Define the indicators
- Create a possible limited English proficiency (LEP) indicator from language and English proficiency, after reviewing the actual categories in the data.
- Use `interpreter_needed_recorded` to measure recorded need.
- Needed and received a professional interpreter → **service received**.
- Needed and recorded as not received → **unmet need**.
- Needed and the service field is blank → **unknown outcome**.

### 4. Answer the main question
- Count total visits.
- Count visits with a recorded need.
- Among visits with a need, count received, unmet, and unknown.
- Calculate the unmet percentage among visits with a known outcome.
- Report how many visits had an unknown outcome.

### 5. Find where the gap is concentrated
- Group by hospital and by department.
- Show the number and percentage of unmet visits.
- Include how many visits needed the service in each group.

### 6. Describe what happened
- Among unmet visits, count the recorded reasons and how many had no documented reason.
- Among served visits, summarize recorded wait times and count how many are missing.
- Compare patient satisfaction by service status, showing how many visits have a recorded score.

### 7. Validate and export
- Confirm the final table has one row per visit.
- Confirm that received + unmet + unknown equals all visits with a recorded need.
- Export the clean table and check that the totals match in Power BI.

## Key Findings

- 1,459 of 5,000 visits (29.2%) had a recorded need for an interpreter.
- Of the 1,447 visits with a known outcome, **420 (29.0%) did not receive a professional interpreter**.
- 12 visits needed an interpreter had an unknown outcome and were excluded from the percentage.

**Unmet need by department** (visits with a known outcome)

| Department | Visits needing an interpreter | Unmet | Unmet % |
|---|---|---|---|
| Cardiology | 285 | 93 | 32.6% |
| Primary Care | 295 | 90 | 30.5% |
| Emergency | 311 | 91 | 29.3% |
| Pediatrics | 285 | 80 | 28.1% |
| Outpatient Surgery | 271 | 66 | 24.4% |

**Unmet need by hospital**

| Hospital | Visits with known outcome | Unmet | Unmet % |
|---|---|---|---|
| Central | 458 | 139 | 30.3% |
| South | 494 | 141 | 28.5% |
| North | 495 | 140 | 28.3% |

**Reasons recorded for unmet need** (420 visits)

| Reason | Visits |
|---|---|
| Interpreter unavailable | 97 |
| No reason documented | 83 |
| Family interpreted | 81 |
| Technical problem | 46 |
| Patient declined | 43 |
| Visit ended before connection | 41 |
| Request not entered | 29 |

The gap is spread across all three hospitals (28–30%), but varies more by department, with Cardiology highest (32.6%) and Outpatient Surgery lowest (24.4%). Interpreter unavailability was the most common recorded reason, and 1 in 5 unmet visits had no reason documented.

## Data Quality Notes

- 73 exact duplicate rows were found in the 5,073 source rows and removed, leaving 5,000 unique visits.
- Interpreter need and service received were recorded inconsistently ("Yes", " YES ", "Y", "1"; "No", " No ", "N", "0") and were standardized to Yes, No, or NULL.
- Hospital names had inconsistent capitalization and spacing and were standardized with `UPPER(TRIM())`.
- Wait times included invalid values (-10, 9999, "unknown"), which were excluded from averages.
- Satisfaction scores outside the valid 1–5 range were excluded from averages.
- 83 of 420 unmet visits (19.8%) had no documented reason.

## Repository Structure

00_create_database.sql        create and select the database
01_data_audit.sql             duplicates, row counts, value checks
02_cleaning.sql               deduplicated and standardized views
03_analysis.sql               unmet need by hospital, department, and reason
04_validation.sql             totals and consistency checks
interpreter_visits_clean.csv  final clean table exported for Power BI
README.md
