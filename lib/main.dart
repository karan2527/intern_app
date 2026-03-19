import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'src/data/datasources/quote_remote_data_source.dart';
import 'src/data/repositories/quote_repository_impl.dart';
import 'src/domain/usecases/get_random_quote.dart';
import 'src/presentation/controllers/quote_controller.dart';
import 'src/presentation/pages/quote_page.dart';

void main() {
  runApp(const FetchApp());
}

class FetchApp extends StatelessWidget {
  const FetchApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = http.Client();
    final remoteDataSource = QuoteRemoteDataSource(client);
    final repository = QuoteRepositoryImpl(remoteDataSource);
    final getRandomQuote = GetRandomQuote(repository);
    final controller = QuoteController(getRandomQuote: getRandomQuote);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch App',
      theme: _theme(),
      home: QuotePage(controller: controller),
    );
  }

  ThemeData _theme() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF5BC0BE),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: GoogleFonts.soraTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
