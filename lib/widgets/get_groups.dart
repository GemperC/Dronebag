import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/pages/third_layer/group_main/view/group_main_page.dart';
import 'package:dronebag/widgets/get_my_groups.dart';
import 'package:flutter/material.dart';

class GetGroups extends StatefulWidget {
  const GetGroups({Key? key}) : super(key: key);

  @override
  State<GetGroups> createState() => _GetGroupsState();
}

class _GetGroupsState extends State<GetGroups> {
  final String documentId = '';
  List<String> docIDs = [];
  List<String> myGroups = [];
  List<String> groupAdmins = [];
  CollectionReference groups = FirebaseFirestore.instance.collection('groups');
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('groups')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docIDs.add(document.reference.id);
              print(document.reference.id);
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
                      onTap: () async{

                        Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyGroupPage()),
                  );
                        
                      },
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
