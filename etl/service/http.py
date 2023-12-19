from requests.exceptions import Timeout
from dynaconf import settings
from logging import warning
from time import sleep

import requests
import logging
import sys


def fetch_data(url):
    retries = settings.from_env('default').REQUEST_RETRIES
    timeout = settings.from_env('default').REQUEST_TIMEOUT_SECONDS
    sleep_time = settings.from_env('default').REQUEST_TIMEOUT_SECONDS
    sleep_multiplicator = settings.from_env('default').REQUEST_TIMEOUT_SECONDS

    for attempt in range(retries):
        try:
            response = requests.get(url, timeout=timeout)

            if response.status_code == 200:
                return response.json()
            elif 400 <= response.status_code < 500:
                logging.error(f"Client error: {response.status_code}")
                sys.exit()
            elif 500 <= response.status_code:
                warning(f"Server error: {response.status_code}")
                if attempt <= retries - 1:
                    warning(f"Retrying. {retries - 1 - attempt} more attempts")
                    sleep(sleep_time)
                    sleep_time = sleep_time * sleep_multiplicator
                    continue
                else:
                    logging.error(f"The job failed due to the external server issues after {retries} retries")
                    sys.exit()
            else:
                warning(f"Unexpected error: {response.status_code}")
                sys.exit()
        except Timeout:
            warning("Request timed out.")
            if attempt <= retries - 1:
                warning(f"Retrying. {retries - 1 - attempt} more attempts")
                sleep(sleep_time)
                sleep_time = sleep_time * sleep_multiplicator
                continue
            else:
                logging.error(f"The job failed due to timeout after {retries} retries")
                sys.exit()
        except Exception as e:
            logging.error(f"Unexpected error occurred: {str(e)}")
            sys.exit()
