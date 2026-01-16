# analytics-data-pipeline

Data Engineering Technical Assessment

This repository contains my solution to the Data Engineering Technical Assessment, covering:

- Part 1: Data pipeline, ingestion, and analytics warehouse design
- Part 2: AI-powered data extraction from web feeds (Kaggle notebook)
- Part 3: Data quality validation, anomaly detection, and monitoring dashboard


## Libraries and Tools

### Data Pipeline, Warehouse, and Monitoring (Tasks 1 & 3)
- Python
  - pandas
  - sqlalchemy
  - psycopg2
  - streamlit
  - logging
- PostgreSQL
- dbt
- Docker
- Docker Compose

### AI-Powered Data Extraction (Task 2)
- Python
  - pandas
  - requests
  - beautifulsoup4
  - re
- GLiNER (open-source LLM for entity extraction)
- transformers (zero-shot classification)


## How to Run Locally

Install libraries for Task 1 & 3
pip install pandas sqlalchemy openpyxl psycopg2-binary dbt-postgres streamlit

### 1. Start PostgreSQL
Ensure Docker Desktop is running, then from the project root directory:

```
docker compose -f backend/compose.yml up -d
```

### 2. Run Ingestion
From the project root directory, run:

```
python -m backend.main
```

### 3. Run dbt Models and Tests

```
cd database
dbt run
dbt test
```

### 4. Launch Monitoring Dashboard
From the project root directory, run:

```
cd ..
streamlit run backend/dashboard.py
```


## AI-Powered Data Extraction (Kaggle Notebook)

Part 2 is implemented as a Kaggle notebook:
https://www.kaggle.com/code/manthangharat/part-2-data-extraction

### How to Run on Kaggle
1. Enable GPU (optional): Settings → Accelerator → GPU  
2. Run all notebook cells from top to bottom  
3. Download generated CSV files from `/kaggle/working/`
