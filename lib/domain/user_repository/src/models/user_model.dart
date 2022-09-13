import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final String fullName;
  final String email;
  final String phone;

  UserData({
    required this.fullName,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'Full_Name': fullName,
        'Email': email,
        'Phone_Number': phone,
      };

  static UserData fromJson(Map<String, dynamic> json) => UserData(
        fullName: json['Full_Name'],
        email: json['Email'],
        phone: json['Phone_Number'],
      );

  Future createUser(UserData user) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc('$email');
    final json = user.toJson();
    await docUser.set(json);
  }

  Future<UserData?> findUser() async {
    final loggedUserEmail = FirebaseAuth.instance.currentUser!.email;
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc('');
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
