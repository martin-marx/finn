import requests

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from model import Car, Base
from pydantic_sqlalchemy import sqlalchemy_to_pydantic

from datetime import datetime

url = "http://localhost:8000/cars"

DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
Base.metadata.create_all(bind=engine)
CarModel = sqlalchemy_to_pydantic(Car)


def convert_car(car):
    date_format = '%Y-%m-%dT%H:%M:%S.%f'

    converted_car = Car(**car)

    if converted_car.registration_date is not None:
        converted_car.registration_date = datetime.strptime(converted_car.registration_date, date_format)

    if converted_car.deregistration_date is not None:
        converted_car.deregistration_date = datetime.strptime(converted_car.deregistration_date, date_format)

    return converted_car


response = requests.get(url)
parsed = response.json()
parsed_list = [convert_car(parsed_car) for parsed_car in parsed]
one_car = parsed_list[0]

connection = SessionLocal()
connection.add_all(parsed_list)
connection.commit()
connection.close()
