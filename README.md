# analytics-data-pipeline

Data Engineering Technical Assessment

This repository contains my solution to the Data Engineering Technical Assessment, covering:

- Part 1: Data pipeline, ingestion, and analytics warehouse design
- Part 2: AI-powered data extraction from web feeds (Kaggle notebook)
- Part 3: Data quality validation, anomaly detection, and monitoring dashboard

Libraries and tools used for the data pipeline, warehouse, and monitoring components:

- Python
  - pandas
  - sqlalchemy
  - psycopg2
  - streamlit
  - logging

- Data Warehouse & Transformation
  - PostgreSQL
  - dbt

- Containerisation
  - Docker
  - Docker Compose

Libraries and tools used for AI-powered data extraction and enrichment:

- Python
  - pandas
  - requests
  - beautifulsoup4
  - re

- NLP / AI
  - GLiNER (open-source LLM for entity extraction)
  - transformers (zero-shot classification)

- Execution Environment
  - Kaggle Notebook

HOW TO RUN

1. Start Postgres

1.1. Ensure Docker Desktop is running
1.2. Navigate to the project root directory
1.3. Run: docker compose -f backend/compose.yml up -d


2. Run Ingestion

2.1 From the project root directory, run: python -m backend.main


3. Run dbt Models and Tests

3.1 cd database
3.2 dbt run
3.3 dbt test


4. Launch Monitoring Dashboard

From the project root directory, run:
streamlit run backend/dashboard.py




AI-POWERED DATA EXTRACTION (KAGGLE NOTEBOOK)

Part 2 is implemented as a Kaggle notebook:
https://www.kaggle.com/code/manthangharat/part-2-data-extraction

How to run on Kaggle:

1. Enable GPU (optional): Settings → Accelerator → GPU
   (The notebook can also run on CPU, but execution will be slower.)
2. Install dependencies (already included in the notebook).
3. Run all cells from top to bottom.
4. Download the generated CSV files from /kaggle/working/
