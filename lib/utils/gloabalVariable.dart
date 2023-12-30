import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screen/add_Post_screen.dart';
import 'package:instagram_clone/screen/feed_screen.dart';
import 'package:instagram_clone/screen/serch_screen.dart';
import 'package:instagram_clone/screen/profile_screen.dart';

const webScreenSize=600;
List<Widget>homeScreenItem=[
  // Text('home'),
  const feedScreen(),
  const serchScreen(),
  const addPost(),
  const Text("Like"),
  profileScreen(uid: FirebaseAuth.instance.currentUser!.uid,)

];