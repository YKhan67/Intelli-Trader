import requests
import json

def test_api():
    # Dataset ID for "Commitments of Traders - Legacy (Futures Only)"
    dataset_id = "6dca-aqww"
    url = f"https://publicreporting.cftc.gov/resource/{dataset_id}.json"
    
    params = {
        "$limit": 5,
        "$order": "report_date_as_yyyy_mm_dd DESC"
    }
    
    print(f"Testing Socrata API: {url}...")
    try:
        response = requests.get(url, params=params, timeout=20)
        if response.status_code == 200:
            data = response.json()
            print("SUCCESS! Received data.")
            print(json.dumps(data, indent=2))
        else:
            print(f"Failed: {response.status_code}")
            print(response.text)
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    test_api()
