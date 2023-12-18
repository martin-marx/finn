# ELT Challenge

## Overview
This challenge focuses on emulating an ELT (Extract, Load, Transform) cycle using Python, a RESTful API, and a SQLite database. You are given a Docker image with an API service application that provides access to the car subscription business primitives. 

Your task is to create a pipeline that extracts data from this API, loads it into a SQLite database, and transforms it into an analytical-ready schema.


## Objectives
**Extract** (E): Develop a Python application to extract all available data from the exposed API.

**Load** (L): Use the developed Python application to load the extracted data into a local SQLite database.

**Transform** (T): Transform the data into a schema that is ready for analytical queries. You can use Python or DBT for this purpose.

Provide detailed instructions on how to run the ELT and how to query the database in a separate markdown file.

### Considerations in Analytical Schema
The exposed analytical data set should be structured in a way that supports queries for the following domains:

Customer Acquisition domain use-cases:
- Analyze the active customer type share (e.g., B2B vs. B2C) per car brand, on a monthly basis.
- Customer type distribution per terms

Operations domain use-cases:
- Calculate the estimated volume of cars infleeted and defleeted per day.
- Determine the number of car deliveries per city per day.

## Getting Started

Pull the provided Docker image from the registry and run the API service.
```
docker run -d -p 8000:8000 finnauto/data_challenge_service:latest
```

The service documentation (OpenAPI) is available at [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)

*(Optional) Refer to manual service setup instructions at [service/SETUP.md](source/SETUP.md) if you _experience issues _running_ the docker_ image*

## Evaluation Criteria
- Python best practices
- Data modeling best practices
- Show us your work through your commit history
- Completeness: did you complete the features? Are all the tests running?
- Correctness: does the functionality act in sensible, thought-out ways?
- Maintainability: is it written in a clean, maintainable way?


This challenge offers a practical scenario to apply and showcase your skills in data engineering, Python programming, and database management. Good luck, and we look forward to seeing your solutions!