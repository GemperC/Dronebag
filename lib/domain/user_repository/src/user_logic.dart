import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/models.dart';





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