import os
import torch
from transformers import AutoTokenizer, AutoModelForSequenceClassification
from typing import List, Dict, Any, Union
from .vader_scorer import VaderScorer

class FinBERTScorer:
    def __init__(self, model_path: str):
        self.model_path = model_path
        self.tokenizer = None
        self.model = None
        self.vader = VaderScorer()
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        self._load_model()

    def _load_model(self):
        if os.path.exists(self.model_path):
            try:
                self.tokenizer = AutoTokenizer.from_pretrained(self.model_path)
                self.model = AutoModelForSequenceClassification.from_pretrained(self.model_path).to(self.device)
                self.model.eval()
            except Exception as e:
                print(f"Warning: Could not load FinBERT from {self.model_path}: {e}")

    def score(self, text: Union[str, List[str]]) -> List[Dict[str, Any]]:
        """
        Runs text through FinBERT and returns score -1.0 to +1.0 with label and confidence.
        Falls back to VADER if FinBERT is not loaded.
        """
        texts = [text] if isinstance(text, str) else text
        
        if not self.model or not self.tokenizer:
            return [self._vader_fallback(t) for t in texts]

        results = []
        batch_size = 32
        
        for i in range(0, len(texts), batch_size):
            batch = texts[i:i + batch_size]
            inputs = self.tokenizer(batch, padding=True, truncation=True, return_tensors="pt").to(self.device)
            
            with torch.no_grad():
                outputs = self.model(**inputs)
                probs = torch.nn.functional.softmax(outputs.logits, dim=-1)
                
            for p in probs:
                # FinBERT labels: 0: neutral, 1: positive, 2: negative
                p_list = p.tolist()
                conf = max(p_list)
                label_idx = p_list.index(conf)
                
                # Normalize to -1.0 to 1.0
                if label_idx == 1: # positive
                    score = conf
                elif label_idx == 2: # negative
                    score = -conf
                else: # neutral
                    score = 0.0
                    
                results.append({
                    "score": score,
                    "label": ["neutral", "positive", "negative"][label_idx],
                    "confidence": conf
                })
        
        return results

    def _vader_fallback(self, text: str) -> Dict[str, Any]:
        vader_score = self.vader.score(text)
        return {
            "score": vader_score,
            "label": "neutral" if abs(vader_score) < 0.05 else ("positive" if vader_score > 0 else "negative"),
            "confidence": abs(vader_score)
        }
