import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../models/venue_model.dart';
import '../models/booking_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.18.10/arena_sport';

  static Future<List<Venue>> getVenues({
    String category = 'all',
    String query = '',
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/get_venues.php',
      ).replace(queryParameters: {'category': category, 'search': query});

      final response = await http.get(uri);

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
    required String userId,
    required String fieldId,
    required String date,
    required String startTime,
    required String endTime,
    required double totalPrice,
    required String paymentMethod,
    String? rewardId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create_booking.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'field_id': fieldId,
          'booking_date': date,
          'start_time': startTime,
          'end_time': endTime,
          'total_price': totalPrice,
          'payment_method': paymentMethod,
          if (rewardId != null) 'reward_id': rewardId,
        }),
      );
      return json.decode(response.body);
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

  static Future<Map<String, dynamic>> updateProfilePhoto(
    String userId,
    File imageFile,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/update_photo.php'),
      );

      request.fields['user_id'] = userId;

      var pic = await http.MultipartFile.fromPath('image', imageFile.path);
      request.files.add(pic);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print("Respon Server: $responseData");

      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        return {
          "status": "error",
          "message": "Server error: ${response.statusCode}",
        };
      }
    } catch (e) {
      print("Error Upload: $e");
      return {"status": "error", "message": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_user_details.php?user_id=$userId'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  static Future<List<dynamic>> getNotifications(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_notifications.php?user_id=$userId'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getSavedPaymentMethods(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_payment_methods.php?user_id=$userId'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getUserBookings(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_user_bookings.php?user_id=$userId'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      print("Error User Bookings: $e");
      return [];
    }
  }

  static Future<List<dynamic>> getUserReviews(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_my_reviews.php?user_id=$userId'),
      );
      if (response.statusCode == 200) return json.decode(response.body);
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> addPaymentMethod({
    required String userId,
    required String name,
    required String type,
    required double balance,
    required String imageUrl,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add_payment_method.php'),
      body: {
        'user_id': userId,
        'name': name,
        'type': type,
        'balance': balance.toString(),
        'image_url': imageUrl,
      },
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> deletePaymentMethod(
    String methodId,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete_payment_method.php'),
      body: {'id': methodId},
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> topUpBalance({
    required String methodId,
    required double amount,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/top_up.php'),
      body: {'id': methodId, 'amount': amount.toString()},
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> lockBooking({
    required String userId,
    required String fieldId,
    required String date,
    required String startTime,
    required String endTime,
    required double totalPrice,
    String? rewardId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_booking.php'),
      body: jsonEncode({
        'user_id': userId,
        'field_id': fieldId,
        'booking_date': date,
        'start_time': startTime,
        'end_time': endTime,
        'total_price': totalPrice,
        if (rewardId != null) 'reward_id': rewardId,
      }),
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> payBooking({
    required String bookingId,
    required String userId,
    required String paymentMethodId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pay_booking.php'),
      body: jsonEncode({
        'booking_id': bookingId,
        'user_id': userId,
        'payment_method': paymentMethodId,
      }),
    );
    return json.decode(response.body);
  }

  static Future<dynamic> updateUserData(
    String s,
    String text,
    String text2,
  ) async {}

  static Future<Map<String, dynamic>> addReview({
    required String userId,
    required String venueName,
    required String sportType,
    required int rating,
    required String comment,
    String? bookingId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_review.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'venue_name': venueName,
          'sport_type': sportType,
          'rating': rating,
          'comment': comment,
          if (bookingId != null) 'booking_id': bookingId,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> toggleFavorite(
    String userId,
    String venueId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/favorite.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'action': 'toggle', 'user_id': userId, 'venue_id': venueId},
      );
      return json.decode(response.body);
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  static Future<bool> checkFavorite(String userId, String venueId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/favorite.php?action=check&user_id=$userId&venue_id=$venueId',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['is_favorite'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Venue>> getUserFavorites(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/favorite.php?action=list&user_id=$userId'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          final List data = jsonResponse['data'];
          return data.map((json) => Venue.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String userId,
    String? name,
    String? email,
    String? phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_profile.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (phone != null) 'phone': phone,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/change_password.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> redeemReward({
    required String userId,
    required String rewardTitle,
    required int pointsCost,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/redeem_reward.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'user_id': userId,
          'reward_title': rewardTitle,
          'points_cost': pointsCost.toString(),
        },
      );
      return json.decode(response.body);
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  static Future<List<dynamic>> getRewardHistory(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_reward_history.php?user_id=$userId'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getMyRewards(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_my_rewards.php?user_id=$userId'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> getAdminSettings() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_settings.php'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  static Future<bool> updateAdminSettings(String action, bool value) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_settings.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': action, 'value': value}),
      );
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        return res['status'] == 'success';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<dynamic>> getAds() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_ads.php'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> addAd({
    required String title,
    required String description,
    required String promoType,
    required double promoValue,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add_ad.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'description': description,
          'promo_type': promoType,
          'promo_value': promoValue,
        }),
      );
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        return res['status'] == 'success';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteAd(String id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete_ad.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateVenue({
    required String id,
    required String name,
    required String address,
    required String openTime,
    required String closeTime,
    required String minPrice,
    required String sportType,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/update_venue.php'),
      );

      request.fields['id'] = id;
      request.fields['name'] = name;
      request.fields['address'] = address;
      request.fields['open_time'] = openTime;
      request.fields['close_time'] = closeTime;
      request.fields['min_price'] = minPrice;
      request.fields['sport_type'] = sportType;

      if (imageFile != null) {
        var pic = await http.MultipartFile.fromPath('image', imageFile.path);
        request.files.add(pic);
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final json = jsonDecode(respStr);
        return json['status'] == 'success';
      }
      return false;
    } catch (e) {
      print("Error updateVenue: $e");
      return false;
    }
  }

  static Future<bool> updateField({
    required String id,
    required String name,
    required String sportType,
    required String price,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/update_field.php'),
      );

      request.fields['id'] = id;
      request.fields['name'] = name;
      request.fields['sport_type'] = sportType;
      request.fields['price'] = price;

      if (imageFile != null) {
        var pic = await http.MultipartFile.fromPath('image', imageFile.path);
        request.files.add(pic);
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final json = jsonDecode(respStr);
        return json['status'] == 'success';
      }
      return false;
    } catch (e) {
      print("Error updateField: $e");
      return false;
    }
  }

  static Future<bool> addVenue({
    required String name,
    required String address,
    required String openTime,
    required String closeTime,
    required String minPrice,
    required String description,
    required String sportType,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/add_venue.php'),
      );

      request.fields['name'] = name;
      request.fields['address'] = address;
      request.fields['open_time'] = openTime;
      request.fields['close_time'] = closeTime;
      request.fields['min_price'] = minPrice;
      request.fields['description'] = description;
      request.fields['sport_type'] = sportType;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path),
        );
      }

      var stream = await request.send();
      var response = await http.Response.fromStream(stream);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['status'] == 'success';
      }
      return false;
    } catch (e) {
      print("Error adding venue: $e");
      return false;
    }
  }
}
