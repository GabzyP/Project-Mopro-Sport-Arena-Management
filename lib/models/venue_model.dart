class Venue {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final double rating;
  final List<String> sportTypes;

  Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.sportTypes,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    List<String> parsedSports = [];
    if (json['sport_type'] != null) {
      parsedSports = json['sport_type'].toString().split(',');
    } else {
      parsedSports = ['general'];
    }

    return Venue(
      id: json['id'].toString(),
      name: json['name'],
      address: json['address'] ?? 'Jakarta Indonesia',
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/300',
      rating: double.tryParse((json['rating'] ?? '0').toString()) ?? 0.0,
      sportTypes: parsedSports,
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
      name: json['name'],
      sportType: json['sport_type'] ?? 'general',
      pricePerHour: double.parse((json['price_per_hour'] ?? 0).toString()),
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150',
      facilities: (json['facilities'] as String?)?.split(',') ?? [],
    );
  }
}
