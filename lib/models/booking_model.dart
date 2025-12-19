class Booking {
  final String id;
  final String bookingCode;
  final String fieldName;
  final String venueName;
  final String date;
  final String startTime;
  final String endTime;
  final String totalPrice;
  final String status;

  Booking({
    required this.id,
    required this.bookingCode,
    required this.fieldName,
    required this.venueName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'].toString(),
      bookingCode: json['booking_code'] ?? '-',
      fieldName: json['field_name'] ?? 'Lapangan',
      venueName: json['venue_name'] ?? 'Venue',
      date: json['booking_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      totalPrice: json['total_price'].toString(),
      status: json['status'] ?? 'booked',
    );
  }
}
