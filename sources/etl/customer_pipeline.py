import requests

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from model import Customer, Base
from pydantic_sqlalchemy import sqlalchemy_to_pydantic

from datetime import datetime

url = "http://localhost:8000/customers"

DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
Base.metadata.create_all(bind=engine)
CustomerModel = sqlalchemy_to_pydantic(Customer)


def convert_customer(customer):

    converted_customer = Customer(**customer)

    return converted_customer


response = requests.get(url)
parsed = response.json()
parsed_list = [convert_customer(parsed_customer) for parsed_customer in parsed]

connection = SessionLocal()
connection.add_all(parsed_list)
connection.commit()
connection.close()
