import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resourses/authentication.dart';
import 'package:instagram_clone/responsive_screen/responsive_layout.dart';
import 'package:instagram_clone/utils/image_utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';
import 'package:instagram_clone/responsive_screen/mobile_screen_layout/mobile_Screen.dart';
import 'package:instagram_clone/responsive_screen/web_screen_layout/web_Screen.dart';

class signInScreen extends StatefulWidget {
  const signInScreen({Key? key}) : super(key: key);

  @override
  State<signInScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<signInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;


  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethod().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });

    if (res == 'success') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Responsive(
          mobileScreenlayout: mobileScreen(),
          webScreenlayout: webScreen(),
        ),
      ));

    } else {
      setState(() {
        _isLoading=false;
      });
      showSnakbar(res, context);
    }
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _bioController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Image.asset(
                "assets/instagram.jpeg",
                height: 50,
              ),
              const SizedBox(
                height: 64,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(_image!),
                          // backgroundColor: Colors.red,
                          radius: 64,
                        )
                      : const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                          // backgroundColor: Colors.red,
                          radius: 64,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo_sharp,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              textFieldInput(
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  hintext: "Enter your email"),
              const SizedBox(
                height: 24,
              ),
              textFieldInput(
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                  hintext: "Enter your password"),
              const SizedBox(
                height: 24,
              ),
              textFieldInput(
                  textInputType: TextInputType.text,
                  textEditingController: _nameController,
                  hintext: "Enter your name"),
              const SizedBox(
                height: 24,
              ),
              textFieldInput(
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                  hintext: "Enter your bio"),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () {
                  if (_emailController.text.isEmpty) {
                    showSnakbar("Enter the email address", context);
                  } else if (_passwordController.text.isEmpty) {
                    showSnakbar("Enter the password", context);
                  } else if (_nameController.text.isEmpty) {
                    showSnakbar("Enter the name", context);
                  } else if (_bioController.text.isEmpty) {
                    showSnakbar("Enter the bio", context);
                  } else {
                    signUpUser();
                  }
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      )),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Sign in"),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Flexible(
                flex: 4,
                child: Container(),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       padding: const EdgeInsets.symmetric(vertical: 8),
              //       child: const Text("Don't have an account?"),
              //     ),
              //     GestureDetector(
              //       onTap: (){
              //         Navigator.push(context, MaterialPageRoute(builder: (context)=>loginScreen()));
              //       },
              //       child: Container(
              //         padding: const EdgeInsets.symmetric(vertical: 8),
              //         child: const Text(
              //           "Sign up",
              //           style: TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //       ),
              //     )
              //   ],
              // )
            ],
          ),
        ),
      ),
    ));
  }
}
