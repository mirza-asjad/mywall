import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mywall/widgets/profile_wall.dart';
import 'package:mywall/widgets/reuse_textfield.dart';
import 'package:mywall/widgets/text_box.dart';


class ShowProfile extends StatefulWidget {
  final String userEmail;
  final String userName;
  final String userBio;

  const ShowProfile({
    Key? key,
    required this.userEmail,
    required this.userName,
    required this.userBio,
  }) : super(key: key);

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  final usersCollection = FirebaseFirestore.instance.collection('Users');
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 50.0,
            child: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 10.0),
        Center(
          child: Text(
            widget.userEmail,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 15, left: 25),
          child: Text('My Details'),
        ),
        const SizedBox(height: 6.0),
        TextBox(
          sectionName: 'Username',
          userName: widget.userName,
          onPressed: () {
            _showChangeNameDialog(context, 'Username', 'username');
          },
        ),
        TextBox(
          sectionName: 'User Bio',
          userName: widget.userBio,
          onPressed: () {
            _showChangeNameDialog(context, 'User Bio', 'bio');
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 25, left: 25),
          child: Text('My Posts'),
        ),        
        SizedBox(
          height: 200,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('User Posts')
                  .orderBy('TimeStamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return WallProfilePost(
                            message: post['Message'],
                            likes:
                                List<String>.from(post['Likes'] ?? []),
                            postID: post.id,
                            user: post['UserEmail']);
                      });
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Unable to load data'),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ],
    );
  }

  // Function to show the alert box with TextField
  Future<void> _showChangeNameDialog(
    BuildContext context,
    String sectionName,
    String field,
  ) async {
    TextEditingController newNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change $sectionName'),
          content: ReuseTextField(
            emailLogin: newNameController,
            prefixIcon: const Icon(Icons.fiber_new_rounded),
            emailLabel: 'Enter New $sectionName',
            isObscure: false,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog on Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newName = newNameController.text;
                if (newName.trim().isNotEmpty) {
                  // Perform any validation or processing as needed
                  // ...

                  // Close the dialog and perform the change
                  Navigator.pop(context, newName);

                  // Update the username in Firestore
                  await usersCollection.doc(currentUser.email).update({
                    field: newName,
                  });
                } else {
                  // Show a snackbar or handle the case where the entered text is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid name.'),
                    ),
                  );
                }
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }
}
