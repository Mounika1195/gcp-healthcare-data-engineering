DECLARE load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP();

BEGIN TRANSACTION;

CREATE TEMP TABLE source_patient AS
SELECT
  patient_id,
  patient_name,
  gender,
  dob,
  blood_group,
  city,
  state,
  insurance_id,

  FARM_FINGERPRINT(
    CONCAT(
      COALESCE(patient_name, ''), '|',
      COALESCE(gender, ''), '|',
      COALESCE(CAST(dob AS STRING), ''), '|',
      COALESCE(blood_group, ''), '|',
      COALESCE(city, ''), '|',
      COALESCE(state, ''), '|',
      COALESCE(insurance_id, '')
    )
  ) AS record_hash

FROM `healthcare-de-demo.healthcare_staging.stg_dim_patient`;

-- Expire the old current version when patient attributes changed.
UPDATE `healthcare-de-demo.healthcare_curated.dim_patient` AS target
SET
  effective_to = load_ts,
  is_current = FALSE,
  updated_timestamp = load_ts
WHERE target.is_current = TRUE
  AND EXISTS (
    SELECT 1
    FROM source_patient AS source
    WHERE source.patient_id = target.patient_id
      AND source.record_hash != target.record_hash
  );

-- Insert completely new patients and new versions of changed patients.
INSERT INTO `healthcare-de-demo.healthcare_curated.dim_patient`
(
  patient_sk,
  patient_id,
  patient_name,
  gender,
  dob,
  blood_group,
  city,
  state,
  insurance_id,
  effective_from,
  effective_to,
  is_current,
  record_hash,
  created_timestamp,
  updated_timestamp
)
SELECT
  GENERATE_UUID() AS patient_sk,
  source.patient_id,
  source.patient_name,
  source.gender,
  source.dob,
  source.blood_group,
  source.city,
  source.state,
  source.insurance_id,
  load_ts AS effective_from,
  NULL AS effective_to,
  TRUE AS is_current,
  source.record_hash,
  load_ts AS created_timestamp,
  NULL AS updated_timestamp
FROM source_patient AS source
LEFT JOIN `healthcare-de-demo.healthcare_curated.dim_patient` AS target
  ON source.patient_id = target.patient_id
 AND target.is_current = TRUE
WHERE target.patient_id IS NULL
   OR source.record_hash != target.record_hash;

COMMIT TRANSACTION;