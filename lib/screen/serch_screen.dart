import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screen/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class serchScreen extends StatefulWidget {
  const serchScreen({Key? key}) : super(key: key);

  @override
  State<serchScreen> createState() => _serchScreenState();
}

class _serchScreenState extends State<serchScreen> {
  final TextEditingController _serchController = TextEditingController();
  bool _isShowuser = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _serchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: const Icon(Icons.search),
          title: TextField(
            controller: _serchController,
            decoration: const InputDecoration(
                labelText: 'Search for a User', border: InputBorder.none),
            onSubmitted: (String _) {
              setState(() {
                _isShowuser = true;
              });
            },
          ),
        ),
        body: _isShowuser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('user')
                    .where('name',
                        isGreaterThanOrEqualTo: _serchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>profileScreen(uid:(snapshot.data! as dynamic).docs[index]['uid']) ));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['photourl']),
                            ),
                            title: Text(
                                (snapshot.data! as dynamic).docs[index]['name']),
                          ),
                        );
                      });
                })
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                          (snapshot.data! as dynamic).docs[index]['posturl']);
                    },
                    staggeredTileBuilder: (index) {
                      return  const StaggeredTile.fit(1);
                      // count(
                      //     (index % 7) == 0 ? 2: 1, (index % 7) == 0 ? 2: 1);

                    },
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,

                  );
                }));
  }
}
