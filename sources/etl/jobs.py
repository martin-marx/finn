from enum import Enum


class Jobs(str, Enum):
    subscriptions = 'subscriptions'
    customers = 'customers'
    cars = 'cars'
