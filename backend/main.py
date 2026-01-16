import sys
import logging
import pandas as pd
from backend.validate_file import validate_sheets
from database.load_user_activity import load_to_postgres
from helpers.params import (
    DB_URL,
    DB_SCHEMA,
    INPUT_EXCEL_PATH,
    EXPECTED_SHEETS,
    REQUIRED_COLUMNS,
    LOG_LEVEL,
)

# Logging
logging.basicConfig(level=getattr(logging, LOG_LEVEL))
logger = logging.getLogger(__name__)

# Load input file
user_activity_data_df = pd.read_excel(INPUT_EXCEL_PATH, sheet_name=None)


def notify_and_exit(missing_sheets, invalid_sheets):
    if missing_sheets:
        logger.error(f"Missing sheets: {', '.join(missing_sheets)}")

    if invalid_sheets:
        logger.error(f"Invalid sheets: {', '.join(invalid_sheets)}")

    logger.error("User activity load failed due to errors in the input file")
    sys.exit(1)


def clean_cols(df):
    df = df.copy()
    df.columns = (
        df.columns.astype(str)
        .str.strip()
        .str.lower()
        .str.replace(r"\s+", "_", regex=True)
    )
    return df


# Normalise column names
user_activity_data_df = {
    name: clean_cols(df) for name, df in user_activity_data_df.items()
}

# Validate input
missing, invalid = validate_sheets(
    user_activity_data_df,
    EXPECTED_SHEETS,
    REQUIRED_COLUMNS,
)

if missing or invalid:
    notify_and_exit(missing, invalid)

logger.info("Input file is ready to be loaded")

# Load validated data into Postgres landing schema
load_to_postgres(
    user_activity_data_df,
    DB_URL,
    schema=DB_SCHEMA,
)

logger.info("File ingested to landing")
