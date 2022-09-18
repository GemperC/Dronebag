class FlightData {
  String id; //id of the flight data in the firestore database
  String comment;
  String flight_purpose;
  String flight_time; // hours of active flight in the flight
  DateTime date;
  String pilot;

  FlightData({
    this.id = '',
    this.comment= '',
    required this.flight_purpose,
    required this.flight_time,
    required this.date,
    required this.pilot,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'comment': comment,
        'flight_purpose': flight_purpose,
        'maintenance': flight_time,
        'date': date,
        'pilot': pilot,
      };

  static FlightData fromJson(Map<String, dynamic> json) => FlightData(
        id: json['id'],
        comment: json['comment'],
        flight_purpose: json['flight_purpose'],
        flight_time: json['flight_time'],
        date: json['date'],
        pilot: json['pilot'],
      );
}
