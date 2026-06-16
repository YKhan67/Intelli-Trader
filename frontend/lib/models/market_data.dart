class NewsItem {
  final String title;
  final String source;
  final DateTime timestamp;
  final double sentimentScore;
  final List<String> currencies;

  NewsItem({
    required this.title,
    required this.source,
    required this.timestamp,
    required this.sentimentScore,
    required this.currencies,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['headline'] ?? json['title'] ?? '',
      source: json['source'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      sentimentScore: (json['sentiment_score'] ?? 0).toDouble(),
      currencies: List<String>.from(json['currencies_mentioned'] ?? []),
    );
  }
}

class CalendarEvent {
  final String name;
  final DateTime timestamp;
  final String currency;
  final String impact;

  CalendarEvent({
    required this.name,
    required this.timestamp,
    required this.currency,
    required this.impact,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      name: json['event_name'],
      timestamp: DateTime.parse(json['timestamp']),
      currency: json['currency'],
      impact: json['impact'],
    );
  }
}
