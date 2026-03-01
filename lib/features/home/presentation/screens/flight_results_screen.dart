import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/flight.dart';
import 'flight_details_screen.dart';

class FlightResultsScreen extends StatelessWidget {
  final String from;
  final String to;
  final DateTime date;
  final int adults;
  final String cabin;
  final List<Flight> flights;

  const FlightResultsScreen({
    super.key,
    required this.from,
    required this.to,
    required this.date,
    required this.adults,
    required this.cabin,
    required this.flights,
  });

  @override
  Widget build(BuildContext context) {
    final title = '$from to $to';
    final subtitle = '${_formatDate(date)} · $adults Adult · $cabin';

    return Scaffold(
      backgroundColor: const Color(0xFFEFF1F8),
      body: LayoutBuilder(
        builder: (_, constraints) {
          final maxWidth = constraints.maxWidth > 500 ? 430.0 : constraints.maxWidth;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/welcome_bg.png', fit: BoxFit.cover),
                  Container(color: Colors.black.withValues(alpha: 0.10)),

                  SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                              ),
                              const Spacer(),
                              const Text(
                                'BabiVoyage Lite',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(width: 44),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _GlassCard(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        subtitle,
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.80),
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _MiniAction(
                                              icon: Icons.tune,
                                              label: 'Filter',
                                              onTap: () {},
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _MiniAction(
                                              icon: Icons.swap_vert,
                                              label: 'Sort All',
                                              onTap: () {},
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 14),

                                if (flights.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Center(
                                      child: Text(
                                        'No flights found for this date.',
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.85),
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  ...flights.map(
                                    (f) => _FlightCard(
                                      airline: f.airline,
                                      price: f.price.toStringAsFixed(0),
                                      depart: f.departTime,
                                      arrive: f.arriveTime,
                                      duration: f.durationLabel,
                                      stops: f.nonStop ? 'Non-Stop' : 'Stops',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => FlightDetailsScreen(flight: f),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                const SizedBox(height: 90),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SafeArea(
                      top: false,
                      child: Container(
                        height: 72,
                        margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _NavItem(icon: Icons.home, label: 'Home', active: true, onTap: () {}),
                            _NavItem(icon: Icons.work_outline, label: 'My Trips', active: false, onTap: () {}),
                            _NavItem(icon: Icons.notifications_none, label: 'Notifications', active: false, onTap: () {}),
                            _NavItem(icon: Icons.person_outline, label: 'Profile', active: false, onTap: () {}),
                          ],
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

  static String _formatDate(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final dow = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][d.weekday - 1];
    return '$dow, ${months[d.month - 1]} ${d.day}';
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: Colors.white.withValues(alpha: 0.30), width: 1),
        ),
        child: child,
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MiniAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54, size: 20),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _FlightCard extends StatelessWidget {
  final String airline;
  final String price;
  final String depart;
  final String arrive;
  final String duration;
  final String stops;
  final VoidCallback onTap;

  const _FlightCard({
    required this.airline,
    required this.price,
    required this.depart,
    required this.arrive,
    required this.duration,
    required this.stops,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 14,
              offset: const Offset(0, 8),
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.flight, color: AppTheme.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    airline,
                    style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w900),
                  ),
                ),
                Text(
                  '\$$price',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(depart, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(width: 10),
                Icon(Icons.arrow_forward, size: 18, color: Colors.black.withValues(alpha: 0.35)),
                const SizedBox(width: 10),
                Text(arrive, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(duration, style: TextStyle(color: Colors.black.withValues(alpha: 0.55), fontWeight: FontWeight.w700)),
                const SizedBox(width: 18),
                Text(stops, style: TextStyle(color: Colors.black.withValues(alpha: 0.55), fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppTheme.primary : Colors.black54;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}