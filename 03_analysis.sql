-- Count visits with unmet need (interpreter needed, professional interpreter not received)
SELECT COUNT(*) 
FROM interpreter_services.visits_clean
WHERE interpreter_needed_clean= 'Yes' AND professional_interpreter_received_clean='No'; 

-- Count visits with unmet need (interpreter needed, professional interpreter received)
SELECT COUNT(*) 
FROM interpreter_services.visits_clean
WHERE interpreter_needed_clean= 'Yes' AND professional_interpreter_received_clean='Yes'; 

-- Count visits with unknown outcome (interpreter needed, service received is missing)
SELECT COUNT(*) 
FROM interpreter_services.visits_clean
WHERE interpreter_needed_clean= 'Yes' AND professional_interpreter_received_clean IS NULL;

-- Calculate the unmet need percentage among visits with a known outcome (420 / 1,447)
SELECT ROUND(420.0 / 1447 * 100, 1) AS unmet_need_pct;

-- Count unmet-need visits by department (highest first)
SELECT department, COUNT(*) AS unmet_visits
FROM interpreter_services.visits_clean
WHERE interpreter_needed_clean = 'Yes'
  AND professional_interpreter_received_clean = 'No'
GROUP BY department
ORDER BY unmet_visits DESC;

-- Count visits with a known outcome by department (denominator for unmet need %)
SELECT department, COUNT(*) AS visits_with_known_outcome
FROM interpreter_services.visits_clean
WHERE interpreter_needed_clean = 'Yes'
  AND professional_interpreter_received_clean IN ('Yes', 'No')
GROUP BY department;

-- Calculate unmet need % by department (unmet / visits with known outcome), highest first
SELECT
    department,
    ROUND(
        100.0 * SUM(CASE
            WHEN professional_interpreter_received_clean = 'No' THEN 1
            ELSE 0
        END) / COUNT(*),
        1
    ) AS unmet_need_pct
FROM interpreter_services.visits_clean
WHERE interpreter_needed_clean = 'Yes'
  AND professional_interpreter_received_clean IN ('Yes', 'No')
GROUP BY department
ORDER BY unmet_need_pct DESC;

-- Calculate unmet need % by hospital (names standardized with UPPER and TRIM), highest first
SELECT
    UPPER(TRIM(hospital)),
    ROUND(
        100.0 * SUM(CASE
            WHEN professional_interpreter_received_clean = 'No' THEN 1
            ELSE 0
        END) / COUNT(*),
        1
    ) AS unmet_need_pct
FROM interpreter_services.visits_clean
WHERE interpreter_needed_clean = 'Yes'
  AND professional_interpreter_received_clean IN ('Yes', 'No')
GROUP BY UPPER(TRIM(hospital))
ORDER BY unmet_need_pct DESC;

-- Identify and rank the reasons for unmet interpreter needs
SELECT unmet_reason_recorded, COUNT(*) AS visit_count
FROM interpreter_services.visits_clean
WHERE interpreter_needed_clean = 'Yes'
  AND professional_interpreter_received_clean='No'
GROUP BY unmet_reason_recorded
ORDER BY visit_count DESC;

-- Identify and rank the reasons for unmet interpreter needs
  SELECT wait_minutes, COUNT(*) AS visits_count
  FROM interpreter_services.visits_clean
  WHERE interpreter_needed_clean = 'Yes'
  AND professional_interpreter_received_clean = 'Yes'
  GROUP BY wait_minutes;

-- Calculate the average interpreter waiting time, excluding identified invalid values
SELECT AVG(wait_minutes) AS avg_wait_minutes
FROM interpreter_services.visits_clean
WHERE interpreter_needed_clean = 'Yes'
  AND professional_interpreter_received_clean = 'Yes' 
  AND TRIM(wait_minutes) NOT IN ('unknown', '-10', '9999');
  
  -- Examine patient satisfaction scores among visits receiving interpreter services
 SELECT patient_satisfaction, COUNT(*) AS visits_count
  FROM interpreter_services.visits_clean
  WHERE interpreter_needed_clean = 'Yes'
  AND professional_interpreter_received_clean = 'Yes'
  GROUP BY patient_satisfaction;
  
-- Compare average patient satisfaction by interpreter service status using valid scores
  SELECT professional_interpreter_received_clean,
       COUNT(*) AS valid_score_count,
       ROUND(AVG(CAST(TRIM(patient_satisfaction) AS UNSIGNED)), 2) AS avg_satisfaction
FROM interpreter_services.visits_clean
WHERE interpreter_needed_clean = 'Yes'
  AND professional_interpreter_received_clean IN ('Yes', 'No')
  AND TRIM(patient_satisfaction) IN ('1', '2', '3', '4', '5')
GROUP BY professional_interpreter_received_clean;