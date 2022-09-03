import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future createUser(UserData user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;

    final json = user.toJson();
    await docUser.set(json);
  }
}
