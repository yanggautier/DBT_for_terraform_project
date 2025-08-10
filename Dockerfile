FROM python:3.13-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir \
    dbt_bigquery==1.10.1 \
    dbt-core=1.10.0 \
    pytz=2024.1

# Create dbt profiles directory
WORKDIR /usr/src/dbt/dbt_project

# COPY the dbt project files into the container
COPY . .

# Set the working directory to the dbt project
CMD ["dbt", "build", "--profiles-dir", "/opt/dbt/profiles"]