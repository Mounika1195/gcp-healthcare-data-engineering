CREATE OR REPLACE TABLE
  `healthcare-de-demo.healthcare_staging.stg_dim_patient`
AS
SELECT
  TRIM(patient_id) AS patient_id,
  INITCAP(TRIM(patient_name)) AS patient_name,

  CASE
    WHEN UPPER(TRIM(gender)) IN ('M', 'MALE') THEN 'M'
    WHEN UPPER(TRIM(gender)) IN ('F', 'FEMALE') THEN 'F'
    ELSE 'UNKNOWN'
  END AS gender,

  dob,
  UPPER(TRIM(blood_group)) AS blood_group,
  INITCAP(TRIM(city)) AS city,
  INITCAP(TRIM(state)) AS state,
  TRIM(insurance_id) AS insurance_id,
  load_timestamp,

  CURRENT_TIMESTAMP() AS staging_timestamp

FROM `healthcare-de-demo.healthcare_raw.raw_dim_patient`

WHERE patient_id IS NOT NULL
  AND TRIM(patient_id) != ''

QUALIFY ROW_NUMBER() OVER (
  PARTITION BY patient_id
  ORDER BY load_timestamp DESC
) = 1;