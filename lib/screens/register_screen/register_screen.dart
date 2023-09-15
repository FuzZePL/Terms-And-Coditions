import 'package:donotnote/screens/main_screen/main_screen.dart';
import 'package:donotnote/screens/register_screen/register_widget_1.dart';
import 'package:donotnote/screens/register_screen/register_widget_2.dart';
import 'package:flutter/material.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/constant_functions.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/web/server.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register-screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _controller =
      PageController(initialPage: 0, keepPage: false);
  int _step = 0;
  String _email = '';
  String _username = '';
  String _password = '';
  String _school = '';

  void _moveToNextStep(PageController controller) {
    _step += 1;
    setState(() {});
    controller.animateToPage(
      _step,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  void _submitFirstStep(String email, String password, String userName,
      PageController controller, String school) {
    _email = email;
    _username = userName;
    _password = password;
    _school = school;
    _moveToNextStep(controller);
  }

  Future<void> _registerSuccess() async {
    ConstantFunctions.showLoadingDialog(context);
    Server.authUser(_email, _password, _username, _school, context)
        .then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final PageView pageView = PageView(
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (page) {
        _step = page;
      },
      controller: _controller,
      scrollDirection: Axis.horizontal,
      children: [
        RegisterWidget1(
          submitFirstStep: _submitFirstStep,
          ctx: context,
          controller: _controller,
        ),
        RegisterWidget2(
          submitStep2: _registerSuccess,
          email: _email,
          controller: _controller,
        ),
      ],
    );
    return Scaffold(
      backgroundColor: KColors.kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: KColors.kPrimaryColor,
        elevation: 2,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.createNewAccount,
              style: TextStyle(
                color: KColors.kTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            if (_step == 0) {
              Navigator.of(context).pop();
            } else {
              _controller.animateToPage(
                0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.ease,
              );
            }
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
          color: KColors.kWhiteColor,
        ),
      ),
      body: pageView,
    );
  }
}
