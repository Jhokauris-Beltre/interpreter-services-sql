-- Count total rows in the raw table 
SELECT COUNT(*)
FROM interpreter_services.patients_raw_v2;

-- Count unique visits (distinct encounter_id values)
SELECT COUNT(DISTINCT encounter_id) AS visitas_distintas
FROM interpreter_services.patients_raw_v2;

-- Count rows with a NULL encounter_id
SELECT COUNT(*) AS ids_nulos
FROM interpreter_services.patients_raw_v2
WHERE encounter_id IS NULL;

-- Count rows with a blank encounter_id (empty or only spaces)
SELECT COUNT(*) AS ids_vacios
FROM interpreter_services.patients_raw_v2
WHERE TRIM(encounter_id) = '';

-- List duplicate values in encounter_id
SELECT encounter_id, COUNT(*) AS row_count
FROM interpreter_services.patients_raw_v2
GROUP BY encounter_id
HAVING COUNT(*) > 1;

-- Count how many encounter_ids appear more than once
SELECT COUNT(*) AS repeated_encounter_count
FROM (
    SELECT encounter_id
    FROM interpreter_services.patients_raw_v2
    GROUP BY encounter_id
    HAVING COUNT(*) > 1
) AS repeated_encounters; 

-- Find exact duplicate rows (identical values in every column)
SELECT patient_id,encounter_id, visit_date, age, hospital, department, shift, preferred_language, english_proficiency,
interpreter_needed_recorded, interpreter_requested, professional_interpreter_received, interpretation_mode, unmet_reason_recorded,
wait_minutes, visit_duration_minutes, patient_satisfaction, insurance, COUNT(*) AS row_count
FROM interpreter_services.patients_raw_v2
GROUP BY patient_id,encounter_id, visit_date, age, hospital, department, shift, preferred_language, english_proficiency,
interpreter_needed_recorded, interpreter_requested, professional_interpreter_received, interpretation_mode, unmet_reason_recorded,
wait_minutes, visit_duration_minutes, patient_satisfaction, insurance
HAVING COUNT(*) > 1
ORDER BY encounter_id;

-- Count rows that would remain after removing exact duplicates (expected: 5,000)
SELECT COUNT(*) AS deduplicated_row_count
FROM (
    SELECT DISTINCT *
    FROM interpreter_services.patients_raw_v2
) AS deduplicated_no_visits;