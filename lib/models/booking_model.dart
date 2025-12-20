class Booking {
  final String id;
  final String fieldId;
  final String bookingCode;
  final String fieldName;
  final String venueName;
  final String date;
  final String startTime;
  final String endTime;
  final double totalPrice;
  final String status;
  final int timeLeftSeconds;

  Booking({
    required this.id,
    required this.fieldId,
    required this.bookingCode,
    required this.fieldName,
    required this.venueName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    this.timeLeftSeconds = 0,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'].toString(),
      fieldId: json['field_id'].toString(),
      bookingCode: json['booking_code'] ?? '-',
      fieldName: json['field_name'] ?? 'Unknown Field',
      venueName: json['venue_name'] ?? 'Unknown Venue',
      date: json['booking_date'] ?? '',
      startTime: (json['start_time'] ?? '00:00').toString().substring(0, 5),
      endTime: (json['end_time'] ?? '00:00').toString().substring(0, 5),
      totalPrice:
          double.tryParse((json['total_price'] ?? '0').toString()) ?? 0.0,
      status: json['status'] ?? 'unknown',
      timeLeftSeconds:
          int.tryParse((json['time_left_seconds'] ?? '0').toString()) ?? 0,
    );
  }
}
