from pathlib import Path

import yaml

from dataflow.utils.logger import get_logger


logger = get_logger(__name__)


def read_yaml_file(file_path):
    """
    Reads a YAML file and returns the content as a Python dictionary.
    """
    try:
        path = Path(file_path)

        if not path.exists():
            raise FileNotFoundError(f"Config file not found: {file_path}")

        logger.info("Reading YAML file: %s", file_path)

        with open(path, "r", encoding="utf-8") as file:
            data = yaml.safe_load(file)

        logger.info("YAML file loaded successfully: %s", file_path)

        return data

    except Exception as error:
        logger.exception("Failed to read YAML file: %s", file_path)
        raise error