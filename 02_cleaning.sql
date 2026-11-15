-- Create a view without exact duplicate rows (one row per visit)
CREATE VIEW interpreter_services.visits_no_duplicates AS
SELECT DISTINCT *
FROM interpreter_services.patients_raw_v2;

-- Check raw values in professional_interpreter_received for visits
-- needing an interpreter
SELECT professional_interpreter_received, COUNT(*) AS visit_count
FROM interpreter_services.visits_no_duplicates 
WHERE interpreter_needed_recorded='Yes' 
GROUP BY professional_interpreter_received;

-- Check raw values in interpreter_needed_recorded and how often each appears
SELECT interpreter_needed_recorded, COUNT(*) AS interpreter_needed_count
FROM interpreter_services.visits_no_duplicates 
GROUP BY  interpreter_needed_recorded;

-- Create a clean view that standardizes interpreter need and service received into 
-- Yes, No, or NULL
CREATE VIEW interpreter_services.visits_clean AS
SELECT *,
    CASE
        WHEN interpreter_needed_recorded IN ('Yes', ' YES ', 'Y', '1') THEN 'Yes'
        WHEN interpreter_needed_recorded IN ('No', ' No ', 'N', '0') THEN 'No'
        ELSE NULL
    END AS interpreter_needed_clean,
    CASE
        WHEN professional_interpreter_received IN ('Yes', ' YES ', 'Y', '1') THEN 'Yes'
        WHEN professional_interpreter_received IN ('No', ' No ', 'N', '0') THEN 'No'
        ELSE NULL
    END AS professional_interpreter_received_clean
FROM interpreter_services.visits_no_duplicates;