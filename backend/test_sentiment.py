import asyncio
import os
import sys
from datetime import datetime, timezone

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.modules.sentiment import SentimentManager

async def main():
    print("Initializing Sentiment Manager...")
    # NOTE: FinBERT might not be loaded if not downloaded, will fallback to VADER
    manager = SentimentManager()
    
    # 1. Process some articles if they exist
    print("Processing any unscored articles...")
    processed = await manager.processor.process_unscored_articles(limit=10)
    print(f"Processed {processed} articles.")
    
    # 2. Run aggregation
    print("Running sentiment aggregation...")
    await manager.aggregator.aggregate_all()
    
    # 3. Get sentiment for a pair
    pair = "EURUSD"
    print(f"Fetching sentiment for {pair}...")
    try:
        result = await manager.get_sentiment(pair)
        
        print(f"\n--- Sentiment Result for {pair} ---")
        print(f"Pair Score: {result.pair_score:.2f}")
        print(f"Trend: {result.sentiment_trend}")
        print(f"COT Bias: {result.cot_bias}")
        print(f"Pre-News Block: {result.pre_news_block}")
        print(f"Hard Block: {result.hard_block}")
        print(f"Post-News Window: {result.post_news_window}")
        
        if result.top_headlines:
            print("\nTop Headlines:")
            for h in result.top_headlines:
                print(f" - {h}")
        else:
            print("\nNo headlines found for this pair.")
            
    except Exception as e:
        print(f"Error during sentiment fetching: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    asyncio.run(main())
