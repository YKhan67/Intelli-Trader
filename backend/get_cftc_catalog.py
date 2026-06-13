import requests
import json

def get_catalog():
    url = "https://publicreporting.cftc.gov/api/views.json"
    params = {"limit": 100}
    
    print(f"Fetching catalog from {url}...")
    try:
        response = requests.get(url, params=params, timeout=20)
        if response.status_code == 200:
            data = response.json()
            print(f"Found {len(data)} datasets.")
            for view in data:
                name = view.get('name', '')
                print(f" - {name}: ID={view.get('id')}")
        else:
            print(f"Failed: {response.status_code}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    get_catalog()
