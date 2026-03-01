import '../models/airport.dart';
import '../models/flight.dart';
import 'api_client.dart';

class FlightService {
  final ApiClient api;
  FlightService(this.api);

  Future<List<Airport>> airportSearch(String q) async {
    final j = await api.get('/api/airports/search', query: {'q': q});
    final list = (j['data'] as List).cast<Map<String, dynamic>>();
    return list.map(Airport.fromJson).toList();
  }
  Future<List<Flight>> searchFlights({
    required String fromCode,
    required String toCode,
    required String date, 
    required int adults,
    required String cabin,
  }) async {
    final j = await api.post('/api/flights/search', {
      'from': fromCode,
      'to': toCode,
      'date': date,
      'adults': adults,
      'cabin': cabin,
    });

    final list = (j['data'] as List).cast<Map<String, dynamic>>();
    return list.map(Flight.fromJson).toList();
  }

  Future<Flight> flightDetails(int id) async {
    final j = await api.post('/api/flights/details', {'id': id});
    return Flight.fromJson(j['data'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> createBooking({required int flightId, required int adults}) async {
    final j = await api.post('/api/bookings', {'flight_id': flightId, 'adults': adults});
    return j['data'] as Map<String, dynamic>;
  }
}