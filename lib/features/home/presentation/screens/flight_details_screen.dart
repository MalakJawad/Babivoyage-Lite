import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/flight.dart';

class FlightDetailsScreen extends StatelessWidget {
  final Flight flight;
  const FlightDetailsScreen({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    final nonStop = flight.nonStop;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF1F8),
      body: LayoutBuilder(
        builder: (_, constraints) {
          final maxWidth = constraints.maxWidth > 500 ? 430.0 : constraints.maxWidth;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                children: [
                  Container(
                    height: 64,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF0A4DB8), Color(0xFF4B86E3)],
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                          ),
                          const Spacer(),
                          const Text(
                            'BabiVoyage Lite',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          const Spacer(),
                          Icon(Icons.favorite_border, color: Colors.white.withValues(alpha: 0.95)),
                          const SizedBox(width: 12),
                          Icon(Icons.notifications_none, color: Colors.white.withValues(alpha: 0.95)),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                              color: Colors.black.withValues(alpha: 0.10),
                            ),
                          ],
                        ),
                        child: LayoutBuilder(
                          builder: (ctx, inner) {
                            final isNarrow = inner.maxWidth < 360;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${flight.from.code}  →  ${flight.to.code}',
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    _Pill(
                                      text: nonStop ? 'Non-Stop' : 'Stops',
                                      bg: Colors.green.withValues(alpha: 0.15),
                                      fg: Colors.green,
                                    ),
                                    const SizedBox(width: 10),
                                    _Pill(
                                      text: flight.status.isEmpty ? 'On Time' : flight.status,
                                      bg: Colors.green.withValues(alpha: 0.15),
                                      fg: Colors.green,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                Row(
                                  children: [
                                    Icon(Icons.flight, color: AppTheme.primary),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        flight.airline,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                    Text(
                                      '\$${flight.price.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                if (flight.flightNo.isNotEmpty)
                                  Text(
                                    flight.flightNo,
                                    style: TextStyle(
                                      color: Colors.black.withValues(alpha: 0.55),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                const SizedBox(height: 18),

                                if (isNarrow) ...[
                                  _TimeBox(title: 'Departure', time: flight.departTime, code: flight.from.code),
                                  const SizedBox(height: 12),
                                  _TimeBox(title: 'Arrival', time: flight.arriveTime, code: flight.to.code),
                                ] else ...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _TimeBox(
                                          title: 'Departure',
                                          time: flight.departTime,
                                          code: flight.from.code,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _TimeBox(
                                          title: 'Arrival',
                                          time: flight.arriveTime,
                                          code: flight.to.code,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],

                                const SizedBox(height: 14),

                                Row(
                                  children: [
                                    Expanded(child: _InfoRow(label: 'Cabin', value: flight.cabin)),
                                    Expanded(child: _InfoRow(label: 'Duration', value: flight.durationLabel)),
                                  ],
                                ),

                                const SizedBox(height: 18),

                                if (isNarrow) ...[
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.35)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                      ),
                                      child: const Text('More Details',
                                          style: TextStyle(fontWeight: FontWeight.w900)),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                      ),
                                      child: Text(
                                        'Book Now  \$${flight.price.toStringAsFixed(0)}',
                                        style: const TextStyle(fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {},
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.35)),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                          ),
                                          child: const Text('More Details',
                                              style: TextStyle(fontWeight: FontWeight.w900)),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppTheme.primary,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                          ),
                                          child: Text(
                                            'Book Now  \$${flight.price.toStringAsFixed(0)}',
                                            style: const TextStyle(fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const _Pill({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w900)),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String title;
  final String time;
  final String code;
  const _TimeBox({required this.title, required this.time, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.black.withValues(alpha: 0.55), fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(time, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(code, style: TextStyle(color: Colors.black.withValues(alpha: 0.55), fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label: ', style: TextStyle(color: Colors.black.withValues(alpha: 0.55), fontWeight: FontWeight.w800)),
        Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w900))),
      ],
    );
  }
}