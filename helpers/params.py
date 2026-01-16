
# Database configuration
DB_URL = "postgresql+psycopg2://admin:postpass@localhost:5432/warehouse"
DB_SCHEMA = "landing"

# Input files
INPUT_EXCEL_PATH = "./backend/user_activity_data.xlsx"

# Validation rules
EXPECTED_SHEETS = {
    "user_activity_source_a_web",
    "user_activity_source_b_mobile",
    "user_activity_source_c_marketin",
}

REQUIRED_COLUMNS = {
    "user_activity_source_a_web": {"user_id", "event"},
    "user_activity_source_b_mobile": {"uid", "action", "ts"},
    "user_activity_source_c_marketing": {
        "user_id",
        "activity_type",
        "activity_timestamp",
    },
}


# Logging
LOG_LEVEL = "INFO"
