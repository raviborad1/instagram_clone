class PostModel{
  final String uid;
  final String name;
  final String photourl;
  final String description;
  final datepublised;
  final  likes;
  final String postId;
  final String posturl;
  const PostModel(
      {required this.datepublised,
        required this.uid,
        required this.description,
        required this.name,
        required this.photourl,
        required this.likes,
        required this.postId,
        required this.posturl,
      });
  Map<String,dynamic>toJson()=>{
    'description': description,
    'uid': uid,
    'name': name,
    'datepublised': datepublised,
    'likes':likes,
    'photourl': photourl,
    'postId':postId,
    'posturl':posturl
  };


}