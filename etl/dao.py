from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from model import Car, Customer, Subscription, Base
from pydantic_sqlalchemy import sqlalchemy_to_pydantic
from dynaconf import settings

engine = create_engine(settings.from_env('default').DB_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
Base.metadata.create_all(bind=engine)
CarModel = sqlalchemy_to_pydantic(Car)
CustomerModel = sqlalchemy_to_pydantic(Customer)
SubscriptionModel = sqlalchemy_to_pydantic(Subscription)


def insert_data(entities):
    connection = SessionLocal()
    connection.add_all(entities)
    connection.commit()
    connection.close()
