import 'package:flutter/material.dart';

class KColors {
  static const Color kPrimaryColor = Color.fromARGB(255, 43, 43, 43);
  static const Color kSecondaryColor = Color.fromARGB(255, 0, 0, 0);
  static const Color kBackgroundColor = Color.fromARGB(255, 59, 59, 59);
  static const Color kTextColor = Color.fromARGB(255, 216, 216, 216);
  static const Color kButtonColorPurple = Color.fromARGB(255, 167, 93, 225);
  static const Color kButtonColorBlue = Color.fromARGB(255, 45, 146, 239);
  static const Color kButtonColorGreen = Color.fromARGB(255, 26, 186, 141);
  static const Color kButtonColorYellow = Color.fromARGB(255, 234, 181, 30);
  static const Color kShadowColor = Color.fromARGB(255, 102, 102, 102);
  static const Color kWhiteColor = Colors.white;
  static const Color kBlackColor = Colors.black;
  static const Color kErrorColor = Colors.red;
  static const Color kTextFieldColor = Color.fromARGB(255, 102, 102, 102);
  static const Color kHintColor = Color.fromARGB(255, 20, 20, 20);

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 81, 81, 83),
      Color.fromARGB(255, 150, 146, 146),
      Color.fromARGB(255, 77, 77, 80),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
}
