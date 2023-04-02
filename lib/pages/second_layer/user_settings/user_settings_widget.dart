import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/pages/second_layer/create_group/create_group.dart';
import 'package:dronebag/pages/second_layer/join_group/join_group.dart';
import 'package:dronebag/pages/second_layer/main_page/widgets/getUserName.dart';
import 'package:dronebag/pages/second_layer/my_groups/my_groups.dart';
import 'package:dronebag/widgets/main_button_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserSettingsWidget extends StatelessWidget {
  const UserSettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.scaffoldBgColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What would you like do to!",
                style: GoogleFonts.poppins(
                  color: ThemeColors.whiteTextColor,
                  fontSize: FontSize.xxLarge,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 60),
              MainButton2(
                backgroundColor: Colors.red,
                text: 'Delete this account',
                onPressed: () async {
                  showReauthenticateDialog(context);
                },
              ),
              const SizedBox(height: 50),
              MainButton2(
                  text: 'Sign Out',
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showReauthenticateDialog(BuildContext context) async {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap on a button
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: ThemeColors.scaffoldBgColor,
          title: Text(
            'Account Delete',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Please enter your email and password to confirm. \nThis will delete all your data!',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;

                UserCredential? userCredential =
                    await reauthenticateUser(email, password);
                if (userCredential != null) {
                  await deleteUserAccount(userCredential);
                  Navigator.of(dialogContext).pop();
                  Navigator.pop(context);
                  // Dismiss the dialog
                } else {
                  // Show an error message to the user or keep the dialog open
                }
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<UserCredential?> reauthenticateUser(
      String email, String password) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    try {
      UserCredential userCredential =
          await currentUser.reauthenticateWithCredential(credential);
      return userCredential;
    } catch (e) {
      print("Error reauthenticating user: $e");
      return null;
    }
  }

  Future<void> deleteUserAccount(UserCredential userCredential) async {
    String userEmail = userCredential.user!.email ?? '';
    String userId = userCredential.user!.uid; // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    // Initialize Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Delete the user document from the "users" collection
    await firestore.collection('users').doc(userEmail).delete();

    // Remove the user's email from the "users" array in all the documents in the "groups" collection
    QuerySnapshot groupSnapshot = await firestore.collection('groups').get();
    groupSnapshot.docs.forEach((groupDoc) async {
      await groupDoc.reference.update({
        'users': FieldValue.arrayRemove([userEmail]),
      });

      // Remove the documents which have the same id as the user's email from the "members" subcollection in the "groups" collection
      QuerySnapshot memberSnapshot = await groupDoc.reference
          .collection('members')
          .where('email', isEqualTo: userEmail)
          .get();
      if (memberSnapshot.docs.isNotEmpty) {
        print("Deleteing user from ${groupDoc.id}");
        memberSnapshot.docs.first.reference.delete;
      }
    });

    // Delete the user's account from Firebase Authentication
    await currentUser.delete();
  }
}
