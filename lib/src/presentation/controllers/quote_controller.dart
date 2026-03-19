import 'dart:async';

import '../../domain/entities/quote.dart';
import '../../domain/usecases/get_random_quote.dart';

class QuoteController {
  QuoteController({
    required GetRandomQuote getRandomQuote,
    this.refreshInterval = const Duration(seconds: 6),
  }) : _getRandomQuote = getRandomQuote;

  final GetRandomQuote _getRandomQuote;
  final Duration refreshInterval;

  final StreamController<QuoteUiState> _stateController =
      StreamController<QuoteUiState>.broadcast();

  QuoteUiState _state = const QuoteUiState();
  Timer? _timer;
  bool _requestInFlight = false;

  Stream<QuoteUiState> get stream => _stateController.stream;
  QuoteUiState get state => _state;

  Future<void> initialize() async {
    await refresh(showLoader: true);
    _timer = Timer.periodic(refreshInterval, (_) {
      refresh(showLoader: false);
    });
  }

  Future<void> refresh({bool showLoader = true}) async {
    if (_requestInFlight) return;

    _requestInFlight = true;
    _emit(
      _state.copyWith(
        isLoading: showLoader,
        isRefreshing: !showLoader,
        errorMessage: null,
      ),
    );

    try {
      final quote = await _getRandomQuote();
      _emit(
        _state.copyWith(
          quote: quote,
          isLoading: false,
          isRefreshing: false,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (_) {
      _emit(
        _state.copyWith(
          isLoading: false,
          isRefreshing: false,
          errorMessage:
              'Could not update data from the API. Try refreshing again.',
        ),
      );
    } finally {
      _requestInFlight = false;
    }
  }

  void _emit(QuoteUiState next) {
    _state = next;
    _stateController.add(next);
  }

  void dispose() {
    _timer?.cancel();
    _stateController.close();
  }
}

class QuoteUiState {
  const QuoteUiState({
    this.quote,
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.lastUpdated,
  });

  final Quote? quote;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;
  final DateTime? lastUpdated;

  QuoteUiState copyWith({
    Quote? quote,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    DateTime? lastUpdated,
  }) {
    return QuoteUiState(
      quote: quote ?? this.quote,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
