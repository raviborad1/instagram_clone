import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/userProvider.dart';
import 'package:instagram_clone/utils/gloabalVariable.dart';
import 'package:provider/provider.dart';

class Responsive extends StatefulWidget {
  final Widget mobileScreenlayout;
  final Widget webScreenlayout;
  const Responsive(
      {Key? key,
      required this.mobileScreenlayout,
      required this.webScreenlayout})
      : super(key: key);

  @override
  State<Responsive> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> {
  @override
  void initState() {
    super.initState();
    getData();
  }
  getData()async{
    UserProvider userProvider=Provider.of(context,listen: false);
    await userProvider.userData();

  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrain) {
      return constrain.maxWidth > webScreenSize ? widget.webScreenlayout : widget.mobileScreenlayout;
    });
  }
}
