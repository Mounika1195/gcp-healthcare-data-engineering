from dataflow.utils.logger import get_logger


logger = get_logger(__name__)


def validate_row(row, columns, primary_key):
    """
    Validates parsed CSV row.
    """

    if row is None:
        return False

    if len(row) != len(columns):
        logger.error("Column count mismatch. Row: %s", row)
        return False

    if primary_key not in row or row[primary_key] in [None, ""]:
        logger.error("Primary key missing. Primary key: %s Row: %s", primary_key, row)
        return False

    return True