import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/gloabalVariable.dart';

import '../../utils/colors.dart';
class webScreen extends StatefulWidget {
  const webScreen({Key? key}) : super(key: key);

  @override
  State<webScreen> createState() => _webScreenState();
}

class _webScreenState extends State<webScreen> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController=PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  int _page = 0;

  navigationTap(int page)
  {
    pageController.jumpToPage(page);
    setState(() {
      _page=page;
    });

  }

  onpageChange(int page){
    setState(() {
      _page=page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
          backgroundColor: webBackgroundColor,
          title: Image.asset(
            'assets/instagram.jpeg',
            height: 32,

          ),
          actions: [
            IconButton(
              onPressed: () =>navigationTap(0),
              icon: const Icon(Icons.home),
              color: _page==0?primaryColor:secondaryColor,
            ),
            IconButton(
              onPressed: ()=>navigationTap(1),
              icon: const Icon(Icons.search_rounded),
              color: _page==1?primaryColor:secondaryColor,
            ),
            IconButton(
              onPressed: () =>navigationTap(2),
              icon: const Icon(Icons.add),
              color: _page==2?primaryColor:secondaryColor,
            ),
            IconButton(
              onPressed: () =>navigationTap(3),
              icon: const Icon(Icons.favorite),
              color: _page==3?primaryColor:secondaryColor,
            ),
            IconButton(
              onPressed: () =>navigationTap(4),
              icon: const Icon(Icons.person),
              color: _page==4 ?primaryColor:secondaryColor,
            ),
          ]),
      body: PageView(
        physics: const   NeverScrollableScrollPhysics(),
        children: homeScreenItem,
        controller: pageController,
        onPageChanged: onpageChange,
      ),
    ));
  }
}
