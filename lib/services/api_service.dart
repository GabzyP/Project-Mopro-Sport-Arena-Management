import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/venue_model.dart';
import '../models/booking_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.6/arena_sport';

  static Future<List<Venue>> getVenues({
    String category = 'all',
    String query = '',
  }) async {
    try {
      String url = '$baseUrl/get_venues.php?category=$category&search=$query';

      final response = await http.get(Uri.parse(url));

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
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_fields.php?venue_id=$venueId'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((json) => Field.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error getFields: $e");
      return [];
    }
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

  static Future<Map<String, dynamic>> createBooking({
    required String fieldId,
    required String date,
    required List<String> slots,
    required double totalPrice,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create_booking.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'field_id': fieldId,
          'date': date,
          'slots': slots,
          'total_price': totalPrice,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {"status": "error", "message": "Gagal menghubungi server"};
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  static Future<bool> addField({
    required String venueId,
    required String name,
    required String sportType,
    required double price,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_field.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'venue_id': venueId,
          'name': name,
          'sport_type': sportType,
          'price': price,
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['status'] == 'success';
      }
      return false;
    } catch (e) {
      print("Error addField: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>> getAdminDashboardData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_admin_data.php'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {};
    } catch (e) {
      print("Error getAdminData: $e");
      return {};
    }
  }

  static Future<bool> updateOrderStatus(
    String orderId,
    String newStatus,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_order_status.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': orderId, 'status': newStatus}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateUserStatus(String userId, String newStatus) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_user_status.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': userId, 'status': newStatus}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
