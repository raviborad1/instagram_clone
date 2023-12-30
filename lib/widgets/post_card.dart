import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/userProvider.dart';
import 'package:instagram_clone/resourses/postMethod.dart';
import 'package:instagram_clone/screen/comment_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/gloabalVariable.dart';
import 'package:instagram_clone/utils/image_utils.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class postCard extends StatefulWidget {

  final snap;
  const postCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<postCard> createState() => _postCardState();
}

class _postCardState extends State<postCard> {
  bool isLikeAnimating = false;
  int comment=0;
  @override
  void initState() {
    super.initState();
    getComment();
  }
  getComment()async{
    try{
      QuerySnapshot snap=await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();

      comment=snap.docs.length;

    }catch(e){
      showSnakbar(e.toString(), context);
    }
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserProvider>(context).getUserData;
    final width=MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color:width>webScreenSize?secondaryColor:mobileBackgroundColor),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.snap['photourl'],
                  ),
                  radius: 16,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.snap['name']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: ['Delet']
                                  .map((e) => InkWell(
                                        onTap: ()async {
                                          await PostMethod().deletPost(postId: widget.snap['postId']);
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 16),
                                          child: Text(e),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          );
                        });
                  },
                  icon: const Icon(Icons.more_vert_rounded),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await PostMethod().likePost(
                  postId: widget.snap['postId'],
                  uid: userModel.uid,
                  likes: widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['posturl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: likeAnimation(

                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              likeAnimation(
                isAnimating: widget.snap['likes'].contains(userModel.uid),
                smallLikes: true,
                child: IconButton(
                    onPressed: () async {
                      await PostMethod().likePost(
                          postId: widget.snap['postId'],
                          uid: userModel.uid,
                          likes: widget.snap['likes']);
                    },
                    icon: widget.snap['likes'].contains(userModel.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          )),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>commentScreen(uid: userModel.uid, postId:widget.snap['postId'], profiepic:userModel.photourl,name: userModel.name,)));
                  }, icon: const Icon(Icons.comment_outlined)),
              IconButton(onPressed: () {

              }, icon: const Icon(Icons.send)),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border_outlined),
                ),
              ))
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length}  likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 6),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                              text: '${widget.snap['name']}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: '  ${widget.snap['description']}'),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>commentScreen(uid: userModel.uid, postId:widget.snap['postId'], profiepic:userModel.photourl,name: userModel.name,)));
             },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child:  Text(
                      "View all $comment comment",
                      style: const TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datepublised'].toDate()),
                      style:
                          const TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
