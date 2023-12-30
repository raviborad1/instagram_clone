

class UserModel {
  final String email;
  final String uid;
  final String name;
  final String bio;
  final String photourl;
  final List follower;
  final List following;
  const UserModel(
      {required this.email,
      required this.uid,
      required this.bio,
      required this.name,
      required this.follower,
      required this.following,
      required this.photourl});
   Map<String,dynamic>toJson()=>{
      'email': email,
      'uid': uid,
      'name': name,
      'bio': bio,
      'followers': [],
      'following': [],
      'photourl': photourl,
   };
   // static UserModel userData(var snapshot){
   //
   //   return UserModel(
   //       email: snapshot.get('email'),
   //       uid: snapshot.get('uid'),
   //       bio: snapshot.get('bio'),
   //       name: snapshot.get('name'),
   //       follower: snapshot.get('followers'),
   //       following: snapshot.get('following'),
   //       photourl: snapshot.get('photourl'));
   //
   // }



}
