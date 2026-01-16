import pandas as pd

def validate_sheets(dataframes, expected_sheets, required_columns):
    """
    Validates:
      All required sheets are present
      Each required sheet is non-empty
      Each required sheet contains a minimal set of expected columns
    """

    missing_sheets = expected_sheets - set(dataframes.keys())

    invalid_sheets = []

    for sheet_name, required_cols in required_columns.items():
        df = dataframes.get(sheet_name)
        if df is None:
            continue
        # Empty check
        if df.empty:
            invalid_sheets.append(f"{sheet_name} (empty)")
            continue

        cols_norm = {str(c).strip().lower() for c in df.columns}
        required_norm = {c.strip().lower() for c in required_cols}

        missing_cols = required_norm - cols_norm
        if missing_cols:
            invalid_sheets.append(
                f"{sheet_name} (Missing columns (Invalid header) : {', '.join(sorted(missing_cols))})")

    return missing_sheets, invalid_sheets
