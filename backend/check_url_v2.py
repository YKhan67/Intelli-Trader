import requests

symbol = "EURUSD"
year = "2021"
base_urls = [
    f"https://raw.githubusercontent.com/philipperemy/FX-1-Minute-Data/master",
    f"https://raw.githubusercontent.com/philipperemy/FX-1-Minute-Data/main"
]

paths = [
    f"/{symbol}/{symbol}_{year}.csv.zip",
    f"/{symbol}_{year}.csv.zip",
    f"/histdata/{symbol}/{symbol}_{year}.csv.zip",
    f"/{symbol}/{year}.csv.zip",
    f"/{symbol.lower()}/{symbol.lower()}_{year}.csv.zip"
]

for base in base_urls:
    for path in paths:
        url = base + path
        try:
            r = requests.head(url, timeout=5)
            if r.status_code == 200:
                print(f"FOUND: {url}")
            else:
                pass
        except:
            pass
print("Check complete.")
