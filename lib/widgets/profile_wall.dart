// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mywall/widgets/comment_button.dart';
import 'package:mywall/widgets/comments.dart';
import 'package:mywall/widgets/like_button.dart';
import 'package:mywall/widgets/reuse_textfield.dart';
import 'package:mywall/widgets/time.dart';

//decorate this....

class WallProfilePost extends StatefulWidget {
  final String message;
  final String user;
  final String postID;
  final List<String> likes;

  const WallProfilePost(
      {super.key,
      required this.message,
      required this.user,
      required this.likes,
      required this.postID});

  @override
  State<WallProfilePost> createState() => _WallProfilePost();
}

class _WallProfilePost extends State<WallProfilePost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final commentTextController = TextEditingController();
  int? numberOfComments;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser
        .email); //if the current email is in List of Like, isLiked will be true
  }

  void toggleLikes() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postID);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email]),
      });
    }
  }

  Future<void> getCommentsCount() async {
    QuerySnapshot commentDocs = await FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postID)
        .collection('Comments')
        .get();

    setState(() {
      numberOfComments = commentDocs.size;
    });
  }

  void addComments(String commentText) async {
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postID)
        .collection('Comments')
        .add({
      'comments': commentText,
      'commentby': currentUser.email,
      'commenttime': Timestamp.now(), //decorate it
    });
    await getCommentsCount();
  }

  void showCommentsDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add Comments'),
              content: ReuseTextField(
                  emailLogin: commentTextController,
                  prefixIcon: const Icon(Icons.comment_rounded),
                  emailLabel: 'Enter The Comment..',
                  isObscure: false),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      addComments(commentTextController.text);
                      Get.back();
                      commentTextController.clear();
                      //fill it
                    },
                    child: const Text('Comment')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user == currentUser.email) {
      return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 8), // RESPONSIVESS SCREEN

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(backgroundColor: Colors.black),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            widget.message,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            widget.user,
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('User Posts')
                                .doc(widget.postID)
                                .collection('Comments')
                                .orderBy("commenttime", descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: snapshot.data!.docs.map((doc) {
                                  final commentData = doc.data();
                                  String formattedTimestamp =
                                      TimeFormatter.formatTimestamp(
                                          commentData['commenttime']);

                                  return Comments(
                                      message: commentData['comments'],
                                      user: commentData['commentby'],
                                      time: formattedTimestamp);
                                }).toList(), // why we return tolist here
                              );
                            })
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.user == currentUser.email)
                            IconButton(
                                onPressed: () {
                                  _showDeleteConfirmationDialog(context);
                                },
                                icon: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.black,
                                )),
                          LikeButton(isLiked: isLiked, onTap: toggleLikes),
                          Text(
                            widget.likes.length.toString(),
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          CommentButton(onTap: () {
                            showCommentsDialog();
                          }),
                          if (numberOfComments != null && numberOfComments != 0)
                            Text(
                              //comment counter
                              numberOfComments.toString(),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                            ),
                          if (numberOfComments == null || numberOfComments == 0)
                            Text(
                              //comment counter
                              '0',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
    } else {
      return Container();
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure to delete?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel button
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Perform delete operation here
                // ...

                final commentDocs = await FirebaseFirestore.instance
                    .collection('User Posts')
                    .doc(widget.postID)
                    .collection('Comments')
                    .get();

                for (var doc in commentDocs.docs) {
                  await FirebaseFirestore.instance
                      .collection('User Posts')
                      .doc(widget.postID)
                      .collection('Comments')
                      .doc(doc.id)
                      .delete();
                }

                FirebaseFirestore.instance
                    .collection('User Posts')
                    .doc(widget.postID)
                    .delete()
                    .then((value) {
                  Get.snackbar('Post', 'Successfully Deleted',
                      margin: const EdgeInsets.only(
                        bottom: 10,
                        left: 10,
                        right: 10,
                      ),
                      backgroundColor: Colors.green,
                      borderRadius: 12,
                      snackPosition: SnackPosition.BOTTOM);
                });

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
