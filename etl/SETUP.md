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

### Run the jobs
3. Launch the job for each service 
```
$ python3 main.py subscriptions && python3 main.py cars && python3 main.py customers
```
