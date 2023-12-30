import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/model/postModel.dart';
import 'package:instagram_clone/resourses/storageImage.dart';
import 'package:uuid/uuid.dart';

class PostMethod{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  Future<String>uploadPost({required String uid,required Uint8List file ,required String description,required String name,required String photourl})async{
    String res="some error occurs";
    try{
        String posturl=await StorageMethod().uploadImageToStorage(childname: 'posts', file: file,isPost: true);
        String postId=const Uuid().v1();
         PostModel postModel=PostModel(datepublised: DateTime.now(), uid: uid, description: description, name: name, photourl: photourl,postId: postId,likes: [],posturl:posturl );
         await _firestore.collection('posts').doc(postId).set(postModel.toJson());
         res="success";
    }catch(e){
      res=e.toString();
    }
    return res;

  }
  //like post method
  Future<void>likePost({required String postId,required String uid,required List likes})
  async {
    try{
      if(likes.contains(uid))
        {
          await _firestore.collection('posts').doc(postId).update({
            'likes':FieldValue.arrayRemove([uid]),
          });
        }
      else{
        await _firestore.collection('posts').doc(postId).update({
           'likes':FieldValue.arrayUnion([uid]),
        });
      }


    }
  catch(e){
  print(e.toString());
  }

}
//messge method
Future<void>postcomment({required String comment,required String uid,required String postId,required String profilepic,required String name})
async {
  try{
    if(comment.isNotEmpty)
      {
        String commentId= const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'postId':postId,
          'profilepic':profilepic,
          'uid':uid,
          'comment':comment,
          'commentId':commentId,
          'datepublised':DateTime.now(),
          'name':name,

        });
      }

  }catch(e)
  {
    print(e.toString());
  }
}

//delet a post

Future<void>deletPost({required String postId})async{
    try{
      await _firestore.collection('posts').doc(postId).delete();

    }catch(e){
      print(e.toString());
    }

}

// follow user
Future<void>followuser({required String uid,required String followuid})
async {
  try{
    DocumentSnapshot snap=await FirebaseFirestore.instance.collection('user').doc(uid).get();
    List following=(snap.data()!as dynamic)['following'];
    if(following.contains(followuid))
      {
        await _firestore.collection('user').doc(uid).update({
          'following':FieldValue.arrayRemove([followuid]),
        });
        await _firestore.collection('user').doc(followuid).update({
          'followers':FieldValue.arrayRemove([uid]),
        });

      }
    else
      {
        await _firestore.collection('user').doc(uid).update({
          'following':FieldValue.arrayUnion([followuid]),
        });
        await _firestore.collection('user').doc(followuid).update({
          'followers':FieldValue.arrayUnion([uid]),
        });

      }


  }catch(e){
    print(e.toString());
  }
}

// update profile
Future<void>signOut()async{
    await FirebaseAuth.instance.signOut();
}




}
