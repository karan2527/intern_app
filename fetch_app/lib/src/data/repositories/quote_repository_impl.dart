import '../../domain/entities/quote.dart';
import '../../domain/repositories/quote_repository.dart';
import '../datasources/quote_remote_data_source.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  QuoteRepositoryImpl(this._remoteDataSource);

  final QuoteRemoteDataSource _remoteDataSource;

  @override
  Future<Quote> getRandomQuote() {
    return _remoteDataSource.getRandomQuote();
  }
}
