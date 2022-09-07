import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/widgets/get_my_groups.dart';
import 'package:flutter/material.dart';

class MyGroupPage extends StatefulWidget {
  const MyGroupPage({Key? key}) : super(key: key);

  @override
  State<MyGroupPage> createState() => _MyGroupPageState();
}


class _MyGroupPageState extends State<MyGroupPage> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('group data'),
      ),
    );
  }
}
