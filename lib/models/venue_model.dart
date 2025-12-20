class Venue {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final double rating;
  final String openTime;
  final String closeTime;
  final double minPrice;
  final List<String> sportTypes;
  final double latitude;
  final double longitude;

  Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.openTime,
    required this.closeTime,
    required this.minPrice,
    required this.sportTypes,
    required this.latitude,
    required this.longitude,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    List<String> parsedSports = [];
    if (json['sport_type'] != null) {
      parsedSports = json['sport_type']
          .toString()
          .split(',')
          .map((e) => e.trim())
          .toList();
    } else {
      parsedSports = ['general'];
    }
    String safeTime(String? time) {
      String t = (time ?? '00:00').toString();
      return t.length >= 5 ? t.substring(0, 5) : t;
    }

    return Venue(
      id: json['id'].toString(),
      name: json['name'] ?? 'No Name',
      address: json['address'] ?? 'Lokasi belum tersedia',
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/300',
      rating: double.tryParse((json['rating'] ?? '0').toString()) ?? 0.0,
      openTime: safeTime(json['open_time']),
      closeTime: safeTime(json['close_time']),
      minPrice: double.tryParse((json['min_price'] ?? '0').toString()) ?? 0.0,
      sportTypes: parsedSports,
      latitude: double.tryParse((json['latitude'] ?? '0').toString()) ?? 0.0,
      longitude: double.tryParse((json['longitude'] ?? '0').toString()) ?? 0.0,
    );
  }
}

class Field {
  final String id;
  final String name;
  final String sportType;
  final double pricePerHour;
  final String imageUrl;
  final List<String> facilities;

  Field({
    required this.id,
    required this.name,
    required this.sportType,
    required this.pricePerHour,
    required this.imageUrl,
    required this.facilities,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'].toString(),
      name: json['name'] ?? 'Lapangan',
      sportType: json['sport_type'] ?? 'general',
      pricePerHour:
          double.tryParse((json['price_per_hour'] ?? '0').toString()) ?? 0.0,
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150',
      facilities:
          (json['facilities'] as String?)
              ?.split(',')
              .map((e) => e.trim())
              .toList() ??
          [],
    );
  }
}
