import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/globals/themes.dart';
import 'package:flutter_instagram_clone/services/auth_services.dart';
import 'package:flutter_instagram_clone/utils/widget_utils.dart';
import 'package:flutter_instagram_clone/widgets/logo.dart';
import 'package:flutter_instagram_clone/widgets/input_text_field.dart';
import 'package:flutter_instagram_clone/widgets/loading_switch.dart';
import 'package:flutter_instagram_clone/widgets/custom_page_route.dart';
import 'package:flutter_instagram_clone/pages/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passWordController.dispose();

    super.dispose();
  }

  void loginUser() async {
    setState(() => _isLoading = true);
    AuthServices.logInUser(
      email: _emailController.text,
      password: _passWordController.text,
    ).then((value) {
      setState(() => _isLoading = false);
      showSnackBar("Login Success");
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
                    InkWell(
                      onTap: _isLoading
                          ? null
                          : () {
                              loginUser();
                            },
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
                          child: const Text("Log In"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(),
                        children: [
                          TextSpan(text: "Forgotten your login details?"),
                          TextSpan(
                            text: " Get help with logging in.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(children: const <Widget>[
                      Expanded(child: Divider()),
                      Text(" OR "),
                      Expanded(child: Divider()),
                    ]),
                    const SizedBox(height: 12),
                    InkWell(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: blueColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.facebook),
                            Text(
                              " Continue with facebook",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
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
                    const TextSpan(text: "Don't have an account?"),
                    TextSpan(
                      text: " Sign up.",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                            context,
                            CustomPageRoute.fromRight(
                              child: const SignupPage(),
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
