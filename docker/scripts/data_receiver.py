import requests
import json

def fetch_api_data():
    api_url = 'https://api.currencyapi.com/v3/latest?apikey=<your-key>'
    response = requests.get(api_url)
    data = response.json()

    with open('/usr/share/nginx/html/data.json', 'w') as file:
        json.dump(data, file)

fetch_api_data()