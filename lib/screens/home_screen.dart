import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/models/user.dart';
import 'package:dronebag/screens/create_group.dart';
import 'package:dronebag/screens/getuser.dart';
import 'package:dronebag/screens/group_home_page.dart';
import 'package:dronebag/screens/join_group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;



    return Scaffold(
      appBar: AppBar(
        title: Text('Dronebag'),
      ),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Sign In as', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(user.email!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            //test
            SizedBox(height: 8),
            ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(20)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GetUser()),
                  );
                },
                icon: FaIcon(FontAwesomeIcons.react, size: 32),
                label: Text('TEST', style: TextStyle(fontSize: 24))),
            //test

            SizedBox(height: 40),
            ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                onPressed: () => FirebaseAuth.instance.signOut(),
                icon: Icon(Icons.arrow_back, size: 32),
                label: Text('Sign Out', style: TextStyle(fontSize: 24))),
            SizedBox(height: 100),
            ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(60)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GroupHomePage()),
                  );
                },
                icon: FaIcon(FontAwesomeIcons.peopleGroup, size: 32),
                label: Text('My Groups', style: TextStyle(fontSize: 24))),
            SizedBox(height: 20),
            ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(60)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateGroupPage()),
                  );
                },
                icon: FaIcon(FontAwesomeIcons.userGroup, size: 32),
                label: Text('Create Group', style: TextStyle(fontSize: 24))),
            SizedBox(height: 20),
            ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(60)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JoinGroupPage()),
                  );
                },
                icon: FaIcon(FontAwesomeIcons.handshake, size: 32),
                label: Text('Join Group', style: TextStyle(fontSize: 24)))
          ],
        ),
      ),
    );
  }
}
