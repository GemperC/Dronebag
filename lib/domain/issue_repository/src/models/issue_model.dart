class Issue {
  String id; //id of the drone in the firestore database
  String detail; // detail of the issue
  bool resolved; // was the issue revolved
  String date; // hours of active flight

  Issue ({
    this.id = '',
    required this.detail,
    this.resolved = false,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'detail': detail,
        'resolved': resolved,
        'date': date,
      };

  static Issue fromJson(Map<String, dynamic> json) => Issue(
        id: json['id'],
        detail: json['detail'],
        resolved: json['resolved'],
        date: json['date'],

      );
}
