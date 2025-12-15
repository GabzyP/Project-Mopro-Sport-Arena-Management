class Booking {
  final String id;
  final String venueName;
  final String fieldName;
  final String date;
  final String startTime;
  final String endTime;
  final double totalPrice;
  final String status;
  final String imageUrl;

  Booking({
    required this.id,
    required this.venueName,
    required this.fieldName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    required this.imageUrl,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'].toString(),
      venueName: json['venue_name'] ?? 'Unknown Venue',
      fieldName: json['field_name'] ?? 'Unknown Field',
      date: json['booking_date'],
      startTime: (json['start_time'] as String).substring(0, 5),
      endTime: (json['end_time'] as String).substring(0, 5),
      totalPrice: double.parse((json['total_price'] ?? 0).toString()),
      status: json['status'],
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150',
    );
  }
}