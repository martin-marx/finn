import requests

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from model import Subscription, Base
from pydantic_sqlalchemy import sqlalchemy_to_pydantic

from datetime import datetime

url = "http://localhost:8000/subscriptions"

DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
Base.metadata.create_all(bind=engine)
SubscriptionModel = sqlalchemy_to_pydantic(Subscription)


def convert_subscription(subscription):
    date_format = '%Y-%m-%dT%H:%M:%S.%f'

    converted_subscription = Subscription(**subscription)

    if converted_subscription.created_at is not None:
        converted_subscription.created_at = datetime.strptime(converted_subscription.created_at, date_format)

    if converted_subscription.start_date is not None:
        converted_subscription.start_date = datetime.strptime(converted_subscription.start_date, date_format)

    return converted_subscription


response = requests.get(url)
parsed = response.json()
parsed_list = [convert_subscription(parsed_subscription) for parsed_subscription in parsed]

connection = SessionLocal()
connection.add_all(parsed_list)
connection.commit()
connection.close()
