import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/model/userModel.dart';
import 'package:instagram_clone/provider/userProvider.dart';
import 'package:instagram_clone/resourses/postMethod.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/image_utils.dart';
import 'package:provider/provider.dart';

class addPost extends StatefulWidget {
  const addPost({Key? key}) : super(key: key);

  @override
  State<addPost> createState() => _addPostState();
}

class _addPostState extends State<addPost> {
  Uint8List? _file;
  bool _isLosding = false;
  final TextEditingController _discriptoncontroller = TextEditingController();
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Creat Post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a Photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Select from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void postImage({
    required String uid,
    required Uint8List file,
    required String name,
    required String photourl
  }) async {
    setState(() {
      _isLosding = true;
    });
    try {
      print("inside try ${_discriptoncontroller.text}");
      String res = await PostMethod().uploadPost(
        photourl:photourl ,
          uid: uid,
          file: file,
          description: _discriptoncontroller.text,
          name: name);
      if (res == 'success') {
        setState(() {
          _isLosding = false;
        });
        showSnakbar('Posted!', context);
        closeImage();
      } else {
        setState(() {
          _isLosding = false;
        });
        showSnakbar(res, context);
      }
    } catch (e) {
      setState(() {
        _isLosding = false;
      });
      showSnakbar(" ${e.toString()}", context);
    }
  }
  void closeImage(){
    setState(() {
      _file=null;
    });
  }

  @override
  void dispose() {
    _discriptoncontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserProvider>(context).getUserData;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post to"),
        leading: IconButton(
          onPressed: closeImage,
            icon: const Icon(Icons.arrow_back)),
        actions: [
          TextButton(
            onPressed: () => postImage(
                uid: userModel.uid, file: _file!, name: userModel.name,photourl: userModel.photourl),
            child: const Text(
              "Post",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ],
        backgroundColor: mobileBackgroundColor,
      ),
      body: _file == null
          ? Center(
              child: IconButton(
                onPressed: () => _selectImage(context),
                icon: const Icon(Icons.upload),
              ),
            )
          : Column(
              children: [
                _isLosding ? const LinearProgressIndicator() : Container(),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userModel.photourl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _discriptoncontroller,
                        decoration: const InputDecoration(
                            hintText: "Write a caption....",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Colors.red,
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }
}
