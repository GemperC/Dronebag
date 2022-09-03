class User {
  String id;
  final String firstName;
  final String secondName;

  User({
    this.id = '',
    required this.firstName,
    required this.secondName,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'First Name': firstName,
        'Second Name': secondName,
      };
}
