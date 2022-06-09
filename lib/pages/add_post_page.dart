import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_instagram_clone/globals/themes.dart';
import 'package:flutter_instagram_clone/utils/io_utils.dart';
import 'package:flutter_instagram_clone/utils/widget_utils.dart';
import 'package:flutter_instagram_clone/services/database_services.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/widgets/loading_overlay.dart';
import 'package:flutter_instagram_clone/widgets/input_text_field.dart';
import 'package:flutter_instagram_clone/widgets/profile_bubble.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _captionController = TextEditingController();

  BoxFit _selectedImageFit = BoxFit.cover;
  Uint8List? _image;

  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();

    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _captionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _captionController.dispose();

    super.dispose();
  }

  void _selectImage() async {
    var data = await IOUtils.pickImage();
    if (data != null) {
      setState(() => _image = data);
    }
  }

  Widget imageSelector() {
    return Scaffold(
      appBar: _image != null
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: TextButton(
                style: TextButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(18),
                  backgroundColor: Colors.black54,
                  primary: Colors.white,
                ),
                child: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Select Image for Post"),
          onPressed: () {
            _selectImage();
          },
        ),
      ),
    );
  }

  void addPost() {
    LoadingOverlay.of(context).show();

    DatabaseServices.upload(
      user: _userProvider.getUser,
      image: _image!,
      description: _captionController.text,
    ).then((value) {
      LoadingOverlay.of(context).hide();
      Navigator.pop(context);
      showSnackBar("Post Added");
    }).catchError((error) {
      LoadingOverlay.of(context).hide();
      showSnackBar(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      return imageSelector();
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("New Post"),
        leading: IconButton(
          splashRadius: 1,
          icon: const Icon(
            Icons.close,
            color: blueColor,
          ),
          onPressed: () {
            setState(() => _image = null);
          },
        ),
        actions: [
          if (_image == null || _captionController.text.isNotEmpty)
            IconButton(
              splashRadius: 1,
              icon: const Icon(
                Icons.check,
                color: blueColor,
              ),
              onPressed: () {
                addPost();
              },
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    height: constraints.maxHeight / 2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_image!),
                        fit: _selectedImageFit,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white60,
                    ),
                    child: IconButton(
                      splashRadius: 25,
                      icon: Transform.rotate(
                        angle: -math.pi / 4,
                        child: const Icon(Icons.code, color: Colors.black54),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedImageFit = _selectedImageFit == BoxFit.cover
                              ? BoxFit.contain
                              : BoxFit.cover;
                        });
                      },
                    ),
                  ),
                ],
              ),
              // Write caption
              Container(
                margin: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    ProfileBubble(
                      user: _userProvider.getUser,
                      withText: false,
                      width: 45,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InputTextField(
                        textEditingController: _captionController,
                        hintText: "Write a caption...",
                        textInputType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(child: imageSelector()),
            ],
          );
        },
      ),
    );
  }
}
