import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/globals/themes.dart';
import 'package:flutter_instagram_clone/services/auth_services.dart';
import 'package:flutter_instagram_clone/utils/io_utils.dart';
import 'package:flutter_instagram_clone/utils/widget_utils.dart';
import 'package:flutter_instagram_clone/widgets/logo.dart';
import 'package:flutter_instagram_clone/widgets/input_text_field.dart';
import 'package:flutter_instagram_clone/widgets/loading_switch.dart';
import 'package:flutter_instagram_clone/widgets/custom_page_route.dart';
import 'package:flutter_instagram_clone/pages/app_layout.dart';
import 'package:flutter_instagram_clone/pages/log_in_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isLoading = false;
  Uint8List? _profileImage;

  @override
  void dispose() {
    _userNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passWordController.dispose();
    _bioController.dispose();

    super.dispose();
  }

  void _selectImage() async {
    var data = await IOUtils.pickImage();
    if (data != null) {
      setState(() => _profileImage = data);
    }
  }

  void signUpUser() async {
    setState(() => _isLoading = true);

    AuthServices.signUpUser(
      username: _userNameController.text,
      fullname: _fullNameController.text,
      email: _emailController.text,
      password: _passWordController.text,
      bio: _bioController.text,
      imageBytes: _profileImage,
    ).then((value) {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        CustomPageRoute.fromUp(
          child: const AppLayout(),
        ),
      );
    }).catchError((error) {
      setState(() => _isLoading = false);
      showSnackBar(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const Logo(),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey,
                          backgroundImage: _profileImage == null
                              ? null
                              : MemoryImage(_profileImage!),
                        ),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: IconButton(
                            icon: const Icon(Icons.add_a_photo_outlined),
                            onPressed: () {
                              _selectImage();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    InputTextField(
                      textEditingController: _userNameController,
                      hintText: "Username",
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 24),
                    InputTextField(
                      textEditingController: _fullNameController,
                      hintText: "Fullname",
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 24),
                    InputTextField(
                      textEditingController: _emailController,
                      hintText: "Email address",
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    InputTextField(
                      textEditingController: _passWordController,
                      isPassword: true,
                      hintText: "Password",
                      textInputType: TextInputType.text,
                    ),
                    const SizedBox(height: 24),
                    InputTextField(
                      textEditingController: _bioController,
                      hintText: "Bio",
                      isMultiline: true,
                      textInputType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 24),
                    InkWell(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: blueColor,
                        ),
                        child: LoadingSwitch(
                          isLoading: _isLoading,
                          child: const Text("Sign Up"),
                        ),
                      ),
                      onTap: () {
                        signUpUser();
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              const Divider(),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: "Already have an account?"),
                    TextSpan(
                      text: " Log in.",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                            context,
                            CustomPageRoute.fromLeft(
                              child: const LoginPage(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
