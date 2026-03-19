import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class GetRandomQuote {
  const GetRandomQuote(this._repository);

  final QuoteRepository _repository;

  Future<Quote> call() {
    return _repository.getRandomQuote();
  }
}
