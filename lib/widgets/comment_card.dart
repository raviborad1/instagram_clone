import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class commentCard extends StatefulWidget {
  final snap;
  const commentCard({Key? key,required this.snap}) : super(key: key);

  @override
  State<commentCard> createState() => _commentCardState();
}

class _commentCardState extends State<commentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Row(

        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilepic']),
            // backgroundColor: Colors.red,
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(text: TextSpan(
                    children: [
                      TextSpan(text:'${widget.snap['name']}',style:const  TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '  ${widget.snap['comment']}')
                    ]
                  ),),
                  Padding(padding: const EdgeInsets.only(top: 4),
                  child: Text(DateFormat.yMMMd().format(widget.snap['datepublised'].toDate()),style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),),



                ],
              ),
            ),
          ),
         Container(
           padding: const EdgeInsets.all(8),
           child: const Icon(Icons.favorite),
         )
        ],
      ),
    );
  }
}
