import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/home_api.dart';
import '../screens/flight_results_screen.dart';
import '../../../admin/presentation/admin_schedule_screen.dart'; // ✅ add this

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();

  String? _fromCode;
  String? _toCode;

  DateTime _date = DateTime.now().add(const Duration(days: 1));
  int _adults = 1;
  String _cabin = 'Economy';

  bool _loading = false;

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  String _apiDate(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  Future<void> _search() async {
    if (_fromCode == null || _toCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select valid airports for From and To.')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final flights = await HomeApi.searchFlights(
        from: _fromCode!,
        to: _toCode!,
        date: _apiDate(_date),
        adults: _adults,
        cabin: _cabin,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FlightResultsScreen(
            from: _fromCtrl.text.trim(),
            to: _toCtrl.text.trim(),
            date: _date,
            adults: _adults,
            cabin: _cabin,
            flights: flights,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ✅ ADMIN GATE (must be inside _HomeScreenState)
  Future<void> _openAdminGate() async {
    final ok = await _askAdminPin();
    if (ok != true) return;

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminScheduleScreen()),
    );
  }

  Future<bool?> _askAdminPin() async {
    final ctrl = TextEditingController();
    bool hide = true;

    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setS) {
            return AlertDialog(
              title: const Text('Admin Access'),
              content: TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                obscureText: hide,
                decoration: InputDecoration(
                  labelText: 'Enter PIN',
                  suffixIcon: IconButton(
                    onPressed: () => setS(() => hide = !hide),
                    icon: Icon(hide ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (ctrl.text.trim() == '741852963') {
                      Navigator.pop(ctx, true);
                    } else {
                      Navigator.pop(ctx, false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wrong PIN')),
                      );
                    }
                  },
                  child: const Text('Enter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Container(color: Colors.black.withValues(alpha: 0.12)),
                  SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Spacer(),
                              const Text(
                                'BabiVoyage Lite',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const Spacer(),
                              Stack(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.35),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.35),
                                        width: 1,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.person, color: Colors.white),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '1',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: Column(
                              children: [
                                _GlassCard(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'From',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      _AirportTypeAheadField(
                                        controller: _fromCtrl,
                                        hint: 'Select departure',
                                        icon: Icons.location_on,
                                        onPicked: (code, label) {
                                          _fromCode = code;
                                          _fromCtrl.text = label;
                                          setState(() {});
                                        },
                                        onTextChanged: () {
                                          _fromCode = null;
                                        },
                                      ),

                                      const SizedBox(height: 12),

                                      _AirportTypeAheadField(
                                        controller: _toCtrl,
                                        hint: 'Select destination',
                                        icon: Icons.location_on,
                                        onPicked: (code, label) {
                                          _toCode = code;
                                          _toCtrl.text = label;
                                          setState(() {});
                                        },
                                        onTextChanged: () {
                                          _toCode = null;
                                        },
                                      ),

                                      const SizedBox(height: 12),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: _MiniField(
                                              text: _formatDate(_date),
                                              icon: Icons.calendar_month,
                                              onTap: _pickDate,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _MiniField(
                                              text: '$_adults Adult · $_cabin',
                                              icon: Icons.person,
                                              onTap: () async {
                                                final res = await _TravelerCabinPicker.pick(
                                                  context,
                                                  adults: _adults,
                                                  cabin: _cabin,
                                                );
                                                if (res != null) {
                                                  setState(() {
                                                    _adults = res.adults;
                                                    _cabin = res.cabin;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 14),

                                      SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppTheme.primary,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                          ),
                                          onPressed: _loading ? null : _search,
                                          child: Text(
                                            _loading ? 'Searching...' : 'Search Flights',
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: _openAdminGate,
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.9),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.88),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'Popular Destinations',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        height: 160,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: const [
                                            _DestCard(img: 'assets/images/dest_paris.jpg', city: 'Paris', price: 350),
                                            _DestCard(img: 'assets/images/dest_tokyo.jpg', city: 'Tokyo', price: 450),
                                            _DestCard(img: 'assets/images/dest_miami.jpg', city: 'Miami', price: 280),
                                            _DestCard(img: 'assets/images/dest_rome.jpg', city: 'Rome', price: 400),
                                          ],
                                        ),
                                      ),
                                    ],
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
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dow = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d.weekday - 1];
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
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withValues(alpha: 0.30), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _AirportTypeAheadField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final void Function(String code, String label) onPicked;
  final VoidCallback onTextChanged;

  const _AirportTypeAheadField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.onPicked,
    required this.onTextChanged,
  });

  @override
  State<_AirportTypeAheadField> createState() => _AirportTypeAheadFieldState();
}

class _AirportTypeAheadFieldState extends State<_AirportTypeAheadField> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = false;

  Future<void> _fetch(String q) async {
    final txt = q.trim();
    if (txt.length < 2) {
      setState(() => _items = []);
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await HomeApi.airportSearch(txt);
      if (!mounted) return;
      setState(() => _items = res);
    } catch (_) {
      if (!mounted) return;
      setState(() => _items = []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: widget.controller,
            onChanged: (v) {
              widget.onTextChanged();
              _fetch(v);
            },
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.50)),
              prefixIcon: Icon(widget.icon, color: AppTheme.primary),
              suffixIcon: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ),
        if (_items.isNotEmpty) ...[
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length > 6 ? 6 : _items.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.black.withValues(alpha: 0.06)),
              itemBuilder: (_, i) {
                final a = _items[i];
                final code = a['code'].toString();
                final city = a['city'].toString();
                final name = a['name'].toString();
                final label = '$city ($code)';

                return ListTile(
                  dense: true,
                  title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    widget.onPicked(code, label);
                    setState(() => _items = []);
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

class _MiniField extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _MiniField({required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestCard extends StatelessWidget {
  final String img;
  final String city;
  final int price;
  const _DestCard({required this.img, required this.city, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(img, height: 92, width: 115, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(city, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text('From \$$price', style: TextStyle(color: Colors.black.withValues(alpha: 0.65), fontSize: 13)),
        ],
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
          Text(label, style: TextStyle(color: color, fontSize: 12.5, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _TravelerCabinResult {
  final int adults;
  final String cabin;
  _TravelerCabinResult(this.adults, this.cabin);
}

class _TravelerCabinPicker {
  static Future<_TravelerCabinResult?> pick(
    BuildContext context, {
    required int adults,
    required String cabin,
  }) async {
    int a = adults;
    String c = cabin;

    return showModalBottomSheet<_TravelerCabinResult>(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setS) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text('Adults', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      const Spacer(),
                      IconButton(onPressed: () => setS(() => a = (a > 1) ? a - 1 : 1), icon: const Icon(Icons.remove)),
                      Text('$a', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      IconButton(onPressed: () => setS(() => a = a + 1), icon: const Icon(Icons.add)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: c,
                    items: const [
                      DropdownMenuItem(value: 'Economy', child: Text('Economy')),
                      DropdownMenuItem(value: 'Business', child: Text('Business')),
                      DropdownMenuItem(value: 'First', child: Text('First')),
                    ],
                    onChanged: (v) => setS(() => c = v ?? 'Economy'),
                    decoration: const InputDecoration(labelText: 'Cabin'),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white),
                      onPressed: () => Navigator.pop(context, _TravelerCabinResult(a, c)),
                      child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}