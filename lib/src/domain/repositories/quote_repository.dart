//This file defines the QuoteRepository interface, which declares a method for fetching a random quote.
import '../entities/quote.dart';

abstract class QuoteRepository {
  Future<Quote> getRandomQuote();
}
