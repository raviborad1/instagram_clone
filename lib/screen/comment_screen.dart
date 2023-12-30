import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screen/feed_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../resourses/postMethod.dart';
import '../widgets/comment_card.dart';

class commentScreen extends StatefulWidget {
  final String uid;
  final String postId;
  final String profiepic;
  final String name;
  const commentScreen(
      {Key? key,
      required this.uid,
      required this.postId,
      required this.profiepic,
      required this.name})
      : super(key: key);

  @override
  State<commentScreen> createState() => _commentScreenState();
}

class _commentScreenState extends State<commentScreen> {
   final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context)
                .pop(MaterialPageRoute(builder: (context) => const feedScreen()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Comment"),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postId)
              .collection('comments')
              .orderBy('datepublised',descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) =>
                    commentCard(snap: snapshot.data!.docs[index].data()));
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.red,
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Comment as Username",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await PostMethod().postcomment(
                      comment: _commentController.text,
                      uid: widget.uid,
                      postId: widget.postId,
                      profilepic: widget.profiepic,
                      name: widget.name);
                  setState(() {
                    _commentController.text="";
                  });
                },
                child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: const Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w800),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
