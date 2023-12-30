import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/model/userModel.dart';
import 'package:instagram_clone/resourses/storageImage.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  // UserModel?_userModel;
  // Future<UserModel> getUserDetail() async {
  //   User currentuser = _auth.currentUser!;
  //   UserModel data;
  //   var snapshot =
  //       await _firestore.collection('user').doc(currentuser.uid).get();
  //
  //   if(snapshot.exists)
  //     {
  //       data=UserModel(
  //           email: snapshot.get('email'),
  //           uid: snapshot.get('uid'),
  //           bio: snapshot.get('bio'),
  //           name: snapshot.get('name'),
  //           follower: snapshot.get('followers'),
  //           following: snapshot.get('following'),
  //           photourl: snapshot.get('photourl'));
  //
  //     }
  //   data=_userModel!;
  //   return data;
  // }

  //sign in method
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          name.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl = await StorageMethod()
            .uploadImageToStorage(childname: 'profilepics', file: file);
        UserModel userModel = UserModel(
            email: email,
            uid: _auth.currentUser!.uid,
            bio: bio,
            name: name,
            follower: [],
            following: [],
            photourl: photoUrl);
        await _firestore
            .collection('user')
            .doc(cred.user!.uid)
            .set(userModel.toJson());
        res = 'success';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // signUp method
  Future<String> loginMethod(
      {required String email, required String password}) async {
    String res = "some error occurs";
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
