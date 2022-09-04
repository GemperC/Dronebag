import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future createUser(UserData user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;

    final json = user.toJson();
    await docUser.set(json);
  }


  Future<UserData?> findUser() async {
    final loggedUserEmail = FirebaseAuth.instance.currentUser!.email;
    final docUser = FirebaseFirestore.instance.collection('users').doc('JoCuxkiYkuHqNNptW6LG');
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return UserData.fromJson(snapshot.data()!);
    }
  }

  Stream<List<UserData>> readUsers() => FirebaseFirestore.instance
    .collection('users')
    .snapshots()
    .map((snapshot) =>
      snapshot.docs.map((doc) => UserData.fromJson(doc.data())).toList());


}
