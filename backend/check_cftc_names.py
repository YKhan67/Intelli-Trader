import requests

def check_names():
    dataset_id = "6dca-aqww"
    url = f"https://publicreporting.cftc.gov/resource/{dataset_id}.json"
    
    # Simple query to find currency-like names
    params = {
        "$select": "market_and_exchange_names",
        "$where": "market_and_exchange_names like 'EURO FX%'",
        "$limit": 100
    }
    
    print(f"Fetching currency names from {url}...")
    try:
        response = requests.get(url, params=params, timeout=20)
        if response.status_code == 200:
            names = sorted(list(set([r['market_and_exchange_names'] for r in response.json()])))
            for n in names:
                print(f" - {n}")
        else:
            print(f"Failed: {response.status_code}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_names()
