import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/strings.dart';
import 'package:flutter/material.dart';

class ConstantFunctions {
  static void showSnackBar(
      BuildContext context, Color color, Color textColor, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return const Dialog(
          backgroundColor: KColors.kWhiteColor,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                CircularProgressIndicator(
                  color: KColors.kPrimaryColor,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  Strings.loading,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Gradient defaultGradient() {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        KColors.kButtonColorGreen,
        KColors.kButtonColorGreen,
      ],
    );
  }

  static Gradient secondaryGradient() {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        KColors.kButtonColorPurple,
        KColors.kButtonColorPurple,
      ],
    );
  }

  static BoxShadow defaultShadow() {
    return const BoxShadow(
      color: KColors.kPrimaryColor,
      spreadRadius: 9,
      blurRadius: 7,
      offset: Offset.zero,
    );
  }

  static BoxShadow defaultLightShadow({Offset offset = Offset.zero}) {
    return BoxShadow(
      color: KColors.kPrimaryColor,
      spreadRadius: 2,
      blurRadius: 8,
      offset: offset,
    );
  }

  static BoxShadow defaultBlackShadow({Offset offset = Offset.zero}) {
    return BoxShadow(
      color: const Color.fromARGB(255, 20, 20, 20).withOpacity(0.6),
      spreadRadius: 10,
      blurRadius: 8,
      offset: offset,
    );
  }

  static BoxShadow defaultGreenShadow() {
    return const BoxShadow(
      color: KColors.kPrimaryColor,
      spreadRadius: 2,
      blurRadius: 6,
      offset: Offset.zero,
    );
  }

  static Route createRoute(Widget page, Offset offset) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin = offset;
        const Offset end = Offset.zero;
        const Curve curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
