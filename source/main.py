from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from model import Base, Car, Customer, Subscription
from pydantic_sqlalchemy import sqlalchemy_to_pydantic
from typing import List

app = FastAPI()

DATABASE_URL = "sqlite:///./source.db"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)

Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

CarModel = sqlalchemy_to_pydantic(Car)
CustomerModel = sqlalchemy_to_pydantic(Customer)
SubscriptionModel = sqlalchemy_to_pydantic(Subscription)

@app.get("/cars/", response_model=List[CarModel])
def read_all_cars(db: Session = Depends(get_db)):
    cars = db.query(Car).all()
    return [CarModel.from_orm(car) for car in cars]

@app.get("/customers/", response_model=List[CustomerModel])
def read_all_customers(db: Session = Depends(get_db)):
    customers = db.query(Customer).all()
    return [CustomerModel.from_orm(customer) for customer in customers]

@app.get("/subscriptions/", response_model=List[SubscriptionModel])
def read_all_subscriptions(db: Session = Depends(get_db)):
    subscriptions = db.query(Subscription).all()
    return [SubscriptionModel.from_orm(subscription) for subscription in subscriptions]
