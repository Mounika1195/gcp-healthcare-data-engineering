from apache_beam.io.filesystems import FileSystems
import yaml

from dataflow.utils.logger import get_logger


logger = get_logger(__name__)


def read_yaml_file(file_path):
    """
    Reads a YAML file from local path or GCS path and returns dictionary.
    """
    try:
        logger.info("Reading YAML file: %s", file_path)

        with FileSystems.open(file_path) as file:
            data = yaml.safe_load(file)

        logger.info("YAML file loaded successfully: %s", file_path)

        return data

    except Exception as error:
        logger.exception("Failed to read YAML file: %s", file_path)
        raise error