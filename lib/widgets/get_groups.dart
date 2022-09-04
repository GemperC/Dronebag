import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/widgets/get_my_groups.dart';
import 'package:flutter/material.dart';

class GetGroups extends StatefulWidget {
  const GetGroups({Key? key}) : super(key: key);

  @override
  State<GetGroups> createState() => _GetGroupsState();
}

class _GetGroupsState extends State<GetGroups> {
  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('groups')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              print(document.reference);
              docIDs.add(document.reference.id);
            }));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder(
        future: getDocId(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: docIDs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: GetMyGroups(documentId: docIDs[index]),
              );
            });

        }),
      ),
    );

        // StreamBuilder<List<UserData>>(
        //   stream: readUsers(),
        //   builder: ((context, snapshot) {
        //     if (snapshot.hasError) {
        //       return Text('nothing to show');
        //     } else if (snapshot.hasData) {
        //       final users = snapshot.data!;
        //       return ListView(
        //         children: users.map(buildUser).toList(),
        //       );
        //     } else {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //   }),
        // ),
        
  }

  // Stream<List<UserData>> readUsers() => FirebaseFirestore.instance
  //     .collection('users')
  //     .snapshots()
  //     .map((snapshot) =>
  //         snapshot.docs.map((doc) => UserData.fromJson(doc.data())).toList());

  // Widget buildUser(UserData user) => ListTile(
  //       title: Text(user.firstName),
  //       subtitle: Text(user.lastName),
  //     );
}
