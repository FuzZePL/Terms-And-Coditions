import 'package:donotnote/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:donotnote/screens/login/auth_screen.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/web/server.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = '/splash';
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _checkIfLoginAndWant() {
    return Server.isLogged();
  }

  void _moveAfterToMain(BuildContext ctx) async {
    Future.delayed(const Duration(milliseconds: 2900)).then((value) {
      if (_checkIfLoginAndWant()) {
        Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _moveAfterToMain(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: KColors.kBackgroundColor,
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/icon_new.png',
              height: size.width * 0.65,
              width: size.width * 0.65,
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              Strings.appName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: KColors.kTextColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
