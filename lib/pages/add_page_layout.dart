import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/pages/add_post_page.dart';
import 'package:flutter_instagram_clone/pages/add_story_page.dart';

class AddPageLayout extends StatefulWidget {
  const AddPageLayout({
    Key? key,
    this.startingPage = 1,
  }) : super(key: key);

  final int startingPage;

  @override
  State<AddPageLayout> createState() => _AddPageLayoutState();
}

class _AddPageLayoutState extends State<AddPageLayout> {
  int _page = 1;

  @override
  void initState() {
    super.initState();

    _page = widget.startingPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              if (_page == 1) const AddPostPage(),
              if (_page == 2) const AddStoryPage(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 0,
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.black45,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        child: Text(
                          "POST",
                          style: TextStyle(
                            color: _page == 1 ? Colors.blue : Colors.white,
                          ),
                        ),
                        onPressed: () {
                          setState(() => _page = 1);
                        },
                      ),
                      TextButton(
                        child: Text(
                          "STORY",
                          style: TextStyle(
                            color: _page == 2 ? Colors.blue : Colors.white,
                          ),
                        ),
                        onPressed: () {
                          setState(() => _page = 2);
                        },
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "LIVE",
                          style: TextStyle(
                            color: _page == 3 ? Colors.blue : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
