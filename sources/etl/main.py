from dao import insert_data
from jobs import Jobs
from model import Car, Customer, Subscription
from dynaconf import settings
from datetime import datetime

import sys
import logging
import requests

date_format = settings.from_env('default').DATE_FORMAT


def __fetch_date(url):
    response = requests.get(url)
    json_result = response.json()
    response.close()
    return json_result


def __convert_car(car):
    date_format = '%Y-%m-%dT%H:%M:%S.%f'

    converted_car = Car(**car)

    if converted_car.registration_date is not None:
        converted_car.registration_date = datetime.strptime(converted_car.registration_date, date_format)

    if converted_car.deregistration_date is not None:
        converted_car.deregistration_date = datetime.strptime(converted_car.deregistration_date, date_format)

    return converted_car


def __convert_customer(customer):
    converted_customer = Customer(**customer)

    return converted_customer


def __convert_subscription(subscription):
    date_format = '%Y-%m-%dT%H:%M:%S.%f'

    converted_subscription = Subscription(**subscription)

    if converted_subscription.created_at is not None:
        converted_subscription.created_at = datetime.strptime(converted_subscription.created_at, date_format)

    if converted_subscription.start_date is not None:
        converted_subscription.start_date = datetime.strptime(converted_subscription.start_date, date_format)

    return converted_subscription


def __convert_entity(job_name, entities):
    match job_name:
        case Jobs.cars.value:
            return [__convert_car(parsed_car) for parsed_car in entities]
        case Jobs.customers.value:
            return [__convert_customer(parsed_customer) for parsed_customer in entities]
        case Jobs.subscriptions.value:
            return [__convert_subscription(parsed_subscription) for parsed_subscription in entities]
        case _:
            logging.error("Unknown job type has been started. Shut down the app")
            sys.exit()


if __name__ == '__main__':
    job_name = sys.argv[1]
    logging.info(f"Start import job {job_name}")
    url = f"{settings.from_env('default').URL}{settings.from_env(job_name).ROUTE}"

    json_result = __fetch_date(url)
    logging.info("Fetched data")
    converted_result = __convert_entity(job_name, json_result)
    filter_converted_result = filter(lambda el: el.id is not None, converted_result)
    insert_data(filter_converted_result)
    logging.info("The data has been inserted. Shutting down the job")
