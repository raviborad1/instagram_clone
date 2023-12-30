import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screen/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/image_utils.dart';
import 'package:instagram_clone/widgets/follow_card.dart';

import '../resourses/postMethod.dart';

class profileScreen extends StatefulWidget {
  final String uid;
  const profileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<profileScreen> createState() => _profielScreenState();
}

class _profielScreenState extends State<profileScreen> {
  bool _isLoding = false;
  int _postnumber = 0;
  int _followers = 0;
  int _following = 0;
  bool _isfollowing = false;
  var useData = {};
  @override
  void initState() {
    super.initState();
    getuserData();
  }

  getuserData() async {
    setState(() {
      _isLoding = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.uid)
          .get();
      useData = snap.data()!;
      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      _postnumber = postsnap.docs.length;
      _followers = snap.data()!['followers'].length;
      _following = snap.data()!['following'].length;
      _isfollowing = snap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {

      });
    } catch (e) {
      showSnakbar(e.toString(), context);
    }
    setState(() {
      _isLoding = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    print("User id  ${widget.uid}");
    return _isLoding
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(useData['name']),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(useData['photourl']),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildStateColumn(
                                          lable: 'Post', num: _postnumber),
                                      buildStateColumn(
                                          lable: 'Followers', num: _followers),
                                      buildStateColumn(
                                          lable: 'Following', num: _following),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? followbutton(
                                            text: 'Sign out',
                                            function: () async {
                                              await PostMethod().signOut();
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const loginScreen()));
                                            },
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            textColor: primaryColor)
                                        : _isfollowing
                                            ? followbutton(
                                                function: () async {
                                                  await PostMethod().followuser(
                                                      uid: FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      followuid: widget.uid);
                                                  setState(() {
                                                    _isfollowing = false;
                                                    _followers--;
                                                  });
                                                },
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                borderColor: Colors.grey,
                                                textColor: Colors.black)
                                            : followbutton(
                                                function: () async {
                                                  await PostMethod().followuser(
                                                      uid: FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      followuid: widget.uid);
                                                  setState(() {
                                                    _isfollowing = true;
                                                    _followers++;
                                                  });
                                                },
                                                text: 'Follow',
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                borderColor: Colors.blueAccent,
                                                textColor: Colors.white)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 10, left: 16),
                        child: Text(
                          useData['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1, left: 16),
                        child: Text(useData['bio']),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data as dynamic).docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1),
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];
                            return Container(
                              child: Image(
                                image: NetworkImage(snap['posturl']),
                                fit: BoxFit.cover,
                              ),
                            );
                          });
                    })
              ],
            ),
          );
  }
}

Column buildStateColumn({required String lable, required int num}) {
  return Column(
    children: [
      Text(
        num.toString(),
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      Text(
        lable,
        style: const TextStyle(
            fontWeight: FontWeight.w400, fontSize: 15, color: Colors.grey),
      )
    ],
  );
}
