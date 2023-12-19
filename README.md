# ELT Challenge

## Description

### ETL
* The ETL pipeline is just a Python app which can be run in 3 modes for 3 different sources(Cars/Subscriptions/Customers)
* [Dynaconf](https://www.dynaconf.com/) is used for config
* The connections are closed without `try`, `except` because there is not too much sense to worry about memory leaks since the pipeline goals is just to deliver data
* The ORM objects have default value for `processing_date` which is used by the DBT incremental models

### DWH
* The initial layer of DWH contains only 3 predefined tables which are expected to be the place to store raw data. The tables don't have any constrains except `id` and `processing_date` are expected to be not null
* The core layer is build as Data Vault ![DBT DAG.png](DBT%20DAG.png)
* The marts layer is build with the respect to defined problems
* It's suggested that instead of SQLite an analytical DB would be used. Like BigQuery or Redshift which means B-Tree indexes are not used
* For some datamarts custom daily/monthly "partition" replacement was build because SQLite doesn't support partitioning
* PII data could be possible managed by Cloud tools to enable hashing or proper access to certain columns
* An assumption has been made that subscriptions data never changes
* An assumption has been made that cars and customers data can be updated over time

## Possible improvements

### ETL
* Use an API with batch processing to fetch data in chunks
* Build proper Circuit Breaker for the fetching service
* Add Unit/It tests

### DWH
* Add DBT macros to avoid code duplicate
* Add tests which compare counters from 2+ different models to validate logic

### General
* Dockerise everything and build orchestration. For example using Apache Airflow
* Add Data Lake layer to store data in a raw format before processing it in DWH. For example GCS/S3
* Add Dashboards using visualisation tools. For example Tableau/PowerBI

## Instructions

* In order to run the pipelines correctly Python 3.11 or a later version is required
* The repository contains 3 folders. Each folder corresponds to a solution for the assignment
* The DWH database is already located in `DWH` folder

### The algorithm
1. Run the source service using instructions from the [SETUP.md](etl%2FSETUP.md) 
2. Run the ETLs [SETUP.md](etl%2FSETUP.md)
3. Run DBT [SETUP.md](dwh%2FSETUP.md)
