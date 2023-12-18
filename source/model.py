from sqlalchemy import Column, String, DateTime, Float, Enum, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.dialects.sqlite import VARCHAR
from sqlalchemy.orm import relationship
import uuid
from enum import Enum as PyEnum

Base = declarative_base()

class EngineType(PyEnum):
    electric = "electric"
    hybrid = "hybrid"
    gasoline = "gasoline"
    diesel = "diesel"

class CustomerType(PyEnum):
    b2b = "b2b"
    b2c = "b2c"

class InvoiceStatus(PyEnum):
    issued = "issued"
    overdue = "overdue"
    paid = "paid"

class LineItemType(PyEnum):
    subscription_fee = "subscription_fee"
    violation_fee = "violation_fee"
    discount = "discount"
    
class Term(PyEnum):
    six = 'six'
    twelve = 'twelve'

class Car(Base):
    __tablename__ = 'cars'
    id = Column(VARCHAR(36), primary_key=True, default=uuid.uuid4())
    vin = Column(String)
    brand = Column(String)
    model = Column(String)
    engine_type = Column(Enum(EngineType))
    license_plate = Column(String)
    registration_date = Column(DateTime)
    deregistration_date = Column(DateTime)
    

class Customer(Base):
    __tablename__ = 'customers'
    id = Column(VARCHAR(36), primary_key=True, default=str(uuid.uuid4()))
    first_name = Column(String)
    second_name = Column(String)
    type = Column(Enum(CustomerType))
    company_name = Column(String, nullable=True)
    address_city = Column(String)
    address_zip = Column(String)
    address_street = Column(String)
    address_street_house = Column(String)

class Subscription(Base):
    __tablename__ = 'subscriptions'
    id = Column(VARCHAR(36), primary_key=True, default=str(uuid.uuid4()))
    customer_id = Column(VARCHAR(36), ForeignKey('customers.id'))
    car_id = Column(VARCHAR(36), ForeignKey('cars.id'))
    created_at = Column(DateTime)
    start_date = Column(DateTime)
    term_month = Column(Enum(Term))
    monthly_rate = Column(Float)