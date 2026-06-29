import csv

from dataflow.utils.logger import get_logger


logger = get_logger(__name__)


def parse_csv_line(line, columns):
    """
    Converts one CSV line into a Python dictionary.
    """

    try:
        reader = csv.reader([line])
        values = next(reader)

        row = dict(zip(columns, values))

        return row

    except Exception as error:
        logger.exception("Failed to parse CSV line: %s", line)
        return None