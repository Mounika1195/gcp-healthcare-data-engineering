import argparse

import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions

from dataflow.utils.config_reader import read_yaml_file
from dataflow.utils.csv_parser import parse_csv_line
from dataflow.utils.logger import get_logger
from dataflow.utils.transformations import clean_and_enrich_row
from dataflow.utils.validation import validate_row


logger = get_logger(__name__)


class ProcessCSVRow(beam.DoFn):
    def __init__(self, columns, primary_key):
        self.columns = columns
        self.primary_key = primary_key

    def process(self, line):
        row = parse_csv_line(line, self.columns)

        if not validate_row(row, self.columns, self.primary_key):
            return

        cleaned_row = clean_and_enrich_row(row)
        yield cleaned_row


def get_table_config(table_name, table_config):
    for table in table_config["tables"]:
        if table["table_name"] == table_name:
            return table

    raise ValueError(f"Table config not found for table: {table_name}")


def run():
    parser = argparse.ArgumentParser(
        description="Config-driven GCS to BigQuery batch pipeline"
    )

    parser.add_argument("--table_name", required=True)
    parser.add_argument("--config_path", default="config/config.yaml")
    parser.add_argument("--table_config_path", default="config/table_config.yaml")

    known_args, pipeline_args = parser.parse_known_args()

    config = read_yaml_file(known_args.config_path)
    table_config = read_yaml_file(known_args.table_config_path)

    selected_table = get_table_config(known_args.table_name, table_config)

    project_id = config["project"]["project_id"]
    raw_dataset = config["bigquery"]["raw_dataset"]
    temp_location = config["gcs"]["temp_path"]

    input_path = selected_table["source_path"]
    output_table = f"{project_id}:{raw_dataset}.{selected_table['raw_table']}"
    primary_key = selected_table["primary_key"]

    columns = selected_table["columns"]

    logger.info("Starting batch pipeline for table: %s", known_args.table_name)
    logger.info("Input path: %s", input_path)
    logger.info("Output table: %s", output_table)

    pipeline_options = PipelineOptions(
        pipeline_args,
        save_main_session=True
    )

    with beam.Pipeline(options=pipeline_options) as pipeline:
        (
            pipeline
            | "Read CSV From GCS" >> beam.io.ReadFromText(
                input_path,
                skip_header_lines=1
            )
            | "Parse Validate Transform Rows" >> beam.ParDo(
                ProcessCSVRow(columns, primary_key)
            )
            | "Write To BigQuery Raw Table" >> beam.io.WriteToBigQuery(
                output_table,
                write_disposition=beam.io.BigQueryDisposition.WRITE_TRUNCATE,
                create_disposition=beam.io.BigQueryDisposition.CREATE_NEVER,
                custom_gcs_temp_location=temp_location
            )
        )

    logger.info("Batch pipeline completed for table: %s", known_args.table_name)


if __name__ == "__main__":
    run()