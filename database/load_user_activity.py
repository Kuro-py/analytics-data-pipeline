import logging
from sqlalchemy import create_engine, text


def load_to_postgres(dfs, db_url, schema="landing"):
    engine = create_engine(db_url)

    with engine.begin() as conn:
        conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {schema};"))

        for sheet_name, df in dfs.items():
            table_name = sheet_name.strip().lower().replace(" ", "_")
            full_table = f"{schema}.{table_name}"

            # 1. Create table if it does not exist
            df.head(0).to_sql(
                name=table_name,
                con=conn,
                schema=schema,
                if_exists="append",
                index=False,
            )

            #Truncate existing data
            conn.execute(text(f"TRUNCATE TABLE {full_table};"))

            # 3. Insert fresh data
            df.to_sql(
                name=table_name,
                con=conn,
                schema=schema,
                if_exists="append",
                index=False,
            )

            logging.info(
                f"Loaded {full_table} rows={len(df)} cols={df.shape[1]}"
            )
