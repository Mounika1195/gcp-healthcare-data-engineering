from datetime import datetime, timedelta

from airflow import DAG
from airflow.providers.google.cloud.operators.dataflow import DataflowCreatePythonJobOperator


PROJECT_ID = "healthcare-de-demo"
REGION = "us-central1"
BUCKET = "mounika-healthcare-data"

DEFAULT_ARGS = {
    "owner": "mounika",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}


with DAG(
    dag_id="healthcare_batch_dataflow_dag",
    default_args=DEFAULT_ARGS,
    description="Batch healthcare Dataflow pipeline from GCS to BigQuery raw layer",
    start_date=datetime(2026, 6, 27),
    schedule_interval=None,
    catchup=False,
    tags=["healthcare", "batch", "dataflow", "bigquery"],
) as dag:

    load_dim_patient = DataflowCreatePythonJobOperator(
        task_id="load_dim_patient_to_raw",
        py_file=f"gs://{BUCKET}/dataflow/pipelines/gcs_to_bigquery_batch.py",
        job_name="healthcare-dim-patient-batch-load",
        location=REGION,
        project_id=PROJECT_ID,
        options={
            "project": PROJECT_ID,
            "region": REGION,
            "runner": "DataflowRunner",
            "temp_location": f"gs://{BUCKET}/temp",
            "staging_location": f"gs://{BUCKET}/staging",
            "table_name": "dim_patient",
            "config_path": f"gs://{BUCKET}/config/config.yaml",
            "table_config_path": f"gs://{BUCKET}/config/table_config.yaml",
        },
    )