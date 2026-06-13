import requests
import io
import zipfile
import pandas as pd
import os
import sys

def debug_cftc():
    # Try multiple years and URL variants
    test_cases = [
        {"name": "Current TXT", "url": "https://www.cftc.gov/dea/futures/deafut.txt"},
        {"name": "2024 TXT", "url": "https://www.cftc.gov/files/dea/history/deafut2024.txt"},
        {"name": "Google Check", "url": "https://www.google.com"}
    ]
    
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    }

    for case in test_cases:
        url = case["url"]
        print(f"Testing URL: {url}...")
        try:
            response = requests.get(url, headers=headers, timeout=20)
            if response.status_code == 200:
                print(f"SUCCESS for {case['year']}!")
                with zipfile.ZipFile(io.BytesIO(response.content)) as z:
                    filename = z.namelist()[0]
                    print(f"File inside: {filename}")
                    with z.open(filename) as f:
                        df = pd.read_csv(f, low_memory=False)
                        print(f"Total rows: {len(df)}")
                        print("Columns:", list(df.columns[:5]))
                return # Stop at first success
            else:
                print(f"Failed: {response.status_code}")
        except Exception as e:
            print(f"Error: {e}")

if __name__ == "__main__":
    debug_cftc()
