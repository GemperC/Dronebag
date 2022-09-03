import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String id;
  final String firstName;
  final String secondName;
  final String email;

  UserData({
    this.id = '',
    required this.firstName,
    required this.secondName,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'First Name': firstName,
        'Second Name': secondName,
        'Email': email,
      };

  Future createUser(UserData user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;

    final json = user.toJson();
    await docUser.set(json);
  }
}
