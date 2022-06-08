import 'package:flutter/material.dart';

class LoadingSwitch extends StatelessWidget {
  const LoadingSwitch({
    Key? key,
    required this.isLoading,
    required this.child,
    this.size = 20,
  }) : super(key: key);

  final bool isLoading;
  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: SizedBox(
              width: size,
              height: size,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          )
        : child;
  }
}
