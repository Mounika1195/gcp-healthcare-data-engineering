CREATE TABLE IF NOT EXISTS
  `healthcare-de-demo.healthcare_curated.dim_patient`
(
  patient_sk STRING NOT NULL,
  patient_id STRING NOT NULL,
  patient_name STRING,
  gender STRING,
  dob DATE,
  blood_group STRING,
  city STRING,
  state STRING,
  insurance_id STRING,

  effective_from TIMESTAMP NOT NULL,
  effective_to TIMESTAMP,
  is_current BOOL NOT NULL,

  record_hash INT64,
  created_timestamp TIMESTAMP NOT NULL,
  updated_timestamp TIMESTAMP
)
PARTITION BY DATE(effective_from)
CLUSTER BY patient_id, city;