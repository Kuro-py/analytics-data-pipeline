import pandas as pd
import streamlit as st
from sqlalchemy import create_engine

DB_URL = "postgresql+psycopg2://admin:postpass@localhost:5432/warehouse"
# Create database connection
engine = create_engine(DB_URL)

st.title("Daily Users Monitoring")

# Load DAU and anomaly data from database
df = pd.read_sql(
    """
    select event_date, dau, prev_dau, pct_change, is_anomaly, anomaly_type
    from analytics.dq_anomalies_dau
    order by event_date
    """,
    engine,
)

# Plot daily active users
st.subheader("Daily Active Users (DAU)")
st.caption("Unique users with at least one event per day")
st.line_chart(df.set_index("event_date")[["dau"]])

# Display detected anomalies
st.subheader("DAU Anomaly Detection")
st.subheader("Detected DAU Spikes and Drops")
st.caption("Anomalies are flagged when day-over-day DAU changes exceed ±50%")
st.dataframe(df[df["is_anomaly"] == True], use_container_width=True)
