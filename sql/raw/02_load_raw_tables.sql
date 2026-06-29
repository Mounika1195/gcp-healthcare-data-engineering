LOAD DATA OVERWRITE `healthcare-de-demo.healthcare_raw.raw_dim_date`
FROM FILES (
  format = 'CSV',
  uris = ['gs://mounika-healthcare-data/landing/dim_date/dim_date.csv'],
  skip_leading_rows = 1
);

LOAD DATA OVERWRITE `healthcare-de-demo.healthcare_raw.raw_dim_patient`
FROM FILES (
  format = 'CSV',
  uris = ['gs://mounika-healthcare-data/landing/dim_patient/dim_patient.csv'],
  skip_leading_rows = 1
);

LOAD DATA OVERWRITE `healthcare-de-demo.healthcare_raw.raw_dim_hospital`
FROM FILES (
  format = 'CSV',
  uris = ['gs://mounika-healthcare-data/landing/dim_hospital/dim_hospital.csv'],
  skip_leading_rows = 1
);

LOAD DATA OVERWRITE `healthcare-de-demo.healthcare_raw.raw_dim_doctor`
FROM FILES (
  format = 'CSV',
  uris = ['gs://mounika-healthcare-data/landing/dim_doctor/dim_doctor.csv'],
  skip_leading_rows = 1
);

LOAD DATA OVERWRITE `healthcare-de-demo.healthcare_raw.raw_dim_department`
FROM FILES (
  format = 'CSV',
  uris = ['gs://mounika-healthcare-data/landing/dim_department/dim_department.csv'],
  skip_leading_rows = 1
);

LOAD DATA OVERWRITE `healthcare-de-demo.healthcare_raw.raw_dim_diagnosis`
FROM FILES (
  format = 'CSV',
  uris = ['gs://mounika-healthcare-data/landing/dim_diagnosis/dim_diagnosis.csv'],
  skip_leading_rows = 1
);

LOAD DATA OVERWRITE `healthcare-de-demo.healthcare_raw.raw_dim_insurance`
FROM FILES (
  format = 'CSV',
  uris = ['gs://mounika-healthcare-data/landing/dim_insurance/dim_insurance.csv'],
  skip_leading_rows = 1
);

LOAD DATA OVERWRITE `healthcare-de-demo.healthcare_raw.raw_fact_appointments`
FROM FILES (
  format = 'CSV',
  uris = ['gs://mounika-healthcare-data/landing/fact_appointments/fact_appointments.csv'],
  skip_leading_rows = 1
);

LOAD DATA OVERWRITE `healthcare-de-demo.healthcare_raw.raw_fact_claims`
FROM FILES (
  format = 'CSV',
  uris = ['gs://mounika-healthcare-data/landing/fact_claims/fact_claims.csv'],
  skip_leading_rows = 1
);

LOAD DATA OVERWRITE `healthcare-de-demo.healthcare_raw.raw_fact_billing`
FROM FILES (
  format = 'CSV',
  uris = ['gs://mounika-healthcare-data/landing/fact_billing/fact_billing.csv'],
  skip_leading_rows = 1
);