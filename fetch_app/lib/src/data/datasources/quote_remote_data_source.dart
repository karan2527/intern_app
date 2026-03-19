import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/quote_model.dart';

class QuoteRemoteDataSource {
  QuoteRemoteDataSource(this._client);

  final http.Client _client;
  static final Uri _endpoint = Uri.parse('https://dummyjson.com/quotes/random');

  Future<QuoteModel> getRandomQuote() async {
    final response = await _client.get(_endpoint);

    if (response.statusCode != 200) {
      throw Exception('Unable to load quote right now.');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return QuoteModel.fromJson(decoded);
  }
}
