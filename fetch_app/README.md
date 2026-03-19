# Fetch App

A modern Flutter application that demonstrates Clean Architecture by fetching live data from a public API and presenting it in a polished, auto-updating interface.

## Overview

Fetch App displays a random quote from a public API and keeps data fresh with automatic background refreshes. It also gives users direct control with manual refresh actions through both `IconButton` and `ElevatedButton` interactions.

This project is suitable as an internship or portfolio assignment because it showcases:

- API integration
- UI/UX quality
- state handling
- periodic background updates
- clean architecture layering

## Features

- Fetches random quotes from a public API (`https://dummyjson.com/quotes/random`)
- Clean, modern Material 3 UI with gradient styling and custom typography
- Auto-refreshes data every 6 seconds
- Manual refresh from:
	- top app bar refresh icon (`IconButton`)
	- primary action button (`ElevatedButton`)
- Loading, refreshing, and error states handled in UI
- Last updated timestamp shown on screen

## Architecture

The app follows a simple Clean Architecture structure:

- `presentation`: UI and controller/state orchestration
- `domain`: entities, repository contracts, and use cases
- `data`: API data source, DTO/model mapping, repository implementation

### Flow

1. UI triggers refresh (manual or periodic timer).
2. Controller calls domain use case.
3. Use case calls repository contract.
4. Data repository fetches from remote data source.
5. Result is mapped to domain entity and emitted to UI state stream.

## Project Structure

```text
lib/
	main.dart
	src/
		data/
			datasources/
				quote_remote_data_source.dart
			models/
				quote_model.dart
			repositories/
				quote_repository_impl.dart
		domain/
			entities/
				quote.dart
			repositories/
				quote_repository.dart
			usecases/
				get_random_quote.dart
		presentation/
			controllers/
				quote_controller.dart
			pages/
				quote_page.dart
```

## Tech Stack

- Flutter (Material 3)
- Dart
- `http` for REST calls
- `google_fonts` for typography

## Getting Started

### Prerequisites

- Flutter SDK installed
- Dart SDK (bundled with Flutter)
- Any Flutter-supported editor (VS Code / Android Studio)

### Run Locally

```bash
flutter pub get
flutter run
```

## Testing

Run widget tests with:

```bash
flutter test
```

## API Reference

- Endpoint: `GET https://dummyjson.com/quotes/random`
- Example response fields used:
	- `id`
	- `quote`
	- `author`

## Notes on Refresh Behavior

- Initial load shows a full-screen loader.
- Auto-refresh updates happen in the background with a subtle top progress indicator.
- Repeated refresh taps are safely ignored while a request is already in flight.

## Future Improvements

- Add local caching and offline fallback
- Add retry/backoff strategy for network failures
- Add integration tests for refresh timing behavior
- Add dependency injection package for scalable wiring

## Author

Created as a Clean Architecture Flutter API-fetch assignment project.
