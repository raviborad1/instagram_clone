import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/model/userModel.dart';

class UserProvider extends ChangeNotifier{
 UserModel? _userData;
 final FirebaseFirestore _firestore=FirebaseFirestore.instance;
userData()async{
  UserModel userModel;
  DocumentSnapshot value=await _firestore.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).get();
  if(value.exists){
   userModel=UserModel(
       email: value.get('email'),
       uid: value.get('uid'),
       bio: value.get('bio'),
       name: value.get('name'),
       follower: value.get('followers'),
       following: value.get('following'),
       photourl: value.get('photourl'));
   _userData=userModel;
   notifyListeners();
  }


}


 // Future<void>refreshUser()async{
 //   // UserModel userModel=await _authMethod.getUserDetail();
 //   // _userData= userModel;
 //   notifyListeners();
 // }
 UserModel get getUserData{
   return _userData!;
 }



}