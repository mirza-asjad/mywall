import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mywall/chat/all_users.dart';
import 'package:mywall/views/auth/login_view.dart';
import 'package:mywall/views/home/post_wall.dart';
import 'package:mywall/views/home/profile_view.dart';
import 'package:mywall/widgets/wall_post.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff000221),
        title: Text('MyWall',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.to(() => ProfileView());
            },
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(()=> const AllUsers());
              },
              icon: const Icon(
                Icons.messenger,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Get.to(() => const LoginView());
                });
              },
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 30, 32, 69),
        onPressed: () {
          Get.to(() => const MyPostView());
        },
        child: const Icon(
          Icons.post_add_outlined,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
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
                              return WallPost(
                                  message: post['Message'],
                                  likes: List<String>.from(post['Likes'] ?? []),
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
                    })),
          ],
        ),
      ),
    );
  }
}
