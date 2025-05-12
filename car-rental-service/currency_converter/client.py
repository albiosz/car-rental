import os
from decimal import Decimal

import requests
import zeep

from exceptions.currencies import CurrencyServiceUnavailableException

_currency_converter_client_instance = None

# Factory function that creates and returns a client instance
def get_currency_converter_client_instance():
    global _currency_converter_client_instance
    if _currency_converter_client_instance is None:
        try:
            _currency_converter_client_instance = CurrencyConverterClient()
        except Exception as e:
            raise CurrencyServiceUnavailableException(str(e))
    return _currency_converter_client_instance

class CurrencyConverterClient:
    def __init__(self):
        self.jwt_token = get_jwt_token()
        self.client = get_currency_converter_client(self.jwt_token)
        
    def get_available_currencies(self) -> list:
        try:
            return self.client.service.getAvailableCurrencies()
        except Exception as e:
            raise CurrencyServiceUnavailableException(str(e))

    def convert(self, from_currency: str, to_currency: str, amount: Decimal) -> Decimal:
        try:
            price_in_cent = int(amount * 100)
            converted_price_in_cent = self.client.service.convert(from_currency, to_currency, price_in_cent)
            return (Decimal(converted_price_in_cent) / Decimal('100')).quantize(Decimal('0.00'))
        except Exception as e:
            raise CurrencyServiceUnavailableException(str(e))
    
    def get_currency_rate(self, from_currency: str, to_currency: str) -> Decimal:
        try:
            currency_rate_in_cent = self.client.service.convert(from_currency, to_currency, 100)
            return (Decimal(currency_rate_in_cent) / Decimal('100')).quantize(Decimal('0.00'))
        except Exception as e:
            raise CurrencyServiceUnavailableException(str(e))

def get_jwt_token() -> str:
    cognito_client_id = os.getenv("COGNITO_CLIENT_ID")
    cognito_client_secret = os.getenv("COGNITO_CLIENT_SECRET")
    cognito_domain_prefix = os.getenv("COGNITO_DOMAIN_PREFIX")
    cognito_region = os.getenv("COGNITO_REGION")

    if cognito_client_id is None or cognito_client_secret is None or cognito_domain_prefix is None or cognito_region is None:
        raise CurrencyServiceUnavailableException("Cognito env variables not set!")

    try:
        response = requests.post(
           f'https://{cognito_domain_prefix}.auth.{cognito_region}.amazoncognito.com/oauth2/token',
            data=f"grant_type=client_credentials&client_id={cognito_client_id}&client_secret={cognito_client_secret}&scope=currency-converter/read",
            headers={'Content-Type': 'application/x-www-form-urlencoded'}
        )
        
        if response.status_code != 200:
            raise CurrencyServiceUnavailableException(f"Failed to get JWT token: {response.json()}")

        return response.json()['access_token']
    except Exception as e:
        raise CurrencyServiceUnavailableException(f"Error getting JWT token: {str(e)}")
    
    
def get_currency_converter_client(jwt_token: str) -> zeep.Client:
    try:
        # Get host from environment variable or use default
        currency_converter_host = os.environ.get('CURRENCY_CONVERTER_HOST', 'currency-converter')
        
        # Build the WSDL URL using the proper host
        wsdl_url = f'{currency_converter_host}/ws/currencies.wsdl'
        
        # Create transport with session that includes the headers
        session = requests.Session()
        session.headers.update({"Authorization": f"Bearer {jwt_token}"})
        
        transport = zeep.Transport(
            session=session,
            timeout=10, 
            operation_timeout=10
        )
        
        # Create the client with the updated transport
        return zeep.Client(wsdl=wsdl_url, transport=transport)
    except Exception as e:
        error_message = f"Error connecting to currency converter service: {e}"
        raise CurrencyServiceUnavailableException(error_message)
