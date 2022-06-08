import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  const InputTextField({
    Key? key,
    this.isPassword = false,
    this.isMultiline = false,
    required this.textEditingController,
    required this.hintText,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final bool isPassword;
  final bool isMultiline;
  final String hintText;
  final TextInputType textInputType;

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  bool obscureText = true;

  @override
  void initState() {
    obscureText = widget.isPassword;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final outlineBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: widget.textEditingController,
      obscureText: obscureText,
      keyboardType: widget.textInputType,
      maxLines: widget.isPassword
          ? 1
          : widget.isMultiline
              ? null
              : 1,
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        border: outlineBorder,
        focusedBorder: outlineBorder,
        enabledBorder: outlineBorder,
        contentPadding: const EdgeInsets.all(8),
        suffixIcon: widget.isPassword
            ? IconButton(
                splashRadius: 18,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                ),
                onPressed: () {
                  setState(() => obscureText = !obscureText);
                },
              )
            : null,
      ),
    );
  }
}
