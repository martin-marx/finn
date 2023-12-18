# Setup instructions

The service image is available for `linux/amd64` and `linux/arm64` architectures in the public Docker registry.

In case of incompatibility use one of the following methods to start the application.

## Docker
Use a terminal to bootstrap the service
1. Build: 
```
$ docker build -t finnauto/data_challenge_service:latest .
```
2. Run: 
```
$ docker run -d -p 8000:8000 finnauto/data_challenge_service
```

## Python venv
1. Create and activate virtual environment in `/service` folder
```
$ python3 -m venv .venv
$ source .venv/bin/activate
```
2. Install service dependencies 
```
$ pip3 install -r requirements.txt
```

3. Launch the app 
```
$ uvicorn main:app --host 0.0.0.0 --port 8000
```

## API Docs
The UI and OpenAPI spec are available at http://127.0.0.1:8000/docs