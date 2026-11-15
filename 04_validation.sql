-- Validate one row per visit: total rows should equal unique encounter_ids (expected: 5,000)
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT encounter_id) AS unique_visits
FROM interpreter_services.visits_clean;

-- Select final clean columns for export to Power BI (interpreter_visits_clean.csv)
SELECT
    encounter_id,
    department,
    UPPER(TRIM(hospital)) AS hospital_clean,
    interpreter_needed_clean,
    professional_interpreter_received_clean,
    unmet_reason_recorded
FROM interpreter_services.visits_clean;