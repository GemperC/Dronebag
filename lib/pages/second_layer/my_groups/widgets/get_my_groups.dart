import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetMyGroups extends StatelessWidget {
  final String documentId;

  GetMyGroups({required this.documentId});
  final user = FirebaseAuth.instance.currentUser!;
  List<String> docIDs = [];

  @override
  Widget build(BuildContext context) {
    // get collection
    CollectionReference groups = FirebaseFirestore.instance.collection('groups');

    return FutureBuilder<DocumentSnapshot>(
      future: groups.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          //print(data['Group Admins']);
          if (data['Group Admins'] != null &&
              data['Group Admins'].contains(user.email!)) {
            return Text(data['Group Name']);
          }
        }
        return Text('loading...');
      }),
    );
  }

  Future getMyGroups() async {
    final docGroup = FirebaseFirestore.instance.collection('groups');
    print(docGroup);
    final snapshot = await docGroup.get();
  }



    Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('groups')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }
}

