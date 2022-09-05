
class UserData {
  String id;
  final String firstName;
  final String lastName;
  final String email;

  UserData({
    this.id = '',
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'First Name': firstName,
        'Last Name': lastName,
        'Email': email,
      };

  static UserData fromJson(Map<String, dynamic> json) => UserData(
    email: json['Email'],
    firstName: json['First Name'], 
    lastName: json['Last Name'], 
    );

  


}
