## Setup instructions

### Python venv
1. Create and activate virtual environment in `/service` folder
```
$ python3 -m venv .venv
$ source .venv/bin/activate
```
2. Install service dependencies 
```
$ pip3 install -r requirements.txt
```

### DBT
3. Update the [profiles.yml](..%2Fdwh%2Fprofiles.yml)
Uncomment corresponding to your OS record of the crypto library(the last 3 records of the file) and comment the other two. By default the library for Mac is enabled

4. Run DBT and DBT tests
```
$ dbt run && dbt tests
```
Could be used several time to activate `incremental` tables logic
5. Check the result in the `dwh.db` database 

Customer Acquisition domain use-cases:
- Analyze the active customer type share (e.g., B2B vs. B2C) per car brand, on a monthly basis -> `type_share` view
- Customer type distribution per terms -> `type_distribution` table

Operations domain use-cases:
- Calculate the estimated volume of cars infleeted and defleeted per day. `defleeted_cars_volumes`/`infleeted_cars_volumes` views
- Determine the number of car deliveries per city per day. -> `cars_deliveries` view
