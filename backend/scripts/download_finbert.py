import os
from transformers import AutoTokenizer, AutoModelForSequenceClassification

def download_model():
    model_name = "ProsusAI/finbert"
    save_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../models/finbert"))
    
    print(f"Downloading {model_name} to {save_path}...")
    
    if not os.path.exists(save_path):
        os.makedirs(save_path, exist_ok=True)
        
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    model = AutoModelForSequenceClassification.from_pretrained(model_name)
    
    tokenizer.save_pretrained(save_path)
    model.save_pretrained(save_path)
    
    print("Download complete.")

if __name__ == "__main__":
    download_model()
