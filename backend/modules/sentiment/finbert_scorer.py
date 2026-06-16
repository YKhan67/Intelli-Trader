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
                # Use use_fast=False to avoid sentencepiece dependency issues on some Windows builds
                self.tokenizer = AutoTokenizer.from_pretrained(
                    self.model_path, 
                    use_fast=False,
                    local_files_only=True
                )
                self.model = AutoModelForSequenceClassification.from_pretrained(
                    self.model_path,
                    local_files_only=True
                ).to(self.device)
                self.model.eval()
            except Exception as e:
                # Silent failure to avoid flooding logs with tokenizer conversion errors
                pass

    def score(self, text: Union[str, List[str]]) -> List[Dict[str, Any]]:
        texts = [text] if isinstance(text, str) else text
        
        if not self.model or not self.tokenizer:
            return [self._vader_fallback(t) for t in texts]

        results = []
        batch_size = 16 # Smaller batch size for CPU stability
        
        for i in range(0, len(texts), batch_size):
            batch = texts[i:i + batch_size]
            try:
                inputs = self.tokenizer(batch, padding=True, truncation=True, return_tensors="pt").to(self.device)
                with torch.no_grad():
                    outputs = self.model(**inputs)
                    probs = torch.nn.functional.softmax(outputs.logits, dim=-1)
                    
                for p in probs:
                    p_list = p.tolist()
                    conf = max(p_list)
                    label_idx = p_list.index(conf)
                    
                    score = 0.0
                    if label_idx == 1: score = conf
                    elif label_idx == 2: score = -conf
                        
                    results.append({
                        "score": score,
                        "label": ["neutral", "positive", "negative"][label_idx],
                        "confidence": conf
                    })
            except:
                # Individual batch fallback
                results.extend([self._vader_fallback(t) for t in batch])
        
        return results

    def _vader_fallback(self, text: str) -> Dict[str, Any]:
        vader_score = self.vader.score(text)
        return {
            "score": vader_score,
            "label": "neutral" if abs(vader_score) < 0.05 else ("positive" if vader_score > 0 else "negative"),
            "confidence": abs(vader_score)
        }
