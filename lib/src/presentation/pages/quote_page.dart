import 'package:flutter/material.dart';

import '../controllers/quote_controller.dart';

class QuotePage extends StatefulWidget {
  const QuotePage({super.key, required this.controller});

  final QuoteController controller;

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  @override
  void initState() {
    super.initState();
    widget.controller.initialize();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuoteUiState>(
      stream: widget.controller.stream,
      initialData: widget.controller.state,
      builder: (context, snapshot) {
        final state = snapshot.data ?? const QuoteUiState();

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Live Quote Pulse'),
            actions: [
              IconButton(
                onPressed: state.isLoading
                    ? null
                    : () => widget.controller.refresh(showLoader: false),
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Refresh now',
              ),
            ],
          ),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0B132B),
                  Color(0xFF1C2541),
                  Color(0xFF3A506B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedOpacity(
                      opacity: state.isRefreshing ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: const LinearProgressIndicator(minHeight: 3),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Auto-refresh every ${widget.controller.refreshInterval.inSeconds}s',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: state.isLoading
                              ? const CircularProgressIndicator()
                              : _QuoteCard(state: state),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: state.isLoading
                          ? null
                          : () => widget.controller.refresh(showLoader: false),
                      icon: const Icon(Icons.bolt_rounded),
                      label: const Text('Update Data Now'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.lastUpdated == null
                          ? 'Waiting for first update...'
                          : 'Last updated: ${_formatDateTime(state.lastUpdated!)}',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    final seconds = dateTime.second.toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.state});

  final QuoteUiState state;

  @override
  Widget build(BuildContext context) {
    final quote = state.quote;

    return Container(
      key: ValueKey(quote?.id ?? 'empty'),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withValues(alpha: 0.12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.errorMessage != null) ...[
            Text(
              state.errorMessage!,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: const Color(0xFFFFD6D6)),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            quote?.content ?? 'No quote yet.',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(height: 1.35),
          ),
          const SizedBox(height: 18),
          Text(
            quote == null ? '' : '- ${quote.author}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
