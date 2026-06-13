from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

class VaderScorer:
    def __init__(self):
        self.analyzer = SentimentIntensityAnalyzer()

    def score(self, text: str) -> float:
        """
        Returns compound score normalized to -1.0 to +1.0.
        """
        if not text:
            return 0.0
        scores = self.analyzer.polarity_scores(text)
        return float(scores['compound'])
