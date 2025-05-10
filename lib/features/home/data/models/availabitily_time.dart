class AvailabilityTime {
  final String day;
  final String startTime;
  final String endTime;

  AvailabilityTime({
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory AvailabilityTime.fromMap(Map<String, dynamic> map) {
    return AvailabilityTime(
      day: map['day'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
