import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../home/data/home_api.dart';

class AdminScheduleScreen extends StatefulWidget {
  const AdminScheduleScreen({super.key});

  @override
  State<AdminScheduleScreen> createState() => _AdminScheduleScreenState();
}

class _AdminScheduleScreenState extends State<AdminScheduleScreen> {
  bool _loading = true;

  List<Map<String, dynamic>> _airports = [];
  List<dynamic> _flights = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final a = await HomeApi.adminListAirports();
      final f = await HomeApi.adminListFlights();
      if (!mounted) return;
      setState(() {
        _airports = a;
        _flights = f;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteFlight(int id) async {
    try {
      await HomeApi.adminDeleteFlight(id: id);
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  Future<void> _deleteAirport(String code) async {
    try {
      await HomeApi.adminDeleteAirport(code: code);
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  // ---------- UI Helpers ----------
  static String _fmtMoney(dynamic v) {
    final n = double.tryParse(v.toString()) ?? 0;
    return n.toStringAsFixed(n % 1 == 0 ? 0 : 2);
  }

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF6B86C8), Color(0xFF93A6D9)],
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
                            'Admin Schedule',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          const Spacer(),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: _loading
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: _load,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Flights',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 10),

                                  if (_flights.isEmpty)
                                    Text(
                                      'No flights yet.',
                                      style: TextStyle(color: Colors.black.withValues(alpha: 0.55)),
                                    )
                                  else
                                    ..._flights.map((f) {
                                      final from = (f['from_code'] ?? f['from']?['code'] ?? '').toString();
                                      final to = (f['to_code'] ?? f['to']?['code'] ?? '').toString();
                                      final airline = (f['airline'] ?? '').toString();
                                      final dep = (f['depart_time'] ?? '').toString();
                                      final arr = (f['arrive_time'] ?? '').toString();
                                      final price = _fmtMoney(f['price']);

                                      return _CardTile(
                                        title: '$from → $to · $airline',
                                        subtitle: '$dep - $arr · \$$price',
                                        onDelete: () => _deleteFlight((f['id'] as num).toInt()),
                                      );
                                    }),

                                  const SizedBox(height: 18),

                                  const Text(
                                    'Airports',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(height: 10),

                                  if (_airports.isEmpty)
                                    Text(
                                      'No airports yet.',
                                      style: TextStyle(color: Colors.black.withValues(alpha: 0.55)),
                                    )
                                  else
                                    ..._airports.map((a) {
                                      final code = a['code'].toString();
                                      final city = a['city'].toString();
                                      final name = a['name'].toString();

                                      return _CardTile(
                                        title: '$city ($code)',
                                        subtitle: name,
                                        onDelete: () => _deleteAirport(code),
                                      );
                                    }),

                                  const SizedBox(height: 90),
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

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'add_airport',
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.primary,
            onPressed: () async {
            },
            icon: const Icon(Icons.add_location_alt),
            label: const Text('Add Airport', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'add_flight',
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            onPressed: () async {
            },
            icon: const Icon(Icons.flight_takeoff),
            label: const Text('Add Flight', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onDelete;

  const _CardTile({
    required this.title,
    required this.subtitle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5)),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.black.withValues(alpha: 0.55), fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}