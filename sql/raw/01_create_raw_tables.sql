CREATE SCHEMA IF NOT EXISTS `healthcare-de-demo.healthcare_raw`
OPTIONS(location = 'us-central1');

CREATE OR REPLACE TABLE `healthcare-de-demo.healthcare_raw.raw_dim_date`
(
  date_id INT64,
  full_date DATE,
  year INT64,
  month INT64,
  month_name STRING,
  quarter INT64,
  day_of_month INT64,
  day_name STRING,
  is_weekend BOOL,
  load_timestamp TIMESTAMP
);

CREATE OR REPLACE TABLE `healthcare-de-demo.healthcare_raw.raw_dim_patient`
(
  patient_id STRING,
  patient_name STRING,
  gender STRING,
  dob DATE,
  blood_group STRING,
  city STRING,
  state STRING,
  insurance_id STRING,
  load_timestamp TIMESTAMP
);

CREATE OR REPLACE TABLE `healthcare-de-demo.healthcare_raw.raw_dim_hospital`
(
  hospital_id STRING,
  hospital_name STRING,
  city STRING,
  state STRING,
  hospital_type STRING,
  bed_capacity INT64,
  load_timestamp TIMESTAMP
);

CREATE OR REPLACE TABLE `healthcare-de-demo.healthcare_raw.raw_dim_doctor`
(
  doctor_id STRING,
  doctor_name STRING,
  department_id STRING,
  specialization STRING,
  hospital_id STRING,
  experience_years INT64,
  load_timestamp TIMESTAMP
);

CREATE OR REPLACE TABLE `healthcare-de-demo.healthcare_raw.raw_dim_department`
(
  department_id STRING,
  department_name STRING,
  load_timestamp TIMESTAMP
);

CREATE OR REPLACE TABLE `healthcare-de-demo.healthcare_raw.raw_dim_diagnosis`
(
  diagnosis_code STRING,
  diagnosis_name STRING,
  department_id STRING,
  department_name STRING,
  load_timestamp TIMESTAMP
);

CREATE OR REPLACE TABLE `healthcare-de-demo.healthcare_raw.raw_dim_insurance`
(
  insurance_id STRING,
  insurance_provider STRING,
  insurance_type STRING,
  max_coverage_amount NUMERIC,
  load_timestamp TIMESTAMP
);

CREATE OR REPLACE TABLE `healthcare-de-demo.healthcare_raw.raw_fact_appointments`
(
  appointment_id STRING,
  patient_id STRING,
  hospital_id STRING,
  doctor_id STRING,
  diagnosis_code STRING,
  appointment_date DATE,
  appointment_date_id INT64,
  visit_type STRING,
  consultation_fee NUMERIC,
  load_timestamp TIMESTAMP
);

CREATE OR REPLACE TABLE `healthcare-de-demo.healthcare_raw.raw_fact_claims`
(
  claim_id STRING,
  appointment_id STRING,
  patient_id STRING,
  hospital_id STRING,
  diagnosis_code STRING,
  insurance_id STRING,
  claim_date DATE,
  claim_date_id INT64,
  claim_amount NUMERIC,
  approved_amount NUMERIC,
  claim_status STRING,
  load_timestamp TIMESTAMP
);

CREATE OR REPLACE TABLE `healthcare-de-demo.healthcare_raw.raw_fact_billing`
(
  bill_id STRING,
  appointment_id STRING,
  patient_id STRING,
  hospital_id STRING,
  bill_date DATE,
  bill_date_id INT64,
  consultation_fee NUMERIC,
  medicine_charges NUMERIC,
  lab_charges NUMERIC,
  room_charges NUMERIC,
  total_bill_amount NUMERIC,
  payment_mode STRING,
  load_timestamp TIMESTAMP
);