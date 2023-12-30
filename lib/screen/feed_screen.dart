import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/gloabalVariable.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class feedScreen extends StatefulWidget {
  const feedScreen({Key? key}) : super(key: key);

  @override
  State<feedScreen> createState() => _feedScreenState();
}

class _feedScreenState extends State<feedScreen> {

  @override
  Widget build(BuildContext context) {
    print("feed use id:-"+FirebaseAuth.instance.currentUser!.uid);
    final width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:width>webScreenSize?null: AppBar(
          backgroundColor: width>webScreenSize?webBackgroundColor:mobileBackgroundColor,
          title: Image.asset(
            'assets/instagram.jpeg',
            height: 32,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.messenger_outline),
            ),
          ]),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').orderBy('datepublised',descending: true).snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting)
              {
                return const Center(child: CircularProgressIndicator());
              }
            return ListView.builder(

                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Container(
                  margin:  EdgeInsets.symmetric(
                    horizontal: width>webScreenSize?width*0.3:0,
                    vertical:width>webScreenSize?15:0,
                  ),
                    child: postCard(snap: snapshot.data!.docs[index].data(),)));
          }),
    );
  }
}
