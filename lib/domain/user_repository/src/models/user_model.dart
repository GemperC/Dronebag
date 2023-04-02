import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String fullName;
  final String email;
  final String? phone;

  UserData({
    required this.fullName,
    required this.email,
    this.phone,
  });

  Map<String, dynamic> toJson() => {
        'Full_Name': fullName,
        'Email': email,
        'Phone_Number': phone,
      };

  UserData.fromMap(Map<String, dynamic> Function() map)
      : assert(map()['Full_Name'] != null),
        assert(map()['Email'] != null),
        assert(map()['Phone_Number'] != null),
        fullName = map()['Full_Name'],
        email = map()['Email'],
        phone = map()['Phone_Number'];

  static UserData fromJson(Map<String, dynamic> json) => UserData(
        fullName: json['Full_Name'],
        email: json['Email'],
        phone: json['Phone_Number'],
      );

  Future createUser(UserData user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(email);
    final json = user.toJson();
    await docUser.set(json);
  }
}
