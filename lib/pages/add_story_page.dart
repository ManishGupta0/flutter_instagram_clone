import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_instagram_clone/utils/io_utils.dart';
import 'package:flutter_instagram_clone/utils/widget_utils.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/services/database_services.dart';
import 'package:flutter_instagram_clone/widgets/custom_page_route.dart';
import 'package:flutter_instagram_clone/widgets/loading_overlay.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({Key? key}) : super(key: key);

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  Uint8List? _image;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  void _selectImage() async {
    var data = await IOUtils.pickImage();
    if (data != null) {
      setState(() => _image = data);
    }
  }

  void addStory() {
    LoadingOverlay.of(context).show();

    DatabaseServices.upload(
      user: _userProvider.getUser,
      image: _image!,
      description: "",
      isStory: true,
    ).then((value) {
      _userProvider.updateCurrentUser().then((value) {
        LoadingOverlay.of(context).hide();
        Navigator.pop(context);
        Navigator.pop(context);
        showSnackBar("Story Added");
      });
    }).catchError((error) {
      LoadingOverlay.of(context).hide();
      showSnackBar(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return imageSelectionStep();
  }

  Widget imageSelectionStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Stack(
            children: [
              if (_image != null)
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(_image!),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              Positioned(
                top: 12,
                right: 12,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(18),
                    backgroundColor: Colors.black54,
                    primary: Colors.white,
                  ),
                  child: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(Icons.image),
                onPressed: () {
                  _selectImage();
                },
              ),
              if (_image != null)
                TextButton(
                  style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                    backgroundColor: Colors.white,
                    primary: Colors.black,
                  ),
                  child: const Icon(Icons.chevron_right),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CustomPageRoute.fromRight(
                        child: storyPostStep(context),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget storyPostStep(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // story image
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      image: DecorationImage(
                        image: MemoryImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(8),
                            backgroundColor: Colors.black54,
                            primary: Colors.white,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Row(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                backgroundColor: Colors.black54,
                                primary: Colors.white,
                              ),
                              onPressed: () {},
                              child: const Text("Aa"),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                backgroundColor: Colors.black54,
                                primary: Colors.white,
                              ),
                              onPressed: () {},
                              child: const Icon(Icons.face),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                backgroundColor: Colors.black54,
                                primary: Colors.white,
                              ),
                              onPressed: () {},
                              child: const Icon(Icons.auto_awesome),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                backgroundColor: Colors.black54,
                                primary: Colors.white,
                              ),
                              onPressed: () {},
                              child: const Icon(Icons.more_horiz),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.account_circle),
                      label: const Text("Your Story"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white12,
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.stars, color: Colors.green),
                      label: const Text("Close Friends"),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white12,
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.white,
                      primary: Colors.black,
                    ),
                    child: const Icon(Icons.check),
                    onPressed: () {
                      addStory();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
