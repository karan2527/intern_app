import '../../domain/entities/quote.dart';

class QuoteModel extends Quote {
  const QuoteModel({
    required super.id,
    required super.content,
    required super.author,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      content: json['quote'] as String? ?? 'No quote found',
      author: json['author'] as String? ?? 'Unknown',
    );
  }
}
