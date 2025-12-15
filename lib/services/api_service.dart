import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/venue_model.dart';
import '../models/booking_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2/arena_sport';

  static Future<List<Venue>> getVenues() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_venues.php'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((json) => Venue.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error getVenues: $e");
      return [];
    }
  }

  static Future<List<Field>> getFields(String venueId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Field(
        id: '1',
        name: 'Lapangan A (Vinyl)',
        sportType: 'futsal',
        pricePerHour: 120000,
        imageUrl: 'https://via.placeholder.com/150',
        facilities: ['WiFi', 'AC'],
      ),
      Field(
        id: '2',
        name: 'Lapangan B (Sintetis)',
        sportType: 'futsal',
        pricePerHour: 100000,
        imageUrl: 'https://via.placeholder.com/150',
        facilities: ['Kantin'],
      ),
    ];
  }

  static Future<Map<String, dynamic>> checkAvailability(
    String fieldId,
    String date,
  ) async {
    try {
      final url =
          '$baseUrl/check_availability.php?field_id=$fieldId&date=$date';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(json.decode(response.body));
      }
      return {};
    } catch (e) {
      print("Error checkAvailability: $e");
      return {};
    }
  }

  static Future<List<Booking>> getMyBookings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_my_bookings.php'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((json) => Booking.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error getMyBookings: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>> getHomeStats() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_home_stats.php'));
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(json.decode(response.body));
      }
      return {"total_venues": "0", "total_fields": "0", "availability": "0%"};
    } catch (e) {
      return {"total_venues": "-", "total_fields": "-", "availability": "-"};
    }
  }
}
