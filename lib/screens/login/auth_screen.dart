import 'package:donotnote/screens/main_screen/main_screen.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/constant_functions.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/web/server.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_card.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = '/Auth-screen';
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _triesLeft = 7;
  bool _isWrong = false;
  static const int _fiveMinutes = 5 * 60 * 1000;
  static const String _lastAttemptKey = 'lastAttempt';
  static const String _lastAttemptNumber = 'lastAttemptNumber';
  Duration _timeDuration = const Duration(microseconds: 1);

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? number = prefs.getInt(_lastAttemptNumber);
    if (number != null) {
      _triesLeft = number;
    }
  }

  Future<bool> checkLogin(BuildContext ctx) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final int? lastAttempt = prefs.getInt(_lastAttemptKey);

    if (lastAttempt != null) {
      final int now = DateTime.now().millisecondsSinceEpoch;

      int difference = now - lastAttempt;

      if (difference >= _fiveMinutes) {
        prefs.remove(_lastAttemptKey);
        prefs.setInt(_lastAttemptNumber, 5);
        _triesLeft = 7;
        return true;
      } else {
        _timeDuration = Duration(milliseconds: difference);
        return false;
      }
    } else {
      return true;
    }
  }

  void _submitAuthForm(String email, String password, BuildContext ctx) {
    ConstantFunctions.showLoadingDialog(context);
    try {
      checkLogin(ctx).then((value) {
        if (value) {
          Server.login(
            email,
            password,
            context,
          ).then((value) {
            Navigator.of(context).pop();
            _onSuccess();
          }).onError((error, stackTrace) {
            Navigator.of(context).pop();
            _onError();
          });
        } else {
          ConstantFunctions.showSnackBar(
              ctx,
              KColors.kErrorColor,
              KColors.kWhiteColor,
              '${Strings.mustWait} ${5 - _timeDuration.inMinutes} min aby znowu się zalogować.');
        }
      });
    } on FirebaseAuthException catch (error) {
      ConstantFunctions.showSnackBar(ctx, KColors.kErrorColor,
          KColors.kWhiteColor, error.message.toString());
    }
  }

  void _onSuccess() async {
    await SharedPreferences.getInstance().then((value) {
      value.setInt(_lastAttemptNumber, 5);
      Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
    });
  }

  void _onError() async {
    ConstantFunctions.showSnackBar(
      context,
      KColors.kErrorColor,
      KColors.kWhiteColor,
      Strings.wrongPasswordOrEmail,
    );
    _triesLeft -= 1;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_triesLeft <= 0) {
      prefs.setInt(_lastAttemptKey, DateTime.now().millisecondsSinceEpoch);
    }
    prefs.setInt(_lastAttemptNumber, _triesLeft);

    setState(() {
      _isWrong = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.kBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: AuthCard(
        submitFn: _submitAuthForm,
        isWrong: _isWrong,
        triesLeft: _triesLeft,
      ),
    );
  }
}
