import 'package:flutter/material.dart';
import '../../../../core/models/airport.dart';
import '../../../../core/services/flight_service.dart';
import '../../../../core/theme/app_theme.dart';

class AirportField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final FlightService service;
  final ValueChanged<Airport> onSelected;

  const AirportField({
    super.key,
    required this.hint,
    required this.icon,
    required this.service,
    required this.onSelected,
  });

  @override
  State<AirportField> createState() => _AirportFieldState();
}

class _AirportFieldState extends State<AirportField> {
  final _ctrl = TextEditingController();
  List<Airport> _results = [];
  bool _loading = false;

  Future<void> _search(String q) async {
    if (q.trim().length < 2) {
      setState(() => _results = []);
      return;
    }

    setState(() => _loading = true);
    try {
      final r = await widget.service.airportSearch(q.trim());
      if (!mounted) return;
      setState(() => _results = r);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _ctrl,
            onChanged: _search,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.45)),
              prefixIcon: Icon(widget.icon, color: AppTheme.primary),
              suffixIcon: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            ),
          ),
        ),

        if (_results.isNotEmpty) ...[
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black12)],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _results.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.black.withValues(alpha: 0.06)),
              itemBuilder: (_, i) {
                final a = _results[i];
                return ListTile(
                  dense: true,
                  title: Text(a.label, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(a.name),
                  onTap: () {
                    _ctrl.text = a.label;
                    setState(() => _results = []);
                    widget.onSelected(a);
                    FocusScope.of(context).unfocus();
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}