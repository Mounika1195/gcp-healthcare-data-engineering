from datetime import datetime, timezone

from dataflow.utils.logger import get_logger


logger = get_logger(__name__)


def clean_and_enrich_row(row):
    """
    Cleans string values and adds audit column.
    """

    cleaned_row = {}

    for key, value in row.items():
        if isinstance(value, str):
            cleaned_row[key] = value.strip()
        else:
            cleaned_row[key] = value

    cleaned_row["load_timestamp"] = datetime.now(timezone.utc).isoformat()

    return cleaned_row