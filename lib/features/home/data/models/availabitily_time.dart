class AvailabilityTime {
  final String day;
  final String startTime;
  final String endTime;

  AvailabilityTime({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  // Add factory methods for JSON serialization if needed
  factory AvailabilityTime.fromJson(Map<String, dynamic> json) {
    return AvailabilityTime(
      day: json['day'] ?? '',
      startTime: json['startTime'] ?? '09:00 AM',
      endTime: json['endTime'] ?? '05:00 PM',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
