import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
    this.width,
    this.color,
  }) : super(key: key);

  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/images/instagram-wordmark.svg",
      width: width ?? 200,
      color: color ?? Colors.white,
    );
  }
}
