class MaintnanceHistory {
  String id; //id of the drone in the firestore database
  String detail; // detail of the issue was the issue revolved
  String date; // hours of active flight

  MaintnanceHistory({
    this.id = '',
    required this.detail,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
      };

  static MaintnanceHistory fromJson(Map<String, dynamic> json) =>
      MaintnanceHistory(
        id: json['id'],
        detail: json['detail'],
        date: json['date'],
      );
}
