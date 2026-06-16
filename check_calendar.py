import requests

url = "http://127.0.0.1:8000/market/calendar"
headers = {"X-API-Key": "dev_key"}

try:
    response = requests.get(url, headers=headers)
    print(f"Status: {response.status_code}")
    print(f"Body: {response.text}")
except Exception as e:
    print(f"Error: {e}")
