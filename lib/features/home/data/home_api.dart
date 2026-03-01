import '../../../core/services/api_client.dart';
import '../../../core/config/api_config.dart';
import '../../../core/models/flight.dart';

class HomeApi {
  static final _api = ApiClient(ApiConfig.baseUrl);

  static Future<List<Map<String, dynamic>>> airportSearch(String q) async {
    final j = await _api.get('/airports/search', query: {'q': q});
    final list = (j['data'] as List).cast<Map<String, dynamic>>();
    return list;
  }

  static Future<List<Flight>> searchFlights({
    required String from,
    required String to,
    required String date,
    required int adults,
    required String cabin,
  }) async {
    final j = await _api.post('/flights/search', {
      'from': from,
      'to': to,
      'date': date,
      'adults': adults,
      'cabin': cabin,
    });

    final list = (j['data'] as List).cast<Map<String, dynamic>>();
    return list.map(Flight.fromJson).toList();
  }

  static const _adminPin = '741852963';

  static Future<List<Map<String, dynamic>>> adminListAirports() async {
    final j = await _api.get('/admin/airports', headers: {'X-ADMIN-PIN': _adminPin});
    return (j['data'] as List).cast<Map<String, dynamic>>();
    }

  static Future<void> adminCreateAirport({
    required String code,
    required String city,
    required String name,
  }) async {
    await _api.post('/admin/airports', {
      'code': code,
      'city': city,
      'name': name,
    }, headers: {'X-ADMIN-PIN': _adminPin});
  }

  static Future<void> adminDeleteAirport({required String code}) async {
    await _api.delete('/admin/airports/$code', headers: {'X-ADMIN-PIN': _adminPin});
  }

  static Future<List<Flight>> adminListFlights() async {
    final j = await _api.get('/admin/flights', headers: {'X-ADMIN-PIN': _adminPin});
    final list = (j['data'] as List).cast<Map<String, dynamic>>();
    return list.map(Flight.fromJson).toList();
  }

  static Future<void> adminCreateFlight({
    required String airline,
    required String flightNo,
    required String fromCode,
    required String toCode,
    required String date,
    required String departTime,
    required String arriveTime,
    required int durationMin,
    required bool nonStop,
    required double price,
    required String cabin,
    required String status,
  }) async {
    await _api.post('/admin/flights', {
      'airline': airline,
      'flight_no': flightNo,
      'from_code': fromCode,
      'to_code': toCode,
      'date': date,
      'depart_time': departTime,
      'arrive_time': arriveTime,
      'duration_min': durationMin,
      'non_stop': nonStop,
      'price': price,
      'cabin': cabin,
      'status': status,
    }, headers: {'X-ADMIN-PIN': _adminPin});
  }

  static Future<void> adminDeleteFlight({required int id}) async {
    await _api.delete('/admin/flights/$id', headers: {'X-ADMIN-PIN': _adminPin});
  }
}