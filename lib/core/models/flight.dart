class FlightPlace {
  final String code;
  final String city;

  const FlightPlace({required this.code, required this.city});

  factory FlightPlace.fromJson(Map<String, dynamic> j) => FlightPlace(
        code: j['code'].toString(),
        city: j['city'].toString(),
      );
}

class Flight {
  final int id;
  final String airline;
  final String flightNo;

  final FlightPlace from;
  final FlightPlace to;

  final String departTime;
  final String arriveTime;
  final int durationMin;
  final bool nonStop;
  final double price;
  final String cabin;
  final String status;

  const Flight({
    required this.id,
    required this.airline,
    required this.flightNo,
    required this.from,
    required this.to,
    required this.departTime,
    required this.arriveTime,
    required this.durationMin,
    required this.nonStop,
    required this.price,
    required this.cabin,
    required this.status,
  });

  factory Flight.fromJson(Map<String, dynamic> j) => Flight(
        id: (j['id'] as num).toInt(),
        airline: j['airline'].toString(),
        flightNo: (j['flight_no'] ?? '').toString(),
        from: FlightPlace.fromJson(j['from'] as Map<String, dynamic>),
        to: FlightPlace.fromJson(j['to'] as Map<String, dynamic>),
        departTime: j['depart_time'].toString(),
        arriveTime: j['arrive_time'].toString(),
        durationMin: (j['duration_min'] as num).toInt(),
        nonStop: (j['non_stop'] as bool?) ?? false,
        price: (j['price'] as num).toDouble(),
        cabin: (j['cabin'] ?? 'Economy').toString(),
        status: (j['status'] ?? 'On Time').toString(),
      );

  String get durationLabel {
    final h = durationMin ~/ 60;
    final m = durationMin % 60;
    return '${h}h ${m}m';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'airline': airline,
        'flight_no': flightNo,
        'from': {'code': from.code, 'city': from.city},
        'to': {'code': to.code, 'city': to.city},
        'depart_time': departTime,
        'arrive_time': arriveTime,
        'duration_min': durationMin,
        'non_stop': nonStop,
        'price': price,
        'cabin': cabin,
        'status': status,
      };
}