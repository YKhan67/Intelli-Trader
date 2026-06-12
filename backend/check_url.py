import requests

urls = [
    "https://raw.githubusercontent.com/philipperemy/FX-1-Minute-Data/master/EURUSD/EURUSD_2021.csv.zip",
    "https://raw.githubusercontent.com/philipperemy/FX-1-Minute-Data/main/EURUSD/EURUSD_2021.csv.zip",
    "https://raw.githubusercontent.com/philipperemy/FX-1-Minute-Data/master/EURUSD/2021.csv.zip",
    "https://raw.githubusercontent.com/philipperemy/FX-1-Minute-Data/main/EURUSD/2021.csv.zip"
]

for url in urls:
    try:
        r = requests.head(url, timeout=5)
        print(f"{url} -> {r.status_code}")
    except Exception as e:
        print(f"{url} -> Error: {e}")
